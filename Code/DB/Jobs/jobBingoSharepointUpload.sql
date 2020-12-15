USE [msdb]
GO

-------------------------------------------------------------------
-- Creates the Bingo Upload to Sharepoint job for the desired eCL environment
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
DECLARE @jobName nvarchar(100) =  N'CoachingSharepointUploadBingo'
DECLARE @jobNameStepBase nvarchar(120) = CONCAT(@jobName,N'--STEP_')
DECLARE @jobNameStep nvarchar(120)
DECLARE @mainJobId BINARY(16)
DECLARE @stepJobId BINARY(16)

-- Declare some action codes to make things more readable
DECLARE @QUIT_REPORTING_SUCCESS int = 1 -- quit reporting success
DECLARE @QUIT_REPORTING_FAILURE int = 2 -- quit reporting failure
DECLARE @GO_TO_NEXT_STEP int = 3 -- go to next step


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
-- Delete any child jobs that may exist
DECLARE @childJobId uniqueidentifier, @childJobName nvarchar(250)

DECLARE jobCursor CURSOR FOR
	SELECT job_id, name
	FROM msdb.dbo.sysjobs_view
	WHERE owner_sid = SUSER_SID() AND name LIKE CONCAT(@jobNameStepBase,N'%')
	ORDER BY name;

OPEN jobCursor;  
FETCH NEXT FROM jobCursor INTO @childJobId, @childJobName;
WHILE @@FETCH_STATUS = 0  
BEGIN
	BEGIN TRY
		PRINT('... Deleting pre-existing version of individal step job ' + @childJobName + '...')
		EXEC msdb.dbo.sp_delete_job @job_id = @childJobId, @delete_unused_schedule=1
	END TRY
	BEGIN CATCH
		PRINT('!! ERROR: Could not delete job ' + @childJobName + '!!')
	END CATCH

	FETCH NEXT FROM jobCursor INTO @childJobId, @childJobName;
END;  
CLOSE jobCursor;  
DEALLOCATE jobCursor;  


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
		@description=N'Uploads Bingo data to Sharepoint.', 
		@category_name=@jobCategory, 
		@owner_login_name=@jobOwner, @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
SET @mainJobId = @jobId

------------------------------------------------------------------------------------
-- Configure proxy name and total steps
------------------------------------------------------------------------------------
DECLARE @proxyName nvarchar(50) = N'ECLProxy'

DECLARE @totalSteps int = 12
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

DECLARE @sqlCommand nvarchar(200) = N'SQLCMD -Q "EXEC ' + @dbName + N'.EC.sp_Sharepoint_Upload_Bingo_Init" -E -S ' + @serverName
SET @stepName = N'Stage Logs for Upload'
SET @stepDescr = N'Selects logs for Upload and Inserts to a staging table for tracking.'
SET @jobId = @mainJobId
SET @stepId = @stepID + 1
SET @successAction = CASE @stepId WHEN @totalSteps THEN @QUIT_REPORTING_SUCCESS -- quit reporting success
								  ELSE @GO_TO_NEXT_STEP END -- go to next step
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

		-- Create a separate single-step job with this step
		SET @jobId = NULL
		SET @jobNameStep = CONCAT(@jobNameStepBase,RIGHT(N'00' + CAST(@stepId AS nvarchar(10)),2),' (Stage Logs for Upload)')

		-------------------------------------------------------------------
		--BEGIN TRY
		--	EXEC msdb.dbo.sp_delete_job @job_name = @jobNameStep, @delete_unused_schedule=1
		--END TRY
		--BEGIN CATCH
		--	PRINT('WARNING: Could not delete job ' + @jobNameStep + '. Job may not exist.')
		--END CATCH

		EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=@jobNameStep, 
				@enabled=1, 
				@notify_level_eventlog=0, 
				@notify_level_email=0, 
				@notify_level_netsend=0, 
				@notify_level_page=0, 
				@delete_level=0, 
				@description=@stepDescr, 
				@category_name=@jobCategory, 
				@owner_login_name=@jobOwner, @job_id = @jobId OUTPUT
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

		EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
				@step_id=1, -- always 1 step 
				@cmdexec_success_code=0, 
				@on_success_action=@QUIT_REPORTING_SUCCESS, -- quit reporting success
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
		
		EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback


-------------------------------------------------------------------
-- Uploads for each site. 11 Total.
-------------------------------------------------------------------

-------------------------------------------------------------------
-- Configure executable path and environment specification 
-------------------------------------------------------------------

