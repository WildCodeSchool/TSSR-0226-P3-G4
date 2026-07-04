# Guide d'Installation Syslog et Configuration 

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
- **Compatibilité :** Équipements à superviser (autres VM/CT Proxmox, hyperviseurs, commutateurs) configurés pour pointer vers l'adresse IP du serveur Syslog.
- **Horloge synchrone (NTP) :** Une horloge synchronisée via NTP sur tous les serveurs et équipements clients est **indispensable** pour que les horodatages (timestamps) des logs soient cohérents entre eux lors des analyses de corrélations.


---

# Étape 1 : Installation et activation de Rsyslog (Collecteur)


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
# Mise à jour des dépôts et installation
apt update && apt install -y rsyslog
```

<img width="1882" height="509" alt="image" src="https://github.com/user-attachments/assets/cbe74378-a620-46e3-ae9e-009f622ef3e9" />

---


```
# Activation au démarrage et lancement du service
systemctl enable rsyslog
systemctl start rsyslog
systemctl status rsyslog
```

<img width="1893" height="573" alt="Capture d&#39;écran 2026-07-04 163316" src="https://github.com/user-attachments/assets/9f8923fd-3e04-44db-b081-0898148b6902" />

---

Si la commande `systemctl status rsyslog` affiche un message d'erreur, j'explique comme résoudre ce problème dans la `FAQ Q1` : **[FAQ](./FAQ.md)**

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

## 2. Validez la bonne création des fichiers cibles :

```
ls -lh /var/log/syslog
```

<img width="1871" height="112" alt="image" src="https://github.com/user-attachments/assets/29e703c5-5b0c-469e-8783-dacce95a1b6f" />

---

# Étape 2 : Configuration du mode Serveur Centralisé 

Si ce serveur `Syslog` doit récupérer tous les logs de tous les serveurs de l'infrastructure Proxmox :

Ouvrir le fichier de configuration principal :

```
nano /etc/rsyslog.conf
```

Décommentez les lignes suivantes pour activer l'écoute UDP et/ou TCP sur le port standard 514 :

```
# Pour la réception UDP
module(load="imudp")
input(type="imudp" port="514")

# Pour la réception TCP
module(load="imtcp")
input(type="imtcp" port="514")
```

<img width="1877" height="587" alt="Capture d&#39;écran 2026-07-04 165250" src="https://github.com/user-attachments/assets/a19b30ac-4086-4e48-bb62-247d9ea855be" />

---

Redémarrez le démon :

```
systemctl restart rsyslog
```

---


