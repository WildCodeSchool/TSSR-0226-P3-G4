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

   <img width="1440" height="213" alt="Capture d&#39;écran 2026-07-01 213751" src="https://github.com/user-attachments/assets/3f0e9a82-fc48-4050-9c8e-2a30001f66f4" />

---

Le statut nominal attendu doit être explicitement Healthy pour l'intégralité des disques physiques et des partitions.

---

### Environnement Serveur Backup Linux (RAID5 + LVM)

Pour s'assurer du bon fonctionnement de la matrice de sauvegarde sur le serveur Debian 13, exécutez les diagnostics suivants :   

Vérification de la grappe RAID au niveau du noyau   

`cat /proc/mdstat`   

<img width="1902" height="235" alt="Capture d&#39;écran 2026-07-01 214113" src="https://github.com/user-attachments/assets/2af3f15d-6025-44fd-bfee-8341dabd8424" />


---

Le tableau doit afficher la mention [UUUU]. Chaque U valide la synchronisation parfaite de l'un des 4 disques.

