# Foire Aux Questions (FAQ) & Résolution des Problèmes

Ce document recense les anomalies courantes rencontrées lors de l'installation, de la configuration ou de l'exécution de la plateforme WDS / MDT, ainsi que leurs correctifs respectifs.

---

## 1. Réseau & Connectivité PXE

### Problème : Mon serveur WDS bascule avec une adresse IP en 169.254.x.x (APIPA) et l'interface affiche "(Duplicate)"

<img width="968" height="657" alt="image" src="https://github.com/user-attachments/assets/023765f9-4026-408c-918f-5084217bc7ce" />

---

* **Cause :** Un conflit d'adresse IP s'est produit. Une autre machine sur le réseau (serveur, imprimante, etc.) utilise déjà l'adresse `172.16.64.54`. Par sécurité, Windows désactive votre IP fixe pour éviter de perturber le réseau et s'attribue une adresse de secours APIPA.
* **Résolution :** 1. Libérez l'adresse IP sur l'appareil intrus ou attribuez une nouvelle adresse IP fixe libre à votre serveur `XTSE-420` (ex: `172.16.64.20`).
    2. Modifiez la configuration réseau dans Windows Server et redémarrez le service WDS via PowerShell :
       ```powershell
       Restart-Service -Name WDSServer
       ```

  <img width="946" height="329" alt="image" src="https://github.com/user-attachments/assets/8e781b35-b0c1-4a5d-8946-45a7a6d53ff8" />

  ---

### Problème : Une erreur de syntaxe ou d'initialisation apparaît lors de la configuration du serveur WDS en mode autonome
* **Cause :** L'interface réseau du serveur n'a pas les liaisons de partage Microsoft activées.
* **Résolution :** Accédez aux propriétés de votre carte réseau Windows, localisez et cochez la case **"Partage de fichiers et d'imprimantes pour les réseaux Microsoft"** (*File and Printer Sharing for Microsoft Networks*), puis relancez l'assistant.

---

## 2. Déploiement & Erreurs Microsoft Deployment Toolkit (MDT)

### Problème : Erreur lors de l'ouverture ou de la configuration des propriétés du Partage de Déploiement (Erreur de composants WinPE manquants)
* **Cause :** L'ADK Windows 11 moderne ne contient plus l'arborescence native pour les composants optionnels d'architecture 32-bits (x86), ce qui bloque l'affichage de l'assistant MDT.
* **Résolution :** Vous devez créer manuellement les dossiers vides requis par l'assistant à l'emplacement suivant :
    1. Allez vers : `C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\`
    2. Créez un dossier nommé `x86`.
 
  <img width="1421" height="401" alt="image" src="https://github.com/user-attachments/assets/153cce21-89f7-4c1a-b6ad-26c7b4923e2d" />

  ---

    4. Entrez dans ce dossier et créez un sous-dossier nommé `WinPE_OCs`.

  <img width="1416" height="309" alt="image" src="https://github.com/user-attachments/assets/ef0f7291-5667-4fd0-8884-46fe229e60db" />

  ---
  
    *Structure attendue :* `...\Windows Preinstallation Environment\x86\WinPE_OCs`

### Problème : L'installation de mon application (ex: Firefox) échoue systématiquement pendant la séquence de tâches WinPE
* **Causes possibles :**
    * Vous avez utilisé un fichier exécutable `.exe` au lieu d'un installeur Windows Installer `.msi`.
 
  <img width="600" height="809" alt="Capture d&#39;écran 2026-07-04 001539" src="https://github.com/user-attachments/assets/d25a2a06-aca1-47c5-a43e-7127b699ba74" />

  ---
  
    * Le nom du fichier spécifié dans la ligne de commande MDT ne correspond pas exactement au fichier présent dans le dossier source.
* **Résolution :** Téléchargez impérativement la version **MSI Entreprise** du logiciel. Dans les propriétés de l'application sur MDT, assurez-vous que la commande silencieuse est exacte (ex: `Firefox.msi /quiet`).

---

## 3. Intégration DHCP / Coexistence

### Question : Dois-je cocher les cases Proxy DHCP lors de la configuration WDS ?
* **Réponse :** **Non.** Dans notre architecture, le service DHCP est hébergé sur le serveur Active Directory (AD DS) et non sur le serveur WDS. Lors de la configuration des options DHCP dans l'onglet WDS, veillez à **décocher** les deux options afin de laisser le serveur DHCP de l'AD gérer l'attribution des adresses et les requêtes PXE proprement sans interférence.

---

## Liens Utiles
* Revenir à l'accueil : **[README.md](README.md)**
* Consulter les étapes WDS : **[Install-WDS.md](Install-WDS.md)**
* Consulter les étapes MDT : **[Install-MDT.md](Install-MDT.md)**
