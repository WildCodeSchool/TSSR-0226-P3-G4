#### Cette documentation détaille la mise en place de **GLPI** pour l'entreprise **XenTech**, hébergé sur un container Proxmox Debian 12 LAMP, et la sauvegarde automatisée quotidienne de sa base de données vers le serveur BACKUP via `mysqldump`.

--------

## Vue d'ensemble

| Élément              | Détail                                                       |
| ---------------------- | ------------------------------------------------------------ |
| Serveur GLPI             | CT Proxmox Debian 12, stack LAMP                                |
| VLAN                     | 20 — APPS, `172.16.66.0/24`                                       |
| Sauvegarde BDD             | `mysqldump` quotidien à minuit (cron) vers le serveur BKP Linux    |
| Destination sauvegarde      | VLAN 30 — BACKUP, `172.16.67.0/24`                                  |

GLPI est hébergé sur son propre CT Debian 12 (LAMP), distinct des CT Zabbix et syslog-ng/iRedMail, tous sur le VLAN APPS.

---

## PARTIE A — Installation de GLPI (CT Debian 12 LAMP)

### A1 — Pré-requis CT Proxmox

- Template : Debian 12
- Stack : Apache2 + MariaDB + PHP (LAMP)
- VLAN : 20 — APPS
- IP statique : `172.16.66.31/24`
- Passerelle : `172.16.66.254`
- VLAN Tag sur l'interface réseau du CT (`net0`) : `20`

### A2 — Installation des dépendances

```bash
apt update && apt upgrade -y
apt install apache2 mariadb-server php php-{cli,common,curl,gd,intl,mysql,xml,mbstring,zip,bz2,ldap,apcu} -y
systemctl enable apache2 mariadb
systemctl status apache2
```
<img width="1877" height="651" alt="glpi-apache-status" src="https://github.com/user-attachments/assets/450fbf7c-6007-47a7-b24d-669568d12e73" />

```bash
systemctl status mariadb
```

<img width="1888" height="787" alt="glpi-mariadb-status" src="https://github.com/user-attachments/assets/65f61d71-3b55-48cb-bfc3-2379c9541745" />


### A3 — Base de données

```bash
mysql_secure_installation
```

<img width="1890" height="1669" alt="glpi-bdd" src="https://github.com/user-attachments/assets/f8b3d2d4-d70e-416e-a4ee-7e5970d7ffbe" />

```bash
mysql -u root -p
```

```sql
CREATE DATABASE glpidb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'glpiuser'@'localhost' IDENTIFIED BY '<mot_de_passe>';
GRANT ALL PRIVILEGES ON glpidb.* TO 'glpiuser'@'localhost';
FLUSH PRIVILEGES;
quit;
```
<img width="1882" height="655" alt="gkpi-bdd-1" src="https://github.com/user-attachments/assets/98fdaa0c-45f8-4fba-8f47-547559bb9f2c" />




### A4 — Téléchargement et installation de GLPI

```bash
cd /var/www/
wget https://github.com/glpi-project/glpi/releases/latest/download/glpi-11.07.tgz
tar xzf glpi-11.0.7.tgz
chown -R www-data:www-data /var/www/glpi
```
<img width="1873" height="57" alt="glpi-version-11 0 7" src="https://github.com/user-attachments/assets/39fa7249-84cb-4438-a523-761180499527" />



Fichier `/etc/apache2/sites-available/support.xentech.green.conf` :

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



Suivre l'assistant : choix de la langue, vérification des prérequis PHP, connexion à la base (`glpidb` / `glpiuser`), création du compte super-admin GLPI : T1.

> Après installation, supprimer ou protéger le dossier `install/` conformément aux recommandations officielles de GLPI (sécurité).

<img width="1898" height="512" alt="glpi-creation-T1-super-admin" src="https://github.com/user-attachments/assets/a443586f-9fe1-4d77-b164-223c16fd31b4" />


### A6 — Règle pare-feu nécessaire

Le poste admin MGMT doit pouvoir atteindre GLPI sur APPS (même logique que Zabbix/PRTG) :

- Pass : Source `172.16.64.0/24` (MGMT) → Destination `172.16.66.31` (GLPI) port `80,443`

