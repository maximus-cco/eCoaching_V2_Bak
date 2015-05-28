/*
eCoaching_Quality_Create(06).sql
Last Modified Date: 10/31/2014
Last Modified By: Susmitha Palacherla

Version 06: 
1.  Updated per SCR 13701 to insert new records based on VerintEvalID 
     Instead of  Journal ID and Submitter ID 
  

Version 05: 
1. Updated [EC].[sp_InsertInto_Coaching_Log_Quality] for Phase II 
   Modular approach related changes.


Version 04: 
1.  Updated per SCR 13054 to Import additional attribute VerintFormName
     Updated impacted tables to add new Column and Stored procedures
2.  Updated per SCR 13138 to insert new records based on Journal ID and Submitter ID 
     Instead of VerintEvalID

Version 03: 
1. Updated stored procedure [EC].[sp_Update_Coaching_Log_Quality]
   with actually implemented code from production.


Version 02: 
1. Updated per SCR 12963 to modify sp_InsertInto_Coaching_Log_Quality
to fetch @@rowcount on insert.

Version 01: 
Initial revision

Summary
Create/Alter Tables
1. Create Table [EC].[Quality_Coaching_Stage]
2. Create Table [EC].[Quality_Coaching_Fact]
3. Create Table [EC].[Quality_Coaching_Rejected]
4. Create Table [EC].[Quality_FileList]


Create/Alter Procedures
1. Create Procedure [EC].[sp_InsertInto_Coaching_Log_Quality] 
2. Create Procedure [EC].[ sp_Update_Coaching_Log_Quality] 
3. Create Procedure [EC].[ sp_Update_Quality_Fact] 
*/



***********************************************************************************
		Section 1 - Tables
***********************************************************************************

