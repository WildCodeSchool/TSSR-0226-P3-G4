# Sommaire

1. [Role du service](#-1-Role-du-service)  
2. [Prérequis](#-2-Prérequis)  
3. [Configuration détaillé](#-3-Configuration-détaillé)  
4. [Documentation Associé](#-4-Documentation-Associé)  

---
# 1. Role du service

Le role du **DNS** (Domain Name Service) est d'agire comme un **annuraire telephonique** mais pour **internet** il permet de traduire les **noms de domaines** en **adresse IP** qui elles sont comprehensibles par le matériel informatique, sans DNS il faudrait retenir et taper a chaque fois les memes adresses IP pour acceder a differents sites.

---
# 2. Prérequis
### Côté serveur
- Adresse IP fixe : un serveur DNS ne doit jamais avoir d'IP dynamique.
- Nom d'hôte et domaine définis.
- Zone(s) configurée(s) : zone de recherche directe (nom → IP) et idéalement la zone inverse (IP → nom) pour les PTR.
- Enregistrements de base créés : NS (serveur autoritaire), SOA (généré automatiquement), puis A/AAAA,. selon les besoins.
- Forwarders définis : pour résoudre les noms externes en redirigeant vers un DNS public ou celui du FAI.
- Service DNS installé et démarré (rôle DNS sous Windows Server, ou bind9 sous Linux).

### Côté intégration AD
- Le DNS doit accepter les mises à jour dynamiques pour que les contrôleurs de domaine y publient leurs enregistrements SRV.
- Le serveur DNS pointe sur lui-même comme DNS préféré (loopback: 127.0.0.1 ou sa propre IP).

### Côté client
- Le client doit avoir l'adresse du serveur DNS renseignée.
- Connectivité réseau vers le serveur (pas de firewall bloquant le port 53 UDP/TCP).
- Bon suffixe DNS configuré si on résout des noms courts (ex. xtech.green).

---
# 3. Configuration détaillé

Serveur **Brincipal**: 
- Nom du serveur Windows 2022 (GUI): **XTSE-410**
- Adresse IP : **172.16.64.3**
- Gateway : **172.16.64.254**

Serveur **Backup** :
- Nom du serveur CORE (CLI) : **XTSE-412**
- Adresse IP : **172.16.64.16**
- Gateway : **172.16.64.254**

# 4. Documentation Associé
