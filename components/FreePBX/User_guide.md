# Guide d'utilisation FreePBX

## Démarrage et première configuration

Par l'interface web, connecte-toi en root sur la VM avec le mot de passe associé.
Indique également une addresse mail pour les notifications et clique sur Setup System.

Dans la fenêtre, clique sur `FreePBX Administration` et reconnecte-toi en root.

<img width="202" height="194" alt="image" src="https://github.com/user-attachments/assets/47ae3b0c-ec6b-4c4e-acd5-0ebe7ad1fb41" />

---

Clique sur `Skip` pour sauter l'activation du serveur et toutes les offres commerciales qui s'affichent.

<img width="899" height="381" alt="image" src="https://github.com/user-attachments/assets/74f6065e-c5c2-4ef3-9dcb-7575e7d21b1f" />

---

Laisse les langages par défaut et clique sur `Submit`.

<img width="1855" height="264" alt="image" src="https://github.com/user-attachments/assets/de45d9c8-d48c-4138-a3a3-c74a7e199944" />

---

A la fenêtre d'activation du firewall, clique sur `Abort` :

<img width="1812" height="580" alt="image" src="https://github.com/user-attachments/assets/660ae956-a544-4ade-b7df-687710fe01d6" />

---

A la fenêtre de l'essais de SIP Station clique sur `Not Now` :

<img width="897" height="721" alt="image" src="https://github.com/user-attachments/assets/30488188-50fb-4b72-9cce-c1ecfe26350f" />

---

Tu arrive sur le tableau de bord, clique sur `Apply Config` (en rouge) pour valider tout ce que tu viens de faire

<img width="1856" height="713" alt="image" src="https://github.com/user-attachments/assets/f950f44a-6a21-445f-a4fe-e8f766cc862f" />

---

# Activation du serveur

Cette activation n'est pas obligatoire, mais elle permet d'avoir accès à l'ensemble des fonctionnalités du serveur.
Va dans le menu `Admin` puis `System Admin`.

<img width="276" height="941" alt="image" src="https://github.com/user-attachments/assets/eda42e23-304e-4cc8-9152-dca8a1f5cf7a" />

---

Un message indique que le système n'est pas activé.

<img width="722" height="45" alt="image" src="https://github.com/user-attachments/assets/9faab531-f15a-4958-a7bb-83c1970a8b84" />

---

Clique sur `Activation` puis `Activate`

Dans la fenêtre qui s'affiche, clique sur `Activate`


<img width="899" height="381" alt="image" src="https://github.com/user-attachments/assets/f81296af-6836-492c-9cae-5e9efb8cd2ca" />

---

Entre une adresse email et attend quelques instant.

<img width="900" height="514" alt="image" src="https://github.com/user-attachments/assets/596edc4d-4aa5-4093-ade5-da5ad147cdb6" />

---

Dans la fenêtre qui s'affiche, renseigne les différentes informations, et :

Pour `Which best describes you` mets `I use your products and services with my Business(s) and do not want to resell it`
Pour `Do you agree to receive product and marketing emails from Sangoma ?` coche No
Clique sur `Create`

<img width="861" height="570" alt="image" src="https://github.com/user-attachments/assets/6ee74698-9add-4b41-88c3-f14d0da824cb" />

---

Dans la fenêtre d'activation, clique sur `Activate` et attends que l'activation se fasse.

<img width="899" height="536" alt="image" src="https://github.com/user-attachments/assets/688f458b-35df-40b2-a121-7be17ad756ad" />

---

Dans les fenêtres qui s'affichent, clique sur `Skip`.

<img width="893" height="636" alt="image" src="https://github.com/user-attachments/assets/6debd06e-ce8b-4fe5-b69d-2174bac28e22" />

---

# Update des modules du serveur

La fenêtre de mise-à-jour des modules va s'afficher automatiquement.
Clique sur `Update Now`.

<img width="466" height="297" alt="image" src="https://github.com/user-attachments/assets/9378c208-4ed8-42cf-9aeb-15d7d52f3d64" />

---

Attend la mise-à-jour de tous les modules.

<img width="409" height="322" alt="image" src="https://github.com/user-attachments/assets/f711f660-1d33-4600-8cc6-eaae51603a51" />

---

Une fois que tout est terminé, clique sur Apply config.

```
Il peut y avoir des erreurs sur le serveurs suite à la mise-à-jour des modules et dans ce cas, l'accès au serveur ne se fait pas.
Les modules incriminés sont précisés et il faut les réinstaller et les activer.
Dans ce cas, sur le serveur en CLI, exécute les commandes suivantes :

fwconsole ma install <module>
fwconsole ma enable <module>
Par exemple pour les modules userman, voicemail, et sysadmin :

fwconsole ma install userman
fwconsole ma enable userman
fwconsole ma install voicemail
fwconsole ma enable voicemail
fwconsole ma install sysadmin
fwconsole ma enable sysadmin
```

Va sur le serveur en CLI et exécute la commande `yum update` pour faire la mise-à-jour du serveur.
Répond y lorsque cela sera demandé.

Redémarre le serveur

# Update complémentaire des modules

Connecte-toi en root via la console web, et vas dans le `Dashboard` pour voir s'il te manque des modules.
Vas dans le menu `Admin` puis `Modules Admin`, et dans l'onglet `Module Update`.

Dans la fenêtre qui s'affiche, dans la colonne `Status`, sélectionne ceux qui sont en `Disabled; Pending Upgrade...` et qui ont une licence GPL.
Sélectionne alors le bouton `Upgrade to ....`

<img width="1376" height="247" alt="image" src="https://github.com/user-attachments/assets/7a147511-d686-4cc7-8d75-50798720eb48" />

---

Quand tu as géré tous les modules, clique sur `Process`.

Dans la fenêtre qui apparaît, clique sur `Confirm`.

<img width="810" height="260" alt="image" src="https://github.com/user-attachments/assets/c47f338f-ada5-483b-a6c8-f166ff12874f" />

---

Quand tout est terminé, clique sur `Apply config`.

---

# Quelques menus intéressant pour l'administration

Dans les chapitres précédents, tu as vu les menus suivants :

Admin --> System Admin --> Activation
Admin --> Updates --> Module Update

Il y en a beaucoup d'autres !

Menu System Admin
Vas dans Admin --> System Admin et regarde à droite de la fenêtre, tu as différentes informations sur le serveur.

<img width="442" height="460" alt="image" src="https://github.com/user-attachments/assets/aa02b2c6-2dac-4139-96a2-2cfdc7af1467" />

---

Regarde plus particulièrement celles-ci :

**Activation** : Tu peux agir sur cette activation
**DNS** : Ici tu peux mettre les adresses IP des autres serveurs DNS de ton réseau
**Network Settings** : Le paramétrage IP (DHCP, ...)
**Hostname** : Le nom de ton serveur
**Time Zone** : Pour le fuseau horaire


**Menu Administrateurs**
Vas dans Admin --> Administrators et tu pourras gérer d'autres comptes administrateurs que root.

**Menu UCP**
Vas dans UCP pour avoir le portail qui permet aux utilisateurs d'avoir un contrôle plus direct sur leurs extensions de téléphonie.











