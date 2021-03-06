USE [master]
GO
/****** Object:  Database [SQLPERF_VP]    Script Date: 6/1/2020 9:34:54 AM ******/
CREATE DATABASE [SQLPERF_VP]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SQLPERF_VP', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.DEV500\MSSQL\DATA\SQLPERF_VP.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'SQLPERF_VP_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.DEV500\MSSQL\DATA\SQLPERF_VP_log.ldf' , SIZE = 139264KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [SQLPERF_VP] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SQLPERF_VP].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SQLPERF_VP] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SQLPERF_VP] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SQLPERF_VP] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SQLPERF_VP] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SQLPERF_VP] SET ARITHABORT OFF 
GO
ALTER DATABASE [SQLPERF_VP] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SQLPERF_VP] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SQLPERF_VP] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SQLPERF_VP] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SQLPERF_VP] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SQLPERF_VP] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SQLPERF_VP] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SQLPERF_VP] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SQLPERF_VP] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SQLPERF_VP] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SQLPERF_VP] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SQLPERF_VP] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SQLPERF_VP] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SQLPERF_VP] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SQLPERF_VP] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SQLPERF_VP] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SQLPERF_VP] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SQLPERF_VP] SET RECOVERY FULL 
GO
ALTER DATABASE [SQLPERF_VP] SET  MULTI_USER 
GO
ALTER DATABASE [SQLPERF_VP] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SQLPERF_VP] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SQLPERF_VP] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SQLPERF_VP] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [SQLPERF_VP] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'SQLPERF_VP', N'ON'
GO
ALTER DATABASE [SQLPERF_VP] SET QUERY_STORE = OFF
GO
USE [SQLPERF_VP]
GO
/****** Object:  Schema [Analysis]    Script Date: 6/1/2020 9:34:54 AM ******/
CREATE SCHEMA [Analysis]
GO
/****** Object:  Table [dbo].[VP_DB_SERVER_LIST]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VP_DB_SERVER_LIST](
	[ServerID] [int] IDENTITY(1,1) NOT NULL,
	[DB_SERVER_NAME] [varchar](30) NOT NULL,
	[ACTIVE_FLAG] [bit] NOT NULL,
	[DESCR] [varchar](50) NULL,
 CONSTRAINT [PK_VP_DB_SERVER_LIST] PRIMARY KEY CLUSTERED 
(
	[ServerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VP_DB_FILE_LIST]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VP_DB_FILE_LIST](
	[DB_File_ID] [int] IDENTITY(1,1) NOT NULL,
	[DBName] [varchar](100) NULL,
	[LogicalName] [varchar](100) NULL,
	[FileType] [char](4) NULL,
	[DBID] [int] NULL,
	[CreationDate] [datetime] NULL,
	[ServerID] [int] NOT NULL,
 CONSTRAINT [PK_VP_DB_FILE_LIST] PRIMARY KEY CLUSTERED 
(
	[DB_File_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VP_DB_GROWTH]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VP_DB_GROWTH](
	[DBGrowthID] [int] IDENTITY(1,1) NOT NULL,
	[DB_File_ID] [int] NOT NULL,
	[NumPages] [int] NULL,
	[OrigSize] [decimal](10, 2) NULL,
	[CurSize] [decimal](10, 2) NULL,
	[GrowthAmt] [varchar](100) NULL,
	[MetricDate] [datetime] NULL,
 CONSTRAINT [PK_DB_GROWTH] PRIMARY KEY CLUSTERED 
(
	[DBGrowthID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_DB_GROWTH]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_DB_GROWTH]
AS
SELECT        dbo.VP_DB_SERVER_LIST.DB_SERVER_NAME, dbo.VP_DB_FILE_LIST.LogicalName, dbo.VP_DB_FILE_LIST.DBName, dbo.VP_DB_FILE_LIST.FileType, dbo.VP_DB_GROWTH.GrowthAmt, dbo.VP_DB_GROWTH.CurSize, 
                         dbo.VP_DB_GROWTH.MetricDate
FROM            dbo.VP_DB_FILE_LIST INNER JOIN
                         dbo.VP_DB_GROWTH ON dbo.VP_DB_FILE_LIST.DB_File_ID = dbo.VP_DB_GROWTH.DB_File_ID INNER JOIN
                         dbo.VP_DB_SERVER_LIST ON dbo.VP_DB_FILE_LIST.ServerID = dbo.VP_DB_SERVER_LIST.ServerID
WHERE        (dbo.VP_DB_SERVER_LIST.ACTIVE_FLAG = 1)
GO
/****** Object:  Table [dbo].[VP_DB_Errors]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VP_DB_Errors](
	[ErrorID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](100) NULL,
	[ErrorNumber] [int] NULL,
	[ErrorState] [int] NULL,
	[ErrorSeverity] [int] NULL,
	[ErrorLine] [int] NULL,
	[ErrorProcedure] [varchar](max) NULL,
	[ErrorMessage] [varchar](max) NULL,
	[ErrorDateTime] [datetime] NULL,
	[CustomMessage] [varchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VP_DISK_SPACE]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VP_DISK_SPACE](
	[ServerName] [varchar](100) NULL,
	[VolumeName] [varchar](100) NULL,
	[Drive] [char](3) NULL,
	[FreeSpaceINMB] [int] NULL,
	[TotalSpaceINMB] [int] NULL,
	[MetricDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VP_DISK_STATUS_POWERSHELL]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VP_DISK_STATUS_POWERSHELL](
	[Server_Name] [varchar](100) NULL,
	[Drive] [varchar](50) NULL,
	[Drive_Label] [varchar](50) NULL,
	[Total_Capacity] [decimal](18, 2) NULL,
	[Used_Capacity] [decimal](18, 2) NULL,
	[Free_Space] [decimal](18, 2) NULL,
	[Free_Space_inperc] [decimal](18, 2) NULL,
	[RAM_inperc] [decimal](18, 2) NULL,
	[CPU_inperc] [decimal](18, 2) NULL,
	[Metric_Date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VP_Growth_Rate]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VP_Growth_Rate](
	[DBGrowthID] [int] IDENTITY(1,1) NOT NULL,
	[ServerName] [varchar](100) NULL,
	[DBName] [varchar](100) NULL,
	[LogicalName] [varchar](100) NULL,
	[FileType] [char](4) NULL,
	[DBID] [int] NULL,
	[NumPages] [int] NULL,
	[OrigSize] [decimal](10, 2) NULL,
	[CurSize] [decimal](10, 2) NULL,
	[GrowthAmt] [varchar](100) NULL,
	[MetricDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VP_InstanceStats]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VP_InstanceStats](
	[InstanceID] [int] IDENTITY(1,1) NOT NULL,
	[ServerID] [int] NOT NULL,
	[ServerNm] [varchar](30) NOT NULL,
	[InstanceNm] [varchar](30) NOT NULL,
	[PerfDate] [datetime] NOT NULL,
	[FwdRecSec] [decimal](10, 4) NOT NULL,
	[PgSpltSec] [decimal](10, 4) NOT NULL,
	[BufCchHit] [decimal](10, 4) NOT NULL,
	[PgLifeExp] [int] NOT NULL,
	[LogGrwths] [int] NOT NULL,
	[BlkProcs] [int] NOT NULL,
	[BatReqSec] [decimal](10, 4) NOT NULL,
	[SQLCompSec] [decimal](10, 4) NOT NULL,
	[SQLRcmpSec] [decimal](10, 4) NOT NULL,
	[BufPrdSec] [decimal](10, 4) NOT NULL,
	[BufPwrtSec] [decimal](10, 4) NOT NULL,
 CONSTRAINT [PK_VP_InstanceStats] PRIMARY KEY CLUSTERED 
(
	[InstanceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VP_PROCESS_LIST]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VP_PROCESS_LIST](
	[Process_ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL,
	[Server_Name] [varchar](100) NULL,
	[Process_Name] [varchar](100) NULL,
	[Env_Search_String] [varchar](100) NULL,
	[Notify_Flag] [bit] NULL,
	[Env_ID] [int] NULL,
	[Active_Flag] [bit] NULL,
 CONSTRAINT [PK_VP_PROCESS_LIST] PRIMARY KEY CLUSTERED 
(
	[Process_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VP_PROCESS_STATUS]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VP_PROCESS_STATUS](
	[Process_ID] [int] NULL,
	[Status] [varchar](50) NULL,
	[Status_Date] [datetime] NULL,
	[Downtime_Int] [int] NULL,
	[Downtime] [datetime] NULL,
	[Notify_Int] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VP_Role]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VP_Role](
	[Role_ID] [int] IDENTITY(1,1) NOT NULL,
	[Role_Name] [nvarchar](50) NOT NULL,
	[Role_Createddate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Role_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Role_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VP_SERVER_ENV_DETAIL]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VP_SERVER_ENV_DETAIL](
	[Env_ID] [int] IDENTITY(1,1) NOT NULL,
	[Env_Title] [varchar](200) NULL,
	[Env_Output] [varchar](1000) NULL,
	[Env_For] [varchar](50) NULL,
	[Email_Recipient] [varchar](100) NULL,
 CONSTRAINT [PK_VP_SERVER_ENV_DETAIL] PRIMARY KEY CLUSTERED 
(
	[Env_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VP_SERVER_LIST]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VP_SERVER_LIST](
	[ServerID] [int] IDENTITY(1,1) NOT NULL,
	[SERVER_NAME] [varchar](30) NOT NULL,
	[ACTIVE_FLAG] [bit] NOT NULL,
	[DESCR] [varchar](50) NULL,
 CONSTRAINT [PK_VP_SERVER_LIST] PRIMARY KEY CLUSTERED 
(
	[ServerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VP_ServerStats]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VP_ServerStats](
	[ServerID] [int] IDENTITY(1,1) NOT NULL,
	[ServerNm] [varchar](30) NOT NULL,
	[PerfDate] [datetime] NOT NULL,
	[PctProc] [decimal](10, 4) NOT NULL,
	[Memory] [bigint] NOT NULL,
	[PgFilUse] [decimal](10, 4) NOT NULL,
	[DskSecRd] [decimal](10, 4) NOT NULL,
	[DskSecWrt] [decimal](10, 4) NOT NULL,
	[ProcQueLn] [int] NOT NULL,
 CONSTRAINT [PK_VP_ServerStats] PRIMARY KEY CLUSTERED 
(
	[ServerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VP_SERVICE_LIST]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VP_SERVICE_LIST](
	[Service_ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL,
	[Server_Name] [varchar](100) NULL,
	[Service_Name] [varchar](100) NULL,
	[Env_Search_String] [varchar](100) NULL,
	[Notify_Flag] [bit] NULL,
	[Env_ID] [int] NULL,
	[Active_Flag] [bit] NULL,
 CONSTRAINT [PK_VP_SERVICE_LIST] PRIMARY KEY CLUSTERED 
(
	[Service_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VP_SERVICE_STATUS]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VP_SERVICE_STATUS](
	[Service_ID] [int] NULL,
	[Status] [varchar](50) NULL,
	[Status_Date] [datetime] NULL,
	[Downtime_Int] [int] NULL,
	[Downtime] [datetime] NULL,
	[Notify_int] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VP_SP_DOWNTIME_LOG]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VP_SP_DOWNTIME_LOG](
	[Service_ID] [int] NULL,
	[Status] [varchar](20) NULL,
	[Status_Date] [datetime] NULL,
	[Down_Time] [datetime] NULL,
	[Status_For] [nvarchar](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VP_SplashPage_items]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VP_SplashPage_items](
	[id] [int] NULL,
	[GroupName] [nvarchar](100) NULL,
	[GroupOrder] [int] NULL,
	[ItemName] [varchar](50) NULL,
	[ItemOrger] [int] NULL,
	[Url] [nvarchar](1000) NULL,
	[preference] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VP_SplashPage_links]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VP_SplashPage_links](
	[Id] [int] NOT NULL,
	[Group] [varchar](100) NOT NULL,
	[Environment] [varchar](100) NOT NULL,
	[Preference] [int] NOT NULL,
	[Url] [varchar](1000) NULL,
 CONSTRAINT [PK_GroupPreference] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VP_SplashPage_login]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VP_SplashPage_login](
	[UserName] [varchar](50) NULL,
	[Password] [varchar](50) NULL,
	[Role] [varchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VP_SplashPage_Note]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VP_SplashPage_Note](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Note] [varchar](1000) NULL,
	[Noteby] [varchar](50) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Status] [bit] NULL,
	[Priority] [varchar](10) NULL,
	[TimeStamp] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VP_User]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VP_User](
	[User_ID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](50) NULL,
	[Password] [varchar](250) NULL,
	[Role_ID] [int] NULL,
 CONSTRAINT [PK_VP_User] PRIMARY KEY CLUSTERED 
(
	[User_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [AK_VP_ServerStats]    Script Date: 6/1/2020 9:34:54 AM ******/
