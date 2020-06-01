#############################################################################
#       Author: Vimal Patel
#       Reviewer:  Mike Ashton
#       Date: 05/21/2019
#		Modified: 06/6/2019 - check for specified environment
#       Updated: check connection and test path
#       Description: Process Monitoring
#############################################################################
#		Modified: 06/11/2019 - Mike Ashton
#       Description: Updated looping logic.  Added comments.  Removed hardcoding.
#############################################################################

# We will use one file for both the configuration parameters (such as report name)
#   as well as the actual input (in this case a list of processes)
$config_file = Get-Content "\\totdbm01\d$\MonitoringScripts\Monitor_SP\VP_Monitoring.cfg"
$input_file  = Get-Content "\\totdbm01\d$\MonitoringScripts\Monitor_SP\VP_Monitoring.cfg"

# First we gather the configuration variables:
foreach ($input in $config_file)
{
  if ($input -match '#VARIABLE#') {
    # REPORT_TITLE will be used as the title of the web page and in the header of the report.
    if ($input -match '#VARIABLE#REPORT_TITLE') {
      $report_title = $input.split(',')[1].split()
    }
    # REPORT_OUTPUT is the full path and filename of the HTML report.
    if ($input -match '#VARIABLE#REPORT_OUTPUT') {
      $report = $input.split(',')[1].split()
    }
  }
  else
  {
    #Do nothing since this is not a line with a config variable, it is a line of input
  }
}
#Write-Host "Report variable (1) : " $report

# If we do not get an output file specified in the config file write the output to the local directory with a generic name:
if ($report -eq $null) {
  $report = ".\report_process.htm"
}

$alert = "Yes"
$smtphost = "smtp.gmail.com"
$from1 = "cs.vimspatel@gmail.com"
$to = "vimalbhai.patel@gaf.com.com"

##############################################################################
# Check to see if the output file already exists.  If it does, we delete it
# and recreate a blank file for this report
$checkrep = Test-Path $report

if ($checkrep -like "True")
{
  Remove-Item $report
}

New-Item $report -Type file 

##############Functions#########################

function Send-Email
{
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory = $true)]
    $From,
    [Parameter(Mandatory = $true)]
    [array]$To,
    [array]$bcc,
    [array]$cc,
    $body,
    $subject,
    $attachment,
    [Parameter(Mandatory = $true)]
    $smtpserver
  )

  $message = New-Object System.Net.Mail.MailMessage
  $message.From = $from
  if ($To -ne $null)
  {
    $To | ForEach-Object {
      $to1 = $_
      $to1
      $message.To.Add($to1)
    }
  }
  if ($cc -ne $null)
  {
    $cc | ForEach-Object {
      $cc1 = $_
      $cc1
      $message.CC.Add($cc1)
    }
  }
  if ($bcc -ne $null)
  {
    $bcc | ForEach-Object {
      $bcc1 = $_
      $bcc1
      $message.bcc.Add($bcc1)
    }
  }
  $message.IsBodyHtml = $True
  if ($subject -ne $null)
  {
    $message.Subject = $Subject
  }
  if ($attachment -ne $null)
  {
    $attach = New-Object Net.Mail.Attachment ($attachment)
    $message.Attachments.Add($attach)
  }
  if ($body -ne $null)
  {
    $message.body = $body
  }
  $smtp = New-Object Net.Mail.SmtpClient ($smtpserver)
  $smtp.Send($message)
}

################################ADD HTML Content#############################

$date = (Get-Date).ToString('yyyy/MM/dd')
Add-Content $report "<!DOCTYPE html>"
Add-Content $report '<html lang="en">'
Add-Content $report "<head>"
Add-Content $report "<title>$report_title</title>"
Add-Content $report '<meta charset="UTF-8">'
Add-Content $report '<meta name="viewport" content="width=device-width, initial-scale=1">'
Add-Content $report "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
Add-Content $report '<link rel="icon" type="image/png" href="web_page/images/icons/favicon.ico"/>'
Add-Content $report '<link rel="stylesheet" type="text/css" href="web_page/vendor/bootstrap/css/bootstrap.min.css">'
Add-Content $report '<link rel="stylesheet" type="text/css" href="web_page/fonts/font-awesome-4.7.0/css/font-awesome.min.css">'
Add-Content $report '<link rel="stylesheet" type="text/css" href="web_page/vendor/animate/animate.css">'
Add-Content $report '<link rel="stylesheet" type="text/css" href="web_page/vendor/select2/select2.min.css">'
Add-Content $report '<link rel="stylesheet" type="text/css" href="web_page/vendor/perfect-scrollbar/perfect-scrollbar.css">'
Add-Content $report '<link rel="stylesheet" type="text/css" href="web_page/css/util.css">'
Add-Content $report '<link rel="stylesheet" type="text/css" href="web_page/css/main.css">'
Add-Content $report "</head>"

