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

<img width="1085" height="902" alt="image" src="https://github.com/user-attachments/assets/3ef4c11a-ebeb-4a0a-8955-c6d702aceeaf" />

---

**5. Fais un clic droit sur le dossier Windows 11 et sélectionne Import Operating System.** 

<img width="926" height="395" alt="Capture d&#39;écran 2026-07-03 232814" src="https://github.com/user-attachments/assets/4796ca76-976a-40a4-bc7b-1f064e6261f1" />

---

**6. Sélectionne Full set of source files et clique sur Suivant.**   

<img width="1086" height="901" alt="image" src="https://github.com/user-attachments/assets/e57a3bc0-d762-4774-a500-8a1ff96b1264" />

---

**7. Spécifie le chemin vers les fichiers source de Windows 11 (le lecteur où tu as monté l'ISO E:\ par exemple).**   

<img width="471" height="479" alt="image" src="https://github.com/user-attachments/assets/e251bebb-1137-4df4-8f8b-90e74bf32b65" />

---

**8. Pour le nom du répertoire de destination, saisis Windows 11 Pro.**   
**9. Clique sur Suivant puis sur Terminer.**

L’importation peut prendre plusieurs minutes. Une fois terminée, tu peux supprimer toutes les éditions de Windows 11 sauf la version Pro : il te suffit de sélectionner une ou plusieurs images non désirées dans la console, puis de cliquer sur Supprimer.   

<img width="1026" height="766" alt="image" src="https://github.com/user-attachments/assets/51a731e1-03a1-41c8-b25f-499f2a6a715c" />

---

## Ajout d'applications dans MDT

### Organisation des sources d'applications


**1. Crée un dossier C:\MDT_Applications sur ton serveur.**    
**2. Dans ce dossier, crée un sous-dossier pour chaque application :     C:\MDT_Applications\Firefox**   
**3. Télécharger Firefox dans sa version .msi, rends-toi sur la page officielle dédiée aux entreprises :**   **[Télécharger Firefox](https://www.mozilla.org/fr/firefox/enterprise/#download)**    
**4. Clique ensuite sur « Téléchargements pour les Entreprises » et choisis l’installer MSI.**    

<img width="906" height="812" alt="image" src="https://github.com/user-attachments/assets/f1c70c15-e8b0-493b-8223-5a670807848e" />


---

**5. 5.Copie le fichier d'installation dans le dossier C:\MDT_Applications\Firefox**

---

```
Les fichiers d'installation doivent impérativement être au format .msi (Microsoft Software Installer) et non .exe. La plupart des logiciels utilisés en environnement professionnel proposent une version .msi adaptée au déploiement automatisé.
```

---

## Ajout de Firefox dans MDT


**1. Dans la console MDT, développe ton partage de déploiement.**
**2. Fais un clic droit sur Applications et sélectionne New Folder.**
**3. Nomme le dossier Navigateurs et clique sur Suivant puis Terminer.**
**4. Fais un clic droit sur le dossier Navigateurs et sélectionne New Application.**
**5. Sélectionne Application with source files et clique sur Suivant.**
**6. Remplis les informations suivantes :**
**Éditeur : Mozilla**
**Nom de l'application : Mozilla Firefox**
**Version : (version actuelle, par exemple 138.0.4)**
**Langue : Français**
**7. Clique sur Suivant.**
**8. Spécifie le chemin source : C:\MDT_Applications\Firefox.**
**9. Pour le répertoire de destination, conserve la valeur par défaut.**
**10. Si tu renommes le fichier MSI en quelque chose de plus générique comme Firefox.msi, tu peux simplement saisir Firefox.msi /quiet.

---

```
Assure-toi que le nom du fichier MSI dans la ligne de commande correspond exactement au nom du fichier présent dans le dossier source, sinon l’installation échouera.
```

---

**11. Clique sur Suivant puis sur Terminer.**

Pour chaque application, note son GUID qui apparaît dans ses propriétés (clic droit > Propriétés). Tu en auras besoin plus tard pour la configuration.


<img width="1021" height="727" alt="image" src="https://github.com/user-attachments/assets/717e0b5b-2750-443f-b436-dfd742875f93" />

---

## Alerte

```
Avant de commencer cette étape, crée deux dossiers dans le répertoire de MDT afin d’éviter une erreur sur la page des propriétés :

**1. Accède au chemin suivant :
C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\**
**2. Dans le dossier Windows Preinstallation Environment, crée un nouveau dossier nommé x86.**
**3. À l’intérieur du dossier x86, crée un dossier supplémentaire nommé WinPE_OCs.**
**4. Vérifie que tu obtiens bien l’arborescence suivante :
C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\x86\WinPE_OCs**
```

---

## Création d'une séquence de tâches


**1. Dans la console MDT, développe ton partage de déploiement.**
**2. Fais un clic droit sur Task Sequences et sélectionne New Folder.**

<img width="428" height="470" alt="image" src="https://github.com/user-attachments/assets/f0f3e1c7-351f-4560-a213-5572f3eca319" />

---

**3. Nomme le dossier Windows 11 et clique sur Suivant puis Terminer.**

<img width="1087" height="907" alt="image" src="https://github.com/user-attachments/assets/9001139e-0b55-42d6-9a55-7434a188df14" />

---

**4. Fais un clic droit sur le dossier Windows 11 et sélectionne New Task Sequence.**

<img width="1113" height="394" alt="image" src="https://github.com/user-attachments/assets/e5b13d73-40cc-4672-821d-053c62bcc042" />

---

**5. Remplis les informations suivantes :**
**Task sequence ID : W11-STANDARD**
**Task sequence name : Windows 11 Pro Déploiement Standard**
**Commentaires : Déploiement standard de Windows 11 Pro**
**6. Clique sur Suivant.**

<img width="1086" height="905" alt="image" src="https://github.com/user-attachments/assets/5993dbae-0b8e-4915-8f60-673d43f8ea7a" />

---

**7. Sélectionne le modèle Standard Client Task Sequence.**
**8. Clique sur Suivant.**
**9. Sélectionne l'image Windows 11 que tu as importée.**
**10. Clique sur Suivant.**
**11. Saisis les informations suivantes :**
**Full Name : Wilder**
**Organization : WCS**
**Internet Explorer home page : laisse vide**
**12. Clique sur Suivant.**
**13. Saisis le clé de produit Windows ou coche Do not specify a product key at this time.**
**14. Clique sur Suivant.**
**15. Saisis un mot de passe administrateur local (pour la machine Windows 11 déployée)**
**16. Clique sur Suivant puis sur Terminer.**

---






