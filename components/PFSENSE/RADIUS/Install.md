# Guide d'nnstallation Radius

**Pré-requis :**     

**VM: pfSense**    
**CPU: 1 Core**    
**RAM: 1G**    
**Stockage: 15G**       
**Carte réseau: 3**      

---

## Installation du package FreeRadius

Nous utiliserons pfSense pour configurer notre serveur FreeRadius.   
Installer pfSense dans une machine virtuelle ici : **[pfSense](https://www.pfsense.org/download/)**    

Installer le package nécessaire pour faire configurer et faire fonctionner notre serveur FreeRadius, allons dans pfSense dans Système et ensuite dans Gestionnaire de paquets.

<img width="1707" height="893" alt="01" src="https://github.com/user-attachments/assets/61aa2c84-c134-4d31-8423-1319b5a7c042" />

---

Il suffit simplement de taper dans la barre de recherche, le nom du paquet qu'on souhaite installer, dans notre cas ça sera freeradius et ensuite de cliquer sur le bouton Install pour installer le paquet en question.

<img width="1708" height="620" alt="02" src="https://github.com/user-attachments/assets/5ac57011-dc9d-434c-ad14-de7ea2668ecc" />

---

<img width="1705" height="864" alt="03" src="https://github.com/user-attachments/assets/fc535848-e21b-48a5-a137-5da992ac1e04" />

---

## Configuration du serveur FreeRadius

Une fois que le package a été installé avec succès, il suffit de partir dans Service, FreeRadius, et enfin de partir sur Interface.

Nous ajouterons une nouvelle interface pour configurer le serveur FreeRadius. Basiquement, dans l'interface IP, il y a une étoile (*), cela signifie toutes les interfaces de la machine. Personnellement, j'ai mis l'adresse du LAN `172.16.64.254`. J'ai également mis une description à ma nouvelle configuration pour FreeRadius, et le port par défaut est 1812. Enregistrons la configuration.

<img width="1702" height="860" alt="04" src="https://github.com/user-attachments/assets/510e21ca-d4cf-4a80-96aa-3d9aa17cb3cf" />

---

<img width="1712" height="869" alt="image" src="https://github.com/user-attachments/assets/63bad212-9cef-40bd-8398-cd16d559ef53" />

---

<img width="1707" height="365" alt="image" src="https://github.com/user-attachments/assets/0c9bd34d-0723-4a5b-a891-1a6aab244f3c" />

---

## Configuration du client pour FreeRadius

Il suffit maintenant de partir dans NAS / Clients et d'ajouter un nouveau client à notre serveur. J'ai mis à nouveau l'adresse du LAN `172.16.64.254`, ainsi un shortname, et ce mot de passe. Il s'agit du secret partagé (mot de passe) dont le NAS (commutateur, point d'accès, etc.) a besoin pour communiquer avec le serveur RADIUS. FreeRADIUS est limité à 31 caractères pour le secret partagé. Ensuite, il suffit d'enregistrer la configuration.

<img width="1699" height="694" alt="05" src="https://github.com/user-attachments/assets/c56099e2-a234-41d4-9861-d8ed85c724d7" />

---

<img width="1705" height="365" alt="image" src="https://github.com/user-attachments/assets/ba1e37e6-c49d-4593-8885-aa64ecb8c23a" />

---

## Création d'utilisateur pour le client

Pour qu'un client ait accès au serveur WEB, il doit avoir des informations d'identifications, donc, allons dans la partie FreeRadius et ensuite Users.

<img width="1711" height="518" alt="image" src="https://github.com/user-attachments/assets/c4ca9368-610f-4d3f-8df8-8ac1fe8178d3" />

---

Cliquons sur Ajouter, nous ajouterons un utilisateur dans le serveur FreeRadius. Il suffit simplement de mettre le nom d'utilisateur, et le mot de passe. Nous pouvons sauvegarder la configuration.

<img width="1712" height="525" alt="image" src="https://github.com/user-attachments/assets/09c0b7ad-ae99-4089-9538-68c51ace7d4a" />

---

## Configuration de la méthode d'authentification

Nous devons ensuite configurer la méthode d'authentification du serveur. Il suffit simplement d'aller dans Système, Gestionnaire d'usages, et sur Serveur d'authentification. Ensuite, il suffira simplement d'ajouter une nouvelle méthode d'authentification.


<img width="1700" height="895" alt="07" src="https://github.com/user-attachments/assets/7349c0df-0872-4ab6-8b07-627be442e41b" />

---

Nous mettrons un nom descriptif. Par la suite, nous choisirons le protocole RADIUS (ce qui est logique). Ensuite, nous choisissons le protocole PAP car il est plus facile à mettre en place que les autres (mais moins safe). Par la suite nous mettrons l'adresse du LAN `172.16.64.254` Il est également important de mettre le secret partagé, et le plus important tout en bas est l'interface. Choisis la bonne interface, c'est généralement le réseau local LAN. Nous pouvons ensuite sauvegarder la configuration.

<img width="1705" height="298" alt="08" src="https://github.com/user-attachments/assets/58f30f6b-77bb-413c-b5d3-17a1d8570dbd" />

---

## Création et configuration du Portail Captif

Il nous reste encore une dernière chose à faire, c'est de mettre en place le système Portail Captif. Il suffit ensuite d'aller Services et sur Portail Captif. Nous ajouterons une nouvelle zone de portail captif, donc cliquons sur Ajouter.

Il suffit simplement d'activer le Portail Captif, et de sélectionner l'interface (c'est généralement le LAN).

<img width="1702" height="818" alt="09" src="https://github.com/user-attachments/assets/ad61e911-f57c-49ec-9864-60cb0935a1a0" />

---






