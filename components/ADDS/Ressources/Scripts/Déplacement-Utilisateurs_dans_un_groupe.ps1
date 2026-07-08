Import-Module ActiveDirectory

# --- Paramètres ---
$targetOU  = "OU=PRS-U,OU=PRS,DC=Xtech,DC=green"   # Vérifie ce DN exact via Get-ADOrganizationalUnit
$groupName = "GSE-GL-PRS-U"

# --- Récupération du groupe ---
try {
    $group = Get-ADGroup -Identity $groupName
}
catch {
    Write-Host "Groupe '$groupName' introuvable. Vérifie le nom exact." -ForegroundColor Red
    return
}

# --- Récupération des utilisateurs sous l'OU (y compris sous-OU), hors comptes admin ---
$users = Get-ADUser -SearchBase $targetOU -Filter * -Properties SamAccountName |
    Where-Object { $_.SamAccountName -notmatch '^(adm-|t0-|svc-)' }

Write-Host "$($users.Count) utilisateur(s) standard(s) trouvé(s) sous $targetOU`n" -ForegroundColor Cyan

# --- Ajout au groupe ---
$successCount = 0
$failCount = 0

foreach ($user in $users) {
    try {
        Add-ADGroupMember -Identity $group -Members $user.DistinguishedName -ErrorAction Stop
        Write-Host "OK    - $($user.SamAccountName) ajouté à $groupName" -ForegroundColor Green
        $successCount++
    }
    catch {
        Write-Host "ECHEC - $($user.SamAccountName) : $($_.Exception.Message)" -ForegroundColor Red
        $failCount++
    }
}

Write-Host "`n===== Résumé =====" -ForegroundColor Cyan
Write-Host "Ajoutés : $successCount" -ForegroundColor Green
Write-Host "Échecs  : $failCount" -ForegroundColor Red

# --- Vérification finale ---
Write-Host "`nMembres actuels de $groupName :" -ForegroundColor Cyan
Get-ADGroupMember -Identity $group | Select-Object Name, SamAccountName | Format-Table -AutoSize
