#############################################################
#                                                           #
# Déplacement automatique des ordinateurs dans la bonne OU  #
#                                                           #
#############################################################

Import-Module ActiveDirectory -ErrorAction Stop
Import-Module "C:\Scripts\Modules\XTechLogging.psm1" -ErrorAction Stop
$ScriptName = "DeplacementOrdinateursOU"

# Mapping : motif du nom -> OU cible
$Mapping = @(
    @{ Pattern = "XTAD-*"; OU = "OU=PRS-OAD,OU=PRS-O,OU=Paris,DC=Xtech,DC=green" }
    @{ Pattern = "XT-OD*"; OU = "OU=PRS-OCL,OU=PRS-O,OU=Paris,DC=Xtech,DC=green" }
    @{ Pattern = "XTSE-*"; OU = "OU=PRS-OSE,OU=PRS-O,OU=Paris,DC=Xtech,DC=green" }
    @{ Pattern = "XTRO-*"; OU = "OU=PRS-OSE,OU=PRS-O,OU=Paris,DC=Xtech,DC=green" }
)

Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "=== Début de l'exécution ==="

foreach ($regle in $Mapping) {

    # Vérifie que l'OU cible existe
    if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$($regle.OU)'" -ErrorAction SilentlyContinue)) {
        Write-XTechLog -ScriptName $ScriptName -Level "ERROR" -Message "OU introuvable -> $($regle.OU)"
        continue
    }

    # Récupère les PC dont le nom correspond au motif
    $PCs = Get-ADComputer -Filter "Name -like '$($regle.Pattern)'" -Properties DistinguishedName

    foreach ($pc in $PCs) {
        # Ignore s'il est déjà dans la bonne OU
        if ($pc.DistinguishedName -like "*$($regle.OU)") { continue }

        try {
            Move-ADObject -Identity $pc.DistinguishedName -TargetPath $regle.OU -ErrorAction Stop
            Write-XTechLog -ScriptName $ScriptName -Level "SUCCESS" -Message "Déplacé : $($pc.Name) -> $($regle.OU)"
        }
        catch {
            Write-XTechLog -ScriptName $ScriptName -Level "ERROR" -Message "Échec : $($pc.Name) -> $($_.Exception.Message)"
        }
    }
}

Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "=== Fin de l'exécution ==="
