#### Cette documentation détaille la configuration complète de l'infrastructure réseau, du plan d'adressage et de la politique de filtrage Zero Trust sur le pare-feu pfSense pour l'entreprise **XTech**.

--------

## Réseau Xtech : `172.16.64.0/19`

**Plage couverte : `172.16.64.0` → `172.16.95.255` (32 sous-réseaux en `/24` `.64` à `.95`)**

### Plan d'adressage  — 25 départements de l'entreprise

| VLAN ID | Nom              | Réseau /24       | Passerelle pfSense | Rôle                                 |
| ------- | ---------------- | ---------------- | ------------------ | ------------------------------------ |
| 10      | AD               | `172.16.65.0/24` | `172.16.65.254`    | DC, DNS, DHCP, CORE                  |
| 20      | APPS             | `172.16.66.0/24` | `172.16.66.254`    | GLPI, PRTG, Syslog, FILES, WDS, WSUS, FreePBX, OpenProject   |
| 30      | BACKUP           | `172.16.67.0/24` | `172.16.67.254`    | BKP Linux RAID5,                     |
| 50      | WEB-INT          | `172.16.68.0/24` | `172.16.68.254`    | Site web interne                     |
| 60      | BASTION          | `172.16.69.0/24` | `172.16.69.254`    | Bastion Guacamole                    |
| 70      | JUMP             | `172.16.70.0/24` | `172.16.70.254`    | Jump server                          |
| 100     | DMZ              | `172.16.71.0/24` | `172.16.71.254`    | WEB externe, Messagerie : iRedMail   |
| 200     | VPN              | `172.16.72.0/24` | `172.16.72.254`    | Pool télétravail                     |
| 41      | RH               | `172.16.73.0/24` | `172.16.73.254`    | Isolé renforcé                       |
| 42      | COMMUNICATION    | `172.16.74.0/24` | `172.16.74.254`    | DEPT Standard                        |
| 43      | COMMERCIAL       | `172.16.75.0/24` | `172.16.75.254`    | DEPT Standard                        |
| 44      | FINANCE          | `172.16.76.0/24` | `172.16.76.254`    | Isolé renforcé                       |
| 45      | MARKETING        | `172.16.77.0/24` | `172.16.77.254`    | DEPT Standard                        |
| 46      | DÉVELOPPEMENT    | `172.16.78.0/24` | `172.16.78.254`    | DEPT Standard                        |
| 47      | R&D              | `172.16.79.0/24` | `172.16.79.254`    | DEPT Standard                        |
| 48      | SERVICE GENERAUX | `172.16.80.0/24` | `172.16.80.254`    | DEPT Standard                        |
| 49      | JURIDIQUE        | `172.16.81.0/24` | `172.16.81.254`    | Isolé renforcé                       |
| 51      | DIRECTION        | `172.16.82.0/24` | `172.16.82.254`    | Isolé renforcé                       |
| 52      | DSI              | `172.16.83.0/24` | `172.16.83.254`    | Isolé renforcé                       |
| 90      | WIFI-ENTREPRISE  | `172.16.84.0/24` | `172.16.84.254`    |                                      |
| 99      | WIFI-GUEST       | `172.16.85.0/24` | `172.16.85.254`    |                                      |
| 300     | MGMT-T0          | `172.16.86.0/24` | `172.16.86.254`    | LAN management T0                    |
| 301     | MGMT-T1          | `172.16.87.0/24` | `172.16.87.254`    | LAN management T1                    |
| 302     | MGMT-T2          | `172.16.88.254`  | `172.16.88.254`    | LAN management T2                    |


---






### Étape 1 — Reconfigurer le LAN de pfSense (em1)
 

<img width="998" height="426" alt="pfSense-LAN" src="https://github.com/user-attachments/assets/bcfa4a82-7967-4ca1-b303-a5c2f90c71ab" />

---

Dans la **console**, menu principal → option `2` (Set interface IP address) : 

<img width="1102" height="285" alt="image" src="https://github.com/user-attachments/assets/50e5cfd6-fbc7-49f9-b988-046ab448a2ff" />


