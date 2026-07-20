Clear-Host
#############################################################################
#    Création OU automatiquement avec fichier                               #
#    (avec suppression protection contre la suppression)                    #
#############################################################################

Import-Module "C:\Scripts\Modules\XTechLogging.psm1" -ErrorAction Stop
$ScriptName = "CreationOU"

### Initialisation
$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
$DomainDN = (Get-ADDomain).DistinguishedName
$File     = "$FilePath\FichierOU2.txt"

Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message " Démarrage du script CreationOU "
Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "Domaine : $DomainDN | Fichier : $File"

if (-not (Test-Path $File)) {
    Write-XTechLog -ScriptName $ScriptName -Level "ERROR" -Message "Fichier introuvable : $File"
    exit 1
}

### Main
function CreateOU {
    param (
        [Parameter(Mandatory=$True)][String]$OU,
        [Parameter(Mandatory=$True)][String]$Path
    )

    If ((Get-ADOrganizationalUnit -Filter {Name -eq $OU} -SearchBase $Path -SearchScope OneLevel -ErrorAction SilentlyContinue) -eq $Null)
    {
        try {
            New-ADOrganizationalUnit -Name $OU -Path $Path -ProtectedFromAccidentalDeletion $false -ErrorAction Stop
            Write-XTechLog -ScriptName $ScriptName -Level "SUCCESS" -Message "OU créée : OU=$OU,$Path (protection contre suppression désactivée)"
        }
        catch {
            Write-XTechLog -ScriptName $ScriptName -Level "ERROR" -Message "Échec création OU $OU sous $Path : $($_.Exception.Message)"
        }
    }
    Else
    {
        Write-XTechLog -ScriptName $ScriptName -Level "WARNING" -Message "OU $OU existe déjà sous $Path, ignorée"
    }
}

# Le fichier attendu contient une ligne par OU, au format : NomOU;CheminParent
$OUList = Import-Csv -Path $File -Delimiter ";" -Header "OU","Path"

foreach ($ligne in $OUList) {
    CreateOU -OU $ligne.OU -Path $ligne.Path
}

Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message " Fin du script CreationOU "
