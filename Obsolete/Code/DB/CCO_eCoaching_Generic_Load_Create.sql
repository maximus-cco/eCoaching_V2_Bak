/*
eCoaching_Generic_Create(03).sql
Last Modified Date:12/12/2016
Last Modified By: Susmitha Palacherla

Version 03: 12/12/2016
Changes to support ad-hoc generic feeds with variations by including attributes in the files- TFS 4916
Added additional columns to tables 1,3 and 4
Updated sp#1 to support the new mappings 

Version 02: 9/11/2016
Updated sp#1 to support ATT SEA feed per TFS 3972


Version 01: 4/11/2016
Initial Revision - TFS 2470 - Generic OTH Feed load setup


Summary

Tables
1. Create Table [EC].[Generic_Coaching_Stage] 
2. Create Table [EC].[Generic_FileList]  
3. Create Table [EC].[Generic_Coaching_Rejected]
4. Create Table [EC].[Generic_Coaching_Fact] 

Procedures
1. Create SP  [EC].[sp_InsertInto_Coaching_Log_Generic]  


*/


 --Details

**************************************************************
--Tables
**************************************************************

--1. Create Table [EC].[Generic_Coaching_Stage]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Generic_Coaching_Stage](
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
	[CSR_EMPID] [nvarchar](10) NULL,
	[CSR_Site] [nvarchar](20) NULL,
	[Program] [nvarchar](30) NULL,
	[CoachReason_Current_Coaching_Initiatives] [nvarchar](20) NULL,
	[TextDescription] [nvarchar](4000) NULL,
	[FileName] [nvarchar](260) NULL,
        [Module_ID] [int] NULL,
	[Source_ID] [int] NULL,
	[isCSE] [bit] NULL,
	[Status_ID] [int] NULL,
	[Submitter_ID] [nvarchar](10) NULL,
	[CoachingReason_ID] [int] NULL,
	[SubCoachingReason_ID] [int] NULL,
	[Value] [nvarchar](30) NULL,
	[EmailSent] [bit] NULL
            
) ON [PRIMARY]

GO



**************************************************************

--2. Create Table [EC].[Generic_FileList]


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Generic_FileList](
	[File_SeqNum] [int] IDENTITY(1,1) NOT NULL,
	[File_Name] [nvarchar](260) NULL,
	[File_LoadDate] [datetime] NULL,
	[Count_Staged] [int] NULL,
	[Count_Loaded] [int] NULL,
	[Count_Rejected] [int] NULL
) ON [PRIMARY]

GO




**************************************************************

--3. Create Table [EC].[Generic_Coaching_Rejected]


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Generic_Coaching_Rejected](
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
	[Module_ID] [int] NULL,
	[Source_ID] [int] NULL,
	[isCSE] [bit] NULL,
	[Status_ID] [int] NULL,
	[Submitter_ID] [nvarchar](10) NULL,
	[CoachingReason_ID] [int] NULL,
	[SubCoachingReason_ID] [int] NULL,
	[Value] [nvarchar](30) NULL,
	[CSR_EMPID] [nvarchar](10) NULL
              
) ON [PRIMARY]

GO



**************************************************************

--4. Create Table [EC].[Generic_Coaching_Fact]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Generic_Coaching_Fact](
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
	[CSR_EMPID] [nvarchar](10) NULL,
	[Module_ID] [int] NULL,
	[Source_ID] [int] NULL,
	[isCSE] [bit] NULL,
	[Status_ID] [int] NULL,
	[Submitter_ID] [nvarchar](10) NULL,
	[CoachingReason_ID] [int] NULL,
	[SubCoachingReason_ID] [int] NULL,
	[Value] [nvarchar](30) NULL

) ON [PRIMARY]

GO


**************************************************************

--Procedures

**************************************************************



--1. Create SP  [EC].[sp_InsertInto_Coaching_Log_Generic]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Coaching_Log_Generic' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_Coaching_Log_Generic]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		        Susmitha Palacherla
-- Create date:        4/11/2016
--  Created per TFS 2470 to load the Generic feed(s)- 4/11/2016
-- Modified to accomodate Attendance feed for seasonal employees per TFS 3972 - 09/15/2016
-- Modified to support ad-hoc loads by adding more values to the file. TFS 4916 -12/9/2016
-- =============================================
CREATE PROCEDURE [EC].[sp_InsertInto_Coaching_Log_Generic]
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
      
