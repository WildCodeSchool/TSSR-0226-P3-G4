#### Cette documentation détaille la mise en place du serveur de messagerie **iRedMail** en DMZ, la configuration des clients **Thunderbird**, et la synchronisation des comptes avec l'Active Directory pour l'entreprise **XTech**.

--------

## Vue d'ensemble

| Élément          | Détail                                                              |
| ----------------- | ----------------------------------------------------------------- |
| Serveur iRedMail   | VLAN DMZ (100), `172.16.71.x`                                       |
| Authentification    | LDAPS vers AD (`172.16.65.3`), port `636` uniquement (jamais 389)    |
| Client mail         | Thunderbird, déployé sur les postes utilisateurs                    |
| Synchronisation AD  | Comptes/mots de passe alignés sur l'annuaire, pas de base séparée  |

L'isolation réseau d'iRedMail suit strictement la règle F7 du pare-feu : seul le port `636` (LDAPS) est ouvert entre la DMZ et l'AD, et uniquement vers l'IP précise `172.16.65.3`, jamais en LDAP clair (389).

### Chemin d'administration (rappel Zero Trust)

Comme pour le serveur WEB-EXT (même VLAN 100), **aucune règle pare-feu existante n'autorise une connexion SSH entrante vers la DMZ** depuis BASTION ou JUMP. Les règles F5/F6 couvrent Bastion → AD/APPS/BACKUP/JUMP, mais pas Bastion ou Jump → DMZ. Si l'administration en SSH de ce serveur iRedMail est nécessaire (et elle le sera), une règle complémentaire doit être ajoutée explicitement :

- Pass : Source `172.16.70.0/24` (JUMP) → Destination `172.16.71.0/24` (DMZ) port `22`

Cette règle reste cohérente avec le modèle Bastion → Jump → cible : l'administrateur passe par Bastion puis Jump, et c'est uniquement depuis le Jump que le dernier saut vers la DMZ est autorisé — jamais de Bastion directement vers DMZ.

---

## PARTIE A — Installation d'iRedMail

### A1 — Pré-requis serveur

- VM dédiée en DMZ, `172.16.71.x`
- Hostname résolvable : `mail.xtech.green`
- Enregistrements DNS publics nécessaires (gérés en externe ou via votre zone DNS publique) :
  - `A` : `mail.xtech.green` → IP publique NATée vers `172.16.71.x`
  - `MX` : `xtech.green` → `mail.xtech.green`
  - `SPF`, `DKIM`, `DMARC` : à configurer pour la délivrabilité (recommandé, non bloquant pour le fonctionnement interne)

### A2 — Installation

```bash
wget https://github.com/iredmail/iRedMail/archive/refs/tags/<version>.tar.gz
tar zxvf <version>.tar.gz
cd iRedMail-<version>
bash iRedMail.sh
```

Pendant l'installation :
- Domaine mail : `xtech.green`
- Backend choisi : **OpenLDAP** par défaut dans iRedMail, mais puisque l'authentification doit s'appuyer sur l'AD existant (cf. partie C), prévoir l'intégration LDAP externe plutôt que de dupliquer les comptes dans l'annuaire OpenLDAP interne d'iRedMail.

### A3 — Ports exposés en NAT (rappel pare-feu F8)

- `25` (SMTP), `587` (soumission), `443` (webmail si activé) — NAT entrant pfSense déjà couvert par la règle F8.
- Pas d'autre port ouvert depuis le WAN.

---

## PARTIE B — Authentification LDAPS vers l'AD

### B1 — Pourquoi LDAPS et pas LDAP

Le flux DMZ → AD est volontairement restreint au port `636` (LDAPS, chiffré) et jamais au port `389` (LDAP en clair), car la DMZ est la zone la plus exposée du réseau : si ce serveur est compromis depuis Internet, un flux LDAP en clair exposerait les échanges d'authentification en texte lisible vers l'AD. Le LDAPS chiffre ce flux de bout en bout.

### B2 — Activation de LDAPS côté AD

Sur le contrôleur de domaine (`172.16.65.3`), LDAPS nécessite un certificat installé sur le service AD CS (Active Directory Certificate Services) ou un certificat tiers importé dans le magasin de certificats de l'ordinateur, avec le rôle "Server Authentication".

Vérification que LDAPS écoute bien :

```powershell
Test-NetConnection -ComputerName 172.16.65.3 -Port 636
```

### B3 — Configuration côté iRedMail (Postfix/Dovecot en LDAP externe)

Fichier `/etc/postfix/ldap/*.cf` (exemple pour la table des utilisateurs) :

```ini
server_host = ldaps://172.16.65.3:636
search_base = OU=Utilisateurs,DC=xtech,DC=green
bind_dn = CN=svc-iredmail,OU=ServiceAccounts,DC=xtech,DC=green
bind_pw = <mot_de_passe_compte_service>
query_filter = (&(objectClass=user)(mail=%s))
result_attribute = mail
```

Fichier équivalent côté Dovecot (`/etc/dovecot/dovecot-ldap.conf.ext`) :

```ini
hosts = 172.16.65.3:636
tls = yes
dn = CN=svc-iredmail,OU=ServiceAccounts,DC=xtech,DC=green
dnpass = <mot_de_passe_compte_service>
ldap_version = 3
base = OU=Utilisateurs,DC=xtech,DC=green
auth_bind = yes
```

