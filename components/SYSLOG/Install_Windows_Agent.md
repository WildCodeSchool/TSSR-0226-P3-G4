# Procédure d'Installation et Configuration de l'Agent de Logs sur Windows (NXLog)

Ce guide détaille l'installation de **NXLog Community Edition**, l'agent le plus léger (style rsyslog) pour Windows. Il permet de collecter les canaux stratégiques (Application, System, Security) de vos contrôleurs de domaine (AD), serveurs de fichiers, WDS et WSUS, et de les acheminer en TCP vers le serveur Syslog-ng principal (`172.16.64.28`).

---

## 1. Téléchargement et Installation de l'Agent

1. Téléchargez le package d'installation officiel de **NXLog Community Edition** pour Windows (fichier `.msi`) depuis le site officiel de NXLog.
2. Lancez l'installateur sur le serveur Windows (ex: votre Active Directory `172.16.64.3`).
3. Suivez l'assistant en conservant le répertoire d'installation par défaut : 
   `C:\Program Files\nxlog` (ou `C:\Program Files (x86)\nxlog` sur les architectures plus anciennes).

---

## 2. Configuration de l'Agent (`nxlog.conf`)

La configuration par défaut doit être remplacée pour capturer correctement les événements Windows et les envoyer au bon format à votre architecture Syslog-ng.

1. Ouvrez l'éditeur de texte **Notepad (Bloc-notes)** explicitement **en tant qu'Administrateur**.
2. Ouvrez le fichier de configuration situé dans : 
   `C:\Program Files\nxlog\conf\nxlog.conf`
3. Effacez l'intégralité du contenu et remplacez-le par la configuration optimisée suivante :

```text
## Configuration NXLog Légère pour l'Infrastructure 172.16.64.0/24

define ROOT C:\Program Files\nxlog
define CERTDIR %ROOT%\cert
define CONFDIR %ROOT%\conf\nxlog.d
define LOGDIR %ROOT%\data

Moduledir %ROOT%\modules
CacheDir %ROOT%\data
Pidfile %ROOT%\data\nxlog.pid
LogFile %ROOT%\data\nxlog.log
LogLevel INFO

# Extension nécessaire pour formater les logs Windows en chaîne Syslog standard
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
# 2. SORTIES : Acheminement vers l'infrastructure Syslog-ng
# -------------------------------------------------------------
# Envoi vers le serveur Syslog Principal (Debian 12)
<Output out_syslog_principal>
    Module      om_tcp
    Host        172.16.64.28
    Port        514
    Exec        to_syslog_bsd();
</Output>

# Envoi vers le serveur de Backup (Debian 13) - Optionnel
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

# Décommenter si le serveur de backup est actif
# <Route route_backup>
#     Path        in_windows_logs => out_syslog_backup
# </Route>
