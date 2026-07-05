# Intégration Ubuntu 24.04 dans Active Directory & Gestion des GPO

Ce projet formalise la procédure d'intégration manuelle des serveurs Linux Ubuntu au sein du domaine Active Directory Windows Server 2022 de l'entreprise, incluant la gestion centralisée des stratégies de groupe (GPO) et l'alignement sur le modèle de Tiering de sécurité.

## Prérequis Plateforme

Assurer la conformité de l'environnement virtuel avant toute manipulation :
* Hyperviseur : Proxmox VE
* Système d'exploitation : VM Ubuntu 24.04 LTS
* Mémoire vive : 4 Go RAM
* Stockage : 20 Go d'espace disque
* CPU : 1 Core

## Contenu de la Documentation

Consulter les guides dédiés pour l'exécution des tâches :
1. **[Install.md](Install.md)** : Procédure technique d'installation des paquets, configuration réseau, jointure au domaine `xtech.green` et déploiement d'Adsys.
2. **[User_guide.md](User_guide.md)** : Guide d'exploitation pour les administrateurs, cycle de vie de la machine et vérification de la descente des GPO.
