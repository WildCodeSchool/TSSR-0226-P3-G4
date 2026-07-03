# Guide d'utilisation

## Déploiement de Windows 11

### Préparation de la machine cliente

1. Crée une nouvelle machine virtuelle dans VirtualBox pour le client (CLIENT-W11).
2. Assure-toi que le réseau est configuré sur le même réseau interne que ton serveur WDS.
3. Configure l'ordre de démarrage pour démarrer en premier à partir du réseau (PXE).
4. Démarre la machine virtuelle.

---

### Processus de déploiement

1. La machine cliente démarre via PXE et se connecte au serveur WDS.

<img width="1075" height="659" alt="Capture d&#39;écran 2026-06-26 150439" src="https://github.com/user-attachments/assets/01ef8fbf-5f3a-4d04-8750-fc692b3f5d26" />

---

2. L'assistant de déploiement MDT s'affiche, choisis le français.

<img width="1014" height="760" alt="image" src="https://github.com/user-attachments/assets/55c58936-0dd5-4d8c-93fb-87bdc7f1c065" />

---

3.Renseigne le compte administrateur du serveur SRV-WDS et son mot de passe.    
Nom d'utilisateur : SRV-WDS\Administrateur ou simplement .\Administrateur (pour un compte local sur le serveur SRV-WDS).    
Mot de passe : Le mot de passe de l'administrateur de SRV-WDS.    
Domaine : Laisse ce champ vide ou saisis . ou WORKGROUP si le champ est obligatoire (puisque WDS est en standalone).    

<img width="1019" height="762" alt="image" src="https://github.com/user-attachments/assets/ecd05185-0839-44f8-950e-9fb24d7dc95b" />

---

3. Sélectionne la séquence de tâches pour déployer Windows 11.

<img width="1015" height="760" alt="image" src="https://github.com/user-attachments/assets/65f98112-ade2-4987-b0f8-3be3d8db2e98" />

---

4. Le déploiement commence automatiquement selon les paramètres que tu as configurés.

<img width="1020" height="761" alt="image" src="https://github.com/user-attachments/assets/1d599f21-35ac-4bc4-adee-ab7b298543a6" />

---

5. Une fois le déploiement terminé, la machine redémarre sur Windows 11.

```
Félicitations ! Tu as réussi à mettre en place un serveur de déploiement WDS avec MDT et à déployer Windows 11 via PXE.
```

---
