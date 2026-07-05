# Guide d'Installation et Configuration Réseau

Suivre scrupuleusement ces étapes pour préparer le système et exécuter la jointure au domaine.

## 1. Configuration Réseau et Résolution DNS

Éditer le fichier de configuration Netplan pour pointer vers le contrôleur de domaine Active Directory :

```
sudo nano /etc/netplan/00-installer-config.yaml
```

