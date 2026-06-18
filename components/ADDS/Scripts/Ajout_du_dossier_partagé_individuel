$Users = Get-ADUser -Filter * -SearchBase "OU=Utilisateurs,OU=Paris,$DomainDN"
$basePath = "\\XTS-417.Xtech.green\Partage_Individuel"

foreach ($User in $Users) {
    $folderPath = "$basePath\$($User.SamAccountName)"

    #Création de dossier pour chaque utilisateur
    New-Item -Path $folderPath -ItemType Directory -Force

    #Application des permissions NTFS
    $acl = Get-Acl -Path $folderPath
    $acl.SetAccessRuleProtection($true, $false) # Protéger les permissions contre l'héritage
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$($User.SamAccountName)", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.SetAccessRule($rule)
    Set-Acl -Path $folderPath -AclObject $acl

    #Liaison folder avec l'AD
    Set-ADUser -Identity $user -HomeDirectory $folderPath -HomeDrive "I:"
}
