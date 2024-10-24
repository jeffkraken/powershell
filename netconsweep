$jobs = @()

1..254 | ForEach-Object {
    $ip = "10.0.0.$_"
    $jobs += Start-Job -ScriptBlock {
        param ($ip)
        $result = Test-NetConnection -ComputerName $ip -Port 135
        [PSCustomObject]@{
            IP = $ip
            Success = $result.TcpTestSucceeded
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
