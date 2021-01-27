USE [msdb]
GO

-------------------------------------------------------------------
-- Creates a job for generation of Credit Card Policy Acknowledgement ecls.
--		You must be logged in as ecljobowner!!
-------------------------------------------------------------------

-- IMPLEMENTER: Set environment here
DECLARE @environment nvarchar(5) = 'DEV'  -- DEV, TEST, UAT, or PROD
										

--=================================================================
-- IMPLEMENTER: Do not modify below this section
--=================================================================
DECLARE @knownServers AS TABLE (
	 ServerName nvarchar(128)
	,Environment nvarchar(10)
)
INSERT INTO @knownServers VALUES
 (N'F3420-ECLDBP01', N'PROD')
,(N'F3420-ECLDBT01', N'UAT') -- This will be a temporary test environment
,(N'F3420-ECLDBT01', N'TEST')
,(N'F3420-ECLDBD01', N'DEV')

IF NOT EXISTS (SELECT * FROM @knownServers WHERE ServerName = @@SERVERNAME AND Environment = @environment)
BEGIN
	DECLARE @error nvarchar(1000) = CONCAT('Unknown environment [', @environment, '] for current server.');
	THROW 51000, @error, 1;
END

SET @environment = UPPER(LTRIM(RTRIM(@environment)))
DECLARE @jobName nvarchar(100) =  N'CoachingCRDLoad'
DECLARE @jobNameStepBase nvarchar(120) = CONCAT(@jobName,N'--STEP_')
DECLARE @jobNameStep nvarchar(120)
DECLARE @mainJobId BINARY(16)


-- Declare some action codes to make things more readable
DECLARE @QUIT_REPORTING_SUCCESS int = 1 -- quit reporting success
DECLARE @QUIT_REPORTING_FAILURE int = 2 -- quit reporting failure
--DECLARE @GO_TO_NEXT_STEP int = 3 -- go to next step


-------------------------------------------------------------------
-- Delete the main job if it exists
BEGIN TRY
	IF EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = @jobName)
	BEGIN
		PRINT('... Deleting pre-existing version of main job ' + @jobName + '...')
		EXEC msdb.dbo.sp_delete_job @job_name = @jobName, @delete_unused_schedule=1
	END
END TRY
BEGIN CATCH
	PRINT('!! ERROR: Could not delete job ' + @jobName + '!!')
END CATCH


-------------------------------------------------------------------
-- Make sure job category exists
-------------------------------------------------------------------
BEGIN TRANSACTION
DECLARE @jobCategory nvarchar(50) = N'[Uncategorized (Local)]'
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
-- Object:  JobCategory [[Uncategorized (Local)]]
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=@jobCategory AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=@jobCategory
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

-------------------------------------------------------------------
-- Create the job itself
-------------------------------------------------------------------
DECLARE @jobOwner nvarchar(50) = N'ecljobowner'
DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=@jobName, 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Generates Credit Card Policy Acknowledgement eCLs.', 
		@category_name=@jobCategory, 
		@owner_login_name=@jobOwner, @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
SET @mainJobId = @jobId

------------------------------------------------------------------------------------
-- Configure proxy name and total steps
------------------------------------------------------------------------------------
DECLARE @proxyName nvarchar(50) = N'ECLProxy'

DECLARE @totalSteps int = 1
DECLARE @stepId int = 0
DECLARE @stepName nvarchar(100)
DECLARE @stepDescr nvarchar(500)
DECLARE @successAction int 
DECLARE @failureAction int 


-------------------------------------------------------------------
-- Object 1:  Step [Stage Logs for Upload]
-------------------------------------------------------------------
--------------------------------------------------------------------
-- Configure database and server names
------------------------------------------------------------------

DECLARE @dbName nvarchar(20) = 
			(SELECT CASE @environment WHEN 'PROD' THEN N'eCoaching'
									  WHEN 'UAT'  THEN N'eCoachingUAT'
									  WHEN 'TEST' THEN N'eCoachingTest'
									  ELSE N'eCoachingDev' END) -- Assume dev

DECLARE @serverName nvarchar(20) = 
			(SELECT CASE @environment WHEN 'PROD' THEN N'F3420-ECLDBP01'
									  WHEN 'UAT'  THEN N'F3420-ECLDBT01'
									  WHEN 'TEST' THEN N'F3420-ECLDBT01'
									  ELSE N'F3420-ECLDBD01' END) -- Assume dev

DECLARE @sqlCommand nvarchar(200) = N'SQLCMD -Q "EXEC ' + @dbName + N'.EC.sp_InsertInto_Coaching_Log_CRD" -E -S ' + @serverName
SET @stepName = N'Generate CRD Logs'
SET @stepDescr = N'Generates CRD Policy logs for CSRs and Quality Specialists.'
SET @jobId = @mainJobId
SET @stepId = @stepID + 1
SET @successAction = CASE @stepId WHEN @totalSteps THEN @QUIT_REPORTING_SUCCESS -- quit reporting success
								  ELSE @QUIT_REPORTING_FAILURE END -- go to next step
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
		@step_id=@stepId, 
		@cmdexec_success_code=0, 
		@on_success_action=@successAction,
		@on_success_step_id=0, 
		@on_fail_action=@QUIT_REPORTING_FAILURE, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=@sqlCommand,
		@database_name=N'master', 
		@flags=0, 
		@proxy_name=@proxyName
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

-------------------------------------------------------------------
-- Warn if there is a step count mismatch
-------------------------------------------------------------------
IF @stepId <> @totalSteps
BEGIN
	PRINT(CHAR(13) + '!! WARNING: Total steps mismatch. Last scripted step count: ' + CAST(@stepId AS nvarchar(5)) + '. Expected total steps: ' + CAST(@totalSteps AS nvarchar(5)) + CHAR(13));
END

-------------------------------------------------------------------
-- Add the job to the server
-------------------------------------------------------------------
SET @jobId = @mainJobId
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
PRINT('** Job creation for ' + @jobName + ' successful! **')
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
	PRINT('** FAILED to create job ' + @jobName + '. **')
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


