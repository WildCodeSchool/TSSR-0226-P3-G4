# FAQ

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

---
