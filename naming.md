# 1. Active Directory
## 1.1 Nom de domaine
Notre nom de domaine sera :
### **Xtech.green**
## 1.2 Nom des Unités d'Organisation
### 1.2.1 Structure arborescence OU
Pour les OU nous avons fais le choix d'une hiérarchie à 5 niveaux permettant de classer les objets par société, site, type et département et service.

**Niveau 1** : Nom de l'AD -> Xtech.green  
**Niveau 2** : Le site -> Paris  
**Niveau 3** : Les objets -> Administrateur (A) ; Utilisateurs (U) ; Ordinateurs (O)  
**Niveau 4** : Département dans U et O -> UD1-...-UD11 pour les utilisateurs et OD1-...-OD11 pour les ordinateurs  
**Niveau 5** : Service dans les départements -> U1-1 U étant le département et le -1 le service  

### 1.2.4 Les Départements
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
### 1.2.1 Les Services
Pour les services nous avons reprenons les départements et y ajoutons un - suivi du du numéro de service  
**D1**
   - D1-1 -> Communication externe  
   - D1-2 -> Evenementiel  
   - D1-3 -> Gestion des réseaux sociaux  
   - D1-4 -> Publicité  
   - D1-5 -> Relation publique et Presse

**D2**
   - D2-1 -> frontend  
   - D2-2 -> backend  
   - D2-3 -> Recherche et prototype  
   - D2-4 -> Analyse et conception
 
**D3**
   - D3-1 -> Controle de gestion
   - D3-2 -> Finance
   - D3-3 -> Comptabilité

**D4**
   - D4-1 -> Digital
   - D4-2 -> Operationnel
   - D4-3 -> Produit
   - D4-4 -> Strategique

**D5**
   - D5-1 -> Data
   - D5-2 -> Dev logiciel
   - D5-3 -> Support

**D6**
   - D6-1 -> Innovation et Stratégie
   - D6-2 -> Laboratoire

**D7**
   - D7-1 -> Formation
   - D7-2 -> Gestion des performances
   - D7-3 -> Recrutement
   - D7-4 -> Santé et sécurité au travail

**D8**
   - D8-1 -> Logistique
   - D8-2 -> Gestion Immobilière

**D9**
   - D9-1 -> Contentieux
   - D9-2 -> Contrats

**D10**
   - D10-1 -> ADV
   - D10-2 -> B2B
   - D10-3 -> B2C
   - D10-4 -> Grands Comptes
   - D10-5 -> Service achat
   - D10-6 -> Service Client

**D11**
   - D11-1 -> Directeur adjoint
   - D11-2 -> Assistant de direction
   - D11-3 -> CEO
   - D11-4 -> Secrétaire

Le chemin complet pour l'utilisateur qui est dans le service communication externe du département communication serait donc : 
**XTech.green -> PRS -> A/U/O -> D1 -> -1**

## 1.3 Nom des utilisateurs
### 1.3.1 Comptes Utilisateur Standard
Les comptes standards sont utilisés pour les tâches classiques (bureautique,...).
Pour la nommenclature nous avons choisi le Format :  
<initialenom><prenom>
- en minuscules  
**exemple** `jmachado`  

En cas d’homonymie : <initialenom>.<prenom><X> (X = chiffre incrémental)  
**exemple** : `jmachado`
### 1.3.4 Comptes Administrateurs
Pour pouvoir garantir un certain niveau de sécurité nous devons respecter le principe du moindre privilège et masquer les comptes critiques, nous utilisons le code neutre XTA (PC administrateurs) suivi du chiffre du niveau de sécurité du compte.

**Tiering 0 : Gestion de L'ADDS DNS DHCP**  
exemple :`XTA0-jmachado`

**Tiering 1 : Gestion de base de donnée**  
exemple :`XTA1-jmachado`

**Tiering 4 : Support Helpdesk**  
exemple :`XTA4-jmachado`

**Tiering 1 : Gestion du SRV-CORE**  
exemple :`XTA1-jmachado`

**Tiering 4 : Gestion du CT-Debian**  
exemple :`XTA4-jmachado`

## 1.4 Nom des groupes
Pour la nommenclature nous avons choisi :  
Convention :
`G-TYPE-ETENDUE-CIBLE-ROLE`

| Élément | Description |
|-------|------------|
| G | Groupe Active Directory |
| TYPE | Type de groupe (SEC=sécurité)/(DIS=Distribution) |
| ETENDUE | (G=Global)(U=Universel)(LDG=Localdedomaine) |
| CIBLE | departement |
| ROLE | Fonction |

`exemple :
GDIS-GPUB-USER
GSEC-GBE-ADMINS`

```
Xtech.green
├── Administration
├── Ordinateurs
├── Utilisateurs
   ├── Département (ex:RH)
         └── Service (ex:Formation)
```
## 1.5 Nom des GPO
### 1.5.1 GPO de Sécurité
| Nom | Type | Cible | Paramètre | Effet |
|-----|------|-------|-----------|-------|
| XTG-SEC-BlocageRegistre | Sécurité | OU Utilisateurs |||
| XTG-SEC-WindowsUpdate | Sécurité | OU Utilisateurs |||
| XTG-SEC-VerrouillageCompte | Sécurité | Xtech.green |||
| XTG-SEC-RestrictionInstallLogiciel | Sécurité | OU Utilisateurs |||
| XTG-SEC-RestrictionPeripheriquesAmovibles | Sécurité | OU Utilisateurs |||
| XTG-SEC-PanneauDeConfig-Block | Sécurité | OU Utilisateurs | Prohibit access to Control Panel and PC Settings->Enabled | Blocage complet du complet de configuration et des paramètres PC |
| XTG-SEC-WindowsUpdate | Sécurité | OU Ordinateurs | Configure Automatic Upadtes->Enabled | Installation automatique à  3h00, pas de redémarrage forcé, vérification toutes les 22h |

