Clear-Host
#############################################################################
#                                                                           #
#    Création OU automatiquement avec fichier                               #
#    (avec suppression protection contre la suppression)                    #
#                                                                           #
#############################################################################

Import-Module "C:\Scripts\Modules\XTechLogging.psm1" -ErrorAction Stop
$ScriptName = "CreationOU"

### Initialisation
$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
$DomainDN = (Get-ADDomain).DistinguishedName
$File     = "$FilePath\FichierOU2.txt"

Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "=== Démarrage du script CreationOU ==="
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
        New-ADOrganizationalUnit -Name $OU -Path $Path
        $OUObj =
