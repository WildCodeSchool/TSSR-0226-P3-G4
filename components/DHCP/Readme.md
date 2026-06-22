## Sommaire

1. [Role du service](#1-Role-du-service)
2. [Position dans l'architecture](#2-Position-dans-lrchitecture)
  2.1. [2.1 Serveur Principal](#21-Serveur-Principal)
4. [Information Technique](#3-Information-Technique)
5. [Documentation associé](4-Documentation-Associé)

---
## 1. Role du service

Son role **principal** est d'assurer la configuration automatique des paramètres réseau sur les equipements connectés :
- Attribution **automatique** et **dynamique** d'une adresse IP unique et du masque de sous-réseau.
- Fournir les paramètres **essentiels** comme l'adresse de la **passerelle** par défault et les services lié au **DNS**.
- Faire **respecter** l'architecture mise en place.
- Réduction des **erreurs** (pas de conflis d'IP en manuelle)
- Gain de temps **importants** (automatisation et centralisation)

---
# 2. Position dans l'architecture

### 2.1 Serveur **Principal**: 
- Nom du serveur Windows 2022 (GUI): **XTSE-410**
- Adresse IP : **172.16.64.3**
- Gateway : **172.16.64.254**

### 2.1 Serveur **Backup** :
- Nom du serveur CORE (CLI) : **XTSE-412**
- Adresse IP : **172.16.64.16**
- Gateway : **172.16.64.254**

---
## 3. Prérequis 

### 3.1 Pour le Serveur : 
- Adresse IP fixe sur le serveur DHCP : il ne peut pas distribuer des IP s'il en reçoit une lui-même.
- Étendue (scope) configurée : plage d'adresses à distribuer + masque de sous-réseau.
- Serveur sur le bon réseau/VLAN, ou un relais DHCP si les clients sont sur un autre segment.
- Autorisation dans l'AD (Windows Server) : le serveur DHCP doit être "autorisé" dans Active Directory pour démarrer.
- Options bien définies : passerelle par défaut, DNS, nom de domaine.
- Pas de conflit : un seul serveur DHCP actif par plage, sinon collisions de baux.

### 3.2 Pour le client
- Carte réseau configurée en mode automatique (DHCP activé), pas en IP fixe sino pas d'ip dynamique.
- Connectivité physique/logique : câble branché ou Wi-Fi associé, port switch actif.
- Etre sur le même réseau/VLAN que le serveur, ou alors un relais DHCP présent si le serveur est ailleurs.
- Broadcast autorisé : le client envoie un DHCPDISCOVER en broadcast, donc rien ne doit le bloquer (firewall, port-security mal réglé).
- Aucune IP statique déjà en place qui empêcherait la demande.

---
## 4. Documentation
