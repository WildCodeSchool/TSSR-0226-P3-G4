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


# Module : Services de Gestion des Identités, de la Sécurité Globale et du Serveur de Fichiers

## 1. Présentation Technique Générale
Ce module documente le socle de sécurité, d'identité et de gouvernance du système d'information de l'entreprise Xtech.green. L'infrastructure est conçue pour centraliser l'authentification des 218 collaborateurs, assurer la résolution de noms de l'ensemble des serveurs du domaine, distribuer dynamiquement les configurations IP aux postes clients, et assurer le cloisonnement strict des accès aux données du serveur de fichiers. 

L'architecture applique les principes de durcissement (Hardening) et d'isolation des privilèges recommandés par l'ANSSI afin de limiter l'exposition face aux menaces d'élévation de privilèges ou de mouvements latéraux.

## 2. Piliers d'Architecture et de Sécurité
* **Industrialisation et Automatisation :** Provisionner l'arborescence Active Directory, les Unités d'Organisation, les groupes de sécurité et les comptes utilisateurs de manière standardisée par l'exécution de la suite de scripts `hello my dir`.
* **Modèle de Privilèges Tiering (Tier 0) :** Séparer de façon étanche les droits d'administration. Positionner le contrôleur de domaine principal `xts-411` dans l'espace de confiance maximal Tier 0. Interdire aux identifiants de ce niveau tout droit de session sur le Tier 1 (serveurs applicatifs) ou le Tier 2 (postes de travail).
* **Isolation Réseau et Accès par Rebond (Bastion) :** Isoler le serveur `xts-411` au sein de son propre réseau local virtuel (VLAN). Bloquer les communications directes depuis les segments utilisateurs standard via le pare-feu pfSense. Effectuer l'administration exclusivement via la passerelle de rebond sécurisée HTTPS Apache Guacamole, depuis des postes de gestion validés.
* **Centralisation des Logs (Serveur Syslog) :** Collecter et rediriger en continu vers un serveur Syslog dédié l'intégralité des événements de sécurité et d'audit provenant de tous les serveurs du parc (infrastructures Windows Server Core, serveurs graphiques, et machines de production Linux) pour garantir la traçabilité et l'inviolabilité des journaux.
* **Résilience de l'Infrastructure d'Identité :** Planifier la sauvegarde et la continuité d'activité par la mise en œuvre d'une routine de clonage hebdomadaire intégrale de la machine virtuelle du contrôleur de domaine.
* **Interconnexion d'Entreprise :** Établir une relation de confiance (Trust Relationship) inter-forêts pour permettre l'accès contrôlé aux ressources partagées avec une entité partenaire externe.

## 3. Structure de la Documentation du Module
Accéder aux différents volets de la documentation technique via les liens ci-dessous :

* **[Guide d'Installation et de Déploiement](./Install.md)**
* **[Guide d'Exploitation et de Gouvernance](./User_guide.md)**
* **[Guide de Résolution des Incidents](./FAQ.md)**
