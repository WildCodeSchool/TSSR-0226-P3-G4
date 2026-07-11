#############################################################
#                Correction de la civilité                  #
#############################################################
Import-Module ActiveDirectory -ErrorAction Stop

$FilePath = "C:\Data"    # <-- adapte au dossier réel où se trouve le fichier
$File     = "$FilePath\Creation_Users2.txt"
$LogFile  = "C:\Logs\CorrectionPersonalTitle.log"

$null = New-Item -ItemType Directory -Path (Split-Path $LogFile) -Force -ErrorAction SilentlyContinue
function Write-Log {
    param([string]$Message)
    Add-Content -Path $LogFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Message"
}

Write-Log "=== Début de l'exécution ==="

$Collaborateurs = Import-Csv -Path $File -Delimiter ";" -Encoding Default

$compteurOK   = 0
$compteurSkip = 0
$compteurErr  = 0

foreach ($personne in $Collaborateurs) {

    $prenom    = $personne.'Prénom'
    $nom       = $personne.'Nom'
    $civilite  = $personne.'civilité'

    if (-not $prenom -or -not $nom -or -not $civilite) {
        Write-Log "IGNORÉ (ligne incomplète) : Prénom='$prenom' Nom='$nom' Civilité='$civilite'"
        $compteurSkip++
        continue
    }

    $utilisateur = Get-ADUser -Filter "GivenName -eq '$prenom' -and Surname -eq '$nom'" `
                    -Properties personalTitle -ErrorAction SilentlyContinue

    if (-not $utilisateur) {
        Write-Log "NON TROUVÉ dans AD : $prenom $nom"
        $compteurErr++
        continue
    }

    if ($utilisateur.Count -gt 1) {
        Write-Log "AMBIGU (plusieurs comptes trouvés) : $prenom $nom -> vérifier manuellement"
        $compteurErr++
        continue
    }

    if ($utilisateur.personalTitle -eq $civilite) {
        Write-Log "Déjà à jour, ignoré : $($utilisateur.SamAccountName)"
        $compteurSkip++
        continue
    }

    try {
        Set-ADUser -Identity $utilisateur.DistinguishedName -Replace @{personalTitle = $civilite} -ErrorAction Stop
        Write-Log "Mis à jour : $($utilisateur.SamAccountName) -> personalTitle = '$civilite'"
        $compteurOK++
    }
    catch {
        Write-Log "ÉCHEC : $($utilisateur.SamAccountName) -> $($_.Exception.Message)"
        $compteurErr++
    }
}

Write-Log "=== Fin de l'exécution : $compteurOK mis à jour / $compteurSkip ignorés / $compteurErr en erreur ==="
Write-Host "Terminé. $compteurOK comptes mis à jour, $compteurSkip ignorés, $compteurErr en erreur. Voir $LogFile" -ForegroundColor Green
