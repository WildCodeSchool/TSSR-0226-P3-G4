# Sommaire




---
# 1. Role du service

PRTG Network Monitor est une solution de supervision (monitoring) réseau et infrastructure. Son but est de surveiller en continu l'état, la disponibilité et les performances de tout ce qui compose un système d'information, et alerter dès qu'un problème survient — idéalement avant que l'utilisateur ne s'en aperçoive. Son unité de base c'est le capteur il ne surveille qu'un seul aspect mesurable d'un équipement.

# 2. Prérequis
### Côté serveur PRTG

- OS Windows : PRTG s'installe sur Windows Server (recommandé) ou Windows 10/11. Pas de version Linux native pour le core.
- Adresse IP fixe : indispensable pour que les sondes et l'interface web restent joignables.
- Ressources matérielles suffisantes selon le nombre de capteurs (RAM/CPU/disque montent avec le nombre de sensors surveillés).
- Accès réseau vers les équipements supervisés : routes correctes, pas de firewall bloquant les protocoles de monitoring.
- Ports ouverts : accès web (par défaut 80/443) pour la console d'administration.
- Licence (gratuite jusqu'à 100 capteurs, payante au-delà).

### Côté équipements à superviser

Selon ce qu'on veut faire remonter, il faut activer le bon protocole sur la cible :

- SNMP activé et community string connue (supervision de switchs, routeurs, serveurs) — le plus courant.
- WMI activé + compte avec droits (pour superviser des machines Windows : CPU, RAM, disque, services).
- Ping/ICMP autorisé pour les capteurs de disponibilité basiques.
- NetFlow/sFlow/jFlow configuré sur l'équipement si tu veux analyser le trafic.
- Comptes d'accès valides renseignés dans PRTG (identifiants WMI, SNMP, SSH selon la cible).
- Connectivité et ports ouverts selon le protocole : SNMP 161/162 UDP, WMI (RPC 135 + plage dynamique), ICMP, etc.

# 3. Information détaillé


# 4. Documentation associé
