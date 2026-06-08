# Machine dédiée à l'administration (systèmes et réseaux) de Xentech

Ce document recense l'ensemble des logiciels et outils d'administration installés sur la machine de gestion, configurés et accessibles (en local ou via le web) conformément à l'architecture de sécurité mise en œuvre.

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
