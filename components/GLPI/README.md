# Composant GLPI - Gestion de Parc & Helpdesk

Ce dossier rassemble la documentation technique et opérationnelle liée au déploiement, à l'administration et à la politique de sauvegarde de la solution **GLPI (Version 11.0.7)** au sein de notre infrastructure.

GLPI est installé sur un conteneur (CT) LXC Debian 12 managé sous Proxmox, connecté à l'Active Directory pour la synchronisation des utilisateurs, et hautement sécurisé.

---

## Organisation de la Documentation

Cliquez sur les liens ci-dessous pour accéder directement aux différents guides de ce composant :

* **[Guide d'Installation & Déploiement](./Install.md)** : Procédure étape par étape pour installer la pile LAMP, configurer la base de données MariaDB, déployer GLPI v11.0.7 et configurer le VirtualHost Apache.
* **[Guide Utilisateur & Exploitation](./User_guide.md)** : Prise en main du Helpdesk, interconnexion/synchronisation avec l'annuaire AD (LDAP), ainsi que les procédures de vérification des services et les plans de *Rollback* (restauration) en cas d'incident.
* **[Foire Aux Questions (FAQ)](./FAQ.md)** : Recueil des erreurs fréquentes et fiches d'aide au diagnostic (résolution DNS réseau, perte de connexion à la base de données).

---

## Fiche d'Identité du Composant

* **Environnement de virtualisation :** Proxmox VE 
* **Système d'Exploitation :** Debian 12 Bookworm (Conteneur LXC non-privilégié)
* **Architecture Web :** Pile LAMP (Apache2, MariaDB, PHP)
* **Ressources allouées :** 2 vCPUs | 2.00 GiB RAM | 31.20 GiB Disque
* **Nom de Domaine Interne (FQDN) :** `support.xtech.green` (IP : `172.16.64.14`)

---

## Politique de Sauvegarde & Centralisation des Logs

Pour garantir la résilience des données du Helpdesk, une chaîne de traitement automatisée a été mise en place :

1. **Planification (Cron) :** Une tâche planifiée déclenche le script de sauvegarde tous les jours à **minuit** (`0 0 * * *`).
2. **Extraction (Mysqldump) :** Le script Bash réalise un export à chaud de la base de données `db_glpi`.
3. **Transfert Sécurisé & Incrémental (Rsync via SSH) :** Les fichiers et le dump SQL sont transférés vers le serveur de sauvegarde distant (`srv bkp`) de manière incrémentale en utilisant une authentification par clé SSH (sans passphrase).
4. **Supervision Centralisée (Logger & Syslog) :** Toutes les étapes du script (succès ou erreurs de l'export) sont capturées via la commande `logger`. Elles alimentent le Syslog local, qui retransmet immédiatement ces événements vers notre **serveur Syslog Centralisé**.

---

## Commandes de Vérification Rapide

En cas de dysfonctionnement ou pour auditer le système, exécutez ces commandes directement sur le conteneur GLPI :

```bash
# Vérifier l'état des services principaux
systemctl status apache2      # Serveur Web
systemctl status mariadb      # Base de données
systemctl status cron         # Planificateur de tâches

# Vérifier si la sauvegarde de minuit s'est bien déclenchée
grep -i "backup" /var/log/syslog

# Tester la configuration des VirtualHosts Apache
apache2ctl configtest
```

---

<img width="1877" height="1287" alt="image" src="https://github.com/user-attachments/assets/9b77f05f-5589-4bcf-968c-7eeb3dfe9349" />

---



