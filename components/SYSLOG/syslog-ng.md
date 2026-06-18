#### Cette documentation détaille la mise en place de la journalisation centralisée **syslog-ng** pour l'entreprise **XTech**, couvrant les serveurs Linux (Debian 13) et Windows (AD, fichiers, Server 2022), ainsi que la méthode pour prouver sur PRTG/Zabbix que les sauvegardes de logs sont bien effectuées.

--------

## Objectif

Centraliser **tous** les logs (Linux et Windows) sur un serveur syslog-ng unique situé sur le VLAN APPS, afin de :

- garder une trace unique et horodatée de tout ce qui se passe sur l'infrastructure,
- pouvoir détecter une panne de remontée de logs avant qu'elle ne devienne un problème de sécurité,
- prouver via PRTG ou Zabbix que la chaîne de collecte/sauvegarde fonctionne réellement, pas seulement qu'elle est "censée" fonctionner.

> **Statut** : aucune partie de cette journalisation n'est encore en place à ce jour. Ce document est donc un plan de mise en œuvre complet, à dérouler étape par étape.

---

## Vue d'ensemble de l'architecture cible

```
                     ┌─────────────────────────────┐
                     │   Serveur syslog-ng central   │
                     │   VLAN 20 - APPS - 172.16.66.x │
                     │   Port 514/UDP + 6514/TCP-TLS  │
                     └───────────────┬─────────────┘
                                     │
        ┌────────────────────────────┼────────────────────────────┐
        │                            │                            │
┌───────▼────────┐         ┌─────────▼─────────┐        ┌─────────▼─────────┐
│ WEB-INT (Deb13)  │         │ WEB-EXT (Deb13)     │        │ AD (Win Srv 2022)   │
│ VLAN 50 (.68.10)  │         │ VLAN 100 (.71.10)    │        │ VLAN 10 (.65.3)      │
└───────────────────┘         └────────────────────┘        └─────────────────────┘
        │                                                            │
┌───────▼─────────────────┐                              ┌──────────▼───────────┐
│ Fichiers XTS-417 (Win)    │                              │ Veeam (sauvegarde)     │
│ VLAN 20 - APPS (.66.x)     │                              │ VLAN 30 - BACKUP (.67.x)│
└────────────────────────────┘                              └────────────────────────┘
```

Le serveur syslog-ng central est placé sur **VLAN 20 — APPS** (`172.16.66.0/24`, passerelle `172.16.66.254`), conformément au plan d'adressage existant (GLPI, Zabbix, Syslog, CORE sont colocalisés sur ce VLAN).

> Précision importante : XTS-417 (serveur de fichiers) et le futur serveur syslog-ng central sont tous deux sur le **même VLAN 20 (APPS)**, mais ce n'est pas le cas de l'AD (VLAN 10, `172.16.65.0/24`) ni des serveurs WEB-INT (VLAN 50) et WEB-EXT (VLAN 100). Chaque flux vers le port syslog franchit donc une frontière inter-VLAN et doit être explicitement autorisé au pare-feu (cf. PARTIE C4 et PARTIE G ci-dessous) — rien n'est ouvert par défaut entre VLAN.

---

## PARTIE A — Installation du serveur syslog-ng central (Debian 13, VLAN APPS)

### A1 — Installation

```bash
apt update
apt install syslog-ng syslog-ng-core -y
systemctl enable syslog-ng
```

### A2 — Configuration réseau

- VLAN ID : `20` (APPS)
- IP : `172.16.66.20/24` (à ajuster selon votre plan d'adressage interne d'APPS, libre dans la plage non réservée par DHCP)
- Passerelle : `172.16.66.254`

### A2bis — Chemin d'administration (rappel Zero Trust)

Comme tout serveur APPS, l'administration SSH de ce serveur ne se fait jamais en direct depuis un poste client : le chemin obligatoire est **Bastion (VLAN 60, `172.16.69.0/24`) → Jump (VLAN 70, `172.16.70.0/24`) → APPS port 22**, conformément aux règles F5 (Bastion → APPS port `3389,22`) déjà en place.

