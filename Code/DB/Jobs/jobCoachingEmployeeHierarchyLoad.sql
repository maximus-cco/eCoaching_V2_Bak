USE [msdb]
GO

-------------------------------------------------------------------
-- Creates the CoachingTrainingLoad job for the desired environment
--		You must be logged in as ecljobowner!!
-------------------------------------------------------------------

-- IMPLEMENTER: Set environment here
DECLARE @environment nvarchar(5) = N'PROD'  -- DEV, TEST, or PROD

--=================================================================
-- Do not modify below this section
--=================================================================
IF ((@@SERVERNAME = 'UVAADADSQL50CCO' AND @environment <> 'DEV')
        OR (@@SERVERNAME = 'UVAADADSQL52CCO' AND @environment <> 'TEST')
	OR (@@SERVERNAME = 'UVAAPADSQL50CCO' AND @environment <> 'PROD')
    )
BEGIN
	DECLARE @error nvarchar(1000) = CONCAT('Unknown environment [', @environment, '] for current server.');
	THROW 51000, @error, 1;
END

SET @environment = UPPER(LTRIM(RTRIM(@environment)))
--DECLARE @currJobId binary(16)
DECLARE @jobName nvarchar(100) = N'CoachingEmployeeHierarchyLoad'
DECLARE @configfileName nvarchar(100) = CONCAT(@environment + N'_', N'Employee_Hierarchy.dtsConfig')
DECLARE @jobNameStepBase nvarchar(120) = CONCAT(@jobName,N'--STEP_')
DECLARE @jobNameStep nvarchar(120)
DECLARE @mainJobId BINARY(16)
DECLARE @stepJobId BINARY(16)

-------------------------------------------------------------------
BEGIN TRY
    EXEC msdb.dbo.sp_delete_job @job_name = @jobName, @delete_unused_schedule=1
END TRY
BEGIN CATCH
	PRINT('WARNING: Could not delete job ' + @jobName + '. Job may not exist.')
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
		@description=N'Load Employee Hierarchy.', 
		@category_name=@jobCategory, 
		@owner_login_name=@jobOwner, @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
SET @mainJobId = @jobId

-------------------------------------------------------------------
-- Configure paths and total steps
-------------------------------------------------------------------
DECLARE @proxyName nvarchar(50) = N'ECLProxy'
DECLARE @packagePath nvarchar(1000) = 
			(SELECT CASE @environment WHEN 'PROD' THEN N'\\UVAAPADSQL50CCO\SSIS\Coaching\Packages\'
									  WHEN 'TEST' THEN N'\\UVAADADSQL52CCO\SSIS\Coaching\Packages\Employee_Hierarchy\' 
									  ELSE N'\\UVAADADSQL50CCO\SSIS\Coaching\Packages\Employee_Hierarchy\' END) -- Assume dev

DECLARE @configfilePath nvarchar(1000) = 
			(SELECT CASE @environment WHEN 'PROD' THEN N'H:\SSIS\Coaching\ConfigFiles\'
									  WHEN 'TEST' THEN N'I:\SSIS\Coaching\ConfigFiles\'
									  ELSE N'G:\SSIS\Coaching\ConfigFiles\' END) -- Assume dev



DECLARE @totalSteps int = (SELECT CASE @environment WHEN 'PROD' THEN 1 ELSE 2 END) -- update email addresses to test distro in all environments except prod
DECLARE @stepId int = 0
DECLARE @successAction int = 3 -- go to next step

-------------------------------------------------------------------
-- Object 1:  Step [Employee Hierarchy Load]
-------------------------------------------------------------------
DECLARE @packageCommand nvarchar(4000) = N'/FILE "' + @packagePath + N'Employee_Hierarchy.dtsx" /CONFIGFILE "' + @configfilePath + @configfileName +'"  /CHECKPOINTING OFF  /REPORTING E'
DECLARE @stepName nvarchar(100) 
SET @jobId = @mainJobId
SET @stepId = @stepID + 1
SET @stepName =  N'Load Hierarchy'
SET @successAction = CASE @stepId WHEN @totalSteps THEN 1 -- quit reporting success
								  ELSE 3 END -- go to next step
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
		@step_id=@stepId, 
		@cmdexec_success_code=0, 
		@on_success_action=@successAction,
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'SSIS', 
		@command=@packageCommand,
		@database_name=N'master', 
		@flags=0, 
		@proxy_name=@proxyName
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

-------------------------------------------------------------------
-- Object 2:  Step [Update email addresses in non prod environments]
-------------------------------------------------------------------

IF @environment  <> N'PROD'
BEGIN
DECLARE @sqlCommand nvarchar(4000) = (SELECT CASE @environment WHEN 'UAT' THEN N'SQLCMD -Q"EXEC eCoachingUAT.EC.sp_Update_Email_Addresses_DevTest" -E -S UVAADADSQL52CCO'
									  WHEN 'TEST' THEN N'SQLCMD -Q"EXEC eCoachingTest.EC.sp_Update_Email_Addresses_DevTest" -E -S UVAADADSQL52CCO'
									  ELSE N'SQLCMD -Q"EXEC eCoachingDev.EC.sp_Update_Email_Addresses_DevTest" -E -S UVAADADSQL50CCO' END) -- Assume dev
SET @jobId = @mainJobId
SET @stepName =  N'Update Email Addresses'
SET @stepId = @stepID + 1
SET @successAction = CASE @stepId WHEN @totalSteps THEN 1 -- quit reporting success
								  ELSE 3 END -- go to next step
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
		@step_id=@stepId, 
		@cmdexec_success_code=0, 
		@on_success_action=@successAction,
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=@sqlCommand,
		@database_name=N'master', 
		@flags=0, 
		@proxy_name=@proxyName
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback		
END;
-------------------------------------------------------------------
-- Schedule the job (generally only enabled for prod)
-------------------------------------------------------------------
SET @jobId = @mainJobId
DECLARE @isEnabled bit = (SELECT CASE @environment WHEN 'PROD' THEN 1 ELSE 0 END)
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Daily', 
		@enabled= 0, 
		@freq_type=4, --Daily
		@freq_interval=1, -- Every Day
		@freq_subday_type=1, -- at specified time
		@freq_subday_interval=0, -- N/A
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20210423, -- May 2nd 2019
		@active_end_date=99991231, -- No end date
		@active_start_time=110000, -- 11:00 AM server time (MT)
		@active_end_time=235959 --11:59:59
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

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