<img width="1824" height="713" alt="glpi-T1-vers-glpi" src="https://github.com/user-attachments/assets/897336fe-c05e-4865-8e9c-1c569b36dbcc" />



Par ailleurs, les départements ont déjà accès à APPS via la règle 5 existante (F2, Pass départements → APPS port 80,443) — donc l'accès utilisateur final à GLPI depuis les VLAN département est déjà couvert, pas besoin de règle supplémentaire pour eux.

---

## PARTIE B — Sauvegarde quotidienne de la base GLPI vers BACKUP

### B1 — Script de sauvegarde (`mysqldump`)

Sur le CT GLPI, créer le script `/usr/local/bin/backup-glpi.sh` :

```bash
#!/bin/bash

# Duplique l'affichage : à l'écran ET dans le fichier de log
exec > >(tee -a /var/log/backup_glpi.log) 2>&1

# ==============================================================================
# SCRIPT DE SAUVEGARDE AUTOMATIQUE GLPI (BASE DE DONNEES + FICHIERS WEB)
# ==============================================================================

# Variables de configuration
DB_USER="glpi_adm"
DB_PASS='Mjgm01*'
DB_NAME="db25_glpi"
BKP_SERVER="172.16.64.18"
BKP_USER="t1"
SSH_KEY="/root/.ssh/id_ed25519_glpi"
DEST_DIR="/mnt/BKP/GLPI"

echo "[$(date +'%Y-%m-%d %H:%M:%S')] Debut de la sauvegarde GLPI..."

# Etape 1 : Exportation de la base de donnees et envoi direct via SSH sur le LV Vol3
echo "-> Exportation de la base de donnees SQL..."
mysqldump -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" | ssh -i "$SSH_KEY" "$BKP_USER"@"$BKP_SERVER" "cat > $DEST_DIR/glpi_backup.sql"

# Etape 2 : Synchronisation incrementielle des fichiers Web (Miroir)
echo "-> Synchronisation des fichiers web (/var/www/html)..."
rsync -avz --delete -e "ssh -i $SSH_KEY" /var/www/html/ "$BKP_USER"@"$BKP_SERVER":"$DEST_DIR/html/"

echo "[$(date +'%Y-%m-%d %H:%M:%S')] Sauvegarde terminee avec succes !"
logger -t BACKUP_GLPI "Sauvegarde terminee avec succes !"

# Nettoyage local : ne garder que les 7 derniers dumps en local
find $BACKUP_DIR -name "glpidb_*.sql.gz" -mtime +7 -delete
```
<img width="1876" height="862" alt="glpi-script" src="https://github.com/user-attachments/assets/2aa2d20e-c46d-4ce7-84ba-777b6e324529" />



```bash
chmod +x /usr/local/bin/backup-glpi.sh
```

> Le transfert utilise `rsync` à titre d'exemple simple. Une clé SSH dédiée (sans mot de passe) doit être générée et déployée vers le serveur BACKUP pour que ce script fonctionne en tâche planifiée sans interaction.

<img width="1886" height="365" alt="glpi-transfert-key-ssh-vers-srv-BKP" src="https://github.com/user-attachments/assets/7a2ed3ae-7ce2-454f-8ade-af687d16e35c" />

```bash
./backup_glpi.sh
```

<img width="1880" height="320" alt="glpi-sauvegarde-bdd-glpi-vers-BKP-ssh" src="https://github.com/user-attachments/assets/d8276176-4e0c-42fa-8931-960bf992cb48" />

> La sauvegarde de la BDD de GLPI a bien été transféré via `rsync` en `ssh` de manière automatique sans mot de passe.


### B2 — Planification cron à minuit

```bash
crontab -e
```

```cron
0 0 * * * /usr/local/bin/backup-glpi.sh
```
<img width="1886" height="603" alt="glpi-cron" src="https://github.com/user-attachments/assets/c900f763-cd4c-4085-8dae-22d6d922d2fd" />



### B3 — Authentification SSH par clé (pré-requis pour le cron)

Sur le CT GLPI :

