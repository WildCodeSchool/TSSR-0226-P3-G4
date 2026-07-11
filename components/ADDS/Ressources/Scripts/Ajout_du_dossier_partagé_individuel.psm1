#############################################################
#         Ajout du dossier partagé individuel                #
#############################################################

Import-Module "C:\Scripts\Modules\XTechLogging.psm1" -ErrorAction Stop
$ScriptName = "AjoutDossierIndividuel"

Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "=== Démarrage du script $ScriptName ==="

try {
    $Users = Get-ADUser -Filter * -SearchBase "OU=Utilisateurs,OU=Paris,$DomainDN"
    $basePath = "\\XTS-417.Xtech.green\Partage_Individuel"

    Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "$($Users.Count) utilisateur(s) trouvé(s) sous l'OU cible"

    foreach ($User in $Users) {
        $folderPath = "$basePath\$($User.SamAccountName)"

        try {
            #Création de dossier pour chaque utilisateur
            New-Item -Path $folderPath -ItemType Directory -Force -ErrorAction Stop | Out-Null
            Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "Dossier créé : $folderPath"

            #Application des permissions NTFS
            $acl = Get-Acl -Path $folderPath
            $acl.SetAccessRuleProtection($true, $false) # Protéger les permissions contre l'héritage
            $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$($User.SamAccountName)", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
            $acl.SetAccessRule($rule)
            Set-Acl -Path $folderPath -AclObject $acl
            Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "Permissions NTFS appliquées pour $($User.SamAccountName)"

            #Liaison folder avec l'AD
            Set-ADUser -Identity $User -HomeDirectory $folderPath -HomeDrive "I:" -ErrorAction Stop
            Write-XTechLog -ScriptName $ScriptName -Level "SUCCESS" -Message "Dossier lié à l'AD pour $($User.SamAccountName) (I:)"
        }
        catch {
            Write-XTechLog -ScriptName $ScriptName -Level "ERROR" -Message "Échec pour $($User.SamAccountName) : $($_.Exception.Message)"
        }
    }
}
catch {
    Write-XTechLog -ScriptName $ScriptName -Level "ERROR" -Message "Erreur fatale : $($_.Exception.Message)"
}

Write-XTechLog -ScriptName $ScriptName -Level "INFO" -Message "=== Fin du script $ScriptName ==="
