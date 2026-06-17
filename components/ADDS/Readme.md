Active Directory Domain Services
Sommaire
1. Rôle du service
2. Position dans l'architecture
3. Prérequis
4. Fonctionnalités
5. Documentation liée
1. Rôle du service
Active Directory est le cœur de l'authentification et de la gestion centralisée des identités et des ressources de notre entreprise XENTECH

Il fournit :

Une authentification des utilisateurs et ordinateurs.
La possibilté de gérer l'architecture de notre entrprise  (comptes, groupes, mots de passe...).
Une politiques de sécurité (GPO – Group Policy Objects).
La résolution de noms interne (DNS intégré).
La base referenciel de la plupart des services (fichiers, messagerie, VPN...).

2. Position dans l'architecture
Serveurs : XTSE-410 (172.16.64.2)  et XTSE-412 (172.16.64.16) VLAN_X avec IP statique.
Redondance : 2 contrôleurs de domaine. 1 principal Windows Server 2022 et 1 Core en backup
Site AD : un site principal (Paris) pour le moement avec possibilité d'ajouter des sites distants dans le futur.

3. Prérequis
**Windows Server 2022**
- Au moins 8 vCPU / 32–64 Go RAM par DC physique ou virtuel.
- Stockage : 2 × SSD RAID1 minimum (OS) + espace pour la base NTDS (~10–20 Go selon taille).
- DNS intégré.
- NTP synchronisé.
- Firewall : ports AD ouverts entre DCs et clients (voir matrice flux)

**WindowsCore** Backup

4. Fonctionnalités