DECLARE @exePath nvarchar(1000) = 
			(SELECT CASE @environment WHEN 'PROD' THEN N'\\F3420-ECLDBP01\SSIS\Coaching\SOIBean\'
									  WHEN 'UAT'  THEN N'\\F3420-ECLDBT01\SSIS\Coaching\UAT\SOIBean\'
									  WHEN 'TEST' THEN N'\\F3420-ECLDBT01\SSIS\Coaching\SOIBean\'
									  ELSE N'\\F3420-ECLDBD01\SSIS\Coaching\SOIBean\' END) -- Assume dev

DECLARE @environConfig nvarchar(100) = 
			(SELECT CASE @environment WHEN 'PROD' THEN N'environment.production.config'
									  WHEN 'UAT'  THEN N'environment.uat.config'
									  WHEN 'TEST' THEN N'environment.systemtest.config'
									  ELSE N'environment.development.config' END) -- Assume dev

------------------------------------------------------------------
-- Object 2:  Step [Upload Bogalusa Bingo Logs.]
-------------------------------------------------------------------


DECLARE @siteConfig nvarchar(100) = N' config\ecl_bingo_bogalusa.config'
DECLARE @exeCommand nvarchar(4000) = N'cmd /c pushd "' + @exePath + N'" && SOIBean.exe config\ecl.config config\' + @environConfig + @siteConfig + ' && popd'
SET @stepName = N'Upload Bogalusa Bingo Logs'
SET @stepDescr = N'Uploads the Bogalusa Bingo logs to the SharePoint site.'
SET @jobId = @mainJobId
SET @stepId = @stepID + 1
SET @successAction = CASE @stepId WHEN @totalSteps THEN @QUIT_REPORTING_SUCCESS -- quit reporting success
								  ELSE @GO_TO_NEXT_STEP END -- go to next step
SET @failureAction = CASE @stepId WHEN @totalSteps THEN @QUIT_REPORTING_FAILURE -- quit reporting failure
								  ELSE @GO_TO_NEXT_STEP END -- go to next step
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
		@step_id=@stepId, 
		@cmdexec_success_code=0, 
		@on_success_action=@successAction,
		@on_success_step_id=0, 
		@on_fail_action=@failureAction,
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=@exeCommand, 
		@flags=0, 
		@proxy_name=@proxyName
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

		-- Create a separate single-step job with this step
		SET @jobId = NULL
		SET @jobNameStep = CONCAT(@jobNameStepBase,RIGHT(N'00' + CAST(@stepId AS nvarchar(10)),2),' (Bogalusa Bingo Upload)')

		-------------------------------------------------------------------
		--BEGIN TRY
		--	EXEC msdb.dbo.sp_delete_job @job_name = @jobNameStep, @delete_unused_schedule=1
		--END TRY
		--BEGIN CATCH
		--	PRINT('WARNING: Could not delete job ' + @jobNameStep + '. Job may not exist.')
		--END CATCH

		EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=@jobNameStep, 
				@enabled=1, 
				@notify_level_eventlog=0, 
				@notify_level_email=0, 
				@notify_level_netsend=0, 
				@notify_level_page=0, 
				@delete_level=0, 
				@description=@stepDescr, 
				@category_name=@jobCategory, 
				@owner_login_name=@jobOwner, @job_id = @jobId OUTPUT
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

		EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
				@step_id=1, -- always 1 step 
				@cmdexec_success_code=0, 
				@on_success_action=@QUIT_REPORTING_SUCCESS, -- quit reporting success
				@on_success_step_id=0, 
				@on_fail_action=@QUIT_REPORTING_FAILURE, 
				@on_fail_step_id=0, 
				@retry_attempts=0, 
				@retry_interval=0, 
				@os_run_priority=0, @subsystem=N'CmdExec', 
				@command=@exeCommand, 
				@flags=0, 
				@proxy_name=@proxyName
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
		
		EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback


------------------------------------------------------------------
-- Object 3:  Step [Upload Brownsville Bingo Logs.]
-------------------------------------------------------------------


SET @siteConfig = N' config\ecl_bingo_brownsville.config'
SET @exeCommand = N'cmd /c pushd "' + @exePath + N'" && SOIBean.exe config\ecl.config config\' + @environConfig + @siteConfig + ' && popd'
SET @stepName = N'Upload Brownsville Bingo Logs'
SET @stepDescr = N'Uploads the Brownsville Bingo logs to the SharePoint site.'
SET @jobId = @mainJobId
SET @stepId = @stepID + 1
SET @successAction = CASE @stepId WHEN @totalSteps THEN @QUIT_REPORTING_SUCCESS -- quit reporting success
								  ELSE @GO_TO_NEXT_STEP END -- go to next step
SET @failureAction = CASE @stepId WHEN @totalSteps THEN @QUIT_REPORTING_FAILURE -- quit reporting failure
								  ELSE @GO_TO_NEXT_STEP END -- go to next step
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
		@step_id=@stepId, 
		@cmdexec_success_code=0, 
		@on_success_action=@successAction,
		@on_success_step_id=0, 
		@on_fail_action=@failureAction,
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=@exeCommand, 
		@flags=0, 
		@proxy_name=@proxyName
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

		-- Create a separate single-step job with this step
		SET @jobId = NULL
		SET @jobNameStep = CONCAT(@jobNameStepBase,RIGHT(N'00' + CAST(@stepId AS nvarchar(10)),2),' (Brownsville Bingo Upload)')

		-------------------------------------------------------------------
		--BEGIN TRY
		--	EXEC msdb.dbo.sp_delete_job @job_name = @jobNameStep, @delete_unused_schedule=1
		--END TRY
		--BEGIN CATCH
		--	PRINT('WARNING: Could not delete job ' + @jobNameStep + '. Job may not exist.')
		--END CATCH

		EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=@jobNameStep, 
				@enabled=1, 
				@notify_level_eventlog=0, 
				@notify_level_email=0, 
				@notify_level_netsend=0, 
				@notify_level_page=0, 
				@delete_level=0, 
				@description=@stepDescr, 
				@category_name=@jobCategory, 
				@owner_login_name=@jobOwner, @job_id = @jobId OUTPUT
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

		EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
				@step_id=1, -- always 1 step 
				@cmdexec_success_code=0, 
				@on_success_action=@QUIT_REPORTING_SUCCESS, -- quit reporting success
				@on_success_step_id=0, 
				@on_fail_action=@QUIT_REPORTING_FAILURE, 
				@on_fail_step_id=0, 
				@retry_attempts=0, 
				@retry_interval=0, 
				@os_run_priority=0, @subsystem=N'CmdExec', 
				@command=@exeCommand, 
				@flags=0, 
				@proxy_name=@proxyName
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
		
		EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

------------------------------------------------------------------
-- Object 4:  Step [Upload Chester Bingo Logs.]
-------------------------------------------------------------------


SET @siteConfig = N' config\ecl_bingo_chester.config'
SET @exeCommand = N'cmd /c pushd "' + @exePath + N'" && SOIBean.exe config\ecl.config config\' + @environConfig + @siteConfig + ' && popd'
SET @stepName = N'Upload Chester Bingo Logs'
SET @stepDescr = N'Uploads the Chester Bingo logs to the SharePoint site.'
SET @jobId = @mainJobId
SET @stepId = @stepID + 1
SET @successAction = CASE @stepId WHEN @totalSteps THEN @QUIT_REPORTING_SUCCESS -- quit reporting success
								  ELSE @GO_TO_NEXT_STEP END -- go to next step
SET @failureAction = CASE @stepId WHEN @totalSteps THEN @QUIT_REPORTING_FAILURE -- quit reporting failure
								  ELSE @GO_TO_NEXT_STEP END -- go to next step
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
		@step_id=@stepId, 
		@cmdexec_success_code=0, 
		@on_success_action=@successAction,
		@on_success_step_id=0, 
		@on_fail_action=@failureAction,
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=@exeCommand, 
		@flags=0, 
		@proxy_name=@proxyName
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

		-- Create a separate single-step job with this step
		SET @jobId = NULL
		SET @jobNameStep = CONCAT(@jobNameStepBase,RIGHT(N'00' + CAST(@stepId AS nvarchar(10)),2),' (Chester Bingo Upload)')

		-------------------------------------------------------------------
		--BEGIN TRY
		--	EXEC msdb.dbo.sp_delete_job @job_name = @jobNameStep, @delete_unused_schedule=1
		--END TRY
		--BEGIN CATCH
		--	PRINT('WARNING: Could not delete job ' + @jobNameStep + '. Job may not exist.')
		--END CATCH

		EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=@jobNameStep, 
				@enabled=1, 
				@notify_level_eventlog=0, 
				@notify_level_email=0, 
				@notify_level_netsend=0, 
				@notify_level_page=0, 
				@delete_level=0, 
				@description=@stepDescr, 
				@category_name=@jobCategory, 
				@owner_login_name=@jobOwner, @job_id = @jobId OUTPUT
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

		EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
				@step_id=1, -- always 1 step 
				@cmdexec_success_code=0, 
				@on_success_action=@QUIT_REPORTING_SUCCESS, -- quit reporting success
				@on_success_step_id=0, 
				@on_fail_action=@QUIT_REPORTING_FAILURE, 
				@on_fail_step_id=0, 
				@retry_attempts=0, 
				@retry_interval=0, 
				@os_run_priority=0, @subsystem=N'CmdExec', 
				@command=@exeCommand, 
				@flags=0, 
				@proxy_name=@proxyName
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
		
		EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback


------------------------------------------------------------------
-- Object 5:  Step [Upload Hattiesburg Bingo Logs.]
-------------------------------------------------------------------


SET @siteConfig = N' config\ecl_bingo_hattiesburg.config'
SET @exeCommand = N'cmd /c pushd "' + @exePath + N'" && SOIBean.exe config\ecl.config config\' + @environConfig + @siteConfig + ' && popd'
SET @stepName = N'Upload Hattiesburg Bingo Logs'
SET @stepDescr = N'Uploads the Hattiesburg Bingo logs to the SharePoint site.'
SET @jobId = @mainJobId
SET @stepId = @stepID + 1
SET @successAction = CASE @stepId WHEN @totalSteps THEN @QUIT_REPORTING_SUCCESS -- quit reporting success
								  ELSE @GO_TO_NEXT_STEP END -- go to next step
SET @failureAction = CASE @stepId WHEN @totalSteps THEN @QUIT_REPORTING_FAILURE -- quit reporting failure
								  ELSE @GO_TO_NEXT_STEP END -- go to next step
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
		@step_id=@stepId, 
		@cmdexec_success_code=0, 
		@on_success_action=@successAction,
		@on_success_step_id=0, 
		@on_fail_action=@failureAction,
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=@exeCommand, 
		@flags=0, 
		@proxy_name=@proxyName
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

		-- Create a separate single-step job with this step
		SET @jobId = NULL
		SET @jobNameStep = CONCAT(@jobNameStepBase,RIGHT(N'00' + CAST(@stepId AS nvarchar(10)),2),' (Hattiesburg Bingo Upload)')

		-------------------------------------------------------------------
		--BEGIN TRY
		--	EXEC msdb.dbo.sp_delete_job @job_name = @jobNameStep, @delete_unused_schedule=1
		--END TRY
		--BEGIN CATCH
		--	PRINT('WARNING: Could not delete job ' + @jobNameStep + '. Job may not exist.')
		--END CATCH

		EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=@jobNameStep, 
				@enabled=1, 
				@notify_level_eventlog=0, 
				@notify_level_email=0, 
				@notify_level_netsend=0, 
				@notify_level_page=0, 
				@delete_level=0, 
				@description=@stepDescr, 
				@category_name=@jobCategory, 
				@owner_login_name=@jobOwner, @job_id = @jobId OUTPUT
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

		EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
				@step_id=1, -- always 1 step 
				@cmdexec_success_code=0, 
				@on_success_action=@QUIT_REPORTING_SUCCESS, -- quit reporting success
				@on_success_step_id=0, 
				@on_fail_action=@QUIT_REPORTING_FAILURE, 
				@on_fail_step_id=0, 
				@retry_attempts=0, 
				@retry_interval=0, 
				@os_run_priority=0, @subsystem=N'CmdExec', 
				@command=@exeCommand, 
				@flags=0, 
				@proxy_name=@proxyName
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
		
		EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback


------------------------------------------------------------------
-- Object 6:  Step [Upload Lawrence Bingo Logs.]
-------------------------------------------------------------------


SET @siteConfig = N' config\ecl_bingo_lawrence.config'
SET @exeCommand = N'cmd /c pushd "' + @exePath + N'" && SOIBean.exe config\ecl.config config\' + @environConfig + @siteConfig + ' && popd'
SET @stepName = N'Upload Lawrence Bingo Logs'
SET @stepDescr = N'Uploads the Lawrence Bingo logs to the SharePoint site.'
SET @jobId = @mainJobId
SET @stepId = @stepID + 1
SET @successAction = CASE @stepId WHEN @totalSteps THEN @QUIT_REPORTING_SUCCESS -- quit reporting success
								  ELSE @GO_TO_NEXT_STEP END -- go to next step
SET @failureAction = CASE @stepId WHEN @totalSteps THEN @QUIT_REPORTING_FAILURE -- quit reporting failure
								  ELSE @GO_TO_NEXT_STEP END -- go to next step
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
		@step_id=@stepId, 
		@cmdexec_success_code=0, 
		@on_success_action=@successAction,
		@on_success_step_id=0, 
		@on_fail_action=@failureAction,
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=@exeCommand, 
		@flags=0, 
		@proxy_name=@proxyName
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

		-- Create a separate single-step job with this step
		SET @jobId = NULL
		SET @jobNameStep = CONCAT(@jobNameStepBase,RIGHT(N'00' + CAST(@stepId AS nvarchar(10)),2),' (Lawrence Bingo Upload)')

		-------------------------------------------------------------------
		--BEGIN TRY
		--	EXEC msdb.dbo.sp_delete_job @job_name = @jobNameStep, @delete_unused_schedule=1
		--END TRY
		--BEGIN CATCH
		--	PRINT('WARNING: Could not delete job ' + @jobNameStep + '. Job may not exist.')
		--END CATCH

		EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=@jobNameStep, 
				@enabled=1, 
				@notify_level_eventlog=0, 
				@notify_level_email=0, 
				@notify_level_netsend=0, 
				@notify_level_page=0, 
				@delete_level=0, 
				@description=@stepDescr, 
				@category_name=@jobCategory, 
				@owner_login_name=@jobOwner, @job_id = @jobId OUTPUT
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

		EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
				@step_id=1, -- always 1 step 
				@cmdexec_success_code=0, 
				@on_success_action=@QUIT_REPORTING_SUCCESS, -- quit reporting success
				@on_success_step_id=0, 
				@on_fail_action=@QUIT_REPORTING_FAILURE, 
				@on_fail_step_id=0, 
				@retry_attempts=0, 
				@retry_interval=0, 
				@os_run_priority=0, @subsystem=N'CmdExec', 
				@command=@exeCommand, 
				@flags=0, 
				@proxy_name=@proxyName
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
		
		EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback


------------------------------------------------------------------
-- Object 7:  Step [Upload London Bingo Logs.]
-------------------------------------------------------------------


SET @siteConfig = N' config\ecl_bingo_london.config'
SET @exeCommand = N'cmd /c pushd "' + @exePath + N'" && SOIBean.exe config\ecl.config config\' + @environConfig + @siteConfig + ' && popd'
SET @stepName = N'Upload London Bingo Logs'
SET @stepDescr = N'Uploads the London Bingo logs to the SharePoint site.'
SET @jobId = @mainJobId
SET @stepId = @stepID + 1
SET @successAction = CASE @stepId WHEN @totalSteps THEN @QUIT_REPORTING_SUCCESS -- quit reporting success
								  ELSE @GO_TO_NEXT_STEP END -- go to next step
SET @failureAction = CASE @stepId WHEN @totalSteps THEN @QUIT_REPORTING_FAILURE -- quit reporting failure
								  ELSE @GO_TO_NEXT_STEP END -- go to next step
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
		@step_id=@stepId, 
		@cmdexec_success_code=0, 
		@on_success_action=@successAction,
		@on_success_step_id=0, 
		@on_fail_action=@failureAction,
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=@exeCommand, 
		@flags=0, 
		@proxy_name=@proxyName
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

		-- Create a separate single-step job with this step
		SET @jobId = NULL
		SET @jobNameStep = CONCAT(@jobNameStepBase,RIGHT(N'00' + CAST(@stepId AS nvarchar(10)),2),' (London Bingo Upload)')

		-------------------------------------------------------------------
		--BEGIN TRY
		--	EXEC msdb.dbo.sp_delete_job @job_name = @jobNameStep, @delete_unused_schedule=1
		--END TRY
		--BEGIN CATCH
		--	PRINT('WARNING: Could not delete job ' + @jobNameStep + '. Job may not exist.')
		--END CATCH

		EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=@jobNameStep, 
				@enabled=1, 
				@notify_level_eventlog=0, 
				@notify_level_email=0, 
				@notify_level_netsend=0, 
				@notify_level_page=0, 
				@delete_level=0, 
				@description=@stepDescr, 
				@category_name=@jobCategory, 
				@owner_login_name=@jobOwner, @job_id = @jobId OUTPUT
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

		EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
				@step_id=1, -- always 1 step 
				@cmdexec_success_code=0, 
				@on_success_action=@QUIT_REPORTING_SUCCESS, -- quit reporting success
				@on_success_step_id=0, 
				@on_fail_action=@QUIT_REPORTING_FAILURE, 
				@on_fail_step_id=0, 
				@retry_attempts=0, 
				@retry_interval=0, 
				@os_run_priority=0, @subsystem=N'CmdExec', 
				@command=@exeCommand, 
				@flags=0, 
				@proxy_name=@proxyName
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
		
		EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

------------------------------------------------------------------
-- Object 8:  Step [Upload LynnHaven Bingo Logs.]
-------------------------------------------------------------------

SET @siteConfig = N' config\ecl_bingo_lynnhaven.config'
SET @exeCommand = N'cmd /c pushd "' + @exePath + N'" && SOIBean.exe config\ecl.config config\' + @environConfig + @siteConfig + ' && popd'
SET @stepName = N'Upload LynnHaven Bingo Logs'
SET @stepDescr = N'Uploads the LynnHaven Bingo logs to the SharePoint site.'
SET @jobId = @mainJobId
SET @stepId = @stepID + 1
SET @successAction = CASE @stepId WHEN @totalSteps THEN @QUIT_REPORTING_SUCCESS -- quit reporting success
								  ELSE @GO_TO_NEXT_STEP END -- go to next step
SET @failureAction = CASE @stepId WHEN @totalSteps THEN @QUIT_REPORTING_FAILURE -- quit reporting failure
								  ELSE @GO_TO_NEXT_STEP END -- go to next step
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
		@step_id=@stepId, 
		@cmdexec_success_code=0, 
		@on_success_action=@successAction,
		@on_success_step_id=0, 
		@on_fail_action=@failureAction,
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=@exeCommand, 
		@flags=0, 
		@proxy_name=@proxyName
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

		-- Create a separate single-step job with this step
		SET @jobId = NULL
		SET @jobNameStep = CONCAT(@jobNameStepBase,RIGHT(N'00' + CAST(@stepId AS nvarchar(10)),2),' (LynnHaven Bingo Upload)')

		-------------------------------------------------------------------
		--BEGIN TRY
		--	EXEC msdb.dbo.sp_delete_job @job_name = @jobNameStep, @delete_unused_schedule=1
		--END TRY
		--BEGIN CATCH
		--	PRINT('WARNING: Could not delete job ' + @jobNameStep + '. Job may not exist.')
		--END CATCH

		EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=@jobNameStep, 
				@enabled=1, 
				@notify_level_eventlog=0, 
				@notify_level_email=0, 
				@notify_level_netsend=0, 
				@notify_level_page=0, 
				@delete_level=0, 
				@description=@stepDescr, 
				@category_name=@jobCategory, 
				@owner_login_name=@jobOwner, @job_id = @jobId OUTPUT
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

		EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
				@step_id=1, -- always 1 step 
				@cmdexec_success_code=0, 
				@on_success_action=@QUIT_REPORTING_SUCCESS, -- quit reporting success
				@on_success_step_id=0, 
				@on_fail_action=@QUIT_REPORTING_FAILURE, 
				@on_fail_step_id=0, 
				@retry_attempts=0, 
				@retry_interval=0, 
				@os_run_priority=0, @subsystem=N'CmdExec', 
				@command=@exeCommand, 
				@flags=0, 
				@proxy_name=@proxyName
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
		
		EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback


------------------------------------------------------------------
-- Object 9:  Step [Upload Phoenix Bingo Logs]
-------------------------------------------------------------------


SET @siteConfig = N' config\ecl_bingo_phoenix.config'
SET @exeCommand = N'cmd /c pushd "' + @exePath + N'" && SOIBean.exe config\ecl.config config\' + @environConfig + @siteConfig + ' && popd'
SET @stepName = N'Upload Phoenix Bingo Logs.'
SET @stepDescr = N'Uploads the Phoenix Bingo logs to the SharePoint site.'
SET @jobId = @mainJobId
SET @stepId = @stepID + 1
SET @successAction = CASE @stepId WHEN @totalSteps THEN @QUIT_REPORTING_SUCCESS -- quit reporting success
								  ELSE @GO_TO_NEXT_STEP END -- go to next step
SET @failureAction = CASE @stepId WHEN @totalSteps THEN @QUIT_REPORTING_FAILURE -- quit reporting failure
								  ELSE @GO_TO_NEXT_STEP END -- go to next step
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
		@step_id=@stepId, 
		@cmdexec_success_code=0, 
		@on_success_action=@successAction,
		@on_success_step_id=0, 
		@on_fail_action=@failureAction,
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=@exeCommand, 
		@flags=0, 
		@proxy_name=@proxyName
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

		-- Create a separate single-step job with this step
		SET @jobId = NULL
		SET @jobNameStep = CONCAT(@jobNameStepBase,RIGHT(N'00' + CAST(@stepId AS nvarchar(10)),2),' (Phoenix Bingo Upload)')

		-------------------------------------------------------------------
		--BEGIN TRY
		--	EXEC msdb.dbo.sp_delete_job @job_name = @jobNameStep, @delete_unused_schedule=1
		--END TRY
		--BEGIN CATCH
		--	PRINT('WARNING: Could not delete job ' + @jobNameStep + '. Job may not exist.')
		--END CATCH

		EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=@jobNameStep, 
				@enabled=1, 
				@notify_level_eventlog=0, 
				@notify_level_email=0, 
				@notify_level_netsend=0, 
				@notify_level_page=0, 
				@delete_level=0, 
				@description=@stepDescr, 
				@category_name=@jobCategory, 
				@owner_login_name=@jobOwner, @job_id = @jobId OUTPUT
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

		EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
				@step_id=1, -- always 1 step 
				@cmdexec_success_code=0, 
				@on_success_action=@QUIT_REPORTING_SUCCESS, -- quit reporting success
				@on_success_step_id=0, 
				@on_fail_action=@QUIT_REPORTING_FAILURE, 
				@on_fail_step_id=0, 
				@retry_attempts=0, 
				@retry_interval=0, 
				@os_run_priority=0, @subsystem=N'CmdExec', 
				@command=@exeCommand, 
				@flags=0, 
				@proxy_name=@proxyName
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
		
		EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback



-------------------------------------------------------------------
-- Object 10:  Step [Upload Sandy Bingo Logs.]
-------------------------------------------------------------------
SET @siteConfig = N' config\ecl_bingo_sandy.config'
SET @exeCommand = N'cmd /c pushd "' + @exePath + N'" && SOIBean.exe config\ecl.config config\' + @environConfig + @siteConfig +' && popd'
SET @stepName = N'Upload Sandy Bingo Logs'
SET @stepDescr = N'Uploads the Sandy Bingo logs to the SharePoint site.'
SET @jobId = @mainJobId
SET @stepId = @stepID + 1
SET @successAction = CASE @stepId WHEN @totalSteps THEN @QUIT_REPORTING_SUCCESS -- quit reporting success
								  ELSE @GO_TO_NEXT_STEP END -- go to next step
SET @failureAction = CASE @stepId WHEN @totalSteps THEN @QUIT_REPORTING_FAILURE -- quit reporting failure
								  ELSE @GO_TO_NEXT_STEP END -- go to next step
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
		@step_id=@stepId, 
		@cmdexec_success_code=0, 
		@on_success_action=@successAction,
		@on_success_step_id=0, 
		@on_fail_action=@failureAction,
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=@exeCommand, 
		@flags=0, 
		@proxy_name=@proxyName
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

		-- Create a separate single-step job with this step
		SET @jobId = NULL
		SET @jobNameStep = CONCAT(@jobNameStepBase,RIGHT(N'00' + CAST(@stepId AS nvarchar(10)),2),' (Sandy Bingo Upload)')

		-------------------------------------------------------------------
		--BEGIN TRY
		--	EXEC msdb.dbo.sp_delete_job @job_name = @jobNameStep, @delete_unused_schedule=1
		--END TRY
		--BEGIN CATCH
		--	PRINT('WARNING: Could not delete job ' + @jobNameStep + '. Job may not exist.')
		--END CATCH

		EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=@jobNameStep, 
				@enabled=1, 
				@notify_level_eventlog=0, 
				@notify_level_email=0, 
				@notify_level_netsend=0, 
				@notify_level_page=0, 
				@delete_level=0, 
				@description=@stepDescr, 
				@category_name=@jobCategory, 
				@owner_login_name=@jobOwner, @job_id = @jobId OUTPUT
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

		EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
				@step_id=1, -- always 1 step 
				@cmdexec_success_code=0, 
				@on_success_action=@QUIT_REPORTING_SUCCESS, -- quit reporting success
				@on_success_step_id=0, 
				@on_fail_action=@QUIT_REPORTING_FAILURE, 
				@on_fail_step_id=0, 
				@retry_attempts=0, 
				@retry_interval=0, 
				@os_run_priority=0, @subsystem=N'CmdExec', 
				@command=@exeCommand, 
				@flags=0, 
				@proxy_name=@proxyName
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
		
		EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback


------------------------------------------------------------------
-- Object 11:  Step [Upload Tampa Bingo Logs.]
-------------------------------------------------------------------


SET @siteConfig = N' config\ecl_bingo_tampa.config'
SET @exeCommand = N'cmd /c pushd "' + @exePath + N'" && SOIBean.exe config\ecl.config config\' + @environConfig + @siteConfig + ' && popd'
SET @stepName = N'Upload Tampa Bingo Logs'
SET @stepDescr = N'Uploads the Tampa Bingo logs to the SharePoint site.'
SET @jobId = @mainJobId
SET @stepId = @stepID + 1
SET @successAction = CASE @stepId WHEN @totalSteps THEN @QUIT_REPORTING_SUCCESS -- quit reporting success
								  ELSE @GO_TO_NEXT_STEP END -- go to next step
SET @failureAction = CASE @stepId WHEN @totalSteps THEN @QUIT_REPORTING_FAILURE -- quit reporting failure
								  ELSE @GO_TO_NEXT_STEP END -- go to next step
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
		@step_id=@stepId, 
		@cmdexec_success_code=0, 
		@on_success_action=@successAction,
		@on_success_step_id=0, 
		@on_fail_action=@failureAction,
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=@exeCommand, 
		@flags=0, 
		@proxy_name=@proxyName
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

		-- Create a separate single-step job with this step
		SET @jobId = NULL
		SET @jobNameStep = CONCAT(@jobNameStepBase,RIGHT(N'00' + CAST(@stepId AS nvarchar(10)),2),' (Tampa Bingo Upload)')

		-------------------------------------------------------------------
		--BEGIN TRY
		--	EXEC msdb.dbo.sp_delete_job @job_name = @jobNameStep, @delete_unused_schedule=1
		--END TRY
		--BEGIN CATCH
		--	PRINT('WARNING: Could not delete job ' + @jobNameStep + '. Job may not exist.')
		--END CATCH

		EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=@jobNameStep, 
				@enabled=1, 
				@notify_level_eventlog=0, 
				@notify_level_email=0, 
				@notify_level_netsend=0, 
				@notify_level_page=0, 
				@delete_level=0, 
				@description=@stepDescr, 
				@category_name=@jobCategory, 
				@owner_login_name=@jobOwner, @job_id = @jobId OUTPUT
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

		EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
				@step_id=1, -- always 1 step 
				@cmdexec_success_code=0, 
				@on_success_action=@QUIT_REPORTING_SUCCESS, -- quit reporting success
				@on_success_step_id=0, 
				@on_fail_action=@QUIT_REPORTING_FAILURE, 
				@on_fail_step_id=0, 
				@retry_attempts=0, 
				@retry_interval=0, 
				@os_run_priority=0, @subsystem=N'CmdExec', 
				@command=@exeCommand, 
				@flags=0, 
				@proxy_name=@proxyName
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
		
		EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

------------------------------------------------------------------
-- Object 12:  Step [Upload Winchester Bingo Logs.]
-------------------------------------------------------------------


SET @siteConfig = N' config\ecl_bingo_winchester.config'
SET @exeCommand = N'cmd /c pushd "' + @exePath + N'" && SOIBean.exe config\ecl.config config\' + @environConfig + @siteConfig + ' && popd'
SET @stepName = N'Upload Winchester Bingo Logs'
SET @stepDescr = N'Uploads the Winchester Bingo logs to the SharePoint site.'
SET @jobId = @mainJobId
SET @stepId = @stepID + 1
SET @successAction = CASE @stepId WHEN @totalSteps THEN @QUIT_REPORTING_SUCCESS -- quit reporting success
								  ELSE @GO_TO_NEXT_STEP END -- go to next step
SET @failureAction = CASE @stepId WHEN @totalSteps THEN @QUIT_REPORTING_FAILURE -- quit reporting failure
								  ELSE @GO_TO_NEXT_STEP END -- go to next step
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
		@step_id=@stepId, 
		@cmdexec_success_code=0, 
		@on_success_action=@successAction,
		@on_success_step_id=0, 
		@on_fail_action=@failureAction,
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=@exeCommand, 
		@flags=0, 
		@proxy_name=@proxyName
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

		-- Create a separate single-step job with this step
		SET @jobId = NULL
		SET @jobNameStep = CONCAT(@jobNameStepBase,RIGHT(N'00' + CAST(@stepId AS nvarchar(10)),2),' (Winchester Bingo Upload)')

		-------------------------------------------------------------------
		--BEGIN TRY
		--	EXEC msdb.dbo.sp_delete_job @job_name = @jobNameStep, @delete_unused_schedule=1
		--END TRY
		--BEGIN CATCH
		--	PRINT('WARNING: Could not delete job ' + @jobNameStep + '. Job may not exist.')
		--END CATCH

		EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=@jobNameStep, 
				@enabled=1, 
				@notify_level_eventlog=0, 
				@notify_level_email=0, 
				@notify_level_netsend=0, 
				@notify_level_page=0, 
				@delete_level=0, 
				@description=@stepDescr, 
				@category_name=@jobCategory, 
				@owner_login_name=@jobOwner, @job_id = @jobId OUTPUT
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

		EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=@stepName, 
				@step_id=1, -- always 1 step 
				@cmdexec_success_code=0, 
				@on_success_action=@QUIT_REPORTING_SUCCESS, -- quit reporting success
				@on_success_step_id=0, 
				@on_fail_action=@QUIT_REPORTING_FAILURE, 
				@on_fail_step_id=0, 
				@retry_attempts=0, 
				@retry_interval=0, 
				@os_run_priority=0, @subsystem=N'CmdExec', 
				@command=@exeCommand, 
				@flags=0, 
				@proxy_name=@proxyName
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
		
		EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback


-------------------------------------------------------------------
-- Warn if there is a step count mismatch
-------------------------------------------------------------------
IF @stepId <> @totalSteps
BEGIN
	PRINT(CHAR(13) + '!! WARNING: Total steps mismatch. Last scripted step count: ' + CAST(@stepId AS nvarchar(5)) + '. Expected total steps: ' + CAST(@totalSteps AS nvarchar(5)) + CHAR(13));
END

-------------------------------------------------------------------
-- Schedule the main job (enabled if needed - generally prod only)
-------------------------------------------------------------------
SET @jobId = @mainJobId
DECLARE @isEnabled bit = (SELECT CASE @environment WHEN 'PROD' THEN 1 ELSE 0 END)
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'MonthlyBingoUploadToSharepoint', 
		@enabled= @isEnabled, 
		@freq_type=16, -- Monthly
		@freq_interval=15, -- day of Month
		@freq_subday_type=1, -- once at specified time
		@freq_subday_interval=0, -- N/A
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20210101,  
		@active_end_date=99991231, -- No end date
		@active_start_time=30000, -- 3:00 AM server time (MT)
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