### A3 — Configuration de réception (`/etc/syslog-ng/conf.d/receive.conf`)

```cfg
source s_network_udp {
    network(
        ip("0.0.0.0")
        port(514)
        transport("udp")
    );
};

source s_network_tcp_tls {
    network(
        ip("0.0.0.0")
        port(6514)
        transport("tls")
        tls(
            key-file("/etc/syslog-ng/cert.d/server-key.pem")
            cert-file("/etc/syslog-ng/cert.d/server-cert.pem")
        )
    );
};

destination d_linux {
    file("/var/log/centralized/linux/${HOST}/${YEAR}-${MONTH}-${DAY}.log"
        create-dirs(yes)
    );
};

destination d_windows {
    file("/var/log/centralized/windows/${HOST}/${YEAR}-${MONTH}-${DAY}.log"
        create-dirs(yes)
    );
};

log {
    source(s_network_udp);
    source(s_network_tcp_tls);
    filter { host("XTS-417") or host("AD-XTECH") or netmask("172.16.65.0/24"); };
    destination(d_windows);
};

log {
    source(s_network_udp);
    source(s_network_tcp_tls);
    filter { not (host("XTS-417") or host("AD-XTECH")); };
    destination(d_linux);
};
```

> Le filtre Windows ne couvre que le VLAN 10 (AD, `172.16.65.0/24`) et les hôtes nommés explicitement (`XTS-417` sur APPS, `AD-XTECH`). Le VLAN 52 — DSI (`172.16.83.0/24`) n'a volontairement **pas** été inclus dans ce filtre : DSI est un VLAN "Isolé renforcé" au même titre que RH/FINANCE/JURIDIQUE/DIRECTION, et ses éventuels postes Windows ne sont pas génériquement des serveurs à journaliser de la même façon — si vous avez des serveurs Windows sur DSI à remonter, ajoutez `or netmask("172.16.83.0/24")` explicitement après l'avoir décidé, plutôt que par défaut.

> Le TLS (port 6514) est recommandé pour le flux Windows car il transite potentiellement des informations sensibles (authentification, accès fichiers RH/Finance). Le port 514/UDP en clair peut rester pour les flux Linux non sensibles, à votre discrétion.

Génération rapide d'un certificat auto-signé pour démarrer (à remplacer par une PKI interne si vous en avez une) :

```bash
mkdir -p /etc/syslog-ng/cert.d
openssl req -x509 -newkey rsa:2048 -keyout /etc/syslog-ng/cert.d/server-key.pem \
    -out /etc/syslog-ng/cert.d/server-cert.pem -days 365 -nodes \
    -subj "/CN=syslog.xtech.green"
systemctl restart syslog-ng
```

### A4 — Vérification de l'écoute

```bash
ss -tulnp | grep -E "514|6514"
```

---

## PARTIE B — Côté Linux (WEB-INT VLAN 50, WEB-EXT VLAN 100) : envoi vers le serveur central

Sur **chaque** VM Debian 13 (WEB-INT `172.16.68.10` et WEB-EXT `172.16.71.10`), syslog-ng est déjà présent par défaut sous Debian (sinon `apt install syslog-ng`). On ajoute simplement une destination de transfert vers le serveur central sur VLAN 20 — APPS.

Fichier `/etc/syslog-ng/conf.d/forward.conf` :

```cfg
destination d_syslog_central {
    network(
        "172.16.66.20"
        port(514)
        transport("udp")
    );
};

log {
    source(s_src);          # source par défaut Debian (déjà définie dans syslog-ng.conf)
    destination(d_syslog_central);
};
```

```bash
systemctl restart syslog-ng
```

### B1 — Inclure les logs Apache2 dans le flux

Sur WEB-INT et WEB-EXT, rediriger Apache vers syslog plutôt que (ou en plus de) ses fichiers locaux :

```apache
ErrorLog "|/usr/bin/logger -t apache-error -p local1.err"
CustomLog "|/usr/bin/logger -t apache-access -p local1.info" combined
```

