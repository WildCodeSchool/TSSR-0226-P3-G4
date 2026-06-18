#### Cette documentation détaille la mise en place de **GLPI** pour l'entreprise **XTech**, hébergé sur un container Proxmox Debian 12 LAMP, et la sauvegarde automatisée quotidienne de sa base de données vers le serveur BACKUP via `mysqldump`.

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
```

### A3 — Base de données

```bash
mysql_secure_installation
mysql -u root -p
```

```sql
CREATE DATABASE glpidb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'glpiuser'@'localhost' IDENTIFIED BY '<mot_de_passe>';
GRANT ALL PRIVILEGES ON glpidb.* TO 'glpiuser'@'localhost';
FLUSH PRIVILEGES;
quit;
```

### A4 — Téléchargement et installation de GLPI

```bash
cd /var/www/
wget https://github.com/glpi-project/glpi/releases/latest/download/glpi-<version>.tgz
tar xzf glpi-<version>.tgz
chown -R www-data:www-data /var/www/glpi
```

Fichier `/etc/apache2/sites-available/glpi.conf` :

```apache
<VirtualHost *:80>
    ServerName glpi.xtech.green
    DocumentRoot /var/www/glpi/public

    <Directory /var/www/glpi/public>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/glpi-error.log
    CustomLog ${APACHE_LOG_DIR}/glpi-access.log combined
</VirtualHost>
```

```bash
a2ensite glpi.conf
a2enmod rewrite
systemctl reload apache2
```

### A5 — Assistant d'installation web

```
http://172.16.66.31/
```

Suivre l'assistant : choix de la langue, vérification des prérequis PHP, connexion à la base (`glpidb` / `glpiuser`), création du compte super-admin GLPI.

> Après installation, supprimer ou protéger le dossier `install/` conformément aux recommandations officielles de GLPI (sécurité).

### A6 — Règle pare-feu nécessaire

Le poste admin MGMT doit pouvoir atteindre GLPI sur APPS (même logique que Zabbix/PRTG) :

- Pass : Source `172.16.64.0/24` (MGMT) → Destination `172.16.66.31` (GLPI) port `80,443`

Par ailleurs, les départements ont déjà accès à APPS via la règle 5 existante (F2, Pass départements → APPS port 80,443) — donc l'accès utilisateur final à GLPI depuis les VLAN département est déjà couvert, pas besoin de règle supplémentaire pour eux.

---

## PARTIE B — Sauvegarde quotidienne de la base GLPI vers BACKUP

### B1 — Script de sauvegarde (`mysqldump`)

Sur le CT GLPI, créer le script `/usr/local/bin/backup-glpi.sh` :

```bash
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/tmp/glpi-backup"
DEST="root@172.16.67.10:/srv/backup/glpi/"
LOGFILE="/var/log/backup-glpi.log"

mkdir -p $BACKUP_DIR

mysqldump -u glpiuser -p'<mot_de_passe>' glpidb | gzip > "$BACKUP_DIR/glpidb_$DATE.sql.gz"

if [ $? -eq 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] Dump GLPI réussi : glpidb_$DATE.sql.gz" >> $LOGFILE
    scp "$BACKUP_DIR/glpidb_$DATE.sql.gz" $DEST
    if [ $? -eq 0 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] Transfert vers BACKUP réussi" >> $LOGFILE
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] Échec du transfert SCP vers BACKUP" >> $LOGFILE
    fi
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] Échec du mysqldump GLPI" >> $LOGFILE
fi

# Nettoyage local : ne garder que les 7 derniers dumps en local
find $BACKUP_DIR -name "glpidb_*.sql.gz" -mtime +7 -delete
```

```bash
chmod +x /usr/local/bin/backup-glpi.sh
```

> Le transfert utilise `scp` à titre d'exemple simple. Une clé SSH dédiée (sans mot de passe) doit être générée et déployée vers le serveur BACKUP pour que ce script fonctionne en tâche planifiée sans interaction (cf. B3).

### B2 — Planification cron à minuit

```bash
crontab -e
```

```cron
0 0 * * * /usr/local/bin/backup-glpi.sh
```

### B3 — Authentification SSH par clé (pré-requis pour le cron)

Sur le CT GLPI :

```bash
ssh-keygen -t ed25519 -f /root/.ssh/id_backup -N ""
ssh-copy-id -i /root/.ssh/id_backup.pub root@172.16.67.10
```

> Adapter le script B1 pour utiliser cette clé explicitement si elle n'est pas la clé par défaut : `scp -i /root/.ssh/id_backup ...`

### B4 — Règle pare-feu nécessaire (APPS → BACKUP)

Cette règle existe déjà dans la configuration actuelle (F4, "Pass : Source APPS → Destination BACKUP port 22,3306 — rsync + mysqldump vers BKP"), donc le flux SCP du script B1 est déjà couvert. Aucune règle supplémentaire à ajouter ici.

### B5 — Réception côté serveur BACKUP

Sur le serveur BKP Linux (`172.16.67.10`), s'assurer que le répertoire de destination existe et a les bonnes permissions :

```bash
mkdir -p /srv/backup/glpi
chown root:root /srv/backup/glpi
chmod 750 /srv/backup/glpi
```

---

## PARTIE C — Vérification finale

1. Exécuter le script manuellement pour valider son bon fonctionnement avant de compter sur le cron :
   ```bash
   /usr/local/bin/backup-glpi.sh
   tail -20 /var/log/backup-glpi.log
   ```
   → doit afficher deux lignes `[INFO]` (dump réussi + transfert réussi).
2. Sur le serveur BACKUP, vérifier la présence du fichier :
   ```bash
   ls -la /srv/backup/glpi/
   ```
3. Test de restauration (à faire au moins une fois pour valider que la sauvegarde est exploitable, pas juste présente) :
   ```bash
   gunzip -c /srv/backup/glpi/glpidb_<date>.sql.gz | mysql -u root -p glpidb_test
   ```
4. Pour une preuve continue et automatisée (plutôt qu'une vérification manuelle ponctuelle), ce fichier de log `backup-glpi.log` peut être repris par syslog-ng et surveillé depuis Zabbix/PRTG exactement selon la méthode décrite dans le document de journalisation (recherche de la chaîne `[ERROR]` sur les dernières 24h).
