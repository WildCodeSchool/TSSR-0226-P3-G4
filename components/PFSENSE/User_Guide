# Guide d'Utilisation du Filtrage & Gestion des Règles pfSense

Ce guide détaille la philosophie de filtrage appliquée sur le pare-feu `pfSense-XTech` et la gestion courante des politiques d'accès.

## Philosophie Zero Trust
Par défaut, pfSense applique une règle **Deny All** invisible en bas de chaque interface. 
* Si un flux n'est pas explicitement autorisé en haut de la liste, il est **bloqué et journalisé**.
* Les connexions sont à changement d'état (*stateful*) : autoriser le flux "Aller" valide implicitement le flux "Retour".

## Matrice de Cloisonnement des Départements

### 1. Modèle "Isolation Sélective" (Départements Standards)
Les départements non-sensibles utilisent un alias réseau global nommé `DEPT_STANDARD` pour pouvoir communiquer entre eux (partages de fichiers, collaboration).
* **Alias `DEPT_STANDARD` :** Regroupe COMMERCIAL, MARKETING, DEVELOPPEMENT, R&D, SERVICES GENERAUX, COMMUNICATION.
* **Règle associée :** `Pass` | Source: `[VLAN] net` | Destination: `DEPT_STANDARD` | Port: `any` (ou restreint selon besoin).

### 2. Isolation Renforcée (Départements Sensibles)
Les réseaux **RH, FINANCE, JURIDIQUE, DIRECTION et DSI** sont soumis à un isolement strict.
* Aucune règle vers l'alias `DEPT_STANDARD` ou vers un autre VLAN sensible n'est tolérée.
* Ils ne possèdent que les règles de survie (Règles 1 à 6 : AD, Web interne, Apps et Internet).

## Ordonnancement Standard d'un VLAN Département
Les règles doivent impérativement respecter cet ordre pour éviter les contournements :

1. **Règle 1 (DNS) :** `Pass` | TCP/UDP | Destination: `172.16.65.3` (AD) | Port: `53`
2. **Règle 2 (Auth) :** `Pass` | TCP/UDP | Destination: `172.16.65.3` (AD) | Ports: `88, 389, 445, 464` (Kerberos/LDAP/SMB)
3. **Règle 3 (Intranet) :** `Pass` | TCP | Destination: `172.16.68.0/24` (WEB-INT) | Ports: `80, 443`
4. **Règle 4 (Outils IT) :** `Pass` | TCP | Destination: `172.16.66.0/24` (APPS) | Ports: `80, 443`
5. **Règle 5 (Inter-Dept) :** *Uniquement pour les VLANs Standards* | Destination: `DEPT_STANDARD` | Port: `any`
6. **Règle 6 (Internet) :** `Pass` | TCP/UDP | Destination: `any` (WAN) | Ports: `80, 443, 53`
