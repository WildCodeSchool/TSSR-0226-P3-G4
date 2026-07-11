#############################################################
#         Féminisation automatique des intitulés de poste   #
#############################################################
Import-Module ActiveDirectory -ErrorAction Stop
Import-Module "C:\Scripts\Modules\XTechLogging.psm1" -ErrorAction Stop
$ScriptName = "FeminisationPoste"

# --- Fichier source (même fichier que Correction_Civilité.ps1) ---
$FilePath = "C:\Data"    # <-- adapte au dossier réel où se trouve le fichier
$File     = "$FilePath\Creation_Users2.txt"

# --- Mapping : intitulé masculin -> intitulé féminin ---
$MappingTitres = @{
    "Acheteur"                          = "Acheteuse"
    "Agent Client"                      = "Agente Client"
    "Agent RH"                          = "Agente RH"
    "Agent logistique"                  = "Agente logistique"
    "Analyste financier"                = "Analyste financière"
    "Animateur sécurité"                = "Animatrice sécurité"
    "Assistant de direction"            = "Assistante de direction"
    "Assistant marketing"               = "Assistante marketing"
    "Attaché de presse"                 = "Attachée de presse"
    "Auditeur"                          = "Auditrice"
    "Chargé de communication"           = "Chargée de communication"
    "Chargé de presse"                  = "Chargée de presse"
    "Chargé de promotion"               = "Chargée de promotion"
    "Chargé en droit de la communication" = "Chargée en droit de la communication"
    "Chef de produit"                   = "Cheffe de produit"
    "Chef de produit stratégique"       = "Cheffe de produit stratégique"
    "Chef de projet"                    = "Cheffe de projet"
    "Chef de projet événement"          = "Cheffe de projet événement"
    "Chercheur"                         = "Chercheuse"
    "Commercial"                        = "Commerciale"
    "Contrôleur de gestion"             = "Contrôleuse de gestion"
    "Coordinateur Marketing"            = "Coordinatrice Marketing"
    "Directeur Marketing Stratégique"   = "Directrice Marketing Stratégique"
    "Directeur RH"                      = "Directrice RH"
    "Directeur adjoint"                 = "Directrice adjointe"
    "Directeur-Adjoint RH"              = "Directrice-Adjointe RH"
    "Développeur"                       = "Développeuse"
    "Formateur"                         = "Formatrice"
    "Gestionnaire immobilier"           = "Gestionnaire immobilière"
    "Ingénieur son"                     = "Ingénieure son"
    "Intégrateur"                       = "Intégratrice"
    "Laborantin"                        = "Laborantine"
    "Technicien HSE"                    = "Technicienne HSE"
    "Caméraman"                         = "Cadreuse"
    "Designer graphique"                = "Designeuse graphique"
}

Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "=== Début de l'exécution ==="

if (-not (Test-Path $File)) {
    Write-XTechLog -ScriptName $ScriptName -Level "ERROR" -Message "Fichier introuvable : $File"
    exit 1
}

$Collaborateurs = Import-Csv -Path $File -Delimiter ";" -Encoding UTF8

$compteurOK   = 0
$compteurSkip = 0
$compteurErr  = 0

foreach ($personne in $Collaborateurs) {

    $prenom   = $personne.'Prénom'
    $nom      = $personne.'Nom'
    $civilite = $personne.'civilité'

    if (-not $prenom -or -not $nom) {
        Write-XTechLog -ScriptName $ScriptName -Level "WARNING" -Message "IGNORÉ (ligne incomplète) : Prénom='$prenom' Nom='$nom'"
        $compteurSkip++
        continue
    }

    # --- Ne traiter que les civilités féminines ---
    # Valeurs réelles observées dans le CSV : "Mme" (féminin) / "M." (masculin)
    $civiliteNettoyee = $civilite.Trim()
    if ($civiliteNettoyee -ne "Mme") {
        Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "Ignoré (civilité = '$civiliteNettoyee') : $prenom $nom"
        $compteurSkip++
        continue
    }

    # --- Fonction lue directement depuis le CSV (colonne 'fonction'), pas depuis l'AD ---
    $fonction = $personne.'fonction'

    if (-not $fonction) {
        Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "Pas de fonction renseignée dans le CSV, ignoré : $prenom $nom"
        $compteurSkip++
        continue
    }

    $utilisateur = Get-ADUser -Filter "GivenName -eq '$prenom' -and Surname -eq '$nom'" `
                    -Properties Description -ErrorAction SilentlyContinue

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

    # Savoir si le poste est déjà féminisé ou non (d'après la colonne 'fonction' du CSV)
    if ($MappingTitres.ContainsValue($fonction)) {
        Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "Déjà féminisé, ignoré : $($utilisateur.SamAccountName)"
        $compteurSkip++
        continue
    }

    if ($MappingTitres.ContainsKey($fonction)) {
        $nouveauTitre = $MappingTitres[$fonction]
        try {
            # Écrit dans Description, l'attribut réellement peuplé par Création_Users_Avec_Fichier.ps1
            Set-ADUser -Identity $utilisateur.DistinguishedName -Replace @{Description = $nouveauTitre} -ErrorAction Stop
            Write-XTechLog -ScriptName $ScriptName -Level "SUCCESS" -Message "Modifié : $($utilisateur.SamAccountName) : '$fonction' -> '$nouveauTitre'"
            $compteurOK++
        }
        catch {
            Write-XTechLog -ScriptName $ScriptName -Level "ERROR" -Message "Échec : $($utilisateur.SamAccountName) -> $($_.Exception.Message)"
            $compteurErr++
        }
    }
    else {
        Write-XTechLog -ScriptName $ScriptName -Level "WARNING" -Message "Pas de correspondance trouvée pour la fonction : '$fonction' ($($utilisateur.SamAccountName))"
        $compteurSkip++
    }
}

Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "=== Fin de l'exécution : $compteurOK modifié(s) / $compteurSkip ignoré(s) / $compteurErr en erreur ==="
Write-Host "Terminé. $compteurOK titres modifiés, $compteurSkip ignorés, $compteurErr en erreur. Voir C:\Logs\PS\$ScriptName.log" -ForegroundColor Green
