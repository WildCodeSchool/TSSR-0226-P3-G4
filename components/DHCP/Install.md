# Installer DHCP 
Ouvrir la console DHCP sur xts-411, autoriser le serveur et implémenter les étendues :

Scope [172.16.64.0] DHCP client

Scope [172.16.40.0] Vlan 200

Définir les options d'étendue indispensables :

Option 003 (Routeur) : IP de l'interface pfSense du VLAN concerné.

Option 006 (Serveurs DNS) : Configurer exclusivement l'IP du DC principal 172.16.64.3.

Option 015 (Nom de domaine) : Spécifier la valeur Xtech.green.
