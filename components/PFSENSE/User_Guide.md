# Guide d'utilisation — Configuration pas-à-pas (pfSense)

Ce guide rassemble les instructions opérationnelles pour l'administration, le durcissement initial et la mise en conformité de la politique de filtrage **Zero Trust** sur le pare-feu central **pfSense**.

---

## 1. Connexion initiale & changement du mot de passe admin

### 1.1. Première authentification
1. Ouvrir le navigateur web et naviguer vers l'adresse d'administration par défaut : **`https://172.16.64.254`**.

<img width="1873" height="1059" alt="Capture d&#39;écran 2026-07-02 202001" src="https://github.com/user-attachments/assets/d86b0b08-4c37-4872-8bc8-63e94ba3f0e4" />


---

## PARTIE A — Fixer le WAN (accès internet)

**Interfaces → WAN**

- **Enable** : `Enable interface`
- **IPv4 Configuration Type** : `Static IPv4`

<img width="1613" height="902" alt="image" src="https://github.com/user-attachments/assets/4e5f9298-c7c5-45c7-ad69-aca107258efc" />

---

- **IPv4 Address** : `10.0.0.4` / `28`
- **IPv4 Upstream Gateway** : **Add a new gateway** → Name: `WANGW`, Gateway: `10.0.0.1` → Save
- Décocher **"Block private networks"** (sinon pfSense bloque notre propre WAN privé)
- Décocher **"Block bogon networks"**
- **Save** → **Apply Changes**

<img width="1536" height="745" alt="image" src="https://github.com/user-attachments/assets/48ad4ae3-7bed-4d47-b10f-f5d8d12b3746" />

---

<img width="1537" height="125" alt="image" src="https://github.com/user-attachments/assets/734182a3-a972-4a28-9dca-1e30c4464af3" />

---

**Status → Gateways** pour vérifier que `WANGW` est en vert (online).

<img width="1625" height="465" alt="image" src="https://github.com/user-attachments/assets/8217faf2-82a1-4b92-85ec-04b04682ca65" />

---


**Status → Interfaces → WAN** : `10.0.0.4/28`.

<img width="1646" height="569" alt="image" src="https://github.com/user-attachments/assets/890c0b15-e22d-4f83-8a40-ccefc7b1ac13" />

---

**Diagnostics → Ping** : ping `10.0.0.1` (la passerelle du formateur). Le WAN est fonctionnel.

<img width="1663" height="911" alt="image" src="https://github.com/user-attachments/assets/90d9141f-8b08-47be-9498-accde138fea4" />


---

## PARTIE B — Assigner OPT1 (em2 → trunk VLAN)

**Interfaces → Assignments**

Clique sur la nouvelle ligne **OPT1** :

- Enable interface
- Description : `TRUNK`
- IPv4 Configuration Type : `None`
- **Save** → **Apply Changes**

<img width="1660" height="924" alt="image" src="https://github.com/user-attachments/assets/b8f8c0fd-c973-4285-a5c4-3137c6675dbe" />


---

## PARTIE C — Créer les 24 VLANs

**Interfaces → VLANs → Add**, répète pour chaque ligne ci-dessous (Parent interface = `em2 (TRUNK)` à chaque fois) :

<img width="1428" height="1026" alt="image" src="https://github.com/user-attachments/assets/3358a9c1-3a31-4b85-8708-a63b3a75a73d" />

---

## PARTIE D — Assigner chaque VLAN comme interface + IP

 **Interfaces → Assignments** : 22 VLANs disponibles dans le menu déroulant en bas. **Add** chacun un par un (22 fois).

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
3. Passer l'alerte de sécurité liée au certificat SSL auto-signé. Cliquer sur **"Paramètres avancés"** (ou "Avancé"), puis sur **"Accepter le risque et poursuivre"**.
4. Sur la page de mire d'authentification pfSense, entrer les identifiants d'usine par défaut :
   * **Username :** `admin`
   * **Password :** `pfsense`
5. Compléter les étapes du **Setup Wizard** (renseigner le hostname `pfSense-XTech`, le domaine `xtech.green` et le WAN statique `10.0.0.4/28` avec la passerelle `10.0.0.1`).

### 1.2. Durcissement immédiat de l'accès (Étape Critique)
Pour révoquer les accès d'usine et appliquer la politique de sécurité XenTech :
1. Aller dans le menu supérieur de pfSense : **System ➔ User Manager**.
2. Sur la ligne de l'utilisateur `admin`, cliquer sur le bouton d'édition (icône de crayon à droite).
3. Faire défiler la page jusqu'au champ **Password** et saisir le nouveau mot de passe fort requis : `ex: G4-TSSR-2026`
4. Confirmer dans le champ **Password CONFIRM**.
5. Descendre tout en bas de la page et cliquer sur **Save**.

