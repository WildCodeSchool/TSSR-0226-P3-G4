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

### 2.1 Pour le Serveur : 
- Adresse IP fixe sur le serveur DHCP : il ne peut pas distribuer des IP s'il en reçoit une lui-même.
- Étendue (scope) configurée : plage d'adresses à distribuer + masque de sous-réseau.
- Serveur sur le bon réseau/VLAN, ou un relais DHCP si les clients sont sur un autre segment.
- Autorisation dans l'AD (Windows Server) : le serveur DHCP doit être "autorisé" dans Active Directory pour démarrer.
- Options bien définies : passerelle par défaut, DNS, nom de domaine.
- Pas de conflit : un seul serveur DHCP actif par plage, sinon collisions de baux.

### 2.2 Pour le client
- Carte réseau configurée en mode automatique (DHCP activé), pas en IP fixe sino pas d'ip dynamique.
- Connectivité physique/logique : câble branché ou Wi-Fi associé, port switch actif.
- Etre sur le même réseau/VLAN que le serveur, ou alors un relais DHCP présent si le serveur est ailleurs.
- Broadcast autorisé : le client envoie un DHCPDISCOVER en broadcast, donc rien ne doit le bloquer (firewall, port-security mal réglé).
- Aucune IP statique déjà en place qui empêcherait la demande.
---
# 3. Configuration détaillé

Serveur **principal**: 
- Nom du serveur Windows 2022 (GUI): **XTSE-410**
- Adresse IP : **172.16.64.3**
- Gateway : **172.16.64.254**

Serveur **backup** :
- Nom du serveur CORE (CLI) : **XTSE-412**
- Adresse IP : **172.16.64.16**
- Gateway : **172.16.64.254**

# 4. Documentation Associé
