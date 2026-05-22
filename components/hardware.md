# Inventaire Prévisionnel du Matériel Réseau

Ce document recense l'ensemble des équipements matériels constitutifs de la topologie réseau, répartis par type et par rôle, conformément à l'architecture de sécurité mise en œuvre.

---

1. [Liste des Serveurs](#Liste-des-Serveurs)
2. [Liste des Routeurs](#Liste-des-Routeurs)
3. [Liste des Commutateurs](#Liste-des-Commutateurs)
4. [Explications Fonctionnelles des Rôles](#Explications-Fonctionnelles-des-Rôles)

# Liste des Serveurs (7 Serveurs)

| Nom du Matériel | Type | Rôle / Description | Zone / Réseau |
| :--- | :--- | :--- | :--- |
| **SRV BASTION** | Server-PT | Passerelle d'administration sécurisée (Bastion) pour l'accès externe. | VLAN 230 (`172.16.23.2/24`) |
| **SRV AD DHCP DNS** | Server-PT | Contrôleur de domaine (Active Directory), Gestionnaire d'adresses (DHCP) et Résolution de noms (DNS). | Zone Serveurs VLAN 200 (`172.16.16.3/24`) |
| **SRV FICHIERS** | Server-PT | Serveur de stockage et de partage de fichiers centralisé pour l'entreprise. | Zone Serveurs VLAN 200 (`172.16.16.2/24`) |
| **SRV BACKUP** | Server-PT | Serveur de sauvegarde locale pour la réplication des données critiques du LAN. | Zone Serveurs VLAN 200 (`172.16.16.4/24`) |
| **SRV-SAUVEGARDE ISOLÉ** | Server-PT | Serveur de sauvegarde externalisé et isolé de manière étanche pour la résilience. | Zone Isolée VLAN 210 (`172.16.21.2/24`) |
| **SRV-MESSAGERIE** | Server-PT | Serveur de messagerie interne de l'entreprise pour la gestion des courriels. | Zone Messagerie VLAN 220 (`172.16.22.3/24`) |
| **SRV-WEB-INTERNET** | Server-PT | Serveur de test simulant les services Internet externes (hébergé dans le Cloud WAN). | Zone Externe / Cloud-PT |

---

# Liste des Routeurs (3 Routeurs)

| Nom du Matériel | Type | Rôle / Description | Interfaces Principales |
| :--- | :--- | :--- | :--- |
| **R1 - IPv4** | Routeur Cisco 2911 | Routeur d'interconnexion central de la zone utilisateurs et de la zone serveurs vers l'ASA. | `g0/0` (LAN), `g0/1` (SRV), `g0/2` (Pare-feu) |
| **R2 - IPv4** | Routeur Cisco 2911 | Routeur de transit externe gérant la liaison vers le Cloud Internet et les sous-réseaux distants. | `g0/2` (Pare-feu), `g0/0` (SRV), `g0/1` (CLOUD) |
| **R3 - IPv4** | Routeur Cisco 2911 | Routeur dédié à l'isolation et à la distribution du segment d'administration Bastion. | `g0/0` (Bastion), `g0/1` (Pare-feu) |

---

# Liste des Commutateurs (17 Commutateurs)

### A. Commutateurs de Distribution / Multicouches (3)
* **Multilayer Switch0** (Cisco 3560-24PS) : Cœur de réseau distribution haut, interconnecte les VLANs utilisateurs majeurs vers R1.
* **Multilayer Switch1** (Cisco 3560-24PS) : Commutateur de distribution intermédiaire pour la redondance et la collecte des flux LAN.
* **Multilayer Switch2** (Cisco 3560-24PS) : Cœur de réseau distribution bas, assure la collecte des VLANs de la direction générale et du juridique.

### B. Commutateurs d'Accès de la Zone Utilisateurs (11)
* **Switch1** (Cisco 2960-24TT) : Accès pour le **VLAN 10 (VENTES / DEV COM)**
* **Switch2** (Cisco 2960-24TT) : Accès pour le **VLAN 20 (DEVELOPPEMENT)**
* **Switch3** (Cisco 2960-24TT) : Accès pour le **VLAN 30 (COMMUNICATION)**
* **Switch4** (Cisco 2960-24TT) : Accès pour le **VLAN 40 (RH)**
* **Switch5** (Cisco 2960-24TT) : Accès pour le **VLAN 50 (MARKETING)**
* **Switch6** (Cisco 2960-24TT) : Accès pour le **VLAN 60 (R&D)**
* **Switch7** (Cisco 2960-24TT) : Accès pour le **VLAN 70 (FINANCE)**
* **Switch8** (Cisco 2960-24TT) : Accès pour le **VLAN 80 (DSI)**
* **Switch9** (Cisco 2960-24TT) : Accès pour le **VLAN 90 (SERVICE GENERAUX)**
* **Switch10** (Cisco 2960-24TT) : Accès pour le **VLAN 100 (DIRECTION GENERALE)**
* **Switch11** (Cisco 2960-24TT) : Accès pour le **VLAN 110 (JURIDIQUE)**

### C. Commutateurs des Zones Spécifiques (3)
* **Switch_Zone_Serveurs** (Cisco 2960-24TT) : Interconnecte l'ensemble des serveurs de la ferme locale (VLAN 200).
* **Switch12** (Cisco 2960-24TT) : Commutateur d'accès dédié à la zone verte de sauvegarde isolée (VLAN 210).
* **Switch_Messagerie** (Cisco 2960-24TT) : Commutateur d'accès dédié à la zone jaune de messagerie (VLAN 220).

---

# Explications Fonctionnelles des Rôles

### Serveur AD DHCP DNS (Active Directory, DHCP, DNS)
C'est le pilier logique du réseau local de l'entreprise :
* **Active Directory (AD) :** Centralise la sécurité et la gestion des utilisateurs et des machines. Il permet aux collaborateurs de se connecter à n'importe quel poste informatique de leur VLAN avec un identifiant unique et d'appliquer des stratégies de groupe (GPO).
* **DHCP (Dynamic Host Configuration Protocol) :** Distribue automatiquement la configuration IP (Adresse IP, masque, passerelle, serveur DNS) à l'ensemble des équipements (PC, Laptops) du réseau lorsqu'ils se connectent, évitant ainsi les conflits d'adresses.
* **DNS (Domain Name System) :** Traduit les noms de domaine lisibles par l'homme (ex: `srv-fichiers.xtech.green`) en adresses IP compréhensibles par les machines. Sans lui, les utilisateurs devraient retenir l'adresse IP exacte de chaque serveur pour y accéder.

### Serveur Bastion
Le Bastion est une passerelle de sécurité indispensable dans une architecture réseau d'entreprise. Il sert de point d'entrée unique et obligatoire pour l'administration à distance (souvent via SSH ou RDP) des serveurs internes de l'entreprise depuis l'extérieur. Toutes les connexions y sont auditées, journalisées et contrôlées. Idéalement placé dans une zone à haut niveau de sécurité, il empêche l'exposition directe des serveurs sensibles sur Internet.

### Switch (Commutateur)
Le commutateur travaille principalement au niveau de la couche 2 (Liaison de données) du modèle OSI. Son rôle est de relier les équipements terminaux (PC, serveurs, imprimantes) au sein d'un **même réseau local (VLAN)**. Il analyse les adresses MAC pour acheminer les données de manière ciblée uniquement vers le port de la machine de destination, optimisant ainsi la bande passante par rapport à un concentrateur (Hub).
* *Note sur les Switchs Multicouches (L3) :* Ils possèdent en plus des capacités de routage de niveau 3, permettant de faire passer le trafic d'un VLAN à un autre très rapidement sans surcharger les routeurs principaux.

### Routeur
Le routeur opère au niveau de la couche 3 (Réseau) du modèle OSI. Son rôle principal est d'interconnecter des réseaux logiques totalement différents (par exemple, relier le réseau privé de l'entreprise `172.16.0.0/20` à Internet). Il analyse les adresses IP des paquets de données pour déterminer le meilleur chemin (le "prochain saut" ou *next-hop*) afin de guider le trafic de manière sécurisée d'un point A à un point B à travers le réseau global.
