## Enter Detail 
$data_servername = "DESKTOP-GKOFLPN\DEV500"
$data_database = "SQLPERF_VP"
$your_user = $null
$your_password =$null
$integrated_security = "True"
$error_location = "D:\MonitoringScripts\Monitor_SP\Error_bin\output_diskspace_error.txt"
########################################################################################################

################################## Get Disk Space Function #########################################

function diskstatus($computer)
{
  $disks = Get-WmiObject -ComputerName $computer -Class Win32_LogicalDisk -Filter "DriveType = 3" 
 $computer = $computer.toupper() 
  foreach($disk in $disks) 
    {         
      $deviceID = $disk.DeviceID; 
            $volName = $disk.VolumeName; 
      [float]$size = $disk.Size; 
      [float]$freespace = $disk.FreeSpace;  
      $percentFree = [Math]::Round(($freespace / $size) * 100); 
      $sizeGB = [Math]::Round($size / 1073741824, 2); 
      $freeSpaceGB = [Math]::Round($freespace / 1073741824, 2); 
            $usedSpaceGB = [Math]::Round($sizeGB - $freeSpaceGB, 2); 
            $color = $whiteColor; 
    # Start processing RAM 		
      $RAM = Get-WmiObject -ComputerName $computer -Class Win32_OperatingSystem
	    $RAMtotal = [Math]::Round(($RAM.TotalVisibleMemorySize),2);
	    $RAMAvail = [Math]::Round(($RAM.FreePhysicalMemory),2);
		    $RAMpercent = [Math]::Round(($RAMavail / $RAMTotal) * 100,2);
    # Start processing CPU
        # Processor utilization
        $CPU = (Get-WmiObject -ComputerName $computer -Class win32_processor -ErrorAction Stop | Measure-Object -Property LoadPercentage -Average | Select-Object Average).Average
        $CPUpercent = [Math]::Round($CPU,2);		

        #Call the function to transform the data and prepare the data for insertion
        writediskstatusInfo $computer $deviceID $volName $sizeGB $usedSpaceGB $freeSpaceGB $percentFree $RAMpercent $CPUpercent
    }
}

################################# Function to Capture disk Status data into table ###########################

#Fucntion to manipulate the data
Function writediskstatusInfo
{
Param($SN,$D,$DL,$TC,$UC,$FS,$FSPER,$RAM,$CPU)
try{
 $date= Get-date
# Data preparation for loading data into SQL table 
$InsertDiskResults = @"
INSERT INTO [dbo].[VP_DISK_STATUS_POWERSHELL](Server_Name,Drive,Drive_Label,Total_Capacity,Used_Capacity,Free_Space,Free_Space_inperc,RAM_inperc,CPU_inperc,Metric_Date)
VALUES ('$SN','$D','$DL','$TC','$UC','$FS','$FSPER','$RAM','$CPU','$date')
"@      
#call the invoke-sqlcmdlet to execute the query
         ExecuteSqlQuery -sqlquery $InsertDiskResults
         }catch{
         Write-Host $SN $D $DL $TC $UC $FS $FSPER $RAM $CPU $datewrite-host 'here' $_.Exception }
}

################################# Function to Delete Old data From table ###############################
#Fucntion to delete the old data
<#
Function deleteold
{

# Delete query
$DeleteResults = @"
DELETE FROM [VP_DISK_STATUS_POWERSHELL]
WHERE Status_Date < DATEADD(dd,-1,GETDATE())
"@      
#call the invoke-sqlcmdlet to execute the query
         ExecuteSqlQuery -sqlquery $DeleteResults
}
#>


########################################################################################################

################################## Get Service Status for each server ##################################

Invoke-Command {
# 1 DEFINE HELPER FUNCTIONS (CAN BE REUSED)
# function that connects to an instance of SQL Server / Azure SQL Server and saves the 
# connection object as a global variable for future reuse
function ConnectToDB {
    # define parameters
    param(
        [string]
        $servername,
        [string]
        $database,
        [string]
        $sqluser,
        [string]
        $sqlpassword
    )
    # create connection and save it as global variable
    $global:Connection = New-Object System.Data.SQLClient.SQLConnection
    $Connection.ConnectionString = "server='$servername';database='$database';trusted_connection=True; user id = '$sqluser'; Password = '$sqlpassword'; integrated security= $integrated_security"
    $Connection.Open()
    Write-Verbose 'Connection established'
}
# function that executes sql commands against an existing Connection object; In pur case
# the connection object is saved by the ConnectToDB function as a global variable
function ExecuteSqlQuery {
    # define parameters
    param(
     
        [string]
        $sqlquery
    
    )
    
    Begin {
        If (!$Connection) {
            Throw "No connection to the database detected. Run command ConnectToDB first."
        }
        elseif ($Connection.State -eq 'Closed') {
            Write-Verbose 'Connection to the database is closed. Re-opening connection...'
            try {
                # if connection was closed (by an error in the previous script) then try reopen it for this query
                $Connection.Open()
            }
            catch {
                Write-Verbose "Error re-opening connection. Removing connection variable."
                Remove-Variable -Scope Global -Name Connection
                throw "Unable to re-open connection to the database. Please reconnect using the ConnectToDB commandlet. Error is $($_.exception)."
            }
        }
    }
    
    Process {
        #$Command = New-Object System.Data.SQLClient.SQLCommand
        $command = $Connection.CreateCommand()
        $command.CommandText = $sqlquery
    
        Write-Verbose "Running SQL query '$sqlquery'"
        try {
            $result = $command.ExecuteReader()      
        }
        catch {
            $Connection.Close()
        }
        $Datatable = New-Object "System.Data.Datatable"
        $Datatable.Load($result)
        return $Datatable          
    }
    End {
        Write-Verbose "Finished running SQL query."
    }
}
# 2 BEGIN EXECUTE (CONNECT ONCE, EXECUTE ALL QUERIES)

ConnectToDB -servername $data_servername -database $data_database -sqluser $your_user -sqlpassword $your_password

# declaration not necessary, but good practice
$resultsDataTable = New-Object System.Data.DataTable
$resultsDataTable = ExecuteSqlQuery -sqlquery 'SELECT * FROM [VP_SERVER_LIST] WHERE ACTIVE_FLAG = 1' 

#validate we got data
Write-Host ("The table contains: " + $resultsDataTable.Rows.Count + " rows")

#loop though each row
FOREACH($row in $resultsDataTable){

Write-Host $row.Description $row.SERVER_NAME

#assigning variable to each column of the row
$report_Server_Name = $row.SERVER_NAME
$report_Active_Flag = $row.Active_Flag

if($report_Active_Flag -eq 1)
{
#Call Function
diskstatus $report_Server_Name
}

}


# 3 CLEANUP
#call function
# deleteold
$Connection.Close()
Remove-Variable -Scope Global -Name Connection

}*>$error_location
