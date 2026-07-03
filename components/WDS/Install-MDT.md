# Installation MDT

## Installation des prérequis pour MDT

Avant d'installer MDT, nous devons d'abord installer les composants nécessaires à son fonctionnement :   

### Installation de Windows ADK (Assessment and Deployment Kit)**    

**1. Télécharge l'Assistant d'installation de Windows ADK pour Windows 11 depuis le site de Microsoft** :    
**[Télécharger ADK](https://docs.microsoft.com/fr-fr/windows-hardware/get-started/adk-install)**

<img width="1484" height="1000" alt="image" src="https://github.com/user-attachments/assets/1e642a27-aeed-4bdf-a8d7-a00dec9b2d5b" />

---

**2. Exécute le fichier téléchargé sur ton serveur WDS.**
**3. Dans l'assistant d'installation garde toutes les fonctionnalités par défaut.**
**4. Clique sur Installer pour lancer l'installation.**

<img width="1099" height="810" alt="install-adk-01" src="https://github.com/user-attachments/assets/13b971ad-4b62-482e-8217-4b7e1be542d1" />


---

<img width="1096" height="809" alt="install-ads-02" src="https://github.com/user-attachments/assets/8e1aa71a-5e7f-42e8-86c6-0d3e1ee2fd5f" />


---

### Installation de Windows PE (Preinstallation Environment)

**1. Télécharge l'add-on Windows PE pour ADK depuis le même site Microsoft.**

<img width="1484" height="1000" alt="image" src="https://github.com/user-attachments/assets/4eeea3a0-7f03-452c-8d73-0def9c89aeba" />

---

**2. Exécute le fichier téléchargé.**
**3. Dans l'assistant d'installation garde tout par défaut.**
**4. Clique sur Installer pour lancer l'installation.**

---

### Installation de MDT

**1. Télécharge Microsoft Deployment Toolkit (MDT) depuis le site de Microsoft (Choisis la vérsion x64) :
**[Télécharge MDT](https://www.microsoft.com/en-us/download/details.aspx?id=54259)**
**2. Exécute le fichier d'installation sur ton serveur WDS.**
**3. Accepte le contrat de licence.**

<img width="738" height="578" alt="install-mdt-01" src="https://github.com/user-attachments/assets/5685a254-70e2-47b9-bb2d-25ae7d584598" />

---

**4. Choisis l'emplacement d'installation (par défaut : C:\Program Files\Microsoft Deployment Toolkit).**

<img width="735" height="578" alt="install-mdt-02" src="https://github.com/user-attachments/assets/a44db7e1-5858-4645-a4bb-f7441dade89a" />

---

**5. Clique sur Suivant, puis sur Installer.**
**6. Une fois l'installation terminée, clique sur Terminer.**


### Création d'un partage de déploiement MDT

**1. Ouvre la Console Microsoft Deployment Toolkit (Deployment Workbench) depuis le menu Démarrer.**

<img width="1172" height="1018" alt="Capture d&#39;écran 2026-07-03 215504" src="https://github.com/user-attachments/assets/cee8a3c4-2535-4fae-9b50-b985f61d830d" />

---

**2. Dans l'arborescence de gauche, fais un clic droit sur Deployment Shares et sélectionne New Deployment Share.**

<img width="460" height="331" alt="Capture d&#39;écran 2026-07-03 215654" src="https://github.com/user-attachments/assets/971e286e-e502-4c64-ace3-4be82aa0a896" />

---

**3. Spécifie le chemin du partage de déploiement (par défaut,C:\Deployment Share). Il est recommandé d'utiliser un disque différent de celui du système. Clique ensuite sur Suivant.**

<img width="1089" height="906" alt="image" src="https://github.com/user-attachments/assets/37b39343-591b-4bdb-903b-5e8ae8ed1a65" />

---

**4. Laisse le nom du partage par défaut (DeploymentShare$) ou modifie-le selon tes préférences.**

<img width="1083" height="904" alt="image" src="https://github.com/user-attachments/assets/c5042e17-1d76-49ac-9d96-e053892009b2" />

---

**5. Entre une description pour le partage (facultatif).**
**6. Laisse les options par défaut pour les paramètres restants.**
**7. Clique sur Suivant, puis sur Terminer pour créer le partage de déploiement.**

```
Si tu ne disposes pas d'un second disque dur, tu peux utiliser le disque système C:\
```

---

### Import d'une image Windows 11

Sur le serveur SRV-WDS, télécharge l’image ISO de Windows 11 depuis le site de Microsoft :  
**[Télécharge ISO Windows 11 Pro](https://www.microsoft.com/fr-fr/software-download/windows11)**

**1. Monte l'ISO Windows 11 en allant sur Proxmox > Hardware.**   

<img width="656" height="262" alt="image" src="https://github.com/user-attachments/assets/f9eb1578-251c-4a6b-8ede-79a7be96713d" />

---

Clique sur Edit

<img width="1108" height="488" alt="Capture d&#39;écran 2026-07-03 220710" src="https://github.com/user-attachments/assets/b87a9b3f-c001-4d0f-8c0d-3242340cff9f" />

---

Ajoute l'ISO de Windows 11 Pro

<img width="597" height="345" alt="Capture d&#39;écran 2026-07-03 220802" src="https://github.com/user-attachments/assets/7770d0aa-c8ea-4d5e-8e35-cd6ec007cefa" />

---

Cela va créer un nouveau disque avec l'ISO montée prête à être déployer. Le serveur WDS se servira de cette ISO comme MASTER pour le déploiement de masse sur les PC.

<img width="782" height="199" alt="Capture d&#39;écran 2026-07-03 220944" src="https://github.com/user-attachments/assets/2b98a9fc-4783-4b56-89f6-abb6f6071c62" />

---

**2. Dans la console MDT, développe ton partage de déploiement.**   
**3. Fais un clic droit sur Operating Systems et sélectionne New Folder.**   

<img width="541" height="432" alt="Capture d&#39;écran 2026-07-03 221551" src="https://github.com/user-attachments/assets/19506462-2371-4936-b419-e6b886ad9956" />

---

**4. Nomme le dossier Windows 11 et clique sur Suivant puis Terminer.**   
**5. Fais un clic droit sur le dossier Windows 11 et sélectionne Import Operating System.**   
**6. Sélectionne Full set of source files et clique sur Suivant.**   
**7. Spécifie le chemin vers les fichiers source de Windows 11 (le lecteur où tu as monté l'ISO E:\ par exemple).**   
**8. Pour le nom du répertoire de destination, saisis Windows 11 Pro.**   
**9. Clique sur Suivant puis sur Terminer.**

L’importation peut prendre plusieurs minutes. Une fois terminée, tu peux supprimer toutes les éditions de Windows 11 sauf la version Pro : il te suffit de sélectionner une ou plusieurs images non désirées dans la console, puis de cliquer sur Supprimer.   
