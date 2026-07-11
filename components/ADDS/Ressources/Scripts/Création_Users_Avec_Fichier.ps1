##################################################################################################
#                                                                                                #
# Création USER automatiquement avec fichier (avec suppression protection contre la suppression) #
#                                                                                                #
##################################################################################################

Import-Module "C:\Scripts\Modules\XTechLogging.psm1" -ErrorAction Stop
$ScriptName = "CreationUsers"

$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)

### Parametre(s) à modifier

$File = "$FilePath\Creation_Users2.txt"

### Main program

Clear-Host

Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "=== Démarrage du script $ScriptName ==="

# Voir si l'affichage du .csv est correct

If (-not(Get-Module -Name activedirectory))
{
    Import-Module activedirectory
}
#"No"

# fonction de suppression de caractère spéciaux

$Users = @(Import-Csv -Path $File -Delimiter ";" -Encoding UTF8)
Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "$($Users.Count) utilisateur(s) à traiter depuis $File"
#$
$ADUsers = Get-ADUser -Filter * -Properties *
$count = 1

# fonction de suppression de caractère spéciaux et espace
function Remove-Accents {
    param([string]$Texte)
    $d = $Texte.Normalize([Text.NormalizationForm]::FormD)
    (-join ($d.ToCharArray() | Where-Object {
        [Globalization.CharUnicodeInfo]::GetUnicodeCategory($_) -ne 'NonSpacingMark'
    })).Normalize([Text.NormalizationForm]::FormC) -replace '\s', ''
}

Foreach ($User in $Users)
{
    Write-Progress -Activity "Création des utilisateurs dans l'OU" -Status "%effectué" -PercentComplete ($Count/$Users.Length*100)
    # $ variable qui rappelle la fonction (Remove-Accents) pour les prenoms et noms
    $Prenom            = ((Remove-Accents $User.Prénom) -replace '\s', '')
    $Nom               = ((Remove-Accents $User.Nom) -replace '\s', '')
    $Name              = "$Prenom.$Nom"
    $DisplayName       = "$Prenom.$Nom"
    # Rappel de la fonction (Remove-Accents) + -replace pour supprimer les accents
    $SamAccountName    = ((Remove-Accents "$($User.Prénom.substring(0,1))$($User.Nom)") -replace '\s', '').ToLower()
    $SamAccountName    = $SamAccountName.Substring(0, [Math]::Min(20, $SamAccountName.length))
    $UserPrincipalName = (($User.Prénom.substring(0,1).tolower() + $User.Nom.ToLower()) + "@" + (Get-ADDomain).Forest)
    $GivenName         = $User.Prénom
    $Surname           = $User.Nom
    $Office            = $User.Société
    $Description       = $User.fonction
    $OfficePhone       = if ($User.'Téléphone fixe'.Trim() -eq '-') {$User.'Téléphone portable'} else {$User.'Téléphone fixe'}
    $EmailAddress      = $UserPrincipalName -replace '\s', ''
    $Path              = "OU=$($User.Département),OU=Utilisateurs,OU=Paris,dc=Xtech,dc=green"
    $Company           = "Ma Societe"
    $Departement       = "$($User.Département)"
    $Service           = "$($User.Service)"

    If (($ADUsers | Where {$_.SamAccountName -eq $SamAccountName}) -eq $Null)
    {
        try {
            New-ADUser -Name $Name -DisplayName $DisplayName -SamAccountName $SamAccountName -UserPrincipalName $UserPrincipalName `
            -GivenName $GivenName -Surname $Surname -Office $Office -Description $Description -OfficePhone $OfficePhone -EmailAddress $EmailAddress `
            -Path $Path -AccountPassword (ConvertTo-SecureString -AsPlainText "P@ssw0rd2026!" -Force) -Enabled $True `
            -OtherAttributes @{Company = $Company; personalTitle = $civilite} -ChangePasswordAtLogon $True -ErrorAction Stop
            Write-XTechLog -ScriptName $ScriptName -Level "SUCCESS" -Message "Création du USER $SamAccountName ($Name) dans $Path"
        }
        catch {
            Write-XTechLog -ScriptName $ScriptName -Level "ERROR" -Message "Échec création USER $SamAccountName : $($_.Exception.Message)"
        }
    }
    Else
    {
        Write-XTechLog -ScriptName $ScriptName -Level "WARNING" -Message "Le USER $SamAccountName existe déjà"
    }
    $Count++
    sleep -Milliseconds 100
}

Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "=== Fin du script $ScriptName ==="
