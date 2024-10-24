# This is a script to start a VM

$act = Read-Host "Would you like to turn on a VM?"

if ($act -like "Y*")
{
do
{
Write-Host "Here are your current VMs"

$vmlist = @()
$vmid = 0

Get-VM | ForEach-Object {
$vmid ++
$vmlist += [PSCustomObject]@{ID = $vmid; VM =$_.Name}
$vmname = $_.Name
$vmstate = $_.State
Write-Host "VM Number: $vmid -- Name: $vmname -- State: $vmstate"
}

$selectedvm = Read-Host "Please Enter the ID of the VM you would like to start."
$selectedvm = $vmlist | Where-Object { $_.ID -eq [int]$selectedvm }

if ($selectedvm) {
    $vmtostart = $selectedvm.VM
    Start-VM -Name $vmtostart
    Write-Host "Starting VM: $vmtostart.Name"
    Write-Host "VM Connection Window will open soon."
    start-sleep -seconds 5
    VMConnect.exe localhost "$vmtostart"}
$act = Read-Host "Would you like to start another VM? Y/N"
}
until($act -like "N*")
}
else{write-host "G'bye"}