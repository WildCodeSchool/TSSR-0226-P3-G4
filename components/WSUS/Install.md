# Installation WSUS

Pré-requis

Un hyperviseur comme Virtualbox/Proxmox  pour pouvoir créer des VM  
1 VM XTSE-419 avec Windows Server 2022 installé et mise à jour, avec :   
Un espace libre et non-configuré (sur une partition ou un disque) d'au moins 20 Go  
Une carte réseau en Réseau interne avec l'adresse IP 172.16.10.10/24   

---

# 1 Installation et configuration de WSUS

## 1.1 Création de la partition de stockage des mises à jour   

Créer une partition formaté avec un espace de 20 Go qui se nomme `WSUS`.   
Sur cette partition, créer un dossier `WSUS`   

<img width="677" height="462" alt="creation-partition-shrink-volume-C" src="https://github.com/user-attachments/assets/818dbc68-b891-4627-82e3-8ca5ba395268" />

---

<img width="746" height="587" alt="20G" src="https://github.com/user-attachments/assets/08affbe5-64ae-4bf2-8d85-7129abe7644a" />

---

<img width="406" height="194" alt="WSUS-20G" src="https://github.com/user-attachments/assets/92185b89-bb98-4c72-a811-7afe4f2462e3" />


---

<img width="968" height="348" alt="image" src="https://github.com/user-attachments/assets/ba86ec25-a3fa-47c3-8a6d-c03927a3fb59" />

---

## 1.2 Installation du rôle WSUS

À partir du Server Manager, installe le rôle Windows Server Update Services.
Valide les fonctionnalités supplémentaires qui vont s'ajouter automatiquement.
Ensuite, sélectionne `WID Connectivity` et `WSUS Service`.
Indique le dossier que tu as créer pour l'emplacement du stockage des mises à jour.
Termine l'installation et redémarre le serveur.

<img width="1175" height="837" alt="WSUS-SRV" src="https://github.com/user-attachments/assets/b1199133-b65c-4f77-a732-09ed108c315c" />

---

<img width="1174" height="835" alt="image" src="https://github.com/user-attachments/assets/ed08683d-e804-490d-9567-18cab99f572b" />

---

<img width="1174" height="835" alt="path-WSUS" src="https://github.com/user-attachments/assets/bfdcb3af-20c4-4282-8510-9ef70ec22c80" />


---


