# Infrastructure Web — Serveurs Apache2 (Debian 13)

## 1. Description du Service
L'infrastructure web de l'entreprise repose sur deux serveurs HTTP **Apache2** distincts, chacun hébergé sur une machine virtuelle (VM) dédiée sous **Debian 13 (Trixie)** au sein de l'environnement d'virtualisation Proxmox VE. 

Cette architecture sépare strictement les flux de production publics et privés :
1. **Serveur Web Interne :** Portail applicatif d'entreprise à destination exclusive des collaborateurs.
2. **Serveur Web Externe :** Site vitrine institutionnel accessible publiquement depuis Internet.

## 2. Cartographie des Instances et Objectifs

### VM Web Interne (`interne.xtech.green`)
* **Rôle :** Espace intranet collaboratif privé.
* **Services hébergés :** * Portail interne d'accès aux applications d'entreprise.
  * Point d'ancrage et redirection vers le logiciel de ticketing (**GLPI**).
  * Flux d'actualités (*News*) et notes de service de l'entreprise.
* **Racine des fichiers (DocumentRoot) :** `/var/www/xtech-interne/`

### VM Web Externe (`externe.xtech.green`)
* **Rôle :** Site vitrine de l'entreprise accessible au public.
* **Services hébergés :**
  * Portail informatif global de l'organisation.
  * Présentation de l'organigramme et de la structure d'entreprise.
  * Actualités publiques, communiqués de presse et formulaire de contact.
* **Racine des fichiers (DocumentRoot) :** `/var/www/xtech-externe/`

## 3. Plan de la Documentation
* **[Guide d'Installation et Déploiement](./Install.md)** : Initialisation d'Apache2, configuration réseau, création des arborescences de dossiers, écriture des fichiers de configuration VirtualHost et commandes de Rollback.
* **[Guide d'Exploitation et Résolution des Incidents ](./User_guide.md)** : Gestion quotidienne des services, maintenance des pages `index.html`, et fiches de débug (pannes DNS, pertes de connectivité ou erreurs d'aiguillage).
* **[Serveur Web interne](Serveur_Web_Interne.md)**
* **[Serveur Web externe](Serveurs_Web_Externe.md)**
* **[FAQ](./FAQ.md)**
