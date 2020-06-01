## Enter Detail 
$data_servername = "DESKTOP-GKOFLPN\DEV500"
$data_database = "SQLPERF_VP"
$your_user = $null
$your_password =$null
$integrated_security = "True"
$error_location = "D:\MonitoringScripts\Monitor_SP\Error_bin\output_process_error.txt"

########################################################################################################

################################## Get Process Status Function #########################################

function processstatus ($id,$description,$serverlist,$Process,$Search_String)
#function processstatus ($description,$serverlist,$Process,$displaycolor)
{

  foreach ($computer in $serverlist)
  {
    if (Test-Connection $computer -Quiet -Count 1) 
      {
      #Has Connection (ie: the server exists and we have connection rights)
      if (Test-Path -Path "C:\*") 
        {
        #HasPermission (we have access to the C drive, therefore permissions are OK)

        # Here we gather the list of all processes that match the name we provide in the config file.  
        $processActive = (Get-WmiObject Win32_Process -ComputerName $computer | Where-Object { $Process -contains $_.Name } | Select-Object PSComputerName,ProcessID,Name,Commandline)
        #$processActive = Get-Process -ComputerName $computer -name $Process | select Name,MachineName,Path,Threads,Id          

        # If the list is NULL we stop here and report no such process is running
        if ($processActive.ProcessID -eq $null)
          {
          
          Write-Host $Process" is not running on "$computer -ForegroundColor yellow

          #Call the function to transform the data and prepare the data for insertion

            writestatusInfo $id 'Not Running'


          }
        # If the list of processes matching our provided process name is not NULL we iterate through, looking for a match to the environment variable
        else
          {
          #If the environment variable was not supplied then we are done since we've found a matching process instance.  Write that to the report:
          if ($Search_String -eq $null)
            {
            $Search_String = "-"
           
          #Call the function to transform the data and prepare the data for insertion
            writestatusInfo $id 'Running'

            }
          else
            {
            # The environment variable is not null, so we check to see if any of the returned processes match this variable in their command line
            $Search_StringMatchFound = 0
            foreach ($object in $processActive)
              {
              if ($object.Commandline -match $Search_String)
                {
                $Search_StringMatchFound = 1
                }
              }
            # If a match was found, write success (process running) to the report:
            if ($Search_StringMatchFound -eq 1)
              {
            
            #Call the function to transform the data and prepare the data for insertion
            writestatusInfo $id 'Running'


              }
            # If a match was not found, write failure (process not running) to the report:
            else
              {
            
            #Call the function to transform the data and prepare the data for insertion
            writestatusInfo $id 'Not Running'

              }
            }
          }
        }

      
      else {
        #No Permission
        #Call the function to transform the data and prepare the data for insertion
            writestatusInfo $id 'Access Denied'

        }
      }
    else {
      #No Connection
     
      ##################NO Need to insert this status into Database ##################################################
       
          #Call the function to transform the data and prepare the data for insertion
           
           writestatusInfo $id 'No Connection'


      }
  }
}

################################# Function to Capture Status data into table ###########################

#Fucntion to manipulate the data
Function writestatusInfo
{
param($id,$Sts)
 $date= Get-date
# Data preparation for loading data into SQL table 
$InsertProcessResults = @"
INSERT INTO [VP_PROCESS_STATUS](Process_Id,Status,Status_Date)
VALUES ('$id','$Sts','$date')
"@      
#call the invoke-sqlcmdlet to execute the query
try{
         ExecuteSqlQuery -sqlquery $InsertProcessResults
         }
         catch{
         write-host "error" $_.exception
         }
}
################################# Function to Delete Old data From table ###############################
#Fucntion to delete the old data
Function deleteold
{

# Delete query
$DeleteResults = @"
DELETE FROM [VP_PROCESS_STATUS]
WHERE Status_Date < DATEADD(dd,-1,GETDATE())
"@      
#call the invoke-sqlcmdlet to execute the query
         ExecuteSqlQuery -sqlquery $DeleteResults
}

########################################################################################################

################################## Get Pro Status for each server ##################################

#Invoke-Command {
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
$resultsDataTable = ExecuteSqlQuery -sqlquery 'SELECT * FROM VP_Server_ENV_Detail a INNER JOIN VP_Process_List b on a.Env_ID = b.Env_ID' 

#validate we got data
Write-Host ("The table contains: " + $resultsDataTable.Rows.Count + " rows")

#loop though each row
FOREACH($row in $resultsDataTable){

Write-Host $row.Description $row.Server_Name $row.Process_Name

#assigning variable to each column of the row
$report_title = $row.Env_Title 
$report_output = $row.Env_Output
$report_process_id = $row.Process_ID
$report_Description = $row.Description
$report_Server_Name = $row.Server_Name
$report_Process_Name = $row.Process_Name
$report_Search_String = $row.Env_Search_String
$report_Notify_Flag = $row.Notify_Flag
$report_Active_Flag = $row.Active_Flag

if($report_Active_Flag -eq 1)
{
#Call Function
processstatus $report_process_id $report_Description $report_Server_Name $report_Process_Name $report_Search_String 
}

}



# 3 CLEANUP

#call function
deleteold
$Connection.Close()
Remove-Variable -Scope Global -Name Connection

#}*>$error_location
