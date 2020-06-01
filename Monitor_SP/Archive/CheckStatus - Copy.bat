::run powershell script to check Services
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "& 'D:\MonitoringScripts\Monitor_SP\CheckService.ps1'"

::run powershell script to check Process
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "& 'D:\MonitoringScripts\Monitor_SP\CheckProcess.ps1'"
