########################################################################################################

################################# Function to Capture Status data into table ###########################

#Invoke-sqlcmd Connection string parameters
$params = @{'server'='TOTDBM01';'Database'='SQLPERF_VP'}
 
#Fucntion to manipulate the data
Function writestatusInfo
{
param($Env,$des,$SN,$PN,$ESS,$Sts)
 $date= Get-date
# Data preparation for loading data into SQL table 
$InsertResults = @"
INSERT INTO [dbo].[VP_PROCESS_STATUS](Environment,Description,Server_Name,Process_Name,Env_Search_String,Status,Status_Date)
VALUES ('$Env','$des','$SN','$PN','$ESS','$Sts','$date')
"@      
#call the invoke-sqlcmdlet to execute the query
         Invoke-sqlcmd @params -Query $InsertResults
}

########################################################################################################

################################# Function to Delete Old data From table ###############################

#Fucntion to delete the old data
Function deleteold
{

# Delete query
$InsertResults = @"
DELETE FROM [VP_PROCESS_STATUS]
WHERE Status_Date < DATEADD(dd,-1,GETDATE())
"@      
#call the invoke-sqlcmdlet to execute the query
         Invoke-sqlcmd @params -Query $InsertResults
}

#call function
deleteold


########################################################################################################

################################## Get Service Status Function #########################################


function processstatus ($report_title,$description,$serverlist,$Process,$environment)
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
        $processActive = (Get-WmiObject Win32_Process -ComputerName $computer | Where-Object { $process -contains $_.Name } | Select-Object PSComputerName,ProcessID,Name,Commandline)
        #$processActive = Get-Process -ComputerName $computer -name $Process | select Name,MachineName,Path,Threads,Id          

        # If the list is NULL we stop here and report no such process is running
        if ($processActive.ProcessID -eq $null)
          {
          Write-Host $process" is not running on "$computer -ForegroundColor yellow

          #Call the function to transform the data and prepare the data for insertion
            writestatusInfo $report_title $description $computer $Process $environment 'Not Running'


          }
        # If the list of processes matching our provided process name is not NULL we iterate through, looking for a match to the environment variable
        else
          {
          #If the environment variable was not supplied then we are done since we've found a matching process instance.  Write that to the report:
          if ($environment -eq $null)
            {
            $environment = "-"
           
          #Call the function to transform the data and prepare the data for insertion
            writestatusInfo $report_title $description $computer $Process $environment 'Running'

            }
          else
            {
            # The environment variable is not null, so we check to see if any of the returned processes match this variable in their command line
            $environmentMatchFound = 0
            foreach ($object in $processActive)
              {
              if ($object.Commandline -match $environment)
                {
                $environmentMatchFound = 1
                }
              }
            # If a match was found, write success (process running) to the report:
            if ($environmentMatchFound -eq 1)
              {
            
            #Call the function to transform the data and prepare the data for insertion
            writestatusInfo $report_title $description $computer $Process $environment 'Running'


              }
            # If a match was not found, write failure (process not running) to the report:
            else
              {
            
            #Call the function to transform the data and prepare the data for insertion
            writestatusInfo $report_title $description $computer $Process $environment 'Not Running'

              }
            }
          }
        }

      
      else {
        #No Permission
        #Call the function to transform the data and prepare the data for insertion
            writestatusInfo $report_title $description $computer $Process $environment 'Access Denied'

        }
      }
    else {
      #No Connection
     
      ##################NO Need to insert this status into Database ##################################################
       
          #Call the function to transform the data and prepare the data for insertion
           
           # writestatusInfo $report_title $description $computer $Process $environment 'No Connection'


      }
  }
}


########################################################################################################

################################## Get Service Status for each server ##################################

Invoke-Command {
[string] $Server= "totdbm01"
[string] $Database = "SQLPERF_VP"
[string] $UserSqlQuery= $("SELECT * FROM VP_Server_Report_Detail a INNER JOIN VP_PROCESS_LIST b on a.Report_ID = b.Report_ID")

# executes a query and populates the $datatable with the data
function ExecuteSqlQuery ($Server, $Database, $SQLQuery) {
$Datatable = New-Object System.Data.DataTable

$Connection = New-Object System.Data.SQLClient.SQLConnection
$Connection.ConnectionString = "server='$Server';database='$Database';trusted_connection=true;"
$Connection.Open()
$Command = New-Object System.Data.SQLClient.SQLCommand
$Command.Connection = $Connection
$Command.CommandText = $SQLQuery
$Reader = $Command.ExecuteReader()
$Datatable.Load($Reader)
$Connection.Close()

return $Datatable
}

# declaration not necessary, but good practice
$resultsDataTable = New-Object System.Data.DataTable
$resultsDataTable = ExecuteSqlQuery $Server $Database $UserSqlQuery

#validate we got data
Write-Host ("The table contains: " + $resultsDataTable.Rows.Count + " rows")

#loop though each row
FOREACH($row in $resultsDataTable){

Write-Host $row.Description $row.Server_Name $row.Service_Name

#assigning variable to each column of the row
$report_title = $row.Report_Title 
$report_output = $row.Report_Output
$report_Description = $row.Description
$report_Server_Name = $row.Server_Name
$report_Process_Name = $row.Process_Name
$report_Search_String = $row.Env_Search_String
$report_Notify_Flag = $row.Notify_Flag

$color = "#00000"

#Call Function
processstatus $report_title $report_Description $report_Server_Name $report_Process_Name $report_Search_String 
#processstatus $report_Description $report_Server_Name $report_Process_Name $color

}


}*>\\totdbadevws05\c$\Users\ViPatel\Desktop\output_process_error.txt

