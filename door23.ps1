Clear-Host; $VerbosePreference="Continue"; $Port=23
$EndPoint=[System.Net.IPEndPoint]::new([System.Net.IPAddress]::Parse("<ip address>"),$Port)
$Listener=[System.Net.Sockets.TcpListener]::new($EndPoint)

$KeepListening=$true
$Listener.Start()

while ($KeepListening) {
  while (!$Listener.Pending) { Start-Sleep -Milliseconds 100 }

  $Client=$Listener.AcceptTcpClient()
  Write-Output "Connection established with $($Client.Client.RemoteEndPoint.Address):$($Client.Client.RemoteEndPoint.Port)"

  $Stream=$Client.GetStream()
  $Timer=10; $Ticks=0; $Continue=$true
  $Response=[System.Text.Encoding]::UTF8.GetBytes("System: Connection established. Timeout in $($Timer.ToString()) seconds.`r`nPress <space> to extend timeout.`r`nType 'q' to end session.`r`nType 'x' to stop server.`r`n`r`n")
  $Stream.Write($Response,0,$Response.Length)

  $StartTimer=(Get-Date).Ticks
  while (($Timer -gt 0)  -and $Continue) {
    if ($Stream.DataAvailable) {
      $Buffer=$Stream.ReadByte()
      Write-Output "Received Data: $($Buffer.ToString())"
      if ($Buffer -eq 113) {  # 'q'
        $Continue=$false
        $Response=[System.Text.Encoding]::UTF8.GetBytes("System: Ending session. Goodbye!`r`n")
      }
      elseif ($Buffer -eq 32) {  # Space
        $Timer+=10
        $Response=[System.Text.Encoding]::UTF8.GetBytes("System: Timeout extended. New timeout: $($Timer.ToString()) seconds.`r`n")
      }
      elseif ($Buffer -eq 120) {  # 'x'
        $Continue=$false
        $KeepListening=$false
        $Response=[System.Text.Encoding]::UTF8.GetBytes("System: Server is shutting down.`r`n")
      }
      else { 
        $Response=[System.Text.Encoding]::UTF8.GetBytes("System: Invalid input. Timeout in $($Timer.ToString()) seconds.`r`nPress <space> to extend timeout.`r`nType 'q' to end session.`r`nType 'x' to stop server.`r`n`r`n") 
      }

      $Stream.Write($Response,0,$Response.Length)
    }
    $EndTimer=(Get-Date).Ticks
    $Ticks=$EndTimer-$StartTimer
    if ($Ticks -gt 10000000) { $Timer--; $StartTimer=(Get-Date).Ticks }
  }

  $Client.Close()
}
$Listener.Stop()
