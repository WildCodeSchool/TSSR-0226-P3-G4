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

