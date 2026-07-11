#Défini ce que je veux executer
$action = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -File `"C:\chemin\DuScript.ps1`""

#Défini quand la tache doit s'executer
$trigger = New-ScheduledTaskTrigger -Daily -At 11pm

#Définit quel compte execute la tâche et avec quels droits.
$principal = New-ScheduledTaskPrincipal -UserId "XTECH\svc-adtasks" `
    -LogonType Password -RunLevel Highest

#Multiple execution en cas de crash ou de serveur eteint au moment où la tâche devrait se lancer
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable `
    -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 5)

#Enregistre la tâche dans le planificateur
Register-ScheduledTask -TaskName "Nom de la tache a executer" `
    -Action $action -Trigger $trigger -Principal $principal -Settings $settings `
    -Description "description de la tache a executer"
