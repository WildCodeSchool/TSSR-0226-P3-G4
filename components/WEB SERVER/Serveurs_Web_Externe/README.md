# Sommaire

1.  [1. Role du service](#1-Role-du-service)
2.  [2. Position dans l'architecture](#2-Position-dans-lrchitecture)
3.  [3. Prérequis](#3-Prérequis)
4.  [4. Documentation associé](#4-Documentation-Associé)

---
# 1. Role du service
Un serveur **web externe** est un serveur qui **héberge** des sites ou applications web accessibles depuis Internet, c'est-à-dire par des utilisateurs situés **en dehors** du réseau de l'entreprise. Son rôle est de publier des **ressources web vers l'extérieur** : par exemple le site vitrine de l'entreprise, un portail client, une boutique en ligne ou une application accessible à distance. Le fonctionnement est le même qu'un serveur web interne (il renvoie les pages demandées via un navigateur), mais la grande différence est l'exposition à Internet, ce qui implique des enjeux de **sécurité** bien plus importants : étant visible de tous, il est davantage exposé aux attaques. On le place donc généralement dans **une zone isolée** du réseau appelée **DMZ** (zone démilitarisée), séparée du réseau interne par le pare-feu, afin qu'une **compromission du serveur web** ne donne **pas accès au reste de l'infrastructure**. Les logiciels sont les mêmes qu'en interne (Apache, Nginx, IIS).

---
# 2. Position dans l'architecture
### Serveur Web Externe
- Nom du serveur : **XTSE-X**
- Adresse IP : **172.16.64.X**
- Gateway : **172.16.64.254**

---
# 3. Prérequis 
- Une machine (ou VM) sous Linux ou Windows Server avec un logiciel serveur web (Apache, Nginx ou IIS).
- Une adresse IP publique (ou une redirection de ports depuis le pare-feu) pour être joignable depuis Internet.
- Un nom de domaine public enregistré (ex. www.xtech.green) avec les enregistrements DNS correspondants (A/AAAA) gérés par un registrar.
- Un placement en DMZ : le serveur doit être isolé du réseau interne par le pare-feu pour des raisons de sécurité.
- Un certificat SSL/TLS (idéalement signé par une autorité reconnue, type Let's Encrypt) pour le HTTPS, indispensable sur un service public.
- Les ports ouverts/redirigés au niveau du pare-feu : 80 (HTTP) et 443 (HTTPS) vers le serveur en DMZ, et uniquement ceux-ci (limiter l'exposition).
- Des mesures de sécurité renforcées : pare-feu bien configuré, mises à jour à jour, éventuellement un WAF (pare-feu applicatif) ou un reverse proxy en frontal.
- Des ressources adaptées à la charge attendue (le trafic externe peut être plus important et imprévisible).

---
# 4. Documentation


