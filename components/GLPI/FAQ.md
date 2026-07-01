## FAQ 1

Que faire si le DNS `support.xtech.green` ne fonctionne pas ?

<img width="1096" height="692" alt="Capture d&#39;écran 2026-07-01 194053" src="https://github.com/user-attachments/assets/488801fa-4f81-44c9-ae37-c7aeeac30f15" />

---

Sur le CT Debian 12 LAMP, vérifier que le fichier `support.xentech.green.conf` est activé (couleur cyan) et non désactivé (couleur)

Chemin : `cd /etc/apache2/sites-enable`
Taper : `ls`

<img width="1190" height="120" alt="image" src="https://github.com/user-attachments/assets/8d60034e-e933-4acb-ac72-79e00d43fff5" />

Comme on peut le voir, le fichier est rouge et s'appelle `support.xtech.fr.conf`   
Que s'est-il passé ?   
J'ai renommé ce fichier `support.xtech.fr.conf` par `support.xtech.green.conf`   
J'ai bien activé le nouveau fichier `support.xtech.green.conf` avec la cmdlet : `a2ensite support.xtech.green.conf`    
mais j'ai oublié de supprimer : `support.xtech.fr.conf`    

Il faut supprimer l'ancien fichier `rm support.xtech.fr.conf`    
Relancer le système pour activer la nouvelle configuration :    
`systemctl reload apache2`   
`a2ensite support.xtech.green.conf`   

<img width="1650" height="279" alt="image" src="https://github.com/user-attachments/assets/3084779f-9b44-4de9-ac60-ed974ffdeb5d" />

---

Une fois que le fichier redevient bleu cyan

On active le serveur Apache2 et tout rentrera dans l'ordre, le DNS fonctionnera   

`systemctl restart apache2`
`systemctl status apache2`

<img width="1637" height="1136" alt="image" src="https://github.com/user-attachments/assets/67bb1862-057c-4189-a472-c9e4dea24ff3" />

---

http://support.xtech.green


<img width="1882" height="1050" alt="image" src="https://github.com/user-attachments/assets/0cce171e-f389-49af-b08f-31a6ec045aae" />


---


# FAQ 2 

Que faire si le DNS `support.xtech.green` ne fonctionne pas alors que le fichier `support.xtech.green` est bleu cyan que le status apache2 et mariadb sont activés vert ?


<img width="1096" height="692" alt="Capture d&#39;écran 2026-07-01 194053" src="https://github.com/user-attachments/assets/2ce4f9f8-6634-4955-83bc-4972771dbcbf" />

---

Sur le PC-admin sur lequel le DNS ne fonctionne pas, dans PowerShell taper cette cmdlet : `nslookup support.xtech.green`

<img width="1349" height="464" alt="Capture d&#39;écran 2026-07-01 200413" src="https://github.com/user-attachments/assets/f08374d0-7513-4d78-afb4-50e1b8d8b0d6" />

---

taper la cmdlet : `ncpa.cpl`

<img width="593" height="677" alt="Capture d&#39;écran 2026-07-01 203445" src="https://github.com/user-attachments/assets/29d8b1fa-57af-44fc-806f-ee4cb5b74f17" />


---

On remarque une incohérence d'adresse IP, le DNS du serveur est : `172.16.64.3` et non `172.16.40.3`


<img width="1874" height="759" alt="Capture d&#39;écran 2026-07-01 200213" src="https://github.com/user-attachments/assets/aebafe17-02ff-4cdd-bda9-7f94622d9caa" />

---

Modifier le DNS puis vérifier `nslookup support.xtech.green`

<img width="1662" height="239" alt="image" src="https://github.com/user-attachments/assets/ff20cd96-d53d-4405-ba9a-0adeda9d6c27" />

---

<img width="1548" height="1056" alt="image" src="https://github.com/user-attachments/assets/98970e18-d5e7-407a-8d85-c468f9a527ea" />

Problème réglé !






