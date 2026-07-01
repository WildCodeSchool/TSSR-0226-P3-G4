## Composant Stockage avancé - RAID1 (Windows) RAID5 + LVM (Linux)

Ce dossier rassemble l'ensemble des ressources, scripts et documentations techniques liés à la mise en place de la politique de stockage avancée de l'infrastructure **XenTech**.

L'architecture est scindée en deux topologies distinctes afin de sécuriser à la fois les serveurs de production Windows et le serveur centralisé de sauvegardes :
1. **RAID1 (Miroir matériel/logiciel) :** Sécurisation des serveurs clés sous Windows Server 2022 (Active Directory, XTS-417, etc.) face à la perte d'un disque système ou de données.
2. **RAID5 Logiciel + LVM :** Déploiement d'un grand espace résilient et extensible de 45 Go utiles sur le serveur de backup Linux (**Debian 13**) pour stocker les Base de données GLPI, les archives d'infrastructure et les configurations.

---

## Organisation de la Documentation

Cliquez sur les liens ci-dessous pour accéder directement aux guides associés :

* **[Guide d'Installation & Configuration](./Install.md)** : Étapes pas-à-pas pour l'allocation des disques sur Proxmox, l'initialisation des volumes dynamiques sous Windows, l'assemblage de la matrice `mdadm` sous Debian 13 et la configuration des couches logiques LVM.
* **[Guide Utilisateur & Maintenance](./User_guide.md)** : Procédures de surveillance courante de l'espace, commandes de diagnostic des disques avec PowerShell et la CLI Linux, ainsi que les plans d'urgence stricts pour remplacer un disque en panne sans perte de données.
* **[FAQ](./FAQ.md)**

---

## Matrice d'Architecture des Volumes

| Serveur / Rôle | Type Disque Proxmox | Topologie RAID | Outils & Couches logiques | Point de montage / Cible |
| :--- | :--- | :--- | :--- | :--- |
| **VMs Windows** (AD, XTS-417) | **IDE** (2 disques identiques) | **RAID1** (Miroir) | Gestionnaire de disques Windows (Disques Dynamiques) | Lettre de volume NTFS unique |
| **Serveur BKP Linux** (VLAN Backup) | **SCSI** (4 disques de 15 Go) | **RAID5** (Tolérance à 1 panne) | `mdadm` + LVM (`pvcreate`, `vgcreate`, `lvcreate`) | Volume Ext4 sur `/mnt/BKP` |

---

<img width="1895" height="922" alt="image" src="https://github.com/user-attachments/assets/67a76b52-a306-44cf-851b-a6fe549a3451" />

---


