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

## 2.2 Nom du PC administrateur 
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
[Entreprise]-[nom du departement + nom du service]-[numérotation]  
**[XT]-[departement+service]-[001]** 

| Département | Service | Nom |
| :----------- | :----------- | :---- |
| **Communication** | Publicité | XT-PUB-001 |
|  | Communication externe | XT-EX-001 |
|  | Événementiel | XT-EV-001 |
|  | Gestion des réseaux sociaux | XT-GRS-001 |
|  | Relation Publique et Presse | XT-RPP-001 |
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
| **DSI** | Data | XT-D-001 |
|  | Dev logiciel | XT-L-001 |
|  | Support | XT-SU-001 |
|  |  |  |
| **R&D** | Innovation et Straté-2gie | XT-IS-001 |
|  | Laboratoire | XT-L-001 |
|  |  |  |
| **RH** | Formation | XT-F-001 |
|  | Gestion des performances | XT-GP-001 |
|  | Recrutement | XT-R-001 |
|  | Santé et sécurité au travail | XT-SST-001 |
|  |  |  |
| **Service Généraux** | Logistique | XT-L-001 |
|  | Gestion Immobilière | XT-GI-001 |
|  |  |  |
| **Service Juridique** | Contentieux | XT-CTX-001 |
|  | Contrats | XT-CT-001 |
|  |  |  |
| **Ventes et Dev Commercial** | ADV | XT-ADV-001 |
|  | B2B | XT-B2B-001 |
|  | B2C | XT-B2C-001 |
|  | Grands Comptes | XT-GC-001 |
|  | Service achat | XT-SA-001 |
|  | Service Client | XT-SC-001 |
|  |  |  |
| **Direction Générale** | Directeur adjoint | XT-DA-001 |
|  | Assistant de direction | XT-AD-001 |
|  | CEO | XT-C-001 |
|  | Secrétaire | XT-S-001 |

# 3. Active Directory
## 3.1 Nom de domaine
Notre nom de domaine sera : **Xtech.green**
### **Xtech.green**
## 3.2 Nom des utilisateurs
Pour la nommenclature nous avons choisi :  
Nom.Prenom

## 3.3 Nom des groupes
Pour la nommenclature nous avons choisi :
Groupe de sécurité/distribution + departement + service
| Groupe | Scope | Service | ID utilisateur | Exemple |
| :----- | :---------- | :------ | :------- | :------- |
| Utilisateurs | Local/Global | Publicité | 001 |GUL/GPUB001 |
| Ordinateurs | Local/Global | Publicité | 001 |GUL/GPUB001 |

## 3.4 Nom des Unités d'Organisation
```
Xtech.green
├── Ordinateurs
├── Utilisateurs
   ├── Département (ex:RH)
         └── Service (ex:Formation)
```
## 3.5 Nom des GPO

| Nom | Type | Cible | Paramètre | Effet |
|-----|------|-------|-----------|-------|
| XTG-SEC-PanneauDeConfig-Block | Sécurité | OU Utilisateurs | Prohibit access to Control Panel and PC Settings->Enabled | Blocage complet du complet de configuration et des paramètres PC |

