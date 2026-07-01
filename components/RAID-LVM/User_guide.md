# Guide Utilisateur & Plan de Maintenance : RAID & LVM

Ce guide détaille les procédures d'exploitation du stockage de l'infrastructure XenTech, la surveillance de l'état de santé des disques sous Windows et Linux, ainsi que la conduite à tenir en cas de panne matérielle d'une unité de stockage.

---

## 1. Procédures de Vérification du Fonctionnement (Statut Nominal)

L'administrateur système doit valider périodiquement la résilience des grappes pour s'assurer qu'aucun disque n'est dégradé.

### Environnement Windows Server (RAID1)
Pour contrôler l'état de santé des disques miroirs sans ouvrir l'interface graphique :
1. Ouvrez une invite PowerShell en tant qu'administrateur.
2. Exécutez les commandes suivantes :
   ```powershell
   Get-Volume
   Get-PhysicalDisk | Select FriendlyName, HealthStatus, OperationalStatus
   ```

  <img width="1436" height="213" alt="Capture d&#39;écran 2026-07-01 213751" src="https://github.com/user-attachments/assets/76f982e1-ec8e-4a05-8d5a-8e6d3bf185bd" />


---

Le statut nominal attendu doit être explicitement `Healthy` pour l'intégralité des disques physiques et des partitions.

---

### Environnement Serveur Backup Linux (RAID5 + LVM)

Pour s'assurer du bon fonctionnement de la matrice de sauvegarde sur le serveur Debian 13, exécutez les diagnostics suivants :   

Vérification de la grappe RAID au niveau du noyau   

`cat /proc/mdstat`   

<img width="1902" height="235" alt="Capture d&#39;écran 2026-07-01 214113" src="https://github.com/user-attachments/assets/2af3f15d-6025-44fd-bfee-8341dabd8424" />


---

Le tableau doit afficher la mention [UUUU]. Chaque U valide la synchronisation parfaite de l'un des 4 disques.

Audit approfondi du démon mdadm    

`df -h /mnt/BKP`

<img width="1897" height="123" alt="image" src="https://github.com/user-attachments/assets/3daae810-0226-405a-b4a9-b4c03a2e8b37" />

---

Vérifiez que l'utilisation du point de montage /mnt/BKP laisse suffisamment d'espace pour l'écriture quotidienne des archives par Rsync.   

---

## Plan de Contingence & Remplacement (Procédure de Rollback en cas de Panne)

Cas n°1 : Perte d'un disque sur le RAID1 Windows   

Si un disque IDE lâche sur Proxmox, le Gestionnaire de disques Windows affiche le volume en mode Dégradé.   

Procédure de rétablissement :    

Éteignez proprement la VM Windows concernée.

<img width="1894" height="1141" alt="Capture d&#39;écran 2026-07-01 214840" src="https://github.com/user-attachments/assets/ebebb39d-5c3f-48dc-8f35-ce9c8c42410f" />

---


Dans Proxmox (Hardware), supprimez le disque virtuel défectueux et ajoutez un nouveau disque dur IDE de taille strictement identique.

<img width="1304" height="526" alt="Capture d&#39;écran 2026-07-01 215006" src="https://github.com/user-attachments/assets/de601eca-ea80-4b34-83b1-1f72298c6a79" />

---


Démarrez la VM, puis ouvrez le Gestionnaire de disques.

<img width="1909" height="1098" alt="image" src="https://github.com/user-attachments/assets/cb8e58f0-3e5f-4bd5-b5ef-4388929a4e2c" />

---


Faites un clic droit sur le nouveau disque → Initialiser le disque (GPT), puis convertissez-le en Disque dynamique.

Faites un clic droit sur le volume en miroir existant qui est dégradé, sélectionnez Ajouter un miroir..., et choisissez le nouveau disque.

Le système passe en statut Resynching : la réplication se fait en tâche de fond. Le volume reste pleinement disponible.





