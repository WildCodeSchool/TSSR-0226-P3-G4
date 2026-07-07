#############################################################
#                                                           #
# Déplacement automatique des ordinateurs dans la bonne OU  #
#                                                           #
#############################################################

Import-Module ActiveDirectory -ErrorAction Stop

# --- Mapping : motif du nom -> OU cible (à adapter à ta structure) ---
$Mapping = @(
    @{ Pattern = "XT-OD01-"; OU = "OU=D1,OU=Ordinateurs,OU=Paris,DC=Xtech,DC=green" }
    @{ Pattern = "XT-OD02-*"; OU = "OU=D2,OU=Ordinateurs,OU=Paris,DC=Xtech,DC=green" }
    @{ Pattern = "XT-OD03-*"; OU = "OU=D3,OU=Ordinateurs,OU=Paris,DC=Xtech,DC=green" }
    # ... compléter jusqu'à OD11
)
# --------------------------------------------------------------------

# Journalisation (pour vérifier l'exécution par la tâche planifiée)
$LogFile = "C:\Logs\DeplacementOU.log"
$null = New-Item -ItemType Directory -Path (Split-Path $LogFile) -Force -ErrorAction SilentlyContinue

function Write-Log {
    param([string]$Message)
    Add-Content -Path $LogFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Message"
}

Write-Log "=== Début de l'exécution ==="

foreach ($regle in $Mapping) {

    # Vérifie que l'OU cible existe
    if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$($regle.OU)'" -ErrorAction SilentlyContinue)) {
        Write-Log "ERREUR : OU introuvable -> $($regle.OU)"
        continue
    }

    # Récupère les PC dont le nom correspond au motif
    $PCs = Get-ADComputer -Filter "Name -like '$($regle.Pattern)'" -Properties DistinguishedName

    foreach ($pc in $PCs) {
        # Ignore s'il est déjà dans la bonne OU
        if ($pc.DistinguishedName -like "*$($regle.OU)") { continue }

        try {
            Move-ADObject -Identity $pc.DistinguishedName -TargetPath $regle.OU -ErrorAction Stop
            Write-Log "Déplacé : $($pc.Name) -> $($regle.OU)"
        }
        catch {
            Write-Log "Échec : $($pc.Name) -> $($_.Exception.Message)"
        }
    }
}

Write-Log "=== Fin de l'exécution ===`n"
