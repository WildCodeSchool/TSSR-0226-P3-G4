# Guide d'utilisation destiné aux Techniciens de Xentech

Ce guide fournit des instructions opérationnelles détaillées, étape par étape, pour l'administration, le durcissement initial et la mise en conformité de la politique de filtrage **Zero Trust** sur le pare-feu central **pfSense-XTech**.

---

## 1. Connexion Initiale & Changement du Mot de Passe Admin

Suite à la configuration de la console réseau et au raccordement de votre machine d'administration (VM 403 rattachée au bridge Proxmox `vmbr400`, sans tag VLAN, configurée avec l'IP statique `172.16.64.10/24`), suivez scrupuleusement la procédure ci-dessous.

### 1.1. Première authentification
1. Ouvrez votre navigateur web et naviguez vers l'adresse d'administration par défaut : **`https://172.16.64.254`**[cite: 1, 2].
2. Une alerte de sécurité liée au certificat SSL auto-signé s'affiche[cite: 1, 2]. Cliquez sur **"Paramètres avancés"** (ou "Avancé"), puis sur **"Accepter le risque et poursuivre"**[cite: 1, 2].
3. Sur la page de mire d'authentification pfSense, entrez les identifiants d'usine par défaut[cite: 1, 2] :
   * **Username :** `admin`[cite: 1, 2]
   * **Password :** `pfsense`[cite: 1, 2]
4. Suivez et complétez les étapes du **Setup Wizard** (en renseignant le hostname `pfSense-XTech`, le domaine `xtech.green` et le WAN statique `10.0.0.4/28` avec la passerelle `10.0.0.1`)[cite: 1, 2].

### 1.2. Durcissement immédiat de l'accès (Étape Critique)
Pour révoquer les accès d'usine et appliquer la politique de sécurité de XenTech :
1. Dans le menu supérieur de pfSense, allez dans : **System ➔ User Manager**[cite: 1, 2].
2. Sur la ligne de l'utilisateur `admin`, cliquez sur le bouton d'édition (icône de crayon 📝 à droite)[cite: 1, 2].
3. Faites défiler la page jusqu'au champ **Password** et saisissez le nouveau mot de passe fort requis : `Azerty1*`[cite: 1, 2].
4. Confirmez-le dans le champ **Password CONFIRM**[cite: 1, 2].
5. Descendez tout en bas de la page et cliquez sur **Save**[cite: 1, 2].

---

## 2. Création et Gestion des Alias Réseau (Aliases)

Pour appliquer notre politique d'isolation sélective sans multiplier les règles redondantes, nous centralisons les sous-réseaux des départements non-sensibles au sein d'un Alias global.

1. Accédez au menu : **Firewall ➔ Aliases**[cite: 1, 2].
2. Restez sur l'onglet par défaut **IP** et cliquez sur le bouton vert **+ Add** en bas à droite[cite: 1, 2].
3. Renseignez scrupuleusement les propriétés suivantes de l'alias[cite: 1, 2] :
   * **Name :** `DEPT_STANDARD`[cite: 1, 2]
   * **Description :** `Regroupement des sous-réseaux des départements non-sensibles`[cite: 1, 2]
   * **Type :** Sélectionnez **`Network(s)`** dans le menu déroulant[cite: 1, 2].
4. Ajoutez un à un les réseaux cibles en cliquant sur le bouton **+ Add Network** pour chaque nouvelle ligne[cite: 1, 2] :

| Réseau / IP Subnet | Masque | Description / Département associé |
| :--- | :---: | :--- |
| `172.16.74.0` | `24` | COMMUNICATION[cite: 1, 2] |
| `172.16.75.0` | `24` | COMMERCIAL[cite: 1, 2] |
| `172.16.77.0` | `24` | MARKETING[cite: 1, 2] |
| `172.16.78.0` | `24` | DEVELOPPEMENT (PRODUCTION)[cite: 1, 2] |
| `172.16.79.0` | `24` | R&D (RD)[cite: 1, 2] |
| `172.16.80.0` | `24` | SERVICES GENERAUX (LOGISTIQUE)[cite: 1, 2] |

