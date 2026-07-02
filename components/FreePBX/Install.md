# Installation de FreePBX

Étape 1 - Prérequis 

- Template : SNG PBX     
- CPU : 1 core   
- RAM : 2G    
- Stockage : 20G    
- Type de conteneur : Non-privilégié (Unprivileged: Yes)    
- Décocher Firewall
- Un softphone 3CX installé sur chaque VM

Le labo a été testé avec les OS Windows Server 2022, Windows 11, et FreePBX qui tourne sur une distribution Red Hat. Les VM fonctionnent sur Proxmox VE.

---

## Installation

Au démarrage de la VM, dans la liste, choisir la version recommandée.   

<img width="642" height="568" alt="image" src="https://github.com/user-attachments/assets/6d84dca0-231e-4d13-aed2-b2991097da0c" />

---

Puis sélectionner `Graphical Installation - Output to VGA.`

<img width="642" height="568" alt="image" src="https://github.com/user-attachments/assets/daa496c9-f6a4-416d-bbad-ecc458844206" />

---

Enfin choisir `FreePBX Standard`   


<img width="642" height="568" alt="image" src="https://github.com/user-attachments/assets/5d5e6bbd-3459-4158-8c76-335ef9929539" />

---

Pendant l'installation, il faut configurer le mot de passe root (`Root password is not set` s'affiche).

<img width="1026" height="856" alt="image" src="https://github.com/user-attachments/assets/8663e269-f85b-440a-bc23-8f22940a290b" />

---

Clique sur `ROOT PASSWORD` et entre un mot de passe (robuste, est-il besoin de le préciser ?) pour le compte root.

```
/!\ Le clavier est en anglais donc attention aux lettres des touches du clavier QWERTY !
```

<img width="1026" height="856" alt="image" src="https://github.com/user-attachments/assets/be0bd98b-7612-4df8-a0b1-ce240a587840" />

---

Indication que le mot de passe root a été changé :

<img width="1026" height="856" alt="image" src="https://github.com/user-attachments/assets/ed2d18bf-64ca-4fc9-a9b7-0ef577647578" />

---

L'installation continue et se termine.

<img width="1026" height="856" alt="image" src="https://github.com/user-attachments/assets/98fe645a-541b-4ae2-a7c6-073c099fdcb4" />

---

Éteindre la VM, enlever l'ISO du lecteur et redémarrer la VM.

<img width="802" height="688" alt="image" src="https://github.com/user-attachments/assets/bf3d3dc3-2a5f-4eba-a8c4-595ed0d50430" />

---

# Configuration sur la VM serveur

Connecte toi en root.

---

## Modification de la langue du clavier

La commande `localectl` donne les informations suivantes :

```
System Locale: LANG=en_US.UTF-8
    VC Keymap: us
   X11 Layout: us
```
---

Vérifie avec la commande `localectl list-locales` que tu as bien `fr_FR.utf8` dans la liste qui s'affiche.

Ecrit les lignes de commandes suivantes pour mettre le clavier en français :

```
localectl set-locale LANG=fr_FR.utf8
localectl set-keymap fr
localectl set-x11-keymap fr
```

---

Vérifie avec la commande `localectl` :

```
System Locale: LANG=fr_FR.UTF-8
    VC Keymap: fr
   X11 Layout: fr
```

---

## Création d'un utilisateur pour l’accès ssh

Créer un utilisateur, ici ce sera wilder, avec la commande `adduser` et change son mot de passe avec `passwd`.
Edite le fichier `/etc/ssh/sshd_config` et modifie le fichier pour qu'il contienne les lignes suivantes :


```
PermitRootLogin no
AllowUsers T1
PasswordAuthentication yes
```
---

Redémarre le service avec `systemctl restart sshd`.

---

# Connexion en SSH

A partir de ta machine cliente, connecte toi en ssh (ici l'adresse IP du serveur FreePBX est 172.16.64.31) :

```
t1@:xentech~$ ssh t1@172.16.64.31
t1@172.16.64.31's password: 
PHP Warning:  include_once(/etc/freepbx.conf): failed to open stream: Permission denied in /var/lib/asterisk/bin/fwconsole on line 12
PHP Warning:  include_once(): Failed opening '/etc/freepbx.conf' for inclusion (include_path='.:/usr/share/pear:/usr/share/php') in /var/lib/asterisk/bin/fwconsole on line 12
PHP Fatal error:  Uncaught Error: Class 'Symfony\Component\Console\Application' not found in /var/www/html/admin/libraries/FWApplication.class.php:11
Stack trace:
#0 /var/lib/asterisk/bin/fwconsole(66): include()
#1 {main}
  thrown in /var/www/html/admin/libraries/FWApplication.class.php on line 11
[t1@freepbx ~]$ 
```

---

Ensuite tu peux passer en root :

---

<img width="1644" height="747" alt="image" src="https://github.com/user-attachments/assets/6d5b567e-5c26-40d3-98e8-5f17d12429b5" />


---

```
/!\ Afin de sécuriser l'accès au serveur, l'authentification ssh par mot de passe ne doit être que temporaire.
Idéalement, il faut que cette connexion se fasse par partage de clé.
Pour rappel :

Création d'une paire de clés avec ssh-keygen
Copie de la clé publique sur le serveur avec ssh-copy-id
Une fois cela fait, il faut modifier le fichier /etc/ssh/sshd_config pour n'autoriser que l'authentification par clés.
```

---

# Connexion en web

<img width="1884" height="1063" alt="image" src="https://github.com/user-attachments/assets/f0efe56f-b2d5-49cc-8d90-d919e540ec60" />

---


