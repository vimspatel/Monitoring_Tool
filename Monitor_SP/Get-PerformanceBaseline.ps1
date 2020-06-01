## Enter Detail 
$data_servername = "DESKTOP-GKOFLPN\DEV500"
$data_database = "SQLPERF_VP"
$your_user = $null
$your_password =$null
$integrated_security = "True"
$error_location = "D:\MonitoringScripts\Monitor_SP\Error_bin\output_performance_error.txt"
########################################################################################################

################################## Get Installed Instances     #########################################

function getinstancename($serverid,$servername){
 
$SQLInstances = Invoke-Command -ComputerName $servername {
 (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server').InstalledInstances
 }
    foreach ($sql in $SQLInstances) {
       
       write-output $$sql.PSComputerName + $sql

       getcounters $serverid $sql.PSComputerName $sql '2020-12-31 23:59:59.997' 

       #getcounters $serverid $sql.PSComputerName $sql '2020-12-31 23:59:59.997' totdbm01 SQLPERF_VP_Dev

   }

}
########################################################################################################

##################################    Get Counter ######################################################

function getcounters{
[CmdletBinding()]
param(
    [int]$srvid=$null,
	[string]$srv=$null,
   #[int]$interval=$null,
   [string]$sqlinst=$null,
	[datetime]$endat=$null
	)
try {

     	if ($sqlinst -eq 'MSSQLSERVER') {
			$srvnm = $sqlinst
			}
		else {
			$srvnm = 'MSSQL$' + $sqlinst
			}
		$stat = get-service -name $srvnm | select Status
		if ($stat.Status -eq 'Running') {
			$iname = $srvnm
			if ($iname -eq 'MSSQLSERVER') {
				$iname = 'SQLServer'
				}
           			
			# Define our list of counters
			$counters = @(
			    "\Processor(_Total)\% Processor Time",
			    "\Memory\Available MBytes",
			    "\Paging File(_Total)\% Usage",
			    "\PhysicalDisk(_Total)\Avg. Disk sec/Read",
			    "\PhysicalDisk(_Total)\Avg. Disk sec/Write",
			    "\System\Processor Queue Length",
			    "\$($iname):Access Methods\Forwarded Records/sec",
			    "\$($iname):Access Methods\Page Splits/sec",
			    "\$($iname):Buffer Manager\Buffer cache hit ratio",
			    "\$($iname):Buffer Manager\Page life expectancy",
			    "\$($iname):Databases(_Total)\Log Growths",
			    "\$($iname):General Statistics\Processes blocked",
			    "\$($iname):SQL Statistics\Batch Requests/sec",
			    "\$($iname):SQL Statistics\SQL Compilations/sec",
			    "\$($iname):SQL Statistics\SQL Re-Compilations/sec",
			    "\$($iname):Buffer Manager\Page reads/sec",
			    "\$($iname):Buffer Manager\Page writes/sec"
                
			)


        
			# Get performance counter data
			$ctr = Get-Counter -ComputerName $srv -Counter $counters -SampleInterval 1 -MaxSamples 1
			$dt = $ctr.Timestamp

			foreach ($ct in $ctr.CounterSamples) {
				if ($ct.Path -like '*% Processor Time') {
					$pptv = $ct.CookedValue
					}
				if ($ct.Path -like '*Available MBytes') {
					$mabv = $ct.CookedValue
					}
				if ($ct.Path -like '*% Usage') {
					$pfuv = $ct.CookedValue
					}
				if ($ct.Path -like '*Avg. Disk sec/Read') {
					$drsv = $ct.CookedValue
					}
				if ($ct.Path -like '*Avg. Disk sec/Write') {
					$dwsv = $ct.CookedValue
					}
				if ($ct.Path -like '*Processor Queue Length') {
					$pqlv = $ct.CookedValue
					}
				if ($ct.Path -like '*Forwarded Records/sec') {
					$frv = $ct.CookedValue
					}
				if ($ct.Path -like '*Page Splits/sec') {
					$psv = $ct.CookedValue
					}
				if ($ct.Path -like '*Buffer cache hit ratio') {
					$bchv = $ct.CookedValue
					}
                if ($ct.Path -like '*Page life expectancy') {
					$plev = $ct.CookedValue
					}
				if ($ct.Path -like '*Log Growths') {
					$lgv = $ct.CookedValue
					}
				if ($ct.Path -like '*Processes blocked') {
					$bpv = $ct.CookedValue
					}
				if ($ct.Path -like '*Batch Requests/sec') {
					$brsv = $ct.CookedValue
					}
				if ($ct.Path -like '*SQL Compilations/sec') {
					$csv = $ct.CookedValue
					}
				if ($ct.Path -like '*SQL Re-Compilations/sec') {
					$rcsv = $ct.CookedValue
					}
                if ($ct.Path -like '*Page reads/sec') {
					$prps = $ct.CookedValue
					}
                if ($ct.Path -like '*Page writes/sec') {
					$pwps = $ct.CookedValue
					}
				}

			#Send the next set of machine counters to our database
			$q = "declare @ServerStatsID int; exec [SP_INSERT_SERVERSTATS]"
			$q = $q + " @ServerStatsID OUTPUT"
			$q = $q + ", @ServerID='" + [string]$srvid + "'"
			$q = $q + ", @PerfDate='" + [string]$dt + "'"
			$q = $q + ", @PctProc=" + [string]$pptv
			$q = $q + ", @Memory=" + [string]$mabv
			$q = $q + ", @PgFilUse=" + [string]$pfuv
			$q = $q + ", @DskSecRd=" + [string]$drsv
			$q = $q + ", @DskSecWrt=" + [string]$dwsv
			$q = $q + ", @ProcQueLn=" + [string]$pqlv
			$q = $q + "; select @ServerStatsID as ServerStatsID"
			$res = ExecuteSqlQuery -sqlquery $q
			$SrvStatID = $res.ServerStatsID

			#Send the next set of instance counters to the database
			$q = "declare @InstanceStatsID int; exec [SP_INSERT_INSTANCESTATS]"
			$q = $q + " @InstanceStatsID OUTPUT"
			$q = $q + ", @ServerStatsID=" + [string]$SrvStatID
			$q = $q + ", @ServerID='" + [string]$srvid + "'"
			$q = $q + ", @InstanceNm=$srvnm"
			$q = $q + ", @PerfDate='" + [string]$dt + "'"
			$q = $q + ", @FwdRecSec=" + [string]$frv
			$q = $q + ", @PgSpltSec=" + [string]$psv
			$q = $q + ", @BufCchHit=" + [string]$bchv
			$q = $q + ", @PgLifeExp=" + [string]$plev
			$q = $q + ", @LogGrwths=" + [string]$lgv
			$q = $q + ", @BlkProcs=" + [string]$bpv
			$q = $q + ", @BatReqSec=" + [string]$brsv
			$q = $q + ", @SQLCompSec=" + [string]$csv
			$q = $q + ", @SQLRcmpSec=" + [string]$rcsv

			$q = $q + ", @PgRdSec=" + [string]$prps
			$q = $q + ", @PgWrtSec=" + [string]$pwps

			$q = $q + "; select @InstanceStatsID as InstanceStatsID"
			$res = ExecuteSqlQuery -sqlquery $q
			$InstID = $res.InstanceStatsID

			}
		

    }
catch {
    # Handle the error
    $err = $_.Exception
    write-output $err.Message
    while( $err.InnerException ) {
	$err = $err.InnerException
	write-output $err.Message
	}
    }
finally {
	write-output "script completed"
	}
}


         




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
$resultsDataTable = ExecuteSqlQuery -sqlquery "SELECT DB_SERVER_NAME,ServerID FROM VP_SERVER_LIST WHERE ACTIVE_FLAG = '1'" 


#validate we got data
Write-Host ("The table contains: " + $resultsDataTable.Rows.Count + " Servers")

#loop though each row
FOREACH($row in $resultsDataTable){

Write-Host $row.DB_SERVER_NAME $row.ServerID

#assigning variable to each column of the row

$Server_Name = $row.DSERVER_NAME
$Server_ID = $row.ServerID

#Call Function
getinstancename $server_ID $Server_Name 
}

# 3 CLEANUP

$Connection.Close()
Remove-Variable -Scope Global -Name Connection

}*>$error_location

