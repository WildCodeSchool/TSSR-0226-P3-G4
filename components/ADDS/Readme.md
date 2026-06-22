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
- Serveurs :
     - XTSE-410
             - (172.16.64.2)  et XTSE-412 (172.16.64.16) VLAN_X avec IP statique.  
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

**WindowsCore** Backup
- Au moins 4 vCPU / 4 Go RAM
- Stockage : 50 Go minimum
 
# 4. Fonctionnalités
