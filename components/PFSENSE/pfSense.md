# Sommaire
[]()
[]()
[]()
[]()

# 1. Role du service
**pfSense** est un **pare-feu** (firewall) et un **routeur open source et gratuit**, basé sur le système FreeBSD. Son rôle est de filtrer ce qui entre et sort du réseau pour le protéger, mais il fait bien plus qu'un simple pare-feu : il gère aussi le routage entre réseaux, peut faire serveur DHCP et DNS, monter des VPN (pour se connecter à distance de façon sécurisée), faire du NAT, de la répartition de charge, et s'enrichir de modules (comme un anti-intrusion ou un proxy). Le tout se pilote via une interface web claire, ce qui en fait une solution très répandue pour remplacer un boîtier pare-feu commercial à moindre coût, aussi bien en PME qu'en lab.

# 2. Prérequis
- Une machine (ou VM) avec au minimum deux interfaces réseau : une pour le WAN et une pour le LAN.
- Des ressources matérielles modestes suffisent pour un usage simple pas besopin de beaucoup de RAM ni d'un gros disque, mais on peut l'augmenter si on active des modules lourds.
- Un support d'installation (image ISO de pfSense) et un accès à la console pour la configuration initiale.
- Une bonne séparation des réseaux : le WAN et le LAN ne doivent pas être sur le même sous-réseau, sinon conflit.
- Un plan d'adressage défini : savoir quelle plage IP utiliser côté LAN, quelle passerelle, etc.
- Un navigateur web depuis un poste du LAN pour accéder à l'interface d'administration une fois l'installation faite.

# 3. Informations Techniques
OS :  
IP :  
Gateway :  

# 4. Documentation Associée
