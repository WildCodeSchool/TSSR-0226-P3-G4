# Serveur Active Directory 
**Gestion des Identités et de la Sécurité Globale.**

## 1. Description du Service
Le système d'identité du domaine `Xtech.green` s'appuie sur une infrastructure distribuée de 4 Contrôleurs de Domaine (DC). Ce service centralise l'authentification des 218 collaborateurs, applique les stratégies de groupe (GPO) pour le durcissement du parc, assure la résolution DNS pour l'intégralité des serveurs de production, et distribue la configuration IP dynamique (DHCP) aux postes clients.

L'architecture applique les principes de durcissement selon les recommandations de l'ANSSI, un cloisonnement des privilèges par niveaux (Tiering), ainsi qu'une interconnexion sécurisée par relation de confiance avec une entité partenaire externe.

## 2. Caractéristiques Techniques et Topologie des Contrôleurs de Domaine

### 2.1. DC Principal : `xts-411.xtech.green` (Tier 0)
* **Système d'Exploitation :** Windows Server 2022 Standard 
* **Adresse IP :** `172.16.64.3/24` (Passerelle : `172.16.64.254`)
* **Positionnement Réseau :** Isolé dans un réseau local virtuel (VLAN) dédié à l'Active Directory.
* **Services Hébergés :** AD DS, Serveur DNS, Serveur DHCP (Distribution Postes Clients).
* **Rôles FSMO Détenus (Niveau Forêt) :** Contrôleur de Schéma (Schema Master), Maître de Nomination de Domaines (Domain Naming Master).

### 2.2. DC Secondaire : `server-core-1.xtech.green` (Tier 0)
* **Système d'Exploitation :** Windows Server 2022 Core (Interface textuelle uniquement)
* **Adresse IP :** `172.16.64.23/24`
* **Services Hébergés :** AD DS, DNS Réplication.
* **Rôles FSMO Détenus (Niveau Domaine) :** Émulateur PDC (PDC Emulator).

### 2.3. DC Troisième : `server-core-2.xtech.green` (Tier 0)
* **Système d'Exploitation :** Windows Server 2022 Core (Interface textuelle uniquement)
* **Adresse IP :** `172.16.64.24/24`
* **Services Hébergés :** AD DS, DNS Réplication.
* **Rôles FSMO Détenus (Niveau Domaine) :** Maître RID (RID Master).

### 2.4. DC Quatrième / Serveur WDS : `xts-wds.xtech.green` (Tier 0)
* **Système d'Exploitation :** Windows Server 2022 Standard (Expérience de bureau)
* **Adresse IP :** `172.16.64.25/24`
* **Services Hébergés :** AD DS, Windows Deployment Services (WDS), DNS Réplication.
* **Rôles FSMO Détenus (Niveau Domaine) :** Maître d'Infrastructure (Infrastructure Master).

## 3. Piliers de Sécurité et d'Architecture
* **Modèle de Privilèges Tiering (Tier 0) :** Séparer de façon étanche les droits d'administration. Interdire l'utilisation des identifiants d'administration globale des 4 serveurs Active Directory sur les serveurs applicatifs (Tier 1) ou les postes de travail (Tier 2).
* **Isolation Réseau et Accès par Rebond (Bastion) :** Bloquer les communications directes en provenance des segments utilisateurs standard via le pare-feu pfSense. Effectuer l'administration exclusivement à travers une session de rebond sécurisée HTTPS via le Bastion Apache Guacamole.
* **Centralisation des Journaux (Syslog) :** Rediriger en continu les événements de sécurité (Security) et de système (System) des 4 contrôleurs de domaine vers le serveur Syslog centralisé pour garantir la traçabilité des accès.
* **Fédération Inter-Entreprises :** Établir une relation de confiance (Trust Relationship) trans-forêts pour permettre l'authentification croisée et l'accès sécurisé aux ressources avec le partenaire externe.
* **Sauvegarde par Clonage :** Exécuter une routine de clonage hebdomadaire intégrale de la machine virtuelle du contrôleur principal `xts-411` pour garantir un point de restauration rapide en cas de sinistre ou de corruption de l'annuaire.


## 4. Architecture de la Documentation
Accéder aux différents volets de la configuration et de l'exploitation du serveur Active Directory via les fichiers suivants :

* **[Guide d'Installation et de Déploiement](./Install.md)** : Automatisation par script `hello my dir`, promotion du mode Core, configuration des zones DNS et des étendues DHCP.
*  **[Guide d'Exploitation et de Gouvernance](./User_guide.md)** : Architecture de l'arborescence des Unités d'Organisation (`PRS`), matrice des stratégies de groupe (GPO), gestion des partages du serveur de fichiers (`XTSE-411`) via le modèle AGDLP/ABE, et synchronisations LDAP (GLPI / iRedMail).
* **[Guide de Résolution des Incidents](./FAQ.md)** : Diagnostic des baux corrompus (`BAD_ADDRESS`), résolution des rejets de certificats LDAPS / Thunderbird, et validation du canal sécurisé de confiance.
