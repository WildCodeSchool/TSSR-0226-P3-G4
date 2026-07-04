# Guide d'Installation et configuration Syslog-ng  

Ce guide détaille le déploiement du serveur **Syslog-ng** pour l'environnement Debian 12.

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
- **Compatibilité :** Équipements à superviser (autres VM/CT Proxmox, hyperviseurs, commutateurs, serveurs Windows via agent type NXLog) configurés pour pointer vers l'adresse IP du serveur Syslog-ng.
- **Horloge synchrone (NTP) :** Une horloge synchronisée via NTP sur tous les serveurs et équipements clients est **indispensable** pour que les horodatages (timestamps) des logs soient cohérents entre eux lors des analyses de corrélations.


---

# Étape 1 : Installation et activation de Syslog-ng 


Debian 12 n'incluant plus rsyslog par défaut, son installation remplit le prérequis logiciel de notre architecture.

Pour que la commande `apt` fonctionne, commenter le dépôt non-free :    

```
nano /etc/apt/sources.list.d/sources.list
```

<img width="1876" height="162" alt="image" src="https://github.com/user-attachments/assets/d54303f4-cb68-4769-a03a-8c75b2e30dd5" />

---

Vérifier que le DNS pointe bien vers son serveur DNS, ici notre serveur AD `172.16.64.3`

```
nano /etc/resolv.conf
```

<img width="1869" height="142" alt="image" src="https://github.com/user-attachments/assets/0f3d31d6-1d4f-4637-bff6-2ed252faf75e" />

---

```
# Mise à jour des dépôts et installation de Syslog-ng
apt update && apt install -y syslog-ng
```

<img width="1883" height="500" alt="image" src="https://github.com/user-attachments/assets/32c535d2-328b-45c4-81ff-40b010a99dfc" />


---


```
# Activation au démarrage et lancement du service
systemctl enable syslog-ng
systemctl start syslog-ng
systemctl status syslog-ng
```

<img width="1866" height="530" alt="image" src="https://github.com/user-attachments/assets/9592c709-1114-4aab-bb3c-4df71c8fa9bb" />


---





## 1. Activation de la persistance de systemd-journald
Par défaut sur certains templates LXC Debian minimaux, les logs sont volatiles. Il faut les fixer sur le disque.

```
# 1. Ouvrir le fichier de configuration de journald
nano /etc/systemd/journald.conf

# 2. Modifier ou décommenter la ligne suivante sous la section [Journal] :
Storage=persistent
SystemMaxUse=500M
```

<img width="1865" height="1240" alt="Capture d&#39;écran 2026-07-04 164023" src="https://github.com/user-attachments/assets/9cce4b14-f142-4aca-bd09-4011d7f6cae1" />

---

```
# 3. Redémarrer le service journald
systemctl restart systemd-journald
```

---

## 2. Configuration du mode Serveur Centralisé

Si ce serveur Syslog-ng doit récupérer tous les logs de tous les serveurs de l'infrastructure Proxmox, il doit écouter sur le réseau et trier dynamiquement les machines entrantes.

Ouvrez le fichier de configuration principal :

```
nano /etc/syslog-ng/syslog-ng.conf
```

<img width="1278" height="1180" alt="Capture d&#39;écran 2026-07-04 205312" src="https://github.com/user-attachments/assets/a8563b55-7f48-465e-897c-91146b941352" />


---
Créer le répertoire racine dédié au stockage, puis redémarrez le démon pour appliquer l'écoute réseau :

```
mkdir -p /var/log/syslog-ng
systemctl restart syslog-ng
```

<img width="1863" height="113" alt="image" src="https://github.com/user-attachments/assets/c2f60fd3-754f-4ecc-983c-38455267a30c" />

---

## 3. Validation de la bonne configuration et de l'écoute des ports

Pour valider que Syslog-ng est désormais prêt à recevoir les logs de toute l'infrastructure en UDP et en TCP, exécutez les vérifications de sockets suivantes :

```
# Vérifier que le service écoute bien en UDP sur le port 514
ss -ulnp | grep 514

# Vérifier que le service écoute bien en TCP (LISTEN) sur le port 514
ss -tlnp | grep 514
```

<img width="1866" height="204" alt="image" src="https://github.com/user-attachments/assets/61d52598-0fc6-4f53-97f2-f1634daa8f41" />

---




