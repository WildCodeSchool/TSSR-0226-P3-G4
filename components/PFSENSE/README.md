# Infrastructure Réseau & Sécurité pfSense — XenTech

## Présentation du Projet
Ce dépôt contient la configuration de référence du pare-feu central **pfSense-XTech**. L'infrastructure segmente les 11 départements et les services critiques de l'entreprise (218 collaborateurs) au sein d'un bloc unique de classe B segmenté via **19 VLANs distincts**.

La politique de sécurité applique un modèle **Zero Trust (Deny All par défaut)** : aucun flux inter-VLAN n'est toléré sans une règle d'autorisation explicite et justifiée.

## Architecture & Plan d'Adressage Global
Le supernet attribué à XenTech est **`172.16.64.0/19`** (Plage : `172.16.64.0` ➔ `172.16.95.255`), découpé en sous-réseaux `/24`.

* **Passerelle d'administration LAN initiale :** `172.16.64.254/24`
* **Cœur de l'infrastructure (VLANs Techniques) :**
  * `VLAN 10` (AD) : `172.16.65.0/24` — DC Principal GUI & Core, DNS, DHCP
  * `VLAN 20` (APPS) : `172.16.66.0/24` — GLPI, Zabbix, Serveur de fichiers, WAPT
  * `VLAN 60` (BASTION) : `172.16.69.0/24` — Apache Guacamole (Unique point d'entrée d'administration)
  * `VLAN 100` (DMZ) : `172.16.71.0/24` — Serveur Web externe, iRedMail

## Structure de la Documentation
Pour naviguer dans la documentation technique de l'infrastructure, veuillez vous référer aux guides suivants :

* **[Guide d'Installation](./Install.md)** : Guide pas-à-pas pour la configuration des interfaces, l'initialisation du LAN et le déploiement du Trunk VLAN.
* **[Guide d'Utilisation du Filtrage](./User_Guide.md)** : Manuel d'exploitation de la politique Zero Trust, règles par défaut et gestion des alias pour le cloisonnement des départements.
* **[Procédure de Fusion P2P](./Fusion.md)** : Protocole de raccordement et d'interconnexion sécurisée par clé partagée (Shared Key) avec notre partenaire Pharmgreen via OpenVPN.
* **[Foire Aux Questions](./FAQ.md)** : Réponses aux incidents fréquents, explications sur la logique des zones passives (BACKUP, WEB-INT) et l'absence de certains DHCP.
