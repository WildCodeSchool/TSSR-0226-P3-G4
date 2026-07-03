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


```
Pour continuer, il faut :
Que le serveur soit membre d'un domaine AD DS ou bien qu'il soit un DC de ce domaine.
Ici ce n'est pas le cas, mais on voit également que le serveur peut être autonome.
C'est le cas de cette installation.
```

Le reste des pré-requis est bon :

Il y a un serveur DHCP, ici le service DHCP est sur le serveur AD DS
Il n'y a pas de rôle DNS, il n'y en a pas l'utilité ici
Une partition NTFS a été réservée pour le stockage des images   

<img width="394" height="178" alt="image" src="https://github.com/user-attachments/assets/ec10ed6f-2d5f-4482-b676-8d47c6923f4e" />

---

Cliquer sur Next
Sélectionner Integrated with Active Directory et cliquer sur Next

<img width="885" height="704" alt="config-srv-02" src="https://github.com/user-attachments/assets/6f14aca0-7c97-422c-98b7-d25c3bf5d9c4" />

 
```
C'est dans cette fenêtre que se fera le choix d'un serveur autonome ou rattaché à un domaine.
```

---



Choisir l'emplacement du deuxième disque dur et cliquer sur Next

<img width="886" height="703" alt="config-srv-01" src="https://github.com/user-attachments/assets/8a593481-d048-4dbf-8ce1-eb624b6a7eb9" />

---

Tout décocher car le serveur WDS est tributaire du DHCP de l'AD

<img width="889" height="698" alt="config-srv-03" src="https://github.com/user-attachments/assets/afc222ed-3423-4e12-964b-150c7fee7d07" />

---



```
Si une erreur apparait indiquant une erreur de syntaxe, le problème vient de la configuration de l'interface réseau.
Il faut aller dans la configuration de la carte réseau, au même endroit que la configuration IP, et cocher File and Printer Sharing for Microsoft Networks.
```

Dans la fenêtre Proxy DHCP Server, laisser tout par défaut et cliquer sur Next.


Une configuration automatique sera ajouté.
Dans la fenêtre PXE Server Initial Settings, on va sélectionner le comportement du serveur WDS lorsqu'il recevra les requêtes des ordinateurs clients. Il peut soit les ignorer et ne pas répondre, soit répondre seulement aux clients connus, soit aux clients connus et inconnus.
Pour ce lab, on sélectionnera Respond to all client computers et on ne coche pas la case en dessous.

<img width="882" height="703" alt="config-srv-04" src="https://github.com/user-attachments/assets/d1e3f6b5-1879-4d7b-9513-5c5c02a62892" />

---

Après avoir cliquer sur Next la configuration de WDS s'effectue
Quand elle est terminée, cliquer sur Finish

<img width="882" height="709" alt="config-srv-05" src="https://github.com/user-attachments/assets/d7e3008d-48ec-4170-96e1-907cc60ba67c" />

---

```
A ce stade, le serveur a bien été configuré mais le service n’a pas encore démarré. On peut le voir grâce à la présence d’une icône noire sur le nom du serveur.
```

<img width="362" height="269" alt="Capture d&#39;écran 2026-07-03 204720" src="https://github.com/user-attachments/assets/eb1b04fc-06f3-454d-8e7a-64aebd72bd05" />

---

## 3 Lancement du service WDS

**En PowerShell**

Pour démarrer le service, exécuter la commande suivante dans une console PowerShell :

```
Start-Service -Name WDSServer
```

**En graphique**

Pour le lancer, faire un clic droit sur le nom du serveur, cliquer sur All tasks puis Start.
Un message Successfully started Windows Deployment Services apparaît à la fin du lancement du service.

<img width="1385" height="690" alt="image" src="https://github.com/user-attachments/assets/b3c9f7ef-7bcc-4e17-a4d7-ba3f97013df1" />

---

<img width="530" height="224" alt="image" src="https://github.com/user-attachments/assets/a270e3c7-3dea-4eaf-8552-3bcc3cc19055" />

---

```
On peut voir une icone verte sur le nom du serveur, indiquant que le service est lancé.
```

<img width="358" height="295" alt="Capture d&#39;écran 2026-07-03 205030" src="https://github.com/user-attachments/assets/6443d084-0586-470b-b7c1-383dd650a9c3" />

---

Dans la console WDS, sous le nom du serveur, on peut voir les dossiers suivants :   

**Install images** : contient les images des systèmes d’exploitation à déployer    
**Boot images** : contient les images WinPE permettant d’amorcer le système depuis le réseau 

<img width="1912" height="358" alt="Capture d&#39;écran 2026-07-03 213310" src="https://github.com/user-attachments/assets/a4d3103c-caac-42a0-8567-19eb5de9b5fe" />

---

**Pending devices** : liste des clients en attente de validation (si on a coché la case de validation des clients à l'étape PXE Server Initial Settings)    
**Prestage Devices** : liste des clients connus qui peuvent être sélectionné    
**Multicast transmissions** : permet de créer des sessions multicast afin de déployer un grand nombre de clients simultanément   
**Drivers** : permet d’ajouter des pilotes afin de les incorporer dans les images à déployer    
De même, à l'emplacement choisi pour les données de déploiement, donc ici le second disque dur, tu trouveras une nouvelle arborescence de dossiers.    
C'est dans ces dossier que tu mettras les images de déploiement, les images de démarrage, les pilotes logiciels, ...     

<img width="1148" height="435" alt="image" src="https://github.com/user-attachments/assets/fe3aa272-635d-4f8f-bc86-1b7625a243d5" />


---

A ce stade, tu as un serveur WDS fonctionnel avec le service lancé.    

---