### 1.5.2 GPO Stantard 
| Nom | Type | Cible | Paramètres | Effet |
|-----|------|-------|------------|-------|
| XTG-STD-FondEcran | Standard | OU Utilisateurs |||
| XTG-STD-ConfiNavigateur | Standard | OU Utilisateurs ||||
| XTG-STD-MappageLecteurs | Standard | OU Utilisateurs |||




# 2. Nomenclature des matériels
## 2.1 Nom des serveurs
Nous avons choisi de nommer les serveurs de la facon suivante :  

| Roles | Nom |
|----------|-------|
| ADDS DHCP DNS | XTS-411|
| Stockage | XTS-414 |
| BackUp | XTS-414 |
| Messagerie | XTS-414 |
| Sauvergarde | XTS-415 |
| Bastion | XTS-416 |

## 2.2 Nom des PC d'administration 
| Roles | Nom |
|----------|-------|
| Admin Windows | XTA-401 |
| Admin Linux | XTA-404 |

## 2.3 Nom des routeurs
Nous avons choisi de nommer les routeurs de la facon suivante :
| Roles | Nom |
|----------|-------|
| Routeur VLAN | XTR-440 |
| Routeur Messagerie/Sauvegarde | XTR-441 |
| Routeur Bastion | XTR-444 |
| Routeur PC-admin | XTR-444 |

## 2.4 Nom des switchs
Nous avons choisi de nommer les switchs de la facon suivante :
| Roles | Nom |
|----------|-------|
| Switch VLAN 10 | XTSW-440 |
| Switch VLAN 40 | XTSW-441 |
| Switch VLAN 40 | XTSW-444 |
| Switch VLAN 40 | XTSW-444 |
| Switch VLAN 50 | XTSX-444 |
| Switch VLAN 60 | XTSW-445 |
| Switch VLAN 70 | XTSW-446 |
| Switch VLAN 80 | XTSW-447 |
| Switch VLAN 90 | XTSW-448 |
| Switch VLAN 100 | XTSW-449 |
| Switch VLAN 110 | XTSW-440 |
| Switch VLAN 400 | XTSW-441 |
| Switch VLAN 410 | XTSW-444 |
| Switch VLAN 440 | XTSW-444 |
| Switch L4 VLAN 10-40-40 | XTSL-444 |
| Switch L4 VLAN 40-50-60 | XTSL-445 |
| Switch L4 VLAN 70-...-110| XTSL-446 |

# 3. Nomenclature des ordinateurs (VM/CT)
Nous avons choisi de nommer les ordinateurs de la facon suivante :  
[Entreprise]-[nom du service]-[numérotation]  
**[XT]-[service]-[001]** 

| Département | Service | Nom |
| :----------- | :----------- | :---- |
| **Communication** | Publicité | XT-PUB-001 |
|  | Communication externe | XT-CE-001 |
|  | Événementiel | XT-EV-001 |
|  | Gestion des réseaux sociaux | XT-GRS-001 |
|  | Relation Publique et Presse | XT-RPR   -001 |
|  |  |  |
| **Développement** | frontend    | XT-FE-001 |
|  | backend    | XT-BE-001 |
|  | Recherche et prototype    | XT-RP-001 |
|  | Analyse et conception    | XT-AC-001 |
|  |  |  |
| **Direction Financière** | Controle de gestion | XT-CG-001 |
|  | Finance | XT-FI-001 |
|  | Comptabilité | XT-CB-001 |
|  |  |  |
| **Direction Marketing** | Digital | XT-DT-001 |
|  | Operationnel | XT-OP-001 |
|  | Produit | XT-PT-001 |
|  | Strategique | XT-ST-001 |
|  |  |  |
| **DSI** | Data | XT-DT-001 |
|  | Dev logiciel | XT-DL-001 |
|  | Support | XT-SU-001 |
|  |  |  |
| **R&D** | Innovation et Straté-4gie | XT-IS-001 |
|  | Laboratoire | XT-LB-001 |
|  |  |  |
| **RH** | Formation | XT-FR-001 |
|  | Gestion des performances | XT-GP-001 |
|  | Recrutement | XT-RC-001 |
|  | Santé et sécurité au travail | XT-SST-001 |
|  |  |  |
| **Service Généraux** | Logistique | XT-LG-001 |
|  | Gestion Immobilière | XT-GI-001 |
|  |  |  |
| **Service Juridique** | Contentieux | XT-CX-001 |
|  | Contrats | XT-CT-001 |
|  |  |  |
| **Ventes et Dev Commercial** | ADV | XT-AV-001 |
|  | B4B | XT-BB-001 |
|  | B4C | XT-BC-001 |
|  | Grands Comptes | XT-GC-001 |
|  | Service achat | XT-SA-001 |
|  | Service Client | XT-SC-001 |
|  |  |  |
| **Direction Générale** | Directeur adjoint | XT-DA-001 |
|  | Assistant de direction | XT-AD-001 |
|  | CEO | XT-CO-001 |
|  | Secrétaire | XT-SC-001 |

