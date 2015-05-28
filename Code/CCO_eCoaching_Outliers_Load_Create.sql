/*
eCoaching_Outliers_Create(06).sql
Last Modified Date: 05/26/2015
Last Modified By: Susmitha Palacherla

Version 06: 05/26/2015
1. Updated table creates for #1,3 and 4 to add new col RMgr_ID
to support rotational mgr for LCSAT feed per SCR 14818.


Version 05: 05/25/2015
1. Updated [EC].[sp_InsertInto_Coaching_Log_Outlier]  
and [EC].[sp_InsertInto_Outlier_Rejected]per scr 14818
to support rotational mgr in LCSAT feeed.


Version 04: 12/19/2014
1. Updated [EC].[sp_InsertInto_Coaching_Log_Outlier]  per scr 13891
to store supid and mgrid at time of insert


Version 03: 08/29/2014
1. Updated [EC].[sp_InsertInto_Coaching_Log_Outlier]  for Phase II 
   Modular approach related changes.

Version 02: 07/22/2014
1. Updated per SCR 13213 to map the Coaching Reason ID for the Outlier logs to 9 ('OMR / Exceptions')

Version 01: 03/10/2014
Initial Revision.


Summary

Tables
1. Create Table [EC].[Outlier_Coaching_Stage] 
2. Create Table [EC].[OutLier_FileList]  
3. Create Table [EC].[Outlier_Coaching_Rejected]
4. Create Table [EC].[Outlier_Coaching_Fact] 

Procedures
1. Create SP  [EC].[sp_InsertInto_Coaching_Log_Outlier]  
2. Create SP [EC].[sp_InsertInto_Outlier_Rejected]

*/


 --Details

**************************************************************
--Tables
**************************************************************

--1. Create Table [EC].[Outlier_Coaching_Stage]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Outlier_Coaching_Stage](
	[Report_ID] [int] NULL,
	[Report_Code] [nvarchar](20) NULL,
	[Form_Type] [nvarchar](20) NULL,
	[Source] [nvarchar](60) NULL,
	[Form_Status] [nvarchar](30) NULL,
	[Event_Date] [datetime] NULL,
	[Submitted_Date] [datetime] NULL,
	[Start_Date] [datetime] NULL,
	[Submitter_LANID] [nvarchar](30) NULL,
	[Submitter_Name] [nvarchar](30) NULL,
	[Submitter_Email] [nvarchar](50) NULL,
	[CSR_LANID] [nvarchar](30) NULL,
	[CSR_EMPID] [nvarchar](20) NULL,
	[CSR_Site] [nvarchar](20) NULL,
	[Program] [nvarchar](30) NULL,
	[CoachReason_Current_Coaching_Initiatives] [nvarchar](20) NULL,
	[TextDescription] [nvarchar](3000) NULL,
	[FileName] [nvarchar](260) NULL,
                  [RMgr_ID] [nvarchar](20) NULL
) ON [PRIMARY]

GO



**************************************************************

--2. Create Table [EC].[OutLier_FileList]


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[OutLier_FileList](
	[File_SeqNum] [int] IDENTITY(1,1) NOT NULL,
	[File_Name] [nvarchar](260) NULL,
	[File_LoadDate] [datetime] NULL,
	[Count_Staged] [int] NULL,
	[Count_Loaded] [int] NULL,
	[Count_Rejected] [int] NULL
) ON [PRIMARY]

GO




**************************************************************

--3. Create Table [EC].[Outlier_Coaching_Rejected]

