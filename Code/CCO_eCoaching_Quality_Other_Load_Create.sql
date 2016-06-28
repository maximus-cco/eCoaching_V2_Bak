/*
eCoaching_Quality_Other_Create(01).sql
Last Modified Date: 6/28/2016
Last Modified By: Susmitha Palacherla



Version 01:6/28/2016
Initial Revision - TFS 2268 - CTC Feed load setup


Summary

Tables
1.[EC].[Quality_Other_Coaching_Stage]
2.[EC].[Quality_Other_Coaching_Rejected]
3.[EC].[Quality_Other_Coaching_Fact]
4.[EC].[Quality_Other_FileList]

Procedures
1.[EC].[sp_InsertInto_Coaching_Log_Quality_Other]


*/


 --Details

**************************************************************
--Tables
**************************************************************

--1. Create Table [EC].[Quality_Other_Coaching_Stage]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Quality_Other_Coaching_Stage](
	[Report_ID] [int] NULL,
	[Report_Code] [nvarchar](20) NULL,
	[Form_Type] [nvarchar](20) NULL,
	[Source] [nvarchar](60) NULL,
	[Form_Status] [nvarchar](50) NULL,
	[Event_Date] [datetime] NULL,
	[Submitted_Date] [datetime] NULL,
	[Start_Date] [datetime] NULL,
	[Submitter_ID] [nvarchar](10) NULL,
	[Submitter_LANID] [nvarchar](30) NULL,
	[Submitter_Email] [nvarchar](50) NULL,
	[EMP_ID] [nvarchar](10) NULL,
	[EMP_LANID] [nvarchar](30) NULL,
	[EMP_Site] [nvarchar](30) NULL,
	[Program] [nvarchar](30) NULL,
	[CoachReason_Current_Coaching_Initiatives] [nvarchar](20) NULL,
	[TextDescription] [nvarchar](4000) NULL,
	[FileName] [nvarchar](260) NULL
) ON [PRIMARY]

GO




--************************************


--2. Create Table [EC].[Quality_Other_Coaching_Rejected]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Quality_Other_Coaching_Rejected](
	[Report_ID] [int] NULL,
	[Report_Code] [nvarchar](20) NULL,
	[Form_Type] [nvarchar](20) NULL,
	[Source] [nvarchar](60) NULL,
	[Form_Status] [nvarchar](50) NULL,
	[Event_Date] [datetime] NULL,
	[Submitted_Date] [datetime] NULL,
	[Start_Date] [datetime] NULL,
	[Submitter_ID] [nvarchar](10) NULL,
	[Submitter_LANID] [nvarchar](30) NULL,
	[Submitter_Email] [nvarchar](50) NULL,
	[EMP_ID] [nvarchar](10) NULL,
	[EMP_LANID] [nvarchar](30) NULL,
	[EMP_Site] [nvarchar](30) NULL,
	[Program] [nvarchar](30) NULL,
	[CoachReason_Current_Coaching_Initiatives] [nvarchar](20) NULL,
	[TextDescription] [nvarchar](4000) NULL,
	[FileName] [nvarchar](260) NULL,
	[Rejected_Reason] [nvarchar](200) NULL,
	[Rejected_Date] [datetime] NULL
) ON [PRIMARY]

GO




--************************************


--3. Create Table [EC].[Quality_Other_Coaching_Fact]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Quality_Other_Coaching_Fact](
	[Report_ID] [int] NULL,
	[Report_Code] [nvarchar](20) NULL,
	[Form_Type] [nvarchar](20) NULL,
	[Source] [nvarchar](60) NULL,
	[Form_Status] [nvarchar](50) NULL,
	[Event_Date] [datetime] NULL,
	[Submitted_Date] [datetime] NULL,
	[Start_Date] [datetime] NULL,
	[Submitter_ID] [nvarchar](10) NULL,
	[Submitter_LANID] [nvarchar](30) NULL,
	[Submitter_Email] [nvarchar](50) NULL,
	[EMP_ID] [nvarchar](10) NULL,
	[EMP_LANID] [nvarchar](30) NULL,
	[EMP_Site] [nvarchar](30) NULL,
	[Program] [nvarchar](30) NULL,
	[CoachReason_Current_Coaching_Initiatives] [nvarchar](20) NULL,
	[TextDescription] [nvarchar](4000) NULL,
	[FileName] [nvarchar](260) NULL
) ON [PRIMARY]

