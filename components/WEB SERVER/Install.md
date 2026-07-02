# Serveurs Web Apache2 — Guide d'Installation et de Déploiement

Ce guide documente les étapes d'installation à appliquer sur chacune des deux VM Debian 13 dédiées sur Proxmox.

Pré-requis
VM : ISO Debian 13
CPU : 1 Core
RAM : 1G
Stockage : 15G

---

## 1. Prérequis et Configuration Réseau Statique
Avant toute installation, attribuer les paramètres IP statiques conformément à la topologie du laboratoire :

### Étape 1 : Édition de la configuration réseau
Ouvrir le fichier de configuration réseau sur la VM :
```bash
nano /etc/network/interfaces
```
--- 

Sur la VM Web Interne :

```
auto ens18
iface ens18 inet static
    address 172.16.64.50
    netmask 255.255.255.0
    gateway 172.16.64.254
    dns-nameservers 172.16.64.3
```

<img width="1913" height="446" alt="image" src="https://github.com/user-attachments/assets/36a1fc12-611c-47ca-88b2-a9566d853f05" />

---

Sur la VM Web Externe :

```
auto ens18
iface ens18dns inet static
    address 172.16.64.51
    netmask 255.255.255.0
    gateway 172.16.64.254
    dns-nameservers 172.16.64.3
```

<img width="1916" height="433" alt="image" src="https://github.com/user-attachments/assets/9fc7abe7-e811-4da4-8009-7bd5768d3e01" />

---

Appliquer les paramètres en redémarrant l'interface :

```
systemctl restart networking
```

## 2. Installation d'Apache2 et Architecture des Dossiers

Étape 1 : Mise à jour du système et installation

```
apt update && apt upgrade -y
apt install apache2 -y
```

<img width="1927" height="402" alt="image" src="https://github.com/user-attachments/assets/41ed4232-b06e-4d18-9d37-7aab862fdb42" />

---

### Étape 2 : Création des répertoires applicatifs personnalisés
Conformément aux objectifs de l'infrastructure, nous isolons les sites dans des répertoires dédiés au lieu du dossier par défaut html.

Sur la VM Web Interne :

```
mkdir -p /var/www/xtech-interne
chown -R www-data:www-data /var/www/xtech-interne
chmod -R 755 /var/www/xtech-interne
```

<img width="1931" height="133" alt="image" src="https://github.com/user-attachments/assets/4a1cd61a-be56-48f7-baa9-70de6885b5e7" />

---

Sur la VM Web Externe :

```
mkdir -p /var/www/xtech-externe
chown -R www-data:www-data /var/www/xtech-externe
chmod -R 755 /var/www/xtech-externe
```

### Étape 3 : Déploiement du code source initial (index.html)
Créer et éditer le fichier d'accueil pour y lier le portail applicatif (GLPI, organigramme, etc.).

Exemple pour le site Interne

```
nano /var/www/xtech-interne/index.html
```

Voir le code de la page du serveur web interne : [ici](./Serveur_Web_Interne/index-interne.html/index-interne.html)

