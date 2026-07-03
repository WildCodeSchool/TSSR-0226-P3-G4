# FAQ 

## 1. Maintenance et Résolution des Problèmes (Troubleshooting)

### 1.2 Nettoyage périodique du stockage (Disque de 20 Go)
Votre partition dédiée à WSUS fait 20 Go, ce qui est une taille restreinte pour stocker des mises à jour. Il est impératif d'exécuter l'assistant de nettoyage au moins une fois par mois pour éviter la saturation du disque.

Dans la console WSUS, allez tout en bas dans Options.

Cliquez sur Server Cleanup Wizard (Assistant de nettoyage du serveur).

Cochez toutes les cases (Mises à jour obsolètes, fichiers temporaires, ordinateurs inactifs).

Cliquez sur Next et laissez l'assistant libérer de l'espace sur votre lecteur C:\WSUS.

<img width="1105" height="818" alt="image" src="https://github.com/user-attachments/assets/4a192f19-8815-4fed-8c2c-b400b9888113" />

---

<img width="1109" height="819" alt="image" src="https://github.com/user-attachments/assets/d2c8083f-6e41-45c4-93a1-2b2f0490a0c9" />

---

<img width="1108" height="812" alt="image" src="https://github.com/user-attachments/assets/1a83a01c-168b-4121-8049-98944517db5a" />


---


### 2 Forcer un client à remonter immédiatement dans WSUS
Si un ordinateur du domaine n'apparaît pas dans la console graphique de WSUS après l'application de la GPO, exécutez ces commandes dans une invite de commande (CMD en tant qu'administrateur) sur le poste client :

```
:: 1. Force l'application des stratégies de groupe
gpupdate /force

:: 2. Arrête et relance le service Windows Update pour réinitialiser la file d'attente
net stop wuauserv
net start wuauserv

:: 3. Force le client à contacter immédiatement le serveur WSUS pour s'enregistrer
wuauclt /detectnow
wuauclt /reportnow

:: (Sur Windows 10/11 / Windows Server 2019+) Commande alternative moderne :
usoclient StartScan
```

### 3 Résoudre l'erreur de déconnexion de la console (Connection Error / Crash)
Si la console WSUS affiche une croix rouge Connection Error (souvent liée à une saturation de la mémoire vive), exécutez ces commandes en PowerShell (Administrateur) sur le serveur WSUS pour relancer les composants :

```
# Relancer le service WSUS et le serveur Web (IIS)
Restart-Service -Name "WsusService"
Restart-Service -Name "W3SVC"

# Forcer la réévaluation de la base de données de stockage local
cd "C:\Program Files\Update Services\Tools"
.\wsusutil.exe reset
```
### 3 Espace de disque insuffisant 

Le guide d'installation stipule la création d'une partition de 20 Go dédiée à WSUS. Or, le catalogue que vous venez de synchroniser demande 523,098.35 MB (523 Go) de téléchargements.

<img width="1568" height="566" alt="Capture d&#39;écran 2026-07-03 151232" src="https://github.com/user-attachments/assets/83568514-34cc-4a1a-9be5-7f4b16bcbf13" />

---

Si WSUS détecte qu'il n'a pas assez d'espace disque pour stocker ce qu'on lui demande, il refuse catégoriquement de démarrer le téléchargement (ce qui explique le blocage à 0.00 MB).

### Étape 1 : Refuser (Decline) les mises à jour approuvées par erreur

Il faut dire à WSUS de ne plus essayer de télécharger ces 1 488 fichiers.   

Il faut réduire drastiquement le volume de données demandées en refusant les mises à jour inutiles :    

Dans la console WSUS, allez dans Options > Products and Classifications.     

Dans l'onglet Products, décochez absolument tout ce dont vous n'avez pas besoin immédiatement (par exemple, décochez les anciennes versions de Windows, conservez uniquement Windows 11 ou la version exacte de votre serveur).   

<img width="689" height="769" alt="Capture d&#39;écran 2026-07-03 151957" src="https://github.com/user-attachments/assets/0dfd65d2-c2d2-434d-8e6e-b26d62a60630" />

---

<img width="611" height="401" alt="Capture d&#39;écran 2026-07-03 152022" src="https://github.com/user-attachments/assets/b2afe374-4fe2-45a2-90d4-a6226670e674" />


---

<img width="616" height="396" alt="Capture d&#39;écran 2026-07-03 152042" src="https://github.com/user-attachments/assets/28165be0-99d2-4b48-ae15-49209ce6a4bb" />


---

<img width="614" height="390" alt="Capture d&#39;écran 2026-07-03 152056" src="https://github.com/user-attachments/assets/efda2e9b-3471-441e-8d20-6b5b33969d5e" />

---

Allez dans Updates > All Updates, passez le filtre sur Approval: Approved et Status: Any.    


Vous allez voir la liste des mises à jour qui saturent votre file d'attente. Cliquez sur l'une d'elles, puis faites CTRL + A pour toutes les sélectionner d'un coup.     

Faites un clic droit sur la sélection et cliquez sur Decline (Refuser).    

Confirmez par "Oui".   

Le compteur "Approved updates" sur votre page d'accueil va retomber à 0, et la file d'attente des 523 Go va complètement s'effacer.     

<img width="1567" height="883" alt="image" src="https://github.com/user-attachments/assets/20c0d749-b8e9-4fc9-9b27-392c41945b2a" />


---

<img width="612" height="293" alt="image" src="https://github.com/user-attachments/assets/1b443299-7f7b-4060-83fe-1a96add41b48" />

---

### Étape 2 : Lancer le nettoyeur pour vider la file d'attente BITS 

Maintenant qu'elles sont refusées, il faut purger la base de données.

Allez dans Options tout en bas à gauche de la console WSUS.

Cliquez sur Server Cleanup Wizard (Assistant de nettoyage du serveur).

Laissez toutes les cases cochées et cliquez sur Next (Suivant).

Laissez l'assistant travailler (il va supprimer les fichiers temporaires des mises à jour que vous venez de refuser).

<img width="1105" height="818" alt="Capture d&#39;écran 2026-07-03 151400" src="https://github.com/user-attachments/assets/76f9461d-5110-4f33-903f-625d21b34c0d" />

---

<img width="1197" height="691" alt="image" src="https://github.com/user-attachments/assets/3a101d59-67d8-4aab-b7f7-a0362dbfa086" />

---

### Étape 3 :Afficher et Refuser les mises à jour approuvées

Dans votre console, cliquez sur All Updates (Toutes les mises à jour).

Modifiez le premier filtre tout en haut à gauche : remplacez Unapproved par Approved.

Laissez le deuxième filtre sur Any.

Cliquez sur le bouton Refresh à droite.

La liste va maintenant se remplir avec les 1 488 mises à jour qui tentent de se télécharger.

Cliquez sur n'importe quelle ligne de la liste, puis faites CTRL + A sur votre clavier pour toutes les sélectionner d'un coup.

Faites un clic droit sur la sélection bleue, puis cliquez sur Decline (Refuser).

Validez le message de confirmation.


<img width="1527" height="941" alt="image" src="https://github.com/user-attachments/assets/dfe60905-be07-4807-b890-cb1d3b82aa7e" />

---

<img width="1203" height="691" alt="image" src="https://github.com/user-attachments/assets/71c3188b-7da1-4ef9-aa12-15f2aa7d3de4" />

---

Bravo, Le compteur est retombé à 0 MB !

<img width="1185" height="743" alt="image" src="https://github.com/user-attachments/assets/d9860848-f7ba-41a7-ad80-866df11760b6" />

---


