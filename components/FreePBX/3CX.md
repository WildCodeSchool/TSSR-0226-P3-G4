# Création d'utilisateurs et de lignes sur FreePBX

## Configuration réseau du serveur

Le serveur FreePBX est basé sur une distribution Linux CentOS, donc la configuration n'est pas la même que sur une Debian par exemple.

La commande `ip a` te permet d'afficher les cartes réseaux.
Le fichier de configuration réseau à éditer pour modifier les paramètres de la carte `eth0` est `/etc/sysconfig/network-scripts/ifcfg-eth0`.
Ajoute ou modifie les lignes suivantes :

```
BOOTPROTO=static
IPADDR=172.16.64.31
NETMASK=255.255.255.0
```

Enregistre le fichier et redémarre le service réseau avec la commande `systemctl restart network`.

---

# Configuration réseau des clients

Sur la VM client 1, écrire les commandes PowerShell suivante pour avoir une configuration IP statique :

```
$Adapter = $(Get-NetAdapter)[0]
New-NetIPAddress -InterfaceIndex $Adapter.ifIndex -IPAddress 172.16.64.13 -PrefixLength 24
```
Faire la même chose sur la VM client 2 avec l'adresse `172.16.64.14`

---

# Création d'utilisateurs et de lignes sur le serveur

Tu as ci-dessous le plan de numérotation que tu vas utiliser :

|Poste client|	Numéro de ligne|	Nom|	Mot de passe|
| --- | --- | --- | --- |
|Client 1|	80100|	Ismail Saidi|	1234|
|Client 1|	80101|	 Naomi Rahmani|	1234|



Connecte-toi en web à partir d'un des clients, sur l'adresse 172.16.64.31 du serveur.
Utilise le compte root.

Va dans le menu `Applications` puis `Extensions`, tu arrives sur cette fenêtre :

<img width="1913" height="484" alt="image" src="https://github.com/user-attachments/assets/b5c1b2a4-5bc9-4f0a-86eb-d4f8dec4191d" />

---

Va sur sur l'onglet `SIP [chan_pjsip] Extensions` et clique sur le bouton `+Add New SIP [chan_pjsip] Extension`.


Pour créer la 1ère ligne, celle de Ismail Saidi, renseigne les informations suivante :

User Extension : 80100   
Display Name : Ismail Saidi    
Secret : 1234    
Password For New User : 1234    
Tu dois avoir les informations comme ceci :    

<img width="1810" height="937" alt="image" src="https://github.com/user-attachments/assets/ed7f4aa0-a543-4ed7-83b0-4fc3bae9009e" />



---

Clique sur le bouton Submit puis Apply Config pour enregistrer ton utilisateur.
Tu viens de créer ta première ligne téléphonique !

<img width="1917" height="388" alt="image" src="https://github.com/user-attachments/assets/80016397-e3c4-40dd-8bf0-d2083e489871" />

---

De la même manière, créer les 2 autres lignes.
Tu dois avoir ceci :

<img width="1733" height="182" alt="image" src="https://github.com/user-attachments/assets/e8c15582-4521-42b9-bbb8-8700d587c021" />

---

#  Installation du logiciel SIP sur les postes clients

Prendre la source [ici](https://3cxphone.software.informer.com/download/).   
Télécharge la version x86/x64 sur le site de et installe-là sur les 2 clients Windows.    

<img width="838" height="149" alt="image" src="https://github.com/user-attachments/assets/07e22560-efe2-49c1-9f72-ae70bd431c81" />

---

<img width="969" height="203" alt="image" src="https://github.com/user-attachments/assets/7d062df8-c57b-491e-a427-f5a63458eb0c" />

---

# Configuration du logiciel SIP

Sur le poste client 1, va dans le menu démarrer et cherche le logiciel 3CX Phone pour l'éxecuter.

<img width="189" height="152" alt="image" src="https://github.com/user-attachments/assets/0e6378cc-2bba-484e-ba9e-acaa0dcdc84b" />

---

Sur l'écran du SIP phone, clique sur Set account pour avoir la fenêtre Accounts.

<img width="259" height="450" alt="image" src="https://github.com/user-attachments/assets/22ac1b5c-de99-4bd2-b036-cf44e40a3f34" />

---

<img width="528" height="369" alt="image" src="https://github.com/user-attachments/assets/f5843188-b9cd-4aef-b18e-d97b78bf2d03" />

---

En cliquant sur New, la fenêtre de création de compte Account settings apparaît :

<img width="575" height="864" alt="creation-user" src="https://github.com/user-attachments/assets/47990e8e-3e19-4d60-b0f4-1424549dfcb5" />

---

Pour configurer la ligne de l'utilisatrice Marie Dupont, rentre les informations comme ceci :

**Account Name** : Ismail Saidi
**Caller ID** : 80100
**Extension** : 80100
**ID** : 80100
**Password** : 1234
I am in the office - local IP : l'adresse IP du serveur soit 172.16.64.31
Clique sur Ok tu dois avoir cette fenêtre :

<img width="776" height="540" alt="user-cree" src="https://github.com/user-attachments/assets/b05e937a-32c9-467c-8f27-73026e9cd7ac" />

---

De la même manière, configure la ligne pour **Naomi Rahmani**.

---

# Communication entre les postes

Sur le client 1, tape sur le clavier du SIP phone le numéro 80103 et clique sur la touche d'appel (la touche verte).


<img width="369" height="669" alt="image" src="https://github.com/user-attachments/assets/5e294d7f-0f39-4cef-aed4-45e4b3fddf5b" />


---

Sur le client 2 on voit l'appel arriver. On peut répondre en cliquant sur le bouton vert ou refuser l'appel en cliquant sur le bouton rouge.

<img width="364" height="672" alt="image" src="https://github.com/user-attachments/assets/176bcd9f-c3be-4695-9713-1fca7b69fc52" />

---

```
Tu a réussi à faire communiquer tes 2 utilisateurs !
```






















