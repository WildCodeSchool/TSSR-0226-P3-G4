#### Cette documentation détaille la configuration complète de l'infrastructure réseau, du plan d'adressage et de la politique de filtrage Zero Trust sur le pare-feu pfSense pour l'entreprise **XTech**.

--------

## Réseau Xtech : `172.16.64.0/19`

**Plage couverte : `172.16.64.0` → `172.16.95.255` (32 sous-réseaux en `/24` `.64` à `.95`)**

### Plan d'adressage  — 24 départements de l'entreprise

| VLAN ID | Nom              | Réseau /24       | Passerelle pfSense | Rôle                                 |
| ------- | ---------------- | ---------------- | ------------------ | ------------------------------------ |
| 10      | AD               | `172.16.65.0/24` | `172.16.65.254`    | DC, DNS, DHCP                        |
| 20      | APPS             | `172.16.66.0/24` | `172.16.66.254`    | GLPI, Zabbix, Syslog, CORE, Fichiers |
| 30      | BACKUP           | `172.16.67.0/24` | `172.16.67.254`    | BKP Linux RAID5, BKP Veeam           |
| 50      | WEB-INT          | `172.16.68.0/24` | `172.16.68.254`    | Site web interne                     |
| 60      | BASTION          | `172.16.69.0/24` | `172.16.69.254`    | Bastion admin                        |
| 70      | JUMP             | `172.16.70.0/24` | `172.16.70.254`    | Jump server                          |
| 100     | DMZ              | `172.16.71.0/24` | `172.16.71.254`    | WEB externe, iRedMail                |
| 200     | VPN              | `172.16.72.0/24` | `172.16.72.254`    | Pool télétravail                     |
| 41      | RH               | `172.16.73.0/24` | `172.16.73.254`    | Isolé renforcé                       |
| 42      | COMMUNICATION    | `172.16.74.0/24` | `172.16.74.254`    | DEPT Standard                        |
| 43      | COMMERCIAL       | `172.16.75.0/24` | `172.16.75.254`    | DEPT Standard                        |
| 44      | FINANCE          | `172.16.76.0/24` | `172.16.76.254`    | Isolé renforcé                       |
| 45      | MARKETING        | `172.16.77.0/24` | `172.16.77.254`    | DEPT Standard                        |
| 46      | DÉVELOPPEMENT    | `172.16.78.0/24` | `172.16.78.254`    | DEPT Standard                        |
| 47      | R&D              | `172.16.79.0/24` | `172.16.79.254`    | DEPT Standard                        |
| 48      | SERVICE GENERAUX | `172.16.80.0/24` | `172.16.80.254`    | DEPT Standard                        |
| 49      | JURIDIQUE        | `172.16.81.0/24` | `172.16.81.254`    | Isolé renforcé                       |
| 51      | DIRECTION        | `172.16.82.0/24` | `172.16.82.254`    | Isolé renforcé                       |
| 52      | DSI              | `172.16.83.0/24` | `172.16.83.254`    | Isolé renforcé                       |
| 90      | WIFI-ENTREPRISE  | `172.16.84.0/24` | `172.16.84.254`    |                                      |
| 99      | WIFI-GUEST       | `172.16.85.0/24` | `172.16.85.254`    |                                      |
| 300     | MGMT-T0          | `172.16.86.0/24` | `172.16.86.254`    | LAN management T0                    |
| 301     | MGMT-T1          | `172.16.87.0/24` | `172.16.87.254`    | LAN management T1                    |
| 302     | MGMT-T2          | `172.16.88.254`  | `172.16.88.254`    | LAN management T2                    |


---






### Étape 1 — Reconfigurer le LAN de pfSense (em1)

Dans la **console**, menu principal → option `2` (Set interface IP address) :  

