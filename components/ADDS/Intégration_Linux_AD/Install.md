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

