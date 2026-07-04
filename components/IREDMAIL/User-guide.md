# Guide d'Exploitation et d'Utilisation de la Messagerie

Ce guide explique comment administrer les comptes de messagerie, accéder aux boîtes aux lettres via l'interface web, et configurer le client lourd Thunderbird.

---

## 1. Gestion des Domaines et des Comptes Utilisateurs

L'administration s'effectue depuis n'importe quel poste client (Windows ou Ubuntu) ayant accès au réseau `172.16.64.0/24`.

1. Ouvrir un navigateur web et se connecter sur l'interface d'administration : `https://mail.xtech.green/iredadmin`
2. S'authentifier avec le compte `postmaster@xtech.green` et le mot de passe configuré à l'installation.

<img width="789" height="440" alt="image" src="https://github.com/user-attachments/assets/f5748549-6084-4bba-9379-67072953a13d" />

---

### 1.1. Créer un compte utilisateur
1. Naviguer vers le menu supérieur, cliquer sur le bouton **Add** puis sélectionner **User**.

<img width="1555" height="716" alt="Capture d&#39;écran 2026-07-05 001520" src="https://github.com/user-attachments/assets/5242fa89-f546-472d-8635-1ef7a732978b" />

---

3. Renseigner les informations du compte :
   * **Email :** `isaidi@xtech.green`
   * **Password :** Définir un mot de passe robuste (minimum 8 caractères, majuscules, minuscules, chiffres et caractères spéciaux).
   * **Name :** `Ismail Saidi`
   * **Quota :** Indiquer `1024` (soit une limite de 1 Go).
   * **Active :** Cocher la case pour activer immédiatement le compte.
4. Cliquer sur **Add** pour valider la création.

<img width="1539" height="572" alt="image" src="https://github.com/user-attachments/assets/daceed5f-c6bc-40b0-9c08-9e8c77922651" />

---

### 1.2. Créer une liste de diffusion (Optionnel)
1. Dans le menu de gauche, cliquer sur **Mailing List**, puis sur **Add**.
2. Configurer les paramètres :
   * **Address :** `equipe-support@xtech.green`
   * **Name :** `Équipe de communication`
   * **Active :** Cocher la case.
3. Cliquer sur **Add**.

### 1.3. Créer un alias (Optionnel)
1. Dans le menu de gauche, cliquer sur **Alias**, puis sur **Add**.
2. Renseigner l'adresse de redirection :
   * **Address :** `info@xtech.green`
   * **Forwarding To :** `isaidi@xtech.green`
3. Cliquer sur **Add**.

---

## 2. Accès à la Messagerie via le Webmail

Pour les utilisateurs ne disposant pas de client lourd, l'accès se fait directement via Roundcube.

1. Se rendre sur l'URL de messagerie : `https://mail.xtech.green/mail`
2. Saisir l'adresse email complète (ex: `isaidi@xtech.green`) et le mot de passe associé.

<img width="824" height="772" alt="image" src="https://github.com/user-attachments/assets/2c6d97a6-23de-41df-ab9c-bf8d495a126c" />

---


## 3. Configuration de l'Agent de Messagerie Thunderbird

Pour connecter un client lourd Thunderbird, suivre la procédure de configuration manuelle ci-dessous.

1. Lancer **Thunderbird** sur le poste client.

<img width="1914" height="1125" alt="image" src="https://github.com/user-attachments/assets/b6fbe094-8217-41aa-ab37-8a55cb9d0a1e" />

---

3. Sélectionner **Carnet d'adresse** et **Ajouter un carnet d'adresse** :

<img width="1906" height="356" alt="image" src="https://github.com/user-attachments/assets/68b70d21-12e6-481e-91c8-54384aed74cd" />

---


<img width="1200" height="898" alt="Capture d&#39;écran 2026-07-05 002228" src="https://github.com/user-attachments/assets/c7273932-962e-4122-b824-739c2497d993" />

---

<img width="1198" height="895" alt="Capture d&#39;écran 2026-07-05 002959" src="https://github.com/user-attachments/assets/a48442c9-618a-4c65-9603-ad6504d23111" />

---

<img width="625" height="474" alt="Capture d&#39;écran 2026-07-05 003401" src="https://github.com/user-attachments/assets/5e33ce18-a1e5-4c58-9c68-7aca8399ee77" />

---

<img width="626" height="472" alt="Capture d&#39;écran 2026-07-05 003520" src="https://github.com/user-attachments/assets/209ac326-7a06-4517-9ac1-75b807de48d6" />


---

<img width="1915" height="1072" alt="image" src="https://github.com/user-attachments/assets/ce05bb51-9702-46cd-9a4d-70ab6c227401" />


---

| Paramètre | Configuration Serveur Entrant (IMAP) | Configuration Serveur Sortant (SMTP) |
| :--- | :--- | :--- |
| **Nom d'hôte** | `mail.xtech.green` | `mail.xtech.green` |
| **Port** | `143` | `587` |
| **Sécurité de la connexion** | `STARTTLS` ou `SSL/TLS` | `STARTTLS` ou `SSL/TLS` |
| **Méthode d'authentification**| `Mot de passe normal` | `Mot de passe normal` |


4. Cliquer sur **Terminer**. Accepter l'exception de sécurité si le certificat SSL généré par iRedMail est auto-signé.
5. Procéder à un test croisé d'envoi et de réception entre deux boîtes aux lettres pour valider le bon fonctionnement de l'infrastructure.
