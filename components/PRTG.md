#### Cette documentation détaille l'installation de **PRTG Network Monitor** pour l'entreprise **XTech**, la mise en place de la surveillance du pare-feu pfSense, et la construction d'un dashboard avec ajout de widgets.

--------

## Vue d'ensemble

| Élément              | Détail                                                  |
| ---------------------- | --------------------------------------------------------- |
| Serveur PRTG             | VM Windows dédiée, VLAN 20 — APPS, `172.16.66.0/24`         |
| Cible surveillée          | pfSense (interface WAN, LAN, et chaque VLAN)                |
| Méthode                   | SNMP (natif sur pfSense)                                    |

> PRTG nécessite un OS Windows (pas de version Linux/CT), contrairement à Zabbix/GLPI qui tournent en CT Debian — c'est pourquoi PRTG est sur une VM dédiée plutôt qu'un container Proxmox.

---

## PARTIE A — Installation de PRTG Network Monitor

### A1 — Pré-requis VM

- VM Windows Server (2019/2022) ou Windows 11, VLAN 20 — APPS
- IP statique : `172.16.66.40/24`
- Passerelle : `172.16.66.254`
- VLAN Tag sur l'interface réseau (Proxmox) : `20`
- RAM recommandée : 4 Go minimum (8 Go conseillé pour de la croissance du nombre de capteurs)

### A2 — Installation

1. Télécharger l'installeur PRTG (édition gratuite jusqu'à 100 capteurs, suffisante pour démarrer) depuis le site officiel Paessler.
2. Exécuter l'installeur, accepter les rôles IIS/services Windows requis (PRTG embarque son propre serveur web, pas besoin d'IIS).
3. À la fin de l'installation, PRTG démarre automatiquement le service `PRTG Core Server` et le service `PRTG Probe`.

### A3 — Premier accès

```
http://172.16.66.40:8080
```

ou en HTTPS si activé pendant l'installation. Création du compte administrateur lors du premier lancement.

### A4 — Règle pare-feu nécessaire

Comme pour Zabbix, le poste admin (MGMT, `172.16.64.0/24`) doit pouvoir atteindre l'interface web PRTG sur APPS. Règle à ajouter si elle n'existe pas déjà (cf. doc Zabbix, PARTIE B — la même règle MGMT → APPS peut couvrir les deux outils si elle inclut les bons ports) :

- Pass : Source `172.16.64.0/24` (MGMT) → Destination `172.16.66.40` (PRTG) port `8080,443`

---

## PARTIE B — Surveillance du pare-feu pfSense via SNMP

### B1 — Activer SNMP sur pfSense

Sur pfSense : **Services → SNMP** :

- Polling Port : `161` (par défaut)
- System location : `XTech - Salle serveur`
- System contact : `admin@xtech.green`
- Community String : choisir une chaîne non triviale (ex : `XtechSNMP2026`, pas `public`)
- **Save**

### B2 — Règle pare-feu pour autoriser le polling SNMP

PRTG (APPS) doit interroger pfSense en SNMP sur son interface LAN (`172.16.64.254`) — c'est un flux **APPS → MGMT**, sens inverse de la règle B Zabbix/PRTG admin web. Règle à ajouter sur pfSense lui-même (les règles d'interface ne s'appliquent pas au pare-feu en tant que destination de la même façon — pfSense filtre nativement l'accès à ses propres services via **Firewall → Rules → [interface concernée]**, ici APPS) :

- Pass : Source `172.16.66.0/24` (APPS) → Destination `172.16.64.254` (pfSense LAN) port `161/UDP`

> Par défaut, pfSense autorise déjà l'administration depuis le LAN sur certains services, mais SNMP doit être vérifié explicitement — ne pas supposer qu'il passe sans test (cf. PARTIE D, vérification).

### B3 — Ajouter pfSense comme device dans PRTG

Dans la console PRTG : **Devices → Add Device** :

- Device Name : `pfSense-XTech`
- IP Address/DNS Name : `172.16.64.254`
- Device Icon : Router/Firewall (pour la clarté visuelle du dashboard)

### B4 — Ajouter les capteurs SNMP

Clic droit sur le device `pfSense-XTech` → **Add Sensor** → rechercher et ajouter :

