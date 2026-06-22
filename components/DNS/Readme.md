# Sommaire

1.  [Role du service](#-1-Role-du-service)
2.  [Position dans l'architecture](#2-Position-dans-lrchitecture)
    - [2.1 Serveur Principal](#21-Serveur-Principal)
    - [2.2 Serveur Backup](#-22-Serveur-Backup)
3.  [3. Prérequis](#3-Prérequis)
    - [3.1 Pour le Serveur](#-31-Pour-le-Serveur)
    - [3.2 Pour le client](#-32-Pour-le-client)
    - [3.3 Intégration dans l'AD](#-33-Intégration-dans-lAD)
4.  [Documentation associé](4-Documentation-Associé)

---
# 1. Role du service
Le role du **DNS** (Domain Name Service) est d'agire comme un **annuraire telephonique** mais pour **internet** il permet de traduire les **noms de domaines** en **adresse IP** qui elles sont comprehensibles par le matériel informatique, sans DNS il faudrait retenir et taper a chaque fois les memes adresses IP pour acceder a differents sites.

---
# 2. Position dans l'architecture
### 2.1 Serveur **Principal**: 
- Nom du serveur Windows 2022 (GUI): **XTSE-410**
- Adresse IP : **172.16.64.3**
- Gateway : **172.16.64.254**

### 2.2 Serveur **Backup** :
- Nom du serveur CORE (CLI) : **XTSE-412**
- Adresse IP : **172.16.64.16**
- Gateway : **172.16.64.254**

---
# 3. Prérequis 
### 3.1 Pour le Serveur : 
- Adresse IP fixe : un serveur DNS ne doit jamais avoir d'IP dynamique.
- Nom d'hôte et domaine définis.
- Zone(s) configurée(s) : zone de recherche directe (nom → IP) et idéalement la zone inverse (IP → nom) pour les PTR.
- Enregistrements de base créés : NS (serveur autoritaire), SOA (généré automatiquement), puis A/AAAA,. selon les besoins.
- Forwarders définis : pour résoudre les noms externes en redirigeant vers un DNS public ou celui du FAI.
- Service DNS installé et démarré (rôle DNS sous Windows Server, ou bind9 sous Linux).

### 3.2 Pour le client :
- Le client doit avoir l'adresse du serveur DNS renseignée.
- Connectivité réseau vers le serveur (pas de firewall bloquant le port 53 UDP/TCP).
- Bon suffixe DNS configuré si on résout des noms courts (ex. xtech.green).

### 3.3 intégration dans l'AD
- Le DNS doit accepter les mises à jour dynamiques pour que les contrôleurs de domaine y publient leurs enregistrements SRV.
- Le serveur DNS pointe sur lui-même comme DNS préféré (loopback: 127.0.0.1 ou sa propre IP).

---
# 4. Documentation


