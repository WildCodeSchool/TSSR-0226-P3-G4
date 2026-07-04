# Guide d'Installation Syslog et Configuration 

Ce document décrit les étapes pour installer le service `Syslog`

## 3. Prérequis

### 3.1 Pour le Serveur
- **Environnement :** Un conteneur LXC Débian 12 standard (non-privilégié) sur Proxmox VE.
- **Solution de collecte :** Le paquet `rsyslog` installé pour lire et intercepter les flux UDP/TCP.
- **Réseau :** Une adresse IP fixe dédiée pour que tous les équipements sachent où envoyer leurs logs.
- **Sécurité/Firewall :** Le port d'écoute standard **514 (TCP/UDP)** ouvert dans le pare-feu pfSense et au niveau de l'OS.
- **Stockage & Persistance :** 8G d'espace disque alloué au conteneur (les journaux peuvent vite devenir volumineux). Une configuration de rotation automatique des logs (`logrotate` et limites `journald`) est obligatoire.
- **RAM** : 512 MB
- **CPU** : 2 Cores

### 3.2 Pour le client
- **Compatibilité :** Équipements à superviser (autres VM/CT Proxmox, hyperviseurs, commutateurs) configurés pour pointer vers l'adresse IP du serveur Syslog.
- **Horloge synchrone (NTP) :** Une horloge synchronisée via NTP sur tous les serveurs et équipements clients est **indispensable** pour que les horodatages (timestamps) des logs soient cohérents entre eux lors des analyses de corrélations.





## 1. Activation de la persistance de systemd-journald
Par défaut sur certains templates LXC Debian minimaux, les logs sont volatiles. Il faut les fixer sur le disque.

```bash
# 1. Ouvrir le fichier de configuration de journald
nano /etc/systemd/journald.conf

# 2. Modifier ou décommenter la ligne suivante sous la section [Journal] :
Storage=persistent
SystemMaxUse=500M

# 3. Redémarrer le service journald
systemctl restart systemd-journald
