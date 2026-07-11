# Sommaire

1. [**Dossiers Partagés**](#1-Dossiers-Partagés)  
2. [**Mappage Réseau**](#2-Mappage-Réseau)  
   2.1 [**Mappage des dossiers départements**](#21-Mappage-des-dossiers-départements)  
   2.2 [**Mappage des dossiers individuels**](#22-Mappage-des-dossiers-individuels)  
   2.3 [**Mappage des dossiers services**](#23-Mappage-des-dossiers-services)  


### Mappage Réseau


## 1. Mappage des dossiers départements




## 2. Mappage des dossiers partagés individuels

### Objectif
Ce processus attribue automatiquement à chaque utilisateur de l'OU OU=PRS-U,OU=PRS,$DomainDN un dossier personnel sur le serveur de fichiers, avec les permissions NTFS adaptées, puis relie ce dossier à son compte AD en tant que lecteur réseau personnel (I:).

### Script associé
Ajout_du_dossier_partagé_individuel.ps1

### Fonctionnement du script
Pour chaque utilisateur trouvé dans l'OU cible, le script :


- Crée un dossier dédié sur le partage :
\\XTS-417.Xtech.green\Partage_Individuel\<SamAccountName>
Applique les permissions NTFS :

- Coupe l'héritage des permissions du dossier parent.
- Accorde le contrôle total (FullControl) à l'utilisateur concerné, uniquement sur son propre dossier.

- Relie le dossier au compte AD :
HomeDirectory = chemin du dossier créé.
HomeDrive = I:

- À la prochaine connexion de l'utilisateur, Windows monte automatiquement
ce chemin sur le lecteur I: de sa session.

### Lancer le script
```
powershellC:\Scripts\Ajout_du_dossier_partagé_individuel.ps1
```
- Si une erreur de policy/signature apparaît, débloquer le fichier avant exécution :
```
powershellUnblock-File -Path "C:\Scripts\Ajout_du_dossier_partagé_individuel.ps1"
```
### Vérifications après exécution

- Vérifier qu'un dossier a bien été créé pour un utilisateur :
```
powershellTest-Path "\\XTS-417.Xtech.green\Partage_Individuel\<SamAccountName>"
```
- Vérifier les permissions NTFS appliquées :
```
powershellGet-Acl "\\XTS-417.Xtech.green\Partage_Individuel\<SamAccountName>" | Format-List
```
- Vérifier le lien AD (HomeDirectory / HomeDrive) :
```
powershellGet-ADUser -Identity "<SamAccountName>" -Properties HomeDirectory, HomeDrive |
    Select-Object SamAccountName, HomeDirectory, HomeDrive
```
### Logs

Chaque exécution est tracée via le module XTechLogging :
- Fichier : C:\Logs\PS\AjoutDossierIndividuel.log
- Observateur d'événements : journal Application, source XTech-AjoutDossierIndividuel


## 3. Mappage des dossiers services
