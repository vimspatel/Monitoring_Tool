::Check Service Status
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "& 'D:\MonitoringScripts\Monitor_SP\Check_Service.ps1'"

::Check Process Status
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "& 'D:\MonitoringScripts\Monitor_SP\Check_Process.ps1'"

::Check Disk Status
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "& 'D:\MonitoringScripts\Monitor_SP\Disk_Space_Monitoring.ps1'"

::Check Performance 
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "& 'D:\MonitoringScripts\Monitor_SP\Get-PerformanceBaseline.ps1'"

