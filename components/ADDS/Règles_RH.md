# SOMMAIRE

1. [Processus de désactivation et d'archivage des utilisateurs qui ne font plus partie de l'entreprise](#1Processus-de-désactivation-et-darchivage-des-utilisateurs-qui-ne-font-plus-partie-de-lentreprise)

2. [Féminisation des postes](#2-féminisation-des-postes)

## 1. Processus de désactivation et d'archivage des utilisateurs qui ne font plus partie de l'entreprise

Le processus de désactivation et d'archivage des comptes utilisateurs est une étape essentielle de la gestion du cycle de vie des collaborateurs  
au sein de l'entreprise. Lorsqu'un salarié quitte l'organisation, il est indispensable de désactiver (sans le supprimer definitevement) rapidement  
son compte Active Directory afin de prévenir tout accès non autorisé :
- aux ressources,
- applications,
- données de l'entreprise,  
réduisant ainsi les risques liés à la sécurité de l'information.

L'archivage qui suit permet quant à lui de :
- conserver une traçabilité des comptes,
- respecter les  obligations légales et réglementaires en matière de conservation des données,
- tout en libérant les ressources actives (licences, boîtes mail, espaces  de stockage) associées aux comptes désactivés,
ce processus est automatisé et documenté pour garantir une gestion rigoureuse et cohérente des départs, limitant les oublis humains et renforçant la posture de sécurité globale du système d'information.

#### Le fichier CSV

Le fichier CSV est placé dans le meme dossier que le scripts son chemin est
```
C:\Scripts\Utilisateurs_Sortants.txt
```
A l'interieur le fichier CSV ne contient que le SAmAccountName et se presente comme ceci (exemple)
```
SamAccountName
jdupont
mmartin
psalvador
ijovanovic
```
Pas besoin d'autres colonnes le script s'occupe du reste.

#### Le script
Vous retrouverez le script ![ici]()

Le script est concu de telle facon que seule le SamAccountName a besoin d'etre renseigner et voivi ce qu'il fait pour chaque utilisateur sortant de la société
- Désactive le compte AD
- Retire l'utilisateur de tous les groupes de sécurité/distribution pour couper tout accès restant, sauf le Domain Users car se groupe ne donne accès a aucune information possiblement sensible.
- Met a jour la description de l'utilisateur avec la date de désactivation, afin de garder une traçabilité en interne.
- Déplace le compte de/des utilisateur(s) vers l'OU d'archivage dédiée (PRS-UAR)
Deux modes d'utilisation sont possible en fonction des besoins

Le mode CSV pour désactiver des utilisateurs en masse
```
.\Désactivation_Archivage_Utilisateurs.ps1
```

Le mode Manuel au cas ou il n'y a que très peu d'utilisateurs
```
.\Désactivation_Archivage_Utilisateurs.ps1 -SamAccountName "jdupont"
```
Une fois le script executé le détail complet est dans le fichier log
```
C:\Logs\PS\Désactivation_Archivage_Utilisateurs.log.
```
## 2. Féminisation des postes

La féminisation des intitulés de poste est un enjeu important pour l'entreprise, car elle contribue à une meilleure représentation et reconnaissance des collaboratrices au sein de l'organisation. Au-delà de l'aspect linguistique, cette démarche participe à une culture d'entreprise plus inclusive et égalitaire, en alignant les documents RH, les organigrammes et les systèmes d'information (comme l'Active Directory) avec les valeurs de diversité que l'entreprise souhaite porter. C'est aussi un signal fort, tant en interne qu'en externe, de la volonté de l'entreprise de moderniser ses pratiques et de refléter fidèlement la réalité de ses équipes.

#### Le fichier CSV

Comme pour le script précedent le fichier CSV est placé dans le meme dossier que le scripts le chemin est 
```
C:\Scripts\Féministaion.txt
```
Pour le fichier CSV qui servira a la féminisation je me suis basé sur le fichier de creation des utilisateurs il se presente donc comme ceci
```

```
Il comprends les informations tel que le nom et prenom mais aussi la civilité des utilisateurs pour differencier les hommes des femmes.

#### Le script
Vous retrouverez le script [ici](Ressources/Scripts/Féminisation_De_Poste.ps1)

Ce que fait le scrit
- Filtre les profils féminins (Mme) à partir de la colonne civilité, pour ne traiter que les comptes concernés.
- Lit l'intitulé de poste actuel depuis la colonne fonction du CSV.
- Recherche l'équivalent féminin dans le tableau de correspondance ($MappingTitres).
- Met à jour l'attribut Description de l'utilisateur dans l'AD avec le nouvel intitulé féminisé (Set-ADUser).

La commande pour lancer le script est celle-ci
```
C:\Scripts\Féminisation_De_Poste.ps1
```
Une fois le script exécuté, le résumé s'affiche en console et le détail complet est dans 
```
C:\Logs\PS\FeminisationPoste.log.
```



























