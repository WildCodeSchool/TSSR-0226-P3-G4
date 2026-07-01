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
