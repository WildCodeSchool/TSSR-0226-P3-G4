# Déploiement de FreeRADIUS et Portail Captif sur pfSense

## Sommaire
- **[Rôle du service](#rôle-du-service)**    
- **[Position dans l'infrastructure](#position-dans-linfrastructure)**    
- **[Prérequis](#prérequis)**    
- **[Documentation](#documentation)**    

## Rôle du service

FreeRADIUS est un serveur d'authentification centralisé utilisant le protocole RADIUS (Remote Authentication Dial-In User Service). Son rôle est de sécuriser l'accès au réseau en vérifiant les identifiants des utilisateurs avant de leur accorder l'accès aux ressources (Internet, serveurs, etc.). Dans cette configuration, il est couplé à un Portail Captif pour forcer l'authentification des clients via une page de connexion web (login/mot de passe).

### 1. Garantir la responsabilité juridique et l'imputabilité
Dans un environnement professionnel ou public, l'accès à Internet constitue une responsabilité légale. En l'absence d'authentification, tout utilisateur branchant un appareil sur le réseau navigue sous l'adresse IP publique de l'organisation. En cas d'usage illicite (téléchargement illégal, attaques informatiques), la responsabilité de l'administrateur réseau est engagée. L'implémentation d'un système de login et de mot de passe permet d'associer de manière irréfutable chaque activité réseau à une identité humaine précise, assurant ainsi une traçabilité probante.

### 2. Appliquer un contrôle des accès
Sans RADIUS ni portail captif, la gestion réseau se limite à une logique binaire "tout ou rien". Le déploiement d'un système d'authentification permet de restreindre l'accès à des groupes d'utilisateurs spécifiques. Il devient possible de définir des politiques de filtrage fines, telles que l'autorisation d'accès à Internet pour les stagiaires tout en restreignant l'accès aux serveurs de fichiers, tandis que d'autres groupes bénéficient de privilèges étendus. Cette configuration offre la possibilité de révoquer l'accès d'un utilisateur instantanément depuis le serveur central, sans nécessité d'intervenir sur la configuration de chaque équipement.

## Position dans l'infrastructure

Le portail captif et le serveur FreeRadius sont hébergés sur le pare-feu pfSense sur l'interface LAN `172.16.64.254`.

Agir comme le moteur d'authentification principal hébergé sur pfSense. Interroger la base d'utilisateurs locale lors de chaque tentative de connexion au portail captif et vider les accès avant d'autoriser le trafic réseau vers l'extérieur.

### 3. Renforcer la protection contre les accès non autorisés
Le couple login et mot de passe agit comme un verrou supplémentaire contre les intrusions physiques et logiques. Lorsqu'un visiteur branche un équipement sur une prise murale en l'absence de portail captif, l'accès au réseau est immédiat. Avec un portail captif, l'appareil connecté est confiné dans un environnement sécurisé, restreignant ses capacités d'interaction tant qu'une authentification valide auprès du serveur RADIUS n'est pas établie. Cette approche transforme le réseau en un espace *zero-trust*, où aucune confiance n'est accordée par défaut.

### 4. Assurer l'isolation des environnements
L'architecture déployée sur pfSense permet d'isoler les fonctions d'authentification des équipements d'accès (bornes Wi-Fi, commutateurs). Ces derniers restent des dispositifs "neutres" ne contenant aucune donnée sensible. Le serveur RADIUS demeure l'unique élément centralisant les secrets d'authentification. En cas de compromission d'un point d'accès, la base de données des mots de passe reste protégée au sein du serveur RADIUS, garantissant une sécurité accrue par cette centralisation.

## Prérequis
Disposer d'une instance pfSense opérationnelle avec une interface LAN configurée. Accéder aux droits administrateur sur l'interface Web. Vérifier la connectivité réseau de base pour permettre la communication entre le portail captif et le service RADIUS.

## Documentation
Consulter les guides techniques pour effectuer la mise en place complète du système :

- **[Consulter le guide d'installation](./Install.md)** pour configurer le package et le serveur FreeRADIUS.
- **[Consulter le guide d'utilisation](./User_guide.md)** pour gérer les utilisateurs et configurer le portail captif.

