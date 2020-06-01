#Utility meant to be able to stop and start services 
#Script created by tradras

cls

#Read location of script folder.
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

#Creating results file
$OutputFile = New-Item -type file -force "$scriptPath\result.txt"

#Pulling username if exists, if not create.
$strUNFile = "$scriptPath\Creds\UN.txt"
If (Test-Path $strUNFile) {
    $username = cat $scriptPath\creds\UN.txt
} Else {
    "Please enter your username below"
    Read-Host | Out-File $scriptPath\creds\UN.txt
}
$username = cat $scriptPath\creds\UN.txt

#Pulling password from secure store if exists, if not create.
$strPWFile = "$scriptPath\Creds\pw.txt"
If (Test-Path $strPWFile) {
    $password = cat $scriptPath\creds\pw.txt | convertto-securestring
} Else {
    "Please enter your password below"
    Read-Host -AsSecureString | ConvertFrom-SecureString | Out-File $scriptPath\creds\pw.txt
}
$password = cat $scriptPath\creds\pw.txt | convertto-securestring

#Creating credential object to connect to servers
$credential = new-object -typename System.Management.Automation.PSCredential `
         -argumentlist $username, $password 

#Decide whether to stop or start a service.
DO {
$UserInput = Read-Host "Would you like to start or stop a service?"  
IF ($UserInput -eq "start") {$StopOrStart = "startservice"}  
    ELSEIF ($UserInput -eq "stop") {$StopOrStart = "stopservice"} 
    Else {$UserInput = "invalid"}
   }
while ($UserInput -eq "invalid")

#determine service to be stopped or started.
DO  {
$ServiceInput = Read-Host "Which service would you like to send $UserInput to?"  
IF ($ServiceInput -eq "IIS") {$Service = "W3SVC"}  
    ELSEIF ($ServiceInput -eq "pipeline") {$Service = "pipeline"}
    ELSEIF ($ServiceInput -eq "activityservices") {$Service = "activityservices"} 
    ELSEIF ($ServiceInput -eq "billingserver") {$Service = "billingserver"} 
        Else {$ServiceInput = "invalid"}
    }
while ($ServiceInput -eq "invalid")

#Import servers list
$computer = Import-CSV $scriptPath\Server_list.csv
$comp = $computer.ComputerName

Write-Host "Now perfroming $StopOrStart on the $service service for the following machines : $comp"

#Check results of run and write to log and screen.
$result = (gwmi win32_service -computername $Comp -filter "name='$service'" -Credential $credential).$StopOrStart()  
    If ($result.ReturnValue -eq "0") 
    {
    write-host "$Comp -> $service was sent $stopOrStart Successfully."
    "$Comp -> $service was sent $stopOrStart Successfully." | Out-File $OutputFile -encoding ASCII -append
    }
    else
    {
    write-host "$Comp -> $service did NOT successfully process the $StopOrStart sent to it, please try again."
    "$Comp -> $service did NOT successfully process the $StopOrStart sent to it, please try again." | Out-File $OutputFile -encoding ASCII -append

}