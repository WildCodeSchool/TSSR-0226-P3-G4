# 1. Découpage des zones
### 1. ZONE UTILISATEURS
**Nous avons décidé de découper cette zone en 6 réseaux eux memes decoupés en 2 sous-reseaux**
- réseau 1 172.16.1.0 : VLAN 10 (.1 à .126), VLAN 20 (.129 à .254)
- réseau 2 172.16.2.0 : VLAN 30 (.1 à .126), VLAN 40 (.129 à .254)
- réseau 3 172.16.3.0 : VLAN 50 (.1 à .126), VLAN 60 (.129 à .254)
- réseau 4 172.16.4.0 : VLAN 70 (.1 à .126), VLAN 80 (.129 à .254)
- réseau 5 172.16.5.0 : VLAN 90 (.1 à .126), VLAN 100 (.129 à .254)
- réseau 6 172.16.6.0 : VLAN 110 (.1 à .126)
### 2. ZONE SERVEURS
**Cette zone sera composé de 3 serveurs sur le même réseau**
- Serveur ADDS DHCP DNS
- Serveur Stockage de fichiers
- Serveur Backup
### 3. MESSAGERIE CLOUD
**La messagerie cloud sera quand a elle sur un réseau apart.**
### 4. PARTENAIRE
**Le VLAN partenaire sera lui sur un réseau VLAN sécurisé**
# 2. Role des VLAN
### VLAN 10 (Ventes/dev com)
Il sert pour
### VLAN 20 (Développement)
Il sert pour
### VLAN 30 (Communication)
Il sert pour
### VLAN 40 (RH)
Il sert pour
### VLAN 50 (Marketing)
Il sert pour
### VLAN 60 (R&D)
Il sert pour
### VLAN 70 (Finance)
Il sert pour
### VLAN 80 (DSI)
Il sert pour
### VLAN 90 (Services Généraux)
Il sert pour
### VLAN 100 (Direction Générale)
Il sert pour
### VLAN 110 (Juridique)
Il sert pour
### VLAN 120 PARTENAIRES
Il sert pour
### VLAN 200 SERVEURS
Il sert pour
# 3. Flux principaux entre zones
# 4. Scéma du réseau logique
# 5. Principe de routage et filtrage
