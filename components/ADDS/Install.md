# Serveur Active Directory — Guide d'Installation et de Déploiement

## 1. Prérequis et Configuration Réseau du Bloc de Contrôle
1. Déployer quatre instances Windows Server 2022 au sein du VLAN Active Directory dédié et isolé.
2. Assigner les configurations IP statiques et masques de sous-réseau `/24` (`255.255.255.0`) :
   * `xts-411` (Principal / Graphique) : `172.16.64.3` | Passerelle : `172.16.64.254`
   * `server-core-1` (Secondaire / Core) : `172.16.64.23` | Passerelle : `172.16.64.254`
   * `server-core-2` (Troisième / Core) : `172.16.64.24` | Passerelle : `172.16.64.254`
   * `xts-wds` (Quatrième / Graphique / WDS) : `172.16.64.25` | Passerelle : `172.16.64.254`
3. Définir le serveur DNS initial de chaque réplica sur l'adresse du serveur principal (`172.16.64.3`) avant leur promotion.

## 2. Déploiement Industrialisé du DC Principal via `hello my dir`
1. Exécuter le script PowerShell maître `hello-my-dir.ps1` sur la machine `xts-411` afin d'automatiser l'installation des rôles :
```powershell
Install-WindowsFeature -Name AD-Domain-Services, DNS, DHCP -IncludeManagementTools
```

---

Initialiser la nouvelle forêt Active Directory avec le nom de domaine racine Xtech.green.

Valider la création automatisée de l'arborescence des Unités d'Organisation sous le conteneur racine OU=PRS et l'importation en masse des 218 comptes utilisateurs configurés par le script.

3. Déploiement, Jonction de Domaine et Promotion des DCs de Réplication
3.1. Configuration de l'environnement Server Core (server-core-1 et server-core-2)
Ouvrir une console PowerShell locale sur chaque serveur Core.

Configurer l'adresse IP statique et le DNS principal :


```
# Exemple pour server-core-1
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 172.16.64.23 -PrefixLength 24 -DefaultGateway 172.16.64.254
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

---