---

## 2. Création et gestion des alias réseau (Aliases)

Pour appliquer la politique d'isolation sélective sans multiplier les règles redondantes, centraliser les sous-réseaux des départements non-sensibles au sein d'un Alias global.

1. Accéder au menu : **Firewall ➔ Aliases**.
2. Rester sur l'onglet par défaut **IP** et cliquer sur le bouton vert **+ Add** en bas à droite.
3. Renseigner les propriétés suivantes de l'alias :
   * **Name :** `DEPT_STANDARD`
   * **Description :** `Regroupement des sous-réseaux des départements non-sensibles`
   * **Type :** Sélectionner **`Network(s)`** dans le menu déroulant.
4. Ajouter un à un les réseaux cibles en cliquant sur le bouton **+ Add Network** pour chaque nouvelle ligne :

| Réseau / IP Subnet | Masque | Description / Département associé |
| :--- | :---: | :--- |
| `172.16.74.0` | `24` | COMMUNICATION |
| `172.16.75.0` | `24` | COMMERCIAL |
| `172.16.77.0` | `24` | MARKETING |
| `172.16.78.0` | `24` | DEVELOPPEMENT (PRODUCTION) |
| `172.16.79.0` | `24` | R&D (RD) |
| `172.16.80.0` | `24` | SERVICES GENERAUX (LOGISTIQUE) |

5. Vérifier la conformité des masques de sous-réseau (sélectionner impérativement le suffixe **24** pour chaque ligne).
6. Cliquer sur **Save** tout en bas de la page.
7. **IMPORTANT :** Cliquer sur le bouton vert **Apply Changes** qui apparaît en haut de l'écran pour valider la configuration.

---

## 3. Implémentation des règles de filtrage par VLAN (Firewall Rules)

> **Règle d'or de l'ordonnancement :** pfSense analyse les règles de pare-feu de haut en bas. Dès qu'une condition est remplie (première correspondance ou *First Match*), le traitement s'arrête et s'applique. Placer impérativement les autorisations spécifiques en haut et les restrictions globales en bas. En l'absence de règle, tout trafic inter-VLAN subit un blocage par défaut.

### 3.1. Configuration pas-à-pas d'un VLAN Standard (Exemple : COMMUNICATION)
Naviguer dans **Firewall ➔ Rules**, puis cliquer sur l'onglet correspondant à l'interface du VLAN (ex: **COMMUNICATION**). Pour chaque règle, cliquer sur le bouton **Add (avec flèche vers le haut)** pour l'insérer en haut de la pile :

