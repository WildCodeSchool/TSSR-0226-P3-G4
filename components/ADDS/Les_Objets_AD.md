# Les objets AD
## Sommaire

1. [Les OU](#1-Les-ou)
   - [1.1 Création des OU Principales](#12-création-des-OU)
   - [1.2 Création des sous-OU](#13-création-des-sous-OU)
      - [1.2.1 Sous-OU Utilisateurs](#132-sous-ou-Utilisateurs)
      - [1.2.2 Sous-OU Administrateurs](#132-sous-ou-Administrateurs)

2. [Création des utilisateurs](#2-création-des-utilisateurs)
   - [2.1 Préparation du fichier CSV](#21-préparation-du-fichier-csv)
   - [2.2 Configuration du script](#22-configuration-du-script)
   - [2.3 Exécution du script](#23-exécution-du-script)
   - [2.4 Vérification](#24-vérification)

3. [Désactivation et archivage des utilisateurs](#25-Désactivation-et-archivage-des-utilisateurs)
   - [3.1 Configuration et exécution du script](#252-configuration-du-script-et-exécution-du-script)

4. [Féminisation des postes](#26-féminisation-des-postes)
   - [4.1 Configuration et exécution du script](#252-configuration-du-script-et-exécution-du-script)

5. [Déplacement automatique des ordinateurs](#3.déplacement-automatique-des-ordinateurs)
    - [5.1 Explication du script](#31-explication-du-script)
    - [5.2 Automatisation par AT](#32-automatisation-par-at)

6. [Création des groupes](#4-création-des-groupes)
   - [6.1 Arborescence des groupes de sécurité](#41-arborescence-des-groupes-de-sécurité)
   - [6.2 Création d'un groupe](#42-création-dun-groupe)
   - [6.3 Liste des groupes à créer](#43-liste-des-groupes-à-créer)

7. [Les GPO](#5-Les-GPO)
   - [7.1 Création de GPO](#51-création-de-GPO)
   - [7.2 GPO de sécurité](#52-GPO-de-sécurité)
   - [7.3 GPO standard](#53-GPO-standard)

8. [Tâche planifiée](#6-tâche-planifiée)

9. [Jonction au domaine](#7-jonction-au-domaine)

10. [Partage des rôles FSMO (PDC et RID)](#8-transfert-des-rôles-fsmo-pdc-et-rid)
   - [10.1 Prérequis et ajout du serveur](#81-prérequis-et-ajout-du-serveur)
   - [10.2 Installation d'Active Directory sur le serveur Core](#82-installation-dactive-directory-sur-le-serveur-core)
   - [10.3 Promotion en contrôleur de domaine](#83-promotion-en-contrôleur-de-domaine)
   - [10.4 Attribution des rôles FSMO](#84-attribution-des-rôles-fsmo)


## 1. Les OU
### 1.2 Création des OU principales
**Dans le server manager**
Cliquer sur "Tools" puis "Active Directory Users and Computers" pour ouvrir le gestionnaire d'OU
[]()
Dans le volet de gauche faites un clic droit pour ouvrir le menu
- cliquer sur "New" puis "Organized unit" pour creer une OU manuellement
[]()
Une fenetre s'ouvre
- Dans la case "Name" entrer le nom souhaité "PRS"
- Cocher la case "Protect container from accidental deletion" pour protéger l'OU contre la suppression accidentel
- Pour terminer la création cliquer sur "OK"
[]()
L'OU "PRS" a été crée.
[]()
Pour les trois OU suivantes même procédure sauf que la création d'OU ce fait depuis l'OU "PRS"
- clic droit sur l'OU "PRS" puis "New" puis "Organized Unit"
[]()
- Entrer "PRS-A" pour les comptes Administrateurs, "PRS-O" pour les ordinateurs et "PRS-U" pour les utilisateurs
- toujours cocher "Protect container from accidental deletion"
- finir par "OK"
[]()
### 1.3 Création des sous-OU
#### 1.3.1 Sous-OU Utilisateurs
Pour les sous-OU Utilisateurs nous avons fait le choix d'utiliser un script pour une question pratique il est renseigner dans le dossier ressources scripts
Anonymisation des OU département :
```
D1 -> Communication
D2 -> Développement
D3 -> Direction Financière
D4 -> Direction Marketing
D5 -> DSI
D6 -> R&D
D7 -> RH
D8 -> Service Généraux
D9 -> Service Juridique
D10 -> Ventes et Développement Commercial
D11 -> Direction Générale
```
puis les services (exemple) :
```
D01-s01 -> Communication externe
D01-s02 -> Communication interne
D01-s03 -> Evenementiel
```
Ensuite mettre tout ca dans un fichier .txt, voici un exemple 
```
D01-s01;D1;PRS-U;PRS
D01-s02;D1;PRS-U;PRS
```
Et voila vous OU utilisaterus son creer
[]()
#### 1.3.2 Sous-OU Administrateurs
Pour la création de la sous-OU "PRS-A" 
Même procédure que pour les OU principale
[]()
[]()

## 2. Création des Utilisateurs
Pour la création des utilisateurs nous avons choisi de passer la aussi par un script via un fichier CSV toujours pour le coter praticiter.
### 2.1 Préparation du fichier CSV
Pour une création d'utilisateurs via script le fichier CSV doit respecter un format strict pour eviter une erreur :
- Le delimiter qui est pour cet exemple un ";"
- Et un encodage en "UTF-8"
Voici un exemple :
[]()
### 2.2 Configuration et execution du script
Pou la configuration tout d'abors choisir le bon fichier a traiter.
```
$File = "$FilePath\Creation_Users2.txt"
```
Ensuite ajouter une variable de suppession de caractère speciaux et espace pour eviter tout probleme avec des prenoms ou noms composés
```
function Remove-Accents {
    param([string]$Texte)
    $d = $Texte.Normalize([Text.NormalizationForm]::FormD)
    (-join ($d.ToCharArray() | Where-Object {
        [Globalization.CharUnicodeInfo]::GetUnicodeCategory($_) -ne 'NonSpacingMark'
    })).Normalize([Text.NormalizationForm]::FormC) -replace '\s', ''
}
```
Ensuite modifier les variables de votre boucle pour prendre le maximum d'informations et appeler la fonction "Remove-Accents" ou cela est nécéssaire :
```
$Prenom            = ((Remove-Accents $User.Prénom) -replace '\s', '')
    $Nom               = ((Remove-Accents $User.Nom) -replace '\s', '')
    $Name              = "$Prenom.$Nom"
    $DisplayName       = "$Prenom.$Nom"
# Rappel de la fonction (Remove-Accents) + -replace pour supprimer les espaces
    $SamAccountName    = ((Remove-Accents "$($User.Prénom.substring(0,1))$($User.Nom)") -replace '\s', '').ToLower()
    $SamAccountName    = $SamAccountName.Substring(0, [Math]::Min(20, $SamAccountName.length))
    $UserPrincipalName = (($User.Prénom.substring(0,1).tolower() + $User.Nom.ToLower()) + "@" + (Get-ADDomain).Forest)
    $GivenName         = $User.Prénom
    $Surname           = $User.Nom
    $Office            = $User.Société
    $Description       = $User.fonction
    $OfficePhone       = if ($User.'Téléphone fixe'.Trim() -eq '-') {$User.'Téléphone portable'} else {$User.'Téléphone fixe'}
    $EmailAddress      = $UserPrincipalName -replace '\s', ''
    #$Path             = "OU=$($User.Service),OU=$($User.Département),OU=Utilisateurs,OU=Paris,dc=Xtech,dc=green"
    $Path              = "OU=$($User.Département),OU=Utilisateurs,OU=Paris,dc=Xtech,dc=green"
    $Company           = "Ma Societe"
    $Departement       = "$($User.Département)"
    $Service           = "$($User.Service)"
    #$Service          = "$($User.Service)" -eq '-') {$User.Département} else {$User.Service}
```
Et pour finir ajouter vos nouvelles fonctions dans le "New ADUser"
```
New-ADUser -Name $Name -DisplayName $DisplayName -SamAccountName $SamAccountName -UserPrincipalName $UserPrincipalName `
        -GivenName $GivenName -Surname $Surname -Office $Office -Description $Description -OfficePhone $OfficePhone -EmailAddress $EmailAddress `
        -Path $Path -AccountPassword (ConvertTo-SecureString -AsPlainText "P@ssw0rd2026!" -Force) -Enabled $True `
        -OtherAttributes @{Company = $Company} -ChangePasswordAtLogon $True
        Write-Host "Création du USER $SamAccountName" -ForegroundColor Green
```
Et voila vos utilisateurs sont désormais dans vos OU
[]()

## 3. Désactivation et archivage des anciens utilisateurs
### 3.1 Configuration et execution du script

## 4. Féminisation des postes
### 4.1 Configuration et execution du script

## 5. Déplacement automatique des ordinateurs

### 5.1 Configuration du script
### 5.2 Automatisation via AT

## 6. Création des groupes
### 6.1 Arborescence des groupes
Tout les groupes sont regroupé dans une OU dédié a cela l'OU "PRS-UDG" situé dans l'OU "PRS-U".
### 6.2 Création de groupe
Je vous laisse vous référer a fichier naming.md disponible au début de notre arborescence github.
Pour creer un groupe, une fois dans l'Active Directory Users and Computers :
- Clic droit sur l'OU "PRS-UDG"
- Selectionner "New" puis "Group"
Remplir les informations suivantes (Exemple) :
|-------|--|
| Group name | Selon la nomenclature choisi |
| Group scope | Selon les besoins (Global) |
| Group type | Selon les beoisns (Sécurity)
### 6.3 Listing des groupes
Pour les groupes par départements
```
GSE-GL-PRS-UD01
GSE-GL-PRS-UD02
GSE-GL-PRS-UD03
GSE-GL-PRS-UD04
GSE-GL-PRS-UD05
GSE-GL-PRS-UD06
GSE-GL-PRS-UD07
GSE-GL-PRS-UD08
GSE-GL-PRS-UD09
GSE-GL-PRS-UD10
GSE-GL-PRS-UD11
```
Pour les groupes de services :
```
Département UD01 :
GSE-GL-PRS-UD01-s1
GSE-GL-PRS-UD01-s2
GSE-GL-PRS-UD01-s3
GSE-GL-PRS-UD01-s4
GSE-GL-PRS-UD01-s5
GSE-GL-PRS-UD01-s6
Département UD02 :
GSE-GL-PRS-UD02-s1
GSE-GL-PRS-UD02-s2
GSE-GL-PRS-UD02-s3
GSE-GL-PRS-UD02-s4
GSE-GL-PRS-UD02-s5
GSE-GL-PRS-UD02-s6
Département UD03 :
GSE-GL-PRS-UD03-s1
GSE-GL-PRS-UD03-s2
GSE-GL-PRS-UD03-s3
Département UD04 :
GSE-GL-PRS-UD04-s1
GSE-GL-PRS-UD04-s2
GSE-GL-PRS-UD04-s3
GSE-GL-PRS-UD04-s4
Département UD05 :
GSE-GL-PRS-UD05-s1
GSE-GL-PRS-UD05-s2
GSE-GL-PRS-UD05-s3
Département UD06 :
GSE-GL-PRS-UD06-s1
GSE-GL-PRS-UD06-s2
Département UD07 :
GSE-GL-PRS-UD07-s1
GSE-GL-PRS-UD07-s2
GSE-GL-PRS-UD07-s3
GSE-GL-PRS-UD07-s4
Département UD08 :
GSE-GL-PRS-UD08-s1
GSE-GL-PRS-UD08-s2
Département UD09 :
GSE-GL-PRS-UD09-s1
GSE-GL-PRS-UD09-s2
Département UD10 :
GSE-GL-PRS-UD10-s1
GSE-GL-PRS-UD10-s2
GSE-GL-PRS-UD10-s3
GSE-GL-PRS-UD10-s4
GSE-GL-PRS-UD10-s5
GSE-GL-PRS-UD10-s6
GSE-GL-PRS-UD10-s7
Département UD11 :
GSE-GL-PRS-UD11-s1
GSE-GL-PRS-UD11-s2
GSE-GL-PRS-UD11-s3
GSE-GL-PRS-UD11-s4
```

## 7. Les GPO
### 7.1 GPO standard
### 7.2 GPO de sécurité
### 7.3 Création de GPO

## 8. Tâches planifiée

## 9. Partage des rôles FSMO
### 9.1 Prérequis et ajout de serveur
### 9.2 Active Directory sur un serveur Core
### 9.3 Promouvoir un serveur en DC
### 9.4 Attribution des rôles FSMO
