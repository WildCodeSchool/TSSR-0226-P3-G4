# README - Déploiement de FreeRADIUS sur pfSense

## Sommaire   

**[Rôle du service](#rôle-du-service)**    
**[Position dans l'infrastructure](#position-dans-linfrastructure)**    
**[Prérequis](#prérequis)**    
**[Documentation](#documentation)**      


## Rôle du service
Centraliser l'authentification réseau via le protocole RADIUS. Utiliser FreeRADIUS pour sécuriser les accès et coupler le service à un portail captif pour filtrer la connexion des utilisateurs.

## Position dans l'infrastructure
Agir comme le moteur d'authentification principal hébergé sur pfSense. Interroger la base d'utilisateurs locale lors de chaque tentative de connexion au portail captif et valider les accès avant d'autoriser le trafic réseau vers l'extérieur.

## Prérequis
Disposer d'une instance pfSense opérationnelle avec une interface LAN configurée. Accéder aux droits administrateur sur l'interface Web. Vérifier la connectivité réseau de base pour permettre la communication entre le portail captif et le service RADIUS.

## Documentation
Consulter les guides techniques pour effectuer la mise en place complète du système :

**[Consulter le guide d'installation](install.md)** pour configurer le package et le serveur FreeRADIUS.

**[Consulter le guide d'utilisation](user_guide.md)** pour gérer les utilisateurs et configurer le portail captif.

