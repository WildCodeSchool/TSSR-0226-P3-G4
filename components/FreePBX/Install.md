# Installation de FreePBX

Étape 1 - Prérequis 

- Template : SNG PBX     
- CPU : 1 core   
- RAM : 2G    
- Stockage : 20G    
- Type de conteneur : Non-privilégié (Unprivileged: Yes)    
- Décocher Firewall
- Un softphone 3CX installé sur chaque VM

Le labo a été testé avec les OS Windows Server 2022, Windows 11, et FreePBX qui tourne sur une distribution Red Hat. Les VM fonctionnent sur Proxmox VE.


Étape 2 - Création de lignes

Sur l'IPBX, créer les lignes suivantes et configure-les sur les machines correspondantes :   


| Poste client	| Numéro de ligne	| Nom	| Mot de passe |
| ---       | ---                 | ---   | ---          |
| Client 1	| 33101 |	Stéphanie Morin	| 1234 |
| Client 2	| 33102	| Joël Lerobillard	| 1234 |
| Client 3  |	33103	| Jean Kyrin	| 1234 |    

Pour rappel :

Connecte toi sur FreePBX en web
Vas dans Applications -> Extensions pour créer les comptes SIP   