5. Vérifiez la conformité des masques de sous-réseau (sélectionnez impérativement le suffixe **24** pour chaque ligne)[cite: 1, 2].
6. Cliquez sur **Save** tout en bas de la page[cite: 1, 2].
7. **IMPORTANT :** Cliquez sur le bouton vert **Apply Changes** qui apparaît en haut de l'écran pour valider la configuration[cite: 1, 2].

---

## 3. Implémentation des Règles de Filtrage par VLAN (Firewall Rules)

**Règle d'Or de l'Ordonnancement :** pfSense analyse les règles de pare-feu de haut en bas. Dès qu'une condition est remplie (première correspondance ou *First Match*), le traitement s'arrête et s'applique[cite: 1, 2]. Il est donc crucial de placer les autorisations spécifiques en haut et les restrictions globales en bas[cite: 1, 2]. En l'absence de règle, tout trafic inter-VLAN est soumis à un blocage par défaut[cite: 1, 2].

### 3.1. Configuration Pas-à-Pas d'un VLAN Standard (Exemple : COMMUNICATION)
Naviguez dans **Firewall ➔ Rules**, puis cliquez sur l'onglet correspondant à l'interface de votre VLAN (ex: **COMMUNICATION**)[cite: 1, 2]. Pour chaque règle, cliquez sur le bouton **Add (avec flèche vers le haut)** pour l'insérer en haut de la pile :

