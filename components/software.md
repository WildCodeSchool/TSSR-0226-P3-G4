# Machine dédiée à l'administration (systèmes et réseaux) de Xentech

Ce document recense l'ensemble des logiciels et outils d'administration installés sur la machine de gestion, configurés et accessibles (en local ou via le web) conformément à l'architecture de sécurité mise en œuvre.

1. [Administration des serveurs Windows](#Administration-des-serveurs-Windows)
2. [Administration des serveurs Linux](#Administration-des-serveurs-Linux)
3. [Logiciels et outils multi-OS](#Logiciels-et-outils-multi-OS)

## PC d'administration : XTA-401

### 1. Administration des serveurs Windows

* **RSAT** - Gestion de consoles serveurs distants - Permet l'administration centralisée des rôles Active Directory (AD), DNS, DHCP, etc.
* **Windows RDP** - Prise de main à distance - Client officiel pour l'accès aux interfaces graphiques des serveurs Windows.
* **Remote PowerShell** - CLI à distance - Permet l'exécution de scripts et de commandes à distance sur les serveurs Windows.
* **Serveur RDP** - Portail RDP - Service permettant l'accès distant entrant vers ce PC d'administration (si autorisé par la politique de sécurité).
* **Suite Sysinternals** - Suite d'outils système - Ensemble d'utilitaires avancés pour le dépannage, le diagnostic et la surveillance de l'OS Windows.

### 2. Administration des serveurs Linux

* **MobaXterm / GitBash** - Shell Bash et protocoles SSH/SCP - Terminal avancé et environnement de commandes pour la gestion des serveurs Linux.
* **PuTTY / Termius** - Client SSH - Outils de connexion sécurisée en ligne de commande.
* **WinSCP / FileZilla** - Transfert de fichiers - Clients SFTP/FTP permettant le transfert sécurisé de données et de configurations.
* **WSL (Windows Subsystem for Linux)** - Intégration Linux - Environnement permettant d'exécuter des outils et distributions Linux nativement sous Windows.
* **VNC (et dérivés)** - Prise en main à distance GUI - Permet l'accès et le contrôle des interfaces graphiques (X11/Wayland) des serveurs Linux.

### 3. Logiciels et outils multi-OS

* **Trippy** - Diagnostic réseau - Outil en ligne de commande combinant les fonctionnalités de traceroute et de ping pour l'analyse des chemins réseau.
* **OpenSSH** - Connectivité sécurisée - Client et serveur pour les connexions chiffrées et la gestion des clés SSH.
* **Wireshark** - Analyse réseau - Analyseur de protocoles pour la capture et l'inspection approfondie du trafic réseau.

------------
# Administration des serveurs Windows

* **RSAT** - Gestion de consoles serveurs distants - Permet l'administration centralisée des rôles Active Directory (AD), DNS, DHCP, etc.
```powershell
# Exemples de commandes via les modules RSAT (Active Directory) installés localement
# Valider la connectivité AD vers le contrôleur de domaine XTS-411
Get-ADDomainController -Identity "XTS-411"

# Créer un nouvel utilisateur dans l'OU Utilisateurs à distance depuis XTA-401
New-ADUser -Name "Abel Abe" -SamAccountName "aabe" -Path "OU=Utilisateurs,DC=xtech,DC=green"
```
---------
* **Windows RDP** - Prise de main à distance - Client officiel pour l'accès aux interfaces graphiques des serveurs Windows.
```powershell
# Lancer une session RDP directe vers le serveur AD en spécifiant l'hôte
mstsc /v:XTS-411

# Lancer en mode admin / console (si nécessaire pour la maintenance)
mstsc /v:XTS-411 /admin
```
--------
* **Remote PowerShell** - CLI à distance - Permet l'exécution de scripts et de commandes à distance sur les serveurs Windows.
```powershell
# Connexion interactive persistante de XTA-401 vers le serveur AD XTS-411
Enter-PSSession -ComputerName XTS-411 -Credential XTECH\Administrator

# Exécution d'une commande unique à distance sans ouvrir de session interactive
Invoke-Command -ComputerName XTS-411 -ScriptBlock { Get-Service -Name "NTDS" }
```
-------
* **Serveur RDP** - Portail RDP - Service permettant l'accès distant entrant vers ce PC d'administration (si autorisé par la politique de sécurité).
```powershell
# Vérifier l'état du service RDP entrant sur le PC-Admin XTA-401
Get-Service -Name "TermService"

# Activer le bureau à distance sur la machine locale via PowerShell (si besoin)
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0
```
-------
* **Suite Sysinternals** - Suite d'outils système - Ensemble d'utilitaires avancés pour le dépannage, le diagnostic et la surveillance de l'OS Windows.
```powershell
# PsExec : Exécuter un processus à distance sur XTS-411 avec les privilèges SYSTEM
psexec \\XTS-411 -s cmd.exe

# PsLoggedOn : Vérifier qui est actuellement connecté sur le serveur AD
psloggedon \\XTS-411
```
--------
# Administration des serveurs Linux

* **MobaXterm / GitBash** - Shell Bash et protocoles SSH/SCP - Terminal avancé et environnement de commandes pour la gestion des serveurs Linux.
```bash
# Ouvrir un shell local GitBash et initialiser une connexion vers un serveur Linux cible
ssh T3@XTS-414 (T3 : admin SRV-Linux et XTS-414 : CT Debian 12 LAMP sur lequel est hébergé GLPI)

# Générer une paire de clés SSH depuis XTA-401 pour sécuriser les accès futures
ssh-keygen -t ed25519 -C "admin@xentech"
```
-----------
* **PuTTY / Termius** - Client SSH - Outils de connexion sécurisée en ligne de commande.
```powershell
# Lancer PuTTY en ligne de commande avec un profil ou une IP spécifique
putty.exe -ssh T3@XTS-414 -P 22

# Utilisation de plink (composant PuTTY CLI) pour exécuter une commande
plink.exe T3@XTS-414 -pw "Azerty1*" "uname -a"
```
---------
* **WinSCP / FileZilla** - Transfert de fichiers - Clients SFTP/FTP permettant le transfert sécurisé de données et de configurations.
```powershell
# Exemple d'appel WinSCP en ligne de commande pour synchroniser un dossier de scripts
winscp.exe /command "open sftp://T3@XTS-414/ -hostkey=""ssh-ed25519...""" "synchronize local C:\Xentech\Scripts /var/www/html" "exit"
```
------
* **WSL (Windows Subsystem for Linux)** - Intégration Linux - Environnement permettant d'exécuter des outils et distributions Linux nativement sous Windows.
```bash
# Depuis l'invite de commande de XTA-401, lister les distributions installées
wsl --list --verbose

# Entrer dans la distribution Linux par défaut pour utiliser des outils Linux (ex: nmap)
wsl nmap -sV XTS-414
```
---------
* **VNC (et dérivés)** - Prise en main à distance GUI - Permet l'accès et le contrôle des interfaces graphiques (X11/Wayland) des serveurs Linux.
```powershell
# Connexion via un tunnel SSH sécurisé préalable (recommandé pour VNC)
# Étape 1 (SSH tunnel) : ssh -L 5901:localhost:5901 admin_tech@srv-linux-01
# Étape 2 (VNC client) : Connecter le client VNC sur l'adresse suivante
vncviewer.exe localhost:1
```
----------
# Logiciels et outils multi-OS

* **Trippy** - Diagnostic réseau - Outil en ligne de commande combinant les fonctionnalités de traceroute et de ping pour l'analyse des chemins réseau.
```powershell
# Analyser le chemin réseau et la perte de paquets entre XTA-401 et le contrôleur AD
trip XTS-411

# Lancer Trippy en mode de routage spécifique (ex: en utilisant des paquets TCP au lieu d'ICMP)
trip XTS-411 -p tcp
```
---------
* **OpenSSH** - Connectivité sécurisée - Client et serveur pour les connexions chiffrées et la gestion des clés SSH.
```bash
# Transférer votre clé publique d'administration vers un serveur Linux cible
ssh-copy-id -i ~/.ssh/id_ed25519.pub admin_tech@srv-linux-01.xentech.local

# Tester la configuration et afficher les logs de débogage lors de la connexion
ssh -v admin_tech@srv-linux-01.xentech.local
```
---------
* **Wireshark** - Analyse réseau - Analyseur de protocoles pour la capture et l'inspection approfondie du trafic réseau.
```powershell
# tshark (Wireshark en CLI) : Capturer le trafic réseau sur l'interface principale (ex: index 1)
tshark -i 1 -f "tcp port 389 or tcp port 636" -w C:\Traffics\LDAP_Capture.pcapng

# Note : Remplacez l'index de l'interface par celui correspondant à votre carte réseau.
```
