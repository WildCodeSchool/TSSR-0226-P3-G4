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


---


## PARTIE E — DHCP par VLAN

**Important** : Le VLAN **AD** ne doit **pas** avoir de DHCP pfSense — c'est le serveur AD (`172.16.65.3`) qui doit faire le DHCP. Pour tous les **autres** VLAN, pfSense peut distribuer du DHCP (IP fixes pour les serveurs, DHCP juste pour les VLAN département/postes clients).

 **Services → DHCP Server**, pour chaque VLAN département (RH, COMMUNICATION, COMMERCIAL, FINANCE, MARKETING, PRODUCTION, RD, LOGISTIQUE, JURIDIQUE, DIRECTION, WIFIENTREPRISE) :

- Onglet du VLAN concerné (ex: `RH`)
- Enable DHCP server
- Range : `172.16.73.10` → `172.16.73.200` 
- DNS servers : `172.16.65.3` (AD, VLAN10)
- **Save**

<img width="1522" height="1002" alt="image" src="https://github.com/user-attachments/assets/14695b23-3c0f-47b6-b4fc-7855754e4c90" />

---

<img width="1704" height="483" alt="image" src="https://github.com/user-attachments/assets/fb9df51b-0cfc-4c27-b9e1-05f4f8337c40" />

---

**PAS de DHCP sur** : AD, APPS, BACKUP, WEBINT, BASTION, JUMP, DMZ, VPN, WIFIGUEST (DHCP plage courte ex `172.16.84.50-100`).

---

## PARTIE F — Politique de filtrage et règles de pare-feu (Zero-Trust)

C'est ici que se joue toute la logique Zero Trust. Principe général appliqué partout : **Deny All implicite en bas**, on **autorise explicitement** seulement ce qui est nécessaire, rien d'autre.

### F1 — Création des Alias

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
| `172.16.78.0` | `24` | DEVELOPPEMENT |
| `172.16.79.0` | `24` | R&D (RD) |
| `172.16.80.0` | `24` | SERVICES GENERAUX |

5. Vérifier la conformité des masques de sous-réseau (sélectionner impérativement le suffixe **24** pour chaque ligne).
6. Cliquer sur **Save** tout en bas de la page.
7. **IMPORTANT :** Cliquer sur le bouton vert **Apply Changes** qui apparaît en haut de l'écran pour valider la configuration.

<img width="1599" height="1005" alt="image" src="https://github.com/user-attachments/assets/a34f783d-3515-433f-90ed-dcd62954e8e6" />


---

### 2.1 Départements qui communiquent avec qui ?

#### Nouveau modèle proposé : "Isolation sélective"

- **Tous les départements standards** :

- Puis sur **chaque VLAN standard** `DEPT_STANDARD`, une règle :

- **Pass : Source : [ce VLAN] subnets → Destination : `DEPT_STANDARD` Port : any (ou restreint à `445` SMB + `3389` RDP partagé + `5060` visio pour limiter)**  

Ça leur permet de se parler entre eux.   


- **VLANs sensibles**   

(RH, FINANCE, JURIDIQUE, DIRECTION, DSI) → **aucune règle d'accès vers les autres VLANs département**    

Qu'ils soient sensibles ou standards. Ils gardent exactement les règles 1-6.


**Ne rien modifer sur RH, FINANCE, JURIDIQUE, DIRECTION** —  isolement (règles 1-6, jamais de règle vers `DEPT_STANDARD` ni vers un autre VLAN sensible).

---

### F2 — Logique et ordonnancement

> **Règle d'or de l'ordonnancement :** pfSense analyse les règles de pare-feu de haut en bas. Dès qu'une condition est remplie (première correspondance ou *First Match*), le traitement s'arrête et s'applique. Placer impérativement les autorisations spécifiques en haut et les restrictions globales en bas. En l'absence de règle, tout trafic inter-VLAN subit un blocage par défaut.

