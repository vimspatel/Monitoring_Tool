	
#Invoke-Command -ComputerName totdbadevws05 -FilePath c:\Users\ViPatel\Desktop\New\Monitor_SP\CheckService.ps1

$s = New-PSSession -ComputerName totdbadevws05 -Credential $credential

Invoke-Command -Session $s -Command {c:\Users\ViPatel\Desktop\New\Monitor_SP\CheckService.ps1}

Invoke-Command -Session $s -Command {c:\Users\ViPatel\Desktop\New\Monitor_SP\CheckProcess.ps1}