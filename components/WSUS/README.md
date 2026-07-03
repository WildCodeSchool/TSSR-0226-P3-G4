# Serveur de Mise à Jour WSUS (Windows Server Update Services)

Ce dépôt contient la documentation technique nécessaire au déploiement et à l'exploitation d'un serveur de gestion des mises à jour Microsoft (WSUS) sous Windows Server 2022 au sein d'un environnement d'entreprise.

## Présentation du Projet
L'objectif est de centraliser, tester, valider et planifier la distribution des correctifs de sécurité et des mises à jour logicielles pour l'ensemble du parc informatique (Clients Windows 11, Serveurs membres et Contrôleurs de domaine).

## Architecture et Pré-requis

### Environnement de virtualisation
* **Hyperviseur :** VirtualBox / Proxmox VE
* **Machine Virtuelle WSUS :** `XTSE-419`

### Spécifications de la VM WSUS
| Composant | Configuration minimale requis |
| :--- | :--- |
| **Système d'exploitation** | Windows Server 2022 (à jour) |
| **Réseau** | Carte réseau configurée en *Réseau Interne* |
| **Adresse IP** | `172.16.64.19/24` |
| **Stockage Dédié** | Un espace disque libre non configuré d'au moins **20 Go** (dédié à la partition WSUS) |

## Structure de la Documentation
L'ensemble des procédures est découpé pour faciliter le déploiement et la maintenance courante :

1. **[User_guide.md](./User_guide.md) :** Le guide complet étape par étape comprenant :
   * La préparation du stockage local et du rôle WSUS.
   * La configuration initiale du service et des synchronisations en amont.
   * La création des groupes de ciblage client.
   * Le déploiement des stratégies de groupe (GPO) côté Active Directory.
   * La méthodologie de gestion et d'approbation des correctifs.

## Démarrage Rapide
Pour démarrer l'installation de l'infrastructure, veuillez vous référer directement au document    
**[Guide d'installation et d'utilisation (User_guide.md)](./User_guide.md)**.   
**[Résolutions de problèmes/bug (FAQ.md)](./FAQ.md)**.
