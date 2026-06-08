# 2. Nomenclature des matériels
## 2.1 Nom des serveurs
Nous avons choisi de nommer les serveurs de la facon suivante :  

| Roles | Nom |
|----------|-------|
| ADDS DHCP DNS | XTS-411|
| Stockage | XTS-412 |
| BackUp | XTS-413 |
| Messagerie | XTS-414 |
| Sauvergarde | XTS-415 |
| Bastion | XTS-416 |

## 2.2 Nom des PC administrateurs 
| Roles | Nom |
|----------|-------|
| Admin Windows | XTA-401 |
| Admin Linux | XTA-402 |

## 2.3 Nom des routeurs
Nous avons choisi de nommer les routeurs de la facon suivante :
| Roles | Nom |
|----------|-------|
| Routeur VLAN | XTR-420 |
| Routeur Messagerie/Sauvegarde | XTR-421 |
| Routeur Bastion | XTR-422 |
| Routeur PC-admin | XTR-423 |

## 2.4 Nom des switchs
Nous avons choisi de nommer les switchs de la facon suivante :
| Roles | Nom |
|----------|-------|
| Switch VLAN 10 | XTSW-430 |
| Switch VLAN 20 | XTSW-431 |
| Switch VLAN 30 | XTSW-432 |
| Switch VLAN 40 | XTSW-433 |
| Switch VLAN 50 | XTSX-434 |
| Switch VLAN 60 | XTSW-435 |
| Switch VLAN 70 | XTSW-436 |
| Switch VLAN 80 | XTSW-437 |
| Switch VLAN 90 | XTSW-438 |
| Switch VLAN 100 | XTSW-439 |
| Switch VLAN 110 | XTSW-440 |
| Switch VLAN 200 | XTSW-441 |
| Switch VLAN 210 | XTSW-442 |
| Switch VLAN 220 | XTSW-443 |
| Switch L3 VLAN 10-20-30 | XTSL-444 |
| Switch L3 VLAN 40-50-60 | XTSL-445 |
| Switch L3 VLAN 70-...-110| XTSL-446 |

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
| **R&D** | Innovation et Straté-2gie | XT-IS-001 |
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
|  | B2B | XT-BB-001 |
|  | B2C | XT-BC-001 |
|  | Grands Comptes | XT-GC-001 |
|  | Service achat | XT-SA-001 |
|  | Service Client | XT-SC-001 |
|  |  |  |
| **Direction Générale** | Directeur adjoint | XT-DA-001 |
|  | Assistant de direction | XT-AD-001 |
|  | CEO | XT-CO-001 |
|  | Secrétaire | XT-SC-001 |

# 3. Active Directory
## 3.1 Nom de domaine
Notre nom de domaine sera : **Xtech.green**
### **Xtech.green**
## 3.2 Nom des utilisateurs
### 3.2.1 Comptes Utilisateur Standard
Les comptes standards sont utilisés pour les tâches classiques (bureautique,...).
Pour la nommenclature nous avons choisi le Format :  
<initialenom><prenom>
- en minuscules  
**exemple** `mpham`  

En cas d’homonymie : <initialenom>.<prenom><X> (X = chiffre incrémental)  
**exemple** : `mpham1`
### 3.2.2 Comptes Administrateurs
Pour pouvoir garantir un certain niveau de sécurité nous devons respecter le principe du moindre privilège et masquer les comptes critiques, nous utilisons le code neutre XTA (PC administrateurs) suivi du chiffre du niveau de sécurité du compte.

**Tiering 0 : Gestion de L'ADDS DNS DHCP**  
`XTA0-mpham`

**Tiering 1 : Gestion de base de donnée**
`XTA1-mpham`

**Tiering 2 : Support Helpdesk**  
`XTA2-mpham`


## 3.3 Nom des groupes
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

## 3.4 Nom des Unités d'Organisation
```
Xtech.green
├── Administration
├── Ordinateurs
├── Utilisateurs
   ├── Département (ex:RH)
         └── Service (ex:Formation)
```
## 3.5 Nom des GPO

### GPO de Sécurité

| Nom | Type | Cible | Paramètre | Effet |
|-----|------|-------|-----------|-------|
| XTG-SEC-BlocageRegistre | Sécurité | OU Utilisateurs |||
| XTG-SEC-WindowsUpdate | Sécurité | OU Utilisateurs |||
| XTG-SEC-VerrouillageCompte | Sécurité | OU Utilisateurs |||
| XTG-SEC-RestrictionInstallLogiciel | Sécurité | OU Utilisateurs |||
| XTG-SEC-RestrictionPeripheriquesAmovibles | OU Utilisateurs ||||
| XTG-SEC-PanneauDeConfig-Block | Sécurité | OU Utilisateurs | Prohibit access to Control Panel and PC Settings->Enabled | Blocage complet du complet de configuration et des paramètres PC |
| XTG-SEC-WindowsUpdate | Sécurité | OU Ordinateurs | Configure Automatic Upadtes->Enabled | Installation automatique à  3h00, pas de redémarrage forcé, vérification toutes les 22h |

### GPO Stantard 

| Nom | Type | Cible | Paramètres | Effet |
|-----|------|-------|------------|-------|
| XTG-STD-FondEcran | Standard | OU Utilisateurs |||
| XTG-STD-ConfiNavigateur | Standard | OU Utilisateurs ||||
| XTG-STD-MappageLecteurs | Standard | OU Utilisateurs |||