#### Règle 1 — Autoriser les requêtes DNS vers l'Active Directory
* **Action :** `Pass` | **Interface :** `COMMUNICATION` | **Address Family :** `IPv4`
* **Protocol :** `TCP/UDP`
* **Source :** `COMMUNICATION net`
* **Destination :** `Single host or alias` ➔ Valeur : `172.16.65.3` (IP de l'AD Principal)
* **Destination Port Range :** From port `53` (DNS) to port `53` (DNS).
* **Description :** `Flux DNS vers AD`

#### Règle 2 — Autoriser l'authentification Kerberos / LDAP / SMB vers l'AD
* **Action :** `Pass` | **Protocol :** `TCP/UDP` | **Source :** `COMMUNICATION net`
* **Destination :** `Single host or alias` ➔ Valeur : `172.16.65.3`
* **Destination Port Range :** Saisir `any` *(ou utiliser un alias de ports préalablement créé incluant 88, 389, 445, 464)*.
* **Description :** `Flux Auth Services AD`

#### Règle 3 — Autoriser l'accès au serveur Web Interne (WEB-INT)
* **Action :** `Pass` | **Protocol :** `TCP` | **Source :** `COMMUNICATION net`
* **Destination :** `WEB_INT net` *(ou le sous-réseau `172.16.68.0/24`)*.
* **Destination Port Range :** From `HTTP (80)` to `HTTPS (443)`.
* **Description :** `Accès Portail Web Interne`

#### Règle 4 — Autoriser l'accès aux Applications d'exploitation (APPS)
* **Action :** `Pass` | **Protocol :** `TCP` | **Source :** `COMMUNICATION net`
* **Destination :** `APPS net` *(ou le sous-réseau `172.16.66.0/24`)*.
* **Destination Port Range :** From `HTTP (80)` to `HTTPS (443)`.
* **Description :** `Accès GLPI / Zabbix`

#### Règle 5 — Autoriser l'accès d'inter-communication standard (Inter-VLAN Standard)
* **Action :** `Pass` | **Protocol :** `any` | **Source :** `COMMUNICATION net`
* **Destination :** `Single host or alias` ➔ Saisir l'alias : **`DEPT_STANDARD`**.
* **Destination Port Range :** `any`
* **Description :** `Interconnexion inter-départements standards`

#### Règle 6 — Autoriser l'accès Internet sortant uniquement (WAN)
* **Action :** `Pass` | **Protocol :** `TCP/UDP` | **Source :** `COMMUNICATION net`
* **Destination :** `any`
* **Destination Port Range :** `any` *(ou restreindre aux ports de navigation sécurisés 80, 443, 53)*.
* **Description :** `Accès Internet Sortant restreint`

> **Note de cloisonnement pour les zones sensibles (RH, FINANCE, JURIDIQUE, DIRECTION, DSI) :**
> Pour ces interfaces critiques, appliquer **uniquement** les règles 1, 2, 3, 4 et 6. Ne **jamais** ajouter la règle 5 (Pas d'accès vers l'alias `DEPT_STANDARD`). L'omission de cette règle garantit leur étanchéité complète et leur isolation vis-à-vis du reste de l'entreprise.

---

### 3.2. Configuration des règles pour les VLANs Techniques Communs

#### VLAN 10 (AD)
* **Flux vers APPS :** `Pass` | Protocol: `TCP/UDP` | Source: `AD net` | Destination: `APPS net` | Ports: `389, 636` (Synchronisation LDAP vers GLPI et iRedMail).

#### VLAN 20 (APPS)
* **Flux vers AD :** `Pass` | Protocol: `TCP/UDP` | Source: `APPS net` | Destination: `172.16.65.3` | Ports: `389, 636, 53`
* **Flux vers BACKUP :** `Pass` | Protocol: `TCP` | Source: `APPS net` | Destination: `BACKUP net` | Ports: `22, 3306` (Sauvegardes et réplication).
* **Flux Internet :** `Pass` | Protocol: `TCP` | Source: `APPS net` | Destination: `any` | Ports: `80, 443` (Mises à jour).

#### VLAN 60 (BASTION - Point d'entrée d'administration unique)
* **Vers AD :** `Pass` | Protocol: `TCP` | Source: `BASTION net` | Destination: `AD net` | Ports: `3389, 22`
* **Vers APPS :** `Pass` | Protocol: `TCP` | Source: `BASTION net` | Destination: `APPS net` | Ports: `3389, 22`
* **Vers BACKUP / JUMP :** `Pass` | Protocol: `TCP` | Source: `BASTION net` | Destination: `BACKUP net` / `JUMP net` | Ports: `3389, 22`

#### VLAN 100 (DMZ)
* **Vers AD :** `Pass` | Protocol: `TCP` | Source: `DMZ net` | Destination: `172.16.65.3` | Port: **`636` uniquement** (LDAPS chiffré obligatoire, interdiction du port 389 en clair).
* **Vers WAN :** `Pass` | Protocol: `TCP` | Source: `DMZ net` | Destination: `any` | Ports: `25, 80, 443, 587` (Flux de messagerie externe iRedMail et serveurs Web).

---

## 4. Placement de la Règle Explicite "Deny All" tout en bas

Les bonnes pratiques de sécurité et d'audit de l'infrastructure XenTech exigent la mise en place d'une règle de blocage finale visible, explicite et journalisée tout en bas de chaque interface réseau.

1. Dans l'onglet de l'interface (ex: **COMMUNICATION**), cliquer sur le bouton vert **Add (avec flèche vers le bas)** pour insérer la règle à la toute fin de la liste actuelle.
2. Configurer les champs de la règle de rejet absolu :
   * **Action :** Sélectionner `Block` (rejette le paquet silencieusement) ou `Reject` (renvoie un paquet d'erreur, recommandé en interne pour faciliter les diagnostics d'administration).
   * **Interface :** `COMMUNICATION`
   * **Address Family :** `IPv4`
   * **Protocol :** `any`
   * **Source :** `any`
   * **Destination :** `any`
3. **Section Logging & Audit (CRUCIAL) :**
   * Cocher obligatoirement la case **"Log packets that are handled by this rule"**. *Cette option permet d'envoyer toutes les tentatives d'accès non autorisées vers le serveur Syslog centralisé (VLAN APPS).*
4. **Description :** Renseigner l'identifiant d'audit suivant : **`[SECURITY] ISOLEMENT ZERO-TRUST - DENY ALL FINAL`**.
5. Cliquer sur **Save**.
6. **Vérification visuelle :** S'assurer que cette règle se positionne bien en dernière place (à la toute fin de la grille sous la règle WAN). Si nécessaire, utiliser les poignées de déplacement situées à gauche de la ligne pour la glisser vers le bas.
7. Cliquer sur le bouton supérieur **Apply Changes** pour recharger la politique de sécurité et appliquer les modifications sur le pare-feu.
