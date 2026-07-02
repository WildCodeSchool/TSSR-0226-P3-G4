# Guide d'Exploitation

Se connecter au site web interne de Xentech : `http://interne.xtech.green`

<img width="1884" height="1064" alt="image" src="https://github.com/user-attachments/assets/1c81e741-2917-4ae2-a934-35e02ec0f278" />

---

Cliquer sur l'onglet `Ticketing GLPI` pour rédiger un ticket sur un poste un client ou accéder au tableau de bord depuis le poste admin T1


<img width="609" height="185" alt="image" src="https://github.com/user-attachments/assets/a84f2ab4-7d2c-4451-9d0c-b19745a355ab" />

---

<img width="1883" height="1064" alt="image" src="https://github.com/user-attachments/assets/92a94ec3-c61b-4ea3-9947-057093fbe603" />

---


Se connecter au site web interne de Xentech : `http://interne.xtech.green`


<img width="1887" height="1069" alt="image" src="https://github.com/user-attachments/assets/bebebe5c-7b71-480c-987d-7ce2114a5238" />

---



## 1. Gestion du Service Web au Quotidien
Pour maintenir et piloter le démon Apache2 sur Debian 13, utilisez les commandes système suivantes :

* **Vérifier l'état d'exécution du serveur :** `systemctl status apache2`
* **Arrêter le serveur web :** `systemctl stop apache2`
* **Démarrer le serveur web :** `systemctl start apache2`
* **Appliquer des modifications de code HTML (sans coupure) :** `systemctl reload apache2`

---

## 2. Maintenance et Mise à Jour des Liens Applicatifs
Pour modifier l'index d'un site (par exemple modifier l'arborescence ou mettre à jour le lien vers le serveur de gestion de parc GLPI), éditez directement le fichier source à la racine :

```bash
# Édition de l'index du site interne
nano /var/www/xtech-interne/index.html
```
