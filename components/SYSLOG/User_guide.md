# Guide d'Utilisation - Toutes les commandes Syslog & Journald

Ce guide recense toutes les commandes applicables dans un conteneur Debian 12 standard pour interroger, filtrer et gérer les flux de journaux.

## 1. Interrogation native via Journalctl (Remplacement moderne de Syslog)

### Lecture de base

Afficher l'intégralité des journaux (du plus ancien au plus récent) :
  
```
journalctl
```
