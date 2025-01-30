# Check if module is installed, and install it if not
if (-not (Get-Module -ListAvailable -Name AudioDeviceCmdlets)) {
    Write-Host "AudioDeviceCmdlets module not found. Installing..."
    Install-Module -Name AudioDeviceCmdlets -Force -Scope CurrentUser
    Import-Module AudioDeviceCmdlets
    Write-Host "AudioDeviceCmdlets module installed and imported."
} else {
    Write-Host "AudioDeviceCmdlets module is already installed."
    Import-Module AudioDeviceCmdlets
}
pause
# Update drivers
Write-Host "Updating audio drivers..."
$audioDevices = Get-PnpDevice -Class "Sound, video, and game controllers" -Status OK
foreach ($device in $audioDevices) {
    Write-Host "Updating driver for: $($device.FriendlyName)"
    Update-Driver -InstanceId $device.InstanceId -Force -ErrorAction SilentlyContinue
}
Write-Host "Audio driver update process completed."

# Disable enhancements for all playback devices
Write-Host "Disabling audio enhancements..."
$playbackDevices = Get-AudioDevice -Playback
foreach ($device in $playbackDevices) {
    Write-Host "Disabling enhancements for: $($device.Name)"
    Set-AudioDevice -ID $device.ID -Enhancements $false
}
Write-Host "Audio enhancements disabled for all playback devices."

# Restart the Windows Audio service
Write-Host "Restarting Windows Audio service..."
Restart-Service -Name "Audiosrv" -Force
Write-Host "Windows Audio service restarted."
pause
