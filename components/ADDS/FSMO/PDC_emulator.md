# PDC emulator - Service de Temps (NTP)

Ce document centralise les directives techniques pour la gouvernance des 5 rôles FSMO et la synchronisation horaire de l'infrastructure de domaine.

<img width="1420" height="202" alt="Capture d&#39;écran 2026-07-05 185715" src="https://github.com/user-attachments/assets/3fdff113-a521-4a7e-89be-0375525f2195" />


---

## Sommaire

1. **[Définition et répartition des 5 rôles FSMO](#1-définition-et-répartition-des-5-rôles-fsmo)**
2. **[Rôle et responsabilités du service PDC Emulator](#2-rôle-et-responsabilités-du-service-pdc-emulator)**
3. **[Positionnement du service dans l'architecture](#3-positionnement-du-service-dans-larchitecture)**
4. **[Documentation technique de configuration NTP](#4-documentation-technique-de-configuration-ntp)**

---

## 1. Définition et répartition des 5 rôles FSMO

Maintenir une topologie Active Directory saine en affectant correctement les rôles de maîtres d'opérations uniques (FSMO).

### Rôles au niveau de la forêt (un seul exemplaire par forêt AD)
* **Maître de schéma (Schema Master)** : Autoriser les modifications et les extensions de la structure de la base de données Active Directory.
* **Maître d'attribution des noms de domaine (Domain Naming Master)** : Valider l'ajout ou la suppression de domaines au sein de la forêt.

### Rôles au niveau du domaine (un exemplaire par domaine AD)
* **Maître RID (RID Master)** : Distribuer des blocs d'identifiants relatifs (RID) aux différents contrôleurs de domaine pour la création d'objets (utilisateurs, machines).
* **Maître d'infrastructure (Infrastructure Master)** : Garantir la mise à jour des références d'objets inter-domaines (GUID, SID).
* **Émulateur PDC (PDC Emulator)** : Agir en tant que pivot pour les opérations critiques de sécurité, d'authentification et de gestion du temps.

---

## 2. Rôle et responsabilités du service PDC Emulator

Piloter le rôle d'Émulateur PDC (Primary Domain Controller) avec une attention particulière, ce service occupant une position centrale :
* **Gérer la réplication des mots de passe** : Recevoir immédiatement les modifications de mots de passe du domaine pour éviter les échecs d'authentification inter-sites.
* **Traiter les verrouillages de comptes** : Centraliser les tentatives d'ouverture de session infructueuses pour valider ou rejeter l'accès.
* **Faire office de source de temps de référence** : Servir d'autorité NTP absolue pour l'ensemble des serveurs et des stations de travail du domaine.

---

## 3. Positionnement du service dans l'architecture

Organiser l'architecture réseau et la distribution des rôles selon la logique suivante :

* **Placer le rôle PDC Emulator** : Héberger ce rôle sur un contrôleur de domaine performant, hautement disponible et disposant d'un accès réseau direct vers l'extérieur sur le port UDP 123.
* **Isoler le trafic** : Autoriser les flux NTP sortants uniquement depuis l'adresse IP du PDC Emulator vers l'Internet, et bloquer les flux Internet directs pour les autres serveurs du réseau.

---

## 4. Documentation technique de configuration NTP

Appliquer les procédures ci-dessous pour aligner la configuration du service de temps sur l'ensemble de l'infrastructure.

### Configuration du PDC Emulator (Source externe Paris)

Exécuter ces commandes sur le contrôleur de domaine principal détenant le rôle FSMO PDC Emulator pour le synchroniser sur les serveurs de temps français (Europe/Paris) :

```
w32tm /config /manualpeerlist:"0.fr.pool.ntp.org,0x1 1.fr.pool.ntp.org,0x1" /syncfromflags:manual /reliable:YES /update
```
<img width="1896" height="227" alt="image" src="https://github.com/user-attachments/assets/2f1923ba-afbc-499c-aa3c-81b33ea9758c" />

---

```
net stop w32time
net start w32time
w32tm /resync /force
w32tm /query /status
```

<img width="1900" height="609" alt="image" src="https://github.com/user-attachments/assets/7ce2951a-cb64-4500-ba35-3330a112c517" />

---

