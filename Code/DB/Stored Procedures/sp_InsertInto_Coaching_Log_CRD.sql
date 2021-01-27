/*
sp_InsertInto_Coaching_Log_CRD(01).sql
Last Modified Date: 01/25/2021
Last Modified By: Susmitha Palacherla

*/


IF EXISTS (
  SELECT * 

    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Coaching_Log_CRD' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_Coaching_Log_CRD]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--    ====================================================================================
-- Author:		      Susmitha Palacherla
-- Create date:       01/15/2021
-- Description:	
-- Creates CCP ecls for eligible CSRs.
-- Last update by:   
-- Initial Revision - Created as part of TFS 19980 for one time load - 01/25/2021

--    ====================================================================================
CREATE PROCEDURE [EC].[sp_InsertInto_Coaching_Log_CRD]
AS
BEGIN

  SET NOCOUNT ON;
  SET XACT_ABORT ON;

  DECLARE @CurrDate datetime = GetDate();
  DECLARE @strReportCode  nvarchar(20) = N'CRD' + CONVERT(varchar(8), [EC].[fn_intDatetime_to_YYYYMMDD](@CurrDate));
  DECLARE @logsInserted TABLE ( CoachingLogID bigint );

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
    DescriptionTxt nvarchar(max),
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
       eh.Emp_ID --FormName
      ,eh.Emp_Program --Program
      ,210            --Training and Development
	  ,4   --Pending Employee Review
	  ,EC.fn_intSiteIDFromEmpID(LTRIM(RTRIM(eh.Emp_ID)))  -- SiteID
	  ,eh.Emp_ID     -- EmpID
	  ,'999999'           -- SubmitterID
	  ,DATEADD(dd, 0, DATEDIFF(dd, 0, @CurrDate))     -- EventDate
	  ,0                  -- isAvokeID
	  ,0                  -- isNGDActivityID
	  ,0                  -- isUCID
	  ,0                  -- isVerintID
	  ,NULL    -- VerintID
	  ,'Replace' -- Description
	  ,@CurrDate          -- SubmittedDate
	  ,DATEADD(dd, 0, DATEDIFF(dd, 0, @CurrDate))     -- StartDate
	  ,0                  -- isCSE
      ,0                  -- isCSRAcknowledged
	  ,[EC].[fn_intModuleIDFromEmpID](eh.Emp_ID) -- ModuleID
	  ,ISNULL(eh.Sup_ID, '999999')  -- SupID
	  ,ISNULL(eh.Mgr_ID, '999999')  -- MgrID
	  ,@strReportCode -- strReportCode
    FROM (SELECT [Emp_ID], [Emp_Site], [Emp_Job_Code], [Emp_Program], [Sup_ID], [Mgr_ID] 
	      FROM EC.Employee_Hierarchy WITH (NOLOCK)
		  WHERE Active = 'A' AND (Emp_Job_Code LIKE 'WACS0%' OR Emp_Job_Code LIKE 'WACQ0%' OR Emp_Job_Code LIKE 'WACQ1%')) eh
	LEFT JOIN (SELECT * FROM EC.Coaching_Log WITH (NOLOCK) WHERE SourceID = 210 AND strReportCode like 'CRD%') cl 
	ON eh.Emp_ID = cl.EmpID
    WHERE cl.EmpID IS NULL;

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
	  SET [FormName] = 'eCL-M-' + FormName + '-' + convert(varchar,CoachingID)
	  ,[Description] = 'When assisting our beneficiaries and consumers, NEVER ask for credit card numbers. CSRs should not attempt to help beneficiaries and consumers with credit card payments (or payments of any kind) – you must follow scripts.' + '<br />' + '<br />' +
'ALL calls are recorded. If you ask for credit card information, you will face disciplinary action, up to and including termination. If it is determined that credit card fraud has taken place, we will report it to the proper authorities.' + '<br />' + '<br />' +
'The following activities could be grounds for disciplinary action up to and including termination:' + '<br />' + '<br />' +
'1. Asking for credit card or bank information.'  + '<br />' +
'2. Attempting to process payments.' + '<br />' +
'3. Asking for a caller''s password.' + '<br />' + '<br />' +
'Important Reminder! Medicare and Marketplace representatives should never ask the beneficiary or consumer for credit card or bank account information. We never collect payments of any kind. 
 Refer to the Role of 1-800 Medicare CSR script (Medicare) and the Protecting Consumers'' Information script (Marketplace) for more information.' + '<br />' + '<br />' +
'If you have any questions, contact your supervisor, manager, or Human Resources representative.'
	  FROM @logsInserted 
	  WHERE strReportCode = @strReportCode
	  AND CoachingID IN (SELECT * FROM @logsInserted);

      -- Inserts records into Coaching_Log_reason table for each record inserted into Coaching_log table.
	  INSERT INTO EC.Coaching_Log_Reason
	  SELECT
	     cl.CoachingID
		,5            -- Current Coaching Initiative
		,42          -- Other: Specify reason under coaching details.
		,'Reinforcement'  -- Value
	  FROM EC.Coaching_Log cl LEFT JOIN EC.Coaching_Log_Reason clr
	  ON cl.CoachingID = clr.CoachingID
	  WHERE cl.strReportCode = @strReportCode
	  AND clr.CoachingID IS NULL ;
 
 
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
END -- sp_InsertInto_Coaching_Log_CCP

GO


