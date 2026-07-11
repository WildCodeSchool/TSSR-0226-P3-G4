#################################################################################
#             Désactivation et archivage des utilisateurs sortants              #
#################################################################################
#                                                                               #
# MODE 1 (par défaut) - Traitement en masse via un fichier CSV                  #
#   Le fichier doit contenir une colonne "SamAccountName" (un compte par ligne) #
#   .\Désactivation_Archivage_Utilisateurs.ps1                                  #
#                                                                               #
# MODE 2 - Traitement manuel d'un seul utilisateur (sans CSV)                   #
#   .\Désactivation_Archivage_Utilisateurs.ps1 -SamAccountName "jdupont"        #
#                                                                               #
#################################################################################

param(
    [string]$SamAccountName
)

Import-Module ActiveDirectory -ErrorAction Stop
Import-Module "C:\Scripts\Modules\XTechLogging.psm1" -ErrorAction Stop
$ScriptName = "DesactivationArchivageUtilisateurs"
$File      = "C:\Scripts\Utilisateurs_Sortants.txt"
$ArchiveOU = "OU=PRS-UAR,OU=PRS-Udd,OU=PRS,DC=Xtech,DC=green"   # <-- adapte ce DN à ta structure réelle

Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message " Début de l'exécution "

# Vérifie que l'OU d'archive existe
if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$ArchiveOU'" -ErrorAction SilentlyContinue)) {
    Write-XTechLog -ScriptName $ScriptName -Level "ERROR" -Message "OU d'archive introuvable : $ArchiveOU"
    exit 1
}

# Fonction commune : désactive et archive un utilisateur AD donné
function Disable-EtArchiverUtilisateur {
    param(
        [Microsoft.ActiveDirectory.Management.ADUser]$Utilisateur
    )

    $sam = $Utilisateur.SamAccountName

    try {
        # 1. Désactivation du compte
        Disable-ADAccount -Identity $Utilisateur.DistinguishedName -ErrorAction Stop
        Write-XTechLog -ScriptName $ScriptName -Level "SUCCESS" -Message "$sam : compte désactivé"

        # 2. Retrait de tous les groupes (hors groupe primaire "Domain Users")
        $groupes = Get-ADPrincipalGroupMembership -Identity $Utilisateur.DistinguishedName |
            Where-Object { $_.Name -ne "Domain Users" }

        foreach ($groupe in $groupes) {
            try {
                Remove-ADGroupMember -Identity $groupe -Members $Utilisateur.DistinguishedName -Confirm:$false -ErrorAction Stop
                Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "$sam : retiré du groupe $($groupe.Name)"
            }
            catch {
                Write-XTechLog -ScriptName $ScriptName -Level "WARNING" -Message "$sam : échec retrait du groupe $($groupe.Name) -> $($_.Exception.Message)"
            }
        }

        # 3. Marque la date de désactivation dans la description
        $dateArchivage = Get-Date -Format "yyyy-MM-dd"
        Set-ADUser -Identity $Utilisateur.DistinguishedName -Description "Compte désactivé le $dateArchivage - Archivé" -ErrorAction Stop
        Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "$sam : description mise à jour (date d'archivage)"

        # 4. Déplacement vers l'OU d'archive
        Move-ADObject -Identity $Utilisateur.DistinguishedName -TargetPath $ArchiveOU -ErrorAction Stop
        Write-XTechLog -ScriptName $ScriptName -Level "SUCCESS" -Message "$sam : déplacé vers $ArchiveOU"

        return "ok"
    }
    catch {
        Write-XTechLog -ScriptName $ScriptName -Level "ERROR" -Message "$sam : échec du traitement -> $($_.Exception.Message)"
        return "err"
    }
}

$compteurOK  = 0
$compteurErr = 0

# ==================================================================
# MODE 2 : un seul utilisateur ciblé manuellement, sans CSV
# ==================================================================
if ($SamAccountName) {

    Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "Mode manuel : utilisateur ciblé = $SamAccountName"

    $utilisateur = Get-ADUser -Identity $SamAccountName -ErrorAction SilentlyContinue

    if (-not $utilisateur) {
        Write-XTechLog -ScriptName $ScriptName -Level "ERROR" -Message "Utilisateur introuvable dans l'AD : $SamAccountName"
        Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message " Fin de l'exécution "
        exit 1
    }

    $resultat = Disable-EtArchiverUtilisateur -Utilisateur $utilisateur
    if ($resultat -eq "ok") { $compteurOK++ } else { $compteurErr++ }
}
# ==================================================================
# MODE 1 : traitement en masse via le CSV
# ==================================================================
else {

    if (-not (Test-Path $File)) {
        Write-XTechLog -ScriptName $ScriptName -Level "ERROR" -Message "Fichier introuvable : $File"
        exit 1
    }

    $Sortants = Import-Csv -Path $File -Delimiter ";" -Encoding UTF8
    Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "$($Sortants.Count) utilisateur(s) à traiter depuis $File"

    foreach ($ligne in $Sortants) {

        $sam = $ligne.SamAccountName

        if (-not $sam) {
            Write-XTechLog -ScriptName $ScriptName -Level "WARNING" -Message "Ligne ignorée (SamAccountName manquant)"
            continue
        }

        $utilisateur = Get-ADUser -Identity $sam -ErrorAction SilentlyContinue

        if (-not $utilisateur) {
            Write-XTechLog -ScriptName $ScriptName -Level "ERROR" -Message "Utilisateur introuvable dans l'AD : $sam"
            $compteurErr++
            continue
        }

        $resultat = Disable-EtArchiverUtilisateur -Utilisateur $utilisateur
        if ($resultat -eq "ok") { $compteurOK++ } else { $compteurErr++ }
    }
}

Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "=== Fin de l'exécution : $compteurOK traité(s) avec succès / $compteurErr en erreur ==="
Write-Host "Terminé. $compteurOK compte(s) désactivé(s) et archivé(s), $compteurErr en erreur. Voir C:\Logs\PS\$ScriptName.log" -ForegroundColor Green