---

Enter the number of the interface you wish to configure: `2` (LAN)  

<img width="1098" height="612" alt="image" src="https://github.com/user-attachments/assets/d61d6b2d-18db-4aca-9645-5306fc93c607" />

---

Configure IPv4 via DHCP? `n`  
Enter the new LAN IPv4 address: `172.16.64.254`  
Subnet bit count: `24`  
Upstream gateway: `ENTRÉE`    
IPv6 ? `n`  

<img width="1104" height="576" alt="image" src="https://github.com/user-attachments/assets/b39b18e6-506d-45ee-893b-b8991f0c4c0c" />

---

Enable DHCP server on LAN? `n`  
Revert to HTTP? `n`  

<img width="1100" height="504" alt="image" src="https://github.com/user-attachments/assets/4e46c072-70de-4731-8079-f26ddc633b3d" />

---





### Étape 2 — Reconnecter ton PC admin

**Sur Proxmox**, VM 449 → Hardware → Network Device (net0) :

- Bridge :  `vmbr400`
- VLAN Tag : **vide** 

**Puis sur le PC admin (T1) :**            
IP statique : `172.16.64.10/24`        
Passerelle `172.16.64.254`    

<img width="529" height="121" alt="image" src="https://github.com/user-attachments/assets/5ee056dc-3efd-43de-86cf-d8414611e014" />

---

### Étape 3 — Accéder à ton nouveau pfSense

```
https://172.16.64.254
```

 <img width="1873" height="1059" alt="Capture d&#39;écran 2026-07-02 202001" src="https://github.com/user-attachments/assets/a7123900-209d-43a7-ab6f-58c526dd6d45" />


 ---


### Setup Wizard pfSense

- **Bienvenue** → Next

<img width="1842" height="681" alt="Capture d&#39;écran 2026-07-02 202122" src="https://github.com/user-attachments/assets/cd5a2926-7a43-40c9-ac43-c2f098682e71" />

---

- **General Information** :
    - Hostname : `pfSense-XTech`
    - Domain : `xtech.green`
    - DNS Server 1 : vide pour l'instant (pas encore de WAN fonctionnel, à configur après que l'AD soit raccordé)
    - Décocher **"Override DNS"** pour forcer les DNS
 
<img width="1676" height="1011" alt="image" src="https://github.com/user-attachments/assets/c2d75daf-c2a6-4a6e-9b91-19bb75e08002" />

---
    
- **Time Server** : Timezone `Europe/Paris`


<img width="1706" height="516" alt="image" src="https://github.com/user-attachments/assets/5023e164-9d7e-4ca5-a0c6-a24cea2bb36f" />

---



- **WAN Configuration** :
    - Type : `Static` (On utilise le DHCP du serveur AD sinon les pc seront en APIPA (169.254.x.x)
    - IP Adress : 10.0.0.4 (WAN)
    - Subnet Mask : 28
 
<img width="1675" height="989" alt="image" src="https://github.com/user-attachments/assets/71e4f25c-d32a-4756-a0df-b50539b079ff" />

---


 - pptplocalsubnet : 32
 - Décocher "Block private networks" **temporairement** si jamais le WAN passe par une IP privée (`10.0.0.4/8`) — sinon pfSense bloquera notre propre WAN
 - Décocher "Block bogon networks" 

    
<img width="1660" height="803" alt="image" src="https://github.com/user-attachments/assets/867d00c9-54e5-4b62-a4b2-5d4452526030" />

---

- **LAN Configuration** :
    - IP : `172.16.64.254`
    - Subnet : `24`

<img width="1717" height="520" alt="image" src="https://github.com/user-attachments/assets/30dfb898-d887-42f9-9e89-548a12ed81c1" />

---


    
- **Set Admin Password** : `******`
- **Reload** → **Finish**

<img width="1694" height="492" alt="image" src="https://github.com/user-attachments/assets/8ab81a97-3c72-440d-a1e8-9b4342a79424" />

---
  