-- Inserts records from the Generic_Coaching_Stage table to the Coaching_Log Table

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
           ,[isVerified]
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
SELECT DISTINCT LOWER(cs.CSR_LANID)	[FormName],

CASE cs.Program  
        WHEN NULL THEN csr.Emp_Program
        WHEN '' THEN csr.Emp_Program
        ELSE cs.Program  
 END [ProgramName],
 
 CASE 
		WHEN cs.[Report_Code] like 'SEA%'
        THEN [EC].[fn_intSourceIDFromSource](cs.[Form_Type],cs.[Source])
        ELSE cs.Source_ID 
  END  [SourceID],
  
  CASE
        WHEN cs.[Report_Code] like 'SEA%'
        THEN [EC].[fn_strStatusIDFromStatus](cs.Form_Status)
        ELSE cs.Status_ID 
  END   [StatusID],
  
        [EC].[fn_intGetSiteIDFromLanID](cs.CSR_LANID,@dtmDate)[SiteID],
        LOWER(cs.CSR_LANID)				[EmpLanID],
        cs.CSR_EMPID                    [EmpID],
        
  CASE
        WHEN cs.[Report_Code] like 'SEA%'
        THEN [EC].[fn_nvcGetEmpIdFromLanId](LOWER(cs.Submitter_LANID),@dtmDate)
        ELSE cs.Submitter_ID
  END   [SubmitterID],
  
		cs.Event_Date			            [EventDate],
		 0			[isAvokeID],
		 0			[isNGDActivityID],
         0			[isUCID],
         0          [isVerintID],
		-- EC.fn_nvcHtmlEncode(cs.TextDescription)		[Description],
  CASE 
		 WHEN cs.[Report_Code] like 'SEA%' 
		 THEN REPLACE(EC.fn_nvcHtmlEncode(cs.TextDescription), '|'  ,'<br /> <br />')
		 WHEN  cs.[Report_Code] like 'OTH%'
		 THEN REPLACE(EC.fn_nvcHtmlEncode(cs.TextDescription), '|'  ,'<br />')
		 ELSE REPLACE(EC.fn_nvcHtmlEncode(cs.TextDescription), '      '  ,'<br />') 
  END [Description],	-- CHAR(13) + CHAR(10)
  
         1                          [isVerified],
		 cs.Submitted_Date			[SubmittedDate],
		 cs.Start_Date				[StartDate],
		 0        				    [isCSRAcknowledged],
CASE 
		 WHEN cs.[Report_Code] like 'SEA%'
		 THEN 0
		 ELSE cs.isCSE
  END                          [isCSE],
		 
  CASE 
		 WHEN cs.[Report_Code] like 'SEA%'
		 THEN 0
		 ELSE cs.EmailSent
  END	[EmailSent],
  
		 cs.Report_ID				[numReportID],
		 cs.Report_Code				[strReportCode],
		 
CASE 
		 WHEN cs.[Report_Code] like 'SEA%'
		 THEN 1
		 ELSE  cs.Module_ID
 END		                      [ModuleID],
  
  
		 ISNULL(csr.[Sup_ID],'999999')  [SupID],
		 ISNULL(csr.[Mgr_ID],'999999') [MgrID]
	                   
from [EC].[Generic_Coaching_Stage] cs  join EC.Employee_Hierarchy csr on cs.CSR_EMPID = csr.Emp_ID
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
    
 CASE 
		 WHEN cf.strReportCode like 'SEA%'
		 THEN 3
		 ELSE cs.CoachingReason_ID	
 END [CoachingReasonID],
 
 CASE 
		 WHEN cf.strReportCode like 'SEA%'				
         THEN [EC].[fn_intSubCoachReasonIDFromRptCode](SUBSTRING(cf.strReportCode,1,3))
         ELSE cs.SubCoachingReason_ID	
 END [SubCoachingReasonID],
 
  CASE 
		 WHEN cf.strReportCode like 'SEA%'		
         THEN  cs.[CoachReason_Current_Coaching_Initiatives]
         ELSE cs.Value 
 END [Value]
 
    FROM [EC].[Generic_Coaching_Stage] cs JOIN  [EC].[Coaching_Log] cf      
    ON cs.[Report_ID] = cf.[numReportID] AND  cs.[Report_Code] = cf.[strReportCode]
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
END -- sp_InsertInto_Coaching_Log_Generic



GO











--***************************************************************************************************


