########################################################################################################

################################# Function to Capture Status data into table ###########################

Invoke-Command {
#Invoke-sqlcmd Connection string parameters
$params = @{'server'='TOTDBM01';'Database'='SQLPERF_VP_dev'}
 
#Fucntion to manipulate the data
Function writestatusInfo
{
param($id,$Sts)
 $date= Get-date
# Data preparation for loading data into SQL table 
$InsertResults = @"
INSERT INTO [dbo].[VP_SERVICE_STATUS](Service_ID,Status,Status_Date)
VALUES ('$id','$Sts','$date')
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
DELETE FROM [VP_SERVICE_STATUS]
WHERE Status_Date < DATEADD(dd,-1,GETDATE())
"@      
#call the invoke-sqlcmdlet to execute the query
         Invoke-sqlcmd @params -Query $InsertResults
}

#call function
deleteold


########################################################################################################

################################## Get Service Status Function #########################################

function servicestatus ($id,$description,$computer,$service,$userid,$password)
{
 ######
        
        if(([string]::IsNullOrWhiteSpace($userid)) -and ([string]::IsNullOrWhiteSpace($password)))
        {
        write-host "null value" -ForegroundColor green
                [System.Management.Automation.PSCredential]
                [System.Management.Automation.Credential()]
                $Credential = [System.Management.Automation.PSCredential]::Empty
        }
        else{
                $User = $userid
                $PWord = ConvertTo-SecureString -String $password -AsPlainText -Force
                $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
        }

######

 
    if (Test-Connection $computer -Quiet -Count 1) 
      {
      #Has Connection (ie: the server exists and we have connection rights)
      if (Test-Path -Path "C:\*") 
        {
        #HasPermission (we have access to the C drive, therefore permissions are OK)

        # Here we gather the list of all services that match the name we provide in the config file.  
      $serviceStatus = (Get-WmiObject Win32_Service -ComputerName $server -Credential $Credential | Where-Object { $service -contains $_.Name } | Select-Object PSComputerName,Name,Status,State)
         ## removed ## $serviceStatus = Get-Service -ComputerName $computer -Name $service
          $svcName = $serviceStatus.Name
          $svcState = $serviceStatus.State

          if ($svcState -eq "Running") {

            Write-Host $computer $svcName $svcState "----" $service -ForegroundColor Green

            #Call the function to transform the data and prepare the data for insertion
            writestatusInfo $id "Running_test"

          }

          elseif ($svcState -eq "Stopped")
          {
            Write-Host $computer $svcName $svcState "----" $service  -ForegroundColor Red
            if ($alert -eq "No")
            {
              $sename = $serviceStatus.Name
              $sestatus = $serviceStatus.status
              Send-Email -From $from1 -To $to -Subject "Open Critical: $computer $sename $sestatus" -SmtpServer $smtphost
            }

            Write-Host $computer $svcName $svcState "----" $service  -ForegroundColor Red

            #Call the function to transform the data and prepare the data for insertion
            writestatusInfo $id "stopped_test"

          }

          else {


            Write-Host "Cannot open Service Control Manager on computer" $computer  "----" $service  -ForegroundColor yellow

            #Call the function to transform the data and prepare the data for insertion
            writestatusInfo $id "Control NO"

          }
       
        }

      
      else {
        #No Permission
        
            Write-Host "Access Denied" $computer "----" $service  -ForegroundColor yellow
        #Call the function to transform the data and prepare the data for insertion
            writestatusInfo $id 'Access Denied'

        }
      }
    else {
      #No Connection
         Write-Host "No Connection" $computer "----" $service  -ForegroundColor yellow
     
      #Call the function to transform the data and prepare the data for insertion
           writestatusInfo $id 'No Connection'

      }
}



########################################################################################################

################################## Get Service Status for each server ##################################

[string] $Server= "totdbm01"
[string] $Database = "SQLPERF_VP_dev"
[string] $UserSqlQuery= $("SELECT * FROM VP_Server_ENV_Detail a INNER JOIN VP_Service_List b on a.Env_ID = b.Env_ID")

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
$report_title = $row.Env_Title 
$report_output = $row.Env_Output
$report_service_id = $row.Service_ID
$report_Description = $row.Description
$report_Server_Name = $row.Server_Name
$report_Service_Name = $row.Service_Name
$report_Search_String = $row.Env_Search_String
$report_Notify_Flag = $row.Notify_Flag
$report_Active_Flag = $row.Active_Flag
$report_User = $row.User
$report_password = $row.password


if($report_Active_Flag -eq 1)
{
#Call Function
servicestatus $report_service_id $report_Description $report_Server_Name $report_Service_Name $report_User $report_password
}

}


}*>\\totdbadevws05\c$\Users\ViPatel\Desktop\Error_bin\output_services_error_dev.txt
