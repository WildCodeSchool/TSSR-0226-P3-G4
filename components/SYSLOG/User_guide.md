# Guide d'Utilisation - Toutes les commandes Syslog & Journald

Ce guide recense toutes les commandes applicables dans un conteneur Debian 12 standard pour interroger, filtrer et gérer les flux de journaux.

## 1. Interrogation native via Journalctl (Remplacement moderne de Syslog)

### Lecture de base

Afficher l'intégralité des journaux (du plus ancien au plus récent) :
  
```
journalctl
```

<img width="1882" height="2044" alt="image" src="https://github.com/user-attachments/assets/bab4015f-3244-4e83-a03b-549f56231479" />

---

Afficher les logs en temps réel (équivalent de tail -f) :

```
journalctl -f
```

<img width="1874" height="468" alt="image" src="https://github.com/user-attachments/assets/16bd4c52-62d2-40fe-8f70-bee661ac8a3c" />

---

Afficher les $N$ dernières lignes :

```
journalctl -n 20
```

<img width="1880" height="588" alt="image" src="https://github.com/user-attachments/assets/1cb535e3-2896-4ec0-82bb-0fbd351628fb" />

---

Filtrage par temps / date
Logs générés depuis aujourd'hui :

```
journalctl --since today
```

<img width="1882" height="2042" alt="image" src="https://github.com/user-attachments/assets/58cfade0-b198-4b70-b1e1-034cbf3ce9eb" />

---

Logs générés sur une plage horaire stricte :

```
journalctl --since "2026-07-04 00:00:00" --until "2026-07-04 15:00:00"
```

---

Filtrage par Unité Systemd / Service
Logs spécifiques au serveur SSH :

```
journalctl -u ssh
```

<img width="1879" height="175" alt="image" src="https://github.com/user-attachments/assets/9aec256f-5976-402f-b33c-4d3b5417f8bd" />

---

Logs spécifiques au serveur web (ex: Apache / Nginx) combinés au mode temps réel :

```
journalctl -u nginx -f
```

---

Filtrage par criticité (Niveau de sévérité Syslog)
Les niveaux vont de 0 (emerg) à 7 (debug).

Afficher uniquement les erreurs (err, niveau 3) et plus critiques :

```
journalctl -p err -b
```

<img width="1875" height="218" alt="image" src="https://github.com/user-attachments/assets/47dc029a-27b9-40b5-a664-6145465d8923" />

---

Filtrer par niveau textuel (emerg, alert, crit, err, warning, notice, info, debug) :

```
journalctl -p warning
```

<img width="1879" height="300" alt="image" src="https://github.com/user-attachments/assets/f1394dd9-daa7-4dc0-8e53-2f3cc250a9ec" />

---

## 2. Commandes d'Administration et Maintenance

Connaître l'espace disque total occupé par les fichiers de logs binaires :

```
journalctl --disk-usage
```

<img width="1878" height="110" alt="image" src="https://github.com/user-attachments/assets/ff322bf0-e648-4abf-9b9b-b91ec54bd14e" />

---

Forcer manuellement une rotation/nettoyage des logs journald pour ne garder que les 100 derniers Mo :

```
journalctl --vacuum-size=100M
```

Nettoyer les logs journald plus vieux que 7 jours :

```
journalctl --vacuum-time=7d
```

<img width="1882" height="133" alt="image" src="https://github.com/user-attachments/assets/4f1a1646-0d65-4d0b-99e0-8cf9a47da192" />

---

Tester l'envoi d'un message Syslog manuellement (utile pour valider les alertes ou la centralisation) :

```
logger "Test de message Syslog - Documentation CT Debian 12"
```

Tester l'envoi vers un niveau de priorité spécifique (ex: Attention / Alerte) :

```
logger -p local0.warn "Message d'avertissement de test"
```

---



