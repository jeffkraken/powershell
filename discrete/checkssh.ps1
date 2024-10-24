$service = Get-Service sshd
if ($service.Status -notlike "R*")
{start-service sshd}
else {Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"C:\openssh`"" -Verb RunAs}