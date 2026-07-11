#################################################
# Module  : XTechLogging.psm1
# Auteur  : XTech.green
# Usage   : Import-Module "\\XTS-417.xtech.green\Scripts\Modules\XTechLogging.psm1"
# Rôle    : Centralise l'écriture des logs fichier + Event Viewer
#################################################

$Global:LogDir = "C:\Logs\PS"

function Write-XTechLog {
    param(
        [Parameter(Mandatory=$true)][string]$ScriptName,
        [Parameter(Mandatory=$true)][string]$Message,
        [ValidateSet("INFO","WARNING","ERROR","SUCCESS")]
        [string]$Level = "INFO"
    )

    # --- Dossier log ---
    if (-not (Test-Path $Global:LogDir)) {
        New-Item -ItemType Directory -Path $Global:LogDir -Force | Out-Null
    }

    $LogFile  = "$Global:LogDir\$ScriptName.log"
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $Entry    = "[$TimeStamp] [$Level] $Message"

    # --- Fichier log (un seul par script) ---
    Add-Content -Path $LogFile -Value $Entry -Encoding UTF8

    # --- Event Viewer (journal Application, Source XTech) ---
    $Source = "XTech-$ScriptName"
    if (-not [System.Diagnostics.EventLog]::SourceExists($Source)) {
        try {
            New-EventLog -LogName "Application" -Source $Source -ErrorAction Stop
        } catch {
            # Source déjà enregistrée par un autre processus, on continue
        }
    }

    $EventId = switch ($Level) {
        "INFO"    { 1000 }
        "SUCCESS" { 1001 }
        "WARNING" { 1002 }
        "ERROR"   { 1003 }
    }

    $EntryType = switch ($Level) {
        "INFO"    { "Information" }
        "SUCCESS" { "Information" }
        "WARNING" { "Warning" }
        "ERROR"   { "Error" }
    }

    try {
        Write-EventLog -LogName "Application" -Source $Source `
                        -EventId $EventId -EntryType $EntryType -Message $Entry
    } catch {
        Write-Host "Attention : écriture Event Viewer échouée pour '$Source'" -ForegroundColor Red
    }

    # --- Affichage console coloré ---
    $Color = switch ($Level) {
        "INFO"    { "Cyan" }
        "SUCCESS" { "Green" }
        "WARNING" { "Yellow" }
        "ERROR"   { "Red" }
    }
    Write-Host $Entry -ForegroundColor $Color
}
