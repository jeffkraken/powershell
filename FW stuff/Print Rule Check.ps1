$rules = Get-NetFirewallRule | Where-Object {$_.Name -match "Spool|Print|Spooler|Printer"}

if ($rules){
    foreach ($rule in $rules){
        if ($rule.Enabled -eq "True"){
            $action = if($rule.Action -eq "Allow") {"allowed"} else {"blocked"}
            Write-Host "$($rule.DisplayName) is enabled and is $action on $($rule.Program)"
        }
    }
}
else {
Write-Host "No Print Rules Found."
}