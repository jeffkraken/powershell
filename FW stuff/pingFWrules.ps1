#Check if inbound ping rule is enabled.
#Enable if not enabled.
Get-NetFirewallRule | Where-Object {$_.DisplayName -like "File*ICMPv4*In*"}
if ($_.Enabled -like "F*")
{Enable-NetFirewallRule -DisplayName $_.DisplayName}
else {$in = "T"}

#Check if outbound ping rule is enabled.
#enable if not enabled.
Get-NetFirewallRule | Where-Object {$_.DisplayName -like "File*ICMPv4*Out*"}
if ($_.Enabled -like "F*")
{Enable-NetFirewallRule -DisplayName $_.DisplayName}
else {$out = "T"}

clear-host

if ($in -like "T" -and $out -like "T")
{Write-Host "Both inbound outbound ping rules were already enabled."}
elseif ($in -notlike "T" -and $out -like "T")
{Write-Host "Inbound rule was not set, it has now been set. `n Outbound rule was already set."}
elseif ($in -like "T" -and $out -notlike "T")
{Write-Host "Outbound rule was not set, it has now been set. `n Inbound rule was already set."}
else {Write-Host "Neither inbound or outbound ping rules were set, but now they are."}