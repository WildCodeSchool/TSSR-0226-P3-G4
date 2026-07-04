# Procédure d'Installation et Configuration de l'Agent de Logs Windows (NXLog)

Ce guide détaille la centralisation des journaux d'événements Windows (Active Directory, Serveur de fichiers, WDS et WSUS) vers notre infrastructure Syslog-ng. Sur le serveur de l'infrastructure (`172.16.64.28`), nous avons déployé un serveur Syslog-ng principal prêt à recevoir ces flux. L'agent retenu pour les machines Windows est **NXLog Community Edition**, choisi pour sa grande légèreté.

---

## 1. Téléchargement et Installation de l'Agent

1. Télécharger le package d'installation officiel de **NXLog Community Edition v3.2** pour Windows (architecture 64 bits) via le lien direct suivant :
   > 🔗 [Télécharger NXLog Community Edition (.msi)](https://nxlog.co/system/files/products/files/348/nxlog-ce-3.2.2329.msi)
2. Lancer l'installateur `.msi` sur le serveur Windows cible (ex: le contrôleur de domaine `172.16.64.3`).
3. Suivre l'assistant d'installation en conservant le répertoire par défaut : 
   `C:\Program Files\nxlog`

---

## 2. Configuration de l'Agent (`nxlog.conf`)

La configuration d'origine doit être remplacée afin de capturer les canaux stratégiques et d'aiguiller les flux vers notre réseau en `.64.x`.

1. Ouvrir l'éditeur de texte **Notepad (Bloc-notes)** explicitement **en tant qu'Administrateur**.
2. Ouvrir le fichier de configuration situé dans : 
   `C:\Program Files\nxlog\conf\nxlog.conf`
3. Effacer l'intégralité du contenu existant et le remplacer par le bloc de configuration suivant, adapté à notre infrastructure :

```text
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
