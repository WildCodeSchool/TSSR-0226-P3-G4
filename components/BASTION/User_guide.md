# Guide Utilisateur — Bastion d'Administration (XenTech)

Ce guide s'adresse aux équipes techniques de XenTech habilitées à administrer les infrastructures réseaux et systèmes.

##  1. Connexion Initiale
1. Allumez votre **PC d'administration** sécurisé (Windows 11 Professionnel T1).
2. Ouvrez votre navigateur internet et naviguez vers l'adresse du Bastion : `http://172.16.64.54:8080/guacamole/`

<img width="901" height="850" alt="Capture d&#39;écran 2026-06-29 142112" src="https://github.com/user-attachments/assets/d1e644bf-60ea-4ffa-bba8-c2014d6266dc" />

--------

3. Saisissez les identifiants Guacamole par défaut lors de la 1ère connexion : `guacadmin/guacadmin`   
(que nous allons durcir par la suite en créant un compte T1)..

<img width="434" height="471" alt="Capture d&#39;écran 2026-06-29 142432" src="https://github.com/user-attachments/assets/86edfe02-6259-4cbe-8f01-34f08ea00db1" />

------


##  2. Interface d'Accueil et Navigation
Une fois connecté, sur l'écran d'accueil en haut à droit, cliquer l'identifiant et dans le menu déroulant, cliquer sur settings puis Connections 

<img width="1902" height="328" alt="image" src="https://github.com/user-attachments/assets/f64e352f-6fb5-4018-8f44-64b5056d93a6" />

-----------

## 2.1 Cliquer sur New Connection pour ajouter un PC client, PC admin ou un Serveur

EDIT CONNECTION   
Name : Nom_PC ou Nom_Serveur (PC_Admin: XTA-401)   
Location : ROOT   
Protocol : RDP   

<img width="1876" height="237" alt="image" src="https://github.com/user-attachments/assets/b1a91c5c-93fa-481e-b9cc-a72611582660" />

-------

PARAMETERS   

Network   
Hostname : IP_PC ou IP_Serveur (IP XTA-401: 172.16.64.10)    
Port : 3389   

Authentication   
Domain : xtech.green   
Security mode: NLA   
Cocher : Ignore server certificate   

<img width="1881" height="687" alt="image" src="https://github.com/user-attachments/assets/8289f6ad-9340-4152-bd3a-14f680708fdb" />

--------


Basic Settings   
Keyboard layout : French Azerty (clavier AZERTY_FR) pour s'identifier sinon le clavier est en QWERTY de base..   
Tout en bas cliquer sur Save.    

<img width="1865" height="322" alt="image" src="https://github.com/user-attachments/assets/a97649b5-1d0b-4e39-99ef-01eccf2b0a17" />

------

## 3. Exploitation d'une Session RDP (Serveurs Windows)

Créer un nouvel utilisateur T1 afin de se connecter en RDP via le PC-admin T1. Dans le menu settings, cliquer sur New User et donner toutes les permissions.

<img width="1880" height="927" alt="image" src="https://github.com/user-attachments/assets/755559ea-3ba3-4f79-95ec-1e93a3f0c27a" />

--------

<img width="1867" height="402" alt="image" src="https://github.com/user-attachments/assets/6e228d1b-1794-4ae0-95c2-0e199fd99c24" />

--------

## 3.1 Connexion en tant que T1 à Guacamole

<img width="428" height="470" alt="image" src="https://github.com/user-attachments/assets/515d388e-9dc6-4bf9-b4ed-f06097abdf04" />

--------

liste exclusivement les machines (Serveurs Windows, Linux) pour lesquelles votre compte dispose d'une autorisation d'accès (Principe du moindre privilège) :

<img width="1914" height="774" alt="image" src="https://github.com/user-attachments/assets/e18b38f7-6a9b-484d-ad4b-bec430b9b025" />

------


Lors de l'administration du Contrôleur de Domaine, du Serveur de fichiers ou du serveur WDS :


* **Clic simple :** Ouvre instantanément la session sur la machine cible dans votre onglet de navigation actuel.
* **Sessions simultanées :** Vous pouvez ouvrir plusieurs serveurs en même temps. Guacamole permet de basculer d'une machine à une autre via des miniatures ou des onglets graphiques.

<img width="1905" height="457" alt="image" src="https://github.com/user-attachments/assets/4e8a1470-0e3c-4132-b53c-fe26f544c8eb" />

----------

Saisir l'identifiant T1 et mot de passe du compte T1 de l'AD pour se connecter à l'AD via le serveur Bastion Guacamole 

<img width="1536" height="272" alt="Capture d&#39;écran 2026-07-01 142003" src="https://github.com/user-attachments/assets/51252fbd-7789-44b0-92dd-68b470530b6c" />



-------
Le serveur Bastion Guacamole est fonctionnel, l'accès au serveur AD est dorénavant sécurisé depuis le PC admin en tant que T1

<img width="1920" height="1199" alt="image" src="https://github.com/user-attachments/assets/b36eaac6-cf49-4d66-957a-e79f63f3f002" />

----------






##  4. Exploitation d'une Session SSH (Serveurs Linux & Réseau)
Lors de l'administration des conteneurs Linux (Zabbix, GLPI) :
* L'authentification par clés de chiffrement asymétriques **Ed25519 de 256 bits** est gérée de manière transparente en arrière-plan par le Bastion.
* Aucune clé privée ne transite sur votre poste client d'administration, garantissant l'étanchéité absolue de l'accès root.

##  5. Résolution des Incidents (FAQ)
* **Erreur "Upstream Error" (Serveur injoignable) :** La machine cible est éteinte sur Proxmox VE, le service distant (sshd/rdp) a planté, ou une règle de filtrage ACL sur le pare-feu pfSense bloque le flux sortant depuis l'IP du Bastion.
