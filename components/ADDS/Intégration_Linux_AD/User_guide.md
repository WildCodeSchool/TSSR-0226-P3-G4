# Guide d'Exploitation et Validation des Objectifs

Utiliser ce guide pour valider l'état du système et administrer les accès utilisateurs au quotidien.

## 1. Validation de l'Intégration Active Directory

Vérifier le statut de l'intégration Kerberos de l'hôte Linux :

```
sudo realm list
```

<img width="1793" height="575" alt="image" src="https://github.com/user-attachments/assets/50505d7f-eb94-4ccb-a29e-400ffe78b3ca" />

---

Interroger l'annuaire AD pour valider la lecture d'un groupe de sécurité global :

```
getent group "Domain Admins@xtech.green"
```

<img width="1796" height="105" alt="image" src="https://github.com/user-attachments/assets/4573795b-19ab-4fd9-9360-e9f72bb6ce3d" />

---

Tester la résolution d'identité pour un utilisateur AD spécifique :

```
id isaidi@xtech.green
```

<img width="1801" height="122" alt="image" src="https://github.com/user-attachments/assets/74d880ef-01d3-41a1-96f5-16a1676b0472" />

---

Valider l'ouverture de session interactive PAM et la génération dynamique du dossier Home :

```
su - isaidi@Xtech.green
```

<img width="1798" height="178" alt="image" src="https://github.com/user-attachments/assets/ad57d694-5a82-4efb-8d33-e8e435abb0ba" />

---

## 2. Contrôle Côté Windows Server 

Ouvrir la console "Utilisateurs et ordinateurs Active Directory" sur Windows Server 2022 pour valider la présence de l'objet ordinateur renommé conformément aux conventions de nommage :

Nom de l'hôte : XT-OD3-s1-001-L


<img width="1908" height="490" alt="image" src="https://github.com/user-attachments/assets/95cbecb5-32a8-4b99-b8f3-1595c84fb2e8" />

---

## 3. Application et Rafraîchissement des GPO Ubuntu

Déclencher manuellement la mise à jour des stratégies de groupe configurées via Adsys depuis la console Windows :

```
adsysctl update -v
```



