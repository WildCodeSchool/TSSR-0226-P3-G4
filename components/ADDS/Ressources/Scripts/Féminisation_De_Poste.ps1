#############################################################
#         Féminisation automatique des intitulés de poste   #
#############################################################
Import-Module ActiveDirectory -ErrorAction Stop

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

$LogFile = "C:\Logs\FeminisationPoste.log"
$null = New-Item -ItemType Directory -Path (Split-Path $LogFile) -Force -ErrorAction SilentlyContinue
function Write-Log {
    param([string]$Message)
    Add-Content -Path $LogFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Message"
}

Write-Log " Début de l'exécution "

# Récupère uniquement les comptes marqués "féminin" (adapter le filtre à ton attribut réel)
$Utilisatrices = Get-ADUser -Filter "extensionAttribute1 -eq 'F'" -Properties Title, extensionAttribute1

foreach ($user in $Utilisatrices) {
    if (-not $user.Title) { continue }

    # Savoir si le poste est deja feminisé ou pas
    if ($MappingTitres.ContainsValue($user.Title)) {
        Write-Log "Déjà féminisé, ignoré : $($user.SamAccountName)"
        continue
    }

    if ($MappingTitres.ContainsKey($user.Title)) {
        $nouveauTitre = $MappingTitres[$user.Title]
        try {
            Set-ADUser -Identity $user.DistinguishedName -Replace @{Title = $nouveauTitre} -ErrorAction Stop
            Write-Log "Modifié : $($user.SamAccountName) : '$($user.Title)' -> '$nouveauTitre'"
        }
        catch {
            Write-Log "Échec : $($user.SamAccountName) -> $($_.Exception.Message)"
        }
    }
    else {
        Write-Log "Pas de correspondance trouvée pour le titre : '$($user.Title)' ($($user.SamAccountName))"
    }
}

Write-Log " Fin de l'exécution "

Test attribut
Get-ADUser -Filter * -Properties personalTitle | 
    Where-Object { $_.personalTitle } | 
    Select-Object SamAccountName, personalTitle -First 10
