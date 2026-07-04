# Guide d'Installation Syslog et Configuration 

Ce document décrit les étapes pour installer le service conformément aux prérequis du serveur décrits dans le `README.md` :



## 1. Activation de la persistance de systemd-journald
Par défaut sur certains templates LXC Debian minimaux, les logs sont volatiles. Il faut les fixer sur le disque.

```bash
# 1. Ouvrir le fichier de configuration de journald
nano /etc/systemd/journald.conf

# 2. Modifier ou décommenter la ligne suivante sous la section [Journal] :
Storage=persistent
SystemMaxUse=500M

# 3. Redémarrer le service journald
systemctl restart systemd-journald
