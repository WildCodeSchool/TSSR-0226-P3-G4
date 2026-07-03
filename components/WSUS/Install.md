# Installation WSUS

Pré-requis

Un hyperviseur comme Virtualbox/Proxmox  pour pouvoir créer des VM
1 VM XTSE-419 avec Windows Server 2022 installé et mise à jour, avec :
Un espace libre et non-configuré (sur une partition ou un disque) d'au moins 20 Go
Une carte réseau en Réseau interne avec l'adresse IP 172.16.10.10/24

---

# 1 Installation et configuration de WSUS

## 1.1 Création de la partition de stockage des mises à jour   

Créer une partition formaté avec un espace de 20 Go qui se nomme `WSUS`.   
Sur cette partition, créer un dossier `WSUS`   

<img width="406" height="194" alt="WSUS-20G" src="https://github.com/user-attachments/assets/92185b89-bb98-4c72-a811-7afe4f2462e3" />


---

<img width="968" height="348" alt="image" src="https://github.com/user-attachments/assets/ba86ec25-a3fa-47c3-8a6d-c03927a3fb59" />

---

## 1.2 Installation du rôle WSUS

À partir du Server Manager, installe le rôle Windows Server Update Services.
Valide les fonctionnalités supplémentaires qui vont s'ajouter automatiquement.
Ensuite, sélectionne `WID Connectivity` et `WSUS Service`.
Indique le dossier que tu as créer pour l'emplacement du stockage des mises à jour.
Termine l'installation et redémarre le serveur.

<img width="1175" height="837" alt="WSUS-SRV" src="https://github.com/user-attachments/assets/b1199133-b65c-4f77-a732-09ed108c315c" />

---

<img width="1174" height="835" alt="image" src="https://github.com/user-attachments/assets/ed08683d-e804-490d-9567-18cab99f572b" />

---

<img width="1174" height="835" alt="path-WSUS" src="https://github.com/user-attachments/assets/bfdcb3af-20c4-4282-8510-9ef70ec22c80" />


---

# 2 Configuration du service WSUS

Une fois le serveur redémarré, lance la tâche `Post Deployment Configuration for WSUS` dans le Server Manager.
Ensuite, dans la fenêtre de gauche, vas dans WSUS.
Avec le bouton droit sélectionne `Windows Server Update Services` cela va lancer automatiquement l'assistant de configuration.


<img width="1850" height="466" alt="Post-deployment" src="https://github.com/user-attachments/assets/99f7a5b5-b1bd-4298-a6fa-a8bae29d8d95" />

---

<img width="1924" height="1105" alt="image" src="https://github.com/user-attachments/assets/53dacbad-eef1-4b1d-b280-eae5968fee7d" />

---

Si tu a lancé l'assistant :

Décoche la case `Yes, I would like to join the Microsoft Update Improvement Program`

<img width="1109" height="821" alt="image" src="https://github.com/user-attachments/assets/ad4d4e77-eb2e-4035-aa82-dcc0d3f502ab" />

---

Laisse sélectionné la case `Synchronize from Microsoft Update`

<img width="1108" height="813" alt="image" src="https://github.com/user-attachments/assets/4bb8a6cb-bce9-45d8-bd4e-b57bf1b13762" />

---

Ne mets pas de proxy

<img width="1109" height="815" alt="image" src="https://github.com/user-attachments/assets/23ce382e-fd6c-4bd9-9215-3506b6c7d72a" />

---

À la fin, clic sur `Start Connecting`. Cette action peut être longue (entre 10 et 20 min) !

<img width="1111" height="817" alt="image" src="https://github.com/user-attachments/assets/89036624-eb8b-4733-8817-d4d6d115d8ce" />

---

Si cela ne fonctionne pas, vérifier la connexion internet
Après, sélectionne les langues `English` et `French`

<img width="688" height="769" alt="image" src="https://github.com/user-attachments/assets/b56b8e46-277f-4b24-a293-0b7659486ae6" />

---

Dans la fenêtre d'après, sélectionne les produits pour lesquels tu souhaites avoir des mises à jour. Ici tu peux choisir parmi les produits Windows 11 et les serveurs

<img width="692" height="770" alt="image" src="https://github.com/user-attachments/assets/64d5975f-d1b5-4458-87cd-12aa4f5d2936" />

---

