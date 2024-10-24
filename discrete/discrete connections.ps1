#Create a task to run the AD Script.
    $action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-File C:\checkssh.ps1"
    $trigger =  New-ScheduledTaskTrigger -AtLogOn
    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Discrete Connection"