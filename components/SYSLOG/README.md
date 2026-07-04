# Documentation du Service Syslog - Conteneur Debian 12 (Proxmox VE)

## Sommaire

1. [Rôle du service](#1-rôle-du-service)
2. [Position dans l'architecture](#2-position-dans-larchitecture)
    2.1 [Serveur Principal](#21-serveur-principal)
    2.2 [Serveur Backup](#22-serveur-backup)
3. [Prérequis](#3-prérequis)
    3.1 [Pour le Serveur](#31-pour-le-serveur)
    3.2 [Pour le client](#32-pour-le-client)
4. [Documentation associée](#4-documentation-associée)

---

## 1. Rôle du service

Un serveur Syslog est un serveur de centralisation des journaux (logs). Le rôle d'un serveur Syslog est de collecter tous ces journaux au même endroit plutôt que de les laisser éparpillés sur chaque machine. Cela facilite grandement le travail de l'administrateur : il peut consulter, rechercher et analyser tout ce qui se passe sur le réseau depuis un point central, corréler des événements entre plusieurs équipements, garder un historique (utile pour le dépannage ou la sécurité), et être alerté en cas de problème. C'est aussi un outil important pour la traçabilité et la sécurité, car il conserve une trace de l'activité, y compris en cas d'incident. Syslog est un protocole standard que la quasi-totalité des équipements réseau savent utiliser.

*Note spécifique à l'environnement :* Sous Debian 12 (Bookworm), la journalisation native est gérée de manière binaire par `systemd-journald`. Ce projet s'appuie sur `rsyslog` pour assurer la compatibilité avec le protocole Syslog traditionnel et permettre la centralisation réseau.

## 2. Position dans l'architecture

### 2.1 Serveur Principal
*Ce conteneur héberge le service de collecte principal au sein du cluster Proxmox VE.*
- **Nom du serveur :** `[À compléter - ex: ct-syslog-01]`
- **Adresse IP :** `[À compléter - ex: 192.168.1.250]`
- **Gateway :** `[À compléter - ex: 192.168.1.1]`

### 2.2 Serveur Backup
*Serveur secondaire configuré pour prendre le relais ou recevoir une copie des flux critiques.*
- **Nom du serveur :** `[À compléter - ex: ct-syslog-02]`
- **Adresse IP :** `[À compléter - ex: 192.168.1.251]`
- **Gateway :** `[À compléter - ex: 192.168.1.1]`

## 3. Prérequis

### 3.1 Pour le Serveur
- **Environnement :** Un conteneur LXC Débian 12 standard (privilégié ou non-privilégié) sur Proxmox VE.
- **Solution de collecte :** Le paquet `rsyslog` installé pour lire et intercepter les flux UDP/TCP.
- **Réseau :** Une adresse IP fixe dédiée pour que tous les équipements sachent où envoyer leurs logs.
- **Sécurité/Firewall :** Le port d'écoute standard **514 (UDP et/ou TCP)** ouvert dans le pare-feu Proxmox VE et au niveau de l'OS.
- **Stockage & Persistance :** Suffisamment d'espace disque alloué au conteneur (les journaux peuvent vite devenir volumineux). Une configuration de rotation automatique des logs (`logrotate` et limites `journald`) est obligatoire.

### 3.2 Pour le client
- **Compatibilité :** Équipements à superviser (autres VM/CT Proxmox, hyperviseurs, commutateurs) configurés pour pointer vers l'adresse IP du serveur Syslog.
- **Horloge synchrone (NTP) :** Une horloge synchronisée via NTP sur tous les serveurs et équipements clients est **indispensable** pour que les horodatages (timestamps) des logs soient cohérents entre eux lors des analyses de corrélations.

## 4. Documentation associée

Pour exploiter et administrer pleinement ce service, veuillez vous référer aux guides suivants :
- **[`Install.md`](./Install.md)** : Procédure pas-à-pas pour installer `rsyslog`, activer la persistance et configurer l'écoute réseau.
- **[`User_guide.md`](./User_guide.md)** : Liste complète de toutes les commandes de consultation et de filtrage (`journalctl`, `grep`, `tail`).
- **[`FAQ.md`](./FAQ.md)** : Résolution des problèmes fréquents (disque plein, logs noyau LXC, redirection réseau).
