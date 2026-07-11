#############################################################
#                Correction de la civilité                  #
#############################################################
Import-Module ActiveDirectory -ErrorAction Stop
Import-Module "C:\Scripts\Modules\XTechLogging.psm1" -ErrorAction Stop
$ScriptName = "CorrectionCivilite"

$FilePath = "C:\Data"    # <-- adapte au dossier réel où se trouve le fichier
$File     = "$FilePath\Creation_Users2.txt"

Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "=== Début de l'exécution ==="

$Collaborateurs = Import-Csv -Path $File -Delimiter ";" -Encoding Default

$compteurOK   = 0
$compteurSkip = 0
$compteurErr  = 0

foreach ($personne in $Collaborateurs) {

    $prenom    = $personne.'Prénom'
    $nom       = $personne.'Nom'
    $civilite  = $personne.'civilité'

    if (-not $prenom -or -not $nom -or -not $civilite) {
        Write-XTechLog -ScriptName $ScriptName -Level "WARNING" -Message "IGNORÉ (ligne incomplète) : Prénom='$prenom' Nom='$nom' Civilité='$civilite'"
        $compteurSkip++
        continue
    }

    $utilisateur = Get-ADUser -Filter "GivenName -eq '$prenom' -and Surname -eq '$nom'" `
                    -Properties personalTitle -ErrorAction SilentlyContinue

    if (-not $utilisateur) {
        Write-XTechLog -ScriptName $ScriptName -Level "ERROR" -Message "NON TROUVÉ dans AD : $prenom $nom"
        $compteurErr++
        continue
    }

    if ($utilisateur.Count -gt 1) {
        Write-XTechLog -ScriptName $ScriptName -Level "WARNING" -Message "AMBIGU (plusieurs comptes trouvés) : $prenom $nom -> vérifier manuellement"
        $compteurErr++
        continue
    }

    if ($utilisateur.personalTitle -eq $civilite) {
        Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "Déjà à jour, ignoré : $($utilisateur.SamAccountName)"
        $compteurSkip++
        continue
    }

    try {
        Set-ADUser -Identity $utilisateur.DistinguishedName -Replace @{personalTitle = $civilite} -ErrorAction Stop
        Write-XTechLog -ScriptName $ScriptName -Level "SUCCESS" -Message "Mis à jour : $($utilisateur.SamAccountName) -> personalTitle = '$civilite'"
        $compteurOK++
    }
    catch {
        Write-XTechLog -ScriptName $ScriptName -Level "ERROR" -Message "ÉCHEC : $($utilisateur.SamAccountName) -> $($_.Exception.Message)"
        $compteurErr++
    }
}

Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "=== Fin de l'exécution : $compteurOK mis à jour / $compteurSkip ignorés / $compteurErr en erreur ==="
Write-Host "Terminé. $compteurOK comptes mis à jour, $compteurSkip ignorés, $compteurErr en erreur. Voir C:\Logs\PS\$ScriptName.log" -ForegroundColor Green
