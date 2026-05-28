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
| **Communication** | Publicité | XT-COMPUB-001 |
|  | Communication externe | XT-COMEX-001 |
|  | Événementiel | XT-COMEV-001 |
|  | Gestion des réseaux sociaux | XT-COMGRS-001 |
|  | Relation Publique et Presse | XT-COMRPP-001 |
|  |  |  |
| **Développement** | frontend    | XT-DEVFE-001 |
|  | backend    | XT-DEVBE-001 |
|  | Recherche et prototype    | XT-DEVRP-001 |
|  | Analyse et conception    | XT-DEVAC-001 |
|  |  |  |
| **Direction Financière** | Controle de gestion | XT-DFCG-001 |
|  | Finance | XT-DFFI-001 |
|  | Comptabilité | XT-DFCB-001 |
|  |  |  |
| **Direction Marketing** | Digital | XT-DMDT-001 |
|  | Operationnel | XT-DMOP-001 |
|  | Produit | XT-DMPT-001 |
|  | Strategique | XT-DMST-001 |
|  |  |  |
| **DSI** | Data | XT-DSID-001 |
|  | Dev logiciel | XT-DSIL-001 |
|  | Support | XT-DSISU-001 |
|  |  |  |
| **R&D** | Innovation et Straté-2gie | XT-RDIS-001 |
|  | Laboratoire | XT-RDL-001 |
|  |  |  |
| **RH** | Formation | XT-RHF-001 |
|  | Gestion des performances | XT-RHGP-001 |
|  | Recrutement | XT-RHR-001 |
|  | Santé et sécurité au travail | XT-RHSST-001 |
|  |  |  |
| **Service Généraux** | Logistique | XT-SGL-001 |
|  | Gestion Immobilière | XT-SGGI-001 |
|  |  |  |
| **Service Juridique** | Contentieux | XT-SJCTX-001 |
|  | Contrats | XT-CT-001 |
|  |  |  |
| **Ventes et Dev Commercial** | ADV | XT-VDCADV-001 |
|  | B2B | XT-VDCC2B-001 |
|  | B2C | XT-VDVB2C-001 |
|  | Grands Comptes | XT-VDCGC-001 |
|  | Service achat | XT-VDCSA-001 |
|  | Service Client | XT-VDCSC-001 |
|  |  |  |
| **Direction Générale** | Directeur adjoint | XT-DGDA-001 |
|  | Assistant de direction | XT-DGAD-001 |
|  | CEO | XT-DGC-001 |
|  | Secrétaire | XT-DGS-001 |

# 3. Active Directory
## 3.1 Nom de domaine
Notre nom de domaine sera :
### **Xtech.green**
## 3.2 Nom des utilisateurs
Pour la nommenclature nous avons choisi : Nom.Prenom

## 3.3 Nom des groupes
Pour la nommenclature nous avons choisi :
Groupe de sécurité + 
| Groupe | Nom |

## 3.4 Nom des Unités d'Organisation
```
Xtech.green
├── Administrateurs
├── _Groupes
│   ├── Sécurité
│   └── Distribution
├── _Ordinateurs
│   ├── Clients
│   └── Serveurs
└── Utilisateurs
│   ├── Département (ex:RH)
│        └── Service (ex:Formation)
```
## 3.5 Nom des GPO
