# Guide d'Installation - Serveur de Messagerie iRedMail

Ce document décrit les étapes nécessaires pour préparer le conteneur Debian 12, configurer la zone DNS sur notre contrôleur de domaine Windows Server et installer la suite iRedMail.

---

## Étape 1 - Prérequis et Préparation du Système

### 1.1. Configuration de la machine Debian 12 (`SRV-iRedMail`)
Allouer un minimum de **4 Go de RAM** et **20 Go d'espace disque** au conteneur pour le bon fonctionnement des modules de filtrage (antivirus/antispam).

Mettre à jour le système et installer les outils de base :

```
apt update && sudo apt upgrade -y
apt install -y wget vim
```

<img width="1880" height="564" alt="Capture d&#39;écran 2026-07-04 234016" src="https://github.com/user-attachments/assets/b4729d0a-0568-4d6c-839a-213590db2363" />

---

Définir le nom d'hôte complet (FQDN) du serveur :

```
hostnamectl set-hostname mail
echo "mail.Xtech.green" | tee /etc/hostname
```

<img width="1878" height="134" alt="image" src="https://github.com/user-attachments/assets/ea27f9bf-190f-4835-8471-9f552da08085" />

---

Modifier le fichier /etc/hosts pour associer l'IP fixe au FQDN :

```
# Éditer /etc/hosts et insérer la ligne suivante :
172.16.64.30  mail.Xtech.green mail
```

<img width="939" height="138" alt="image" src="https://github.com/user-attachments/assets/ae3a69af-4ad8-4a99-b695-fe15675087b4" />

---

### 1.2. Préparation du serveur DNS (Sur SRV-AD - 172.16.64.3)
Pour que les flux de messagerie soient correctement routés, configurer la zone sur le serveur DNS Windows Server.

A. Ajout des enregistrements réseau
Enregistrement A (Hôte) :

Faire un clic droit sur la zone Xtech.greenmail -> Nouvel hôte (A)....

Saisir le nom : mail.

Saisir l'adresse IP du serveur de messagerie : 172.16.64.30.

Cliquer sur Ajouter un hôte.

<img width="1012" height="684" alt="image" src="https://github.com/user-attachments/assets/6d24e86c-1bf1-4e58-a2a5-d288d6eedd57" />

---

Enregistrement MX (Échangeur de courrier) :

Faire un clic droit sur la zone Xtech.green -> Nouvel échangeur de courrier (MX)....

Laisser le champ du nom d'hôte ou domaine parent vide (utilise le domaine par défaut).

Dans le champ Nom de domaine complet du serveur de messagerie, saisir : mail.Xtech.green..

Indiquer une priorité de 10.

Cliquer sur OK.

<img width="594" height="676" alt="image" src="https://github.com/user-attachments/assets/017c0199-0412-40a6-96a5-bf37b792f89a" />

---

Enregistrement CNAME (Alias optionnel) :

Faire un clic droit sur la zone tssr.lab -> Nouvel alias (CNAME)....

Saisir le nom de l'alias : iredmail.

Saisir le nom de domaine complet de la cible : mail.Xtech.green.

Cliquer sur OK.

<img width="594" height="672" alt="image" src="https://github.com/user-attachments/assets/95eaece7-f032-49ea-bf44-2fac07911857" />

---

Étape 2 - Téléchargement et Exécution d'iRedMail
2.1. Récupération des sources
Se positionner dans le répertoire /root ou /tmp et télécharger la version stable :

```
wget https://github.com/iredmail/iRedMail/archive/refs/tags/1.7.2.tar.gz
tar xvf 1.7.2.tar.gz
cd iRedMail-1.7.2
bash iRedMail.sh
```

<img width="1877" height="487" alt="image" src="https://github.com/user-attachments/assets/45903079-5938-4623-a53b-a83ab727221c" />


---

<img width="1880" height="83" alt="image" src="https://github.com/user-attachments/assets/d234baf2-7fa2-423b-9ffb-9ac315505488" />

---

2.3. Directives de configuration de l'assistant
Au cours de l'assistant, appliquer scrupuleusement les choix suivants :

Stockage des emails : Conserver l'emplacement par défaut /var/vmail.

Serveur Web : Sélectionner Nginx.

Backend de base de données : Sélectionner OpenLDAP.

Mot de passe racine LDAP : Saisir un mot de passe fort pour l'administrateur de l'annuaire.

Premier domaine de messagerie : Saisir exactement Xtech.green.

Mot de passe du compte administrateur du domaine : Définir un mot de passe hautement sécurisé pour le compte maître postmaster@xtech.green.

Composants optionnels : Cocher l'ensemble des options proposées (Roundcube, iRedAdmin, Fail2ban, etc.) afin de garantir la sécurité et l'accessibilité du serveur.

Valider les choix en tapant y lors du résumé final, puis procéder au redémarrage du serveur une fois l'installation achevée.

```
reboot
```

---

<img width="893" height="718" alt="image" src="https://github.com/user-attachments/assets/41f1b6b8-c0db-4777-ab66-ca8b98cd4993" />

---