#### Règle 1 — Autoriser les requêtes DNS vers l'Active Directory
* **Action :** `Pass`[cite: 1, 2] | **Interface :** `COMMUNICATION`[cite: 1, 2] | **Address Family :** `IPv4`[cite: 1, 2]
* **Protocol :** `TCP/UDP`[cite: 1, 2]
* **Source :** `COMMUNICATION net`[cite: 1, 2]
* **Destination :** `Single host or alias` ➔ Valeur : `172.16.65.3` (IP de l'AD Principal)[cite: 1, 2]
* **Destination Port Range :** From port `53` (DNS) to port `53` (DNS)[cite: 1, 2].
* **Description :** `Flux DNS vers AD`[cite: 1, 2]

#### Règle 2 — Autoriser l'authentification Kerberos / LDAP / SMB vers l'AD
* **Action :** `Pass`[cite: 1, 2] | **Protocol :** `TCP/UDP`[cite: 1, 2] | **Source :** `COMMUNICATION net`[cite: 1, 2]
* **Destination :** `Single host or alias` ➔ Valeur : `172.16.65.3`[cite: 1, 2]
* **Destination Port Range :** Saisissez `any` *(ou utilisez un alias de ports préalablement créé incluant 88, 389, 445, 464)*[cite: 1, 2].
* **Description :** `Flux Auth Services AD`[cite: 1, 2]

#### Règle 3 — Autoriser l'accès au serveur Web Interne (WEB-INT)
* **Action :** `Pass`[cite: 1, 2] | **Protocol :** `TCP`[cite: 1, 2] | **Source :** `COMMUNICATION net`[cite: 1, 2]
* **Destination :** `WEB_INT net` *(ou le sous-réseau `172.16.68.0/24`)*[cite: 1, 2]
* **Destination Port Range :** From `HTTP (80)` to `HTTPS (443)`[cite: 1, 2].
* **Description :** `Accès Portail Web Interne`[cite: 1, 2]

#### Règle 4 — Autoriser l'accès aux Applications d'exploitation (APPS)
* **Action :** `Pass`[cite: 1, 2] | **Protocol :** `TCP`[cite: 1, 2] | **Source :** `COMMUNICATION net`[cite: 1, 2]
* **Destination :** `APPS net` *(ou le sous-réseau `172.16.66.0/24`)*[cite: 1, 2]
* **Destination Port Range :** From `HTTP (80)` to `HTTPS (443)`[cite: 1, 2].
* **Description :** `Accès GLPI / Zabbix`[cite: 1, 2]

#### Règle 5 — Autoriser l'accès d'inter-communication standard (Inter-VLAN Standard)
* **Action :** `Pass`[cite: 1, 2] | **Protocol :** `any`[cite: 1, 2] | **Source :** `COMMUNICATION net`[cite: 1, 2]
* **Destination :** `Single host or alias` ➔ Saisissez l'alias : **`DEPT_STANDARD`**[cite: 1, 2].
* **Destination Port Range :** `any`[cite: 1, 2]
* **Description :** `Interconnexion inter-départements standards`[cite: 1, 2]

#### Règle 6 — Autoriser l'accès Internet sortant uniquement (WAN)
* **Action :** `Pass`[cite: 1, 2] | **Protocol :** `TCP/UDP`[cite: 1, 2] | **Source :** `COMMUNICATION net`[cite: 1, 2]
* **Destination :** `any`[cite: 1, 2]
* **Destination Port Range :** `any` *(ou restreindre aux ports de navigation sécurisés 80, 443, 53)*[cite: 1, 2].
* **Description :** `Accès Internet Sortant restreint`[cite: 1, 2]

**Note de cloisonnement pour les zones sensibles (RH, FINANCE, JURIDIQUE, DIRECTION, DSI) :**
 Pour ces interfaces critiques, appliquez **uniquement** les règles 1, 2, 3, 4 et 6[cite: 1, 2]. N'ajoutez **jamais** la règle 5 (Pas d'accès vers l'alias `DEPT_STANDARD`)[cite: 1, 2]. L'omission de cette règle garantit leur étanchéité complète et leur isolation vis-à-vis du reste de l'entreprise[cite: 1, 2].

---

### 3.2. Configuration des Règles pour les VLANs Techniques Communs

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

Les bonnes pratiques de sécurité et d'audit de l'infrastructure XenTech exigent la mise en place d'une règle de blocage finale visible, explicite et journalisée tout en bas de chaque interface réseau[cite: 1, 2].

1. Dans l'onglet de votre interface (ex: **COMMUNICATION**), cliquez sur le bouton vert **Add (avec flèche vers le bas)** pour insérer la règle à la toute fin de la liste actuelle[cite: 1, 2].
2. Configurez précisément les champs de la règle de rejet absolu[cite: 1, 2] :
   * **Action :** Sélectionnez `Block` (rejette le paquet silencieusement) ou `Reject` (renvoie un paquet d'erreur, recommandé en interne pour faciliter les diagnostics d'administration)[cite: 1, 2].
   * **Interface :** `COMMUNICATION`[cite: 1, 2]
   * **Address Family :** `IPv4`
   * **Protocol :** `any`[cite: 1, 2]
   * **Source :** `any`[cite: 1, 2]
   * **Destination :** `any`[cite: 1, 2]
3. **Section Logging & Audit (CRUCIAL) :**
   * Cochez obligatoirement la case **"Log packets that are handled by this rule"**[cite: 1, 2]. *Cette option permet d'envoyer toutes les tentatives d'accès non autorisées vers notre serveur Syslog centralisé (VLAN APPS)[cite: 1, 2].*
4. **Description :** Renseignez scrupuleusement l'identifiant d'audit suivant : **`[SECURITY] ISOLEMENT ZERO-TRUST - DENY ALL FINAL`**[cite: 1, 2].
5. Cliquez sur **Save**[cite: 1, 2].
6. **Vérification visuelle :** Assurez-vous que cette règle se positionne bien en dernière place (à la toute fin de la grille sous la règle WAN)[cite: 1, 2]. Si nécessaire, utilisez les poignées de déplacement situées à gauche de la ligne pour la glisser vers le bas[cite: 1, 2].
7. Cliquez sur le bouton supérieur **Apply Changes** pour recharger la politique de sécurité et appliquer les modifications sur le pare-feu[cite: 1, 2].
