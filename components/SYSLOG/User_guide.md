# Guide d'Utilisation - Administration et Exploitation de Syslog-ng

Ce guide rassemble toutes les commandes et procédures indispensables pour exploiter, auditer et dépanner au quotidien votre serveur de centralisation des logs sous Debian 12.

## 1. Vérification des liaisons réseaux et des ports d'écoute

Puisque les équipements de l'infrastructure (`172.16.64.0/24`) envoient leurs flux de journaux vers ce serveur, la première étape d'exploitation consiste à s'assurer que le démon `syslog-ng` écoute correctement les paquets entrants.

**Vérifier l'écoute des flux UDP (Port 514) :**

  ```
  ss -ulnp | grep 514
  ```

<img width="1866" height="204" alt="Capture d&#39;écran 2026-07-04 211851" src="https://github.com/user-attachments/assets/aedea88a-452c-41a5-b334-b0d59af5827a" />


---

## 2. Déclenchement et Validation du Premier Flux Client

Pour valider le bon fonctionnement de la chaîne de centralisation et forcer syslog-ng à créer dynamiquement les dossiers de stockage grâce à l'option create-dirs(yes), il faut générer un log de test depuis vos machines clientes.

A. Depuis un client Linux (Serveurs Web, BDD, autres CT LXC)
Utiliser l'utilitaire logger pour injecter un message directement dans le canal réseau du serveur de logs :

```
# Envoi forcé via le protocole TCP (Recommandé)
logger --tcp -n 172.16.64.28 -P 514 "TEST_FLUX_XTECH : Initialisation du flux centralisé"

# Envoi alternatif via le protocole UDP
logger -n 172.16.64.28 -P 514 "TEST_FLUX_XTECH : Initialisation du flux centralisé"
```
<img width="1873" height="109" alt="image" src="https://github.com/user-attachments/assets/977dc209-f74f-4c09-b3ab-c6005025e197" />

---

## 3. Lecture et Navigation dans l'Arborescence des Logs

Grâce à la variable $HOST déclarée dans la configuration, syslog-ng trie automatiquement les fichiers reçus par adresse IP ou par Nom d'Hôte dans le répertoire racine /var/log/syslog-ng/.

Lister l'ensemble des machines de l'infrastructure qui centralisent leurs logs :

<img width="1875" height="452" alt="image" src="https://github.com/user-attachments/assets/8cc2b4c8-acd7-465b-b571-d380c3b768b3" />

---

Consulter l'historique ou suivre les logs en temps réel d'un serveur spécifique :
Les fichiers de logs adoptent une nomenclature claire basée sur la date du jour (AAAA-MM-JJ.log).

```
# Suivre en direct (Live tail) l'activité d'une machine cliente
tail -f /var/log/syslog-ng/172.16.64.14/2026-07-04.log
```

<img width="1879" height="474" alt="image" src="https://github.com/user-attachments/assets/e1b4dcf2-3af3-4a6b-988b-3a3bb0467535" />

---

## 4. Nettoyer les anciens dossiers en .172.16.40.x

Exécuter ces commandes sur le serveur de logs (172.16.64.28) :

```
# 1. Supprime proprement les anciens dossiers spécifiques (un par un pour la sécurité)
rm -rf /var/log/syslog-ng/172.16.40.14
rm -rf /var/log/syslog-ng/172.16.40.18
rm -rf /var/log/syslog-ng/172.16.40.22
rm -rf /var/log/syslog-ng/172.16.40.27


# 2. Vérifie que ton arborescence est désormais propre et ne contient que du .64 :
ls -la /var/log/syslog-ng/
```

<img width="1865" height="447" alt="image" src="https://github.com/user-attachments/assets/f8f1b0be-a19b-4c2e-93c0-39e65531c1c0" />

---

## 5. Étape 2 : Faire basculer TOUS tes serveurs en .64


Pour que l'intégralité des serveurs de l'infrastructure apparaissent désormais dans le dossier /var/log/syslog-ng/, il reste simplement à appliquer la configuration finale sur chacun des clients :

**A. Sur tes serveurs Linux clients :**

Ouvrir le fichier de configuration de leur service de journalisation (souvent /etc/rsyslog.conf selon ce qui est installé sur le client) et s'assurer qu'ils pointent bien vers les nouvelles adresses IP :

```
# Exemple si le client utilise Rsyslog :
*.* @@172.16.64.28:514      # Envoi au Serveur SYSLOG 
*.* @@172.16.64.18:514      # Envoi au Serveur BKP (RAID 5 + LVM)
```

<img width="1880" height="136" alt="image" src="https://github.com/user-attachments/assets/f047168e-e97c-4071-8cb9-d279f38a77a3" />

---

Rsyslog est installé sur tous les clients. Si les machines clientes utilisent déjà Rsyslog, il est inutile et déconseillé d'installer syslog-ng dessus.

Le rôle de l'infrastructure est d'avoir un serveur central unique sous syslog-ng (ce que nous avons avec succès), mais les clients peuvent tout à fait envoyer leurs logs en utilisant rsyslog (qui est l'outil léger installé par défaut sur la plupart des distributions Linux). Ils parlent le même protocole standard !

Si une tentative d'installation syslog-ng a déjà eté faite sur un client et que cela pose problème ou s'il y a un conflit avec rsyslog, voici comment nettoyer le client et configurer son rsyslog natif pour qu'il envoie ses logs vers le serveur SYSLOG-NG centralisé.

Étape 1 : Nettoyer le client Linux (Garder uniquement Rsyslog)
Sur la machine cliente SRV-GLPI (XTSE-451), désinstaller proprement syslog-ng pour éviter que deux serveurs de logs ne se disputent les mêmes ressources locales :

```
# Supprimer syslog-ng et ses fichiers de configuration résiduels
apt purge -y syslog-ng syslog-ng-core syslog-ng-mod-sql
```

<img width="1884" height="1272" alt="Capture d&#39;écran 2026-07-04 220019" src="https://github.com/user-attachments/assets/cce5b16a-2e68-4363-a6a1-0c54db081a19" />

---

Ré-installer Rsyslog : 

```
apt update && apt install rsyslog -y
systemctl restart rsyslog
systemctl enable rsyslog
systemctl status rsyslog
```

<img width="1883" height="555" alt="image" src="https://github.com/user-attachments/assets/51596e2c-1eb9-48cc-b3f9-bdcc2b965b19" />

---
