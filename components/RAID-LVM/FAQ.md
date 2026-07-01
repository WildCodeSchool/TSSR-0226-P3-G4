## Résolution des Problèmes Récurrents (FAQ)

# FAQ 1

Le serveur Linux refuse de démarrer et bascule sur l'invite "Emergency Mode" ?

Cause : Un des disques est absent et le fichier /etc/fstab bloque le démarrage car il n'arrive pas à monter /mnt/BKP.

<img width="1617" height="568" alt="Capture d&#39;écran 2026-07-01 220922" src="https://github.com/user-attachments/assets/7f362e4e-6b58-44b4-ad54-e0159605b5a6" />

---


Solution : Entrez le mot de passe root dans la console de secours, éditez le fichier avec nano /etc/fstab, commentez la ligne du montage LVM en ajoutant un # au début, puis redémarrez (reboot). Une fois la machine lancée, réparez le RAID, puis réactivez la ligne dans /etc/fstab.


---

# FAQ 2

**Etendre le LV de 45 à 60G**   

### Etape 1 : Ajouter un disque de 15G et injecter le disque dans la matrice RAID 5   

---

### Etape 2 : Déclarer le disque /dev/sdf comme un membre disponible pour notre grappe /dev/md0 :   

`sudo mdadm --manage /dev/md0 --add /dev/sdf`   

<img width="1648" height="96" alt="image" src="https://github.com/user-attachments/assets/b2105ee8-c0b8-4476-bedd-435b524e6402" />

---

### Étape 3 : Demander au RAID 5 de grandir (Grow)

Actuellement, notre RAID 5 est configuré pour utiliser 4 disques actifs. On va lui ordonner de passer à 5 disques actifs pour intégrer /dev/sdf et ainsi recalculer la parité sur l'ensemble :

`sudo mdadm --grow /dev/md0 --raid-devices=5`

<img width="1657" height="67" alt="image" src="https://github.com/user-attachments/assets/541277bf-b1a6-40f5-8f49-497eb79a519e" />


---
Suivre la reconstruction !
Le processeur va recalculer les blocs de parité pour étaler les données sur les 5 disques. Cette étape prend du temps. Il faut attendre qu'elle soit terminée à 100 % avant de passer à la suite. Surveille la progression avec :

---

<img width="1656" height="303" alt="Capture d&#39;écran 2026-07-01 225007" src="https://github.com/user-attachments/assets/1d3a3db0-55d1-49b8-bde1-85fc89d4eee2" />

---

<img width="1655" height="273" alt="image" src="https://github.com/user-attachments/assets/374948fa-89bb-4cfb-80ce-0ab19e9585ef" />

---

### Étape 4 : Mettre à jour la configuration de sauvegarde du RAID    

Puisque la structure du RAID a changé (passée de 4 à 5 disques), il faut écraser l'ancien fichier de config pour que Debian s'en rappelle au prochain redémarrage :    

`sudo mdadm --detail --scan | sudo tee /etc/mdadm/mdadm.conf`   
`sudo update-initramfs -u`   

<img width="1635" height="152" alt="image" src="https://github.com/user-attachments/assets/c819f081-fce2-4311-aee9-87922e01f928" />

---

/!\ Surtout ne JAMAIS oublier l'étape 4 pour éviter de passer en md127 au redémarrage !!!

---

### Étape 5 : Agrandir le volume physique LVM (PV)   

Le RAID 5 fait maintenant 60 Go utiles, mais LVM croit toujours que le "disque" sous-jacent fait 45 Go. On va lui demander de recalculer sa taille :   

`sudo pvresize /dev/md0`   

Pour vérifier que le Volume Group voit désormais l'espace supplémentaire libre, taper la cmd vgs.   

<img width="1650" height="238" alt="Capture d&#39;écran 2026-07-01 225709" src="https://github.com/user-attachments/assets/cbad83b5-3a19-4d91-bdb2-866db07031d7" />


---

### Étape 6 : Étendre le Volume Logique et le système de fichiers 

Maintenant que LVM a 15 Go de libre dans son groupe, on peut exécuter à nouveau les deux commandes pour attribuer tout l'espace restant au volume de backup et l'étendre en direct :


```
sudo lvextend -l +100%FREE /dev/mvg_bkp/lv_bkp
sudo resize2fs /dev/mvg_bkp/lv_bkp
```

<img width="1648" height="295" alt="Capture d&#39;écran 2026-07-01 230220" src="https://github.com/user-attachments/assets/4cc48220-3ce3-4cab-bfff-f08b141fc158" />


---

### Étape 7 : La vérification finale   

`df -h /mnt/BKP`

<img width="1648" height="125" alt="image" src="https://github.com/user-attachments/assets/6aa59f3a-4c06-4c99-8865-b5b3ae1f7ed2" />

---

Et voilà ! L'infra de backup est passée à 60 Go utiles, entièrement à chaud et sans aucune perte de données.
















