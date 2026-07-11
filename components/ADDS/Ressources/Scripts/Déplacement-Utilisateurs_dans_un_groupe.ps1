Import-Module ActiveDirectory
Import-Module "C:\Scripts\Modules\XTechLogging.psm1" -ErrorAction Stop
$ScriptName = "DeplacementUtilisateursGroupe"

Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "=== Démarrage du script $ScriptName ==="

# --- Paramètres ---
$targetOU  = "OU=PRS-U,OU=PRS,DC=Xtech,DC=green"   # Vérifie ce DN exact via Get-ADOrganizationalUnit
$groupName = "GSE-GL-PRS-U"

# --- Récupération du groupe ---
try {
    $group = Get-ADGroup -Identity $groupName -ErrorAction Stop
}
catch {
    Write-XTechLog -ScriptName $ScriptName -Level "ERROR" -Message "Groupe '$groupName' introuvable : $($_.Exception.Message)"
    return
}

# --- Récupération des utilisateurs sous l'OU (y compris sous-OU), hors comptes admin ---
$users = Get-ADUser -SearchBase $targetOU -Filter * -Properties SamAccountName |
    Where-Object { $_.SamAccountName -notmatch '^(adm-|t0-|svc-)' }

Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "$($users.Count) utilisateur(s) standard(s) trouvé(s) sous $targetOU"

# --- Ajout au groupe ---
$successCount = 0
$failCount = 0

foreach ($user in $users) {
    try {
        Add-ADGroupMember -Identity $group -Members $user.DistinguishedName -ErrorAction Stop
        Write-XTechLog -ScriptName $ScriptName -Level "SUCCESS" -Message "$($user.SamAccountName) ajouté à $groupName"
        $successCount++
    }
    catch {
        Write-XTechLog -ScriptName $ScriptName -Level "ERROR" -Message "Échec ajout $($user.SamAccountName) : $($_.Exception.Message)"
        $failCount++
    }
}

Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "=== Résumé : $successCount ajouté(s), $failCount échec(s) ==="

# --- Vérification finale ---
Write-Host "`nMembres actuels de $groupName :" -ForegroundColor Cyan
Get-ADGroupMember -Identity $group | Select-Object Name, SamAccountName | Format-Table -AutoSize

Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "=== Fin du script $ScriptName ==="
