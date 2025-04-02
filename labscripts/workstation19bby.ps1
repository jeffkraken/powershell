#Verify that DC19BBY gave Workstation19BBY a valid IP Address via DHCP 
# Get-NetIPAddress -AddressFamily IPv4 | Format-Table

#Set the Firewall to allow inbound and outbound ping over IPv4
# Enable-NetFirewallRule -Name FPS-ICMP4-*

#Set the Time Zone to "Central Standard Time"
# Set-TimeZone -Id "Central Standard Time"

#Create the Certs folder if it doesn't exist
# New-Item -Path C:\Certs -ItemType Directory -Force

#Generate a Digital Certificate for Workstation19BBY 
# $cert = New-SelfSignedCertificate -Subject $env:USERNAME -CertStoreLocation Cert:\LocalMachine\My
# Export-Certificate -Cert $cert -FilePath C:\Certs\Certificate.cer

#Share the new Digital Certificate over the network and allow "Everyone - Read" permissions
# New-SmbShare -Path C:\Certs -Name Certs -ReadAccess Everyone

# Set the Hostname to Workstation19BBY
#Rename-Computer -NewName Workstation19BBY -Force

# Restart the VM
#Restart-Computer -Force