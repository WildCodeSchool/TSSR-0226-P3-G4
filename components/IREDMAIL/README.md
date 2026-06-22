# Sommaire

1.  [Role du service](#-1-Role-du-service)
2.  [Position dans l'architecture](#2-Position-dans-lrchitecture)
    - [2.1 Serveur Principal](#21-Serveur-Principal)
    - [2.2 Serveur Backup](#-22-Serveur-Backup)
3.  [Prérequis](#3-Prérequis)
    - [3.1 Pour le Serveur](#-31-Pour-le-Serveur)
    - [3.2 Pour le client](#-32-Pour-le-client)
4.  [Documentation associé](4-Documentation-Associé)

---
# 1. Role du service
**IRedMail** est une solution **gratuite** et **open source** qui permet de monter facilement son **propre** serveur de messagerie (e-mails) sur une machine **Linux**. Au lieu de passer par un service comme Gmail ou Outlook, on **héberge soi-même** ses adresses mail et son courrier. **IRedMail installe et configure tout automatiquement** : la partie qui envoie les mails, celle qui les reçoit, un filtre anti-spam et anti-virus, ainsi qu'une interface web (webmail) pour consulter ses mails depuis un navigateur et une console pour gérer les comptes et les domaines. Bref, il évite de devoir **tout** paramétrer à la main.

---
# 2. Position dans l'architecture

### 2.1 Serveur **Principal**: 
- Nom du serveur : ****
- Adresse IP : ****
- Gateway : ****

### 2.2 Serveur **Backup** :
- Nom du serveur : ****
- Adresse IP : ****
- Gateway : ****

---
# 3. Prérequis 
- Une machine Linux fraîchement installée, dédiée uniquement à ça (rien d'autre dessus pour éviter tout conflit possible).
- Une adresse IP fixe, et une IP publique propre si le serveur doit envoyer des mails vers l'extérieur.
- Un nom complet pour le serveur (ex. mail.xtech.green).
- Enregistrements DNS à créer pour que les mails arrivent et soient considérés comme légitimes (MX et SPF pour ne pas finir en spam).
- Assez de mémoire et d'espace disque car l'anti-virus consomme pas mal de ressources.
- Les bons ports ouverts sur le réseau/pare-feu pour laisser passer les mails et l'accès au webmail.
- Un accès administrateur (root) pour lancer l'installation.

---
# 4. Documentation


