# Procédure d'Installation et Configuration de l'Agent de Logs Windows (NXLog)

Ce guide détaille la centralisation des journaux d'événements Windows (Active Directory, Serveur de fichiers, WDS et WSUS) vers notre infrastructure Syslog-ng. Sur le serveur de l'infrastructure (`172.16.64.28`), nous avons déployé un serveur Syslog-ng principal prêt à recevoir ces flux. L'agent retenu pour les machines Windows est **NXLog Community Edition**, choisi pour sa grande légèreté.

---

## 1. Téléchargement et Installation de l'Agent

1. Télécharger le package d'installation officiel de **NXLog Community Edition v3.2** pour Windows (architecture 64 bits) via le lien direct suivant :
   > **[Télécharger NXLog Community Edition (.msi)](https://nxlog.co/system/files/products/files/348/nxlog-ce-3.2.2329.msi)**
2. Lancer l'installateur `.msi` sur le serveur Windows cible (ex: le contrôleur de domaine `172.16.64.3`).
3. Suivre l'assistant d'installation en conservant le répertoire par défaut : 
   `C:\Program Files\nxlog`

<img width="1886" height="975" alt="image" src="https://github.com/user-attachments/assets/373e681c-e195-475d-8b91-7a9595922c3c" />


---
<img width="1895" height="1008" alt="image" src="https://github.com/user-attachments/assets/ecbab384-b86b-438f-ac07-35cce336150e" />

---

<img width="936" height="705" alt="image" src="https://github.com/user-attachments/assets/11d11214-d351-4d85-83f8-c96ee5cfa1d9" />

---



## 2. Configuration de l'Agent (`nxlog.conf`)

La configuration d'origine doit être remplacée afin de capturer les canaux stratégiques et d'aiguiller les flux vers notre réseau en `.64.x`.

1. Ouvrir l'éditeur de texte **Notepad (Bloc-notes)** explicitement **en tant qu'Administrateur**.
2. Ouvrir le fichier de configuration situé dans : 
   `C:\Program Files\nxlog\conf\nxlog.conf`
3. Effacer l'intégralité du contenu existant et le remplacer par le bloc de configuration suivant, adapté à notre infrastructure :

```
## Configuration NXLog - Infrastructure 172.16.64.0/24

define ROOT C:\Program Files\nxlog
define CERTDIR %ROOT%\cert
define CONFDIR %ROOT%\conf\nxlog.d
define LOGDIR %ROOT%\data

Moduledir %ROOT%\modules
CacheDir %ROOT%\data
Pidfile %ROOT%\data\nxlog.pid
LogFile %ROOT%\data\nxlog.log
LogLevel INFO

# Extension pour formater les messages au standard Syslog BSD
<Extension _syslog>
    Module      xm_syslog
</Extension>

# -------------------------------------------------------------
# 1. ENTRÉES : Collecte des journaux d'événements Windows
# -------------------------------------------------------------
<Input in_windows_logs>
    Module      im_msvistalog
    # Sélection des canaux principaux à centraliser
    Query       <QueryList>\
                    <Query Id="0">\
                        <Select Path="Application">*</Select>\
                        <Select Path="System">*</Select>\
                        <Select Path="Security">*</Select>\
                    </Query>\
                </QueryList>
</Input>

# -------------------------------------------------------------
# 2. SORTIES : Acheminement vers notre cluster Syslog-ng
# -------------------------------------------------------------
# Envoi vers le serveur Syslog Principal (Debian 12)
<Output out_syslog_principal>
    Module      om_tcp
    Host        172.16.64.28
    Port        514
    Exec        to_syslog_bsd();
</Output>

# Envoi vers le serveur de Backup (Debian 13)
<Output out_syslog_backup>
    Module      om_tcp
    Host        172.16.64.18
    Port        514
    Exec        to_syslog_bsd();
</Output>

# -------------------------------------------------------------
# 3. LIAISONS (Routes)
# -------------------------------------------------------------
<Route route_principal>
    Path        in_windows_logs => out_syslog_principal
</Route>

# Optionnel : décommenter si le serveur de backup est actif
# <Route route_backup>
#     Path        in_windows_logs => out_syslog_backup
# </Route>
```

Sauvegarder les modifications (Ctrl + S) et fermer le fichier.

---

# 3. Activation et Démarrage du Service

L'agent doit être configuré pour s'exécuter en arrière-plan et démarrer automatiquement avec le système Windows.

Option A : Via l'interface graphique des Services
Ouvrir le gestionnaire des services Windows (services.msc).

Rechercher le service nommé nxlog.

Ouvrir ses propriétés, positionner le Type de démarrage sur Automatique.

Cliquer sur Démarrer, puis valider.

**Option B : Via PowerShell (En tant qu'Administrateur)**
Exécuter les commandes suivantes pour automatiser la tâche :

```
Set-Service -Name nxlog -StartupType Automatic
Restart-Service -Name nxlog
```

# 4. Contrôle et Validation

Vérification locale sur la machine Windows :
En cas d'erreur de syntaxe ou de problème de démarrage, consulter les lignes de statut dans le fichier journal local de l'agent :
C:\Program Files\nxlog\data\nxlog.log
Un fonctionnement normal est confirmé par la mention : nxlog-ce started.

Validation sur notre serveur Syslog-ng principal (172.16.64.28) :
Dès le lancement du service NXLog, un paquet d'initialisation est transmis au serveur de logs. Exécuter la commande suivante sur notre serveur centralisé pour valider la création automatique du répertoire :

```
ls -la /var/log/syslog-ng/
```

Le nouveau dossier portant l'adresse IP du serveur Windows configuré (ex: 172.16.64.3) doit apparaître instantanément dans la liste.

---
