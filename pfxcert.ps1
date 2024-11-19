#generate password from DinoPass API
$password = (Invoke-WebRequest https://www.dinopass.com/password/strong).Content

#password error handling
try {
    $password = (Invoke-WebRequest https://www.dinopass.com/password/strong).Content
} catch {
    Write-Error "Failed to generate password from DinoPass API: $_"
    exit 1

#insecure function to store password
$password | Set-Content -Path "C:\SECRET"

# Create a self-signed certificate for the current user
$destinationFolder = "C:\Certificates"
if (!(Test-Path -Path $destinationFolder)) {
    New-Item -ItemType Directory -Path $destinationFolder
}
$user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$hostname = hostname

#create pfx cert
$cert = New-SelfSignedCertificate -CertStoreLocation Cert:\CurrentUser\My -Subject "E=$user, CN=$hostname"
$secure = ConvertTo-SecureString -String $password -Force -AsPlainText
Export-PfxCertificate -Cert $cert -FilePath "$destinationFolder\user_cert.pfx" -Password $secure