Modèle d'isolation sélective des départements :
VLANs Standards (COMMUNICATION, COMMERCIAL, MARKETING, DEVELOPPEMENT, R&D, SERVICES GENERAUX, WIFIENTREPRISE) : Ils disposent d'une règle spécifique les autorisant à inter-communiquer via l'alias DEPT_STANDARD.

VLANs Sensibles (RH, FINANCE, JURIDIQUE, DIRECTION, DSI) : Ils ne possèdent aucune règle d'accès vers les autres départements. Ils sont totalement hermétiques et isolés du reste de l'entreprise.

Cas particulier WIFIGUEST : Il ne doit avoir accès à aucune ressource interne (ni AD, ni APPS, ni WEB-INT). Il dispose uniquement d'un accès direct vers l'Internet (WAN).


### F3 — Règles pour les VLANs Départements

Naviguer dans **Firewall ➔ Rules**, puis cliquer sur l'onglet correspondant à l'interface du VLAN (ex: **COMMUNICATION**). Pour chaque règle, cliquer sur le bouton **Add (avec flèche vers le haut)** pour l'insérer en haut de la pile :

#### Règle 1 — Autoriser les requêtes DNS vers l'Active Directory
* **Action :** `Pass` | **Interface :** `COMMUNICATION` | **Address Family :** `IPv4`
* **Protocol :** `TCP/UDP`
* **Source :** `COMMUNICATION net`
* **Destination :** `Single host or alias` ➔ Valeur : `172.16.65.3` (IP de l'AD Principal)
* **Destination Port Range :** From port `53` (DNS) to port `53` (DNS).
* **Description :** `Flux DNS vers AD`

#### Règle 2 — Autoriser DHCP
Déjà géré automatiquement de manière invisible en arrière-plan par le service DHCP natif de pfSense.

#### Règle 3 — Autoriser l'authentification Kerberos / LDAP / SMB vers l'AD
* **Action :** `Pass` | **Protocol :** `TCP/UDP` | **Source :** `COMMUNICATION net`
* **Destination :** `Single host or alias` ➔ Valeur : `172.16.65.3`
* **Destination Port Range :** Saisir `any` *(ou utiliser un alias de ports préalablement créé incluant 88, 389, 445, 464)*.
* **Description :** `Flux Auth Services AD`

#### Règle 4 — Autoriser l'accès au serveur Web Interne (WEB-INT)
* **Action :** `Pass` | **Protocol :** `TCP` | **Source :** `COMMUNICATION net`
* **Destination :** `WEB_INT net` *(ou le sous-réseau `172.16.68.0/24`)*.
* **Destination Port Range :** From `HTTP (80)` to `HTTPS (443)`.
* **Description :** `Accès Portail Web Interne`

#### Règle 5 — Autoriser l'accès aux Applications d'exploitation (APPS)
* **Action :** `Pass` | **Protocol :** `TCP` | **Source :** `COMMUNICATION net`
* **Destination :** `APPS net` *(ou le sous-réseau `172.16.66.0/24`)*.
* **Destination Port Range :** From `HTTP (80)` to `HTTPS (443)`.
* **Description :** `Accès GLPI / Zabbix`

#### Règle 6 — Autoriser l'accès d'inter-communication standard (Inter-VLAN Standard)
* **Action :** `Pass` | **Protocol :** `any` | **Source :** `COMMUNICATION net`
* **Destination :** `Single host or alias` ➔ Saisir l'alias : **`DEPT_STANDARD`**.
* **Destination Port Range :** `any`
* **Description :** `Interconnexion inter-départements standards`

Note de cloisonnement critique : Ne jamais ajouter cette règle sur les interfaces sensibles (RH, FINANCE, JURIDIQUE, DIRECTION, DSI) ni sur WIFIGUEST.

#### Règle 7 — Autoriser l'accès Internet sortant uniquement (WAN)
* **Action :** `Pass` | **Protocol :** `TCP/UDP` | **Source :** `COMMUNICATION net`
* **Destination :** `any`
* **Destination Port Range :** `any` *(ou restreindre aux ports de navigation sécurisés 80, 443, 53)*.
* **Description :** `Accès Internet Sortant restreint`

---


### F4 — Règles pour les VLANs Techniques 

#### A. VLAN 10 (AD)
**Règle 1 — Autoriser AD → APPS** (sync GLPI/iRedMail)
* **Action :** `Pass` | Protocol: `TCP/UDP` | Source: `AD net` | Destination: `APPS net` | Ports: `389, 636` (Synchronisation LDAP vers GLPI et iRedMail)

Note sur le trafic de retour : Les réponses vers les VLANs clients (DNS/LDAP/Kerberos retour) sont gérées dynamiquement par l'état "established/related" de pfSense.   
Aucune règle manuelle n'est requise.

Règle finale : Deny all implicite vers la DMZ et le BASTION (sauf retours initiés légitimement).

**Règle 2 — Autoriser réponses vers tous les VLANs clients** (DNS/LDAP/Kerberos retour)

- Source: `172.16.65.0/24` / Destination: `any` / déjà couvert par "established/related" de pfSense par défaut, pas besoin de règle supplémentaire pour le retour


<img width="1803" height="988" alt="AD" src="https://github.com/user-attachments/assets/0999e8a1-702d-4437-89a0-eb3af6bbdc58" />

---

#### B. VLAN 20 (APPS)
 
* **Flux vers AD :** `Pass` | Protocol: `TCP/UDP` | Source: `APPS net` | Destination: `172.16.65.3` | Ports: `389, 636, 53` (Sync GLPI vers AD et requête DNS)
* **Flux vers BACKUP :** `Pass` | Protocol: `TCP` | Source: `APPS net` | Destination: `BACKUP net` | Ports: `22, 3306` (Sauvegardes rsync + myslqdump vers BKP).
* **Flux Internet :** `Pass` | Protocol: `TCP` | Source: `APPS net` | Destination: `any` | Ports: `80, 443` (WDS Téléchargement des mises à jour).
* **Règle finale :** `Deny` vers tout le reste. 


<img width="1831" height="1005" alt="APPS" src="https://github.com/user-attachments/assets/6d0a6d75-45b6-4f14-8b14-8753f1608fc1" />

---

#### C. VLAN 60 (BASTION - Point d'entrée d'administration unique)
* **Vers AD :** `Pass` | Protocol: `TCP` | Source: `BASTION net` | Destination: `AD net` | Ports: `3389, 22`
* **Vers APPS :** `Pass` | Protocol: `TCP` | Source: `BASTION net` | Destination: `APPS net` | Ports: `3389, 22`
* **Vers BACKUP / JUMP :** `Pass` | Protocol: `TCP` | Source: `BASTION net` | Destination: `BACKUP net` / `JUMP net` | Ports: `3389, 22`
* **Règle finale :** `Deny` vers tout le reste (La DMZ est exclue, le Bastions n'y accède pas directement).


<img width="1704" height="1001" alt="BASTION" src="https://github.com/user-attachments/assets/207668d3-92f8-43eb-8be2-f8fd87591d5e" />


### D. — VLAN JUMP → Firewall Rules

- Pass : Source `172.16.70.0/24` → Destination `any LAN` port `3389,22` (le jump rebondit vers les serveurs cibles selon le tier admin)
- Pass : Source `172.16.69.0/24` (BASTION) → Destination `172.16.70.0/24` (JUMP) port `3389,22` (déjà fait en F5, redondant mais explicite ici aussi)
- Deny : tout le reste

<img width="1801" height="989" alt="JUMP" src="https://github.com/user-attachments/assets/c6ba4dce-c542-4320-b115-6d5909b4cb62" />

---

#### E. VLAN 100 (DMZ)
* **iRedMail Vers AD :** `Pass` | Protocol: `TCP` | Source: `DMZ net` | Destination: `172.16.65.3` | Port: **`636` uniquement** (LDAPS chiffré obligatoire, interdiction du port 389 en clair).
* **Sortie Vers WAN :** `Pass` | Protocol: `TCP` | Source: `DMZ net` | Destination: `any` | Ports: `25, 80, 443, 587` (Flux de messagerie externe iRedMail et serveurs Web).
* **Deny vers LAN:** `Block` | Source : `DMZ net` | Destination : `any, LAN` (Isolation DMZ absolue - Interdiction totale d'initier un flux vers le réseau interne)


<img width="1856" height="967" alt="DMZ" src="https://github.com/user-attachments/assets/e9f3601c-de59-489f-96f1-4562122be081" />

---

### F. — WAN → Firewall (entrée depuis Internet via NAT)

- Pass (NAT) : Destination `172.16.71.x` (IP publique du WEB externe en DMZ) port `80,443`
- Pass (NAT) : Destination `172.16.71.x` (IP iRedMail DMZ) port `25,587,443`
- **Deny All** : tout le reste depuis WAN (donc 0 accès WAN→LAN direct, conforme à ta demande)


<img width="1797" height="958" alt="WAN" src="https://github.com/user-attachments/assets/32c71d76-8980-4eb0-b74c-d71a766b7335" />


### G. — VPN → Firewall (télétravail)

- Pass : Source `172.16.72.0/24` (VPN) → Destination `172.16.70.0/24` (JUMP) port `3389,22` **uniquement**
- Deny : tout le reste (le télétravailleur doit obligatoirement passer par le Jump, jamais direct vers un serveur)


<img width="1826" height="729" alt="VPN" src="https://github.com/user-attachments/assets/b35e93ff-9085-421d-be3c-e9f66af2b946" />


---

### PARTIE H — Cas particuliers des VLANs BACKUP et WEB-INT (Laissés vides par conception)

**BACKUP vide** : c'est **normal et volontaire**. BACKUP est une destination, jamais une source qui initie du trafic vers les autres VLANs. Toutes les connexions vers BACKUP partent d'APPS (rsync/mysqldump, déjà fait dans les règles APPS) ou de BASTION (admin). BACKUP n'a besoin d'aucune règle sortante propre — sauf s'il accède à Internet pour ses propres mises à jour système (`apt update`), dans ce cas ajoute juste une règle "BACKUP → WAN port 80,443".

**WEBINT vide** : WEB-INT est un serveur Apache (le portail interne) — **c'est lui aussi qui ne reçoit que du trafic entrant** (les départements s'y connectent en HTTP/HTTPS, déjà autorisé via les règles département "Règle 4"). WEB-INT n'a pas besoin d'initier de connexion sortante vers un autre VLAN, sauf s'il doit aller chercher des données dynamiques sur GLPI/Zabbix (APPS) pour les afficher sur le portail — ajouter "WEBINT → APPS port 80,443". 


### I - Placement de la Règle Explicite "Deny All" tout en bas

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




### I - Pour WIFIGUEST 

Contrairement aux autres VLANs département, **WIFIGUEST ne doit PAS avoir accès à WEB-INT ni APPS** (règles 4 et 5) — un visiteur n'a pas au portail interne ou GLPI. 

Donc WIFIGUEST = règle 6 uniquement (+ éventuellement DNS public), pas de règle 1/3/4/5 vers ton AD/APPS/WEB-INT.

### Pour WIFIENTREPRISE

Règle 1 à 6 comme un VLAN département classique, puisque ce sont les employés qui s'y connectent.



### Vérification finale (Validation de la Politique)

**Diagnostics → Ping** depuis pfSense, teste :

- `172.16.65.254` (AD) → doit répondre
- Depuis un poste test RH (à connecter au VLAN RH), ping vers `172.16.74.254` (COMMUNICATION) → doit **échouer** (isolation confirmée)
- Depuis BASTION, ping vers AD → doit réussir
- Test d'administration : Depuis le VLAN BASTION, tenter un accès SSH/RDP vers le réseau AD ➔ Le trafic doit réussir conformément aux privilèges accordés.
















---

