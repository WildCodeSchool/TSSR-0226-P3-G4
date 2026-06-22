# Sommaire

1.  [1. Role du service](#1-Role-du-service)
2.  [2. Position dans l'architecture](#2-Position-dans-lrchitecture)
    - [2.1 Serveur Principal](#21-Serveur-Principal)
    - [2.2 Serveur Backup](#22-Serveur-Backup)
3.  [3. Prérequis](#3-Prérequis)
    - [3.1 Pour le Serveur](#31-Pour-le-Serveur)
    - [3.2 Pour le client](#32-Pour-le-client)
4.  [4. Documentation associé](#4-Documentation-Associé)

---
# 1. Role du service
Un serveur web interne est un serveur qui héberge des sites ou applications web accessibles uniquement depuis le réseau local de l'entreprise, et non depuis Internet. Son rôle est de mettre à disposition des ressources web en interne : par exemple un intranet, un portail d'entreprise, une application métier, une documentation, ou l'interface d'administration d'un outil. Quand un utilisateur du réseau tape l'adresse dans son navigateur, le serveur web lui renvoie les pages demandées. L'intérêt d'un serveur interne est qu'il reste privé et sécurisé (non exposé à l'extérieur), ce qui convient bien aux outils réservés aux employés. Les logiciels les plus courants pour assurer ce rôle sont Apache et Nginx sous Linux, ou IIS sous Windows Server.

---
# 2. Position dans l'architecture

### 2.1 Serveur **Principal**: 
- Nom du serveur : ****
- Adresse IP : ****
- Gateway : ****

---
# 3. Prérequis 
Une machine (ou VM) sous Linux ou Windows Server pour héberger le service.
Un logiciel serveur web installé : Apache, Nginx ou IIS selon l'environnement.
Une adresse IP fixe pour que le serveur reste joignable de façon stable.
Un nom dans le DNS interne (ex. intranet.xtech.green) pour que les utilisateurs accèdent au site par un nom plutôt que par une adresse IP.
Les ports ouverts nécessaires : 80 (HTTP) et/ou 443 (HTTPS) sur le pare-feu local.
Un certificat (idéalement) pour activer le HTTPS et chiffrer les échanges, même en interne.
Des ressources adaptées à l'application hébergée (un simple site statique demande peu, une application métier davantage).
Les contenus ou l'application web à publier, déposés dans le répertoire prévu par le serveur web.

---
# 4. Documentation


