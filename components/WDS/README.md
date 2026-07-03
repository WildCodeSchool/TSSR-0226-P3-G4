# Plateforme de Déploiement Automatisé : WDS & MDT

Bienvenue dans la documentation technique relative à la mise en place et à la configuration de notre infrastructure de déploiement de postes de travail. Cette solution s'appuie sur le couplage des technologies **Windows Deployment Services (WDS)** et **Microsoft Deployment Toolkit (MDT)** sous Windows Server 2022 pour automatiser le déploiement en masse de **Windows 11 Professionnel**.

---

## Navigation dans la Documentation

Pour faciliter votre parcours ou l'exploitation de la plateforme au quotidien, utilisez les liens ci-dessous :

* **[Guide d'Utilisation (User_guide.md)](User_guide.md)** : Guide pas-à-pas destiné aux techniciens pour lancer un déploiement client via PXE.
* **[Installation de WDS (Install-WDS.md)](Install-WDS.md)** : Procédure détaillée d'installation et d'initialisation du rôle WDS (PowerShell & Graphique).
* **[Installation de MDT (Install-MDT.md)](Install-MDT.md)** : Procédure complète d'installation d'ADK, WinPE, MDT, et configuration des séquences de tâches.
* **[Foire Aux Questions (FAQ.md)](FAQ.md)** : Résolution des erreurs courantes (conflits IP, erreurs de syntaxe d'interface, erreurs d'arborescence WinPE).

---

## Fiche Technique du Serveur Master

L'ensemble de la plateforme est configuré au sein d'une machine virtuelle isolée répondant aux spécifications suivantes :

* **Système d'Exploitation :** Microsoft Windows Server 2022
* **Nom d'Hôte :** `XTSE-420` (ou configuré en tant que `srv-wds`)
* **Configuration Réseau :**
    * IP Fixe : `172.16.64.54`
    * Masque : `255.255.255.0` (/24)
* **Stockage & Volumes :**
    * Disque OS : `32 Go` (Système C:)
    * Disque Données : `80 Go` (Dédié aux partages de déploiement et données WDS)
    * Partitionnement : **GPT**
    * Système de Fichiers : **NTFS**

---

## Résumé Architectural du Flux de Déploiement

1.  **Amorçage PXE :** La machine cible démarre sur le réseau et interroge le serveur DHCP de l'Active Directory.
2.  **Prise en charge WDS :** WDS prend le relais et fournit l'image de démarrage WinPE générée par MDT (`LiteTouchPE_x64.wim`).
3.  **Séquence MDT :** L'environnement WinPE se connecte au partage réseau MDT (`DeploymentShare$`), exécute les règles du fichier `CustomSettings.ini`, puis applique l'image de l'OS personnalisée ainsi que les applications sélectionnées (ex: Mozilla Firefox).

---

## Maintenance & Mises à jour de la Plateforme

Lorsque vous modifiez la configuration des applications ou le fichier `CustomSettings.ini` dans le **Deployment Workbench** :
1.  Faites un clic droit sur votre partage de déploiement > **Update Deployment Share**.
2.  Sélectionnez **Completely regenerate the boot images**.
3.  Une fois l'image régénérée, n'oubliez pas de remplacer l'ancienne image de démarrage dans la console **WDS** par le nouveau fichier situé dans `D:\DeploymentShare\Boot\LiteTouchPE_x64.wim`.
