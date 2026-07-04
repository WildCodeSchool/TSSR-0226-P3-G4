# FAQ

### Q1. Pourquoi les commandes de logs du noyau (`journalctl -k` ou `dmesg`) renvoient une erreur ?
**Réponse :** Votre serveur est hébergé dans un conteneur LXC sur Proxmox VE. Le conteneur partage le noyau de l'hôte Proxmox. L'accès aux logs du noyau est bloqué à l'intérieur du conteneur pour des raisons de sécurité. Seuls les logs applicatifs et de services y sont visibles.

<img width="1879" height="711" alt="Capture d&#39;écran 2026-07-04 162542" src="https://github.com/user-attachments/assets/1eb234c4-4932-442f-8c2d-712baf2ce69f" />

---

Puisque le conteneur Debian 12 tourne sous Proxmox VE, il partage le noyau (kernel) avec l'hôte. Rsyslog essaie de charger le module imklog pour lire les logs du noyau, mais Proxmox lui refuse légitimement l'accès pour des raisons de sécurité.

Rsyslog fonctionne quand même (le statut est bien active (running)), mais ce message d'erreur va polluer les statuts à chaque redémarrage.

Voici comment nettoyer ça proprement pour l'environnement Proxmox.

La solution : Désactiver le module kernel log (imklog)
Puisque le conteneur ne pourra jamais lire directement /proc/kmsg (et que c'est le rôle de l'hôte Proxmox de le faire), il faut simplement dire à Rsyslog d'arrêter d'essayer.

1. Ouvre le fichier de configuration principal :

```
nano /etc/rsyslog.conf
```

2. Cherche la ligne suivante (généralement vers le début du fichier) :

```
module(load="imklog") # provides kernel logging support
```

<img width="1889" height="929" alt="Capture d&#39;écran 2026-07-04 163104" src="https://github.com/user-attachments/assets/e59aa7ce-0702-4484-abeb-ddb1b8bce2e2" />

---

4. Sauvegarde (Ctrl+O, puis Entrée) et quitte (Ctrl+X).

5. Redémarre le service Rsyslog pour appliquer la modification :

```
systemctl restart rsyslog
```

6. Vérifie à nouveau le statut :

```
systemctl status rsyslog
```

<img width="1893" height="573" alt="image" src="https://github.com/user-attachments/assets/fec1f699-25ba-4ef1-914e-7e7f66317b6c" />

---

Le message en rouge aura disparu et ton service sera parfaitement propre et adapté à ton conteneur Proxmox !

---

### Q2. Comment configurer un équipement client pour qu'il envoie ses logs vers notre serveur ?
**Réponse :** Sur le client (s'il s'agit d'une machine Linux équipée de Rsyslog), ajoutez cette ligne à la fin de son fichier `/etc/rsyslog.conf` en remplaçant par l'IP de votre **Serveur Principal** défini dans le `README.md` :

```
# Envoi en UDP (un seul @)
*.* @172.16.64.28:514

# Ou envoi en TCP (deux @@)
*.* @@172.16.64.28:514
```

On recommande d'envoyer les logs en TCP "@@" et non en UDP "@", inutile d'utiliser les 2 UDP et TCP en même temps.
Pour de la redondance, on envoie les logs au serveur de log `Syslog` et au serveur de sauvegarde `BKP`.

---

<img width="1866" height="898" alt="Capture d&#39;écran 2026-07-04 174130" src="https://github.com/user-attachments/assets/905add64-affe-4747-bbd0-61e5616e3205" />


