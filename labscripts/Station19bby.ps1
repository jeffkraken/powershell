#Verify that DC19BBY gave Station19BBY a valid IP Address via DHCP 
# Get-NetIPAddress -AddressFamily IPv4 | Format-Table

#Set the Firewall to allow inbound and outbound ping over IPv4
# Enable-NetFirewallRule -Name FPS-ICMP4-*

#Set the Time Zone to "Central Standard Time"
# Set-TimeZone -Id "Central Standard Time"

#Create the Certs folder if it doesn't exist
# New-Item -Path C:\Certs -ItemType Directory -Force

#Generate a Digital Certificate for the current user on Station19BBY 
# $cert = New-SelfSignedCertificate -Subject $env:USERNAME -CertStoreLocation Cert:\LocalMachine\My
# Export-Certificate -Cert $cert -FilePath C:\Certs\Certificate.cer

#Share the new Digital Certificate over the network and allow "Everyone - Read" permissions
# New-SmbShare -Path C:\Certs -Name Certs -ReadAccess Everyone

#Firewall rules to ensure lab connectivity
# Enable-NetFirewallRule -DisplayGroup "File and Printer Sharing"
# Enable-NetFirewallRule -Name "FPS-ICMP4-In"

# Set the Hostname to Station19BBY
#Rename-Computer -NewName Station19BBY -Force

# Restart the VM
#Restart-Computer -Force
