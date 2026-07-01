#### Cette documentation détaille la mise en place du stockage avancé de l'entreprise **XTech** : RAID1 sur les serveurs Windows, et RAID5 logiciel + LVM sur le serveur BACKUP Linux.

--------

## Vue d'ensemble

| Serveur                         | Type de disque Proxmox | RAID                          | Outil                  |
| ---------------------------------- | ------------------------- | -------------------------------- | -------------------------- |
| Serveurs Windows (AD, XTS-417, etc.) | IDE                         | RAID1 (miroir)                     | Gestionnaire de disques Windows / mdadm si Linux |
| Serveur BKP Linux (VLAN BACKUP)       | SCSI                        | RAID5 logiciel, 4 disques de 15 Go   | `mdadm` + LVM (`pvcreate`/`vgcreate`/`lvcreate`) |

> Le choix du type de disque virtuel (IDE pour Windows, SCSI pour Linux) reflète la configuration Proxmox existante de votre infrastructure : SCSI offre de meilleures performances et est privilégié pour les charges Linux/serveur, IDE reste utilisé ici pour les VM Windows.

---

## PARTIE A — RAID1 sur les serveurs Windows

### A1 — Ajout des disques virtuels sur Proxmox

Pour chaque VM Windows nécessitant un RAID1 (ex : AD, XTS-417) :

**Proxmox → VM → Hardware → Add → Hard Disk** :

- Bus/Device : `IDE 0`, `IDE 1` (deux disques de taille identique, ex. 100 Go chacun)
- Storage : datastore Proxmox de votre choix
- Format : `qcow2` 

<img width="647" height="249" alt="image" src="https://github.com/user-attachments/assets/07570214-72a9-40e7-9a85-107a706b24fb" />

------


### A2 — Configuration du RAID1 dans Windows (Gestionnaire de disques)

Dans la VM Windows :

1. **Gestion de l'ordinateur → Gestion des disques**
2. Les deux nouveaux disques IDE apparaissent comme "Non initialisé" → clic droit → **Initialiser le disque** (GPT recommandé)
3. Clic droit sur l'un des deux disques → **Convertir en disque dynamique** (pré-requis Windows pour le RAID logiciel natif)
4. Clic droit sur l'espace non alloué du premier disque dynamique → **Nouveau volume en miroir...**
5. Sélectionner le second disque comme miroir
6. Assigner une lettre de lecteur, formater en NTFS

<img width="1887" height="503" alt="RAID-1a" src="https://github.com/user-attachments/assets/6bb51944-ee8d-4c2b-bb80-c6baf823016a" />

-----

<img width="490" height="464" alt="RAID-1b" src="https://github.com/user-attachments/assets/276ea787-634f-4388-8cc7-f26944cb0bd0" />

---------

<img width="1894" height="655" alt="RAID-1" src="https://github.com/user-attachments/assets/d2b03d0d-f445-458f-9251-d2446c056d7c" />



### A3 — Vérification

```powershell
Get-Volume
Get-PhysicalDisk | Select FriendlyName, HealthStatus, OperationalStatus
```

→ les deux disques doivent apparaître `Healthy`, et le volume en miroir doit être listé avec son statut "Resynching" (à la création) puis "Healthy" une fois la synchronisation initiale terminée.

<img width="824" height="263" alt="image" src="https://github.com/user-attachments/assets/6afe537d-25b6-496f-9cf2-216fdeafc8d4" />


### A4 — Test de tolérance de panne (à faire en environnement de test, pas en production)

Retirer un des deux disques virtuels depuis Proxmox (à VM éteinte, pour simuler une panne disque) → redémarrer la VM → le volume miroir doit rester accessible en lecture/écriture en mode dégradé, avec une alerte visible dans le Gestionnaire de disques signalant le disque manquant.

---

## PARTIE B — RAID5 logiciel + LVM sur le serveur BKP Linux

### B1 — Ajout des 4 disques virtuels sur Proxmox

**Proxmox → VM (serveur BKP Linux) → Hardware → Add → Hard Disk**, répété 4 fois :

- Bus/Device : `SCSI 1`, `SCSI 2`, `SCSI 3`, `SCSI 4`
- Taille : `15G` chacun (soit 60 Go bruts, ~45 Go utiles en RAID5 — un disque équivalent sert à la parité)
- Storage : datastore Proxmox

### B2 — Identification des disques côté Linux

```bash
lsblk
```

→ les 4 nouveaux disques doivent apparaître, typiquement `/dev/sdb`, `/dev/sdc`, `/dev/sdd`, `/dev/sde` (à adapter selon votre nommage réel).

### B3 — Création du RAID5 avec mdadm

```bash
apt update
apt install mdadm -y
```

```bash
mdadm --create --verbose /dev/md0 --level=5 --raid-devices=4 /dev/sdb /dev/sdc /dev/sdd /dev/sde
```
<img width="1914" height="1137" alt="RAID-5" src="https://github.com/user-attachments/assets/0285fca0-e1ac-43b1-a937-9975d4d71e75" />

