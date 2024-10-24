#set variables
$ip = read-host "What is the IP Address of the server you want to connect to?"
$port = read-host "What is the port that RDP is using on the server? Standard RDP uses port 3389 but sometimes that is changed to a higher number."

#test connection before actually connecting
Test-NetConnection $ip -Port $port

$answer = read-host "Do you want to continue? Y/N"
if ($answer -eq "Y")
{
#create remote connection
mstsc /v:${ip}:${port}
}
else{exit}