/****** Object:  Table [EC].[Outlier_Coaching_Rejected]    Script Date: 01/18/2014 13:31:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Outlier_Coaching_Rejected](
	[Report_ID] [int] NULL,
	[Report_Code] [nvarchar](20) NULL,
	[Form_Type] [nvarchar](20) NULL,
	[Source] [nvarchar](60) NULL,
	[Form_Status] [nvarchar](30) NULL,
	[Event_Date] [datetime] NULL,
	[Submitted_Date] [datetime] NULL,
	[Start_Date] [datetime] NULL,
	[Submitter_LANID] [nvarchar](30) NULL,
	[Submitter_Name] [nvarchar](30) NULL,
	[Submitter_Email] [nvarchar](50) NULL,
	[CSR_LANID] [nvarchar](30) NULL,
	[CSR_Site] [nvarchar](20) NULL,
	[Program] [nvarchar](30) NULL,
	[CoachReason_Current_Coaching_Initiatives] [nvarchar](20) NULL,
	[TextDescription] [nvarchar](3000) NULL,
	[FileName] [nvarchar](260) NULL,
	[Rejected_Reason] [nvarchar](200) NULL,
	[Rejected_Date] [datetime] NULL,
                  [RMgr_ID] [nvarchar](20) NULL
) ON [PRIMARY]

GO



**************************************************************

--4. Create Table [EC].[Outlier_Coaching_Fact]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Outlier_Coaching_Fact](
	[Report_ID] [int] NULL,
	[Report_Code] [nvarchar](20) NULL,
	[Form_Type] [nvarchar](20) NULL,
	[Source] [nvarchar](60) NULL,
	[Form_Status] [nvarchar](30) NULL,
	[Event_Date] [datetime] NULL,
	[Submitted_Date] [datetime] NULL,
	[Start_Date] [datetime] NULL,
	[Submitter_LANID] [nvarchar](30) NULL,
	[Submitter_Name] [nvarchar](30) NULL,
	[Submitter_Email] [nvarchar](50) NULL,
	[CSR_LANID] [nvarchar](30) NULL,
	[CSR_Site] [nvarchar](20) NULL,
	[Program] [nvarchar](30) NULL,
	[CoachReason_Current_Coaching_Initiatives] [nvarchar](20) NULL,
	[TextDescription] [nvarchar](3000) NULL,
	[FileName] [nvarchar](260) NULL,
                  [RMgr_ID] [nvarchar](20) NULL
) ON [PRIMARY]

GO


**************************************************************

--Procedures

**************************************************************

--1. Create SP  [EC].[sp_InsertInto_Coaching_Log_Outlier]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Coaching_Log_Outlier' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_Coaching_Log_Outlier]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		        Susmitha Palacherla
-- Create date:        03/10/2014
-- Loads records from [EC].[Outlier_Coaching_Stage]to [EC].[Coaching_Log]
-- Last Modified Date: 05/12/2015
-- Last Updated By: Susmitha Palacherla
-- Modified per SCR 14818 to support LCSAT feed.

-- =============================================
CREATE PROCEDURE [EC].[sp_InsertInto_Coaching_Log_Outlier]
AS
BEGIN

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY

      DECLARE @maxnumID INT,
              @dtmDate DATETIME,
              @strLCSPretext nvarchar(80)
      -- Fetches the maximum CoachingID before the insert.
      SET @maxnumID = (SELECT IsNUll(MAX([CoachingID]), 0) FROM [EC].[Coaching_Log])  
      -- Fetches the Date of the Insert
      SET @dtmDate  = GETDATE()   
      SET @strLCSPretext = 'The call associated with this Low CSAT is Verint ID: '
-- Inserts records from the Outlier_Coaching_Stage table to the Coaching_Log Table

 INSERT INTO [EC].[Coaching_Log]
           ([FormName]
           ,[ProgramName]
           ,[SourceID]
           ,[StatusID]
           ,[SiteID]
           ,[EmpLanID]
           ,[EmpID]
           ,[SubmitterID]
           ,[EventDate]
           ,[isAvokeID]
		   ,[isNGDActivityID]
           ,[isUCID]
           ,[isVerintID]
           ,[Description]
	       ,[SubmittedDate]
           ,[StartDate]
           ,[isCSRAcknowledged]
           ,[isCSE]
           ,[EmailSent]
           ,[numReportID]
           ,[strReportCode]
           ,[ModuleID]
           ,[SupID]
           ,[MgrID]
           )
select  Distinct LOWER(cs.CSR_LANID)	[FormName],
        CASE cs.Program  
        WHEN NULL THEN csr.Emp_Program
        WHEN '' THEN csr.Emp_Program
        ELSE cs.Program  END       [ProgramName],
        212                             [SourceID],
        [EC].[fn_strStatusIDFromStatus](cs.Form_Status)[StatusID],
        [EC].[fn_intGetSiteIDFromLanID](cs.CSR_LANID,@dtmDate)[SiteID],
        LOWER(cs.CSR_LANID)				[EmpLanID],
        cs.CSR_EMPID                    [EmpID],
        [EC].[fn_nvcGetEmpIdFromLanId](LOWER(cs.Submitter_LANID),@dtmDate)[SubmitterID],
		cs.Event_Date			            [EventDate],
		 0			[isAvokeID],
		 0			[isNGDActivityID],
         0			[isUCID],
         0          [isVerintID],
		 CASE WHEN cs.Report_Code LIKE 'LCS%' 
		 THEN @strLCSPretext + EC.fn_nvcHtmlEncode(cs.TextDescription)
		 ELSE  EC.fn_nvcHtmlEncode(cs.TextDescription)END		[Description],
	     cs.Submitted_Date			SubmittedDate,
		 cs.Start_Date				[StartDate],
		 0        				    [isCSRAcknowledged],
		 0                          [isCSE],
		 0                          [EmailSent],
		 cs.Report_ID				[numReportID],
		 cs.Report_Code				[strReportCode],
		 1							[ModuleID],
		 ISNULL(csr.[Sup_ID],'999999')  [SupID],
		 CASE WHEN cs.Report_Code LIKE 'LCS%' THEN ISNULL(cs.[RMgr_ID],'999999')
		 ELSE ISNULL(csr.[Mgr_ID],'999999')END  [MgrID]
	                   
from [EC].[Outlier_Coaching_Stage] cs  join EC.Employee_Hierarchy csr on cs.CSR_EMPID = csr.Emp_ID
left outer join EC.Coaching_Log cf on cs.Report_ID = cf.numReportID and cs.Report_Code = cf.strReportCode
where cf.numReportID is Null and cf.strReportCode is null


-- Updates the strFormID value

WAITFOR DELAY '00:00:00:05'  -- Wait for 5 ms

UPDATE [EC].[Coaching_Log]
SET [FormName] = 'eCL-'+[FormName] +'-'+ convert(varchar,CoachingID)
where [FormName] not like 'eCL%'    
OPTION (MAXDOP 1)

WAITFOR DELAY '00:00:00:05'  -- Wait for 5 ms

 -- Inserts records into Coaching_Log_reason table for each record inserted into Coaching_log table.


INSERT INTO [EC].[Coaching_Log_Reason]
           ([CoachingID]
           ,[CoachingReasonID]
           ,[SubCoachingReasonID]
           ,[Value])
    SELECT cf.[CoachingID],
           9,
           [EC].[fn_intSubCoachReasonIDFromRptCode](SUBSTRING(cf.strReportCode,1,3)),
           os.[CoachReason_Current_Coaching_Initiatives]
    FROM [EC].[Outlier_Coaching_Stage] os JOIN  [EC].[Coaching_Log] cf      
    ON os.[Report_ID] = cf.[numReportID] AND  os.[Report_Code] = cf.[strReportCode]
    LEFT OUTER JOIN  [EC].[Coaching_Log_Reason] cr
    ON cf.[CoachingID] = cr.[CoachingID]  
    WHERE cr.[CoachingID] IS NULL 
 OPTION (MAXDOP 1)   
 
                  
COMMIT TRANSACTION
END TRY

      
      BEGIN CATCH
      IF @@TRANCOUNT > 0
      ROLLBACK TRANSACTION


    DECLARE @ErrorMessage NVARCHAR(4000)
    DECLARE @ErrorSeverity INT
    DECLARE @ErrorState INT

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE()

    RAISERROR (@ErrorMessage, -- Message text.
               @ErrorSeverity, -- Severity.
               @ErrorState -- State.
               )
      
    IF ERROR_NUMBER() IS NULL
      RETURN 1
    ELSE IF ERROR_NUMBER() <> 0 
      RETURN ERROR_NUMBER()
    ELSE
      RETURN 1
  END CATCH  
END -- sp_InsertInto_Coaching_Log_Outlier

GO











***************************************************************************************************

--2. Create SP   [EC].[sp_InsertInto_Outlier_Rejected]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Outlier_Rejected' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_Outlier_Rejected]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		        Susmitha Palacherla
-- Create date:         01/15/2014
-- Description:	 
-- Loads all records from [EC].[Outlier_Coaching_Stage]Table
-- that dont have a corresponding CSR Lanid in the Employee_Hierarchy table
-- Into the Outliers rejected Table.
-- Last Modified Date: 05/12/2015
-- Last Updated By: Susmitha Palacherla
-- Modified per SCR 14818 to support LCSAT feed.
-- =============================================
CREATE PROCEDURE [EC].[sp_InsertInto_Outlier_Rejected]
AS
BEGIN

-- Inserts records from the Outlier_Coaching_Stage table to the Outlier_Rejected table.

INSERT INTO [EC].[Outlier_Coaching_Rejected]
           ([Report_ID]
           ,[Report_Code]
           ,[Form_Type]
           ,[Source]
           ,[Form_Status]
           ,[Event_Date]
           ,[Submitted_Date]
           ,[Start_Date]
           ,[Submitter_LANID]
           ,[Submitter_Name]
           ,[Submitter_Email]
           ,[CSR_LANID]
           ,[CSR_Site]
           ,[CoachReason_Current_Coaching_Initiatives]
           ,[TextDescription]
           ,[FileName]
           ,[Rejected_Reason]
           ,[Rejected_Date]
           ,[RMgr_ID])
 SELECT S.[Report_ID]
      ,S.[Report_Code]
      ,S.[Form_Type]
      ,S.[Source]
      ,S.[Form_Status]
      ,S.[Event_Date]
      ,S.[Submitted_Date]
      ,S.[Start_Date]
      ,S.[Submitter_LANID]
      ,S.[Submitter_Name]
      ,S.[Submitter_Email]
      ,S.[CSR_LANID]
      ,S.[CSR_Site]
      ,S.[CoachReason_Current_Coaching_Initiatives]
      ,S.[TextDescription]
      ,S.[FileName]
      ,'CSR_LANID not found in Hierarchy Table'
      ,GETDATE()
      ,S.RMgr_ID
  FROM [EC].[Outlier_Coaching_Stage]S left outer join [EC].[Outlier_Coaching_Rejected] R 
  ON S.Report_ID = R.Report_ID and S.Report_Code = R.Report_Code and S.CSR_LANID = R.CSR_LANID
  LEFT OUTER JOIN EC.[Employee_Hierarchy]H
  ON S.CSR_LANID = H.Emp_LanID
  WHERE H.Emp_LanID is NULL 
  AND R.Report_ID is NULL and R.Report_Code  is NULL and  R.CSR_LANID is NULL
	                   

END -- sp_InsertInto_Outlier_Rejected
GO





