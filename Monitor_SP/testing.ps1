Invoke-Command {
$server = "totdbm01"
$inventoryDB = "SQLPERF_VP_Dev"

#This is the definition of the table that will contain the values for each instance you wish to collect information from  
$resourcesUsageTable = "
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'CPU_Memory_Usage' AND xtype = 'U')
CREATE TABLE CPU_Memory_Usage(
   [server] [varchar](128) NOT NULL,
   [max_server_memory] [int] NOT NULL,
   [sql_memory_usage] [int] NOT NULL,
   [physical_memory] [int] NOT NULL,
   [available_memory] [int] NOT NULL,
   [system_memory_state] [varchar](255) NOT NULL,
   [page_life_expectancy] [int] NOT NULL,
   [cpu_usage_30] [int] NOT NULL,
   [cpu_usage_15] [int] NOT NULL,
   [cpu_usage_10] [int] NOT NULL,
   [cpu_usage_5] [int] NOT NULL,
   [data_sample_timestamp] [datetime] NULL
) ON [PRIMARY]
"

#Make sure you create this table in your central environment, where you wish to gather the information from all the desired instances
$instances = Invoke-Sqlcmd -ServerInstance $server -Database $inventoryDB -Query $resourcesUsageTable

#Fetch all the instances under your care
<#
   This is an example of the result set that your query must return
   ########################################################################
   # name                     # version             # instance            #
   ########################################################################
   # server1.domain.net,45000 # SQL Server 2016 RTM # server1             #
   # server1.domain.net,45001 # SQL Server 2016 SP1 # server1\MSSQLSERVER1# 
   # server2.domain.net,45000 # SQL Server 2014 SP2 # server2             #
   # server3.domain.net,45000 # SQL Server 2014 SP1 # server3             #
   # server4.domain.net       # SQL Server 2012 SP3 # server4\MSSQLSERVER2#
   ########################################################################
				   
   Make sure that your result set only contains instances using SQL Server 2008 and beyond.
   The reason is that there are some System DMVs not available in SQL Server 2005 and below. 
#>

<#Put in your query that returns the list of instances as described in the example result set above#>
$instanceLookupQuery = "SELECT name, version, instance FROM instances" 
$instances = Invoke-Sqlcmd -ServerInstance $server -Database $inventoryDB -Query $instanceLookupQuery

$resourcesQuery = "
WITH SQLProcessCPU
AS(
   SELECT TOP(30) SQLProcessUtilization AS 'CPU_Usage', ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS 'row_number'
   FROM ( 
         SELECT 
           record.value('(./Record/@id)[1]', 'int') AS record_id,
           record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') AS [SystemIdle],
           record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') AS [SQLProcessUtilization], 
           [timestamp] 
         FROM ( 
              SELECT [timestamp], CONVERT(xml, record) AS [record] 
              FROM sys.dm_os_ring_buffers 
              WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR' 
              AND record LIKE '%<SystemHealth>%'
              ) AS x 
        ) AS y
) 

SELECT 
   SERVERPROPERTY('SERVERNAME') AS 'Instance',
   (SELECT value_in_use FROM sys.configurations WHERE name like '%max server memory%') AS 'Max Server Memory',
   (SELECT physical_memory_in_use_kb/1024 FROM sys.dm_os_process_memory) AS 'SQL Server Memory Usage (MB)',
   (SELECT total_physical_memory_kb/1024 FROM sys.dm_os_sys_memory) AS 'Physical Memory (MB)',
   (SELECT available_physical_memory_kb/1024 FROM sys.dm_os_sys_memory) AS 'Available Memory (MB)',
   (SELECT system_memory_state_desc FROM sys.dm_os_sys_memory) AS 'System Memory State',
   (SELECT [cntr_value] FROM sys.dm_os_performance_counters WHERE [object_name] LIKE '%Manager%' AND [counter_name] = 'Page life expectancy') AS 'Page Life Expectancy',
   (SELECT AVG(CPU_Usage) FROM SQLProcessCPU WHERE row_number BETWEEN 1 AND 30) AS 'SQLProcessUtilization30',
   (SELECT AVG(CPU_Usage) FROM SQLProcessCPU WHERE row_number BETWEEN 1 AND 15) AS 'SQLProcessUtilization15',
   (SELECT AVG(CPU_Usage) FROM SQLProcessCPU WHERE row_number BETWEEN 1 AND 10) AS 'SQLProcessUtilization10',
   (SELECT AVG(CPU_Usage) FROM SQLProcessCPU WHERE row_number BETWEEN 1 AND 5)  AS 'SQLProcessUtilization5',
   GETDATE() AS 'Data Sample Timestamp'
"

#For each instance, grab the CPU/RAM usage information
foreach ($instance in $instances){
   Write-Host "Fetching CPU/RAM information for instance" $instance.instance
   $results = Invoke-Sqlcmd -Query $resourcesQuery -ServerInstance $instance.name -ErrorAction Stop -querytimeout 30
   
   #Build the INSERT statement
   if($results.Length -ne 0){    
      $insert = "INSERT INTO CPU_Memory_Usage VALUES"
      foreach($result in $results){        
         $insert += "
         (
         '"+$result['Instance']+"',
         "+$result['Max Server Memory']+",
         "+$result['SQL Server Memory Usage (MB)']+",
         "+$result['Physical Memory (MB)']+",
         "+$result['Available Memory (MB)']+",
            '"+$result['System Memory State']+"',
            "+$result['Page Life Expectancy']+",
            "+$result['SQLProcessUtilization30']+",
            "+$result['SQLProcessUtilization15']+",
            "+$result['SQLProcessUtilization10']+",
            "+$result['SQLProcessUtilization5']+",
            GETDATE()
            ),
       "
       }

   #Perform the INSERT in the central table
   Invoke-Sqlcmd -Query $insert.Substring(0,$insert.LastIndexOf(',')) -ServerInstance $server -Database $inventoryDB
   }
}

Write-Host "Done!" 
}*>\\totdbadevws05\c$\Users\ViPatel\Desktop\Error_bin\output_testing_error.txt
