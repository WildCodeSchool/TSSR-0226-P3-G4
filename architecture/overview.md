# PROJET : Refonte de l'infrastructure réseau - XenTech

1. [Résumé de la situation (réseau actuel)](#Résumé-de-la-situation-(réseau-actuel))
2. [Objectifs du projet](#Objectifs-du-projet)
3. [Shéma global](#Shéma-global)
4. [Liste des briques techniques](#Liste-des-briques-techniques)
5. [Lien vers les autres fichiers HLD](#Lien-vers-les-autres-fichiers-HLD)

# Résumé 
XenTech est une start-up en pleine expansion (218 collaborateurs) qui repose actuellement sur une infrastructure informatique "domestique" et non professionnelle. Malgré une levée de fonds réussie, le système actuel présente des failles critiques :

Risque de Sécurité Majeur : Absence de gestion centralisée des identités (Workgroups). 

Absence de Sauvegarde : 100% des données critiques sont stockées localement sur des PC portables. 

Infrastructure Réseau Saturée : Le réseau repose sur une simple box FAI et des répéteurs Wi-Fi. 

# Objectifs du projet
L'objectif principal est de concevoir et déployer une infrastructure réseau et système de classe entreprise, sécurisée, évolutive et prête pour les futurs partenariats.

## Objectifs Techniques
Centralisation de l'Identité : Déployer un annuaire (type Active Directory ou LDAP) pour gérer les 218 utilisateurs et les accès aux ressources.

Refonte du Réseau : Mettre en place un routeur/firewall professionnel.

Segmenter le réseau en VLANs (un par département) pour accroître la sécurité et la performance.

Revoir le plan d'adressage IP pour absorber la croissance future.

Continuité d'Activité : Implémenter une solution de stockage centralisée et une stratégie de sauvegarde automatisée.

Standardisation du Parc : Assainir et intégrer la liste des collaborateurs pour assurer un suivi rigoureux du matériel hétérogène.

## Objectifs Fonctionnels
Sécurisation du Turnover : Permettre une gestion rapide des arrivées (onboarding) et des départs (offboarding) pour supprimer les risques liés aux comptes obsolètes.

Ouverture vers l'Extérieur : Préparer l'infrastructure pour accueillir des partenaires externes (accès réseau dédié) et permettre, à terme, le télétravail via VPN.

Professionnalisation : Passer d'une gestion "artisanale" à une administration centralisée et monitorée.

[IMPORTANT]

L'assainissement préalable du fichier ListeRHCollaborateurs est une étape critique et obligatoire. L'importation de données brutes contenant des doublons ou des incohérences dans le futur système de gestion d'identité (annuaire) compromettrait l'intégrité de toute l'infrastructure dès son déploiement. Un nettoyage rigoureux est le gage d'une base saine pour la sécurité future de XenTech.

# Shéma global

<img width="9455" height="5751" alt="image" src="https://github.com/user-attachments/assets/629caafc-5be5-46ef-8a5f-1270786bd563" />

# Liste des briques techniques

# Lien vers les autres fichiers HLD


