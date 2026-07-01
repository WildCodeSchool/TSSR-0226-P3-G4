# Sommaire

1.  [1. Role du service](#1-Role-du-service)
2.  [2. Position dans l'architecture](#2-Position-dans-lrchitecture)
    - [2.1 Serveur Principal](#21-Serveur-Principal)
    - [2.2 Serveur Backup](#22-Serveur-Backup)
3.  [3. Prérequis](#3-Prérequis)
    - [3.1 Pour le Serveur](#31-Pour-le-Serveur)
    - [3.2 Pour le client](#32-Pour-le-client)
4.  [4. Documentation associé](#4-Documentation-Associé)

---
# 1. Role du service
**pfSense** est un **pare-feu** (firewall) et un **routeur open source et gratuit**, basé sur le système FreeBSD. Son rôle est de filtrer ce qui entre et sort du réseau pour le protéger, mais il fait bien plus qu'un simple pare-feu : il gère aussi le routage entre réseaux, peut faire serveur DHCP et DNS, monter des VPN (pour se connecter à distance de façon sécurisée), faire du NAT, de la répartition de charge, et s'enrichir de modules (comme un anti-intrusion ou un proxy). Le tout se pilote via une interface web claire, ce qui en fait une solution très répandue pour remplacer un boîtier pare-feu commercial à moindre coût, aussi bien en PME qu'en lab.

---
# 2. Position dans l'architecture

### 2.1 Serveur **Principal**: 
- Nom du serveur : ****
- Adresse IP : ****
- Gateway : ****

### 2.2 Serveur **Backup** :
- Nom du serveur : ****
- Adresse IP : ****
- Gateway : ****

---
# 3. Prérequis 
- Une machine (ou VM) avec au minimum deux interfaces réseau : une pour le WAN et une pour le LAN.
- Des ressources matérielles modestes suffisent pour un usage simple pas besopin de beaucoup de RAM ni d'un gros disque, mais on peut l'augmenter si on active des modules lourds.
- Un support d'installation (image ISO de pfSense) et un accès à la console pour la configuration initiale.
- Une bonne séparation des réseaux : le WAN et le LAN ne doivent pas être sur le même sous-réseau, sinon conflit.
- Un plan d'adressage défini : savoir quelle plage IP utiliser côté LAN, quelle passerelle, etc.
- Un navigateur web depuis un poste du LAN pour accéder à l'interface d'administration une fois l'installation faite.

---
# 4. Documentation

# Infrastructure Réseau & Sécurité pfSense — XenTech

## 📌 Présentation du Projet
Ce dépôt contient la configuration de référence du pare-feu central **pfSense-XTech**. L'infrastructure segmente les 11 départements et les services critiques de l'entreprise (218 collaborateurs) au sein d'un bloc unique de classe B segmenté via **19 VLANs distincts**.

La politique de sécurité applique un modèle **Zero Trust (Deny All par défaut)** : aucun flux inter-VLAN n'est toléré sans une règle d'autorisation explicite et justifiée.

## 🔀 Architecture & Plan d'Adressage Global
Le supernet attribué à XenTech est **`172.16.64.0/19`** (Plage : `172.16.64.0` ➔ `172.16.95.255`), découpé en sous-réseaux `/24`.

* **Passerelle d'administration LAN initiale :** `172.16.64.254/24`
* **Cœur de l'infrastructure (VLANs Techniques) :**
  * `VLAN 10` (AD) : `172.16.65.0/24` — DC Principal GUI & Core, DNS, DHCP
  * `VLAN 20` (APPS) : `172.16.66.0/24` — GLPI, Zabbix, Serveur de fichiers, WAPT
  * `VLAN 60` (BASTION) : `172.16.69.0/24` — Apache Guacamole (Unique point d'entrée d'administration)
  * `VLAN 100` (DMZ) : `172.16.71.0/24` — Serveur Web externe, iRedMail

## 📂 Structure de la Documentation
* `Install.md` : Guide d'installation pas-à-pas, configuration des interfaces et déploiement du Trunk.
* `User_guide.md` : Manuel d'exploitation des règles de filtrage pour les administrateurs réseau.
* `FAQ.md` : Réponses aux incidents fréquents et logique des zones "vides".
* `Fusion.md` : Procédure de raccordement Peer-to-Peer sécurisé par clé partagée avec le partenaire Pharmgreen.

