# Active Directory Domain Services  
## Sommaire  
1. [Rôle du service](#1-Rôle-du-service)
2. [Position dans l'architecture](#2-Position-dans-l'architecture)
3. [Prérequis](#3-Prérequis)
4. [Fonctionnalités](#4-Fonctionnalités)
 
# 1. Rôle du service
Active Directory est le cœur de l'authentification et de la gestion centralisée des identités et des ressources de notre entreprise XENTECH.  
Son rôle principal est de permettre :
- Une gestion centralisée : au lieu de créer un compte sur chaque machine, l'administrateur gère tout depuis un seul endroit.
- L'AD assure aussi l'authentification (vérifier l'identité d'un utilisateur quand il se connecte) et l'autorisation (définir ce à quoi il a droit).
- Il permet egalement d'appliquer des règles communes à tout le parc grâce aux stratégies de groupe (GPO) : par exemple imposer un mot de passe complexe, connecter automatiquement un lecteur réseau ou bloquer certaines actions.

# 2. Position dans l'architecture
- Serveur Principal (GUI) :
     - Nom : XTSE-410
     - Adresse IP : 172.16.64.2/24
     - Gateway : 172.16.64.254
- Serveur Secondaire (CORE):
     - Nom XTSE-412
     - Adresse IP : 172.16.64.16/24
     - Gateway : 172.16.64.254
- Redondance : 2 contrôleurs de domaine. 1 principal Windows Server 2022 et 1 Core en backup.  
- Site AD : un site principal (Paris) pour le moement avec possibilité d'ajouter des sites distants dans le futur.  

# 3. Prérequis
- Un serveur sous Windows Server qui jouera le rôle de contrôleur de domaine. Ici on utilise un Windows Server 2022.
- Une adresse IP fixe sur ce serveur (jamais en dynamique).
- Un DNS fonctionnel, car l'AD en dépend totalement : c'est lui qui permet aux clients de retrouver le contrôleur de domaine. En général, le rôle DNS est installé sur le même serveur que l'AD.
- Un nom de domaine défini (ex. xtech.green) choisi avant l'installation.
- Le serveur pointant sur lui-même comme serveur DNS préféré.
- Des ressources suffisantes et un nom de machine correct avant la promotion en contrôleur de domaine.
- Côté postes clients : être sur le même réseau, avoir le bon serveur DNS renseigné (celui de l'AD) pour pouvoir rejoindre le domaine.
 
# 4. Fonctionnalités


# Service d'Annuaire, Gouvernance & Fichiers (AD DS / DNS / DHCP / GPO)

## Présentation du Service
Ce dossier regroupe l'architecture du cœur de l'infrastructure XenTech. L'annuaire Active Directory centralise l'authentification des 218 collaborateurs, la configuration dynamique du réseau (DNS/DHCP), ainsi que la gouvernance des accès au serveur de fichiers via l'application de stratégies de groupe (GPO).

L'infrastructure est hautement disponible et durcie gràce à la répartition des rôles FSMO sur 4 Contrôleurs de Domaine (DC), combinant des interfaces graphiques et des serveurs en mode Core.

## Architecture des Contrôleurs de Domaine (DC)
* **DC-1 (GUI — Principal) :** `172.16.65.3` | Détient les rôles de niveau forêt (**Contrôleur de Schéma**, **Maître de Nomination de Domaines**).
* **DC-2 (Server Core) :** `172.16.65.4` | Détient les rôles **Émulateur PDC**.
* **DC-3 (Server Core) :** `172.16.65.5` | Détient le rôle **Maître RID**.
* **DC-4 (GUI — WDS) :** `172.16.65.6` | Détient le rôle **Maître d'Infrastructure**

## Structure de la Documentation
* [Guide d'Installation (`Install.md`)](./Install.md) : Déploiement via scripts, promotion des serveurs Core et configuration des étendues DHCP.
* [Guide d'Utilisation (`User_guide.md`)](./User_guide.md) : Gestion de la structure des OUs, application de la stratégie AGDLP, droits NTFS/ABE et GPO de mappage de lecteurs.
* [Foire Aux Questions (`FAQ.md`)](./FAQ.md) : Résolution des problèmes de réplication, transfert de rôles FSMO, et résolution du bug de certificat LDAPS pour iRedMail.
