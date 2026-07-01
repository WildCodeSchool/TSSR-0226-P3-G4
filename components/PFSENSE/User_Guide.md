# Guide d'utilisation — Configuration pas-à-pas (pfSense)

Ce guide rassemble les instructions opérationnelles pour l'administration, le durcissement initial et la mise en conformité de la politique de filtrage **Zero Trust** sur le pare-feu central **pfSense**.

---

## 1. Connexion initiale & changement du mot de passe admin

### 1.1. Première authentification
1. Ouvrir le navigateur web et naviguer vers l'adresse d'administration par défaut : **`https://172.16.64.254`**.
2. Passer l'alerte de sécurité liée au certificat SSL auto-signé. Cliquer sur **"Paramètres avancés"** (ou "Avancé"), puis sur **"Accepter le risque et poursuivre"**.
3. Sur la page de mire d'authentification pfSense, entrer les identifiants d'usine par défaut :
   * **Username :** `admin`
   * **Password :** `pfsense`
4. Compléter les étapes du **Setup Wizard** (renseigner le hostname `pfSense-XTech`, le domaine `xtech.green` et le WAN statique `10.0.0.4/28` avec la passerelle `10.0.0.1`).

### 1.2. Durcissement immédiat de l'accès (Étape Critique)
Pour révoquer les accès d'usine et appliquer la politique de sécurité XenTech :
1. Aller dans le menu supérieur de pfSense : **System ➔ User Manager**.
2. Sur la ligne de l'utilisateur `admin`, cliquer sur le bouton d'édition (icône de crayon à droite).
3. Faire défiler la page jusqu'au champ **Password** et saisir le nouveau mot de passe fort requis : `Azerty1*`
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
