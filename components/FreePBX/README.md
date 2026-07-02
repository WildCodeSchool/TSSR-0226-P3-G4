# Serveur de Téléphonie IP — FreePBX (SNG PBX)

## 1. Description du Service
Le serveur de Téléphonie sur IP (ToIP) repose sur la solution **FreePBX**, encapsulée au sein de la distribution Linux spécialisée **SNG PBX** (dérivée de Red Hat). Ce service gère l'enregistrement des extensions téléphoniques, le routage des appels internes et externes, ainsi que la configuration des commutateurs logiciels (Softphones 3CX) déployés sur les différents postes clients (Windows 11) et serveurs (Windows Server 2022) du laboratoire.

L'instance est déployée de manière isolée sur un hyperviseur Proxmox VE tout en intégrant des mécanismes de durcissement (Hardening) liés à l'accès distant sécurisé.

## 2. Caractéristiques Techniques et Fiche d'Identité
* **Nom d'hôte par défaut :** `freepbx.xtech.green`
* **Distribution de Base :** SNG PBX (Sous environnement Red Hat Enterprise Linux)
* **Adresse IP assignée :** `172.16.64.31/24`
* **Hyperviseur / Environnement :** Proxmox VE
* **Spécifications de la Machine Virtuelle / Conteneur :**
  * **Template utilisé :** SNG PBX
  * **Processeur (CPU) :** 1 Core
  * **Mémoire (RAM) :** 2 Go
  * **Stockage :** 20 Go
  * **Type :** Conteneur Non-privilégié (`Unprivileged: Yes`)
  * **Sécurité :** Pare-feu Proxmox décoché (Firewall : No)

## 3. Piliers de Sécurité et d'Architecture
* **Cloisonnement des Droits SSH :** Interdiction stricte de la connexion directe en tant que `root` via SSH. L'administration à distance transite obligatoirement par un compte utilisateur dédié à privilèges restreints (`t1`).
* **Transition vers le Modèle Sans Mot de Passe (Zero-Password SSH) :** L'authentification par mot de passe traditionnel est configurée de manière temporaire. Le standard de production impose l'usage exclusif d'un échange de clés asymétriques (paire de clés SSH générée via `ssh-keygen`).
* **Gestion du Filtrage :** Le contrôle des flux et la journalisation des paquets VoIP (protocoles SIP sur le port 5060 et RTP pour la voix) sont délégués au pare-feu centralisé de l'infrastructure (pfSense).

## 4. Architecture de la Documentation
Naviguez à travers les différents modules de l'infrastructure de téléphonie à l'aide des fichiers dédiés suivants :

* **[Guide d'Installation et de Déploiement](./Install.md)** : Initialisation graphique sur Proxmox VE, choix du mode standard, définition du mot de passe maître et initialisation du système.
* **[Guide d'Exploitation et de Configuration](./User_guide.md)** : Paramétrage régional (clavier Azerty), gestion des accès d'administration SSH, cycle de sécurisation par clés asymétriques et accès à la mire d'administration Web GUI.
* **[Guide de Résolution des Incidents](./FAQ.md)** : Traitement des alertes et exceptions PHP lors de l'accès utilisateur SSH, et gestion du comportement du clavier lors de la phase d'installation.
* **[3CX](./3CX.md)** : Communiquer par le biais d'un client SIP
