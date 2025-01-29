##created to demonstrate loops, if/elseif/else, variables, and command chaining/substitution

#while loop, continues "while" the specified variable meets the conditions of the loop.
$loop1 = "Y"
while ($loop1 -like "Y*")
{write-host "This script searches for stopped services related to printing and starts them."
$continue = read-host "Would you like to scan for stopped print services? Y/N"

#if/else statement, depending on the user response, the script will process the "if" statement or the "elseif" statement if the variable meets the conditions.
if ($continue -like "Y*")
{
write-host "Good, we'll do that."
pause

#variable and command chaining/substitution, by passing a command into a variable, the output of the command can be used as the input for another command.
$services = get-service | where-object {$_.DisplayName -like "*print*" -and $_.Status -like "Stopped"}
if ($services)
{
#a foreach loop is similar to while loops. However, this only processes "foreach" item inside of the called variable.
foreach ($service in $services)
{start-service -name $service.Name
write-host "Started $($service.name)"
}}
else{write-host "No stopped print services."}
}
elseif ($continue -like "N*")
{write-host "Okay, we won't continue"}
else{write-host "Ok, that's a Y or a N."}
#finally, with while loops, always include a way to change or modify the called variable INSIDE the loop or it will run until stopped and can cause process/system issues.
$loop1 = read-host "Try again? Y/N"}
pause