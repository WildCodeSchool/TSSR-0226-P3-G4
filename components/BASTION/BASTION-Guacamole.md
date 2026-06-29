## Installation d'un Bastion Apache Guacamole 1.6.0 (Tomcat 9 & MariaDB)

1. Mise à jour du système et installation des dépendances nécessaires

`sudo apt update && sudo apt install -y build-essential libcairo2-dev libjpeg62-turbo-dev libpng-dev libtool-bin libossp-uuid-dev libvncserver-dev freerdp2-dev libssh2-1-dev libssl-dev libvorbis-dev libwebp-dev tomcat9 mariadb-server mariadb-client wget`

<img width="1882" height="907" alt="image" src="https://github.com/user-attachments/assets/aa752c8f-b304-4a4e-9d00-adb820bcccda" />

-----

2. Lancer la compilation dans le bon dossier (1.6.0)

```
cd ~/guacamole-server-1.6.0/
sudo ./configure --with-init-dir=/etc/init.d
make && sudo make install
sudo ldconfig
```

<img width="1868" height="1650" alt="image" src="https://github.com/user-attachments/assets/8b412d3a-3b43-40d8-bdce-773e632fc62d" />

--------

3. Configuration et démarrage du démon guacd

```
sudo cp /home/t1/guacamole-server-1.6.0/src/guacd/init.d/guacd /etc/init.d/
sudo chmod +x /etc/init.d/guacd
sudo systemctl daemon-reload
sudo systemctl start guacd
sudo systemctl enable guacd
```

<img width="1862" height="532" alt="image" src="https://github.com/user-attachments/assets/0ea072b9-843c-4aeb-ae38-10deb8260b2e" />

----

4. Application du correctif de sécurité MariaDB pour conteneur Proxmox LXC

```
sudo mkdir -p /etc/systemd/system/mariadb.service.d && echo -e "[Service]\nProtectHome=false\nProtectSystem=false\nPrivateTmp=false\nReadWritePaths=\nCapabilityBoundingSet=\nNoNewPrivileges=false" | sudo tee /etc/systemd/system/mariadb.service.d/override.conf
sudo systemctl daemon-reload
sudo systemctl restart mariadb
sudo systemctl status mariadb
```
<img width="1877" height="1020" alt="image" src="https://github.com/user-attachments/assets/d13ea5dc-96df-41fb-86b5-17ed6ca4bcb9" />

--------

5. Connexion à MariaDB et création de la base de donnée

`sudo mysql -u root`

```
CREATE DATABASE guacamole_db;
CREATE USER 'guacamole_user'@'localhost' IDENTIFIED BY 'Azerty1*';
GRANT SELECT,INSERT,UPDATE,DELETE ON guacamole_db.* TO 'guacamole_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

<img width="1869" height="578" alt="image" src="https://github.com/user-attachments/assets/77700150-cdd0-48fa-824c-68b7f8780c60" />

-----

6. Initialisation et injection du schéma SQL de Guacamole

```
sudo mariadb guacamole_db < ~/guacamole-auth-jdbc-1.6.0/mysql/schema/001-create-schema.sql
sudo mariadb guacamole_db < ~/guacamole-auth-jdbc-1.6.0/mysql/schema/002-create-admin-user.sql
```

<img width="1885" height="737" alt="image" src="https://github.com/user-attachments/assets/fe2a75f5-0d44-4443-8aea-da72bfe1c906" />

------

<img width="1877" height="186" alt="image" src="https://github.com/user-attachments/assets/9595d0ea-ff10-4b91-8b6a-6b9bb2761e6e" />

-------

7. Préparation de l'arborescence de configuration de Guacamole

`sudo mkdir -p /etc/guacamole/extensions /etc/guacamole/lib`

8. Extraction et déploiement ciblé des extensions et connecteurs Java nécessaires

```
sudo find ~/guacamole-auth-jdbc-1.6.0/ -name "guacamole-auth-jdbc-mysql-*.jar" -exec cp {} /etc/guacamole/extensions/ \;
sudo find ~/guacamole-auth-jdbc-1.6.0/ -name "guacamole-auth-totp-*.jar" -exec cp {} /etc/guacamole/extensions/ \;
sudo find ~/mysql-connector-java-8.0.27/ -name "*.jar" -exec cp {} /etc/guacamole/lib/ \;
```

<img width="1868" height="399" alt="image" src="https://github.com/user-attachments/assets/42efd3ed-fcf6-4dbf-86ed-a83ff136a860" />

-----

9. Rédaction du fichier de propriétés de connexion de Guacamole

`sudo nano /etc/guacamole/guacamole.properties`

<img width="1879" height="311" alt="image" src="https://github.com/user-attachments/assets/a6b7f796-16c6-4560-a8c6-2c9df5e18a64" />

----

10. Liaison de la configuration et attribution des permissions pour Tomcat 9

```
sudo mkdir -p /usr/share/tomcat9/.guacamole
sudo ln -s /etc/guacamole/guacamole.properties /usr/share/tomcat9/.guacamole/guacamole.properties
sudo chown -R tomcat:tomcat /etc/guacamole /usr/share/tomcat9/.guacamole
```

<img width="1869" height="125" alt="image" src="https://github.com/user-attachments/assets/4003cab9-4004-4b9b-8630-6cde39014039" />

----

11. Redémarrage général des services de la stack

<img width="1881" height="2040" alt="image" src="https://github.com/user-attachments/assets/b622b242-1de5-435f-b482-123c71b4d56e" />

-----

12. Accès final à l'application web

<img width="1628" height="161" alt="image" src="https://github.com/user-attachments/assets/66448c83-3eed-41fa-9ef2-e79d368ad65c" />

--------

<img width="1171" height="821" alt="image" src="https://github.com/user-attachments/assets/9c648cba-d875-4b1e-a4f8-6018fa3955f3" />

-------

<img width="1177" height="1052" alt="Capture d&#39;écran 2026-06-29 142454" src="https://github.com/user-attachments/assets/1c9321c3-0408-472e-abe6-a9994938de7a" />

-------

<img width="1917" height="832" alt="image" src="https://github.com/user-attachments/assets/015edc53-d4fe-420e-8c73-4849295a565b" />



------

















