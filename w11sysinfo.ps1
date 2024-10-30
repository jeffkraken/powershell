#sysinfo

$hostname = hostname
$os_version = (Get-WmiObject -Class Win32_OperatingSystem).Version
$current_user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

$network_info = Get-NetIPAddress | Select-Object InterfaceAlias, IPAddress, AddressFamily

#Display

Write-Output "Computer name: $hostname"
Write-Output "OS Version: $os_version"
Write-Output "Current User: $current_user"
Write-Output "Network information: "
$network_info | ForEach-Object {Write-Output "`t $($_.InterfaceAlias): $($_.IPAddress)"}
