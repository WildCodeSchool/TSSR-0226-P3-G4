# Guide d'Installation et d'Utilisation de WSUS

Ce guide détaille la mise en œuvre de WSUS sur le serveur `XTSE-419` ainsi que l'interconnexion avec les machines du domaine Active Directory.

---

## 1. Installation et Configuration de WSUS

### 1.1 Création de la partition de stockage
Pour éviter la saturation du disque système `C:\`, les mises à jour doivent être stockées sur un volume dédié.
1. Ouvrez la **Gestion des disques** (`diskmgmt.msc`).
2. Initialisez et formatez l'espace non alloué de **90 Go**.
3. Nommez le nouveau volume **`WSUS`**.

<img width="1333" height="1005" alt="image" src="https://github.com/user-attachments/assets/9127c5ad-cc74-46b6-8847-1d2a902efba6" />

---

5. À la racine de ce nouveau lecteur, créez un dossier nommé **`WSUS`**.

<img width="977" height="342" alt="image" src="https://github.com/user-attachments/assets/423ff9d7-8c8a-4c7f-bad9-c69a40191d15" />

---

### 1.2 Installation du rôle WSUS
1. Ouvrez le **Gestionnaire de serveur** (Server Manager) et cliquez sur **Ajouter des rôles et fonctionnalités**.
2. Avancez jusqu'à la page *Rôles de serveurs* et cochez **Windows Server Update Services**. Validez l'ajout des fonctionnalités requises.
3. À l'étape des services de rôle, laissez coché par défaut :
   * **WID Connectivity** (Base de données interne)
   * **WSUS Service**
4. Sur la page *Emplacement du contenu*, spécifiez le chemin du dossier créé à l'étape précédente (ex: `D:\WSUS` ou `E:\WSUS` selon la lettre attribuée à votre partition de 20 Go).
5. Finalisez l'installation puis **redémarrez le serveur**.

---

## 2. Configuration du service WSUS

Après le redémarrage, ouvrez le Gestionnaire de serveur pour effectuer les tâches post-déploiement.

### 2.1 Assistant de configuration initiale
1. Cliquez sur le drapeau des notifications jaunes et lancez **Post Deployment Configuration for WSUS**.
2. Une fois terminé, ouvrez la console d'administration WSUS, faites un clic droit sur le nom du serveur et lancez l'**Assistant de configuration**.
3. Suivez les étapes de l'assistant selon la politique suivante :
   * **Amélioration Microsoft :** Décochez la case `Yes, I would like to join the Microsoft Update Improvement Program`.
   * **Serveur amont :** Laissez activé `Synchronize from Microsoft Update`.
   * **Proxy :** Ne configurez pas de serveur proxy (sauf spécificité réseau).
   * **Connexion :** Cliquez sur **Start Connecting** (cette étape prend entre 10 et 20 minutes pour récupérer le catalogue Microsoft).
   * **Langues :** Sélectionnez uniquement `English` et `French`.
   * **Produits :** Sélectionnez les produits présents dans votre parc (ex: *Windows 11*, *Windows Server 2022*).
   * **Classifications :** Laissez les choix par défaut (Mises à jour de sécurité, critiques, etc.).
   * **Planification :** Configurez **4 synchronisations par jour**, débutant à **02:00**.
   * **Initialisation :** Cochez `Begin initial synchronization` puis cliquez sur **Finish**.

> **Suivi :** Vous pouvez suivre la progression de la première synchronisation sur la page d'accueil de la console WSUS à l'aide du widget **Synchronization Status**.

### 2.2 Approbations Automatiques (Règles de base)
1. Dans la console WSUS, allez dans **Options** > **Automatic Approvals**.
2. Dans l'onglet *Update Rules*, cochez la règle **Default Automatic Approval Rule**.
3. Cliquez sur **Run Rules**, puis appliquez les modifications avec **Apply** et **OK**.
   *(Par défaut, cette règle approuve automatiquement les mises à jour Critiques et de Sécurité pour l'ensemble du parc).*

---

## 3. Liaison avec les ordinateurs du domaine

### 3.1 Configuration du ciblage côté WSUS
1. Dans la console WSUS, allez dans **Options** > **Computers**.
2. Cochez l'option **Use Group Policy or registry settings on computers** (indique que les machines rejoindront leurs groupes via GPO) et validez.
3. Dans l'arborescence, faites un clic droit sur **All Computers** > **Add Computer Group** et créez les 3 sous-groupes stratégiques suivants :
   * **PRS-OAD** (Contrôleurs de domaine)
   * **PRS-OCL** (Postes clients)
   * **PRS-OSE** (Serveurs membres)

---

### 3.2 Configuration des Stratégies de Groupe (GPO)
Depuis votre contrôleur de domaine Active Directory (`Gestion des stratégies de groupe`), créez les GPO suivantes.

#### Paramètres communs (À appliquer sur TOUTES les GPO WSUS)
Chemin d'accès : `Configuration ordinateur` > `Stratégies` > `Modèles d'administration` > `Composants Windows` > `Windows Update`

