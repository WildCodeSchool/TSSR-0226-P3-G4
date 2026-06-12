# 1. Active Directory
## 1.1 Nom de domaine
Notre nom de domaine sera :
### **Xtech.green**
## 1.2 Nom des Unités d'Organisation
### 1.2.1 Structure arborescence OU
Pour les OU nous avons fais le choix d'une hiérarchie à 5 niveaux permettant de classer les objets par société, site, type et département et service.

**Niveau 1** : Nom de l'AD -> Xtech.green  
**Niveau 2** : Le site -> Paris  
**Niveau 3** : Les objets -> Administration ; Utilisateurs ; Ordinateurs  
**Niveau 4** : Département dans l'OU correspondante -> D1-...-D11 pour les utilisateurs et D1-...-D11 pour les ordinateurs  
**Niveau 5** : Service dans les départements -> s1-...-s11  

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
   - D1-s1 -> Communication externe
   - D1-s2 -> Communication interne  
   - D1-s3 -> Evenementiel  
   - D1-s4 -> Gestion des réseaux sociaux  
   - D1-s5 -> Publicité  
   - D1-s6 -> Relation publique et Presse

**D2**
   - D2-s1 -> frontend  
   - D2-s2 -> backend  
   - D2-s3 -> Recherche et prototype  
   - D2-s4 -> Analyse et conception
   - D2-s5 -> Tests et qualité
 
**D3**
   - D3-s1 -> Controle de gestion
   - D3-s2 -> Finance
   - D3-s3 -> Comptabilité

**D4**
   - D4-s1 -> Digital
   - D4-s2 -> Operationnel
   - D4-s3 -> Produit
   - D4-s4 -> Strategique

**D5**
   - D5-s1 -> Data
   - D5-s2 -> Dev logiciel
   - D5-s3 -> Support

**D6**
   - D6-s1 -> Innovation et Stratégie
   - D6-s2 -> Laboratoire

**D7**
   - D7-s1 -> Formation
   - D7-s2 -> Gestion des performances
   - D7-s3 -> Recrutement
   - D7-s4 -> Santé et sécurité au travail

**D8**
   - D8-s1 -> Logistique
   - D8-s2 -> Gestion Immobilière

**D9**
   - D9-s1 -> Contentieux
   - D9-s2 -> Contrats

**D10**
   - D10-s1 -> ADV  
   - D10-s2 -> B2B  
   - D10-s3 -> B2C  
   - D10-s4 -> Développement internationnal  
   - D10-s5 -> Grands Comptes  
   - D10-s6 -> Service achat  
   - D10-s7 -> Service Client  

**D11**
   - D11-s1 -> Directeur adjoint
   - D11-s2 -> Assistant de direction
   - D11-s3 -> CEO
   - D11-s4 -> Secrétaire

Chemin complet pour un le service communication externe du département communication sera: `**XTech.green -> PRS -> A/U/O -> D1 -> s1**`  
  
Exemple pour l'OU Communication externe utilisateur: `PRS-UD1-s1`  
  
Exemple pour l'OU Communication externe ordinateur: `PRS-OD1-s1`  

## 1.3 Nom des utilisateurs
### 1.3.1 Comptes Utilisateur Standard
Les comptes standards sont utilisés pour les tâches classiques (bureautique,...).
Pour la nommenclature nous avons choisi le Format :  
<initialenom><prenom>
- en minuscules  
**exemple** `jmachado`  

En cas d’homonymie : <initialenom>.<prenom><X> (X = chiffre incrémental)  
**exemple** : `jmachado1`
### 1.3.4 Comptes Administrateurs
Pour pouvoir garantir un certain niveau de sécurité nous devons respecter le principe du moindre privilège et masquer les comptes critiques, nous utilisons le code neutre XTA (PC administrateurs) suivi du chiffre du niveau de sécurité du compte.

**Tiering 0 : Gestion de L'ADDS DNS DHCP**  
exemple :`XTA0-jmachado`

**Tiering 1 : Gestion de base de donnée**  
exemple :`XTA1-jmachado`

**Tiering 2 : Support Helpdesk**  
exemple :`XTA4-jmachado`

**Tiering 3 : Gestion du SRV-CORE**  
exemple :`XTA1-jmachado`

**Tiering 4 : Gestion du CT-Debian**  
exemple :`XTA4-jmachado`

**Tiering 5 : Gestion du SRV-Fichiers**  
exemple :`XTA5-jmachado`

