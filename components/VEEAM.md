#### Cette documentation détaille la mise en place de **Veeam Backup & Replication** pour l'entreprise **XTech**, sauvegardant le serveur de fichiers XTS-417 et les autres VM de l'infrastructure vers le VLAN BACKUP.

--------

## Vue d'ensemble

| Élément              | Détail                                                              |
| ---------------------- | -------------------------------------------------------------------- |
| Serveur Veeam            | VLAN 30 — BACKUP, `172.16.67.0/24`                                       |
| Périmètre sauvegardé      | XTS-417 (fichiers I/J/K), AD, autres VM/CT de l'infrastructure             |
| Destination stockage        | RAID5 logiciel (mdadm) + LVM sur le serveur BKP Linux (cf. doc stockage)     |
| Méthode                     | Job de sauvegarde planifié, type dépend de la cible (fichiers vs VM complète)|

---

## PARTIE A — Installation de Veeam Backup & Replication

### A1 — Pré-requis serveur

- VM Windows Server (2019/2022), VLAN 30 — BACKUP
- IP statique : `172.16.67.20/24`
- Passerelle : `172.16.67.254`
- VLAN Tag sur l'interface réseau (Proxmox) : `30`
- Espace disque suffisant pour le repository de sauvegarde, ou montage vers le stockage RAID5+LVM du serveur BKP Linux (cf. PARTIE D)

### A2 — Installation

1. Installer les rôles Windows pré-requis (.NET Framework, le cas échéant selon la version de Veeam choisie).
2. Lancer l'installeur Veeam Backup & Replication, choisir "All-in-one" pour une installation simple (serveur de sauvegarde + console + proxy + repository sur la même machine, suffisant pour la taille actuelle de l'infrastructure).
3. Configurer le compte de service Veeam (compte AD dédié recommandé, ex : `svc-veeam`, avec droits suffisants sur les machines à sauvegarder).

### A3 — Connexion à l'hyperviseur Proxmox

Veeam Backup & Replication ne supporte nativement Proxmox que depuis les versions récentes (Veeam Backup for Proxmox VE, produit dédié ou plugin selon la version). Ajouter le serveur Proxmox comme infrastructure managée :

**Inventory → Add server → Proxmox VE** :

- Adresse : IP de l'hôte Proxmox sur le VLAN MGMT (`172.16.64.x`)
- Identifiants : compte API Proxmox dédié à la sauvegarde (à créer côté Proxmox avec droits `PVEVMAdmin` au minimum)

### A4 — Règle pare-feu nécessaire (BACKUP → MGMT)

Le serveur Veeam (BACKUP) doit atteindre l'hôte Proxmox (MGMT) pour orchestrer les sauvegardes de VM. Aucune règle existante ne couvre ce sens (les règles actuelles ne traitent que Bastion/Jump → autres VLAN, pas BACKUP → MGMT) :

- Pass : Source `172.16.67.0/24` (BACKUP) → Destination `172.16.64.x` (hôte Proxmox) port `8006` (API Proxmox HTTPS)

---

## PARTIE B — Job de sauvegarde fichiers : XTS-417

### B1 — Création du job

**Home → Backup Job → Windows Computer** (ou "File share" si vous sauvegardez le partage SMB directement plutôt que le serveur complet) :

- Name : `Backup-XTS417-Fichiers`
- Cible : XTS-417 (`172.16.66.x`), ajouté en tant que "Managed server" avec un compte ayant les droits d'accès aux partages `Partage_individuel`, `Partage_service`, `Partage_departement`
- Backup mode : "Entire computer" si vous voulez une image complète restaurable, ou "File level backup" si vous voulez cibler uniquement les dossiers partagés (plus rapide, suffisant pour la simple restauration de fichiers)

### B2 — Planification