--1. Create Table [EC].[Quality_Coaching_Stage]
/****** Object:  Table [EC].[Quality_Coaching_Stage]    Script Date: 09/12/2013 15:53:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Quality_Coaching_Stage](
	[Eval_ID] [nvarchar](20) NULL,
	[Eval_Date] [datetime] NULL,
	[Eval_Site_ID] [int] NULL,
	[User_ID] [nvarchar](20) NULL,
	[User_EMPID] [nvarchar](20) NULL,
	[User_LANID] [nvarchar](30) NULL,
	[SUP_ID] [nvarchar](20) NULL,
	[SUP_EMPID] [nvarchar](20) NULL,
	[MGR_ID] [nvarchar](20) NULL,
	[MGR_EMPID] [nvarchar](20) NULL,
	[Journal_ID] [nvarchar](30) NULL,
	[Call_Date] [datetime] NULL,
	[Summary_CallerIssues] [nvarchar](max) NULL,
	[Coaching_Goal_Discussion] [nvarchar](4000) NULL,
	[CSE] [nvarchar](2) NULL,
	[Evaluator_ID] [nvarchar](20) NULL,
	[Program] [nvarchar](20) NULL,
	[Source] [nvarchar](30) NULL,
	[Oppor_Rein] [nvarchar](20) NULL,
	[Date_Inserted] [datetime] NULL,
                  [VerintFormName] [nvarchar) (50) NULL
) ON [PRIMARY]

GO



GO




**************************************************************************************************

--2. Create Table [EC].[Quality_Coaching_Fact]

/****** Object:  Table [EC].[Quality_Coaching_Fact]    Script Date: 09/12/2013 15:54:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Quality_Coaching_Fact](
	[Eval_ID] [nvarchar](20) NULL,
	[Eval_Date] [datetime] NULL,
	[Eval_Site_ID] [int] NULL,
	[User_ID] [nvarchar](20) NULL,
	[User_EMPID] [nvarchar](20) NULL,
	[User_LANID] [nvarchar](30) NULL,
	[SUP_ID] [nvarchar](20) NULL,
	[SUP_EMPID] [nvarchar](20) NULL,
	[MGR_ID] [nvarchar](20) NULL,
	[MGR_EMPID] [nvarchar](20) NULL,
	[Journal_ID] [nvarchar](30) NULL,
	[Call_Date] [datetime] NULL,
	[Summary_CallerIssues] [nvarchar](max) NULL,
	[Coaching_Goal_Discussion] [nvarchar](4000) NULL,
	[CSE] [nvarchar](2) NULL,
	[Evaluator_ID] [nvarchar](20) NULL,
	[Program] [nvarchar](20) NULL,
	[Source] [nvarchar](30) NULL,
	[Oppor_Rein] [nvarchar](20) NULL,
	[Date_Inserted] [datetime] NULL,
                  [VerintFormName] [nvarchar) (50) NULL
) ON [PRIMARY]

GO


**************************************************************************************************

--3. Create Table [EC].[Quality_Coaching_Rejected]

/****** Object:  Table [EC].[Quality_Coaching_Rejected]    Script Date: 09/12/2013 15:54:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Quality_Coaching_Rejected](
	[Eval_ID] [nvarchar](20) NULL,
	[Eval_Date] [datetime] NULL,
	[Eval_Site_ID] [int] NULL,
	[User_ID] [nvarchar](20) NULL,
	[User_EMPID] [nvarchar](20) NULL,
	[User_LANID] [nvarchar](30) NULL,
	[SUP_ID] [nvarchar](20) NULL,
	[SUP_EMPID] [nvarchar](20) NULL,
	[MGR_ID] [nvarchar](20) NULL,
	[MGR_EMPID] [nvarchar](20) NULL,
	[Journal_ID] [nvarchar](30) NULL,
	[Call_Date] [datetime] NULL,
	[Summary_CallerIssues] [nvarchar](max) NULL,
	[Coaching_Goal_Discussion] [nvarchar](4000) NULL,
	[CSE] [nvarchar](2) NULL,
	[Evaluator_ID] [nvarchar](20) NULL,
	[Program] [nvarchar](20) NULL,
	[Source] [nvarchar](30) NULL,
	[Oppor_Rein] [nvarchar](20) NULL,
	[Reject_reason] [nvarchar](40) NULL,
	[Date_Rejected] [datetime] NULL,
	[VerintFormName] [nvarchar) (50) NULL
) ON [PRIMARY]

GO


**************************************************************************************************

--4. Create Table [EC].[Quality_FileList]

/****** Object:  Table [EC].[Quality_FileList]   Script Date: 09/12/2013 15:54:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Quality_FileList](
	[File_SeqNum] [int] IDENTITY(1,1) NOT NULL,
	[File_Name] [nvarchar](260) NULL,
	[File_LoadDate] [datetime] NULL,
	[Count_Staged] [int] NULL,
	[Count_Loaded] [int] NULL,
	[Count_Rejected] [int] NULL
) ON [PRIMARY]

GO









***************************************************************************************************
		Section 2 - Procedures
****************************************************************************************************




-- 1. Create Procedure [EC].[sp_InsertInto_Coaching_Log_Quality] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Coaching_Log_Quality' 
)
   DROP  PROCEDURE [EC].[sp_InsertInto_Coaching_Log_Quality] 
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      02/23/2014
--    Description:     This procedure inserts the Quality scorecards into the Coaching_Log table. 
--                     The main attributes of the eCL are written to the Coaching_Log table.
--                     The Coaching Reasons are written to the Coaching_Reasons Table.
-- Last Modified Date: 10/31/2014
-- Last Updated By: Susmitha Palacherla
-- Modified to revert to using the Verint evalid as the unique identifier for loading new logs in the
-- Coaching table.
--    =====================================================================
CREATE PROCEDURE [EC].[sp_InsertInto_Coaching_Log_Quality]
@Count INT OUTPUT
  
AS
BEGIN

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY
      
      DECLARE @maxnumID INT
       -- Fetches the maximum CoachingID before the insert.
      SET @maxnumID = (SELECT IsNUll(MAX([CoachingID]), 0) FROM [EC].[Coaching_Log])    
      
      
      -- Inserts records from the Quality_Coaching_Stage table to the Coaching_Log Table

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
           ,[VerintID]
           ,[VerintEvalID]
           ,[Description]
	       ,[SubmittedDate]
           ,[StartDate]
           ,[isCSE]
           ,[isCSRAcknowledged]
           ,[VerintFormName]
           ,[ModuleID]
           )

            SELECT DISTINCT
            lower(csr.Emp_LanID)	[FormName],
            CASE qs.Program  
            WHEN NULL THEN csr.Emp_Program
            WHEN '' THEN csr.Emp_Program
            ELSE qs.Program  END       [ProgramName],
             211             [SourceID],
            [EC].[fn_strStatusIDFromIQSEvalID](qs.CSE, qs.Oppor_Rein )[StatusID],
            [EC].[fn_intSiteIDFromEmpID](LTRIM(qs.User_EMPID))[SiteID],
            lower(csr.Emp_LanID)	[EmpLanID],
            qs.User_EMPID [EmpID],
            qs.Evaluator_ID	 [SubmitterID],       
            qs.Call_Date [EventDate],
            0			[isAvokeID],
		    0			[isNGDActivityID],
            0			[isUCID],
            1 [isVerintID],
            qs.Journal_ID	[VerintID],
            qs.Eval_ID [VerintEvalID],
            EC.fn_nvcHtmlEncode(qs.Summary_CallerIssues)[Description],	
            GetDate()  [SubmittedDate], 
		    qs.Eval_Date	[StartDate],
		    CASE WHEN qs.CSE = '' THEN 0
	            	ELSE 1 END	[isCSE],			
		    0 [isCSRAcknowledged],
		    qs.VerintFormname [verintFormName],
		    1 [ModuleID]
FROM [EC].[Quality_Coaching_Stage] qs 
join EC.Employee_Hierarchy csr on qs.User_EMPID = csr.Emp_ID
left outer join EC.Coaching_Log cf on qs.Eval_ID = cf.VerintEvalID
where cf.VerintEvalID is null
OPTION (MAXDOP 1)

SELECT @Count =@@ROWCOUNT

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
           10,
           42,
           qs.[Oppor_Rein]
    FROM [EC].[Quality_Coaching_Stage] qs JOIN  [EC].[Coaching_Log] cf      
    ON qs.[Eval_ID] = cf.[VerintEvalID] 
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
END -- sp_InsertInto_Coaching_Log_Quality



GO

**********************************************************************************************************************

--2. Create Procedure [EC].[sp_Update_Coaching_Log_Quality] 


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update_Coaching_Log_Quality'
)
   DROP  PROCEDURE [EC].[sp_Update_Coaching_Log_Quality] 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      04/23/2014
--    Description:     This procedure updates the Quality scorecards into the Coaching_Log table. 
--                     The txtdescription is updated in the Coaching_Log table.
--                     The updated Oppor/Re-In value is updated in the Coaching_Reasons Table.
--
--    =====================================================================
CREATE PROCEDURE [EC].[sp_Update_Coaching_Log_Quality]
  
AS
BEGIN

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY
      
-- Update txtDescription for existing records

 UPDATE [EC].[Coaching_Log]
 SET [Description] = EC.fn_nvcHtmlEncode(S.[Summary_CallerIssues])
 FROM [EC].[Quality_Coaching_Stage]S INNER JOIN [EC].[Coaching_Log]F
 ON S.[Eval_ID] = F.[VerintEvalID]
 AND S.[Journal_ID] = F.[VerintID]
 WHERE F.[VerintEvalID] is NOT NULL
 OPTION (MAXDOP 1)       
           

WAITFOR DELAY '00:00:00:05'  -- Wait for 5 ms


 -- Update Oppor/Re-In value in Coaching_Log_reason table for each record updated in Coaching_log table.

 UPDATE [EC].[Coaching_Log_reason]
 SET  [Value]= S.[Oppor_Rein]        
 FROM [EC].[Quality_Coaching_Stage] S JOIN  [EC].[Coaching_Log] F 
    ON S.[Eval_ID] = F.[VerintEvalID]  JOIN  [EC].[Coaching_Log_Reason] R
    ON F.[CoachingID] = R.[CoachingID]  
    WHERE S.[Oppor_Rein] <> [Value]
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
END -- sp_Update_Coaching_Log_Quality



GO



**********************************************************************************************************************

--3. Create Procedure [EC].[sp_Update_Quality_Fact] 


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update_Quality_Fact'
)
   DROP  PROCEDURE [EC].[sp_Update_Quality_Fact] 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      05/14/2014
--    Description:     This procedure updates the existing records in the Quality Fact table
--                     and inserts new records.
--   Modified Date:    07/18/2014
--   Description:      Updated per SCR 13054 to add additional column VerintFormName.
--    =====================================================================
CREATE PROCEDURE [EC].[sp_Update_Quality_Fact]
  
AS
BEGIN

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY
      
-- Update existing records in quality Fact Table

 UPDATE [EC].[Quality_Coaching_Fact]
 SET [Summary_CallerIssues] = S.[Summary_CallerIssues],
     [Date_Inserted]=S.[Date_Inserted],
     [Oppor_Rein]= S.[Oppor_Rein]
 FROM [EC].[Quality_Coaching_Stage]S INNER JOIN [EC].[Quality_Coaching_Fact]F
 ON S.[Eval_ID] = F.[Eval_ID]
 AND S.[Journal_ID] = F.[Journal_ID]
 WHERE F.[Eval_ID] is NOT NULL
 OPTION (MAXDOP 1)       
           
        

WAITFOR DELAY '00:00:00:05'  -- Wait for 5 ms


 -- Append new records to Quality Fact Table

INSERT INTO [EC].[Quality_Coaching_Fact]
           ([Eval_ID]
           ,[Eval_Date]
           ,[Eval_Site_ID]
           ,[User_ID]
           ,[User_EMPID]
           ,[User_LANID]
           ,[SUP_ID]
           ,[SUP_EMPID]
           ,[MGR_ID]
           ,[MGR_EMPID]
           ,[Journal_ID]
           ,[Call_Date]
           ,[Summary_CallerIssues]
           ,[Coaching_Goal_Discussion]
           ,[CSE]
           ,[Evaluator_ID]
           ,[Program]
           ,[Source]
           ,[Oppor_Rein]
           ,[Date_Inserted]
           ,[VerintFormName])
     SELECT
       S.[Eval_ID]
      ,S.[Eval_Date]
      ,S.[Eval_Site_ID]
      ,S.[User_ID]
      ,S.[User_EMPID]
      ,S.[User_LANID]
      ,S.[SUP_ID]
      ,S.[SUP_EMPID]
      ,S.[MGR_ID]
      ,S.[MGR_EMPID]
      ,S.[Journal_ID]
      ,S.[Call_Date]
      ,S.[Summary_CallerIssues]
      ,S.[Coaching_Goal_Discussion]
      ,S.[CSE]
      ,S.[Evaluator_ID]
      ,S.[Program]
      ,S.[Source]
      ,S.[Oppor_Rein]
      ,S.[Date_Inserted]
      ,S.[VerintFormName]
      FROM
	[EC].[Quality_Coaching_Stage] S LEFT OUTER JOIN
	[EC].[Quality_Coaching_Fact] F ON 
	S.[Eval_ID] = F.[Eval_ID]
    WHERE(F.[Eval_ID] IS NULL) 

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
END -- sp_Update_Quality_Fact
GO








