Import-Module ActiveDirectory
Import-Module "C:\Scripts\Modules\XTechLogging.psm1" -ErrorAction Stop
$ScriptName = "RestrictionHorairesUtilisateurs"

Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "=== Démarrage du script $ScriptName ==="

# Forcer un DC unique pour toute l'exécution
$dc = (Get-ADDomainController -Discover).HostName[0]
Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "DC utilisé : $dc"

# Fonction : construction du masque logonHours
function Build-LogonHoursMask {
    param([hashtable]$Schedule)
    $hours = New-Object byte[] 21
    foreach ($day in $Schedule.Keys) {
        foreach ($h in $Schedule[$day]) {
            $bitIndex   = ($day * 24) + $h
            $byteIndex  = [math]::Floor($bitIndex / 8)
            $bitInByte  = $bitIndex % 8
            $hours[$byteIndex] = $hours[$byteIndex] -bor (1 -shl $bitInByte)
        }
    }
    return $hours
}

# Planning : Lun-Ven 7h-20h, Samedi 8h-13h, Dimanche fermé
$weekdayHours  = 7..19   # 07:00 -> 20:00
$saturdayHours = 8..12   # 08:00 -> 13:00

$schedule = @{
    0 = @()             # Dimanche
    1 = $weekdayHours   # Lundi
    2 = $weekdayHours   # Mardi
    3 = $weekdayHours   # Mercredi
    4 = $weekdayHours   # Jeudi
    5 = $weekdayHours   # Vendredi
    6 = $saturdayHours  # Samedi
}

$mask = Build-LogonHoursMask -Schedule $schedule
Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "Taille du masque généré : $($mask.Length) (doit être 21)"

# Fonction : application via DirectoryEntry
function Set-LogonHoursMask {
    param(
        [string]$DistinguishedName,
        [byte[]]$Mask
    )
    try {
        $de = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$DistinguishedName")
        $de.Properties["logonHours"].Clear()
        $de.Properties["logonHours"].Add($Mask) | Out-Null
        $de.CommitChanges()
        $de.Close()
        return $true
    }
    catch {
        throw $_
    }
}

# Récupération des utilisateurs cibles (hors comptes privilégiés)
$targetOU = "OU=Paris,DC=Xtech,DC=green"   # <-- Vérifie/adapte ce DN exact via Get-ADOrganizationalUnit

$users = Get-ADUser -SearchBase $targetOU -Filter * -Properties SamAccountName -Server $dc |
    Where-Object { $_.SamAccountName -notmatch '^(adm-|t0-|svc-)' }

Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "$($users.Count) utilisateur(s) à traiter"

# Boucle d'application
$successCount = 0
$failCount = 0

foreach ($user in $users) {
    try {
        Set-LogonHoursMask -DistinguishedName $user.DistinguishedName -Mask $mask
        Write-XTechLog -ScriptName $ScriptName -Level "SUCCESS" -Message "$($user.SamAccountName) : horaires appliqués"
        $successCount++
    }
    catch {
        Write-XTechLog -ScriptName $ScriptName -Level "ERROR" -Message "$($user.SamAccountName) : $($_.Exception.Message)"
        $failCount++
    }
}

Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "=== Résumé : $successCount succès, $failCount échec(s) ==="
Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "=== Fin du script $ScriptName ==="