* **Specify intranet Microsoft update service location :**
  * Statut : **Actif** (Enabled)
  * Service de mise à jour / Serveur de statistiques : Spécifiez l'URL FQDN de votre serveur WSUS sur le port `8530`. 
    *Exemple : `http://xtse-419.votredomaine.local:8530`*
* **Do not connect to any Windows Update Internet locations :**
  * Statut : **Actif** (Enabled) *(Bloque l'accès aux serveurs externes de Microsoft).*

---

#### 1️GPO Spécifique : `COMPUTER-WSUS-Clients-Communication`
*(À lier à l'Unité Organisationnelle contenant vos postes clients)*

* **Configure Automatic Updates :**
  * Statut : **Actif** (Enabled)
  * Option de configuration : `4 - Auto Download and schedule the install`
  * Planification : `0 - Every day` à **09:00**, récurrence `Every week`.
  * Options complémentaires : Cochez `Install updates for other Microsoft Products`.
* **Enable client-side targeting :**
  * Statut : **Actif** (Enabled)
  * Target group name : **COMMUNICATION** (ou le nom exact du groupe cible défini dans votre arborescence).
* **Turn off auto-restart for updates during active hours :**
  * Statut : **Actif** (Enabled)
  * Heures d'activité : **8 AM - 6 PM** *(Empêche le redémarrage intempestif pendant les heures de travail).*

---

#### 2️GPO Spécifique : `COMPUTER-WSUS-Serveurs`
*(À copier depuis la GPO Client, puis modifier la partie spécifique pour vos serveurs membres)*

* **Configure Automatic Updates :**
  * Statut : **Actif** (Enabled)
  * Option de configuration : `7 - Auto Download, Notify to restart` *(Téléchargement automatique mais redémarrage manuel obligatoire pour préserver la production).*
  * Planification : `0 - Every day` à **09:00**, récurrence `Every week`.
  * Options complémentaires : **Ne pas cocher** *Install updates for other Microsoft Products*.
* **Enable client-side targeting :**
  * Statut : **Actif** (Enabled)
  * Target group name : Indiquez le nom de votre groupe WSUS dédié aux serveurs (ex: `PRS-OSE`).

---

#### 3️GPO Spécifique : `COMPUTER-WSUS-DC`
*(À copier depuis la GPO Serveur, à lier à l'OU des Contrôleurs de Domaine)*

* **Enable client-side targeting :**
  * Statut : **Actif** (Enabled)
  * Target group name : Indiquez le nom de votre groupe WSUS dédié aux contrôleurs de domaine (ex: `PRS-OAD`).

---

### 3.3 Validation et déploiement côté client
Une fois les GPO liées aux Unités Organisationnelles (OU) correspondantes, forcez leur application sur les machines cibles :

1. Ouvrez une invite de commande en tant qu'administrateur sur le poste client et exécutez :
   ```cmd
   gpupdate /force
