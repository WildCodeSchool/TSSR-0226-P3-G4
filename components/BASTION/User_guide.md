# Guide Utilisateur — Bastion d'Administration (XenTech)

Ce guide s'adresse aux équipes techniques de XenTech habilitées à administrer les infrastructures réseaux et systèmes.

##  1. Connexion Initiale
1. Allumez votre **PC d'administration** sécurisé (Windows 11 Professionnel T1).
2. Ouvrez votre navigateur internet et naviguez vers l'adresse du Bastion : `http://172.16.64.54:8080/guacamole/`

<img width="901" height="850" alt="Capture d&#39;écran 2026-06-29 142112" src="https://github.com/user-attachments/assets/d1e644bf-60ea-4ffa-bba8-c2014d6266dc" />

--------

3. Saisissez vos identifiants réseau nominatifs **Active Directory** (`identifiant & mdp`).

<img width="434" height="471" alt="Capture d&#39;écran 2026-06-29 142432" src="https://github.com/user-attachments/assets/86edfe02-6259-4cbe-8f01-34f08ea00db1" />

------


##  2. Interface d'Accueil et Navigation
Une fois connecté, l'écran d'accueil liste exclusivement les machines (Serveurs Windows, Linux) pour lesquelles votre compte dispose d'une autorisation d'accès (Principe du moindre privilège) :

<img width="1912" height="351" alt="Capture d&#39;écran 2026-06-29 142649" src="https://github.com/user-attachments/assets/b201470a-b9ed-4f2d-b2a0-b968ec821e89" />

--------

* **Clic simple :** Ouvre instantanément la session sur la machine cible dans votre onglet de navigation actuel.
* **Sessions simultanées :** Vous pouvez ouvrir plusieurs serveurs en même temps. Guacamole permet de basculer d'une machine à une autre via des miniatures ou des onglets graphiques.

## 3. Exploitation d'une Session RDP (Serveurs Windows)
Lors de l'administration du Contrôleur de Domaine, du Serveur de fichiers ou du serveur de sauvegarde Veeam :
* **Raccourci Majeur :** Utilisez la combinaison de touches `Ctrl + Alt + Shift` pour faire apparaître le panneau de configuration Guacamole.
* **Presse-papiers :** Pour copier/coller du texte (scripts PowerShell, variables) depuis votre poste physique vers le serveur virtuel, vous devez obligatoirement coller votre texte dans la zone de texte "Presse-papiers" de ce panneau avant de pouvoir le manipuler dans la VM Windows.

##  4. Exploitation d'une Session SSH (Serveurs Linux & Réseau)
Lors de l'administration des conteneurs Linux (Zabbix, GLPI) :
* L'authentification par clés de chiffrement asymétriques **Ed25519 de 256 bits** est gérée de manière transparente en arrière-plan par le Bastion.
* Aucune clé privée ne transite sur votre poste client d'administration, garantissant l'étanchéité absolue de l'accès root.

##  5. Résolution des Incidents (FAQ)
* **Erreur "Upstream Error" (Serveur injoignable) :** La machine cible est éteinte sur Proxmox VE, le service distant (sshd/rdp) a planté, ou une règle de filtrage ACL sur le pare-feu pfSense bloque le flux sortant depuis l'IP du Bastion.