> Créer un compte de service dédié dans l'AD (`svc-iredmail`), en lecture seule sur l'OU des utilisateurs, plutôt que d'utiliser un compte administrateur — principe de moindre privilège.

### B4 — Test de connexion LDAPS

```bash
ldapsearch -H ldaps://172.16.65.3:636 -D "CN=svc-iredmail,OU=ServiceAccounts,DC=xtech,DC=green" \
    -W -b "OU=Utilisateurs,DC=xtech,DC=green" "(mail=*)"
```

→ doit retourner la liste des utilisateurs disposant d'un attribut `mail` renseigné dans l'AD.

---

## PARTIE C — Synchronisation des comptes avec l'AD

### C1 — Principe retenu

Plutôt que de créer manuellement chaque boîte mail dans iRedMail, on s'appuie sur l'attribut `mail` déjà présent (ou à compléter) sur les 218 comptes utilisateurs AD. iRedMail authentifie via LDAPS (partie B) ; la création des boîtes peut être automatisée par script à partir de l'export AD.

### C2 — Script de synchronisation (exécuté côté AD ou serveur d'administration)

```powershell
$LogFile = "C:\Logs\Script-SyncIredmail.log"
function Write-Log { param($m) Add-Content -Path $LogFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $m" }

$users = Get-ADUser -Filter * -SearchBase "OU=Utilisateurs,DC=xtech,DC=green" -Properties Mail, SamAccountName

foreach ($user in $users) {
    if (-not $user.Mail) {
        $mail = "$($user.SamAccountName)@xtech.green"
        Set-ADUser -Identity $user.SamAccountName -EmailAddress $mail
        Write-Log "Attribut mail ajouté pour $($user.SamAccountName) : $mail"
    }
}

Write-Log "Synchronisation terminée : $($users.Count) comptes traités"
```

> Ce script complète l'attribut `mail` pour tout compte AD qui ne l'aurait pas encore — pré-requis pour que la recherche LDAP côté iRedMail (partie B3, filtre `mail=%s`) trouve bien chaque utilisateur. Le log de ce script suit la même convention que les 4 scripts existants (cf. doc centralisation des logs) et peut être déposé dans `C:\Logs` pour remonter automatiquement vers syslog-ng une fois NXLog en place.

### C3 — Changement de mot de passe

Le mot de passe de messagerie est le **même** que le mot de passe AD puisque l'authentification passe par LDAPS en temps réel (bind direct), sans copie locale du mot de passe côté iRedMail. Un changement de mot de passe AD est donc immédiatement effectif pour la messagerie, sans script de synchronisation supplémentaire.

---

## PARTIE D — Déploiement Thunderbird sur les postes clients

### D1 — Installation

Déploiement via GPO (package MSI) ou installation manuelle Thunderbird, selon votre méthode de distribution logicielle existante.

### D2 — Configuration automatique du compte (fichier autoconfig)

Pour éviter une configuration manuelle par 218 utilisateurs, un fichier d'autoconfiguration côté DNS/serveur évite la saisie des paramètres serveur :

Fichier `autoconfig.xtech.green` exposé en HTTPS sur le serveur mail, chemin `/.well-known/autoconfig/mail/config-v1.1.xml` :

```xml
<?xml version="1.0"?>
<clientConfig version="1.1">
  <emailProvider id="xtech.green">
    <domain>xtech.green</domain>
    <displayName>XTech Mail</displayName>
    <incomingServer type="imap">
      <hostname>mail.xtech.green</hostname>
      <port>993</port>
      <socketType>SSL</socketType>
      <authentication>password-cleartext</authentication>
      <username>%EMAILLOCALPART%</username>
    </incomingServer>
    <outgoingServer type="smtp">
      <hostname>mail.xtech.green</hostname>
      <port>587</port>
      <socketType>STARTTLS</socketType>
      <authentication>password-cleartext</authentication>
      <username>%EMAILLOCALPART%</username>
    </outgoingServer>
  </emailProvider>
</clientConfig>
```

Avec ce fichier en place, Thunderbird détecte automatiquement les paramètres dès que l'utilisateur saisit son adresse `prenom.nom@xtech.green` et son mot de passe AD — aucune configuration manuelle serveur par serveur côté utilisateur final.

### D3 — Vérification

Sur un poste de test, ouvrir Thunderbird, ajouter le compte avec l'adresse mail de l'utilisateur et son mot de passe AD :

→ Thunderbird doit détecter automatiquement IMAP/SMTP via le fichier autoconfig et se connecter sans message d'erreur de certificat (si le certificat du serveur mail est valide).

---

## PARTIE E — Vérification finale de bout en bout

1. Sur l'AD, vérifier qu'un utilisateur test dispose bien de l'attribut `mail` : `Get-ADUser jdupont -Properties Mail`.
2. Tester la connexion LDAPS depuis iRedMail (partie B4).
3. Se connecter avec Thunderbird en utilisant le mot de passe AD de cet utilisateur test.
4. Changer le mot de passe AD de l'utilisateur test, puis reconnecter Thunderbird avec le nouveau mot de passe → doit fonctionner immédiatement sans étape de synchronisation manuelle, confirmant le bind LDAPS en temps réel.
5. Vérifier dans les logs Postfix/Dovecot (`/var/log/mail.log` sur le serveur iRedMail) qu'aucune tentative de connexion LDAP en clair (port 389) n'apparaît — seul le port 636 doit être utilisé, conformément à la règle pare-feu F7.

