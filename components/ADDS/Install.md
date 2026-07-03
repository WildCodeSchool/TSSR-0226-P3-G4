# Serveur Active Directory — Guide d'Installation et de Déploiement

## 1. Prérequis et Configuration Réseau du Bloc de Contrôle
1. Déployer quatre instances Windows Server 2022 au sein du VLAN Active Directory dédié et isolé.
2. Assigner les configurations IP statiques et masques de sous-réseau `/24` (`255.255.255.0`) :
   - `XTSE-411` (Principal / Graphique) : `172.16.64.3` | Passerelle : `172.16.64.254`
   - `XTSE-412` (Secondaire / Core) : `172.16.64.23` | Passerelle : `172.16.64.254`
   - `XTSE-424` (Troisième / Core) : `172.16.64.24` | Passerelle : `172.16.64.254`
   - `XTSE-420` (Quatrième / Graphique / WDS) : `172.16.64.25` | Passerelle : `172.16.64.254`
3. Définir le serveur DNS initial de chaque réplica sur l'adresse du serveur principal (`172.16.64.3`) avant leur promotion.

<img width="1492" height="377" alt="Capture d&#39;écran 2026-07-04 003641" src="https://github.com/user-attachments/assets/c5bf8bdf-a8ec-4f4b-92a4-9f9e140151bb" />

---

## 2. Déploiement Industrialisé et Installation des Rôles sur le DC Principal
Avant d'exécuter la promotion de la forêt, installer de manière obligatoire les services de base via le Gestionnaire de serveur (Server Manager) ou l'interface PowerShell sous-jacente.

### 2.1. Ajout des rôles DNS, DHCP et AD DS
1. Ouvrir le **Gestionnaire de serveur** (Server Manager) sur `xts-411`.
2. Cliquer sur **Gérer** > **Ajouter des rôles et fonctionnalités**.
3. Sélectionner **Installation basée sur un rôle ou une fonctionnalité**.
4. Cocher les rôles suivants dans la liste :
   * **Services de domaine Active Directory** (AD DS)
   * **Serveur DNS**
   * **Serveur DHCP**
5. Valider l'ajout des outils de gestion requis et exécuter l'installation.

<img width="158" height="177" alt="image" src="https://github.com/user-attachments/assets/82d5c26b-4820-465e-b820-9d41d7e10e53" />

---

*Alternative en ligne de commande équivalente (via le script de la suite `hello my dir`) :*
```powershell
Install-WindowsFeature -Name AD-Domain-Services, DNS, DHCP -IncludeManagementTools
```


Initialiser la nouvelle forêt Active Directory avec le nom de domaine racine Xtech.green.

Valider la création automatisée de l'arborescence des Unités d'Organisation sous le conteneur racine OU=PRS et l'importation en masse des 218 comptes utilisateurs configurés par le script.

3. Déploiement, Jonction de Domaine et Promotion des DCs de Réplication
3.1. Configuration de l'environnement Server Core (server-core-1 et server-core-2)
Ouvrir une console PowerShell locale sur chaque serveur Core.

Configurer l'adresse IP statique et le DNS principal :


```
# Exemple pour server-core-1
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 172.16.64.3 -PrefixLength 24 -DefaultGateway 172.16.64.254
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 172.16.64.3
```
---

Joindre la machine au domaine Xtech.green et redémarrer :

```
Add-Computer -DomainName "Xtech.green" -Restart
```
--- 

3.2. Configuration du serveur WDS graphique (xts-wds)
Installer le rôle Windows Deployment Services (WDS) et les outils d'administration AD DS par PowerShell :

```
Install-WindowsFeature -Name WDS, AD-Domain-Services, RSAT-AD-Tools -IncludeManagementTools
```
--- 

Joindre la machine au domaine Xtech.green et redémarrer :

```
Add-Computer -DomainName "Xtech.green" -Restart
```
--- 

3.3. Promotion en tant que Contrôleurs de Domaine (DC) de réplication
Exécuter la commande PowerShell de promotion sur server-core-1, server-core-2 et xts-wds après le redémarrage pour les déclarer comme contrôleurs de domaine supplémentaires :

```
Install-ADDSDomainController -DomainName "Xtech.green" -InstallDns:$true -Credential (Get-Credential)
```

---

4. Répartition des Rôles FSMO (Flexible Single Master Operations)
Pour garantir la haute disponibilité et la tolérance aux pannes de l'annuaire, exécuter le transfert des 5 rôles FSMO.

4.1. Statut initial (Rôles Forêt hébergés sur xts-411)
Le DC principal xts-411 conserve de façon stricte les rôles de niveau forêt :

Contrôleur de Schéma (Schema Master)

Maître de Nomination de Domaines (Domain Naming Master)

4.2. Opérations de transfert des rôles de niveau Domaine via PowerShell
Transférer le rôle d'Émulateur PDC (PDCEmulator) vers server-core-1 :


```
Move-ADDirectoryServerOperationMasterRole -Identity "server-core-1" -OperationMasterRole PDCEmulator -Confirm:$false
```

---
Transférer le rôle de Maître RID (RIDMaster) vers server-core-2 :

```
Move-ADDirectoryServerOperationMasterRole -Identity "server-core-2" -OperationMasterRole RIDMaster -Confirm:$false
```
---

Transférer le rôle de Maître d'Infrastructure (InfrastructureMaster) vers xts-wds :

```
Move-ADDirectoryServerOperationMasterRole -Identity "xts-wds" -OperationMasterRole InfrastructureMaster -Confirm:$false
```

---

4.3. Audit et validation de la topologie
Exécuter la commande d'audit suivante pour confirmer la bonne répartition des rôles sur les 4 contrôleurs de domaine :

```
netdom query fsmo
```



<img width="1893" height="242" alt="image" src="https://github.com/user-attachments/assets/db489f62-553a-4930-bf05-12152443f75c" />

---