########################################### Report Header #################################################

Add-Content $report "<body>"
$mdate = (Get-Item $report | ForEach-Object { $_.LastWriteTime }).ToString()
Add-Content $report '<div class="header">'
Add-Content $report "<div class='center' >$report_title</div>"
Add-Content $report "<div class='center'>Last Run Date and time - $mdate</div>"
Add-Content $report "</div>"

###########################################################################################################

Add-Content $report '<div class="limiter">'
Add-Content $report '<div class="container-table100">'
Add-Content $report '<div class="wrap-table100">'
Add-Content $report '<div class="table100 ver1 m-b-110">'
Add-Content $report '<table data-vertable="ver1">'
Add-Content $report '<thead>'
Add-Content $report '<tr class="row100 head">'

Add-Content $report '<th class="column100 column1" data-column="column1">Description</th>'
Add-Content $report '<th class="column100 column3" data-column="column2">Server Name</th>'
Add-Content $report '<th class="column100 column4" data-column="column3">Process Name</th>'
Add-Content $report '<th class="column100 column2" data-column="column4">Environment Search String</th>'
#Add-Content $report '<th class="column100 column5" data-column="column5">Path</th>'
Add-Content $report '<th class="column100 column6" data-column="column6">Status</th>'
Add-Content $report "</tr>"
Add-Content $report '</thead>'
Add-Content $report '<tbody>'

########################################################################################################

################################## Get Process Status #################################################


function processstatus ($serverlist,$process,$environment,$displaycolor)
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

          Add-Content $report "<tr class='row100'>"
          Add-Content $report "<td class='column100 column1' data-column='column1' bgcolor= '$displaycolor'>$description</td>"
          Add-Content $report "<td class='column100 column2' data-column='column2' bgcolor= '$displaycolor'>$computer</td>"
          Add-Content $report "<td class='column100 column3' data-column='column3' bgcolor= '$displaycolor'>$Process</td>"
          Add-Content $report "<td class='column100 column4' data-column='column4' bgcolor= '$displaycolor'>$environment</td>"
          Add-Content $report "<td class='column100 column5 error' data-column='column5'>Not Running</td>"
          #Add-Content $report "<td class='column100 column6' data-column='column5'>$proPath</td>"
          Add-Content $report "</tr>"
          }
        # If the list of processes matching our provided process name is not NULL we iterate through, looking for a match to the environment variable
        else
          {
          #If the environment variable was not supplied then we are done since we've found a matching process instance.  Write that to the report:
          if ($environment -eq $null)
            {
            $environment = "-"
            Add-Content $report "<tr class='row100'>"
            Add-Content $report "<td class='column100 column1' data-column='column1' bgcolor= '$displaycolor'>$description</td>"
            Add-Content $report "<td class='column100 column2' data-column='column2' bgcolor= '$displaycolor'>$computer</td>"
            Add-Content $report "<td class='column100 column3' data-column='column3' bgcolor= '$displaycolor'>$Process</td>"
            Add-Content $report "<td class='column100 column4' data-column='column4' bgcolor= '$displaycolor'>$environment</td>"
            Add-Content $report "<td class='column100 column5 running' data-column='column5'>Running</td>"
            #Add-Content $report "<td class='column100 column6' data-column='column6'>$proPath</td>"
            Add-Content $report "</tr>"
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
              Add-Content $report "<tr class='row100'>"
              Add-Content $report "<td class='column100 column1' data-column='column1' bgcolor= '$displaycolor'>$description</td>"
              Add-Content $report "<td class='column100 column2' data-column='column2' bgcolor= '$displaycolor'>$computer</td>"
              Add-Content $report "<td class='column100 column3' data-column='column3' bgcolor= '$displaycolor'>$Process</td>"
              Add-Content $report "<td class='column100 column4' data-column='column4' bgcolor= '$displaycolor'>$environment</td>"
              Add-Content $report "<td class='column100 column5 running' data-column='column5'>Running</td>"
              #Add-Content $report "<td class='column100 column6' data-column='column6'>$proPath</td>"
              Add-Content $report "</tr>"
              }
            # If a match was not found, write failure (process not running) to the report:
            else
              {
              Add-Content $report "<tr class='row100'>"
              Add-Content $report "<td class='column100 column1' data-column='column1' bgcolor= '$displaycolor'>$description</td>"
              Add-Content $report "<td class='column100 column2' data-column='column2' bgcolor= '$displaycolor'>$computer</td>"
              Add-Content $report "<td class='column100 column3' data-column='column3' bgcolor= '$displaycolor'>$Process</td>"
              Add-Content $report "<td class='column100 column4' data-column='column4' bgcolor= '$displaycolor'>$environment</td>"
              Add-Content $report "<td class='column100 column5 error' data-column='column5'>Not Running</td>"
              #Add-Content $report "<td class='column100 column6' data-column='column6'>$proPath</td>"
              Add-Content $report "</tr>"
              }
            }
          }
        }

      
      else {
        #No Permission
        Add-Content $report "<tr class='row100'>"
        Add-Content $report "<td class='column100 column1' data-column='column1' bgcolor= '$displaycolor'>$description</td>"
        Add-Content $report "<td class='column100 column2' data-column='column2' bgcolor= '$displaycolor'>$computer</td>"
        Add-Content $report "<td class='column100 column3' data-column='column3' bgcolor= '$displaycolor'>$Process</td>"
        Add-Content $report "<td class='column100 column4' data-column='column4' bgcolor= '$displaycolor'>$environment</td>"
        Add-Content $report "<td class='column100 column5 error' data-column='column5'>Access Denied</td>"
        #Add-Content $report "<td class='column100 column6' data-column='column6'>$proPath</td>"
        Add-Content $report "</tr>"
        }
      }
    else {
      #No Connection
      Add-Content $report "<tr class='row100'>"
        Add-Content $report "<td class='column100 column1' data-column='column1' bgcolor= '$displaycolor'>$description</td>"
        Add-Content $report "<td class='column100 column2' data-column='column2' bgcolor= '$displaycolor'>$computer</td>"
        Add-Content $report "<td class='column100 column3' data-column='column3' bgcolor= '$displaycolor'>$Process</td>"
        Add-Content $report "<td class='column100 column4' data-column='column4' bgcolor= '$displaycolor'>$environment</td>"
      Add-Content $report "<td class='column100 column5 error' data-column='column5'>No Connection</td>"
      #Add-Content $report "<td class='column100 column6' data-column='column6'>$proPath</td>"
      Add-Content $report "</tr>"
      }
  }
}

