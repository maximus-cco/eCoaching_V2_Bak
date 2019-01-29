/*
sp_InsertInto_Coaching_Log_NPN(04).sql
Last Modified Date: 1/15/2019
Last Modified By: Susmitha Palacherla

Version 04: Modified to decrease coaching_log table locking time TFS 13282 - 1/15/2019
Version 03: Modified to support Encryption of sensitive data. Removed LanID - TFS 7856 - 10/23/2017
Version 02: Additional update from V&V feedback - TFS 5653 - 03/02/2017
Version 01: Document Initial Revision - TFS 5653 - 2/28/2017
*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Coaching_Log_NPN' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_Coaching_Log_NPN]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--    ====================================================================================
-- Author:		      Susmitha Palacherla
-- Create date:       02/28/2017
-- Description:	
-- Creates NPN ecls for eligible IQS logs that have been identified and staged.
-- Last update by:   Susmitha Palacherla
-- Initial Revision - Created as part of  TFS 5653 - 02/28/2017
-- Modified to support Encryption of sensitive data. Removed LanID. TFS 7856 - 10/23/2017
-- Modified to decrease coaching_log table locking time TFS 13282- 1/15/2019
--    ====================================================================================
CREATE PROCEDURE [EC].[sp_InsertInto_Coaching_Log_NPN]
AS
BEGIN

  SET NOCOUNT ON;
  SET XACT_ABORT ON;

  DECLARE @maxnumID INT;
  DECLARE @logsInserted TABLE ( CoachingLogID bigint );

  -- Fetches the maximum CoachingID before the insert.
  SET @maxnumID = (SELECT IsNUll(MAX([CoachingID]), 0) FROM [EC].[Coaching_Log]);

  CREATE TABLE #Temp_Logs_To_Insert (
    FormName nvarchar(50),
	ProgramName nvarchar(50),
	SourceID int,
	StatusID int,
	SiteID int,
	EmpID nvarchar(10),
	SubmitterID nvarchar(10),
	EventDate datetime,
	isAvokeID bit,
	isNGDActivityID bit,
	isUCID bit,
	isVerintID bit,
	VerintID nvarchar(40),
	[Description] nvarchar(max),
	SubmittedDate datetime,
	StartDate datetime,
	isCSE bit,
	isCSRAcknowledged bit,
	ModuleID int,
	SupID nvarchar(20),
	MgrID nvarchar(20),
	strRptCode nvarchar(30)
  );

  BEGIN TRY
    
	INSERT INTO #Temp_Logs_To_Insert
    SELECT DISTINCT 
       User_EMPID
      ,CASE qcs.Program
         WHEN NULL THEN eh.Emp_Program
	     WHEN '' THEN eh.Emp_Program
	     ELSE qcs.Program
	   END ProgramName
      ,218                -- SourceID
	  ,6                  -- StatusID
	  ,EC.fn_intSiteIDFromEmpID(LTRIM(RTRIM(qcs.User_EMPID)))  -- SiteID
	  ,qcs.User_EMPID     -- EmpID
	  ,'999999'           -- SubmitterID
	  ,qcs.Call_Date      -- EventDate
	  ,0                  -- isAvokeID
	  ,0                  -- isNGDActivityID
	  ,0                  -- isUCID
	  ,1                  -- isVerintID
	  ,qcs.Journal_ID     -- VerintID
	  ,REPLACE(EC.fn_nvcHtmlEncode([EC].[fn_strNPNDescriptionFromCode](qs.[Summary_CallerIssues])), CHAR(13) + CHAR(10), '<br />') + qs.Journal_ID [Description] -- Description
	  ,GetDate()          -- SubmittedDate
	  ,qcs.Call_Date      -- StartDate
	  ,0                  -- isCSE
      ,0                  -- isCSRAcknowledged
	  ,1                  -- ModuleID
	  ,ISNULL(qcs.Sup_ID, '999999')  -- SupID
	  ,ISNULL(qcs.Mgr_ID, '999999')  -- MgrID
	  ,'NPN' + CONVERT(varchar(8), [EC].[fn_intDatetime_to_YYYYMMDD](GETDATE())) -- strReportCode
    FROM EC.Quality_Coaching_Stage qcs 
    JOIN EC.Employee_Hierarchy eh WITH (NOLOCK) ON qcs.User_EMPID = eh.Emp_ID
	LEFT JOIN (SELECT * FROM EC.Coaching_Log WITH (NOLOCK) WHERE SourceID = 218) cl 
	ON qcs.Journal_ID = cl.VerintID AND qcs.User_EMPID = cl.EmpID AND qcs.Call_Date = cl.EventDate
    WHERE cl.VerintID IS NULL 
	  AND cl.EmpID IS NULL 
	  AND cl.EventDate IS NULL;

	BEGIN TRANSACTION
      -- Insert into coaching log table
	  INSERT INTO EC.Coaching_Log  (
	     FormName
        ,ProgramName
        ,SourceID
        ,StatusID
        ,SiteID
        ,EmpID
        ,SubmitterID
        ,EventDate
        ,isAvokeID
        ,isNGDActivityID
        ,isUCID
        ,isVerintID
        ,VerintID
        ,[Description]
        ,SubmittedDate
        ,StartDate
        ,isCSE
        ,isCSRAcknowledged
        ,ModuleID
        ,SupID
        ,MgrID
		,strReportCode)
      OUTPUT INSERTED.[CoachingID] INTO @logsInserted
	  SELECT * 
	  FROM #Temp_Logs_To_Insert;

      -- Update formname for the inserted logs
	  UPDATE EC.Coaching_Log 
	  SET FormName = 'eCL-' + FormName + '-' + convert(varchar,CoachingID)
	  FROM @logsInserted 
	  WHERE CoachingID IN (SELECT * FROM @logsInserted);

      -- Inserts records into Coaching_Log_reason table for each record inserted into Coaching_log table.
	  INSERT INTO EC.Coaching_Log_Reason
	  SELECT
	     CoachingLogID
		,5              -- CoachingReasonID
		,42             -- SubCoachingReasonID
		,'Opportunity'  -- Value
	  FROM @logsInserted;
 
     -- Truncate Staging Table
      Truncate Table EC.Quality_Coaching_Stage
	
	COMMIT TRANSACTION
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
	
    DECLARE @ErrorMessage nvarchar(4000), @ErrorSeverity int, @ErrorState int;
    SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
      
    IF ERROR_NUMBER() IS NULL RETURN 1
    ELSE IF ERROR_NUMBER() <> 0 RETURN ERROR_NUMBER() 
    ELSE RETURN 1
  END CATCH  
END -- sp_InsertInto_Coaching_Log_NPN


GO


