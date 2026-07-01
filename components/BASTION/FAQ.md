##  Résolution des Incidents (FAQ)
* **Erreur "Upstream Error" (Serveur injoignable) :** La machine cible est éteinte sur Proxmox VE, le service distant (sshd/rdp) a planté, ou une règle de filtrage ACL sur le pare-feu pfSense bloque le flux sortant depuis l'IP du Bastion.

---

# FAQ 1

## L'interface Web de Guacamole affiche une erreur 500 ou ne charge pas.

Que faire ?    
L'interface Web dépend directement du serveur applicatif Tomcat et du démon de liaison.    

**Étapes de diagnostic :**

## 1 Vérifiez le statut des services essentiels dans le conteneur LXC :

```
sudo systemctl status tomcat9
sudo systemctl status guacd
```
## 2 Si un service est arrêté, redémarrez-le :    

`sudo systemctl restart tomcat9 guacd`    

## 3 Consultez les journaux d'erreurs de Tomcat pour identifier un problème de corruption de fichier .war ou de mémoire :   

`sudo tail -n 100 /var/log/tomcat9/catalina.out`    


# FAQ 2

## L'authentification AD/LDAP échoue pour les utilisateurs. Où se situe le blocage ?   

Point de vigilance Identifié : La matrice des flux indique le port 389 (LDAP standard), tandis que le fichier guacamole.properties cible le port 636 avec la méthode ssl. C'est la cause principale d'échec en cas de mauvaise configuration de pfSense ou du certificat.

**Étapes de diagnostic :**   

## Vérification réseau : Testez la connectivité vers le DC principal (172.16.64.3) sur le port configuré :   

`nc -zv 172.16.64.3 636`   

Si le flux est bloqué, vérifiez les règles d'accès sur le pare-feu pfSense (VLAN Bastion vers VLAN DC).    

## Vérification de la configuration : Assurez-vous qu'aucune coquille ne s'est glissée dans /etc/guacamole/guacamole.properties (ex: double tiret sur ap-search-bind--password).   

## Analyse des logs de Guacamole :   

`sudo journalctl -u guacd -n 50`   

# FAQ 3 

## Impossible de joindre un serveur cible en RDP ou en SSH via le Bastion. Pourquoi ?    

Si l'authentification sur le Bastion réussit mais que la session distante ne s'ouvre pas :

- Pour le RDP (Windows Server) : Vérifier que le flux TCP 3389 est ouvert depuis le Bastion vers le serveur cible et que le protocole de chiffrement (NLA) est correctement renseigné dans les paramètres de la connexion Guacamole.

- Pour le SSH (Linux) : Vérifier que la clé asymétrique Ed25519 de 256 bits est correctement déclarée et que l'utilisateur possède les droits appropriés sur la cible. Le port TCP 22 doit être autorisé par pfSense depuis l'IP du Bastion.   

# FAQ 3

## Rollback : Procédures de Retour Arrière   

**Une mise à jour ou une modification de configuration a corrompu le Bastion. Comment effectuer un rollback rapide ?**   

- Restauration manuelle de la configuration (Niveau Fichier)    

Si le problème concerne uniquement le fichier guacamole.properties :   

- Restaurer la sauvegarde locale générée avant modification :   

`sudo cp /etc/guacamole/guacamole.properties.bak /etc/guacamole/guacamole.properties`    

- Redémarrer les services pour appliquer la configuration saine :

`sudo systemctl restart tomcat9 guacd`   






