# Installation WDS

**Pré requis**

VM Microsoft Windows Server 2022    
Adresse IP fixe du serveur : 172.16.64.54/24    
Nom du serveur : XTSE-420    
Ce serveur dispose de 2 disques de stockage de 32G et 80G    
Partition de type : GPT    
File system : NTFS    
Nom : WDS   

---

## 1 Installation du rôle WDS

**En PowerShell**

Exécuter la commande suivante dans une console PowerShell :

```
Install-WindowsFeature wds-deployment -includemanagementtools
```



**En graphique**


Ouvrir le Service Manager.   
Aller dans Managepuis Add Roles and Features   
Cliquer sur Next    
Sélectionner Role-based or feature-based installation puis Next   
Sélectionner votre serveur et cliquer sur Next   
Choisir le rôle Windows Deployment Service, dans la fenêtre qui apparaît cliquer sur Add features    
Cliquer 4 fois sur Next en laissant les options par défaut    
Cliquer sur Install puis Close    


<img width="1177" height="843" alt="image" src="https://github.com/user-attachments/assets/fe083255-d6c3-457c-b7f4-35ab13c8fdd5" />

---

L'installation est terminée lorsque le rôle WDS apparaît dans le Server Manager.
La console Windows Deployment Services est disponible dans le menu Tools, à partir du rôle WDS, ou encore en tapant WdsMgmt.msc dans une fenêtre de commande.
Si on la lance, voilà à quoi elle ressemble :

<img width="1422" height="129" alt="image" src="https://github.com/user-attachments/assets/cc39f7d5-371e-470f-86e1-43542220fbde" />

---

<img width="1914" height="559" alt="image" src="https://github.com/user-attachments/assets/109f1cec-0775-4182-94a1-701050261f5f" />

---

On voit bien ici qu'il n'y a rien de configuré :


<img width="626" height="289" alt="image" src="https://github.com/user-attachments/assets/be3dd0f6-b99b-4c80-b11f-a2d3493126a8" />

---

## 2 Configuration du WDS

**En PowerShell**

```
Exécuter la commande suivante dans une console PowerShell pour configurer le service :

# /Server:(Nom du serveur WDS)
# /remInst:(emplacement des données WDS pour les déploiements)
# /Standalone : A utiliser si le serveur n'est pas sur un domaine
wdsutil /Initialize-Server /Server:srv-wds /remInst:D:\WdsData /Standalone 
Exécuter la commande suivante dans une console PowerShell pour configurer la gestion des clients :

# /Server:(Nom du serveur WDS)
# /AnswerClients:(All | Known | None) ==> le comportement pour les requêtes des clients
# All   ==> Réponse à tous les clients
# Known ==> Réponse uniquement aux clients connu
# None  ==> Pas de réponse aux clients
wdsutil /Set-Server /Server:srv-wds /AnswerClients:All 
La commande suivante va permettre de vérifier la configuration :

# /Server:(Nom du serveur WDS)
wdsutil /Get-Server /Server:srv-wds /Show:Config
```

**En graphique**

Si la console WDS n'est pas lancé, lancez-là

Cliquer sur le nœud Servers
Sélectionner le serveur WDS et cliquer avec le bouton droit de la souris
Sélectionner Configure Server, cette fenêtre apparait :
Fenetre configuration WDS
Pour continuer, il faut :
Que le serveur soit membre d'un domaine AD DS ou bien qu'il soit un DC de ce domaine.
Ici ce n'est pas le cas, mais on voit également que le serveur peut être autonome.
C'est le cas de cette installation.

Le reste des pré-requis est bon :

Il y a un serveur DHCP, ici le service DHCP est sur le même serveur
Il n'y a pas de rôle DNS, il n'y en a pas l'utilité ici
Une partition NTFS a été réservée pour le stockage des images
Cliquer sur Next
Sélectionner Standalone server et cliquer sur Next
C'est dans cette fenêtre que se fera le choix d'un serveur autonome ou rattaché à un domaine.

Choisir l'emplacement du deuxième disque dur et cliquer sur Next
Si une erreur apparait indiquant une erreur de syntaxe, le problème vient de la configuration de l'interface réseau.
Il faut aller dans la configuration de la carte réseau, au même endroit que la configuration IP, et cocher File and Printer Sharing for Microsoft Networks.

Dans la fenêtre Proxy DHCP Server, laisser tout par défaut et cliquer sur Next.
Une configuration automatique sera ajouté.
Dans la fenêtre PXE Server Initial Settings, on va sélectionner le comportement du serveur WDS lorsqu'il recevra les requêtes des ordinateurs clients. Il peut soit les ignorer et ne pas répondre, soit répondre seulement aux clients connus, soit aux clients connus et inconnus.
Pour ce lab, on sélectionnera Respond to all client computers et on ne coche pas la case en dessous.
Après avoir cliquer sur Next la configuration de WDS s'effectue
Quand elle est terminée, cliquer sur Finish


