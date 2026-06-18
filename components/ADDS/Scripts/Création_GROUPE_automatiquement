Clear-Host
####################################
#                                  #
# Création GROUPE automatiquement  #
#                                  #
####################################
### Parametre(s) à modifier
$Groupes = "Groupe"
$Groups = "GSE-GLD1-s1","GSE-GLD1-s2","GSE-GLD1-s3","GSE-GLD1-s4","GSE-GLD1-s5","GSE-GLD1-s6",`
          "GSE-GLD2-s1", "GSE-GLD2-s2", "GSE-GLD2-s3", "GSE-GLD2-s4", "GSE-GLD2-s5",`
          "GSE-GLD3-s1", "GSE-GLD3-s2", "GSE-GLD3-s3",`
          "GSE-GLD4-s1", "GSE-GLD4-s2", "GSE-GLD4-s3", "GSE-GLD4-s4",`
          "GSE-GLD5-s1", "GSE-GLD5-s2", "GSE-GLD5-s3",`
          "GSE-GLD6-s1", "GSE-GLD6-s2",`
          "GSE-GLD7-s1", "GSE-GLD7-s2", "GSE-GLD7-s3", "GSE-GLD7-s4",`
          "GSE-GLD8-s1", "GSE-GLD8-s2",`
          "GSE-GLD9-s1", "GSE-GLD9-s2",`
          "GSE-GLD10-s1", "GSE-GLD10-s2", "GSE-GLD10-s3", "GSE-GLD10-s4", "GSE-GLD10-s5", "GSE-GLD10-s6", "GSE-GLD10-s7",`
          "GSE-GLD11-s1", "GSE-GLD11-s2", "GSE-GLD11-s3", "GSE-GLD11-s4",`
          `

### Initialisation
$DomainDN = (Get-ADDomain).DistinguishedName
### Main program
Foreach ($Group in $Groups)
{
    Try
    {
        New-ADGroup -Name $Group -Path "ou=$OuGroupes,ou=Utilisateurs,ou=Paris,$DomainDN" -GroupScope Global -GroupCategory Security
        Write-Host "Création du GROUPE $Group dans l'OU ou=$OuGroupes,$DomainDN" -ForegroundColor Green
    }
    Catch
    {
        Write-Host "Le GROUPE $Group existe déjà" -ForegroundColor Yellow -BackgroundColor Black
    }
}
