########################################################################################################

################################# Function to Capture Status data into table ###########################

#Invoke-sqlcmd Connection string parameters
$params = @{'server'='TOTDBM01';'Database'='SQLPERF_VP'}
 
#Fucntion to manipulate the data
Function writestatusInfo
{
param($Env,$des,$SN,$SR,$Sts)
 $date= Get-date
# Data preparation for loading data into SQL table 
$InsertResults = @"
INSERT INTO [dbo].[VP_SERVICES_STATUS](Environment,Description,Server_Name,Service_Name,Status,Status_Date)
VALUES ('$Env','$des','$SN','$SR','$Sts','$date')
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
DELETE FROM [VP_SERVICES_STATUS]
WHERE Status_Date < DATEADD(dd,-1,GETDATE())
"@      
#call the invoke-sqlcmdlet to execute the query
         Invoke-sqlcmd @params -Query $InsertResults
}

#call function
deleteold


########################################################################################################

################################## Get Service Status Function #########################################

function servicestatus ($description,$serverlist,$service,$displaycolor)
{

  foreach ($computer in $serverlist)
  {
    if (Test-Connection $computer -Quiet -Count 1) 
      {
      #Has Connection (ie: the server exists and we have connection rights)
      if (Test-Path -Path "C:\*") 
        {
        #HasPermission (we have access to the C drive, therefore permissions are OK)

        # Here we gather the list of all services that match the name we provide in the config file.  
       
          $serviceStatus = Get-Service -ComputerName $computer -Name $service
          $svcName = $serviceStatus.Name
          $svcState = $serviceStatus.status

          if ($serviceStatus.status -eq "Running") {

            Write-Host $computer `t $serviceStatus.Name `t $serviceStatus.status -ForegroundColor Green

            #Call the function to transform the data and prepare the data for insertion
            writestatusInfo $report_title $description $computer $svcName $svcState

          }

          elseif ($serviceStatus.status -eq "Stopped")
          {
            Write-Host $computer `t $serviceStatus.Name `t $serviceStatus.status -ForegroundColor Red
            if ($alert -eq "No")
            {
              $sename = $serviceStatus.Name
              $sestatus = $serviceStatus.status
              Send-Email -From $from1 -To $to -Subject "Open Critical: $computer $sename $sestatus" -SmtpServer $smtphost
            }

            Write-Host $computer `t $serviceStatus.Name `t $serviceStatus.status -ForegroundColor Red

            #Call the function to transform the data and prepare the data for insertion
            writestatusInfo $report_title $description $computer $svcName $svcState

          }

          else {


            Write-Host "Cannot open Service Control Manager on computer" $computer -ForegroundColor yellow

            #Call the function to transform the data and prepare the data for insertion
            writestatusInfo $report_title $description $computer $svcName $svcState

          }
       
        }

      
      else {
        #No Permission
        
        #Call the function to transform the data and prepare the data for insertion
            writestatusInfo $report_title $description $computer $svcName 'Access Denied'

        }
      }
    else {
      #No Connection
      
      # NO need to insert into table so not calling function 
      #Call the function to transform the data and prepare the data for insertion
           writestatusInfo $report_title $description $computer $svcName 'No Connection'

      }
  }
}


########################################################################################################

################################## Get Service Status for each server ##################################

Invoke-Command {
[string] $Server= "totdbm01"
[string] $Database = "SQLPERF_VP"
[string] $UserSqlQuery= $("SELECT * FROM VP_Server_Report_Detail a INNER JOIN VP_Service_List b on a.Report_ID = b.Report_ID")

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
$report_Service_Name = $row.Service_Name
$report_Search_String = $row.Env_Search_String
$report_Notify_Flag = $row.Notify_Flag

$color = "#00000"

#Call Function
servicestatus $report_Description $report_Server_Name $report_Service_Name $color

}


}*>\\totdbadevws05\c$\Users\ViPatel\Desktop\outputerror_test.txt

