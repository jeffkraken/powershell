$jobs = @()
30..35 | ForEach-Object {
    $ip = "192.168.86.$_"
    $jobs += Start-Job -ScriptBlock {
        param ($ip)
        $result = Test-NetConnection $ip -InformationLevel Quiet
        [PSCustomObject]@{
            IP = $ip
            Success = $result
        }
    } -ArgumentList $ip
}

$jobs | ForEach-Object { $_ | Wait-Job }
$results = $jobs | ForEach-Object {
    Receive-Job -Job $_
}

$jobs | ForEach-Object { $_ | Remove-Job }
$results | ForEach-Object {
    "$($_.IP): $($_.Success)"
}
