## Installation de GLPI (Version 11.0.7)  


<img width="1877" height="77" alt="image" src="https://github.com/user-attachments/assets/413c107b-a1f0-4d9c-97cd-f5d0b5b6f6b1" />


---
## PARTIE A — Installation de GLPI (CT Debian 12 LAMP)

### A1 — Pré-requis CT Proxmox

- Template : Debian 12 
- CPU : 1 core   
- RAM : 2G   
- Stockage : 20G
- Type de conteneur : Non-privilégié (Unprivileged: Yes)
- Décocher Firewall
- Domain DNS : xtech.green - IP 172.16.64.3 
- Stack : Apache2 + MariaDB + PHP 8.2 (LAMP)
- VLAN : 20 — APPS
- IP statique : `172.16.66.31/24`
- Passerelle : `172.16.66.254`
- VLAN Tag sur l'interface réseau du CT (`net0`) : `20`
- Type de conteneur : Non-privilégié (Unprivileged: Yes)   

## Vue d'ensemble

| Élément              | Détail                                                       |
| ---------------------- | ------------------------------------------------------------ |
| Serveur GLPI             | CT Proxmox Debian 12, stack LAMP                                |
| VLAN                     | 20 — APPS, `172.16.66.0/24`                                       |
| Sauvegarde BDD             | `mysqldump` quotidien à minuit (cron) vers le serveur BKP Linux    |
| Destination sauvegarde      | VLAN 30 — BACKUP, `172.16.67.0/24`                                  |

---

## Mise à jour du système

`apt update && apt upgrade -y`

<img width="1893" height="928" alt="image" src="https://github.com/user-attachments/assets/fef14849-1585-483d-8a2b-f0d704647ebf" />

---

Installation de l'architecture LAMP & Modules PHP obligatoires.   

GLPI nécessite un serveur Web, un moteur de base de données et des extensions PHP spécifiques pour communiquer avec l'Active Directory (LDAPS) que nous allons synchroniser par la suite.   

`apt install apache2 mariadb-server php php-mysql php-mbstring php-gd php-xml php-curl php-intl php-zip php-bz2 php-ldap -y`

<img width="1867" height="1681" alt="image" src="https://github.com/user-attachments/assets/f0adeac9-c9ca-4d3b-8915-dd345a12a108" />

---

## Création et sécurisation de la base de données MariaDB

`mysql_secure_installation` 

Répondre oui à tout [Y]   
Configurer un nouveau mot de passe root


<img width="1878" height="1866" alt="image" src="https://github.com/user-attachments/assets/ffb726ce-3213-472a-a482-da968ca63a66" />


---

## Connexion à MariaDB pour instancier la base GLPI

`mysql -u root -p`

Entrer le mot de passe généré juste avant..

```
CREATE DATABASE db_glpi CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
GRANT ALL PRIVILEGES ON db_glpi.* TO 'user_glpi'@'localhost' IDENTIFIED BY 'VotreMotDePasseRoot';
FLUSH PRIVILEGES;
EXIT;
```

<img width="1876" height="584" alt="Capture d&#39;écran 2026-07-01 175839" src="https://github.com/user-attachments/assets/8806e170-71c7-4fcf-9653-1e4197456c95" />

---

## Téléchargement, extraction et déploiement de GLPI v11.0.7

Déplacement dans le répertoire temporaire et téléchargement du paquet officiel   

`cd /tmp`

`wget https://github.com/glpi-project/glpi/releases/download/11.0.7/glpi-11.0.7.tgz`

<img width="1881" height="816" alt="image" src="https://github.com/user-attachments/assets/96215641-972d-4b7e-8b30-fc930c4f02b0" />

---

Extraction dans le répertoire du serveur Web Apache   

`tar -xvzf glpi-11.0.7.tgz -C /var/www/html/`

<img width="1867" height="2049" alt="image" src="https://github.com/user-attachments/assets/427eeab3-512f-472a-92a2-0367c51e0698" />

---

Attribution des droits à l'utilisateur du serveur Web (www-data)

```
chown -R www-data:www-data /var/www/html/glpi
chmod -R 755 /var/www/html/glpi
```

<img width="1876" height="92" alt="image" src="https://github.com/user-attachments/assets/98e4775f-1203-4512-a379-c692a53d2be6" />

---

## Guide de Vérification du Fonctionnement   

Avant de basculer sur l'interface graphique, l'administrateur doit valider la bonne exécution des services applicatifs sous Debian.   

Vérification des services système    

Contrôle du serveur Web Apache    

`systemctl status apache2`

<img width="1874" height="517" alt="image" src="https://github.com/user-attachments/assets/e2597f2d-7a99-4148-bfa5-966a95dfa578" />

---


Contrôle du système de gestion de base de données   

`systemctl status mariadb`

<img width="1879" height="660" alt="image" src="https://github.com/user-attachments/assets/639a27b5-893c-4569-a72b-b643e02416e5" />

---
















Configuration du DNS GLPI pour accéder à l'interface web : http://support.xtech.green   

Chemin du fichier de configuration : `/etc/apache2/sites-available/support.xentech.green.conf` :

```apache
<VirtualHost *:80>
    ServerName support.xtech.green
    DocumentRoot /var/www/glpi/public

    <Directory /var/www/glpi/public>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/glpi-error.log
    CustomLog ${APACHE_LOG_DIR}/glpi-access.log combined
</VirtualHost>
```
<img width="1872" height="851" alt="glpi-cd apache2 sites-available support xtech green conf" src="https://github.com/user-attachments/assets/bf8ca4f6-cb3c-43d5-b595-5dc0d664d57b" />



```bash
a2ensite glpi.conf
a2enmod rewrite
systemctl reload apache2
```

### A5 — Assistant d'installation web

```
http://support.xtech.green/
```
<img width="1881" height="1065" alt="glpi-interface" src="https://github.com/user-attachments/assets/17ee86bf-c160-4025-b958-2ce0a4d8eda4" />



Suivre l'assistant : choix de la langue, vérification des prérequis PHP.

Pour la 1ère connexion à GLPI, utiliser les identifiants par défaut  (`glpi` / `glpi`), création du compte super-admin GLPI : T1.


