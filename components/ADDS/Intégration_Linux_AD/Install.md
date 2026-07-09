# Guide d'Installation et Configuration Réseau

Suivre scrupuleusement ces étapes pour préparer le système et exécuter la jointure au domaine.

## 1. Configuration Réseau et Résolution DNS

Éditer le fichier de configuration Netplan pour pointer vers le contrôleur de domaine Active Directory :

```
sudo nano /etc/netplan/00-installer-config.yaml
```

<img width="1195" height="596" alt="Capture d&#39;écran 2026-07-05 171759" src="https://github.com/user-attachments/assets/b6f98c89-4c47-419c-8748-9fe64481eae2" />

---

```
sudo chmod 600 /etc/netplan/*.yaml
sudo netplan try
sudo netplan apply
```

Activer la synchronisation horaire NTP pour éviter tout décalage avec Kerberos :

```
sudo timedatectl set-ntp true
```

<img width="1219" height="234" alt="Capture d&#39;écran 2026-07-05 171637" src="https://github.com/user-attachments/assets/a0ce91ac-d708-4153-aef0-77ff6a8780b8" />

---

## 2. Installation des Dépendances et Découverte du Domaine

Installer les paquets requis pour la liaison AD et le service SSSD :

```
sudo apt update
sudo apt install -y realmd sssd sssd-tools libnss-sss libpam-sss adcli samba-common-bin krb5-user adsys
```

<img width="1224" height="531" alt="Capture d&#39;écran 2026-07-05 171655" src="https://github.com/user-attachments/assets/623d3fb8-7a84-442a-ba3b-4dcea71a0f17" />

---

<img width="1203" height="792" alt="Capture d&#39;écran 2026-07-05 171540" src="https://github.com/user-attachments/assets/8dc755d4-2827-4a4e-a8db-a8a1808775ae" />

---

Renseigner le domaine XTECH.GREEN en majuscules si l'invite Kerberos apparaît.

Découvrir le domaine afin de valider la visibilité des contrôleurs de domaine :

```
sudo realm discover xtech.green
```

<img width="1201" height="759" alt="image" src="https://github.com/user-attachments/assets/9b765a80-db58-4a5b-8289-dd2ee07d7271" />

---

## 3. Jointure Manuelle au Domaine Active Directory

Exécuter la jointure de la machine en utilisant un compte doté des privilèges requis :

```
sudo realm join --user=Administrator xtech.green
```

<img width="1201" height="110" alt="Capture d&#39;écran 2026-07-05 172000" src="https://github.com/user-attachments/assets/f2bf7ade-35ca-499c-b6e2-6cfef1e00c8a" />

---

Activer la création automatique des répertoires utilisateurs à la première connexion :

```
sudo pam-auth-update --enable mkhomedir sss
```

## 4. Configuration Avancée du Service SSSD

Ouvrir le fichier de configuration de SSSD pour stabiliser les correspondances d'identifiants :

```
[domain/xtech.green]
default_shell = /bin/bash
krb5_store_password_if_offline = True
cache_credentials = True
krb5_realm = XTECH.GREEN
realmd_tags = manages-system joined-with-adcli
id_provider = ad
fallback_homedir = /home/%u@%d
ad_domain = xtech.green
use_fully_qualified_names = True
ldap_id_mapping = True
access_provider = ad
ldap_sasl_authid = XTECH$
ad_gpo_access_control = permissive
```

<img width="1198" height="694" alt="image" src="https://github.com/user-attachments/assets/8a96f554-cecb-4add-9782-6344e7bcbc2b" />

---

Appliquer les permissions strictes sur le fichier et purger le cache persistant :

```
sudo chmod 600 /etc/sssd/sssd.conf
sudo systemctl stop sssd
sudo rm -rf /var/lib/sss/db/*
sudo rm -rf /var/lib/sss/mc/*
sudo systemctl start sssd
```

<img width="1743" height="1062" alt="image" src="https://github.com/user-attachments/assets/3b0b998d-36d2-471f-a1a0-79febd6fa076" />

---

## 5. Déploiement des Modèles de GPO Ubuntu (Adsys)

Exporter les fichiers de définitions GPO d'Ubuntu présents sur la VM pour les importer sur le serveur Windows Server 2022 :

Copier les fichiers .admx depuis /usr/share/adsys/admx/ vers le dossier C:\Windows\PolicyDefinitions\ du contrôleur de domaine.

Copier les fichiers .adml depuis /usr/share/adsys/admx/en-US/ vers C:\Windows\PolicyDefinitions\en-US\ du contrôleur de domaine.

---