> Alternative plus simple : laisser Apache écrire dans ses fichiers `.log` habituels et faire lire ces fichiers par syslog-ng via une source `file()` dédiée — à privilégier si vous voulez garder les logs Apache lisibles localement en plus de leur remontée centralisée.

---

## PARTIE C — Côté Windows (AD, fichiers XTS-417, Server 2022) : à mettre en place

Windows ne parle pas syslog nativement. Deux approches possibles ; recommandation : **NXLog** (léger, gratuit en version Community, fiable).

### C1 — Installation de NXLog sur chaque serveur Windows (AD + XTS-417)

1. Télécharger NXLog Community Edition depuis le site officiel.
2. Installer en tant que service Windows.
3. Configurer `C:\Program Files\nxlog\conf\nxlog.conf` :

```nxlog
define ROOT C:\Program Files\nxlog
Moduledir %ROOT%\modules
CacheDir %ROOT%\data
Pidfile %ROOT%\data\nxlog.pid
SpoolDir %ROOT%\data

<Extension syslog>
    Module xm_syslog
</Extension>

<Input eventlog>
    Module im_msvistalog
    # Capture les journaux Sécurité, Système, Application
</Input>

<Input customlogs>
    Module im_file
    File 'C:\Logs\*.log'
    SavePos TRUE
    Recursive FALSE
</Input>

<Output out_syslog>
    Module om_udp
    Host 172.16.66.20
    Port 514
    Exec to_syslog_bsd();
</Output>

<Route eventlog_to_central>
    Path eventlog => out_syslog
</Route>

<Route customlogs_to_central>
    Path customlogs => out_syslog
</Route>
```

> Le bloc `<Input customlogs>` permet de remonter directement le contenu de `C:\Logs\*.log` (les 4 scripts PowerShell, cf. doc dédiée) vers syslog-ng, sans étape intermédiaire. C'est la jonction entre les deux documents.

4. Démarrer le service :

```powershell
Start-Service nxlog
Set-Service nxlog -StartupType Automatic
```

### C2 — Cas particulier du serveur AD (Windows Event Forwarding, alternative à NXLog)

Si vous préférez rester 100 % natif Microsoft plutôt que d'installer NXLog, Windows Event Forwarding (WEF) est possible mais nécessite un collecteur WEC Windows intermédiaire — ce qui ajoute une brique Windows supplémentaire avant de retomber sur syslog. **NXLog reste la solution la plus directe** pour atteindre un serveur syslog-ng Linux, c'est l'option recommandée ci-dessus.

### C3 — Pare-feu Windows

Autoriser le trafic sortant UDP/514 (et TCP/6514 si TLS) vers `172.16.66.20` :

```powershell
New-NetFirewallRule -DisplayName "NXLog vers syslog-ng" -Direction Outbound `
    -Protocol UDP -RemotePort 514 -RemoteAddress 172.16.66.20 -Action Allow
