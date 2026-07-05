# Les objets AD
## Sommaire

1. [Les OU](#1-Les-ou)
   - [1.2 Création des OU Principales](#12-création-des-OU)
   - [1.3 Création des sous-OU](#13-création-des-sous-OU)
      - [1.3.1 Sous-OU Utilisateurs](#132-sous-ou-Utilisateurs)
      - [1.3.2 Sous-OU Administrateurs](#132-sous-ou-Administrateurs)

2. [Création des utilisateurs](#2-création-des-utilisateurs)
   - [2.1 Préparation du fichier CSV](#21-préparation-du-fichier-csv)
   - [2.2 Configuration du script](#22-configuration-du-script)
   - [2.3 Exécution du script](#23-exécution-du-script)
   - [2.4 Vérification](#24-vérification)

3. [Désactivation et archivage des utilisateurs](#25-Désactivation-et-archivage-des-utilisateurs)
      - [2.5.2 Configuration et exécution du script](#252-configuration-du-script-et-exécution-du-script)

4. [Féminisation des postes](#26-féminisation-des-postes)
      - [2.5.2 Configuration et exécution du script](#252-configuration-du-script-et-exécution-du-script)

5. [Déplacement automatique des ordinateurs](#3.déplacement-automatique-des-ordinateurs)
    - [3.1 Explication du script](#31-explication-du-script)
    - [3.2 Automatisation par AT](#32-automatisation-par-at)

6. [Création des groupes](#4-création-des-groupes)
   - [4.1 Arborescence des groupes de sécurité](#41-arborescence-des-groupes-de-sécurité)
   - [4.2 Création d'un groupe](#42-création-dun-groupe)
   - [4.3 Liste des groupes à créer](#43-liste-des-groupes-à-créer)

7. [Les GPO](#5-Les-GPO)
   - [5.1 Création de GPO](#51-création-de-GPO)
   - [5.2 GPO de sécurité](#52-GPO-de-sécurité)
   - [5.3 GPO standard](#53-GPO-standard)

8. [Tâche planifiée](#6-tâche-planifiée)

9. [Jonction au domaine](#7-jonction-au-domaine)

10. [Partage des rôles FSMO (PDC et RID)](#8-transfert-des-rôles-fsmo-pdc-et-rid)
   - [8.1 Prérequis et ajout du serveur](#81-prérequis-et-ajout-du-serveur)
   - [8.2 Installation d'Active Directory sur le serveur Core](#82-installation-dactive-directory-sur-le-serveur-core)
   - [8.3 Promotion en contrôleur de domaine](#83-promotion-en-contrôleur-de-domaine)
   - [8.4 Attribution des rôles FSMO](#84-attribution-des-rôles-fsmo)