```bash
ssh-keygen -t ed25519 -C "CT-Debian-12-GLPI vers SRV-BKP-Debian-13
ssh-copy-id -i /root/.ssh/id_25519_glpi.pub t1@172.16.67.10
```
<img width="1880" height="106" alt="glpi-key-ssh-public" src="https://github.com/user-attachments/assets/32ce5556-f3e9-4a8e-85a3-3d45388e51f9" />



> Adapter le script B1 pour utiliser cette clé explicitement si elle n'est pas la clé par défaut : `ssh-copy-id -i /root/.ssh/id_25519.pub ...`

### B4 — Règle pare-feu nécessaire (APPS → BACKUP)

Cette règle existe déjà dans la configuration actuelle (F4, "Pass : Source APPS → Destination BACKUP port 22,3306 — rsync + mysqldump vers BKP"), donc le flux RSYNC du script B1 est déjà couvert. Aucune règle supplémentaire à ajouter ici.

<img width="1706" height="111" alt="glpi-rules-ssh-vers-bkp" src="https://github.com/user-attachments/assets/060bfbe3-b11e-4e3c-bf0e-76fa1e064da2" />


### B5 — Réception côté serveur BACKUP

Sur le serveur BKP Linux (`172.16.67.10`), s'assurer que le répertoire de destination existe et a les bonnes permissions :

```bash
mkdir -p /mnt/BKP/GLPI
chown root:root /mnt/BKP/GLPI
chmod 750 /mnt/BKP/GLPI
```
<img width="1920" height="145" alt="glpi-chown-t1" src="https://github.com/user-attachments/assets/79692fda-297e-4c88-af9b-285d641fea79" />

---

## PARTIE C — Vérification finale

1. Exécuter le script manuellement pour valider son bon fonctionnement avant de compter sur le cron :
   ```bash
   /root/backup_glpi.sh
   tail -10 /var/log/backup_glpi.log
   ```

<img width="1887" height="291" alt="glpi-tail-10" src="https://github.com/user-attachments/assets/57adacd6-ac23-459c-9920-fc2e8bf39893" />

   
   → doit afficher deux lignes `[INFO]` (dump réussi + transfert réussi).
2. Sur le serveur BACKUP, vérifier la présence du fichier :
   ```bash
   ls -la /mnt/BKP/GLPI/
   ```

   <img width="1918" height="203" alt="glpi-preuve-sauvegarde-BKP" src="https://github.com/user-attachments/assets/4c3d6f2a-2724-4cef-af4c-82701c1ed173" />

3. Test de restauration (à faire au moins une fois pour valider que la sauvegarde est exploitable, pas juste présente) :
   ```bash
   gunzip -c /mnt/BKP/GLPI/glpidb_<date>.sql.gz | mysql -u root -p glpidb_test
   ```

### Étape 1 : Se connecter à MySQL

```bash
mysql -u root -p

```

### Étape 2 : Créer la base de test et quitter

Copie-colle ces lignes dans l'invite MySQL :

```sql
CREATE DATABASE glpi_test;
EXIT;

```

### Étape 3 : Lancer le test de restauration

Maintenant, tu peux importer ta sauvegarde dans cette nouvelle base sans toucher à la production :

```bash
mysql -u root -p glpi_test < /mnt/BKP/GLPI/glpi_backup.sql

```

### Étape 4 : Vérifier que ça a marché

Pour t'assurer que le fichier était exploitable et contient bien tes tables, reconnecte-toi pour voir si les tables sont là :

```bash
mysql -u root -p -e "SHOW TABLES FROM glpi_test;"

```

Si tu vois la liste de toutes tes tables GLPI s'afficher, **ta sauvegarde est officiellement validée et fonctionnelle !**

### Étape 5 : Nettoyage (Optionnel)

Une fois le test réussi, tu peux supprimer cette base de test pour libérer de l'espace :

```bash
mysql -u root -p -e "DROP DATABASE glpi_test;"

```
   
4. Pour une preuve continue et automatisée (plutôt qu'une vérification manuelle ponctuelle), ce fichier de log `backup_glpi.log` peut être repris par syslog-ng et surveillé depuis Zabbix/PRTG exactement selon la méthode décrite dans le document de journalisation (recherche de la chaîne `[ERROR]` sur les dernières 24h).
