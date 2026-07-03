# 1 Guide d'utilisation WSUS

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

## 3.2 GPO pour les clients de la Communication

Sur ton AD, créer une GPO **COMPUTER-WSUS-Clients-Communication**   
Va dans Computer Configuration--> Policies--> Administrative Templates--> Windows Components--> Windows update    
Le paramétrage ci-dessous est commun à toutes les GPO :    
Va dans `Specify intranet Microsoft update service location`, qui indiquera où est le serveur de mise à jour.   
Coche `Enabled`   

<img width="1885" height="985" alt="GPO-1" src="https://github.com/user-attachments/assets/e8346835-7fcc-49d0-bb9a-9897faf76660" />

---

Dans les options, pour les 2 premiers champs, mettre l'URL avec le nom du serveur sous sa forme **FQDN**, ajouter le numéro du port 8530    
Valide la configuration    

<img width="1027" height="949" alt="GPO-PATH-corrige" src="https://github.com/user-attachments/assets/1fdaefe3-3c2e-4334-87f9-2489a9685a46" />

---

<img width="1891" height="416" alt="resultat-final" src="https://github.com/user-attachments/assets/96a57cb4-0d3d-48ff-9e34-11aa47b5cf25" />

---

Va dans `Do not connect to any Windows Update Internet locations` qui bloque la connexion aux serveurs de Microsoft    
Coche `Enabled` et valide la configuration    


<img width="1025" height="954" alt="GPO-2" src="https://github.com/user-attachments/assets/c6fffbdb-c0dd-4e35-8874-ed6733729a39" />

---

Le paramétrage ci-dessous est spécifique à cette GPO :    
Va dans `Configure Automatic Updates`    
Coche `Enabled`     
Dans les options mets :     
Dans `Configure automatic updating` sélectionne `4- Auto Download and schedule the install`         
Dans `Scheduled install day` mets `0 - Every day`     
Dans `Scheduled install time` mets `09:00`              
Cocher `Every week`           
Cocher `Install updates for other Microsoft Products`   

<img width="1909" height="1136" alt="GPO-3" src="https://github.com/user-attachments/assets/f67b39b4-0f04-471b-8615-16bfa8bce3d5" />

---

Aller dans `Enable client-side targeting` qui fait la liaison avec les groupes crées dans WSUS      
Coche `Enabled`          
Dans les options, mettre le nom du groupe WSUS pour les ordinateurs cible, donc **COMMUNICATION**     
Valide la configuration     

Aller dans `Turn off auto-restart for updates during active hours` qui permet d'empêcher les machines de redémarrer après l'installation d'une mise à jour pendant leurs      heures d'utilisations      
Coche `Enabled`     
Dans les options, mettre (par exemple) `8 AM - 6 PM`       

<img width="1022" height="951" alt="GPO-5" src="https://github.com/user-attachments/assets/d36d9da0-777c-42c5-8d69-34f85a7a6cb0" />

---

   
## 3.4 GPO pour les serveurs (non-DC)    


Fais cette GPO si tu as une VM serveur.    

Copie la GPO client et renomme là en **COMPUTER-WSUS-Serveurs**    
Ne touche pas à la partie commune et modifie uniquement la partie spécifique à cette GPO :    
Va dans `Configure Automatic Updates`       
Dans les options mets :    
Dans `Configure automatic updating` sélectionne `7- Auto Download, Notify to restart`          
Dans `Scheduled install day` mets `0 - Every day`            
Dans `Scheduled install time` mets `09:00`         
Cocher `Every week`     
Ne pas cocher `Install updates for other Microsoft Products`         
Aller dans `Enable client-side targeting` qui fait la liaison avec les groupes crées dans WSUS     
Coche `Enabled`    
Dans les options, mettre le nom du groupe WSUS pour les ordinateurs cible, dont ici les serveurs    
Valide la configuration    


## 3.5 GPO pour les DC

Fais cette GPO si tu as une VM DC.

Copie la GPO serveur et renomme là en **COMPUTER-WSUS-DC**
Ne touche pas à la partie commune et modifie uniquement la partie spécifique à cette GPO :
Aller dans `Enable client-side targeting` qui fait la liaison avec les groupes crées dans WSUS
Coche `Enabled`
Dans les options, mettre le nom du groupe WSUS pour les ordinateurs cible, dont ici les contrôleurs de domaine
Valide la configuration
Une fois les GPO crées et configurées, lie les aux OU dans lesquelles sont tes machines clientes

Sur chaque client, exécuter la commande avec le compte administrateur local `gpupdate /force`.
On peut vérifier si les GPO sont appliquée avec la commande `gpresult /R` ou avec la commande PowerShell    
`Get-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate' -Name WUServer, WUStatusServer`

# 4 Gestion des mises à jour

Sur le serveur WSUS, va dans la partie **Updates** et sélectionne **Security Updates**.     
Sélectionne des mises à jour et ouvre le menu d'approbation avec le bouton droit de la souris.     
Tu vas retrouver les groupes que tu as créer sous l'arborescence **All Computers**.    
Tu peux pour chacun des groupes appliquer les différentes mises à jour ou bien les bloquer.