CREATE NONCLUSTERED INDEX [AK_VP_ServerStats] ON [dbo].[VP_InstanceStats]
(
	[ServerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_VP_ServerStats_PerfDate]    Script Date: 6/1/2020 9:34:54 AM ******/
CREATE NONCLUSTERED INDEX [IX_VP_ServerStats_PerfDate] ON [dbo].[VP_ServerStats]
(
	[PerfDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VP_PROCESS_STATUS] ADD  CONSTRAINT [DF_VP_PROCESS_STATUS_Downtime_Int]  DEFAULT ((0)) FOR [Downtime_Int]
GO
ALTER TABLE [dbo].[VP_PROCESS_STATUS] ADD  CONSTRAINT [DF_VP_PROCESS_STATUS_Notify_Int]  DEFAULT ((0)) FOR [Notify_Int]
GO
ALTER TABLE [dbo].[VP_SERVICE_STATUS] ADD  CONSTRAINT [DF_VP_SERVICE_STATUS_Downtime_Int]  DEFAULT ((0)) FOR [Downtime_Int]
GO
ALTER TABLE [dbo].[VP_SERVICE_STATUS] ADD  CONSTRAINT [DF_VP_SERVICE_STATUS_notify_Int]  DEFAULT ((0)) FOR [Notify_int]
GO
ALTER TABLE [dbo].[VP_DB_FILE_LIST]  WITH CHECK ADD  CONSTRAINT [FK_VP_DB_FILE_LIST_VP_DB_SERVER_LIST] FOREIGN KEY([ServerID])
REFERENCES [dbo].[VP_DB_SERVER_LIST] ([ServerID])
GO
ALTER TABLE [dbo].[VP_DB_FILE_LIST] CHECK CONSTRAINT [FK_VP_DB_FILE_LIST_VP_DB_SERVER_LIST]
GO
ALTER TABLE [dbo].[VP_DB_GROWTH]  WITH CHECK ADD  CONSTRAINT [FK_VP_DB_GROWTH_VP_DB_FILE_LIST] FOREIGN KEY([DB_File_ID])
REFERENCES [dbo].[VP_DB_FILE_LIST] ([DB_File_ID])
GO
ALTER TABLE [dbo].[VP_DB_GROWTH] CHECK CONSTRAINT [FK_VP_DB_GROWTH_VP_DB_FILE_LIST]
GO
ALTER TABLE [dbo].[VP_InstanceStats]  WITH CHECK ADD  CONSTRAINT [FX_VP_InstanceStats] FOREIGN KEY([ServerID])
REFERENCES [dbo].[VP_ServerStats] ([ServerID])
GO
ALTER TABLE [dbo].[VP_InstanceStats] CHECK CONSTRAINT [FX_VP_InstanceStats]
GO
ALTER TABLE [dbo].[VP_PROCESS_LIST]  WITH CHECK ADD  CONSTRAINT [FK_PROCESS_ENV_ID] FOREIGN KEY([Env_ID])
REFERENCES [dbo].[VP_SERVER_ENV_DETAIL] ([Env_ID])
GO
ALTER TABLE [dbo].[VP_PROCESS_LIST] CHECK CONSTRAINT [FK_PROCESS_ENV_ID]
GO
ALTER TABLE [dbo].[VP_SERVICE_LIST]  WITH CHECK ADD  CONSTRAINT [FK_ENV_ID] FOREIGN KEY([Env_ID])
REFERENCES [dbo].[VP_SERVER_ENV_DETAIL] ([Env_ID])
GO
ALTER TABLE [dbo].[VP_SERVICE_LIST] CHECK CONSTRAINT [FK_ENV_ID]
GO
ALTER TABLE [dbo].[VP_User]  WITH CHECK ADD FOREIGN KEY([Role_ID])
REFERENCES [dbo].[VP_Role] ([Role_ID])
GO
/****** Object:  StoredProcedure [dbo].[dbgrowthdisplay]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[dbgrowthdisplay]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

Select  STRING_AGG(cast(OrigSize as NVARCHAR(MAX)), ', ') as Size, STRING_AGG(cast(MetricDate as NVARCHAR(MAX)), '","')as MDate
FROM [dbo].[VP_Growth_Rate] WHERE [ServerName]= 'TOTPROD09-SQL' and [DBName]='master' AND FileType='Rows';
END
GO
/****** Object:  StoredProcedure [dbo].[dbgrowthdisplaydev]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[dbgrowthdisplaydev] 
@ServerName varchar(100),
@DBName varchar(100), 
@FileType char(4),
@startTime datetime = null,
@endTime datetime = null,
@startDate datetime = null,
@endDate datetime = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

Select  STRING_AGG(cast(OrigSize as NVARCHAR(MAX)), ', ') as Size, STRING_AGG(cast(MetricDate as NVARCHAR(MAX)), '","')as MDate
--FROM [dbo].[VP_Growth_Rate] WHERE [ServerName]= @ServerName and [DBName]= @DBName AND FileType= @FileType;
FROM VP_DB_SERVER_LIST A INNER JOIN VP_DB_FILE_LIST B ON A.ServerID = B.ServerID
						INNER JOIN VP_DB_GROWTH C ON B.DB_File_ID = C.DB_File_ID
WHERE A.[DB_SERVER_NAME] = @ServerName
	 AND B.[DBName] = @DBName 
	 AND B.[FileType] = @FileType
	 AND C.MetricDate BETWEEN @startDate AND @endDate
	 AND CONVERT(VARCHAR(8),C.MetricDate,108) BETWEEN @startTime AND @endTime
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DBGROWTH_CHART]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vimal Patel	
-- Create date: 04/25/2020
-- Description:	Get Data as comma seperated string for chart
-- =============================================
CREATE PROCEDURE [dbo].[SP_DBGROWTH_CHART] 
@ServerID int,
@DBName varchar(100), 
@FileType char(4) = 'both',
@startTime datetime = null,
@endTime datetime = null,
@startDate datetime = null,
@endDate datetime = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @sql nvarchar(max)

	Set @sql ='Select B.FileType,  STRING_AGG(cast(OrigSize as NVARCHAR(MAX)), '', '') as Size, STRING_AGG(cast(MetricDate as NVARCHAR(MAX)), ''","'')as MDate
					FROM VP_DB_SERVER_LIST A INNER JOIN VP_DB_FILE_LIST B ON A.ServerID = B.ServerID
											INNER JOIN VP_DB_GROWTH C ON B.DB_File_ID = C.DB_File_ID
					WHERE 1 = 1
						AND A.[ServerID] = @sid
						AND B.[DBName] = @dbn
						AND [FileType] = @ft'
			
	IF (@startDate is not null) AND (@endDate is not null)
		Set @sql = @sql + ' AND C.MetricDate BETWEEN @sd AND @ed'
	IF (@startTime is not null) AND (@endTime is not null)
		Set @sql = @sql + ' AND CONVERT(VARCHAR(8),C.MetricDate,108) BETWEEN @st AND @et' 
	IF @FileType = 'both'
	BEGIN
	Set @sql = @sql + ' GROUP BY B.FileType'	
	Execute sp_executesql @sql,
							N'@sid int,@dbn varchar(100),@ft varchar(4),@sd datetime,@ed datetime,@st datetime,@et datetime',
							@sid=@ServerID,@dbn=@DBName,@ft='LOG',@sd=@startDate,@ed=@endDate,@st=@startTime,@et=@endTime

	Execute sp_executesql @sql,
							N'@sid int,@dbn varchar(100),@ft varchar(4),@sd datetime,@ed datetime,@st datetime,@et datetime',
							@sid=@ServerID,@dbn=@DBName,@ft='ROWS',@sd=@startDate,@ed=@endDate,@st=@startTime,@et=@endTime
	END
	ELSE
	BEGIN
	Set @sql = @sql + ' GROUP BY B.FileType'
	Execute sp_executesql @sql,
							N'@sid int,@dbn varchar(100),@ft varchar(4),@sd datetime,@ed datetime,@st datetime,@et datetime',
							@sid=@ServerID,@dbn=@DBName,@ft=@FileType,@sd=@startDate,@ed=@endDate,@st=@startTime,@et=@endTime
	END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DISK_STATUS]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Vimal Patel
-- Create date: 7/7/2019
-- Description:	Store procedure executed to pull and display disk space status on different servers
-- =============================================
CREATE PROCEDURE [dbo].[SP_DISK_STATUS]


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	--SELECT DISTINCT Environment FROM VP_SERVER_STATUS
	
	DECLARE @ServerName AS VARCHAR(50)
	DECLARE @Descr AS VARCHAR(100)
	DECLARE @Iteration AS INT
	

	DECLARE Server_List CURSOR LOCAL FAST_FORWARD
	FOR
	SELECT DISTINCT ds.ServerName,dbsl.DESCR FROM [VP_DISK_SPACE] ds JOIN [dbo].[VP_DB_SERVER_LIST] dbsl ON dbsl.DB_SERVER_NAME = ds.ServerName

	OPEN Server_List

	SET @Iteration = 0

	FETCH NEXT
	FROM Server_List
	INTO @ServerName,@Descr

	

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @Iteration = @Iteration + 1
		PRINT @ServerName
		Print @Descr

	
		SELECT ds.ServerName,ds.VolumeName,ds.Drive,ds.FreespaceINMB,ds.TotalspaceINMB,CONVERT(DECIMAL(15,2),((CONVERT(NUMERIC(15,0),ds.FreespaceINMB) / CONVERT(NUMERIC(15,0),ds.TotalspaceINMB)) * 100)) AS [Percentage Free],dbsl.DESCR
		FROM [VP_DISK_SPACE] ds JOIN [dbo].[VP_DB_SERVER_LIST] dbsl ON dbsl.DB_SERVER_NAME = ds.ServerName
		WHERE ServerName = @ServerName 
		AND [MetricDate] IN (SELECT MAX(MetricDate) FROM [VP_DISK_SPACE] WHERE ServerName = @ServerName )
		GROUP BY ds.ServerName,dbsl.DESCR,ds.VolumeName,ds.Drive,ds.FreespaceINMB,ds.TotalspaceINMB
		ORDER BY ServerName DESC
		
		FETCH NEXT from Server_List INTO @ServerName ,@Descr
		 
	END
	
	CLOSE Server_List
	DEALLOCATE Server_List

END
GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_InstanceStats]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Insert_InstanceStats]
           (@InstanceID     int OUTPUT
           ,@ServerID       int = NULL
           ,@ServerNm       varchar(30) = NULL
           ,@InstanceNm     varchar(30) = NULL
           ,@PerfDate       datetime = NULL
           ,@FwdRecSec      decimal(10,4) = NULL
           ,@PgSpltSec      decimal(10,4) = NULL
           ,@BufCchHit      decimal(10,4) = NULL
           ,@PgLifeExp      int = NULL
           ,@LogGrwths      int = NULL
           ,@BlkProcs       int = NULL
           ,@BatReqSec      decimal(10,4) = NULL
           ,@SQLCompSec     decimal(10,4) = NULL
           ,@SQLRcmpSec     decimal(10,4) = NULL
		   ,@BufPrdSec		decimal(10,4) = NULL
		   ,@BufPwrtSec		decimal(10,4) = NULL)
AS
    SET NOCOUNT ON
    
    DECLARE @InstanceOut table( InstanceID int);

    INSERT INTO [VP_InstanceStats]
           ([ServerID]
           ,[ServerNm]
           ,[InstanceNm]
           ,[PerfDate]
           ,[FwdRecSec]
           ,[PgSpltSec]
           ,[BufCchHit]
           ,[PgLifeExp]
           ,[LogGrwths]
           ,[BlkProcs]
           ,[BatReqSec]
           ,[SQLCompSec]
           ,[SQLRcmpSec]
		   ,[BufPrdSec]
		   ,[BufPwrtSec])
    OUTPUT INSERTED.InstanceID INTO @InstanceOut
    VALUES
           (@ServerID
           ,@ServerNm
           ,@InstanceNm
           ,@PerfDate
           ,@FwdRecSec
           ,@PgSpltSec
           ,@BufCchHit
           ,@PgLifeExp
           ,@LogGrwths
           ,@BlkProcs
           ,@BatReqSec
           ,@SQLCompSec
           ,@SQLRcmpSec
		   ,@BufPrdSec
		   ,@BufPwrtSec)

    SELECT @InstanceID = InstanceID FROM @InstanceOut
    
    RETURN

GO
/****** Object:  StoredProcedure [dbo].[SP_INSERT_ServerStats]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_INSERT_ServerStats]
           (@ServerID       int OUTPUT
           ,@ServerNm       varchar(30) = NULL
           ,@PerfDate       datetime = NULL
           ,@PctProc        decimal(10,4) = NULL
           ,@Memory     bigint = NULL
           ,@PgFilUse       decimal(10,4) = NULL
           ,@DskSecRd       decimal(10,4) = NULL
           ,@DskSecWrt      decimal(10,4) = NULL
           ,@ProcQueLn      int = NULL)
AS
    SET NOCOUNT ON
    
    DECLARE @ServerOut table( ServerID int);

    INSERT INTO [VP_ServerStats]
           ([ServerNm]
           ,[PerfDate]
           ,[PctProc]
           ,[Memory]
           ,[PgFilUse]
           ,[DskSecRd]
           ,[DskSecWrt]
           ,[ProcQueLn])
    OUTPUT INSERTED.ServerID INTO @ServerOut
        VALUES
           (@ServerNm
           ,@PerfDate
           ,@PctProc
           ,@Memory
           ,@PgFilUse
           ,@DskSecRd
           ,@DskSecWrt
           ,@ProcQueLn)

    SELECT @ServerID = ServerID FROM @ServerOut
    
    RETURN

GO
/****** Object:  StoredProcedure [dbo].[SP_MASTER_INSERT_UPDATE_DELETE_Env]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Vimal Patel
-- Create date: 11/20/2019
-- Description:	Insert Update Delete Env Title,Output Path,Env for Service/Process
-- =============================================
CREATE PROCEDURE [dbo].[SP_MASTER_INSERT_UPDATE_DELETE_Env]
(
@Env_ID int = null,   
@Env_Title VARCHAR(200) = null,
@Env_Output Varchar(1000) = null,  
@Env_For Varchar(50) = null,
@Email_Recipient Varchar(100) = null,
  
@StatementType nvarchar(20) = null 
)  
AS  
BEGIN  
IF @StatementType = 'Insert'  
BEGIN  
	
		insert into [VP_SERVER_ENV_DETAIL] ([Env_Title],[Env_Output],[Env_For],[Email_Recipient])
				values(@Env_Title,@Env_Output,@Env_For,@Email_Recipient)
	
END  
ELSE IF @StatementType = 'Select'  
BEGIN  

		select [Env_ID],[Env_Title],[Env_Output],[Env_For],[Email_Recipient] from [VP_SERVER_ENV_DETAIL]  

END  
ELSE IF @StatementType = 'Update'  
BEGIN  

		UPDATE [VP_SERVER_ENV_DETAIL] 
				SET	[Env_Title] = @Env_Title, [Env_Output]=@Env_Output,[Env_For]=@Env_For,[Email_Recipient]=@Email_Recipient
				WHERE Env_ID = @Env_ID  

END  
ELSE IF @StatementType = 'Delete'  
BEGIN  

		DELETE FROM [VP_SERVER_ENV_DETAIL] WHERE Env_ID = @Env_ID    

END  
END  
GO
/****** Object:  StoredProcedure [dbo].[SP_MASTER_INSERT_UPDATE_DELETE_LOGINS]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vimal Patel
-- Create date: 11/20/2019
-- Description:	Insert Update Delete Logins
-- =============================================
CREATE PROCEDURE [dbo].[SP_MASTER_INSERT_UPDATE_DELETE_LOGINS]
(
@User_ID int = null,   
@UserName VARCHAR(50) = null,
@Password Varchar(250) = null,  
@Role_id int = null,
  
@StatementType nvarchar(20) = null 
)  
AS  
BEGIN  
IF @StatementType = 'Insert'  
BEGIN  
	
		insert into [VP_User] ([UserName],[Password],[Role_ID])
				values(@UserName,@Password,@Role_id)
	
END  
ELSE IF @StatementType = 'Select'  
BEGIN  
SELECT [User_ID]
      ,[UserName]
      ,[Password]
      ,[Role_ID]
  FROM [VP_User]
		--select * from [VP_User]  

END  
ELSE IF @StatementType = 'Update'  
BEGIN  

		UPDATE [VP_User] 
				SET	[UserName] = @UserName, [Password]=@Password,[Role_ID]=@Role_id
				WHERE [User_ID] = @User_ID  

END  
ELSE IF @StatementType = 'Delete'  
BEGIN  

		DELETE FROM [VP_User] WHERE [User_ID] = @User_ID    

END  
END  
GO
/****** Object:  StoredProcedure [dbo].[SP_MASTER_INSERT_UPDATE_DELETE_PROCESS]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Vimal Patel
-- Create date: 11/20/2019
-- Description:	Insert Update Delete Process List
-- =============================================
CREATE PROCEDURE [dbo].[SP_MASTER_INSERT_UPDATE_DELETE_PROCESS]
(
@Process_ID int = null,   
@Description VARCHAR(100) = null,
@Server_Name Varchar(100) = null,  
@Process_Name Varchar(100) = null,
@Env_Search_String Varchar(100) = null,
@Notify_Flag bit = null,
@Env_ID int = null,
@Active_Flag bit = null,
@StatementType nvarchar(20)  = null 
)  
AS  
BEGIN  
IF @StatementType = 'Insert'  
BEGIN  
	
		insert into [VP_PROCESS_LIST] ([Description],[Server_Name],[Process_Name],[Env_Search_String],[Notify_Flag],[Env_ID],[Active_Flag])
				values(@Description,@Server_Name,@Process_Name,@Env_Search_String,@Notify_Flag,@Env_ID,@Active_Flag)
	
END  
ELSE IF @StatementType = 'Select'  
BEGIN  

		select * from [VP_PROCESS_LIST]  

END  
ELSE IF @StatementType = 'Update'  
BEGIN  

		UPDATE [VP_PROCESS_LIST] 
				SET	[Description] = @Description, [Server_Name]=@Server_Name,[Process_Name]=@Process_Name,[Env_Search_String] =@Env_Search_String,[Notify_Flag]=@Notify_Flag, [Env_ID]=@Env_ID ,[Active_Flag]=@Active_Flag
				WHERE Process_ID = @Process_ID  

END  
ELSE IF @StatementType = 'Delete'  
BEGIN  

		DELETE FROM [VP_PROCESS_LIST] WHERE Process_ID = @Process_ID  

END  
END  
GO
/****** Object:  StoredProcedure [dbo].[SP_MASTER_INSERT_UPDATE_DELETE_SERVER]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Vimal Patel
-- Create date: 11/20/2019
-- Description:	Insert Update Delete Env Title,Output Path,Env for Service/Process
-- =============================================
CREATE PROCEDURE [dbo].[SP_MASTER_INSERT_UPDATE_DELETE_SERVER]
(
@ServerID int = null,   
@DB_Server_Name VARCHAR(30) = null,
@Active_Flag bit = null,  
@Descr Varchar(50) = null,
  
@StatementType nvarchar(20) = null 
)  
AS  
BEGIN  
IF @StatementType = 'Insert'  
BEGIN  
	
		insert into [VP_DB_SERVER_LIST] ([DB_SERVER_NAME],[ACTIVE_FLAG],[DESCR])
				values(@DB_Server_Name,@Active_Flag,@Descr)
	
END  
ELSE IF @StatementType = 'Select'  
BEGIN  

		select [ServerID],[DB_SERVER_NAME],[ACTIVE_FLAG],[DESCR] from [VP_DB_SERVER_LIST]  

END  
ELSE IF @StatementType = 'Update'  
BEGIN  

		UPDATE [VP_DB_SERVER_LIST] 
				SET	[DB_SERVER_NAME] = @DB_Server_Name, [ACTIVE_FLAG]=@Active_Flag,[DESCR]=@Descr
				WHERE ServerID = @ServerID  

END  
ELSE IF @StatementType = 'Delete'  
BEGIN  

		DELETE FROM [VP_DB_SERVER_LIST] WHERE ServerID = @ServerID    

END  
END  
GO
/****** Object:  StoredProcedure [dbo].[SP_MASTER_INSERT_UPDATE_DELETE_SERVICE]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Vimal Patel
-- Create date: 11/20/2019
-- Description:	Insert Update Delete Service List
-- =============================================
CREATE PROCEDURE [dbo].[SP_MASTER_INSERT_UPDATE_DELETE_SERVICE]
(
@Service_ID int = null,   
@Description VARCHAR(100) = null,
@Server_Name Varchar(100) = null,  
@Service_Name Varchar(100) = null,
@Env_Search_String Varchar(100) = null,
@Notify_Flag bit = null,
@Env_ID int = null,
@Active_Flag bit = null,
@StatementType nvarchar(20)  = null 
)   
AS  
BEGIN  
IF @StatementType = 'Insert'  
BEGIN  
	
		insert into [VP_SERVICE_LIST] ([Description],[Server_Name],[Service_Name],[Env_Search_String],[Notify_Flag],[Env_ID],[Active_Flag])
				values(@Description,@Server_Name,@Service_Name,@Env_Search_String,@Notify_Flag,@Env_ID,@Active_Flag)
	
END  
ELSE IF @StatementType = 'Select'  
BEGIN  

		select * from [VP_SERVICE_LIST]  

END  
ELSE IF @StatementType = 'Update'  
BEGIN  

		UPDATE [VP_SERVICE_LIST] 
				SET	[Description] = @Description, [Server_Name]=@Server_Name,[Service_Name]=@Service_Name,[Env_Search_String] =@Env_Search_String,[Notify_Flag]=@Notify_Flag, [Env_ID]=@Env_ID, [Active_Flag]=@Active_Flag
				WHERE Service_ID = @Service_ID  

END  
ELSE IF @StatementType = 'Delete'  
BEGIN  

		DELETE FROM [VP_SERVICE_LIST] WHERE Service_ID = @Service_ID  

END  
END  
GO
/****** Object:  StoredProcedure [dbo].[SP_MasterInsertUpdateDeleteNOTE]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_MasterInsertUpdateDeleteNOTE]
(
@Id int ='',   
@Note VARCHAR(1000),
@Noteby Varchar(50),  
@StartDate datetime,  
@EndDate datetime,  
@Status bit,  
@Priority varchar(20),
@TimeStamp datetime = '',
@StatementType nvarchar(20) ='' 
)  
AS  
BEGIN  
IF @StatementType = 'Insert'  
BEGIN  
	IF @EndDate < GETDATE()
	BEGIN
		insert into VP_SplashPage_Note ([Note],[Noteby],[StartDate],[EndDate],[Status],[Priority],[TimeStamp])
				values(@Note,@Noteby,@StartDate,@EndDate,0,@Priority,GETDATE())
	END
	ELSE 
	BEGIN
		insert into VP_SplashPage_Note ([Note],[Noteby],[StartDate],[EndDate],[Status],[Priority],[TimeStamp])
				values(@Note,@Noteby,@StartDate,@EndDate,1,@Priority,GETDATE())
	END	  

END  
IF @StatementType = 'Select'  
BEGIN  
select * from VP_SplashPage_Note  
END  
IF @StatementType = 'Update'  
BEGIN  
UPDATE VP_SplashPage_Note SET  
[Note] = @Note, [Noteby]=@Noteby,[StartDate]=@StartDate,[EndDate]=@EndDate,[Status]=@Status,[Priority]=@Priority,[TimeStamp]=getdate()
WHERE Id = @id  
END  
else IF @StatementType = 'Delete'  
BEGIN  
DELETE FROM VP_SplashPage_Note WHERE Id = @id  
END  
end  
GO
/****** Object:  StoredProcedure [dbo].[SP_NONRUNNING_PROCESSES]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vimal Patel
-- Create date: 7/1/2019
-- Description:	Store Procedure that fetched Non Running Processes from [VP_PROCESS_STATUS] to display on dashboard
-- =============================================
CREATE PROCEDURE [dbo].[SP_NONRUNNING_PROCESSES]
	@process_lastrun datetime output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT C.[Env_Title]
			,B.[Description]
			,B.[Server_Name]
			,B.[Process_Name]
			,A.[Status]
			,Max(A.Status_Date) As Status_Date
			--,ROW_NUMBER()  OVER (ORDER BY  [Service_Name]) 
		FROM [VP_PROCESS_STATUS] A INNER JOIN [VP_PROCESS_LIST] B ON A.Process_ID = B.Process_ID
									INNER JOIN [VP_SERVER_ENV_DETAIL] C ON B.Env_ID = C.Env_ID
		WHERE [STATUS] = 'Not Running'
		 
		GROUP BY C.[Env_Title],B.[Description],B.[Server_Name],B.[Process_Name],A.[Status]
		ORDER BY B.[Process_Name] DESC

	SET @process_lastrun = (Select  TOP 1 A.Status_Date FROM [VP_PROCESS_STATUS] A INNER JOIN [VP_PROCESS_LIST] B ON A.Process_ID = B.Process_ID
									INNER JOIN [VP_SERVER_ENV_DETAIL] C ON B.Env_ID = C.Env_ID
									ORDER BY A.Status_Date DESC)


END
GO
/****** Object:  StoredProcedure [dbo].[SP_NONRUNNING_SERVICES]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vimal Patel
-- Create date: 7/7/2019
-- Description:	Store procedure executed to pull and display service status on different servers
-- =============================================
CREATE PROCEDURE [dbo].[SP_NONRUNNING_SERVICES]

 @service_lastrun datetime OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT C.[Env_Title]
			,B.[Description]
			,B.[Server_Name]
			,B.[Service_Name]
			,A.[Status]
			,Max(A.Status_Date) As Status_Date
			--,ROW_NUMBER()  OVER (ORDER BY  [Service_Name]) 
		FROM [VP_SERVICE_STATUS] A INNER JOIN [VP_SERVICE_LIST] B ON A.Service_ID = B.Service_ID
									INNER JOIN [VP_SERVER_ENV_DETAIL] C ON B.Env_ID = C.Env_ID
		WHERE [STATUS] = 'Stopped'
		 
		GROUP BY C.[Env_Title],B.[Description],B.[Server_Name],B.[Service_Name],A.[Status]
		ORDER BY B.[Service_Name] DESC

SET @service_lastrun = (Select  TOP 1 A.Status_Date FROM [VP_SERVICE_STATUS] A INNER JOIN [VP_SERVICE_LIST] B ON A.Service_ID = B.Service_ID
									INNER JOIN [VP_SERVER_ENV_DETAIL] C ON B.Env_ID = C.Env_ID
									ORDER BY A.Status_Date DESC)


END
GO
/****** Object:  StoredProcedure [dbo].[SP_PROCESS_STATUS]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vimal Patel
-- Create date: 7/7/2019
-- Description:	Store procedure executed to pull and display process status on different servers
-- =============================================
CREATE PROCEDURE [dbo].[SP_PROCESS_STATUS]

 @lastrun datetime OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	--SELECT DISTINCT Environment FROM VP_SERVER_STATUS
	
	DECLARE @Environment AS VARCHAR(50)
	DECLARE @SQL_Statement AS NVARCHAR(max)
	DECLARE @Iteration AS INT
	

	DECLARE Environment_List CURSOR LOCAL FAST_FORWARD
	FOR
	SELECT DISTINCT C.Env_Title FROM [VP_PROCESS_LIST] B INNER JOIN [VP_SERVER_ENV_DETAIL] C ON B.Env_ID = C.Env_ID

	OPEN Environment_List

	SET @Iteration = 0

	FETCH NEXT
	FROM Environment_List
	INTO @Environment

	

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @Iteration = @Iteration + 1
		PRINT @Environment

		SELECT C.[Env_Title]
			,B.[Description]
			,B.[Server_Name]
			,B.[Process_Name]
			,A.[Status]
			,Max(A.Status_Date) As Status_Date
			--,ROW_NUMBER()  OVER (ORDER BY  [Service_Name]) 
		FROM [VP_PROCESS_STATUS] A INNER JOIN [VP_PROCESS_LIST] B ON A.Process_ID = B.Process_ID
									INNER JOIN [VP_SERVER_ENV_DETAIL] C ON B.Env_ID = C.Env_ID
		WHERE C.Env_Title = @Environment 
		 
		GROUP BY C.[Env_Title],B.[Description],B.[Server_Name],B.[Process_Name],A.[Status]
		ORDER BY B.[Process_Name] DESC
		
		FETCH NEXT from Environment_List INTO @Environment
		 
	END
	
	CLOSE Environment_List
	DEALLOCATE Environment_List


	SET @lastrun = (Select  TOP 1 A.Status_Date FROM [VP_PROCESS_STATUS] A INNER JOIN [VP_PROCESS_LIST] B ON A.Process_ID = B.Process_ID
									INNER JOIN [VP_SERVER_ENV_DETAIL] C ON B.Env_ID = C.Env_ID
									ORDER BY A.Status_Date DESC)

END
GO
/****** Object:  StoredProcedure [dbo].[SP_SERVICES_STATUS]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vimal Patel
-- Create date: 7/8/2019
-- Description:	Store Procedure to pull Services Status
-- =============================================
CREATE PROCEDURE [dbo].[SP_SERVICES_STATUS]
	
	@lastrun datetime OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	--SELECT DISTINCT Environment FROM VP_SERVICES_STATUS
	
	DECLARE @Environment AS VARCHAR(50)
	DECLARE @SQL_Statement AS NVARCHAR(max)
	DECLARE @Iteration AS INT
	

	DECLARE Environment_List CURSOR LOCAL FAST_FORWARD
	FOR
	SELECT DISTINCT C.Env_Title FROM [VP_SERVICE_LIST] B INNER JOIN [VP_SERVER_ENV_DETAIL] C ON B.Env_ID = C.Env_ID

	OPEN Environment_List

	SET @Iteration = 0

	FETCH NEXT
	FROM Environment_List
	INTO @Environment

	

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @Iteration = @Iteration + 1
		PRINT @Environment

		SELECT C.[Env_Title]
			,B.[Description]
			,B.[Server_Name]
			,B.[Service_Name]
			,A.[Status]
			,Max(A.Status_Date) As Status_Date
			--,Max(Status_Date) As Status_Date
			--,ROW_NUMBER()  OVER (ORDER BY  [Service_Name]) 
		FROM [VP_SERVICE_STATUS] A INNER JOIN [VP_SERVICE_LIST] B ON A.Service_ID = B.Service_ID
									INNER JOIN [VP_SERVER_ENV_DETAIL] C ON B.Env_ID = C.Env_ID 
		WHERE C.Env_Title = @Environment 
		GROUP BY C.[Env_Title],B.[Description],B.[Server_Name],B.[Service_Name],A.[Status]
		ORDER BY B.[Service_Name] DESC
		
		FETCH NEXT from Environment_List INTO @Environment
		 
	END
	
	CLOSE Environment_List
	DEALLOCATE Environment_List

	Set @lastrun = (SELECT TOP 1 A.Status_Date FROM [VP_SERVICE_STATUS] A INNER JOIN [VP_SERVICE_LIST] B ON A.Service_ID = B.Service_ID
									INNER JOIN [VP_SERVER_ENV_DETAIL] C ON B.Env_ID = C.Env_ID
									ORDER BY A.Status_Date DESC)

END
GO
/****** Object:  StoredProcedure [dbo].[SP_SPLASH_PAGE]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_SPLASH_PAGE]   
   
AS   

    SET NOCOUNT ON;  

	DECLARE @Group AS VARCHAR(50)
	DECLARE @Iteration AS INT
	

	DECLARE Group_List CURSOR LOCAL FAST_FORWARD
	FOR
	SELECT [Group] 
		FROM VP_SplashPage_links 
		WHERE Preference in (SELECT min(Preference) 
									FROM VP_SplashPage_links 
									GROUP BY [Group]) 
									ORDER BY Preference

	OPEN Group_List

	SET @Iteration = 0

	FETCH NEXT
	FROM Group_List
	INTO @Group

	

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @Iteration = @Iteration + 1
		PRINT @Group

SELECT [Group],Environment,'<a href="'+ Url +'">' +Url+'</a>' from [dbo].[VP_SplashPage_links] WHERE [Group] = @Group
ORDER by Preference 


		FETCH NEXT from Group_List INTO @Group
		 
	END
	
	CLOSE Group_List
	DEALLOCATE Group_List
GO
/****** Object:  StoredProcedure [dbo].[VP_DBGROWTH_RATE]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[VP_DBGROWTH_RATE]
AS
BEGIN
	
--select distinct DBName from #TempDBSize1 where server_name = 'TOTPSDBTST01'

------------------------------------------------------------
-- Retrieve DB File Size Information and Check the growth -- 
------------------------------------------------------------
--Scheduled Job to automate the growth monitoring-----------
--Below is the code run Daily/Weekly to check the growth.---
------------------------------------------------------------

CREATE TABLE #TempDBSize3 (
	ServerName varchar(100),
    DBName varchar(100),
	LogicalName varchar(100),
	Filetype varchar(100),
	database_id int,
	file_id varchar(4),
	size int )

DECLARE @Server_Name AS VARCHAR(30)
DECLARE @SQL_Statement AS NVARCHAR(MAX)
DECLARE @Iteration AS INT

DECLARE Server_List CURSOR LOCAL FAST_FORWARD FOR

SELECT DB_SERVER_NAME
FROM VP_DB_SERVER_LIST
WHERE ACTIVE_FLAG = '1'

OPEN Server_List
SET @Iteration = 0

FETCH NEXT from Server_List INTO @Server_Name

WHILE @@FETCH_STATUS = 0 BEGIN
  SET @Iteration = @Iteration + 1


PRINT @Server_Name


---------------------------------------
-- Retrieve DB File Size Information -- 
---------------------------------------
BEGIN TRY
 SET @SQL_Statement = N'SELECT * '+
                      N'FROM OPENROWSET (''SQLOLEDB'',''Server='+@Server_Name+';Trusted_Connection=Yes;'',''SELECT @@servername as server_name, sd.name AS DBName, mf.name AS LogicalName, mf.type_desc AS Filetype, mf.database_id, file_id, size FROM sys.databases sd JOIN sys.master_files mf ON sd.database_id = mf.database_id ORDER BY mf.database_id, sd.name'') '


-- Print @SQL_Statement
INSERT INTO #TempDBSize3 EXECUTE sp_executesql @SQL_Statement



  IF EXISTS (SELECT DISTINCT
      DBName,LogicalName
    FROM #TempDBSize3
    WHERE DBName IN (SELECT DISTINCT
      DBName
    FROM VP_Growth_Rate)
	AND LogicalName IN (SELECT DISTINCT
      LogicalName
    FROM VP_Growth_Rate))
    AND CONVERT(varchar(10), GETDATE(), 100) > (SELECT DISTINCT
      CONVERT(varchar(10), MAX(MetricDate), 101) AS MetricDate
    FROM dbo.VP_Growth_Rate)
  BEGIN
    INSERT INTO dbo.VP_Growth_Rate (ServerName,DBName, LogicalName, FileType, DBID, NumPages, OrigSize, CurSize, GrowthAmt, MetricDate)
      (
      SELECT
		tds.ServerName,
        tds.DBName,
		tds.LogicalName,
		tds.Filetype,
        tds.database_id,
        SUM(tds.size) AS NumPages,
        dgr.CurSize AS OrigSize,
        CONVERT(decimal(10, 2), (((SUM(CONVERT(decimal(10, 2), tds.size)) * 8000) / 1024) / 1024)) AS CurSize,
        CONVERT(varchar(100), (CONVERT(decimal(10, 2), (((SUM(CONVERT(decimal(10, 2), tds.size)) * 8000) / 1024) / 1024)) - dgr.CurSize)) AS GrowthAmt,
        --CONVERT(varchar(100), (CONVERT(decimal(10, 2), (((SUM(CONVERT(decimal(10, 2), tds.size)) * 8000) / 1024) / 1024)) - dgr.CurSize)) + ' MB' AS GrowthAmt,
        GETDATE() AS MetricDate
      FROM #TempDBSize3 tds
      JOIN VP_Growth_Rate dgr
        ON tds.database_id = dgr.DBID
      WHERE DBGrowthID = (SELECT DISTINCT
        MAX(DBGrowthID)
      FROM VP_Growth_Rate
      WHERE DBID = dgr.DBID)
      GROUP BY tds.database_id,
               tds.ServerName,tds.DBName,tds.LogicalName,tds.Filetype,
               dgr.CurSize
      )
  END
  ELSE
  IF NOT EXISTS (SELECT DISTINCT
      DBName
    FROM #TempDBSize3
    WHERE DBName IN (SELECT DISTINCT
      DBName
    FROM VP_Growth_Rate))
  BEGIN
    INSERT INTO dbo.VP_Growth_Rate (ServerName,DBName, LogicalName, FileType, DBID, NumPages, OrigSize, CurSize, GrowthAmt, MetricDate)
      (
      SELECT
		tds.ServerName,
        tds.DBName,
		tds.LogicalName,
		tds.Filetype,
        tds.database_id,
        SUM(tds.size) AS NumPages,
        CONVERT(decimal(10, 2), (((SUM(CONVERT(decimal(10, 2), tds.size)) * 8000) / 1024) / 1024)) AS OrigSize,
        CONVERT(decimal(10, 2), (((SUM(CONVERT(decimal(10, 2), tds.size)) * 8000) / 1024) / 1024)) AS CurSize,
        '0.00' AS GrowthAmt,
		--'0.00 MB' AS GrowthAmt,
        GETDATE() AS MetricDate
      FROM #TempDBSize3 tds
      WHERE tds.database_id NOT IN (SELECT DISTINCT DBID
      FROM VP_Growth_Rate
      WHERE DBName = tds.database_id)
      GROUP BY tds.database_id,
               tds.ServerName,tds.DBName,tds.LogicalName,tds.Filetype
      )
  END


END TRY

		BEGIN CATCH
		-- Table to record errors
 
--CREATE TABLE VP_DB_Errors
--         (ErrorID        INT IDENTITY(1, 1),
--          UserName       VARCHAR(100),
--          ErrorNumber    INT,
--          ErrorState     INT,
--          ErrorSeverity  INT,
--          ErrorLine      INT,
--          ErrorProcedure VARCHAR(MAX),
--          ErrorMessage   VARCHAR(MAX),
--          ErrorDateTime  DATETIME,
--		  CustomMessage   VARCHAR(100))
--GO
 INSERT INTO VP_DB_Errors
    VALUES
  (SUSER_SNAME(),
   ERROR_NUMBER(),
   ERROR_STATE(),
   ERROR_SEVERITY(),
   ERROR_LINE(),
   ERROR_PROCEDURE(),
   ERROR_MESSAGE(),
   GETDATE(),
   'DB Growth Rate Error');
			FETCH NEXT
			FROM Server_List
			INTO @Server_Name

		END CATCH

		FETCH NEXT
		FROM Server_List
		INTO @Server_Name
	END

	CLOSE Server_List

	DEALLOCATE Server_List
	

------------------------------------------------------------------------------------------------



    DROP TABLE #TempDBSize3

  -- COMMIT
  -- ROLLBACK
  -- DBCC opentran

  --Select * from VP_Growth_Rate where LogicalName = 'tempdev'


/*#######################################################################################*/



--COMMIT
--ROLLBACK

END
GO
/****** Object:  StoredProcedure [dbo].[VP_MONITOR_DB_GROWTH]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[VP_MONITOR_DB_GROWTH]
AS
BEGIN
	-- ============================================================================================
	-- Author: Vimal - 6/11/19 
	-- Description:  Monitor database growth in Normalized Tables Part -2
	-- Server List : VP_DB_SERVER_LIST
	-- Database File List : VP_DB_FILE_LIST
	-- Growth Table : VP_DB_GROWTH    
	------------------------------------------------------------
	-- Retrieve DB File Size Information and Check the growth -- 
	------------------------------------------------------------
	--Scheduled Job to automate the growth monitoring-----------
	--Below is the code run Daily/Weekly to check the growth.---
	-- ============================================================================================
	CREATE TABLE #TempDBSize2 (
		ServerName VARCHAR(100),
		DBName VARCHAR(100),
		LogicalName VARCHAR(100),
		Filetype VARCHAR(100),
		database_id INT,
		file_id VARCHAR(4),
		size INT,
		CreateDate DATETIME
		)

	DECLARE @Server_Name AS VARCHAR(30)
	DECLARE @SQL_Statement AS NVARCHAR(max)
	DECLARE @Iteration AS INT

	DECLARE Server_List CURSOR LOCAL FAST_FORWARD
	FOR
	SELECT DB_SERVER_NAME
	FROM VP_DB_SERVER_LIST
	WHERE ACTIVE_FLAG = '1'

	OPEN Server_List

	SET @Iteration = 0

	FETCH NEXT
	FROM Server_List
	INTO @Server_Name

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @Iteration = @Iteration + 1

		PRINT @Server_Name

		---------------------------------------
		-- Retrieve DB File Size Information -- 
		---------------------------------------
		BEGIN TRY
			SET @SQL_Statement = N'SELECT * ' + N'FROM OPENROWSET (''SQLOLEDB'',''Server=' + @Server_Name + ';Trusted_Connection=Yes;'',''SELECT @@servername as server_name, sd.name AS DBName, mf.name AS LogicalName, mf.type_desc AS Filetype, mf.database_id, file_id, size,sd.create_date FROM sys.databases sd JOIN sys.master_files mf ON sd.database_id = mf.database_id ORDER BY mf.database_id, sd.name'') '
			INSERT INTO #TempDBSize2
			EXECUTE sp_executesql @SQL_Statement

			IF EXISTS (
					SELECT DISTINCT ServerName, DBName,
						LogicalName
					FROM #TempDBSize2
					WHERE DBName IN (
							SELECT DISTINCT DBName
							FROM VP_DB_GROWTH dbg
							INNER JOIN VP_DB_FILE_LIST dbf
								ON dbg.DB_File_ID = dbf.DB_File_ID
							INNER JOIN VP_DB_SERVER_LIST dbs
								ON dbf.ServerID = dbs.ServerID
							WHERE dbs.DB_SERVER_NAME = @Server_Name
							)
						AND LogicalName IN (
							SELECT DISTINCT LogicalName
							FROM VP_DB_GROWTH dbg
							INNER JOIN VP_DB_FILE_LIST dbf
								ON dbg.DB_File_ID = dbf.DB_File_ID
							INNER JOIN VP_DB_SERVER_LIST dbs
									ON dbf.ServerID = dbs.ServerID
								WHERE dbs.DB_SERVER_NAME = @Server_Name
							)
						AND ServerName IN (
								SELECT DISTINCT DB_SERVER_NAME
								FROM VP_DB_FILE_LIST dbf
								INNER JOIN VP_DB_SERVER_LIST dbs
									ON dbf.ServerID = dbs.ServerID
								WHERE dbs.DB_SERVER_NAME = @Server_Name
							)
					)
				AND CONVERT(VARCHAR(23), GETDATE(), 113) > (
					SELECT DISTINCT CONVERT(VARCHAR(23), MAX(MetricDate), 113) AS MetricDate
					FROM VP_DB_GROWTH
					)					
			BEGIN
				INSERT INTO VP_DB_GROWTH (
					DB_File_ID,
					NumPages,
					OrigSize,
					CurSize,
					GrowthAmt,
					MetricDate
					) (
					SELECT dbf.DB_File_ID,
					SUM(tds.size) AS NumPages,
					dbg.CurSize AS OrigSize,
					CONVERT(DECIMAL(10, 2), (((SUM(CONVERT(DECIMAL(10, 2), tds.size)) * 8000) / 1024) / 1024)) AS CurSize,
					CONVERT(VARCHAR(100), (CONVERT(DECIMAL(10, 2), (((SUM(CONVERT(DECIMAL(10, 2), tds.size)) * 8000) / 1024) / 1024)) - dbg.CurSize)) AS GrowthAmt,
					GETDATE() AS MetricDate 
					FROM #TempDBSize2 tds INNER JOIN VP_DB_SERVER_LIST dbs ON tds.ServerName = dbs.DB_SERVER_NAME
										  INNER JOIN VP_DB_FILE_LIST dbf ON tds.DBName = dbf.DBName AND tds.LogicalName =dbf.LogicalName
										  INNER JOIN VP_DB_GROWTH dbg ON dbf.DB_File_ID = dbg.DB_File_ID
					WHERE dbg.DBGrowthID = (SELECT DISTINCT MAX(dbg.DBGrowthID) FROM VP_DB_GROWTH dbg INNER JOIN VP_DB_FILE_LIST dbf
																											ON dbg.DB_File_ID = dbf.DB_File_ID
																									INNER JOIN VP_DB_SERVER_LIST dbs
																											ON dbf.ServerID = dbs.ServerID
																					WHERE tds.database_id = dbf.DBID
																						AND tds.ServerName = @Server_Name
																						AND tds.DBName = dbf.DBName
																						AND tds.LogicalName = dbf.LogicalName
																					) GROUP BY dbf.DB_File_ID,
																				dbg.CurSize
					)
			END
			ELSE
			BEGIN
				IF NOT EXISTS (
						SELECT DISTINCT ServerName,DBName,LogicalName
						FROM #TempDBSize2
						WHERE DBName IN (
								SELECT DISTINCT DBName
								FROM VP_DB_GROWTH dbg
								INNER JOIN VP_DB_FILE_LIST dbf
									ON dbg.DB_File_ID = dbf.DB_File_ID
								INNER JOIN VP_DB_SERVER_LIST dbs
									ON dbf.ServerID = dbs.ServerID
								WHERE dbs.DB_SERVER_NAME = @Server_Name
								)
							AND LogicalName IN (
								SELECT DISTINCT LogicalName
								FROM VP_DB_GROWTH dbg
								INNER JOIN VP_DB_FILE_LIST dbf
									ON dbg.DB_File_ID = dbf.DB_File_ID
								INNER JOIN VP_DB_SERVER_LIST dbs
									ON dbf.ServerID = dbs.ServerID
								WHERE dbs.DB_SERVER_NAME = @Server_Name
								)
							AND ServerName IN (
								SELECT DISTINCT DB_SERVER_NAME
								FROM VP_DB_FILE_LIST dbf
								INNER JOIN VP_DB_SERVER_LIST dbs
									ON dbf.ServerID = dbs.ServerID
								WHERE dbs.DB_SERVER_NAME = @Server_Name
							)
						)
				BEGIN 					
					INSERT INTO VP_DB_FILE_LIST (
						DBName,
						LogicalName,
						FileType,
						DBID,
						CreationDate,
						ServerID
						) (
						SELECT tds.DBName,
						tds.LogicalName,
						tds.Filetype,
						tds.database_id,
						tds.CreateDate,
						dbs.ServerID FROM #TempDBSize2 tds INNER JOIN VP_DB_SERVER_LIST dbs
																ON tds.ServerName = dbs.DB_SERVER_NAME 
															WHERE tds.ServerName = @Server_Name GROUP BY dbs.ServerID,
																										tds.database_id,
																										tds.ServerName,
																										tds.DBName,
																										tds.LogicalName,
																										tds.Filetype,
																										tds.CreateDate						
																										)

						INSERT INTO VP_DB_GROWTH (
						DB_File_ID
						,NumPages
						,OrigSize
						,CurSize
						,GrowthAmt
						,MetricDate
						) (
						SELECT dbf.DB_File_ID
						,SUM(tds.size)
						,CONVERT(DECIMAL(10, 2), (((SUM(CONVERT(DECIMAL(10, 2), tds.size)) * 8000) / 1024) / 1024))
						,CONVERT(DECIMAL(10, 2), (((SUM(CONVERT(DECIMAL(10, 2), tds.size)) * 8000) / 1024) / 1024))
						,'0.00'
						,GETDATE() FROM #TempDBSize2 tds INNER JOIN VP_DB_FILE_LIST dbf
						ON tds.DBName = dbf.DBName
							AND tds.LogicalName = dbf.LogicalName
							AND tds.Filetype = dbf.FileType
							AND tds.database_id = dbf.DBID INNER JOIN VP_DB_SERVER_LIST dbs
						ON tds.ServerName = dbs.DB_SERVER_NAME WHERE tds.ServerName = @Server_Name
						AND tds.LogicalName NOT IN (
							SELECT DISTINCT dbf.LogicalName
							FROM VP_DB_GROWTH dbg
							INNER JOIN VP_DB_FILE_LIST dbf
								ON dbg.DB_File_ID = dbf.DB_File_ID
							INNER JOIN VP_DB_SERVER_LIST dbs
								ON tds.ServerName = dbs.DB_SERVER_NAME
							WHERE tds.ServerName = @Server_Name
							) GROUP BY dbf.DB_File_ID	
							)								
					
				END
				ELSE
				BEGIN
					
						INSERT INTO VP_DB_GROWTH (
						DB_File_ID
						,NumPages
						,OrigSize
						,CurSize
						,GrowthAmt
						,MetricDate
						) (
						SELECT dbf.DB_File_ID
						,SUM(tds.size)
						,CONVERT(DECIMAL(10, 2), (((SUM(CONVERT(DECIMAL(10, 2), tds.size)) * 8000) / 1024) / 1024))
						,CONVERT(DECIMAL(10, 2), (((SUM(CONVERT(DECIMAL(10, 2), tds.size)) * 8000) / 1024) / 1024))
						,'0.00'
						,GETDATE() FROM #TempDBSize2 tds INNER JOIN VP_DB_FILE_LIST dbf
						ON tds.DBName = dbf.DBName
							AND tds.LogicalName = dbf.LogicalName
							AND tds.Filetype = dbf.FileType
							AND tds.database_id = dbf.DBID INNER JOIN VP_DB_SERVER_LIST dbs
						ON tds.ServerName = dbs.DB_SERVER_NAME WHERE tds.ServerName = @Server_Name
						AND tds.LogicalName NOT IN (
							SELECT DISTINCT dbf.LogicalName
							FROM VP_DB_GROWTH dbg
							INNER JOIN VP_DB_FILE_LIST dbf
								ON dbg.DB_File_ID = dbf.DB_File_ID
							INNER JOIN VP_DB_SERVER_LIST dbs
								ON tds.ServerName = dbs.DB_SERVER_NAME
							WHERE tds.ServerName = @Server_Name
							) GROUP BY dbf.DB_File_ID	
							)	
				END
			END
					/*############################# FETCH NEXT SERVER FROM TABLE #################################################################*/
		END TRY

		BEGIN CATCH
			-- Table to record errors
 
--CREATE TABLE VP_DB_Errors
--         (ErrorID        INT IDENTITY(1, 1),
--          UserName       VARCHAR(100),
--          ErrorNumber    INT,
--          ErrorState     INT,
--          ErrorSeverity  INT,
--          ErrorLine      INT,
--          ErrorProcedure VARCHAR(MAX),
--          ErrorMessage   VARCHAR(MAX),
--          ErrorDateTime  DATETIME,
--		  CustomMessage   VARCHAR(100))
--GO
 INSERT INTO VP_DB_Errors
    VALUES
  (SUSER_SNAME(),
   ERROR_NUMBER(),
   ERROR_STATE(),
   ERROR_SEVERITY(),
   ERROR_LINE(),
   ERROR_PROCEDURE(),
   ERROR_MESSAGE(),
   GETDATE(),
   'DB Growth Rate');
			FETCH NEXT
			FROM Server_List
			INTO @Server_Name
			TRUNCATE TABLE #TempDBSize2
		END CATCH

		FETCH NEXT
		FROM Server_List
		INTO @Server_Name
		TRUNCATE TABLE #TempDBSize2
	END

	CLOSE Server_List

	DEALLOCATE Server_List

	DROP TABLE #TempDBSize2
	
END
GO
/****** Object:  StoredProcedure [dbo].[VP_MONITOR_DISK_SPACE]    Script Date: 6/1/2020 9:34:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[VP_MONITOR_DISK_SPACE]
AS
BEGIN
	-- ============================================================================================
	-- Author: Vimal - 8/9/19 
	-- Description:  Monitor DISK SPACE 
	-- Server List : VP_DB_SERVER_LIST
	-- DiskSpace Table : VP_DB_DISKSPACE    
	------------------------------------------------------------
	-- Retrieve Disk Size Information and Check the growth -- 
	------------------------------------------------------------
	--Scheduled Job to automate the growth monitoring-----------
	--Below is the code run Daily/Weekly to check the growth.---
	-- ============================================================================================	
	CREATE TABLE #TempDBSize4 (
		ServerName VARCHAR(100),
		VolumeName VARCHAR(100),
		Drive CHAR(3),
		FreeSpaceINMB INT,
		TotalSpaceINMB INT,
		MetricDate DATETIME
		)

	DECLARE @Server_Name AS VARCHAR(30)
	DECLARE @SQL_Statement AS NVARCHAR(max)
	DECLARE @Iteration AS INT

	DECLARE Server_List CURSOR LOCAL FAST_FORWARD
	FOR
	SELECT DB_SERVER_NAME
	FROM VP_DB_SERVER_LIST
	WHERE ACTIVE_FLAG = '1' 

	OPEN Server_List

	SET @Iteration = 0

	FETCH NEXT
	FROM Server_List
	INTO @Server_Name

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @Iteration = @Iteration + 1

		PRINT @Server_Name

		---------------------------------------
		-- Retrieve DB File Size Information -- 
		---------------------------------------
		BEGIN TRY
			SET @SQL_Statement = N'SELECT * ' + N'FROM OPENROWSET (''SQLOLEDB'',''Server=' + @Server_Name + ';Trusted_Connection=Yes;'',''
								SELECT DISTINCT 
								@@servername as server_name,
								dovs.logical_volume_name AS VolumeName,
								dovs.volume_mount_point AS Drive,
								CONVERT(INT,dovs.available_bytes/1048576.0) AS FreeSpaceInMB,
								CONVERT(INT,dovs.total_bytes/1048576.0) AS TotalSpaceInMB,getdate()
								FROM sys.databases sd JOIN  sys.master_files mf ON sd.database_id = mf.database_id
														CROSS APPLY sys.dm_os_volume_stats(mf.database_id, mf.FILE_ID) dovs	'') '
			INSERT INTO #TempDBSize4
			EXECUTE sp_executesql @SQL_Statement

			INSERT INTO VP_DISK_SPACE
			SELECT * FROM #TempDBSize4
		--select count(*)/3,ServerName from VP_Growth_Rate
		--where ServerName = @Server_Name
		--group by ServerName

/*############################# FETCH NEXT SERVER FROM TABLE #################################################################*/
		END TRY

		BEGIN CATCH
			FETCH NEXT
			FROM Server_List
			INTO @Server_Name
			DELETE FROM #TempDBSize4
		END CATCH

		FETCH NEXT
		FROM Server_List
		INTO @Server_Name
		DELETE FROM #TempDBSize4
	END

	CLOSE Server_List

	DEALLOCATE Server_List

	DROP TABLE #TempDBSize4
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "VP_DB_FILE_LIST"
            Begin Extent = 
               Top = 145
               Left = 317
               Bottom = 275
               Right = 487
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "VP_DB_GROWTH"
            Begin Extent = 
               Top = 133
               Left = 689
               Bottom = 263
               Right = 859
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "VP_DB_SERVER_LIST"
            Begin Extent = 
               Top = 132
               Left = 70
               Bottom = 262
               Right = 257
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_DB_GROWTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_DB_GROWTH'
GO
USE [master]
GO
ALTER DATABASE [SQLPERF_VP] SET  READ_WRITE 
GO
