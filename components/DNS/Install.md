# Installer DNS

## Installation et configuration du rôle DHCP

Pour commencer on va ajouter le role DNS sur le serveur Windows 2022 :
- Dans **manage** selectionner **add Roles and features**  
![DNS](components/DNS/Ressources/Manage.png)

- Puis cliquer trois sur **next** jusqu'a arriver a la selection de roles **cocher DNS Server**  
![DNS](components/DNS/Ressources/Coche_DNS.png)

- Puis cliquer deux fois sur **next** jusqu'a arriver a **confirmation** et cliquer sur **install** pour lancer l'installation du role DNS  
![DNS](components/DNS/Ressources/Coche_DNS.png)

Une fois le rôle ajouté, aller dans Tools puis cliquer sur DNS Manager  
![Tools](components/DNS/Ressources/Tools.png)

Puis on choisi DNS.
Une fois dans le DNS manage clic droit sur New Zone et suivre l'assistant pour configurer la nouvelle zone  
![DNS](components/DNS/Ressources/New_Zone_DNS.png)

Créer une première zone et un premier enregistrement A. Servant de base a l'AD  
![DNS]()

Parametrer une zone reverse et des CNAME pour le reseau  
![DNS]()





Ouvrir la console DNS sur xts-411 et vérifier la réplication automatique des zones de recherche directe Xtech.green et inversée 40.16.172.in-addr.arpa sur les trois autres contrôleurs de domaine.

Configurer les enregistrements d'hôtes (A) statiques obligatoires :

mail.xtech.green vers 172.16.64.30

interne.xtech.green vers 172.16.64.50

externe.xtech.green vers 172.16.64.51

support.xtech.green vers 172.16.64.14
