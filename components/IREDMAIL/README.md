# Plateforme de Messagerie Centralisée - iRedMail & Thunderbird

## Sommaire
* **[1. Rôle du service](#1-rôle-du-service)**    
* **[2. Position dans l'architecture](#2-position-dans-larchitecture)**    
    * **[2.1 Serveur Principal](#21-serveur-principal)**    
    * **[2.2 Serveur Backup](#22-serveur-backup)**    
* **[3. Prérequis](#3-prérequis)**    
    * **[3.1 Pour le Serveur](#31-pour-le-serveur)**    
    * **[3.2 Pour le client](#32-pour-le-client)**    
* **[4. Documentation associée](#4-documentation-associée)**    

---

## 1. Rôle du service

iRedMail est une solution gratuite et open source permettant de monter facilement un serveur de messagerie (e-mails) complet sur une machine Linux. Au lieu de passer par un service tiers comme Gmail ou Outlook, nous hébergeons nous-mêmes nos adresses e-mails et nos courriers au sein de notre infrastructure. 

iRedMail installe et interconnecte automatiquement tous les composants nécessaires : la partie qui envoie les e-mails (Postfix), celle qui les reçoit et les stocke (Dovecot), des filtres de sécurité performants (anti-spam et anti-virus), ainsi qu'une interface web (Webmail Roundcube) pour consulter les messages depuis un navigateur et une console d'administration (iRedAdmin) pour gérer les comptes et les domaines. Cette solution évite d'avoir à configurer manuellement chaque service à la main.

---

## 2. Position dans l'architecture

Pour garantir la haute disponibilité de notre service de messagerie, nous avons intégré un serveur principal et un serveur de redondance (Backup).

### 2.1 Serveur Principal
* **Nom du serveur :** `SRV-iRedMail` (Conteneur LXC Debian 12)
* **Adresse IP :** `172.16.64.30/24`
* **Gateway :** `172.16.64.1`


---

## 3. Prérequis

### 3.1 Pour le Serveur
* **Environnement système :** Déployer une machine Linux Debian 12 fraîchement installée et dédiée uniquement à cet usage (aucune autre application installée pour éviter tout conflit applicatif).
* **Accès privilèges :** Disposer d'un accès administrateur (`root` ou privilèges `sudo`) pour exécuter l'assistant d'installation.
* **Ressources matérielles :** Allouer au minimum **4 Go de RAM** et **20 Go d'espace disque**, l'antivirus de messagerie intégré étant particulièrement gourmand en ressources.
* **Réseau :** Configurer une adresse IP fixe dédiée au sein de notre sous-réseau.
* **Nom d'hôte :** Définir un nom de domaine complet (FQDN) pour le serveur (ex. `mail.Xtech.green`).
* **Configuration DNS :** Créer les enregistrements indispensables sur notre serveur DNS Windows (`172.16.64.3`) :
    * Un enregistrement de type **A** pointant le FQDN vers l'IP du serveur.
    * Un enregistrement de type **MX** pour aiguiller le routage du courrier vers le serveur.
    * Un enregistrement de type **SPF (TXT)** afin de légitimer nos envois et éviter le classement en spam.
* **Réseau / Pare-feu :** Ouvrir les ports réseaux nécessaires sur notre pare-feu pfSense :
    * Flux de messagerie : `25` (SMTP), `143` (IMAP), `587` (SMTP sécurisé).
    * Flux web (Administration & Webmail) : `80` (HTTP) et `443` (HTTPS).

### 3.2 Pour le client
* **Poste client de test :** Utiliser notre machine Windows 11 `T1` (`172.16.64.10`) connectée au réseau.
* **Résolution de noms :** S'assurer que le client pointe vers notre serveur DNS pour résoudre correctement l'adresse `mail.Xtech.green`.
* **Logiciels clients :** Utiliser un navigateur web moderne pour l'accès au Webmail ou disposer du client de messagerie lourd **Thunderbird** préinstallé.

---

## 4. Documentation associée

Pour le déploiement et l'exploitation quotidienne de la plateforme, se référer aux guides techniques suivants :
* **[`INSTALL.md`](./INSTALL.md)** : Procédure pas à pas pour préparer le système, configurer la zone DNS Active Directory et installer la suite logicielle iRedMail.
* **[`USER_GUIDE.md`](./USER_GUIDE.md)** : Guide de gestion des boîtes aux lettres via iRedAdmin, utilisation du Webmail Roundcube et configuration pas à pas du client lourd Thunderbird.
