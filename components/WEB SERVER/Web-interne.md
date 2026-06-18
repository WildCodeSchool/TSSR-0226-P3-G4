#### Cette documentation détaille la mise en place des deux serveurs web Apache2 de l'entreprise **XTech** : le portail web interne (VLAN WEB-INT) et le site web externe exposé en DMZ.

--------

## Vue d'ensemble

| Rôle           | VLAN ID  | Nom VLAN | OS         | Réseau            | Passerelle pfSense   | Exposition                          |
| -------------- | -------- | -------- | ---------- | ------------------ | --------------------- | ------------------------------------ |
| WEB-INT         | 50       | WEB-INT  | Debian 13  | `172.16.68.0/24`    | `172.16.68.254`        | Interne uniquement (tous VLAN dept) |
| WEB-EXT (DMZ)   | 100      | DMZ      | Debian 13  | `172.16.71.0/24`    | `172.16.71.254`        | Internet via NAT pfSense (80/443)   |

Les deux machines sont des VM Debian 13 distinctes, chacune raccordée à son propre sous-réseau VLAN sur le trunk pfSense (interface physique `em2`, assignée en tant qu'interface `OPT1` taggée `TRUNK`, dont sont ensuite dérivées les interfaces VLAN 50 et VLAN 100 — cf. PARTIE B et PARTIE C du document de configuration pfSense). Côté Proxmox, chaque VM doit avoir son adaptateur réseau sur le bridge du trunk (`vmbr400` ou équivalent) avec le **VLAN Tag** renseigné explicitement (`50` pour WEB-INT, `100` pour DMZ) — sans ce tag, la VM se retrouverait sur le VLAN natif (MGMT) et non sur le bon sous-réseau.

Conformément à la séparation Zero Trust définie dans le plan d'adressage : le serveur interne ne doit jamais être joignable depuis le WAN, et le serveur DMZ ne doit jamais initier de connexion vers le LAN interne (cf. règles F7/F8 du pare-feu).

### Chemin d'administration (SSH) — jamais en direct

Aucun de ces deux serveurs n'est administré directement depuis un poste client ou un poste admin. L'accès SSH passe obligatoirement par la chaîne **Bastion (VLAN 60, `172.16.69.0/24`) → Jump (VLAN 70, `172.16.70.0/24`) → serveur cible**, conformément aux règles F5/F6 :

- Un administrateur se connecte d'abord au Bastion (`172.16.69.x`).
- Depuis le Bastion, rebond autorisé vers le Jump (`172.16.70.x`) en SSH/RDP (règle F5 : Bastion → JUMP port `3389,22`).
- Depuis le Jump, rebond vers WEB-INT ou WEB-EXT en SSH (règle F6 : JUMP → any LAN port `3389,22`).

Aucune règle pare-feu n'autorise une connexion SSH directe depuis BASTION vers WEB-INT ou WEB-EXT : le Jump est le seul point de rebond final vers ces deux VM. Pour WEB-EXT spécifiquement (en DMZ), il n'existe **aucun chemin admin entrant** depuis le LAN — la DMZ n'a aucune règle d'entrée autorisée depuis BASTION/JUMP dans la configuration pare-feu actuelle (F7 ne couvre que les flux sortants de la DMZ vers AD et WAN). Si une administration SSH de WEB-EXT depuis le Jump est nécessaire, une règle complémentaire doit être ajoutée côté pare-feu : **Pass : Source `172.16.70.0/24` (JUMP) → Destination `172.16.71.0/24` (DMZ) port `22`** — à ajouter explicitement, elle ne fait pas partie des règles existantes listées dans F6/F7.

---

## PARTIE A — Installation de base (commune aux deux VM)

Sur chaque VM Debian 13 :

```bash
apt update && apt upgrade -y
apt install apache2 -y
systemctl enable apache2
systemctl start apache2
```

Vérification :

```bash
systemctl status apache2
```

Modules activés utiles :

```bash
a2enmod rewrite
a2enmod headers
a2enmod ssl
systemctl restart apache2
```

---

## PARTIE B — Serveur WEB-INT (portail interne)

### B1 — Configuration réseau

- VLAN ID : `50` (WEB-INT)
- IP statique : `172.16.68.10/24`
- Passerelle : `172.16.68.254` (pfSense, interface VLAN 50 — WEB-INT)
- DNS : `172.16.65.3` (AD, VLAN 10)
- Sur Proxmox : adaptateur réseau sur le bridge du trunk, **VLAN Tag = 50**

### B2 — Structure du vhost

```bash
mkdir -p /var/www/portail-interne
chown -R www-data:www-data /var/www/portail-interne
chmod -R 755 /var/www/portail-interne
```

Fichier `/etc/apache2/sites-available/portail-interne.conf` :

```apache
<VirtualHost *:80>
    ServerName portail.xtech.green
    DocumentRoot /var/www/portail-interne

    <Directory /var/www/portail-interne>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/portail-interne-error.log
    CustomLog ${APACHE_LOG_DIR}/portail-interne-access.log combined
</VirtualHost>
```

Activation :

```bash
a2ensite portail-interne.conf
a2dissite 000-default.conf
systemctl reload apache2
```

### B3 — Accès aux données dynamiques (GLPI / Zabbix)

Le portail interne va chercher des données sur APPS (`172.16.66.0/24`, ports 80/443) pour les afficher — flux déjà autorisé côté pare-feu (règle "WEBINT → APPS port 80,443" documentée dans la partie firewall, section finale "VLAN BACKUP et WEB-INT vides").

### B4 — Résolution DNS interne

Sur l'AD (`172.16.65.3`), enregistrement A :

```
portail.xtech.green   A   172.16.68.10
```

---

## PARTIE C — Serveur WEB-EXT (site externe en DMZ)

### C1 — Configuration réseau

- VLAN ID : `100` (DMZ)
- IP statique : `172.16.71.10/24`
- Passerelle : `172.16.71.254` (pfSense, interface VLAN 100 — DMZ)
- DNS : résolveur public (ou forward via pfSense), **jamais** l'AD interne directement en clair (cf. isolation DMZ)
- Sur Proxmox : adaptateur réseau sur le bridge du trunk, **VLAN Tag = 100**

### C2 — Structure du vhost

```bash
mkdir -p /var/www/site-externe
chown -R www-data:www-data /var/www/site-externe
chmod -R 755 /var/www/site-externe
```

Fichier `/etc/apache2/sites-available/site-externe.conf` :

```apache
<VirtualHost *:80>
    ServerName www.xtech.green
    DocumentRoot /var/www/site-externe

    <Directory /var/www/site-externe>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/site-externe-error.log
    CustomLog ${APACHE_LOG_DIR}/site-externe-access.log combined
</VirtualHost>
```

Activation :

```bash
a2ensite site-externe.conf
a2dissite 000-default.conf
systemctl reload apache2
```

### C3 — HTTPS (recommandé avant mise en prod réelle)

```bash
apt install certbot python3-certbot-apache -y
certbot --apache -d www.xtech.green
```

> Le renouvellement automatique passe par le timer `certbot.timer`, déjà actif après installation (`systemctl list-timers | grep certbot`).

### C4 — NAT entrant pfSense (rappel)

Le NAT côté pare-feu redirige le WAN vers cette VM uniquement sur les ports 80/443 (règle F8 — Pass NAT vers `172.16.71.x` ports `80,443`). Aucune autre porte d'entrée n'existe depuis Internet vers cette machine.

### C5 — Isolation stricte (rappel Zero Trust)

Ce serveur ne doit **jamais** initier de connexion vers le LAN interne, à l'exception du flux LDAPS vers l'AD sur le port `636` uniquement (déjà autorisé en F7, utilisé typiquement par un futur module d'authentification ou par iRedMail s'il est colocalisé). Toute tentative de connexion sortante vers un autre VLAN est bloquée par défaut.

---

## PARTIE D — Vérification finale

Depuis un poste client interne :

```bash
curl -I http://portail.xtech.green
```

→ doit répondre `200 OK`.

Depuis Internet (ou un poste hors LAN) :

```bash
curl -I http://www.xtech.green
```

→ doit répondre `200 OK`.

Depuis le serveur WEB-EXT (DMZ), test d'isolation :

```bash
curl -m 3 http://172.16.66.10
```

→ doit **échouer** (timeout), confirmant que la DMZ ne peut pas atteindre APPS.

Depuis le serveur WEB-INT, test d'accès APPS :

```bash
curl -I http://172.16.66.10
```

→ doit répondre, confirmant l'accès autorisé pour la récupération des données dynamiques.

