# Serveur FreePBX & Softphone 3CX — Guide de Résolution des Incidents (FAQ)

### Q1 : Le statut du profil sur le Softphone 3CX reste bloqué sur "On Hook" (Non enregistré) ou affiche une erreur de connexion réseau.

* **Cause 1 : Écart de configuration IP.** Les cartes réseau internes des machines clientes et du serveur ne partagent pas le même segment réseau IP, ou le service réseau du serveur FreePBX n'a pas pris en compte la configuration statique.
* **Cause 2 : Secret incorrect.** Le mot de passe ou l'ID d'extension saisi dans l'onglet `Account Settings` de 3CX Phone ne correspond pas exactement au `Secret` ou à la `User Extension` soumis dans le panneau FreePBX.
* **Résolution :**
  1. Valider la connectivité réseau de bout en bout. Depuis PowerShell sur le PC Client 1 (`172.16.64.13`), initier un ping vers la carte réseau du serveur FreePBX :
     ```powershell
     ping 172.16.64.31
     ```
  2. Si le ping échoue, vérifier l'état du service réseau sur FreePBX avec `systemctl status network` après avoir validé le fichier `/etc/sysconfig/network-scripts/ifcfg-eth0`.
  3. Ouvrir l'onglet **Set Account** > **Edit** sur l'application 3CX et s'assurer que les champs suivants pointent exclusivement sur l'identifiant numérique :
     * **Caller ID :** `80100` (Exemple pour Marie Dupont)
     * **Extension :** `80100`
     * **ID :** `80100`
     * **I am in the office - local IP :** `172.16.64.31`

---

### Q2 : Lors d'une tentative d'appel vers un autre poste (ex: le 80103), le Softphone 3CX émet une tonalité d'occupation ou affiche le message "Not Found".

* **Cause :** L'extension ciblée n'est pas encore créée sur l'IPBX, ou les modifications apportées dans le panneau d'administration Web de FreePBX n'ont pas été chargées dans la configuration active d'Asterisk.
* **Résolution :**
  1. Se connecter sur l'interface d'administration Web de FreePBX (`http://172.16.64.31`) à l'aide du navigateur d'un poste client.
  2. Naviguer dans **Applications** > **Extensions**.
  3. Vérifier la présence du numéro demandé dans le tableau récapitulatif des extensions SIP `chan_pjsip`.
  4. **Important :** Si un bouton rouge **Apply Config** apparaît en haut à droite de l'interface Web, cliquer obligatoirement dessus pour appliquer les lignes créées et rafraîchir le plan de numérotation d'Asterisk.

---

### Q3 : Je souhaite modifier la configuration réseau de ma carte `eth0` sur FreePBX mais les commandes Debian standards (`nano /etc/network/interfaces`) ne fonctionnent pas.

* **Cause :** FreePBX est adossé à une distribution de type Linux CentOS (Red Hat), son architecture de script réseau diffère donc des distributions de la famille Debian/Ubuntu.
* **Résolution :**
  1. Ouvrir le fichier de configuration spécifique à Red Hat à l'aide de l'éditeur local :
     ```bash
     vi /etc/sysconfig/network-scripts/ifcfg-eth0
     ```
  2. Adapter ou insérer les variables réseau statiques obligatoires :
     ```text
     BOOTPROTO=static
     IPADDR=172.16.64.31
     NETMASK=255.255.255.0
     ONBOOT=yes
     ```
  3. Enregistrer l'édition et forcer la réinitialisation de la pile réseau système :
     ```bash
     systemctl restart network
     ```

---

### Q4 : Est-il possible d'enregistrer et d'utiliser simultanément deux lignes d'utilisateurs distincts sur la même instance de l'application 3CX Phone ?

* **Cause / Contexte :** Dans le plan de numérotation du laboratoire, le Poste Client 1 héberge à la fois le compte de Marie Dupont (`80100`) et celui de Pierre Martin (`80101`).
* **Résolution :**
  1. Oui, l'application 3CX permet la multi-configuration. Accéder au panneau **Accounts** de 3CX Phone.
  2. Cliquer sur **New** pour renseigner la ligne de Marie Dupont, puis cliquer à nouveau sur **New** pour déclarer celle de Pierre Martin.
  3. Sur l'affichage de la liste des comptes, cocher la case située à gauche du profil de l'utilisateur pour définir la ligne active (le profil sélectionné affichera alors son nom sur l'écran principal du Softphone).





### Q5 : Lors de la connexion en SSH avec mon utilisateur standard, des avertissements PHP ("Permission denied" / "FWApplication.class.php") s'affichent en cascade dans mon terminal. Le serveur est-il corrompu ?

* **Cause :** Non, le serveur n'est pas corrompu. Lors de l'ouverture d'une session utilisateur, le système FreePBX tente automatiquement d'exécuter le script de bienvenue de la console d'Asterisk (`fwconsole`) pour afficher l'état du serveur d'appel. Ce script nécessite de lire le fichier de configuration `/etc/freepbx.conf`. L'utilisateur standard (ex: `t1`) ne possède pas les privilèges de sécurité nécessaires pour lire ce fichier restrictif, ce qui déclenche le rejet de l'interpréteur PHP.
* **Résolution :** Ce comportement est normal et attendu sous les privilèges restreints d'un utilisateur non-root en SSH. Vous pouvez ignorer ces alertes initiales et basculer immédiatement sous l'environnement root pour administrer le serveur sans restriction à l'aide de la commande :
```bash
su -
```

Saisissez ensuite le mot de passe root défini lors de la phase d'installation.

---

### Q6 : Mon mot de passe root est systématiquement rejeté lors de ma première connexion sur la console de la VM FreePBX, bien que je sois certain de ce que j'ai écrit.
Cause : Durant la phase d'installation graphique de FreePBX (SNG PBX), l'installateur utilise par défaut une disposition de clavier américaine QWERTY. Si vous avez saisi votre mot de passe en pensant être sur un clavier français AZERTY, les caractères spéciaux ou certaines lettres (comme le A, Z, Q, W, M ou les chiffres sans la touche Maj) ont été inversés ou mal interprétés par le système.

Résolution : Réinitialisez la machine virtuelle. Lors de la phase de saisie du mot de passe dans l'écran de configuration système (ROOT PASSWORD), faites attention à la correspondance des touches de votre clavier physique.

Exemple : Si votre mot de passe contient un A, appuyez sur la touche Q de votre clavier AZERTY. Pour saisir des chiffres, utilisez le pavé numérique ou assurez-vous de la correspondance de la rangée supérieure du clavier QWERTY. Une fois le système démarré et le clavier basculé en français via localectl (voir le User_guide.md), vos futures saisies locales correspondront parfaitement.
