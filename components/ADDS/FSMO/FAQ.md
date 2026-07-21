## Procédure de correction pour les machines non synchronisées (serveur AD et postes admin)

J'exécute ces commandes directement en administrateur sur les machines concernées qui conservent un décalage horaire.

`w32tm /unregister`

Je désinscris le service de temps corrompu pour le purger de la mémoire de la machine.

`w32tm /register`

Je réinscris proprement le service Windows Time sur le système.

`net start w32time`

Je redémarre le service pour qu'il soit de nouveau actif.

`w32tm /config /syncfromflags:DOMHIER /update`

Je force la machine à adopter la hiérarchie du domaine pour pointer vers notre PDC.

`tzutil /s "Romance Standard Time"`

Je m'assure que le fuseau horaire de Paris est bien appliqué pour éviter tout décalage d'offset.

`w32tm /resync /force`

Je déclenche une synchronisation forcée pour aligner immédiatement l'heure de la machine sur celle du PDC.

---

<img width="821" height="203" alt="image" src="https://github.com/user-attachments/assets/396dc209-4f41-433b-96fb-0116e6f6b39d" />

---
