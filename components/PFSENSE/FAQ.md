# FAQ — Sécurité & Architecture pfSense XenTech

### Q1. Pourquoi le VLAN 30 (BACKUP) ne contient-il aucune règle de pare-feu sortante ?
**C'est normal et volontaire.** Le réseau BACKUP est une zone de destination passive (Puits de données). Ce sont les serveurs de la zone `APPS` (GLPI/Zabbix via rsync/mysqldump) ou le `BASTION` qui initient les connexions vers les serveurs de sauvegarde. N'initiant aucun trafic lui-même, le VLAN BACKUP n'a besoin d'aucune règle d'autorisation sortante.

### Q2. Pourquoi la zone WEB-INT est-elle vide de règles ?
Le serveur de portail interne (`WEB-INT`) agit uniquement en mode d'écoute. Il reçoit le trafic HTTP/HTTPS initié par les utilisateurs des différents départements (autorisé via la règle 3 de chaque VLAN). N'ayant pas besoin de rebondir vers le LAN, ses règles restent vides par sécurité pour bloquer toute tentative de pivot en cas de compromission du serveur Web.

### Q3. Quelle est la différence de traitement entre le WIFI-GUEST et le WIFI-ENTREPRISE ?
* **WIFI-ENTREPRISE :** Destiné aux collaborateurs. Il possède les mêmes privilèges qu'un département standard (Accès AD, APPS, WEB-INT et Internet).
* **WIFI-GUEST :** Destiné aux visiteurs. Il possède **uniquement** un accès direct vers le WAN (`Internet`). L'accès à l'AD, aux applications ou à l'intranet `WEB-INT` lui est strictement interdit.

### Q4. Pourquoi le service DHCP de pfSense est-il désactivé sur le VLAN 10 (AD) ?
L'infrastructure Active Directory de XenTech s'appuie sur son propre contrôleur de domaine (`172.16.65.3`) pour assurer la distribution des baux DHCP et l'enregistrement dynamique des enregistrements DNS. Activer le DHCP de pfSense sur cette zone provoquerait un conflit critique de distribution de baux sur le réseau.