Enter the number of the interface you wish to configure: 2 (LAN)  
Configure IPv4 via DHCP? n  
Enter the new LAN IPv4 address: 172.16.64.254  
Subnet bit count: 24  
Upstream gateway: ENTRÉE    
IPv6 ? n  
Enable DHCP server on LAN? n  
Revert to HTTP? n  

<img width="998" height="426" alt="pfSense-LAN" src="https://github.com/user-attachments/assets/bcfa4a82-7967-4ca1-b303-a5c2f90c71ab" />

### Étape 2 — Reconnecter ton PC admin

**Sur Proxmox**, VM 403 → Hardware → Network Device (net0) :

- Bridge :  `vmbr400`
- VLAN Tag : **vide** 

Puis sur le PC admin (Windows), IP statique : 172.16.64.10/24`, passerelle `172.16.64.254`

### Étape 3 — Accéder à ton nouveau pfSense

```
https://172.16.64.254
```

 <img width="1910" height="1059" alt="image" src="https://github.com/user-attachments/assets/595c2568-c804-4a70-856a-5cae90ed381d" />

 ---


### Setup Wizard pfSense

- **Bienvenue** → Next

<img width="1842" height="681" alt="Capture d&#39;écran 2026-07-02 202122" src="https://github.com/user-attachments/assets/cd5a2926-7a43-40c9-ac43-c2f098682e71" />

---

- **General Information** :
    - Hostname : `pfSense-XTech`
    - Domain : `xtech.green`
    - DNS Server 1 : vide pour l'instant (pas encore de WAN fonctionnel, à configur après que l'AD soit raccordé)
    - Décocher **"Override DNS"** pour forcer les DNS
 
<img width="1676" height="1011" alt="image" src="https://github.com/user-attachments/assets/c2d75daf-c2a6-4a6e-9b91-19bb75e08002" />

---
    
- **Time Server** : Timezone `Europe/Paris`


<img width="1706" height="516" alt="image" src="https://github.com/user-attachments/assets/5023e164-9d7e-4ca5-a0c6-a24cea2bb36f" />

---



- **WAN Configuration** :
    - Type : `Static` (On utilise le DHCP du serveur AD sinon les pc seront en APIPA (169.254.x.x)
    - IP Adress : 10.0.0.4 (WAN)
    - Subnet Mask : 28
 
<img width="1675" height="989" alt="image" src="https://github.com/user-attachments/assets/71e4f25c-d32a-4756-a0df-b50539b079ff" />

---


 - pptplocalsubnet : 32
 - Décocher "Block private networks" **temporairement** si jamais le WAN passe par une IP privée (`10.0.0.4/8`) — sinon pfSense bloquera notre propre WAN
 - Décocher "Block bogon networks" 

    
<img width="1660" height="803" alt="image" src="https://github.com/user-attachments/assets/867d00c9-54e5-4b62-a4b2-5d4452526030" />

---

- **LAN Configuration** :
    - IP : `172.16.64.254`
    - Subnet : `24`

<img width="1717" height="520" alt="image" src="https://github.com/user-attachments/assets/30dfb898-d887-42f9-9e89-548a12ed81c1" />

---


    
- **Set Admin Password** : `******`
- **Reload** → **Finish**

<img width="1694" height="492" alt="image" src="https://github.com/user-attachments/assets/8ab81a97-3c72-440d-a1e8-9b4342a79424" />

---
  
## PARTIE A — Fixer le WAN (accès internet)

**Interfaces → WAN**

- **IPv4 Configuration Type** : `Static IPv4`
- **IPv4 Address** : `10.0.0.4` / `28`
- **IPv4 Upstream Gateway** : **Add a new gateway** → Name: `WANGW`, Gateway: `10.0.0.1` → Save
- Décocher **"Block private networks"** (sinon pfSense bloque notre propre WAN privé)
- Décocher **"Block bogon networks"**
- **Save** → **Apply Changes**

**Status → Gateways** pour vérifier que `WANGW` est en vert (online).

**Status → Interfaces → WAN** : `10.0.0.4/28`.

**Diagnostics → Ping** : ping `10.0.0.1` (la passerelle du formateur). Le WAN est fonctionnel.

---

## PARTIE B — Assigner OPT1 (em2 → trunk VLAN)

**Interfaces → Assignments**

Clique sur la nouvelle ligne **OPT1** :

- Enable interface
- Description : `TRUNK`
- IPv4 Configuration Type : `None`
- **Save** → **Apply Changes**

---

## PARTIE C — Créer les 24 VLANs

**Interfaces → VLANs → Add**, répète pour chaque ligne ci-dessous (Parent interface = `em2 (TRUNK)` à chaque fois) :


## PARTIE D — Assigner chaque VLAN comme interface + IP

 **Interfaces → Assignments** : 19 VLANs disponibles dans le menu déroulant en bas. **Add** chacun un par un (22 fois).

Pour CHAQUE interface créée (elles s'appelleront OPT2, OPT3... OPT20), configuration :

- Enable
- Description : nom du VLAN (ex: `AD`, `APPS`...)
- IPv4 Configuration Type : `Static IPv4`
- IPv4 Address : selon le tableau ci-dessous

| VLAN | Description     | IPv4 Address                                                                                       |
| ---- | --------------- | -------------------------------------------------------------------------------------------------- |
| 10   | AD              | `172.16.65.254/24`                                                                                 |
| 20   | APPS            | `172.16.66.254/24`                                                                                 |
| 30   | BACKUP          | `172.16.67.254/24`                                                                                 |
| 50   | WEB-INT         | `172.16.68.254/24`                                                                                 |
| 60   | BASTION         | `172.16.69.254/24`                                                                                 |
| 70   | JUMP            | `172.16.70.254/24`                                                                                 |
| 100  | DMZ             | `172.16.71.254/24`                                                                                 |
| 200  | VPN             | `172.16.72.254/24`                                                                                 |
| 41   | RH              | `172.16.73.254/24`                                                                                 |
| 42   | COMMUNICATION   | `172.16.74.254/24`                                                                                 |
| 43   | COMMERCIAL      | `172.16.75.254/24`                                                                                 |
| 44   | FINANCE         | `172.16.76.254/24`                                                                                 |
| 45   | MARKETING       | `172.16.77.254/24`                                                                                 |
| 46   | PRODUCTION      | `172.16.78.254/24`                                                                                 |
| 47   | RD              | `172.16.79.254/24`                                                                                 |
| 48   | LOGISTIQUE      | `172.16.80.254/24`                                                                                 |
| 49   | JURIDIQUE       | `172.16.81.254/24`                                                                                 |
| 51   | DIRECTION       | `172.16.82.254/24`                                                                                 |
| 52   | DSI             | `172.16.83.254/24`                                                                                 |
| 90   | WIFI-ENTREPRISE | `172.16.84.254/24`                                                                                 |
| 99   | WIFI-GUEST      | `172.16.85.254/24`                                                                                 |
| 300  | MGMT-T0         | `172.16.86.0/24`                                                                                   |
| 301  | MGMT-T1         | `172.16.87.0/24`                                                                                   |
| 302  | MGMT-T2         | `172.16.88.254`                                                                                    |




<img width="1799" height="1120" alt="VLAN" src="https://github.com/user-attachments/assets/751c612b-2221-479d-8dac-8885e485cea1" />


## PARTIE E — DHCP par VLAN

**Important** : Le VLAN **AD** ne doit **pas** avoir de DHCP pfSense — c'est le serveur AD (`172.16.65.3`) qui doit faire le DHCP. Pour tous les **autres** VLAN, pfSense peut distribuer du DHCP (IP fixes pour les serveurs, DHCP juste pour les VLAN département/postes clients).

 **Services → DHCP Server**, pour chaque VLAN département (RH, COMMUNICATION, COMMERCIAL, FINANCE, MARKETING, PRODUCTION, RD, LOGISTIQUE, JURIDIQUE, DIRECTION, WIFIENTREPRISE) :

- Onglet du VLAN concerné (ex: `RH`)
- Enable DHCP server
- Range : `172.16.73.10` → `172.16.73.200` 
- DNS servers : `172.16.65.3` (AD, VLAN10)
- **Save**

**PAS de DHCP sur** : AD, APPS, BACKUP, WEBINT, BASTION, JUMP, DMZ, VPN, WIFIGUEST (DHCP plage courte ex `172.16.84.50-100`).

---

## PARTIE F — Règles de pare-feu 

C'est ici que se joue toute la logique Zero Trust. Principe général appliqué partout : **Deny All implicite en bas**, on **autorise explicitement** seulement ce qui est nécessaire, rien d'autre.

### F1 — Règle générale : bloquer tout l'inter-VLAN par défaut

pfSense bloque déjà par défaut tout trafic **entre interfaces différentes** s'il n'y a pas de règle explicite. Donc la base est déjà "Deny All" implicite. On ajoute des **autorisations ciblées**.

### F2 — VLAN DEPT (tous les départements) → Interfaces → [VLAN] → Firewall Rules

Pour CHAQUE VLAN département (RH, COMMUNICATION, etc.), créer ces règles dans l'ordre :

**Règle 1 — Autoriser DNS vers AD**

- Action: Pass / Protocol: TCP/UDP / Source: ce VLAN net / Destination: `172.16.65.3` / Port: `53`

**Règle 2 — Autoriser DHCP** (si pfSense gère, sinon ignorer)

- Déjà géré automatiquement par le service DHCP de pfSense

**Règle 3 — Autoriser auth Kerberos/LDAP vers AD**

- Action: Pass / Protocol: TCP/UDP / Source: ce VLAN net / Destination: `172.16.65.3` / Port: `88,389,445,464`

**Règle 4 — Autoriser accès WEB-INT**

- Action: Pass / Source: ce VLAN net / Destination: `172.16.68.0/24` / Port: `80,443`

**Règle 5 — Autoriser accès APPS (GLPI, Zabbix)**

- Action: Pass / Source: ce VLAN net / Destination: `172.16.66.0/24` / Port: `80,443`

**Règle 6 — Autoriser Internet (sortant uniquement)**

- Action: Pass / Source: ce VLAN net / Destination: `any` (WAN) / Port: `80,443,53`

**Règle finale implicite** : tout le reste est bloqué (comportement par défaut pfSense entre interfaces).


<img width="1195" height="1010" alt="COMMUNICATION" src="https://github.com/user-attachments/assets/ba846f1a-2ec5-40af-b90b-d5a99679e39a" />



### F3 — VLAN AD → Firewall Rules

**Règle 1 — Autoriser réponses vers tous les VLANs clients** (DNS/LDAP/Kerberos retour)

- Source: `172.16.65.0/24` / Destination: `any` / déjà couvert par "established/related" de pfSense par défaut, pas besoin de règle supplémentaire pour le retour

**Règle 2 — Autoriser AD → APPS** (sync GLPI/iRedMail)

- Action: Pass / Source: `172.16.65.0/24` / Destination: `172.16.66.0/24` / Port: `389,636`

**Règle finale** : Deny all vers DMZ, BASTION (sauf retour bastion qu'on configure en F5)


<img width="1803" height="988" alt="AD" src="https://github.com/user-attachments/assets/0999e8a1-702d-4437-89a0-eb3af6bbdc58" />


### F4 — VLAN APPS → Firewall Rules

- Pass : Source `172.16.66.0/24` → Destination `172.16.65.3` (AD) port `389,636,53` (sync GLPI/Zabbix vers AD)
- Pass : Source `172.16.66.0/24` → Destination `172.16.67.0/24` (BACKUP) port `22,3306` (rsync + mysqldump vers BKP)
- Pass : Source `172.16.66.0/24` → Destination WAN port `80,443` (mises à jour)
- Deny : tout le reste


<img width="1831" height="1005" alt="APPS" src="https://github.com/user-attachments/assets/6d0a6d75-45b6-4f14-8b14-8753f1608fc1" />


### F5 — VLAN BASTION → Firewall Rules (le pivot central)

C'est LE VLAN qui a le droit de parler à tout le LAN pour l'administration :

- Pass : Source `172.16.69.0/24` → Destination `172.16.65.0/24` (AD) port `3389,22`
- Pass : Source `172.16.69.0/24` → Destination `172.16.66.0/24` (APPS) port `3389,22`
- Pass : Source `172.16.69.0/24` → Destination `172.16.67.0/24` (BACKUP) port `22`
- Pass : Source `172.16.69.0/24` → Destination `172.16.70.0/24` (JUMP) port `3389,22`
- Deny : tout le reste (notamment DMZ — le bastion n'a pas accès direct DMZ)


<img width="1704" height="1001" alt="BASTION" src="https://github.com/user-attachments/assets/207668d3-92f8-43eb-8be2-f8fd87591d5e" />


### F6 — VLAN JUMP → Firewall Rules

- Pass : Source `172.16.70.0/24` → Destination `any LAN` port `3389,22` (le jump rebondit vers les serveurs cibles selon le tier admin)
- Pass : Source `172.16.69.0/24` (BASTION) → Destination `172.16.70.0/24` (JUMP) port `3389,22` (déjà fait en F5, redondant mais explicite ici aussi)
- Deny : tout le reste

<img width="1801" height="989" alt="JUMP" src="https://github.com/user-attachments/assets/c6ba4dce-c542-4320-b115-6d5909b4cb62" />


### F7 — VLAN DMZ → Firewall Rules (isolation stricte)

- Pass : Source `172.16.71.0/24` → Destination `172.16.65.3` (AD) port `636` **uniquement** (LDAPS, IP à IP précise, jamais 389 en clair) — c'est le flux iRedMail → AD pour l'auth
- Pass : Source `172.16.71.0/24` → Destination WAN port `25,80,443,587` (mail + web sortant)
- **Deny explicite** : Source `172.16.71.0/24` → Destination `any LAN` (tout le reste du LAN, RIEN d'autre n'est autorisé)
- **Deny explicite en haut des règles WAN/LAN** : Source `any WAN` → Destination `LAN nets` (0 accès WAN→LAN, sauf NAT entrant ciblé vers DMZ uniquement, voir F8)


<img width="1856" height="967" alt="DMZ" src="https://github.com/user-attachments/assets/e9f3601c-de59-489f-96f1-4562122be081" />


### F8 — WAN → Firewall Rules (entrée depuis Internet)

- Pass (NAT) : Destination `172.16.71.x` (IP publique du WEB externe en DMZ) port `80,443`
- Pass (NAT) : Destination `172.16.71.x` (IP iRedMail DMZ) port `25,587,443`
- **Deny All** : tout le reste depuis WAN (donc 0 accès WAN→LAN direct, conforme à ta demande)


<img width="1797" height="958" alt="WAN" src="https://github.com/user-attachments/assets/32c71d76-8980-4eb0-b74c-d71a766b7335" />


### F9 — VPN → Firewall Rules (télétravail)

- Pass : Source `172.16.72.0/24` (VPN) → Destination `172.16.70.0/24` (JUMP) port `3389,22` **uniquement**
- Deny : tout le reste (le télétravailleur doit obligatoirement passer par le Jump, jamais direct vers un serveur)


<img width="1826" height="729" alt="VPN" src="https://github.com/user-attachments/assets/b35e93ff-9085-421d-be3c-e9f66af2b946" />


---

## PARTIE G — Vérification finale

**Diagnostics → Ping** depuis pfSense, teste :

- `172.16.65.254` (AD) → doit répondre
- Depuis un poste test RH (à connecter au VLAN RH), ping vers `172.16.74.254` (COMMUNICATION) → doit **échouer** (isolation confirmée)
- Depuis BASTION, ping vers AD → doit réussir

### Pour WIFIGUEST 

Contrairement aux autres VLANs département, **WIFIGUEST ne doit PAS avoir accès à WEB-INT ni APPS** (règles 4 et 5) — un visiteur n'a pas au portail interne ou GLPI. 

Donc WIFIGUEST = règle 6 uniquement (+ éventuellement DNS public), pas de règle 1/3/4/5 vers ton AD/APPS/WEB-INT.

### Pour WIFIENTREPRISE

Règle 1 à 6 comme un VLAN département classique, puisque ce sont les employés qui s'y connectent.

### 1. VLAN BACKUP et WEB-INT vides 

**BACKUP vide** : c'est **normal et volontaire**. BACKUP est une destination, jamais une source qui initie du trafic vers les autres VLANs. Toutes les connexions vers BACKUP partent d'APPS (rsync/mysqldump, déjà fait dans les règles APPS) ou de BASTION (admin). BACKUP n'a besoin d'aucune règle sortante propre — sauf s'il accède à Internet pour ses propres mises à jour système (`apt update`), dans ce cas ajoute juste une règle "BACKUP → WAN port 80,443".

**WEBINT vide** : WEB-INT est un serveur Apache (le portail interne) — **c'est lui aussi qui ne reçoit que du trafic entrant** (les départements s'y connectent en HTTP/HTTPS, déjà autorisé via les règles département "Règle 4"). WEB-INT n'a pas besoin d'initier de connexion sortante vers un autre VLAN, sauf s'il doit aller chercher des données dynamiques sur GLPI/Zabbix (APPS) pour les afficher sur le portail — ajouter "WEBINT → APPS port 80,443". 

### 2. Départements qui communiquent avec qui ?

#### Nouveau modèle proposé : "Isolation sélective"

- **Tous les départements standards** (Communication, Commercial, Marketing, Production, RD, Logistique, Direction) → ajoutent une règle **"Pass : Source [CE VLAN] subnets → Destination DEPT_STANDARD_ALIAS port any"** où `DEPT_STANDARD_ALIAS` est un alias regroupant tous les réseaux département non-sensibles. Ça leur permet de se parler entre eux.
- **VLANs sensibles** (RH, FINANCE, JURIDIQUE, DIRECTION, DSI) → **aucune règle d'accès vers les autres VLANs département**, qu'ils soient sensibles ou standards. Ils gardent exactement les règles 1-6.

#### Mise en œuvre :

 **Firewall → Aliases → Add** :

- Name : `DEPT_STANDARD`   
- Type : `Network(s)`    
- Ajoute les réseaux :    
  `172.16.75.0/24` (COMMERCIAL),    
  `172.16.77.0/24` (MARKETING),    
  `172.16.78.0/24` (DEVELOPPEMENT),    
  `172.16.79.0/24` (R&D),    
  `172.16.80.0/24` (SERVICE GENERAUX),   
  `172.16.74.0/24` (COMMUNICATION)    


  <img width="1633" height="992" alt="DEPT_STD" src="https://github.com/user-attachments/assets/4a3cdb36-fe97-49e3-b11c-398087efb40a" />


Puis sur**chaque VLAN standard** (COMMUNICATION, COMMERCIAL, MARKETING, PRODUCTION, RD, LOGISTIQUE), une règle supplémentaire :

- Pass / Source : ce VLAN subnets / Destination : `DEPT_STANDARD` / Port : any (ou restreint à `445` SMB + `3389` RDP partagé + `5060` visio pour limiter)

**Ne rien modifer sur RH, FINANCE, JURIDIQUE, DIRECTION** —  isolement (règles 1-6, jamais de règle vers DEPT_STANDARD ni vers un autre VLAN sensible).

---