- **SNMP Traffic** (par interface : WAN, LAN, chaque interface VLAN) : volumes de trafic entrant/sortant
- **SNMP Library** (générique) ou **SNMP Custom** si vous voulez cibler des OID spécifiques à pfSense (ex : nombre d'états de connexion actifs, charge CPU du pare-feu)
- **Ping** : disponibilité de base de pfSense

PRTG lance un assistant de découverte automatique des interfaces SNMP disponibles sur l'équipement détecté — sélectionner au minimum les interfaces `WAN`, `LAN`, et les VLAN les plus critiques (AD, APPS, BASTION, JUMP, DMZ) pour ne pas saturer le dashboard avec les 22 VLAN si ce n'est pas nécessaire au quotidien.

### B5 — Capteur dédié sur l'état des passerelles (gateways)

Pour surveiller spécifiquement que `WANGW` reste online (visible normalement dans **Status → Gateways** sur pfSense) :

- **Add Sensor** → **Ping** sur l'IP de la gateway WAN (`10.0.0.1`)
- Seuil d'alerte : timeout > 3 paquets consécutifs perdus

---

## PARTIE C — Mise en place du dashboard et ajout de widgets

### C1 — Création d'un dashboard dédié

Dans PRTG : **Setup → Account Settings → Maps** (les "Maps" sont l'équivalent dashboard dans PRTG) → **Add new map** :

- Name : `Dashboard XTech - Infrastructure`
- Layout : grille libre

### C2 — Ajout des widgets principaux

Dans l'éditeur de map, glisser-déposer les widgets suivants depuis le panneau de gauche :

| Widget                     | Source                                  | Utilité                                          |
| ----------------------------- | ------------------------------------------ | --------------------------------------------------- |
| Gauge (jauge)                  | Capteur SNMP Traffic WAN                     | Visualiser le débit Internet en temps réel              |
| Status list                     | Tous les devices (pfSense, Zabbix, GLPI...)   | Vue d'ensemble santé "up/down" de toute l'infra        |
| Top 10 list                      | Capteur SNMP Traffic, trié par interface       | Identifier le VLAN le plus consommateur de bande passante |
| Graph (historique)               | Capteur Ping pfSense LAN                       | Tendance de latence/disponibilité sur 24h/7j             |
| Log/alarm list                    | Tous les capteurs en erreur                     | Liste des alertes actives, triée par sévérité            |

### C3 — Configuration d'un widget (exemple : Gauge trafic WAN)

1. Glisser le widget "Gauge" sur la map.
2. Dans la fenêtre de configuration : sélectionner le capteur `SNMP Traffic - WAN` créé en B4.
3. Choisir le canal à afficher (Traffic In ou Traffic Out, ou les deux en deux jauges distinctes).
4. Définir les seuils de couleur : vert sous 50 Mbps, orange 50-80 Mbps, rouge au-delà (à ajuster selon votre débit réel WAN).
5. **Save**.

### C4 — Disposition recommandée du dashboard

```
┌─────────────────────────────────────────────────────────┐
│  Status list : tous les devices (pfSense, Zabbix, GLPI...)  │
├─────────────────────┬─────────────────────┬───────────────┤
│  Gauge Trafic WAN In   │ Gauge Trafic WAN Out  │ Ping pfSense LAN │
├─────────────────────┴─────────────────────┴───────────────┤
│  Graph historique trafic WAN (24h)                            │
├──────────────────────────────────────────────────────────┤
│  Top 10 list : trafic par VLAN                                  │
├──────────────────────────────────────────────────────────┤
│  Log/alarm list : alertes actives                                │
└──────────────────────────────────────────────────────────┘
```

### C5 — Partage du dashboard

**Map → Properties → Sharing** : possibilité de générer un lien d'accès public en lecture seule (sans authentification) pour un affichage sur un écran de salle serveur, ou de restreindre l'accès à un groupe d'utilisateurs PRTG précis (admin réseau uniquement).

---

## PARTIE D — Vérification finale

1. **Devices → pfSense-XTech** : tous les capteurs SNMP doivent afficher un statut vert (`Up`) après quelques minutes de collecte initiale.
2. Couper temporairement le câble/lien WAN (ou simuler une coupure) → le capteur Ping gateway (B5) doit passer en rouge (`Down`) dans les 1-2 minutes, et une notification doit apparaître dans le **Log/alarm list** du dashboard.
3. Vérifier que le dashboard `Dashboard XTech - Infrastructure` affiche des données en temps réel sur tous les widgets, sans widget vide ou en erreur de configuration.
4. Si SNMP ne répond pas depuis PRTG vers `172.16.64.254`, vérifier dans l'ordre : la community string (B1) correspond bien entre pfSense et PRTG, la règle pare-feu B2 est bien appliquée, et que le service SNMP est bien démarré côté pfSense (**Status → Services**).