GO


--************************************


--4. Create Table [EC].[Quality_Other_FileList]


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Quality_Other_FileList](
	[File_SeqNum] [int] IDENTITY(1,1) NOT NULL,
	[File_Name] [nvarchar](260) NULL,
	[File_LoadDate] [datetime] NULL,
	[Count_Staged] [int] NULL,
	[Count_Loaded] [int] NULL,
	[Count_Rejected] [int] NULL
) ON [PRIMARY]

GO









/**********************************************************************************



**************************************************************

--Procedures

**************************************************************/


--1. PROCEDURE [EC].[sp_InsertInto_Coaching_Log_Quality_Other]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Coaching_Log_Quality_Other' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_Coaching_Log_Quality_Other]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:		        Susmitha Palacherla
-- Create date:        6/15/2016
--  Created per TFS 2268 during setup of CTC Load
-- =============================================
CREATE PROCEDURE [EC].[sp_InsertInto_Coaching_Log_Quality_Other]
AS
BEGIN

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY

      DECLARE @maxnumID INT,
              @dtmDate DATETIME
                        
      -- Fetches the maximum CoachingID before the insert.
      SET @maxnumID = (SELECT IsNULL(MAX([CoachingID]), 0) FROM [EC].[Coaching_Log])  
      -- Fetches the Date of the Insert
      SET @dtmDate  = GETDATE()   
      
-- Inserts records from the Quality_Other_Coaching_Stage table to the Coaching_Log Table

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
select  Distinct LOWER(cs.EMP_LANID)	[FormName],
        CASE cs.Program  
        WHEN NULL THEN csr.Emp_Program
        WHEN '' THEN csr.Emp_Program
        ELSE cs.Program  END       [ProgramName],
        [EC].[fn_intSourceIDFromSource](cs.[Form_Type],cs.[Source])[SourceID],
        [EC].[fn_strStatusIDFromStatus](cs.Form_Status)[StatusID],
        [EC].[fn_intGetSiteIDFromLanID](cs.EMP_LANID,@dtmDate)[SiteID],
        LOWER(cs.EMP_LANID)				[EmpLanID],
        cs.[EMP_ID]                   [EmpID],
        cs.[Submitter_ID]              [Submitter_ID],
		cs.Event_Date			            [EventDate],
		 0			[isAvokeID],
		 0			[isNGDActivityID],
         0			[isUCID],
         0          [isVerintID],
		-- EC.fn_nvcHtmlEncode(cs.TextDescription)		[Description],
		 REPLACE(EC.fn_nvcHtmlEncode(cs.TextDescription), '      '  ,'<br />')[Description],	
		 cs.Submitted_Date			SubmittedDate,
		 cs.Event_Date				[StartDate],
		 0        				    [isCSRAcknowledged],
		 0                          [isCSE],
		 0                          [EmailSent],
		 cs.Report_ID				[numReportID],
		 cs.Report_Code				[strReportCode],
		 2							[ModuleID],
		 ISNULL(csr.[Sup_ID],'999999')  [SupID],
		 ISNULL(csr.[Mgr_ID],'999999') [MgrID]
	                   
from [EC].[Quality_Other_Coaching_Stage] cs  join EC.Employee_Hierarchy csr on cs.[EMP_ID] = csr.Emp_ID
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
           CASE WHEN cf.strReportCode like 'CTC%'
           THEN 21 ELSE 14 END,
           [EC].[fn_intSubCoachReasonIDFromRptCode](SUBSTRING(cf.strReportCode,1,3)),
           qs.[CoachReason_Current_Coaching_Initiatives]
    FROM [EC].[Quality_Other_Coaching_Stage] qs JOIN  [EC].[Coaching_Log] cf      
    ON qs.[Report_ID] = cf.[numReportID] AND  qs.[Report_Code] = cf.[strReportCode]
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
END -- sp_InsertInto_Coaching_Log_Quality_Other






GO







--***************************************************************************************************