## 1.4 Nom des groupes
Pour la nommenclature nous avons choisi :  
Convention :
`G-TYPE-ETENDUE-CIBLE-ROLE`

| Élément | Description |
|-------|------------|
| G | Groupe Active Directory |
| TYPE | Type de groupe (SE=sécurité)/(DI=Distribution) |
| ETENDUE | (GL=Global)(UN=Universel)(LO=Localdedomaine) |
| CIBLE | departement |
| ROLE | Fonction |

`exemple :
GDI-GLD1-USER
GSE-UND1-ADMINS`

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
| Stockage | XTS-412 |
| BackUp | XTS-413 |
| Messagerie | XTS-414 |
| Sauvergarde | XTS-415 |
| Bastion | XTS-416 |

## 2.2 Nom des PC d'administration 
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
| Routeur Bastion | XTR-423 |
| Routeur PC-admin | XTR-424 |

## 2.4 Nom des switchs
Nous avons choisi de nommer les switchs de la facon suivante :
| Roles | Nom |
|----------|-------|
| Switch VLAN 10 | XTSW-430 |
| Switch VLAN 40 | XTSW-431 |
| Switch VLAN 40 | XTSW-434 |
| Switch VLAN 40 | XTSW-434 |
| Switch VLAN 50 | XTSX-434 |
| Switch VLAN 60 | XTSW-435 |
| Switch VLAN 70 | XTSW-436 |
| Switch VLAN 80 | XTSW-437 |
| Switch VLAN 90 | XTSW-438 |
| Switch VLAN 100 | XTSW-439 |
| Switch VLAN 110 | XTSW-440 |
| Switch VLAN 400 | XTSW-441 |
| Switch VLAN 410 | XTSW-442 |
| Switch VLAN 440 | XTSW-443 |
| Switch L4 VLAN 10-40-40 | XTSL-444 |
| Switch L4 VLAN 40-50-60 | XTSL-445 |
| Switch L4 VLAN 70-...-110| XTSL-446 |

# 3. Nomenclature des ordinateurs (VM/CT)
Nous avons choisi de nommer les ordinateurs de la facon suivante :  
[Entreprise]-[nom du service]-[numérotation]  
**[XT]-[service]-[001]** 

| Département | Service | Nom |
| :----------- | :----------- | :---- |
| **D1** | Publicité | XT-s1-001 |
|  | Communication externe | XT-s2-001 |
|  | Événementiel | XT-s3-001 |
|  | Gestion des réseaux sociaux | XT-s4-001 |
|  | Relation Publique et Presse | XT-s5-001 |
|  |  |  |
| **D2** | frontend    | XT-s1-001 |
|  | backend    | XT-s2-001 |
|  | Recherche et prototype    | XT-s3-001 |
|  | Analyse et conception    | XT-s4-001 |
|  |  |  |
| **D3** | Controle de gestion | XT-s1-001 |
|  | Finance | XT-s2-001 |
|  | Comptabilité | XT-s3-001 |
|  |  |  |
| **D4** | Digital | XT-s1-001 |
|  | Operationnel | XT-s2-001 |
|  | Produit | XT-s3-001 |
|  | Strategique | XT-s4-001 |
|  |  |  |
| **D5** | Data | XT-s1-001 |
|  | Dev logiciel | XT-s2-001 |
|  | Support | XT-s3-001 |
|  |  |  |
| **D6** | Innovation et Straté-4gie | XT-s1-001 |
|  | Laboratoire | XT-s2-001 |
|  |  |  |
| **D7** | Formation | XT-s1-001 |
|  | Gestion des performances | XT-s2-001 |
|  | Recrutement | XT-s3-001 |
|  | Santé et sécurité au travail | XT-s4-001 |
|  |  |  |
| **D8** | Logistique | XT-s1-001 |
|  | Gestion Immobilière | XT-s2-001 |
|  |  |  |
| **D9** | Contentieux | XT-s1-001 |
|  | Contrats | XT-s2-001 |
|  |  |  |
| **D10** | ADV | XT-s1-001 |
|  | B4B | XT-s2-001 |
|  | B4C | XT-s3-001 |
|  | Grands Comptes | XT-s4-001 |
|  | Service achat | XT-s5-001 |
|  | Service Client | XT-s6-001 |
|  |  |  |
| **D11** | Directeur adjoint | XT-s1-001 |
|  | Assistant de direction | XT-s2-001 |
|  | CEO | XT-s3-001 |
|  | Secrétaire | XT-s4-001 |

