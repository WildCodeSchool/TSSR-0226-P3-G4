# Procédure de Fusion : Raccordement Partenaire en OpenVPN Peer-to-Peer (Clé Partagée)

Ce document décrit comment interconnecter de manière étanche le réseau de notre partenaire **Pharmgreen** avec le Bastion d'Administration de **XenTech** via un tunnel OpenVPN Site-à-Site statique.

## Synthèse du Raccordement
* **Type de Topologie :** Peer-to-Peer (Shared Key)
* **IP WAN pfSense XenTech (Serveur) :** `10.0.0.4`
* **Réseau Local XenTech (DMZ/Bastion cible) :** `172.16.69.0/24` (VLAN BASTION)
* **Réseau Local Pharmgreen (Source) :** À renseigner selon le plan d'adressage du partenaire (ex: `192.168.100.0/24`)
* **Réseau du Tunnel (Transit) :** `10.0.99.0/30`

---

## Étape 1 : Génération et Partage de la Clé Secrète sur pfSense-XTech

Dans le cadre d'une architecture décentralisée, nous allons configurer le pfSense de XenTech en tant que point de terminaison "Serveur" pour la réception du lien.

1. Rendez-vous dans **VPN ➔ OpenVPN ➔ Peer to Peer (Shared Key)**.
2. Cliquez sur **Add**.
3. Configurez les **General Information** :
   * **Server mode :** Peer to Peer (Shared Key)
   * **Protocol :** UDP on IPv4
   * **Interface :** WAN
   * **Local Port :** `1194` (ou port dédié à Pharmgreen)
   * **Description :** `Tunnel_P2P_Pharmgreen`
4. **Cryptographic Settings** :
   * Cochez **"Automatically generate a shared key"**.
5. **Tunnel Settings** :
   * **IPv4 Tunnel Network :** `10.0.99.0/30` (Fournit l'IP `10.0.99.1` à XenTech et `10.0.99.2` à Pharmgreen)
   * **IPv4 Remote Network(s) :** Renseignez le sous-réseau exact de l'équipe IT Pharmgreen (ex: `192.168.100.0/24`).
6. Cliquez sur **Save** puis **Apply Changes**.

> **Action Manuelle Sécurisée :** Retournez dans l'édition de ce tunnel, copiez le bloc de texte apparu dans le champ **Shared Key** et transmettez-le de manière hautement sécurisée (ex: via un coffre-fort Bitwarden partagé) à l'administrateur de Pharmgreen.

---

## Étape 2 : Configuration du Côté Partenaire (Pharmgreen)

L'administrateur de Pharmgreen devra configurer son pare-feu de la manière suivante :
* **Server Mode :** Peer to Peer (Shared Key)
* **Remote Host :** `10.0.0.4` (L'IP WAN publique/externe de XenTech)
* **Shared Key :** Décocher la génération automatique et coller la clé transmise par XenTech.
* **IPv4 Tunnel Network :** `10.0.99.0/30`
* **IPv4 Remote Network(s) :** `172.16.69.0/24` (Permet de router son trafic vers notre VLAN Bastion).

---

## Étape 3 : Politique de Filtrage & Clôture Zero Trust sur XenTech

Pour respecter notre engagement d'étanchéité totale, l'équipe IT de Pharmgreen ne doit **en aucun cas** divaguer sur l'ensemble de notre réseau. Elle doit uniquement atteindre l'interface d'administration Web de notre Apache Guacamole.

### 1. Ouverture du port OpenVPN (Interface WAN)
Dans **Firewall ➔ Rules ➔ WAN** :
* **Action :** `Pass`
* **Protocol :** `UDP`
* **Source :** IP WAN Externe de Pharmgreen uniquement (Sécurité renforcée)
* **Destination :** `WAN address`
* **Destination Port Range :** `1194`

### 2. Restriction stricte du trafic du Tunnel (Interface OpenVPN)
 pfSense crée un onglet dédié appelé **OpenVPN** dans les règles de pare-feu. C'est ici que l'on applique la barrière de contrôle.

Dans **Firewall ➔ Rules ➔ OpenVPN** :

* **Règle 1 : Autoriser l'accès à l'interface Web du Bastion**
  * **Action :** `Pass`
  * **Protocol :** `TCP`
  * **Source :** Network Pharmgreen (ex: `192.168.100.0/24`)
  * **Destination :** `172.16.69.0/24` (VLAN BASTION)
  * **Destination Port Range :** `8080` et `443` (Ports HTTP/HTTPS d'Apache Guacamole)
  * **Description :** `SAS Pharmgreen vers HTTPS Bastion`

* **Règle 2 : Bloquer tout le reste (Deny All explicite de sécurité)**
  * **Action :** `Block` / `Reject`
  * **Source :** `any`
  * **Destination :** `any`
  * **Description :** `Isolation absolue - Pas d'accès au reste du LAN/VLANs XenTech`

---

## Étape 4 : Validation du raccordement
1. Allez dans **Status ➔ OpenVPN**, le statut du tunnel `Tunnel_P2P_Pharmgreen` doit être marqué comme **Up** (Vert).
2. Depuis un poste du réseau Pharmgreen, effectuez un test d'accès vers `https://172.16.69.254` (ou l'IP du serveur Guacamole). L'accès doit réussir, tandis qu'un ping vers l'AD (`172.16.65.3`) doit être instantanément rejeté.