```

### C4 — Règles pare-feu pfSense à ajouter (aucune n'existe actuellement pour le flux syslog)

En relisant les règles F2 à F9 déjà en place, **aucune n'autorise explicitement le port syslog (514/UDP ou 6514/TCP) vers APPS**. Les règles existantes couvrent DNS (53), Kerberos/LDAP (88,389,445,464), HTTP/HTTPS (80,443) — il faut ajouter une règle dédiée par VLAN source :

| VLAN source                     | Réseau               | Règle à ajouter                                                        |
| --------------------------------- | ----------------------- | --------------------------------------------------------------------------- |
| AD (VLAN 10)                       | `172.16.65.0/24`         | Pass : Source `172.16.65.0/24` → Destination `172.16.66.20` port `514,6514` |
| WEB-INT (VLAN 50)                  | `172.16.68.0/24`         | Pass : Source `172.16.68.0/24` → Destination `172.16.66.20` port `514`      |
| DMZ / WEB-EXT (VLAN 100)            | `172.16.71.0/24`         | Pass : Source `172.16.71.0/24` → Destination `172.16.66.20` port `514`      |

> Attention pour la règle DMZ : la politique d'isolation stricte définie en F7 n'autorise aujourd'hui que les flux DMZ → AD (port 636) et DMZ → WAN. Une règle DMZ → APPS (même limitée au seul port syslog) est une **ouverture supplémentaire** de l'isolation DMZ qui doit être validée consciemment : un serveur compromis en DMZ pourrait potentiellement utiliser ce canal pour exfiltrer des données déguisées en trafic syslog vers APPS. Si cette règle est ajoutée, il est recommandé de la restreindre strictement au port 514 vers l'IP unique du serveur syslog (`172.16.66.20/32`), jamais vers `172.16.66.0/24` en entier, et d'envisager un filtrage applicatif (le syslog-ng central peut rejeter tout message ne respectant pas le format RFC 5424 attendu).

---

## PARTIE D — Sauvegarde Veeam des dossiers/fichiers (Server 2022) : à mettre en place

Le serveur Veeam existant sauvegarde le serveur de fichiers Windows Server 2022 (XTS-417), mais ce job n'est pas encore configuré. Étapes minimales :

1. Dans la console Veeam, créer un **Backup Job** de type "File Backup" ou "Volume Backup" ciblant XTS-417 (les partages `Partage_individuel`, `Partage_service`, `Partage_departement`).
2. Planifier le job (ex : quotidien à 22h00).
3. Définir une destination de stockage sur le VLAN BACKUP (`172.16.67.0/24` — BKP Linux RAID5 ou repository Veeam dédié).
4. Activer la notification d'échec par e-mail (ou, mieux, faire remonter le statut du job vers syslog-ng — voir partie E).

> Une fois ce job actif, **chaque exécution Veeam doit elle aussi logger son résultat** (succès/échec) de manière vérifiable, sinon on retombe sur le même problème : on suppose que ça marche sans preuve. C'est l'objet de la partie suivante.

---

## PARTIE E — Prouver sur PRTG ou Zabbix que les logs et sauvegardes sont bien faits

C'est le point central de cette demande : il ne suffit pas de configurer la collecte, il faut une **preuve continue et automatisée** que la chaîne fonctionne. Trois mécanismes complémentaires, du plus simple au plus complet.

### E1 — Méthode 1 : surveillance de fraîcheur de fichier (la plus simple, à faire en premier)

Principe : si syslog-ng reçoit bien des logs, le fichier du jour grossit ou se met à jour régulièrement. Si un serveur arrête de remonter ses logs, son fichier arrête d'être modifié — c'est détectable immédiatement.

**Sur Zabbix**, agent installé sur le serveur syslog-ng central :

```bash
# Item Zabbix de type "Zabbix agent" avec la clé :
vfs.file.time[/var/log/centralized/windows/XTS-417/{$DATE}.log,modify]
```

Trigger associé :

```
Dernière modification du fichier > 900 secondes (15 min) => Warning
Dernière modification du fichier > 3600 secondes (1h) => Critical
```

Cela revient à dire : "si XTS-417 n'a pas envoyé un seul log en 15 minutes, c'est suspect ; en 1h, c'est une panne confirmée."

**Sur PRTG**, capteur équivalent : **"Folder"** ou **"File"** sensor, pointé sur le fichier du jour, avec seuil sur `LastWriteTime`.

### E2 — Méthode 2 : "heartbeat" applicatif (preuve active, pas seulement passive)

Plutôt que de déduire indirectement que ça marche (méthode E1), on **force chaque source à envoyer un message de preuve volontaire**, toutes les X minutes :

Côté Linux (cron sur chaque serveur source) :

```bash
*/10 * * * * logger -p local1.info "HEARTBEAT $(hostname) $(date +%s)"
```

Côté Windows (tâche planifiée PowerShell, écrit dans `C:\Logs\heartbeat.log`, donc déjà repris par NXLog) :

```powershell
$msg = "HEARTBEAT $(hostname) $(Get-Date -Format yyyy-MM-ddTHH:mm:ss)"
Add-Content -Path "C:\Logs\heartbeat.log" -Value $msg
```

Côté Zabbix : un script de vérification interroge le fichier centralisé et compte le nombre de heartbeats reçus par hôte sur les 15 dernières minutes via `zabbix_sender` ou un script externe (`UserParameter`) :

```bash
# /etc/zabbix/zabbix_agentd.conf.d/heartbeat.conf
UserParameter=syslog.heartbeat.count[*],grep -c "HEARTBEAT $1" /var/log/centralized/*/$1/$(date +%Y-%m-%d).log 2>/dev/null || echo 0
```

Trigger : si le compteur de heartbeats d'un hôte tombe à 0 sur la fenêtre attendue → alerte. C'est la preuve la plus fiable car elle ne dépend pas d'une déduction, elle teste directement "le flux de bout en bout fonctionne-t-il en ce moment".

### E3 — Méthode 3 : preuve de la sauvegarde Veeam elle-même

Une fois le job Veeam de la partie D actif, faire écrire son statut de fin de job dans un fichier ou syslog, pour qu'il rentre dans le même système de preuve :

```powershell
# Script post-job Veeam (configuré dans les options avancées du job, "Run the following script after the job")
$status = Get-VBRBackupSession | Sort-Object CreationTime -Descending | Select-Object -First 1
$line = "$(Get-Date -Format yyyy-MM-dd HH:mm:ss) [VEEAM] Job='$($status.Name)' Result='$($status.Result)'"
Add-Content -Path "C:\Logs\veeam-status.log" -Value $line
```

Ce fichier `veeam-status.log` est repris par NXLog comme les autres (partie C1), donc remonte automatiquement vers syslog-ng et devient surveillable par Zabbix/PRTG exactement comme un heartbeat — un item Zabbix de type "log monitor" cherchant la chaîne `Result='Success'` dans les dernières 24h suffit comme preuve :

```
Item Zabbix : log["C:\Logs\veeam-status.log","Result='Success'"]
Trigger : si aucune occurrence sur les dernières 24h => Critical (la sauvegarde n'a pas tourné ou a échoué)
```

### E4 — Tableau de bord récapitulatif (Zabbix ou PRTG)

| Preuve à afficher                                 | Source                          | Méthode               |
| --------------------------------------------------- | ---------------------------------- | ------------------------ |
| Logs Linux WEB-INT/WEB-EXT reçus dans les 15 min      | `/var/log/centralized/linux/...`    | E1 (fraîcheur fichier)   |
| Logs Windows AD/XTS-417 reçus dans les 15 min          | `/var/log/centralized/windows/...`  | E1 + E2 (heartbeat)       |
| Scripts PowerShell (C:\Logs) bien remontés            | Fichier `C:\Logs\*.log` côté agent  | E2 (heartbeat)            |
| Sauvegarde Veeam du jour réussie                       | `C:\Logs\veeam-status.log`          | E3 (statut post-job)      |

> Une fois ces 4 lignes vertes en permanence sur le dashboard Zabbix/PRTG, vous avez une preuve continue — pas une supposition — que la chaîne complète (scripts → logs → syslog-ng → sauvegarde) fonctionne.

---

## PARTIE F — Vérification finale de bout en bout

1. Générer un événement de test sur WEB-INT : `logger "TEST WEB-INT depuis Apache"`.
2. Générer un événement de test sur XTS-417 via PowerShell : `Add-Content C:\Logs\Script2-CreationDossiers.log "TEST manuel"`.
3. Sur le serveur syslog-ng central, vérifier l'arrivée :
   ```bash
   tail -f /var/log/centralized/linux/*/$(date +%Y-%m-%d).log
   tail -f /var/log/centralized/windows/*/$(date +%Y-%m-%d).log
   ```
4. Vérifier dans Zabbix/PRTG que l'item de fraîcheur correspondant repasse au vert immédiatement après ce test.

Cette dernière étape valide que toute la chaîne (source → réseau → syslog-ng → supervision) est opérationnelle, et pas uniquement que chaque brique individuelle est démarrée.