############################################Call Function#############################################
function addtable ($nameoflist) {
  Add-Content $report "<table width='100%'>"
  Add-Content $report "<tr bgcolor='Lavender'>"
  Add-Content $report "<td colspan='7' height='25' align='center'>"
  Add-Content $report "<font face='tahoma' color='#003399' size='4'><strong>$nameoflist</strong></font>"
  Add-Content $report "</td>"
  Add-Content $report "</tr>"
  Add-Content $report "</table>"
}



##### All in one list #####
#addtable("ALL-in-one")

foreach ($input in $input_file)
{

  if ($input -match '#VARIABLE#')
  {
      #Do nothing since this is not a line of input, only a configuration variable
  }
  else
  {

  $description = $input.split(',')[0].split()
  $server = $input.split(',')[1].split()
  $process = $input.split(',')[2].split()
  $application = $input.split(',')[3].split()

  try {

    # The color can be blank so we will try to get it but will accept null input
    $color = $input.split(',')[4].split()
  }

  catch {

    # Run this if a terminating error occurred in the Try block
    $color = ""
    # The variable $_ represents the error that occurred

    #$_

    if ($application -eq 'Erae-Server') {

      $color = '#D4E6F1'

    }
    elseif ($application -eq 'PeopleSoft-Server') {
      $color = '#D1F2EB'

    }
    elseif ($application -eq 'Misc-Server') {
      $color = '#FDEBD0'

    }
    elseif ($application -eq 'Shared-Server') {
      $color = '#F2F3F4'

    }
    else {
      $color = '#FADBD8'

    }

  }

  finally {

    # Always run this at the end

  }


  Write-Host $server $process $application $color
  processstatus $server $process $application $color
  Clear-Variable -Name color
  }
}
############################################Close HTMl Tables#########################################


Add-Content $report '</div>'
Add-Content $report '</div>'
Add-Content $report '</div>'
Add-Content $report '</div>'

Add-Content $report "</table>"
Add-Content $report '<script src="web_page/vendor/jquery/jquery-3.2.1.min.js"></script>'
Add-Content $report '<script src="web_page/vendor/bootstrap/js/popper.js"></script>'
Add-Content $report '<script src="web_page/vendor/bootstrap/js/bootstrap.min.js"></script>'
Add-Content $report '<script src="web_page/vendor/select2/select2.min.js"></script>'
#	Add-Content $report '<script src="web_page/js/main.js"></script>'
Add-Content $report "</body>"
Add-Content $report "</html>"

#####################################################################################################

