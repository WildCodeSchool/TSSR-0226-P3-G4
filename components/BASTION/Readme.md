# Composant BASTION — Apache Guacamole (XenTech)

## 1. Présentation & Rôle Stratégique
Dans le cadre de l'évolution de l'infrastructure de la start-up **XenTech** (218 collaborateurs, 11 départements), la sécurisation des accès d'administration est un enjeu critique. Auparavant caractérisé par des PC en groupes de travail locaux sans cloisonnement, l'environnement est désormais structuré, virtualisé sur **Proxmox VE** et segmenté par VLANs à l'aide de **pfSense** et de routeurs **VyOS**.

Le **Bastion d'Administration (Apache Guacamole)** est l'**unique point d'entrée réseau et d'audit** pour toutes les opérations d'exploitation informatique. Il supprime les flux d'administration directs (RDP/SSH) depuis les postes de travail des utilisateurs vers le cœur de l'infrastructure.

## 2. Intégration Écosystème & Modèle Multi-Tiers
Le Bastion est interconnecté nativement avec l'ensemble des briques du projet :
* **Authentification centralisée (LDAP/AD) :** Synchronisé avec les trois Contrôleurs de Domaine Active Directory (`xtech.lan`) — incluant le DC principal en interface graphique (GUI) et les deux serveurs en mode CORE. L'authentification repose sur les groupes de sécurité AD, implémentant un modèle de privilèges par niveaux (*Tiering Model*).
* **Écosystème Windows Server 2022 (RDP) :** Interface graphique pour le management du Serveur de fichiers (RAID 1, partages réseaux structurés I/J/K avec énumération basée sur l'accès - ABE), du serveur de déploiement (WDS/WAPT) et de la solution **Veeam Backup & Replication**.
* **Écosystème Linux Debian/Ubuntu (SSH-2) :** Console en ligne de commande durcie via clés asymétriques **Ed25519 de 256 bits** pour l'administration de **GLPI** (Gestion de parc/ticketing), **PRTG** (Supervision globale), **Bitwarden** (Coffre-fort de mots de passe), **WSUS** (Mises à jour liées aux OU de l'AD) et **FreePBX** (Téléphonie VoIP).
* **Partenariat Pharmgreen :** En réponse à la mise en place du VPN site-à-site et de la relation de confiance AD commune, le Bastion fait office de sas de contrôle. Les membres IT de Pharmgreen accèdent aux ressources XenTech autorisées de manière étanche, sécurisée et entièrement tracée.

## 3. Matrice des Flux Réseaux (Politique Least Privilege)
Conformément aux principes appliqués sur notre pare-feu pfSense (`Deny all` par défaut), seuls les flux suivants impliquant le Bastion (situé dans une DMZ ou un VLAN de gestion isolé) sont autorisés :

| Zone Source | Zone Destination | Protocole / Port | Usage & Justification Fonctionnelle | 
| :--- | :--- | :--- | :--- |
| **PC Admin (VLAN Admin)** | Bastion | `TCP / 8080 et 443` | Accès à l'interface Web Guacamole d'administration |
| **Bastion** | Contrôleurs de Domaine (AD) | `TCP-UDP / 389` | Requêtes d'authentification LDAP & requêtes de groupes |
| **Bastion** | Serveurs Windows Cibles | `TCP / 3389` | Sessions distantes graphiques d'administration (RDP) |
| **Bastion** | Serveurs Linux & VyOS | `TCP / 22` | Sessions distantes en ligne de commande durcies (SSH) |
| **Réseau Pharmgreen (via VPN)** | Bastion | `TCP / 8080 et 443` | Accès contrôlé pour l'équipe IT de l'entreprise partenaire |

## 4. Déploiement Rapide (Conteneur LXC Debian)
L'installation est industrialisée au sein d'un conteneur LXC léger afin de rationaliser les ressources matérielles :
```bash
# Mise à jour système et installation du serveur applicatif, de Tomcat et des protocoles
sudo apt update && sudo apt install -y tomcat9 guacamole-tomcat guacd libguac-client-ssh0 libguac-client-rdp0

# Configuration de l'extension LDAP (/etc/guacamole/guacamole.properties)
guacamole-home: /etc/guacamole
ldap-hostname: 172.16.64.3  # IP du DC Officiel
ldap-port: 636 
ap-encryption-method: ssl
ap-base-dn: DC=Xtech,DC=green
ap-username-attribute: sAMAccountName
ap-search-bind-dn: CN=Sync_Guacamole,OU=PRS,DC=Xtech,DC=green
ap-search-bind--password: ******** (motdepasse-G4-xtech) 
