#### Cette documentation détaille la mise en place du serveur **Zabbix** de l'entreprise **XTech**, hébergé sur un container Proxmox (CT) Debian 12 LAMP, la supervision de l'agent Windows 11 Pro du poste admin XTA-401, et l'administration des logs syslog centralisés depuis Zabbix.

--------

## Vue d'ensemble

| Élément              | Détail                                                           |
| ---------------------- | -------------------------------------------------------------- |
| Serveur Zabbix          | CT Proxmox Debian 12, stack LAMP                                   |
| VLAN                     | 20 — APPS, `172.16.66.0/24`                                        |
| Poste supervisé (agent)   | XTA-401, Windows 11 Pro, T1 admin, VLAN 1 — MGMT (`172.16.64.0/24`) |
| Logs administrés          | Logs centralisés sur le serveur syslog-ng (CT Debian 12, VLAN APPS) |

Zabbix est hébergé sur son propre CT Debian 12 (LAMP), distinct du CT GLPI et du CT syslog-ng/iRedMail, tous trois sur le VLAN APPS. Le poste XTA-401 (admin, Windows 11 Pro) est sur le VLAN MGMT — il s'agit donc d'un flux **inter-VLAN MGMT → APPS** qui doit être explicitement autorisé au pare-feu.

---

## PARTIE A — Installation du serveur Zabbix (CT Debian 12 LAMP)

### A1 — Pré-requis CT Proxmox

- Template : Debian 12
- Stack : Apache2 + MySQL/MariaDB + PHP (LAMP), déjà en place selon votre infra
- VLAN : 20 — APPS
- IP statique : `172.16.66.30/24` (à ajuster selon votre plan d'adressage interne d'APPS)
- Passerelle : `172.16.66.254`
- VLAN Tag sur l'interface réseau du CT (`net0`) : `20`

### A2 — Installation du serveur Zabbix

```bash
apt update
wget https://repo.zabbix.com/zabbix/6.4/debian/pool/main/z/zabbix-release/zabbix-release_6.4-1+debian12_all.deb
dpkg -i zabbix-release_6.4-1+debian12_all.deb
apt update
apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent -y
```

### A3 — Base de données

```bash
mysql -u root -p
```

```sql
CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER 'zabbix'@'localhost' IDENTIFIED BY '<mot_de_passe>';
GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';
SET GLOBAL log_bin_trust_function_creators = 1;
quit;
```

Import du schéma :

```bash
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -u zabbix -p zabbix
```

### A4 — Configuration du serveur

Fichier `/etc/zabbix/zabbix_server.conf` :

```ini
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=<mot_de_passe>
```

```bash
systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2
```

### A5 — Accès web

```
http://172.16.66.30/zabbix
```

Assistant de configuration → connexion à la base → identifiants par défaut `Admin / zabbix` à changer immédiatement après la première connexion.

---

## PARTIE B — Règle pare-feu nécessaire (MGMT → APPS)

En relisant la configuration pare-feu actuelle, **aucune règle n'autorise un flux depuis le VLAN 1 — MGMT vers APPS**. Le poste XTA-401 (MGMT) doit pourtant atteindre le serveur Zabbix sur APPS pour l'interface web et l'agent doit y envoyer ses données. Règle à ajouter :

- Pass : Source `172.16.64.0/24` (MGMT) → Destination `172.16.66.30` (Zabbix) port `80,443` (interface web) et `10051` (zabbix-server, réception agent)

> Le VLAN MGMT est censé être le réseau d'administration de plus haut niveau (T0/T1/T2) ; il est cohérent qu'il puisse atteindre APPS pour la supervision, mais cette règle reste à créer explicitement — rien ne l'autorise par défaut entre VLAN.

---

## PARTIE C — Déploiement de l'agent Zabbix sur XTA-401 (Windows 11 Pro)

### C1 — Téléchargement et installation

Sur XTA-401, télécharger l'agent Zabbix (version Windows MSI) correspondant à la version du serveur (6.4) depuis le site officiel Zabbix.

```powershell
msiexec /i zabbix_agent2-6.4-windows-amd64.msi /qn SERVER=172.16.66.30 SERVERACTIVE=172.16.66.30 HOSTNAME=XTA-401
```

### C2 — Configuration de l'agent

Fichier `C:\Program Files\Zabbix Agent 2\zabbix_agent2.conf` :

