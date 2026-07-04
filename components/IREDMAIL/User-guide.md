# Guide d'Exploitation et d'Utilisation de la Messagerie

Ce guide explique comment administrer les comptes de messagerie, accéder aux boîtes aux lettres via l'interface web, et configurer le client lourd Thunderbird.

---

## 1. Gestion des Domaines et des Comptes Utilisateurs

L'administration s'effectue depuis n'importe quel poste client (Windows ou Ubuntu) ayant accès au réseau `172.20.0.0/24`.

1. Ouvrir un navigateur web et se connecter sur l'interface d'administration : `https://mail.tssr.lab/iredadmin`
2. S'authentifier avec le compte `postmaster@tssr.lab` et le mot de passe configuré à l'installation.

### 1.1. Créer un compte utilisateur
1. Naviguer vers le menu supérieur, cliquer sur le bouton **Add** puis sélectionner **User**.
2. Renseigner les informations du compte :
   * **Email :** `utilisateur1@tssr.lab`
   * **Password :** Définir un mot de passe robuste (minimum 8 caractères, majuscules, minuscules, chiffres et caractères spéciaux).
   * **Name :** `Utilisateur Un`
   * **Quota :** Indiquer `1024` (soit une limite de 1 Go).
   * **Active :** Cocher la case pour activer immédiatement le compte.
3. Cliquer sur **Add** pour valider la création.

### 1.2. Créer une liste de diffusion (Optionnel)
1. Dans le menu de gauche, cliquer sur **Mailing List**, puis sur **Add**.
2. Configurer les paramètres :
   * **Address :** `equipe-support@tssr.lab`
   * **Name :** `Équipe de vente`
   * **Active :** Cocher la case.
3. Cliquer sur **Add**.

### 1.3. Créer un alias (Optionnel)
1. Dans le menu de gauche, cliquer sur **Alias**, puis sur **Add**.
2. Renseigner l'adresse de redirection :
   * **Address :** `info@tssr.lab`
   * **Forwarding To :** `utilisateur1@tssr.lab`
3. Cliquer sur **Add**.

---

## 2. Accès à la Messagerie via le Webmail

Pour les utilisateurs ne disposant pas de client lourd, l'accès se fait directement via Roundcube.

1. Se rendre sur l'URL de messagerie : `https://mail.tssr.lab/mail`
2. Saisir l'adresse email complète (ex: `utilisateur1@tssr.lab`) et le mot de passe associé.

---

## 3. Configuration de l'Agent de Messagerie Thunderbird

Pour connecter un client lourd Thunderbird, suivre la procédure de configuration manuelle ci-dessous.

1. Lancer **Thunderbird** sur le poste client.
2. Sélectionner **Configurer un compte existant** et renseigner l'identité générale :
   * **Nom complet :** `Utilisateur Un`
   * **Adresse électronique :** `utilisateur1@tssr.lab`
   * **Mot de passe :** Saisir le mot de passe du compte concerné.
3. Cliquer sur **Configuration manuelle** et appliquer strictement les paramètres réseaux suivants :

| Paramètre | Configuration Serveur Entrant (IMAP) | Configuration Serveur Sortant (SMTP) |
| :--- | :--- | :--- |
| **Nom d'hôte** | `mail.tssr.lab` | `mail.tssr.lab` |
| **Port** | `143` | `587` |
| **Sécurité de la connexion** | `STARTTLS` ou `SSL/TLS` | `STARTTLS` ou `SSL/TLS` |
| **Méthode d'authentification**| `Mot de passe normal` | `Mot de passe normal` |
| **Nom d'utilisateur** | `utilisateur1@tssr.lab` (adresse complète) | `utilisateur1@tssr.lab` (adresse complète) |

4. Cliquer sur **Terminer**. Accepter l'exception de sécurité si le certificat SSL généré par iRedMail est auto-signé.
5. Procéder à un test croisé d'envoi et de réception entre deux boîtes aux lettres pour valider le bon fonctionnement de l'infrastructure.