Pour les classifications laisse les choix par défaut
Pour la synchronisation, choisi **4** synchronisations par jour, à partir de **2h**.

<img width="690" height="765" alt="image" src="https://github.com/user-attachments/assets/911c66f1-dd5e-458e-a9b2-b539a3e97e8a" />

---

Enfin coche la case `Begin initial synchronization` et clic sur `Finish`


---

Pour voir l'état de la synchronisation, tu cliques sur le nom de ton serveur dans la fenêtre, et tu as l'état de la synchronisation avec le widget Synchronization Status.

<img width="1919" height="996" alt="image" src="https://github.com/user-attachments/assets/d242688f-2ff0-433a-b71a-4878c27ca911" />

---

Va dans Options, puis Automatic Approvals.


Dans l'onglet Update Rules, cocher Default Automatic Approval Rule.

<img width="690" height="765" alt="image" src="https://github.com/user-attachments/assets/9a1e1225-8c02-4fa3-93ee-b0f0a5f7be23" />

---

Cela permet d'approuver automatiquement les mises à jour suivant les règles de la section Rule Properties se trouvant en dessous. Par défaut, une mise à jour Critique ou de Sécurité sont Approuvées sur tout les ordinateurs.

Cliquer sur Run Rules
Cliquer sur Apply et OK

---

# 3 Liaison avec les ordinateurs du domaine

## 3.1 Configuration sur WSUS

Sur le serveur WSUS :

Va dans Options, puis Computers.
Coche l'option Use Group Policy... et valide

<img width="688" height="768" alt="image" src="https://github.com/user-attachments/assets/74b5f1f9-60f5-47e2-bb13-9d781857804a" />

---

Dans l'arborescence des ordinateurs, sous All Computers, créer 3 groupes avec Add Computer Group :

**PRS-OAD**

<img width="1894" height="487" alt="image" src="https://github.com/user-attachments/assets/65f4a619-640a-4ae7-a78a-0aea1f48cd88" />

---

<img width="1300" height="410" alt="image" src="https://github.com/user-attachments/assets/5b13c11b-2b6d-461f-98fe-1e0688c3e893" />

---

**PRS-OCL**

<img width="1904" height="485" alt="image" src="https://github.com/user-attachments/assets/37b841d0-054d-46dc-ad7f-ebb8272d55e0" />

---


**PRS-OSE**

<img width="1902" height="495" alt="image" src="https://github.com/user-attachments/assets/689ede5b-ea00-47c8-9589-e10f629ed845" />

---


<img width="349" height="165" alt="image" src="https://github.com/user-attachments/assets/2f97ade4-7dc9-45dc-9fae-512b4728b954" />

---

## 3.2 GPO pour les clients de la Comptabilité

Sur ton AD, créer une GPO COMPUTER-WSUS-Clients-Communication
Va dans Computer Configuration--> Policies--> Administrative Templates--> Windows Components--> Windows update
Le paramétrage ci-dessous est commun à toutes les GPO :
Va dans `Specify intranet Microsoft update service location`, qui indiquera où est le serveur de mise à jour.
Coche `Enabled`
Dans les options, pour les 2 premiers champs, mettre l'URL avec le nom du serveur sous sa forme **FQDN**, ajouter le numéro du port 8530
Valide la configuration
Va dans `Do not connect to any Windows Update Internet locations` qui bloque la connexion aux serveurs de Microsoft
Coche `Enabled` et valide la configuration
Le paramétrage ci-dessous est spécifique à cette GPO :
Va dans `Configure Automatic Updates`
Coche `Enabled`
Dans les options mets :
Dans Configure automatic updating sélectionne 4- Auto Download and schedule the install
Dans Scheduled install day mets 0 - Every day
Dans Scheduled install time mets 09:00
Cocher Every week
Cocher Install updates for other Microsoft Products
Aller dans Enable client-side targeting qui fait la liaison avec les groupes crées dans WSUS
Coche Enabled
Dans les options, mettre le nom du groupe WSUS pour les ordinateurs cible, donc COMPTABILITE
Valide la configuration
Aller dans Turn off auto-restart for updates during active hours qui permet d'empêcher les machines de redémarrer après l'installation d'une mise à jour pendant leurs heures d'utilisations
Coche Enabled
Dans les options, mettre (par exemple) 8 AM - 6 PM

