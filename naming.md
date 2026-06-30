1. [**Active Directory**](#1-active-directory)   
   1.1 [**Nom de domaine**](#11-nom-de-domaine)   
   1.2 [**Nom des Unités d'Organisation**](#uo)   
   1.3 [**Les Départements**](#depts)   
   1.4 [**Les Services**](#14-les-services)   
   1.5 [**Nom des utilisateurs**](#15-nom-des-utilisateurs)   
   1.6 [**Nom des GPO**](#16-nom-des-gpo)   

2. [**Nomenclature des matériels**](#materiels)   
   2.1 [**Nom des serveurs**](#21-nom-des-serveurs)   
   2.2 [**Nom des PC d'administration**](#22-nom-des-pc-dadministration)   
   2.3 [**Nom des routeurs**](#23-nom-des-routeurs)   
   2.4 [**Nom des switchs**](#24-nom-des-switchs)   

3. [**Nomenclature des ordinateurs**](#3-nomenclature-des-ordinateurs)   

# 1. Active Directory
## 1.1 Nom de domaine
Notre nom de domaine sera : **Xtech.green**
Le NetBIOS est : XTECH

## 1.2 Nom des Unités d'Organisation <a id="uo"></a>
### Structure arborescence OU
Pour les OU nous avons fais le choix d'une hiérarchie à 5 niveaux permettant de classer les objets par société, site, type et département et service.

**Niveau 1** : Nom de l'AD -> Xtech.green  
**Niveau 2** : Le site -> Paris  
**Niveau 3** : Les objets -> Administration ; Utilisateurs ; Ordinateurs  
**Niveau 4** : Département dans l'OU correspondante -> D1-...-D11 pour les utilisateurs et D1-...-D11 pour les ordinateurs  
**Niveau 5** : Service dans les départements -> s1-...-s11  

## 1.3 Les Départements <a id="depts"></a>
Pour offusquer la société et avoir un bon niveau de sécurité nous avons décidé de donné des numeros d'identification pour chaque département.  

**D1** -> Communication  
**D2** -> Développement  
**D3** -> Direction Financière  
**D4** -> Direction Marketing  
**D5** -> DSI  
**D6** -> R&D  
**D7** -> RH  
**D8** -> Service Généraux  
**D9** -> Service Juridique  
**D10** -> Ventes et Développement Commercial   
**D11** -> Direction Générale

### 1.4 Les Services
Pour les services nous avons reprenons les départements et y ajoutons un - suivi du du numéro de service  
**D1**
   - D01-s01 -> Communication externe
   - D01-s02 -> Communication interne  
   - D01-s03 -> Evenementiel  
   - D01-s04 -> Gestion des réseaux sociaux  
   - D01-s05 -> Publicité  
   - D01-s06 -> Relation publique et Presse

**D2**
   - D02-s01 -> frontend  
   - D02-s02 -> backend  
   - D02-s03 -> Recherche et prototype  
   - D0-s04 -> Analyse et conception
   - D02-s05 -> Tests et qualité
 
**D3**
   - D03-s01 -> Controle de gestion
   - D03-s02 -> Finance
   - D03-s03 -> Comptabilité

**D4**
   - D04-s01 -> Digital
   - D04-s02 -> Operationnel
   - D04-s03 -> Produit
   - D04-s04 -> Strategique

**D5**
   - D05-s01 -> Data
   - D05-s02 -> Dev logiciel
   - D05-s03 -> Support

**D6**
   - D06-s01 -> Innovation et Stratégie
   - D06-s02 -> Laboratoire

**D7**
   - D07-s01 -> Formation
   - D07-s02 -> Gestion des performances
   - D07-s03 -> Recrutement
   - D07-s04 -> Santé et sécurité au travail

**D8**
   - D08-s01 -> Logistique
   - D08-s02 -> Gestion Immobilière

**D9**
   - D09-s01 -> Contentieux
   - D09-s02 -> Contrats

**D10**
   - D10-s01 -> ADV  
   - D10-s02 -> B2B  
   - D10-s03 -> B2C  
   - D10-s04 -> Développement internationnal  
   - D10-s05 -> Grands Comptes  
   - D10-s06 -> Service achat  
   - D10-s07 -> Service Client  

**D11**
   - D11-s01 -> Directeur adjoint
   - D11-s02 -> Assistant de direction
   - D11-s03 -> CEO
   - D11-s04 -> Secrétaire

Chemin complet pour le service communication externe du département communication sera: `**XTech.green -> PRS -> A/U/O -> D01 -> s01**`  
  
Exemple pour l'OU Communication externe utilisateur: `PRS-UD01-s01`  
  
Exemple pour l'OU Communication externe ordinateur: `PRS-OD01-s01`  

## 1.5 Nom des utilisateurs
### 1.5.1 Comptes Utilisateur Standard
Les comptes standards sont utilisés pour les tâches classiques (bureautique,...).
Pour la nommenclature nous avons choisi le Format :  
<initialenom><prenom>
- en minuscules **exemple** `jmachado`  

En cas d’homonymie : <initialenom><prenom><X> (X = chiffre incrémental) **exemple** : `jmachado1`
### 1.5.2 Comptes Administrateurs
Pour pouvoir garantir un certain niveau de sécurité nous devons respecter le principe du moindre privilège et masquer les comptes critiques, nous utilisons le code neutre XTA (PC administrateurs) suivi du chiffre du niveau de sécurité du compte.

**Tiering 0 : Gestion de L'ADDS DNS DHCP**  
exemple :`XTA0-jmachado`

**Tiering 1 : Gestion de tous les serveurs d'applications**  
exemple :`XTA1-jmachado`

**Tiering 2 : Gestion des postes clients et imprimantes**  
exemple :`XTA2-jmachado`

| Élément | Description |
|-------|------------|
| G | Groupe Active Directory |
| TYPE | Type de groupe (SE=sécurité)/(DI=Distribution) |
| ETENDUE | (GL=Global)(UN=Universel)(LO=Localdedomaine) |
| DEPARTEMENT | D1 -> D11 |
| SERVICE | s1 -> s7 |

`exemple :
GDI-GLUD1-s1
GSE-GLUD1-s1`

```
Xtech.green
├── Administration
├── Ordinateurs
├── Utilisateurs
   ├── Département (ex:RH)
         └── Service (ex:Formation)
```
## 1.6 Nom des GPO
### 1.6.1 GPO de Sécurité
| Nom | Type | Cible | Paramètre | Effet |
|-----|------|-------|-----------|-------|
| XTG-SEC-BlocageRegistre | Sécurité | OU Utilisateurs |||
| XTG-SEC-WindowsUpdate | Sécurité | OU Utilisateurs |||
| XTG-SEC-VerrouillageCompte | Sécurité | Xtech.green |||
| XTG-SEC-RestrictionInstallLogiciel | Sécurité | OU Utilisateurs |||
| XTG-SEC-RestrictionPeripheriquesAmovibles | Sécurité | OU Utilisateurs |||
| XTG-SEC-PanneauDeConfig-Block | Sécurité | OU Utilisateurs | Prohibit access to Control Panel and PC Settings->Enabled | Blocage complet du complet de configuration et des paramètres PC |
| XTG-SEC-WindowsUpdate | Sécurité | OU Ordinateurs | Configure Automatic Upadtes->Enabled | Installation automatique à  3h00, pas de redémarrage forcé, vérification toutes les 22h |

### 1.6.2 GPO Stantard 
| Nom | Type | Cible | Paramètres | Effet |
|-----|------|-------|------------|-------|
| XTG-STD-FondEcran | Standard | OU Utilisateurs |||
| XTG-STD-ConfiNavigateur | Standard | OU Utilisateurs ||||
| XTG-STD-MappageLecteurs | Standard | OU Utilisateurs |||



# 2 Nomenclature des matériels <a id="materiels"></a>
Nous avons fait le choix du format suivant : 
- Initiale entreprise : XT (Xentech)
- Code de l'objet AD
     - Serveur : **SE**
     - PC Administration : **AD**
     - Routeur : **RO**
     - Switch : **SW**
     - PC client : **ODx-sx** Suivi d'un numero d'identification unique : **00x**
# 2.1 Nom des serveurs
Nous avons choisi de nommer les serveurs de la facon suivante :  

| Roles | Nom |
|----------|-------|
| ADDS DHCP DNS | XTSE-410 |
| Stockage De Fichiers | XTSE-411 |
| Backup AD Core | XTSE-412 |
| PFsense | XTSE-413 |
| Sauvergarde Windows Veeam | XTSE-414 |
| Sauvegarde Général | XTSE-415 |
| Serveur Web Interne | XTSE-416 |
| Serveur Web Externe | XTSE-417 |
| Serveur VoIP | XTSE-418 |
| Serveur WSUS | XTSE-419 |
| Serveur WDS | XTSE-420 |
| Zabbix | XTSE-450 |
| GLPI | XTSE-451 |
| Syslog | XTSE-452 |
| IRedMail | XTSE-453 |
| Bastion | XTSE-454 |


## 2.2 Nom des PC d'administration 
| Roles | Nom |
|----------|-------|
| T0 | XTAD-401 |
| T1 | XTAD-402 |
| T2 | XTAD-403 |

## 2.3 Nom des routeurs
Nous avons choisi de nommer les routeurs de la facon suivante :
| Roles | Nom |
|----------|-------|
| Routeur VLAN | XTRO-430 |
| Routeur Messagerie/Sauvegarde | XTRO-431 |
| Routeur Bastion | XTRO-432 |
| Routeur PC-admin | XTRO-433 |

# 3 Nomenclature des ordinateurs
Nous avons choisi de nommer les ordinateurs de la facon suivante :  
[Entreprise]-[département]-[service]-[numérotation]  
**[XT]-[OD1-...-OD11]-[s1-...-s7]-[001]**

Exemple pour un ordinateur **fixe** se situant dans le département **communication** :   
`XT-OD1-s1-001`  
Exemple avec un ordinatuer **portable** se situant dans le departement **communication** :  
`XT-OD1-s1-001`  
