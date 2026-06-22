# DHCP
## 1. Role du service

Son role principal est d'assurer la configuration automatique des paramètres réseau sur les equipements connectés pour eliminer une intervention manuelle:
- Attribution automatique et dynamique d'une adresse IP unique et du masque de sous-réseau.
- Fournir les paramètres essentiels comme l'adresse de la passerelle par défault et les services lié au DNS.
- Faire respecter l'architecture mise en place.
- Réduction des erreurs (pas de conflis d'IP en manuelle)
- Gain de temps importants (automatisation et centralisation)

## 2. Architecture 

Serveurs principal(GUI): XTSE-410 -> aussi AD et DNS  
Serveur backup (Core): XTSE-412

## 3. Information Technique

- Serveurs : **Principal** Windows Server 2022 , **Secondaire** Core 
- Adressage IP statique sur les deux serveurs
- Possibilité d'acceder aux scopes VLAN depuis les deux serveurs

## 4. Documentation associé
