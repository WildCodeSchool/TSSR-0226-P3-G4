# Documentation du Service Syslog-ng - Conteneur Debian 12 (Proxmox VE)

## Sommaire

1. **[Rôle du service](#1-rôle-du-service)**    
2. **[Position dans l'architecture](#2-position-dans-larchitecture)**    
    2.1 **[Serveur Principal](#21-serveur-principal)**    
    2.2 **[Serveur Backup](#22-serveur-backup)**    
3. **[Prérequis](#3-prérequis)**     
    3.1 **[Pour le Serveur](#31-pour-le-serveur)**     
    3.2 **[Pour le client](#32-pour-le-client)**    
4. **[Documentation associée](#4-documentation-associée)**    

---

## 1. Rôle du service

Un serveur Syslog-ng (Next Generation) est un serveur de centralisation des journaux (logs). Le rôle de ce serveur est de collecter tous ces journaux au même endroit plutôt que de les laisser éparpillés sur chaque machine. 

Syslog-ng apporte une grande flexibilité par rapport au syslog traditionnel : il permet de filtrer, trier et structurer automatiquement les fichiers reçus dans des répertoires dynamiques basés sur le nom ou l'IP de la machine émettrice. Cela facilite grandement le travail de l'administrateur pour la sécurité, le dépannage, et la traçabilité de l'infrastructure.

## 2. Position dans l'architecture

### 2.1 Serveur Principal
*Conteneur LXC hébergeant le collecteur Syslog-ng principal.*
- **Nom du serveur :** `[XTSE-452]`
- **Adresse IP :** `172.16.64.28`
- **Gateway :** `[172.16.64.254]`


## 3. Prérequis

### 3.1 Pour le Serveur
- **Environnement :** Un conteneur LXC Debian 12 (Principal) sur Proxmox VE.
- **Solution de collecte :** Le paquet `syslog-ng` installé et configuré pour l'écoute réseau.
- **Réseau :** Adresses IP fixes dédiées (réseau `172.16.64.0/24`).
- **Sécurité/Firewall :** Ouverture du port **514 (en TCP et UDP)** au niveau du pare-feu Proxmox VE pour autoriser le nouveau plan d'adressage.
- **Stockage :** Un espace disque supervisé (avec LVM / RAID 5 pour le Backup) pour encaisser la volumétrie des logs d'infrastructure.

### 3.2 Pour le client
- **Clients Linux :** Configurés pour transférer le flux `*.*` via TCP ou UDP vers les deux IP de collecte.
- **Clients Windows (AD / Files) :** Installation obligatoire d'un agent tiers (ex: *NXLog* ou *Winlogbeat*) pour convertir les journaux d'événements Windows (`.evtx`) et les envoyer au format Syslog vers le serveur de collecte.
- **Horloge synchrone (NTP) :** Une horloge synchronisée sur toute l'infra est indispensable pour la cohérence des horodatages lors de l'analyse des incidents.

## 4. Documentation associée

- **[`Install.md`](./Install.md)** : Procédure d'installation et fichier de configuration `syslog-ng.conf` complet.
- **[`User_guide.md`](./User_guide.md)** : Commandes d'administration, de vérification des ports et de lecture des dossiers de logs par serveurs.
- **[`FAQ.md`](./FAQ.md)** : Réponses aux erreurs fréquentes (LXC, blocage réseau, alertes de cache DNS).
