#### Cette documentation détaille la centralisation des journaux des 4 scripts PowerShell d'administration de l'entreprise **XTech** dans le répertoire `C:\Logs`, afin d'assurer la traçabilité des actions automatisées (création de comptes, dossiers personnels, etc.).

--------

## Objectif

Chaque script PowerShell d'administration doit écrire son propre fichier de log horodaté dans `C:\Logs`, avec un format homogène, pour permettre :

- la relecture rapide en cas d'incident,
- la remontée ultérieure vers syslog-ng (cf. doc journalisation),
- la preuve d'exécution en cas d'audit.

---

## PARTIE A — Structure du dossier de logs

Les 4 scripts s'exécutent sur deux serveurs distincts, situés sur deux VLAN différents :

| Serveur                          | VLAN ID | Réseau              | Scripts concernés                                    |
| ----------------------------------- | --------- | ---------------------- | --------------------------------------------------------- |
| AD (`172.16.65.3`)                   | 10        | `172.16.65.0/24`         | Script1 (création comptes), Script4 (le cas échéant)        |
| XTS-417 (serveur de fichiers)         | 20        | `172.16.66.0/24`         | Script2 (dossiers individuels), Script3 (mappage lecteurs)   |

Sur **chaque** serveur où s'exécutent les scripts :

```powershell
New-Item -Path "C:\Logs" -ItemType Directory -Force
```

> Administration : ces deux serveurs sont accessibles uniquement via le chemin **Bastion (VLAN 60, `172.16.69.0/24`) → Jump (VLAN 70, `172.16.70.0/24`) → serveur cible**, conformément aux règles F5/F6 du pare-feu (Bastion → AD port `3389,22` et Bastion → APPS port `3389,22`). C'est par ce chemin que les scripts doivent être déployés et exécutés, jamais en RDP/SSH direct depuis un poste admin.

Arborescence cible :

```
C:\Logs\
├── Script1-AddADUser.log
├── Script2-CreationDossier.log
├── Script3-CreationGroupe.log
├── Script4-CreationOU.log
├── Script5-GPO-CreationautoVide.log
├── Script6-GROUP-Creation-auto.log
```

> Un fichier par script, journalisation en mode **append** (ajout), jamais d'écrasement, pour conserver l'historique complet entre deux exécutions.

---

## PARTIE B — Fonction de log commune (à réutiliser dans les 4 scripts)

Insérer cette fonction en tête de chaque script PowerShell, en adaptant uniquement le nom du fichier de sortie :

```powershell
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO",          # INFO / WARN / ERROR
        [string]$LogFile = "C:\Logs\Script-Generique.log"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "$timestamp [$Level] $Message"

    Add-Content -Path $LogFile -Value $line -Encoding UTF8

    # Affichage console en parallèle pour debug en direct
    switch ($Level) {
        "ERROR" { Write-Host $line -ForegroundColor Red }
        "WARN"  { Write-Host $line -ForegroundColor Yellow }
        default { Write-Host $line }
    }
}
```

Exemple d'appel dans un script :

```powershell
$LogFile = "C:\Logs\Script2-CreationDossier.log"

Write-Log -Message "Début du script de création des 218 dossiers individuels" -LogFile $LogFile

foreach ($user in $users) {
    try {
        New-Item -Path "\\XTS-417\Partage_individuel\$($user.SamAccountName)" -ItemType Directory -Force | Out-Null
        Write-Log -Message "Dossier créé pour $($user.SamAccountName)" -Level "INFO" -LogFile $LogFile
    }
    catch {
        Write-Log -Message "Échec création dossier pour $($user.SamAccountName) : $_" -Level "ERROR" -LogFile $LogFile
    }
}

Write-Log -Message "Fin du script" -LogFile $LogFile
```

---

## PARTIE C — Format de ligne retenu

```
2026-06-16 09:42:13 [INFO] Dossier créé pour jdupont
2026-06-16 09:42:14 [ERROR] Échec création dossier pour isaidi : Accès refusé
```

Ce format `timestamp [niveau] message` est volontairement simple et "parsable" : c'est ce même format que syslog-ng ira lire pour le transférer côté Linux (voir doc journalisation).

---

## PARTIE D — Rotation des logs

Pour éviter une croissance infinie des fichiers, une tâche planifiée hebdomadaire archive et purge :

```powershell
# A placer dans le Planificateur de tâches Windows, exécution hebdomadaire
$logFolder = "C:\Logs"
$archiveFolder = "C:\Logs\Archive"
$maxAgeDays = 90

New-Item -Path $archiveFolder -ItemType Directory -Force | Out-Null

Get-ChildItem -Path $logFolder -Filter "*.log" | ForEach-Object {
    $archiveName = "$($_.BaseName)_$(Get-Date -Format yyyyMMdd).log"
    Copy-Item $_.FullName -Destination (Join-Path $archiveFolder $archiveName)
}

Get-ChildItem -Path $archiveFolder -Filter "*.log" |
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$maxAgeDays) } |
    Remove-Item -Force
```

---

## PARTIE E — Liste des 4 scripts concernés et leur fichier de log dédié

| # | Script                              | Fichier de log                          | Rôle                                                    |
| - | ------------------------------------ | ----------------------------------------- | -------------------------------------------------------- |
| 1 | Création des comptes AD              | `C:\Logs\Script1-AddADUser.log`     | Création des 218 comptes utilisateurs dans l'AD          |
| 2 | Création des 218 dossiers individuels | `C:\Logs\Script2-CreationDossier.log`    | Création des dossiers sous `\\XTS-417\Partage_individuel` |
| 3 | Mappage des lecteurs réseau           | `C:\Logs\Script3-CreationGroupe.log`     | Application/test du mapping I/J/K (en complément de la GPO) |
| 4 | Création des OU                       | `C:\Logs\Script4-CreationOU.log`               |                                            |

> Le tableau ci-dessus reprend les 3 scripts identifiés dans cette session (comptes, dossiers individuels, mappage). Le 4e script n'a pas été détaillé dans nos échanges — remplacez la ligne 4 par son nom réel et son rôle pour que le tableau soit complet dans le livrable final.

---

## PARTIE F — Vérification

```powershell
Get-Content "C:\Logs\Script2-CreationDossier.log" -Tail 20
```

→ doit afficher les 20 dernières lignes du dernier passage du script, avec horodatage cohérent et niveau `INFO`/`ERROR` correctement renseigné.

Comptage rapide des erreurs sur la dernière exécution :

```powershell
Select-String -Path "C:\Logs\Script2-CreationDossier.log" -Pattern "\[ERROR\]" | Measure-Object
```
