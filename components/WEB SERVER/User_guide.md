# Guide d'Exploitation

Se connecter au site web interne de Xentech : `http://interne.xtech.green`

<img width="1884" height="1064" alt="image" src="https://github.com/user-attachments/assets/1c81e741-2917-4ae2-a934-35e02ec0f278" />

---

Cliquer sur l'onglet `Ticketing GLPI` pour rédiger un ticket sur un poste un client ou accéder au tableau de bord depuis le poste admin T1


<img width="609" height="185" alt="image" src="https://github.com/user-attachments/assets/a84f2ab4-7d2c-4451-9d0c-b19745a355ab" />

---

<img width="1883" height="1064" alt="image" src="https://github.com/user-attachments/assets/92a94ec3-c61b-4ea3-9947-057093fbe603" />

---


Se connecter au site web interne de Xentech : `http://interne.xtech.green`


<img width="1887" height="1069" alt="image" src="https://github.com/user-attachments/assets/bebebe5c-7b71-480c-987d-7ce2114a5238" />

---

Cliquer sur `Organigramme` pour y accéder deuis la page d'accueil

<img width="1884" height="85" alt="image" src="https://github.com/user-attachments/assets/051ea4ef-c164-4952-a655-f95caa7ba93c" />

---

<img width="1881" height="1009" alt="image" src="https://github.com/user-attachments/assets/8839b1a7-e28f-4d74-bd5d-301c668ce3da" />

---

## 1. Gestion du Service Web au Quotidien
Pour maintenir et piloter le démon Apache2 sur Debian 13, utilisez les commandes système suivantes :

* **Vérifier l'état d'exécution du serveur :** `systemctl status apache2`
* **Arrêter le serveur web :** `systemctl stop apache2`
* **Démarrer le serveur web :** `systemctl start apache2`
* **Appliquer des modifications de code HTML (sans coupure) :** `systemctl reload apache2`

---

## 2. Maintenance et Mise à Jour des Liens Applicatifs
Pour modifier l'index d'un site (par exemple modifier l'arborescence ou mettre à jour le lien vers le serveur de gestion de parc GLPI), éditez directement le fichier source à la racine :

```bash
# Édition de l'index du site interne
nano /var/www/xtech-interne/index.html
```

Astuce d'exploitation : Aucun redémarrage d'Apache2 n'est requis lors de la modification simple de fichiers .html ou .php. Les changements sont visibles immédiatement en rafraîchissant le navigateur client (F5).

---

## 3. Guide de Diagnostic et Résolution des Pannes (Troubleshooting)


**Incident A : Le nom de domaine (ex: interne.xtech.green) ne répond plus, le navigateur affiche "Serveur introuvable".**


### Étape 1 : Diagnostic de la résolution de noms locale (DNS)
Depuis la VM web en panne, testez si elle parvient à joindre et interroger le contrôleur de domaine/serveur DNS principal (172.16.64.3) :

```
ping -c 3 172.16.64.3
```

### Étape 2 : Vérification du fichier /etc/resolv.conf
Si le ping fonctionne mais que la résolution de noms externe échoue, inspectez les serveurs de noms configurés sur la VM Debian :

```
cat /etc/resolv.conf
```

Le fichier doit obligatoirement contenir l'adresse du DC principal : nameserver 172.16.64.3. Si ce n'est pas le cas, rééditez le fichier /etc/network/interfaces pour corriger la ligne dns-nameservers et relancez l'interface.

### Étape 3 : Diagnostic depuis la console DNS Active Directory
Si la VM est correctement configurée, connectez-vous sur le serveur Windows principal (xts-411), ouvrez le gestionnaire DNS, et assurez-vous que les enregistrements d'hôtes (A) statiques obligatoires pointent bien vers les bonnes IP de vos VM Web :

interne ➔ 172.16.64.50

externe ➔ 172.16.64.51

---

**Incident B : Le DNS fonctionne (le ping résout l'IP), mais le navigateur affiche "Connexion refusée" ou une erreur 404/403.**

### Cas 1 : Le service Apache2 s'est arrêté
Exécutez systemctl status apache2. Si le service est marqué en Failed, inspectez les dernières lignes de log pour identifier l'erreur de syntaxe :

```
journalctl -u apache2 --no-pager -n 20
```

### Cas 2 : Erreur de droits d'accès (Erreur 403 Forbidden)
Apache ne possède pas les droits de lecture sur le dossier personnalisé créé. Rétablissez immédiatement les permissions d'usine :

```
chown -R www-data:www-data /var/www/xtech-interne
chmod -R 755 /var/www/xtech-interne
```

### Cas 3 : Analyse des journaux applicatifs en temps réel
Pour traquer les requêtes clients et intercepter les erreurs HTTP générées au moment précis où vous naviguez sur le site, lisez les fichiers de logs d'Apache en mode interactif :

```
# Suivre les erreurs du site interne
tail -f /var/log/apache2/xtech-interne_error.log

# Suivre les accès en temps réel
tail -f /var/log/apache2/xtech-interne_access.log
```

--


