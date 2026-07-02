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

Voir le code de la page du serveur web interne : [ici](Serveur_Web_Interne/index-interne.html)    
Voir le code de la page du serveur web externe : [ici](Serveurs_Web_Externe/index-externe.html)

---

## 3. Configuration du VirtualHost Apache2

Pour que le serveur web réponde correctement aux requêtes HTTP basées sur les noms de domaine, configurer le fichier hôte virtuel.

### Étape 1 : Création du fichier de configuration du site

Sur la VM Web Interne :

```
nano /etc/apache2/sites-available/xtech-interne.conf
```

Ajouter la configuration suivante :

```
<VirtualHost *:80>
    ServerName interne.xtech.green
    ServerAdmin admin@xtech.green
    DocumentRoot /var/www/xtech-interne
    
    <Directory /var/www/xtech-interne>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/xtech-interne_error.log
    CustomLog ${APACHE_LOG_DIR}/xtech-interne_access.log combined
</VirtualHost>
```

<img width="1861" height="505" alt="image" src="https://github.com/user-attachments/assets/1e2c6914-b518-4373-8cbf-af16e195ef5a" />

---

Sur la VM Web Externe :

```
nano /etc/apache2/sites-available/xtech-externe.conf
```

Ajouter la configuration suivante :

```
<VirtualHost *:80>
    ServerName externe.xtech.green
    ServerAdmin admin@xtech.green
    DocumentRoot /var/www/xtech-externe
    
    <Directory /var/www/xtech-externe>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/xtech-externe_error.log
    CustomLog ${APACHE_LOG_DIR}/xtech-externe_access.log combined
</VirtualHost>

```

### Étape 2 : Activation du site et désactivation de la page par défaut

```
# 1. Désactiver le site d'origine d'Apache
a2dissite 000-default.conf

# 2. Activer le nouveau site (Exemple interne)
a2ensite xtech-interne.conf

# 3. Tester la syntaxe de configuration
apache2ctl configtest

# 4. Recharger le service si le test affiche "Syntax OK"
systemctl reload apache2
```

## 4. Procédure de Retour Arrière Global (Rollback)
En cas d'anomalie critique sur l'un des serveurs ou si vous devez réinitialiser la configuration d'Apache à son état initial d'usine, exécutez les commandes suivantes pas à pas :

```
# 1. Désactiver le site personnalisé défectueux
a2dissite xtech-interne.conf   # (ou xtech-externe.conf)

# 2. Réactiver la page d'accueil d'usine d'Apache2
a2ensite 000-default.conf

# 3. Supprimer les répertoires et fichiers créés (Attention : efface le code source web local)
rm -rf /var/www/xtech-interne/
rm -rf /var/www/xtech-externe/
rm -f /etc/apache2/sites-available/xtech-interne.conf
rm -f /etc/apache2/sites-available/xtech-externe.conf

# 4. Redémarrer proprement le service HTTP
systemctl restart apache2
```

Le serveur web est désormais revenu à son état de post-installation standard.



