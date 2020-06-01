
#######################################################################################################################################################
###
### 
#######################################################################################################################################################
$InputStringArray = "FNDEV Batch Server,Totpsappdev01,BBL.EXE,appserv\\prcs\\FNDEV",
                    "FNDEV App Server,Totpsappdev02,BBL.EXE,appserv\\FNDEV",
                    "FNDEV_D App Server,Totpsappdev02,BBL.EXE,appserv\\FNDEV_D",
                    "FNFIX Batch Server,Totpsappdev01,BBL.EXE,appserv\\prcs\\FNFIX",
                    "FNFIX App Server,Totpsappdev03,BBL.EXE,appserv\\FNFIX",
                    "FNPATCH Batch Server,Totpsappdev01,BBL.EXE,appserv\\prcs\\FNPATCH",
                    "FNPATCH App Server,Totpsappdev03,BBL.EXE,appserv\\FNPATCH",
                    "FNSTRESS Batch Server,Totpsappdev01,BBL.EXE,appserv\\prcs\\FNSTRESS",
                    "FNSTRESS App Server,Totpsappdev03,BBL.EXE,appserv\\FNSTRESS",
                    "FNTEST Batch Server,Totpsapptst01,BBL.EXE,appserv\\prcs\\FNTEST",
                    "FNTEST App Server,Totpsapptst02,BBL.EXE,appserv\\FNTEST",
                    "FNUAT Batch Server,Totpsapptst01,BBL.EXE,appserv\\prcs\\FNUAT",
                    "FNUAT App Server,Totpsapptst02,BBL.EXE,appserv\\FNUAT",
                    "FNAUDIT Batch Server,Totpsapptst01,BBL.EXE,appserv\\prcs\\FNAUDIT",
                    "FNAUDIT App Server,Totpsapptst02,BBL.EXE,appserv\\FNAUDIT",
                    "FNQC Batch Server,Totpsappqa01,BBL.EXE,appserv\\prcs\\FNQC",
                    "FNQC App Server,Totpsappqa02,BBL.EXE,appserv\\FNQC",
                    "SIFNDEV Batch Server,Totsipsappdev01,BBL.EXE,appserv\\prcs\\SIFNDEV",
                    "SIFNDEV App Server,Totsipsawdev01,BBL.EXE,appserv\\SIFNDEV",
                    "SIFNTEST Batch Server,Totsipsapptst01,BBL.EXE,appserv\\prcs\\SIFNTEST",
                    "SIFNTEST App Server,Totsipsawtst01,BBL.EXE,appserv\\SIFNTEST",
                    "SIFNQC Batch Server,Totsipsapptst01,BBL.EXE,appserv\\prcs\\SIFNQC",
                    "SIFNQC App Server,Totsipsawtst01,BBL.EXE,appserv\\SIFNQC",
                    "SIFNUAT Batch Server,Totsipsapptst01,BBL.EXE,appserv\\prcs\\SIFNUAT",
                    "SIFNUAT App Server,Totsipsawtst01,BBL.EXE,appserv\\SIFNUAT"


        Function GetbatchAppServerProcess{
                Param ($environment,$computer, $Process, $Search_String)

        # Here we gather the list of all processes that match the name we provide in the config file.  
        $processActive = (Get-WmiObject -Namespace "root\cimv2" -Class Win32_Process -ComputerName $computer | Where-Object { $Process -contains $_.Name } | Select-Object PSComputerName,ProcessID,Name,Commandline)
         

        # If the list is NULL we stop here and report no such process is running
        if ($processActive.ProcessID -eq $null)
          {
          
          Write-Host $Process" is not running on "$computer -ForegroundColor Red
          

          }
        # If the list of processes matching our provided process name is not NULL we iterate through, looking for a match to the environment variable
        else
          {
          #If the environment variable was not supplied then we are done since we've found a matching process instance.  Write that to the report:
          if ($Search_String -eq $null)
            {
            $Search_String = "-"
           
           Write-Host $Process" is not running on "$computer -ForegroundColor Red
           
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
              Write-Host $Process" is Running on "$computer -ForegroundColor Green
            
              }
            # If a match was not found, write failure (process not running) to the report:
            else
              {
              Write-Host $Process" is not running on "$computer -ForegroundColor Red
            
              }
            }
          }
          }
        
foreach ($InputString in $InputStringArray)
{
$StringArray =$InputString.Split(",")
$env = $StringArray[0]
$cname = $StringArray[1]
$pName = $StringArray[2]
$sString = $StringArray[3]

write-host $env -ForegroundColor White
GetbatchAppServerProcess($env,$cname,$pName,$sString)

}      
        