Suivi de la construction initiale (peut prendre du temps selon la taille) :

```bash
cat /proc/mdstat
```
<img width="1916" height="197" alt="cat-proc-mdstat" src="https://github.com/user-attachments/assets/2c65874e-c55a-4613-9c8a-87d43fe258b1" />

### B4 — Sauvegarde de la configuration mdadm (indispensable pour la persistance au reboot)

```bash
mdadm --detail /dev/md0
```
<img width="1911" height="820" alt="mdadm-detail" src="https://github.com/user-attachments/assets/9408a0bb-31ef-4d26-8a40-a0bdcbf20d59" />


```bash
mdadm --detail --scan >> /etc/mdadm/mdadm.conf
update-initramfs -u (pour éviter de perdre md0 et passer en md127 !)
```

<img width="1921" height="1204" alt="mdadm conf" src="https://github.com/user-attachments/assets/70aa9fee-f7ad-4063-bb91-197291f049ea" />


### B5 — Création du Volume Group et Logical Volume (LVM)

```bash
apt install lvm2 -y
pvcreate /dev/md0
vgcreate mvg_bkp /dev/md0
```
<img width="1012" height="561" alt="vgcreate" src="https://github.com/user-attachments/assets/e8c96265-0340-410e-a880-0b1f6daece88" />

Vérification :

```bash
pvdisplay
vgdisplay
```

<img width="957" height="312" alt="image" src="https://github.com/user-attachments/assets/76ac8009-9f2b-4064-bdd4-a795978d1c3f" />

----

<img width="961" height="519" alt="image" src="https://github.com/user-attachments/assets/b80f3194-df65-45e7-9e57-bccd3160edc5" />



Création du volume logique dédié à la sauvegarde :

```bash
lvcreate -n lv_bkp -L 45G mvg_BKP
```

> Le Volume Group `vg_backup` dispose d'environ 45 Go utiles ; réserver 40 Go au LV Veeam laisse une marge pour un éventuel second LV (ex : sauvegarde GLPI en complément du mysqldump, ou extension future via `lvextend` sans avoir à tout recréer).

### B6 — Formatage et montage

```bash
mkfs.ext4 /dev/vg_backup/lv_veeam
mkdir -p /mnt/lv_veeam
mount /dev/vg_backup/lv_veeam /mnt/lv_veeam
```

Montage persistant au démarrage, dans `/etc/fstab` :

```
/dev/mapper/vg_bkp-lv_bkp   /mnt/BKP   ext4   defaults   0   0
mount -a
df -h
```
<img width="1921" height="1200" alt="image" src="https://github.com/user-attachments/assets/2c1e269a-de56-4ea5-8042-c6eb340c85b1" />

-----

<img width="1267" height="346" alt="image" src="https://github.com/user-attachments/assets/b0b26229-e069-4261-8cfe-996b2ced0cb5" />


### B7 — Vérification finale du RAID5 + LVM

```bash
df -h /mnt/BKP
mdadm --detail /dev/md0
```
<img width="1911" height="820" alt="mdadm-detail" src="https://github.com/user-attachments/assets/39f474c5-7a20-4da3-98b2-d382fdd6be4c" />

---------

→ `mdadm --detail` doit afficher `State : clean`, les 4 disques en `active sync`, et aucun disque marqué `faulty` ou `removed`.

### B8 — Test de tolérance de panne RAID5

Simuler la défaillance d'un disque (à faire en test, pas en production active) :

```bash
mdadm --manage /dev/md0 --fail /dev/sdc
cat /proc/mdstat
```

→ le tableau doit passer en mode dégradé (`[U_UU]` ou équivalent selon la position du disque en panne) mais rester **accessible en lecture/écriture**, confirmant la tolérance de panne RAID5 à un disque.

Remplacement du disque simulé :

```bash
mdadm --manage /dev/md0 --remove /dev/sdc
# après ajout d'un nouveau disque virtuel sur Proxmox, par exemple /dev/sdf
mdadm --manage /dev/md0 --add /dev/sdf
cat /proc/mdstat
```

→ la reconstruction (`resync`/`recovery`) doit démarrer automatiquement et le tableau revenir à l'état `clean` une fois terminée.

---

## PARTIE C — Vérification finale globale

1. Sur chaque serveur Windows concerné (A) : `Get-PhysicalDisk` → tous les disques `Healthy`.
2. Sur le serveur BKP Linux (B) : `mdadm --detail /dev/md0` → état `clean`, 4 disques actifs.
3. `df -h` sur le serveur BKP Linux → le point de montage `/mnt/BKP` doit afficher l'espace utilisé/disponible cohérent avec les 40 Go alloués.
4. Vérifier que le job Veeam (cf. doc dédiée) écrit bien ses sauvegardes dans ce volume sans erreur d'espace disque insuffisant.

