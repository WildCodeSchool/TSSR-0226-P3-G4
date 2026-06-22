# Sommaire

1.  [1. Role du service](#1-Role-du-service)
2.  [2. Position dans l'architecture](#2-Position-dans-lrchitecture)
    - [2.1 Serveur Principal](#21-Serveur-Principal)
    - [2.2 Serveur Backup](#22-Serveur-Backup)
3.  [3. Prérequis](#3-Prérequis)
    - [3.1 Pour le Serveur](#31-Pour-le-Serveur)
    - [3.2 Pour le client](#32-Pour-le-client)
4.  [4. Documentation associé](#4-Documentation-Associé)

---
# 1. Role du service
Zabbix est une solution de **supervision** (monitoring) **open source et gratuite**, qui surveille en continu l'état et **les performances d'une infrastructure** : serveurs, équipements réseau, services, applications... Son rôle est de **vérifier que tout fonctionne**, collecte des mesures (charge CPU, mémoire, espace disque, disponibilité, trafic réseau...), affiche le tout dans des tableaux de bord et déclenche des alertes quand un seuil est dépassé ou qu'un équipement tombe en panne. L'administrateur peut ainsi réagir de façon proactive. Il fonctionne soit avec un agent installé sur les machines à surveiller (pour des mesures détaillées), soit sans agent via des protocoles standards comme SNMP (pour les équipements réseau) ou des simples vérifications réseau (ping, ports, HTTP...).

---
# 2. Position dans l'architecture

### 2.1 Serveur **Principal**: 
- Nom du serveur : ****
- Adresse IP : ****
- Gateway : ****

### 2.2 Serveur **Backup** :
- Nom du serveur : ****
- Adresse IP : ****
- Gateway : ****

---
# 3. Prérequis 
- Un serveur sous Linux (Debian, Ubuntu, RHEL/Rocky...) pour héberger le serveur Zabbix.
- Une base de données (MySQL/MariaDB, PostgreSQL...) pour stocker les données collectées et l'historique.
- Un serveur web (Apache ou Nginx) avec PHP pour l'interface web d'administration.
- Une adresse IP fixe pour que les agents et équipements sachent où envoyer leurs données.
- Des ressources suffisantes (RAM, CPU, disque), à dimensionner selon le nombre d'éléments surveillés et la durée d'historique conservée.
- Côté machines à superviser : installer l'agent Zabbix (sur Windows ou Linux), ou activer SNMP sur les équipements réseau.
- Les ports ouverts nécessaires : 10051 (serveur Zabbix), 10050 (agent), plus 161 UDP pour le SNMP si utilisé.
- Une horloge synchronisée (NTP) sur l'ensemble, pour la cohérence des mesures et des alertes.

---
# 4. Documentation

