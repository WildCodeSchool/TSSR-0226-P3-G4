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
| ------- | ------ |
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
#### GPO fond d'écran

**Nom :** `XTG-STD-FondEcran`

**Chemin de configuration :**
> User Configuration > Policies > Administrative Templates > Desktop > Desktop

**Paramètres :**


**Portée :**
```
Liaison : Xtech.green > PRS-U > Tous les départements  
Filtrage : Tous les groupes de départements  
Cible : Users  
Statut : Computer configuration settings disabled  
```
#### GPO Mappage de lecteurs

**Nom :** `XTG-STD-MappageLecteurs`

**Chemin de configuration :**
> User Configuration > Preferences > Windows Settings > Drive Maps

Clic droit > **New** > **Mapped Drive**

**Paramètres :**


**Portée :**
```
Liaison : Xtech.green > PRS-U > Tous les départements  
Filtrage : Tous les groupes de départements  
Cible : Users  
Statut : Computer configuration settings disabled  
```
#### GPO Configuration du Navigateur

### 7.2 GPO de sécurité

### 7.3 Création de GPO

## 8. Tâches planifiée

## 9. Partage des rôles FSMO
### 9.1 Prérequis et ajout de serveur
#### Configurer le clavier en AZERTY

Par défaut, Windows Server Core démarre avec un clavier en QWERTY. Avant toute autre opération, passer le clavier en AZERTY de façon permanente dans une console PowerShell :

```powershell
# Passer le clavier en AZERTY (français)
Set-WinUserLanguageList -LanguageList fr-FR -Force

# Appliquer le changement au niveau système
Set-WinSystemLocale fr-FR
```

Redémarrer le serveur pour que la configuration soit définitive :

```powershell
Restart-Computer
```

> Une fois redémarré, ouvrir une nouvelle session PowerShell : le clavier est désormais en AZERTY.

---

#### Configuration IP du serveur Core

Dans une console PowerShell, entrer les commandes suivantes :

- Vérifier l'index de l'adaptateur :
```powershell
Get-NetAdapter
```

> Adapter la valeur de `InterfaceIndex` selon le résultat obtenu.

- Supprimer l'ancienne IP et route :
```powershell
Remove-NetIPAddress -InterfaceIndex 1 -Confirm:$false
Remove-NetRoute -InterfaceIndex 1 -Confirm:$false
```

- Appliquer la nouvelle configuration :
```powershell
New-NetIPAddress -InterfaceIndex 1 -IPAddress "172.16.12.6" -PrefixLength 28 -DefaultGateway "172.16.12.14"
```

-  Configuration du DNS :
```powershell
Set-DnsClientServerAddress -InterfaceIndex 1 -ServerAddresses "172.16.12.1"
```

#### Jonction du serveur Core au domaine

- Choisir l'option **1** dans sconfig

![]()

- Ajouter le serveur dans le domaine :
    - Entrer `D` pour sélectionner Domain
    - Entrer `billu.lan`
    - Entrer le nom d'un utilisateur autorisé : `Administrator`
    - Entrer son mot de passe
    - Changer le nom de la machine par : `DOM-AD-PDC-01`
    - Entrer le mot de passe du serveur Core
    - Redémarrer en appuyant sur `Y`

![]()

#### Ajout du serveur dans le Server Manager

Depuis le serveur graphique :

- Cliquer sur `Manage` puis `Add Servers`

![]()

- Cliquer sur `Find Now`
- Sélectionner le serveur à ajouter
- Vérifier qu'il apparaît dans la liste **Selected**

![]()

Le serveur doit apparaître dans la liste `All Servers`.

![]()


### 9.2 Active Directory sur un serveur Core

- Faire `clic droit` sur le serveur **PDC** dans la liste `All Servers`

![]()

- Cliquer sur `Next` jusqu'à la sélection des serveurs
- Sélectionner le serveur PDC

![]()

- Cocher **Active Directory Domain Services**

![]()

- Cliquer sur `Add Features`

![]()

- Faire `Next` jusqu'à l'étape `Confirmation`
- Vérifier les informations et cliquer sur `Install`

![]()

- Attendre la confirmation de l'installation

![]()

---

### 9.3 Promouvoir un serveur en DC

- Cliquer sur le drapeau
- Cliquer sur `Promote this server to a domain controller`

![]()

- Sélectionner `Add a domain controller to an existing domain`
- Cliquer sur `Change` et entrer les credentials Administrator

![]()

- Cocher `Domain Name System (DNS) server` et `Global Catalog (GC)`
- Définir un mot de passe DSRM

![]()

- Cliquer sur `Next` jusqu'à `Prerequisites Check` puis sur `Install`

![]()

- Attendre la confirmation de la configuration

![]()

- **Redémarrer le serveur Core**


### 9.4 Attribution des rôles FSMO