```ini
Server=172.16.66.30
ServerActive=172.16.66.30
Hostname=XTA-401
```

```powershell
Restart-Service "Zabbix Agent 2"
Set-Service "Zabbix Agent 2" -StartupType Automatic
```

### C3 — Pare-feu Windows local sur XTA-401

```powershell
New-NetFirewallRule -DisplayName "Zabbix Agent" -Direction Inbound -Protocol TCP -LocalPort 10050 -Action Allow
```

### C4 — Déclaration de l'hôte dans Zabbix

Interface web Zabbix → **Data collection → Hosts → Create host** :

- Host name : `XTA-401`
- Groups : créer ou sélectionner un groupe `Postes Admin MGMT`
- Interfaces : Agent, IP `172.16.64.x` (IP réelle de XTA-401), port `10050`
- Templates : `Windows by Zabbix agent` (template officiel, surveille CPU/RAM/disque/services de base)

### C5 — Vérification

```bash
zabbix_get -s 172.16.64.x -k agent.ping
```

→ doit retourner `1`.

Dans l'interface Zabbix : **Monitoring → Latest data**, filtrer sur `XTA-401` → les métriques système doivent apparaître et se rafraîchir.

---

## PARTIE D — Administration des logs syslog centralisés depuis Zabbix

Conformément au document de journalisation syslog-ng, les logs Linux et Windows de l'infrastructure sont déjà centralisés sur le CT syslog-ng (VLAN APPS) dans `/var/log/centralized/`. L'objectif ici est de rendre ces logs **consultables et surveillables directement depuis Zabbix**, sans avoir à se connecter en SSH au CT syslog-ng pour les lire.

### D1 — Installer l'agent Zabbix sur le CT syslog-ng

```bash
apt install zabbix-agent2 -y
```

Fichier `/etc/zabbix/zabbix_agent2.conf` :

```ini
Server=172.16.66.30
ServerActive=172.16.66.30
Hostname=syslog-central
```

```bash
systemctl restart zabbix-agent2
systemctl enable zabbix-agent2
```

### D2 — Surveillance des fichiers de logs via item de type "Log monitor"

Dans Zabbix, **Data collection → Hosts → syslog-central → Items → Create item** :

- Type : `Zabbix agent (active)`
- Key : `log[/var/log/centralized/linux/web-int/2026-06-18.log]` (exemple pour un hôte précis ; répéter par fichier/hôte à surveiller, ou utiliser un item prototype avec découverte automatique des fichiers — voir D4)
- Type of information : `Log`
- Update interval : `30s`

Ce type d'item permet à Zabbix de lire en continu le contenu des fichiers de logs et de déclencher des triggers sur des motifs précis (ex : `ERROR`, `CRITICAL`, échec d'authentification).

### D3 — Exemple de trigger sur erreur critique

**Data collection → Triggers → Create trigger** :

- Name : `Erreur critique détectée dans les logs centralisés`
- Expression : `find(/syslog-central/log[/var/log/centralized/...],,"like","CRITICAL")=1`
- Severity : `High`

### D4 — Découverte automatique des fichiers (recommandé à grande échelle)

Plutôt que de créer un item par fichier/serveur à la main, une règle de découverte de bas niveau (LLD) basée sur `vfs.file.listing` ou un script externe parcourant `/var/log/centralized/*/*/` permet de générer automatiquement un item de log par serveur source détecté, ce qui évite la maintenance manuelle à chaque nouveau serveur ajouté à l'infrastructure.

### D5 — Vérification

Dans **Monitoring → Latest data**, filtrer sur l'hôte `syslog-central` → les entrées de log les plus récentes doivent apparaître avec leur horodatage, consultables directement dans l'interface Zabbix sans connexion SSH.

---

## PARTIE E — Vérification finale

1. `zabbix_get -s 172.16.64.x -k agent.ping` depuis le serveur Zabbix vers XTA-401 → doit répondre `1`.
2. Dans **Monitoring → Hosts**, vérifier que `XTA-401` et `syslog-central` apparaissent tous deux en vert (disponibilité `ZBX` verte).
3. Provoquer une erreur de test dans un fichier de log centralisé (`echo "TEST CRITICAL" >> /var/log/centralized/.../fichier.log`) → vérifier que le trigger D3 se déclenche dans **Monitoring → Problems** dans la minute suivante.
