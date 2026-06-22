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
Un serveur **Syslog** est un serveur de centralisation des journaux (logs). Le rôle d'un serveur Syslog est de **collecter** tous ces journaux au même endroit plutôt que de les laisser éparpillés sur chaque machine. Cela facilite grandement le travail de l'administrateur : il peut **consulter**, **rechercher** et **analyser** tout ce qui se passe sur le réseau depuis un **point central**, corréler des événements entre plusieurs équipements, **garder un historique** (utile pour le dépannage ou la sécurité), et **être alerté** en cas de problème. C'est aussi un **outil important** pour la **traçabilité** et la **sécurité**, car il conserve une trace de l'activité, y compris en cas d'incident. Syslog est un protocole standard que la quasi-totalité des équipements réseau savent utiliser.

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
- Un serveur **dédié** (souvent sous Linux) avec un logiciel de collecte Syslog : **rsyslog** ou **syslog-ng** sont les plus courants, ou une solution plus complète type **Graylog**.
- Une adresse **IP fixe** pour que tous les équipements sachent où envoyer leurs logs.
- Suffisamment d'espace disque : les journaux peuvent vite devenir volumineux, donc il faut prévoir le stockage et une rotation des logs (archivage/suppression automatique des anciens).
- Le port d'écoute ouvert : par défaut **514** (UDP, parfois TCP), et le service configuré pour recevoir les logs distants.
- Equipements à superviser : les configurer pour qu'ils envoient leurs journaux vers l'adresse IP du serveur Syslog (souvent une simple ligne de configuration indiquant l'adresse du collecteur).
- Une **horloge synchronisée** (NTP) sur tous les équipements, indispensable pour que les horodatages des logs soient cohérents entre eux.

---
# 4. Documentation