**Schedule** : quotidien, ex. `22:00`, avec rétention `14 restore points` (2 semaines d'historique).

### B3 — Destination du job

Repository pointant vers le stockage RAID5+LVM du serveur BKP Linux (cf. PARTIE D pour le détail du montage), monté en tant que partage SMB ou NFS exposé par ce serveur et ajouté comme repository Veeam :

**Backup Infrastructure → Backup Repositories → Add Repository → Shared folder** :

- UNC Path : `\\172.16.67.10\veeam-repo`
- Identifiants d'accès au partage

### B4 — Règle pare-feu nécessaire (BACKUP interne)

Le serveur Veeam et le serveur BKP Linux RAID5 sont tous deux sur le VLAN BACKUP (`172.16.67.0/24`) — trafic intra-VLAN, non filtré par défaut par pfSense (le filtrage ne s'applique qu'inter-VLAN). Vérifier simplement que le partage SMB est bien exposé et accessible localement sur ce VLAN.

---

## PARTIE C — Job de sauvegarde des autres VM (AD, Apache, etc.)

### C1 — Création du job VM

**Home → Backup Job → Virtual Machine** :

- Name : `Backup-VM-Infra-XTech`
- Sélectionner les VM/CT à inclure : AD, WEB-INT, WEB-EXT, GLPI, Zabbix, syslog-ng/iRedMail (selon votre politique de rétention souhaitée — toutes les VM critiques de production)
- Backup mode : "Incremental" avec point de synthèse hebdomadaire (réduit la charge réseau quotidienne par rapport à une sauvegarde complète chaque nuit)

### C2 — Planification

Quotidien, décalé par rapport au job XTS-417 pour ne pas saturer le lien réseau au même instant, ex. `23:00`.

### C3 — Destination

Même repository que B3 (`\\172.16.67.10\veeam-repo`), ou un repository distinct si vous souhaitez séparer la rétention fichiers / rétention VM complètes.

---

## PARTIE D — Stockage cible : RAID5 logiciel + LVM sur le serveur BKP Linux

> Cf. document dédié "Stockage avancé LVM/RAID" pour le détail complet de la configuration `mdadm` + `pvcreate`/`vgcreate`/`lvcreate`. Résumé ici pour le contexte Veeam :

- 4 disques de 15 Go en RAID5 logiciel (`mdadm`), soit une capacité utile d'environ 45 Go (3 disques de données utiles sur 4, le 4ᵉ servant à la parité).
- Volume Group LVM créé sur le RAID (`vgcreate vg_backup /dev/md0`), puis Logical Volume dédié à Veeam (`lvcreate -n lv_veeam -L 40G vg_backup`).
- Le volume logique est formaté et monté, puis exposé en partage SMB (`veeam-repo`) consommé par Veeam comme repository (B3).

### D1 — Activation du partage SMB sur le serveur BKP Linux

```bash
apt install samba -y
```

Fichier `/etc/samba/smb.conf`, section ajoutée :

```ini
[veeam-repo]
   path = /mnt/lv_veeam
   browsable = yes
   read only = no
   guest ok = no
   valid users = svc-veeam
```

```bash
smbpasswd -a svc-veeam
systemctl restart smbd
```

---

## PARTIE E — Vérification finale

1. Lancer manuellement le job `Backup-XTS417-Fichiers` (clic droit → **Start**) → vérifier dans la console Veeam que le statut final est `Success`.
2. Lancer manuellement le job `Backup-VM-Infra-XTech` → même vérification.
3. Vérifier la présence des fichiers de sauvegarde sur le repository :
   ```bash
   ls -la /mnt/lv_veeam/
   ```
4. Test de restauration partielle (au moins un fichier depuis le job XTS-417, via **Restore → File level restore** dans la console Veeam) pour confirmer que la sauvegarde n'est pas seulement présente mais réellement exploitable.
5. Pour une preuve continue et automatisée du bon déroulement de ces jobs (plutôt qu'une vérification manuelle), faire écrire le statut de fin de job vers `C:\Logs\veeam-status.log` (script post-job) puis surveiller cette chaîne depuis Zabbix/PRTG — méthode déjà détaillée dans le document de journalisation syslog-ng, PARTIE E3.
