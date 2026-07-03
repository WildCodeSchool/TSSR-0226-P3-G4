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
**2. Dans l'arborescence de gauche, fais un clic droit sur Deployment Shares et sélectionne New Deployment Share.**
**3. Spécifie le chemin du partage de déploiement (par défaut,C:\Deployment Share). Il est recommandé d'utiliser un disque différent de celui du système. Clique ensuite sur Suivant.**
**4. Laisse le nom du partage par défaut (DeploymentShare$) ou modifie-le selon tes préférences.**
**5. Entre une description pour le partage (facultatif).**
**6. Laisse les options par défaut pour les paramètres restants.**
**7. Clique sur Suivant, puis sur Terminer pour créer le partage de déploiement.**

```
Si tu ne disposes pas d'un second disque dur, tu peux utiliser le disque système C:\
```

---

