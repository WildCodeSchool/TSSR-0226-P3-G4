# Installation WDS

**Pré requis**

VM Microsoft Windows Server 2022    
Adresse IP fixe du serveur : 172.16.64.54/24    
Nom du serveur : XTSE-420    
Ce serveur dispose de 2 disques de stockage de 32G et 80G    
Partition de type : GPT    
File system : NTFS    
Nom : WDS   

---

## Installation du rôle WDS

**En PowerShell**

Exécuter la commande suivante dans une console PowerShell :

```
Install-WindowsFeature wds-deployment -includemanagementtools
```



**En graphique**


Ouvrir le Service Manager.   
Aller dans Managepuis Add Roles and Features   
Cliquer sur Next    
Sélectionner Role-based or feature-based installation puis Next   
Sélectionner votre serveur et cliquer sur Next   
Choisir le rôle Windows Deployment Service, dans la fenêtre qui apparaît cliquer sur Add features    
Cliquer 4 fois sur Next en laissant les options par défaut    
Cliquer sur Install puis Close    

