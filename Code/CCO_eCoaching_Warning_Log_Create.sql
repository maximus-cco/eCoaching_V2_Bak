/*
eCoaching_Warning_Log_Create(10).sql
Last Modified Date: 07/23/2015
Last Modified By: Susmitha Palacherla

Version 10:
1.  Updates for TFS 363 Avoid Duplicate FormNames for Insert from UI.
     Updated SP#2 for generating formname after insert

Version 09: SCR 14966
1. Additional Update to sp [EC].[sp_SelectReviewFrom_Warning_Log] (#3) to add Sup and Mgr Ids

Version 08: SCR 14966
1. Modified sp [EC].[sp_SelectReviewFrom_Warning_Log] (#3) to add Emp and submitter IDs
2. Added a new SP #9 which was created earlier as part of 14423 and added toas SP #76 in Coaching_Log_Create doc.


Version 07: SCR 14304
1. Modified sp [EC].[sp_InsertInto_Warning_Log](#2)

Version 06: SCR 13623
1. Added 2 new fields to the Warning_Log table.
    numReportID and strReportCode

Version 05: SCR 13542
1. Modified sp [EC].[sp_SelectFrom_Warning_Log_SUPCSRCompleted]  (#6)

Version 04: Updates from UAT for SCR 13479 SCR 13624.
1. Modified sp [EC].[sp_SelectFrom_Warning_Log_MGRCSRCompleted]  (#7)

Version 03: Inactivate expired warning logs. SCR 13624.
1. Added new sp [EC].[sp_InactivateExpiredWarningLogs] (#8)


Version 02: Additional Updates. SCR 13479.
1. Marked Encryption related Objects as Not being Used.(sp #1)
2. Removed Calls to encryption Functions and procedure and 
    removed Description and Coaching Notes from Insert (sp #2) and Review (sp #3) Procedures.


Version 01: Initial Revision 
1. Created code modules necessary to support CSR progressive warnings
    per SCR 13479.

Summary

Tables
1. [EC].[Warning_Log]
2. [EC].[Warning_Log_Reason]

Procedures
1.  [EC].[sp_OpenKeys] -- (Not Being Used)
2.  [EC].[sp_InsertInto_Warning_Log]
3. [EC].[sp_SelectReviewFrom_Warning_Log] 
4. [EC].[sp_SelectReviewFrom_Warning_Log_Reasons]
5. [EC].[sp_SelectFrom_Warning_Log_CSRCompleted]-- (Not Being Used)
6. [EC].[sp_SelectFrom_Warning_Log_SUPCSRCompleted] 
7. [EC].[sp_SelectFrom_Warning_Log_MGRCSRCompleted] 
8. [EC].[sp_InactivateExpiredWarningLogs] 
9. [EC].[sp_SelectFrom_Coaching_Log_SRMGREmployeeWarning] --(#76 in Coaching_Log_Create doc)
*/


 --Details

**************************************************************
--Tables
**************************************************************

--1. Create Table  [EC].[Warning_Log]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [EC].[Warning_Log](
	[WarningID] [bigint] IDENTITY(1,1) NOT NULL,
	[FormName] [nvarchar](50) NOT NULL,
	[ProgramName] [nvarchar](50) NOT NULL,
	[SourceID] [int] NOT NULL,
	[StatusID] [int] NOT NULL,
	[SiteID] [int] NOT NULL,
	[EmpLanID] [nvarchar](50) NOT NULL,
	[EmpID] [nvarchar](10) NOT NULL,
	[SubmitterID] [nvarchar](10) NULL,
	[SupID] [nvarchar](10) NOT NULL,
	[MgrID] [nvarchar](10) NOT NULL,
	[WarningGivenDate] [datetime] NOT NULL,
	[Description] [varbinary](max) NULL,
	[CoachingNotes] [varbinary](max) NULL,
	[SubmittedDate] [datetime] NULL,
	[ModuleID] [int] NULL,
	[Active] [bit] NULL,
                  [ numReportID] [int] NOT NULL,
                 [strReportCode]  [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_Warning_Log] PRIMARY KEY CLUSTERED 
(
	[WarningID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [EC].[Warning_Log]  WITH NOCHECK ADD  CONSTRAINT [fkWarningSiteID] FOREIGN KEY([SiteID])
REFERENCES [EC].[DIM_Site] ([SiteID])
GO

ALTER TABLE [EC].[Warning_Log] CHECK CONSTRAINT [fkWarningSiteID]
GO

ALTER TABLE [EC].[Warning_Log]  WITH NOCHECK ADD  CONSTRAINT [fkWarningSourceID] FOREIGN KEY([SourceID])
REFERENCES [EC].[DIM_Source] ([SourceID])
GO

ALTER TABLE [EC].[Warning_Log] CHECK CONSTRAINT [fkWarningSourceID]
GO

ALTER TABLE [EC].[Warning_Log]  WITH NOCHECK ADD  CONSTRAINT [fkWarningStatusID] FOREIGN KEY([StatusID])
REFERENCES [EC].[DIM_Status] ([StatusID])
GO

ALTER TABLE [EC].[Warning_Log] CHECK CONSTRAINT [fkWarningStatusID]
GO

ALTER TABLE [EC].[Warning_Log] ADD  DEFAULT ((1)) FOR [Active]
GO




**************************************************************

--2. Create Table  [EC].[Warning_Log_Reason]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Warning_Log_Reason](
	[WarningID] [bigint] NOT NULL,
	[CoachingReasonID] [bigint] NOT NULL,
	[SubCoachingReasonID] [bigint] NOT NULL,
	[Value] [nvarchar](30) NULL,
 CONSTRAINT [PK_Warning_Log_Reason] PRIMARY KEY CLUSTERED 
(
	[WarningID] ASC,
	[CoachingReasonID] ASC,
	[SubCoachingReasonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [EC].[Warning_Log_Reason]  WITH NOCHECK ADD  CONSTRAINT [fkWarningID] FOREIGN KEY([WarningID])
REFERENCES [EC].[Warning_Log] ([WarningID])
GO

ALTER TABLE [EC].[Warning_Log_Reason] CHECK CONSTRAINT [fkWarningID]
GO




**************************************************************



**************************************************************

--Procedures

**************************************************************

--1. Create SP  [EC].[sp_OpenKeys] -- Obsolete

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_OpenKeys' 
)
   DROP PROCEDURE [EC].[sp_OpenKeys]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	10/08/2014
--	Description: *	This procedure opens the Symmetric keys that allows them to be used for 
--               Encryption and Decryption of data. 
--	Last Update:
--  Last Updated By:   
--	=====================================================================
CREATE PROCEDURE [EC].[sp_OpenKeys]
AS
BEGIN
   

    BEGIN TRY
        OPEN SYMMETRIC KEY WarnDescKey
        DECRYPTION BY CERTIFICATE WarnDescCert
    END TRY
    BEGIN CATCH
        -- Handle non-existant key here
    END CATCH
END --sp_OpenKeys


GO



******************************************************************

--2. Create SP   [EC].[sp_InsertInto_Warning_Log]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Warning_Log' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_Warning_Log]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      10/03/2014
--    Description:     This procedure inserts the Warning records into the Warning_Log table. 
--                     The main attributes of the Warning are written to the warning_Log table.
--                     The Warning Reasons are written to the Warning_Reasons Table.
-- Last Modified Date: 07/23/2015
-- Last Updated By: Susmitha Palacherla
-- Modified per TFS 363/402 to update formname from WarningID after insert. 
--    =====================================================================
CREATE PROCEDURE [EC].[sp_InsertInto_Warning_Log]
(     @nvcFormName Nvarchar(50),
      @nvcProgramName Nvarchar(50),
      @nvcEmpLanID Nvarchar(40),
      @SiteID INT,
      @nvcSubmitter Nvarchar(40),
      @dtmEventDate datetime,
      @intCoachReasonID1 INT,
      @nvcSubCoachReasonID1 Nvarchar(255),
      @dtmSubmittedDate datetime ,
      @ModuleID INT,
      @isDup BIT OUTPUT,
      @nvcNewFormName Nvarchar(50) OUTPUT
      )
   
AS
BEGIN
   
DECLARE @RetryCounter INT
SET @RetryCounter = 1

RETRY: -- Label RETRY

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY
      
    --	Fetch the Employee ID of the current User (@nvcCSR) and Employee ID of the Submitter (@nvcSubmitter).

	DECLARE @nvcEmpID Nvarchar(10),
	        @nvcSubmitterID	Nvarchar(10),
	        @nvcSupID nvarchar(10),
	        @nvcMgrID nvarchar(10),
	        @nvcNotPassedSiteID INT,
	        @dtmDate datetime,
	        @intWarnIDExists BIGINT
	        
	  
	 	        
	SET @dtmDate  = GETDATE()   
	SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@nvcEmpLanID,@dtmDate)
	SET @nvcSubmitterID = EC.fn_nvcGetEmpIdFromLanID(@nvcSubmitter,@dtmDate)
	SET @nvcSupID = (Select Sup_ID from EC.Employee_Hierarchy Where Emp_ID = @nvcEmpID)
	SET @nvcMgrID = (Select Mgr_ID from EC.Employee_Hierarchy Where Emp_ID = @nvcEmpID)  
	SET @nvcNotPassedSiteID = EC.fn_intSiteIDFromEmpID(@nvcEmpID)
	SET @isDup = 1
	
SET @intWarnIDExists = (SELECT WL.WarningID
FROM [EC].[Warning_Log]WL join [EC].[Warning_Log_Reason]WLR
ON WL.WarningID = WLR.WarningID
WHERE WL.[EmpID]= @nvcEmpID
AND WL.[WarningGivenDate]= @dtmEventDate 
AND WLR.[CoachingReasonID] = @intCoachReasonID1
AND WLR.[SubCoachingReasonID]= @nvcSubCoachReasonID1
AND [Active] = 1)


IF @intWarnIDExists IS NULL 
        
 BEGIN 
         INSERT INTO [EC].[Warning_Log]
           ([FormName]
           ,[ProgramName]
           ,[SourceID]
           ,[StatusID]
           ,[SiteID]
           ,[EmpLanID]
           ,[EmpID]
           ,[SubmitterID]
           ,[SupID]
           ,[MgrID]
           ,[WarningGivenDate]
           ,[SubmittedDate]
           ,[ModuleID])
     VALUES
           (@nvcFormName
           ,@nvcProgramName 
           ,120
           ,1
           ,ISNULL(@SiteID,@nvcNotPassedSiteID)
           ,@nvcEmpLanID
           ,@nvcEmpID 
           ,@nvcSubmitterID
           ,@nvcSupID
           ,@nvcMgrID
           ,@dtmEventDate 
	       ,@dtmSubmittedDate 
		   ,@ModuleID)
            
    
     --PRINT 'STEP1'
            
    SELECT @@IDENTITY AS 'Identity';
    --PRINT @@IDENTITY
    
    DECLARE @I BIGINT = @@IDENTITY,
            @MaxSubReasonRowID INT,
            @SubReasonRowID INT
    
UPDATE [EC].[Warning_Log]
SET [FormName] = 'eCL-'+[FormName] +'-'+ convert(varchar,WarningID)
where [WarningID] = @I  AND [FormName] not like 'eCL%'    
OPTION (MAXDOP 1)

WAITFOR DELAY '00:00:00:01'  -- Wait for 5 ms

SET @nvcNewFormName = (SELECT [FormName] FROM  [EC].[Warning_Log] WHERE [WarningID] = @I)


 IF NOT @intCoachReasonID1 IS NULL
  BEGIN
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID1, ','))
       --PRINT  @MaxSubReasonRowID
       SET @SubReasonRowID = 1
	

While @SubReasonRowID <= @MaxSubReasonRowID 
   BEGIN
   
   
		INSERT INTO [EC].[Warning_Log_Reason]
            ([WarningID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             VALUES (@I, @intCoachReasonID1,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID1, ',')where Rowid = @SubReasonRowID ),
             'Opportunity')       
             
		SET @SubReasonRowID = @SubReasonRowID + 1

     END           
  END
 
 SET @isDup = 0
 END       

COMMIT TRANSACTION


END TRY
      
      BEGIN CATCH
	--PRINT 'Rollback Transaction'
	ROLLBACK TRANSACTION
	DECLARE @DoRetry bit; -- Whether to Retry transaction or not
    DECLARE @ErrorMessage NVARCHAR(4000)
    DECLARE @ErrorSeverity INT
    DECLARE @ErrorState INT
    
     SET @doRetry = 0;
     SELECT @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE()
    
    
    IF ERROR_NUMBER() = 1205 -- Deadlock Error Number
	BEGIN
		SET @doRetry = 1; -- Set @doRetry to 1 only for Deadlock
	END
	IF @DoRetry = 1
	BEGIN
		SET @RetryCounter = @RetryCounter + 1 -- Increment Retry Counter By one
		IF (@RetryCounter > 3) -- Check whether Retry Counter reached to 3
		BEGIN
			RAISERROR(@ErrorMessage, 18, 1) -- Raise Error Message if 
				-- still deadlock occurred after three retries
		END
		ELSE
		BEGIN
			WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms
			GOTO RETRY	-- Go to Label RETRY
		END
	END
	ELSE
	BEGIN
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
   END
  END CATCH  

  END -- sp_InsertInto_Warning_Log



GO








******************************************************************

--3. Create SP  [EC].[sp_SelectReviewFrom_Warning_Log] 


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectReviewFrom_Warning_Log' 
)
   DROP PROCEDURE [EC].[sp_SelectReviewFrom_Warning_Log]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	10/08/2014
--	Description: 	This procedure displays the Warning Log attributes for given Form Name. 
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 07/10/2015
-- Updated per SCR 14966 to add Hierarchy IDs to the select list.
--	=====================================================================

CREATE PROCEDURE [EC].[sp_SelectReviewFrom_Warning_Log] @strFormIDin nvarchar(50)
AS

BEGIN
DECLARE	

@nvcSQL nvarchar(max)

 
  SET @nvcSQL = 'SELECT wl.WarningID 	numID,
		wl.FormName	strFormID,
		m.Module,
		''Direct''	strFormType,
		''Completed''	strFormStatus,
		wl.WarningGivenDate	EventDate,
		wl.SubmitterID strSubmitterID,
		wl.SupID strCLSupID,
		wl.MgrID strCLMgrID,
		wl.EmpID strEmpID,	
		sh.Emp_LanID	strSubmitter,		
		sh.Emp_Name	strSubmitterName,
		sh.Emp_Email	strSubmitterEmail,			
		wl.EmpLanID	strEmpLanID,
		eh.Emp_Name	strCSRName,
		eh.Emp_Email	strCSREmail,
		st.City	strCSRSite,
		eh.Sup_ID strCSRSupID,
		eh.Sup_LanID	strCSRSup,
		eh.Sup_Name	strCSRSupName,
		eh.Sup_Email	strCSRSupEmail,
		eh.Mgr_ID strCSRMgrID,
		eh.Mgr_LanID	strCSRMgr,
		eh.Mgr_Name	strCSRMgrName,
		eh.Mgr_Email	strCSRMgrEmail,
		''Warning''	strSource,
		wl.SubmittedDate
		FROM [EC].[Employee_Hierarchy] eh join [EC].[Warning_Log] wl 
	    ON [wl].[EMPID] = [eh].[Emp_ID]JOIN [EC].[Employee_Hierarchy] sh
	    ON [wl].[SubmitterID] = [sh].[Emp_ID]JOIN [EC].[DIM_Module] m
	    ON [wl].[ModuleID] = [m].[ModuleID]JOIN [EC].[DIM_Site] st
	    ON [wl].[SiteID] = [st].[SiteID]
	 	Where [wl].[FormName] = '''+@strFormIDin+'''
Order By [wl].[FormName]'
		

EXEC (@nvcSQL)
--Print (@nvcSQL)

	    
END --sp_SelectReviewFrom_Warning_Log





GO





******************************************************************


--4. Create SP  [EC].[sp_SelectReviewFrom_Warning_Log_Reasons]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectReviewFrom_Warning_Log_Reasons' 
)
   DROP PROCEDURE [EC].[sp_SelectReviewFrom_Warning_Log_Reasons]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	08/26/2014
--	Description: 	This procedure displays the Warning Log Reason and Sub Coaching Reason values for 
--  a given Form Name.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectReviewFrom_Warning_Log_Reasons] @strFormIDin nvarchar(50)
AS

BEGIN
	DECLARE	

	@nvcSQL nvarchar(max),
	@intWarningID INT

 
SET @intWarningID = (SELECT WarningID From [EC].[Warning_Log]where[FormName]=@strFormIDin)


SET @nvcSQL = 'SELECT cr.CoachingReason, scr.SubCoachingReason, wlr.value
FROM [EC].[Warning_Log_Reason] wlr join [EC].[DIM_Coaching_Reason] cr
ON[wlr].[CoachingReasonID] = [cr].[CoachingReasonID]Join [EC].[DIM_Sub_Coaching_Reason]scr
ON [wlr].[SubCoachingReasonID]= [scr].[SubCoachingReasonID]
Where WarningID = '''+CONVERT(NVARCHAR(20),@intWarningID) + '''
ORDER BY cr.CoachingReason,scr.SubCoachingReason,wlr.value'

		
EXEC (@nvcSQL)	
--Print (@nvcSQL)
	    
END --sp_SelectReviewFrom_Warning_Log_Reasons
GO



******************************************************************

--5. Create SP  [EC].[sp_SelectFrom_Warning_Log_CSRCompleted]
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Warning_Log_CSRCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Warning_Log_CSRCompleted]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	10/07/2014
--  Description: Displays the list of warning logs in the CSR dashboard.
-- Last Modified Date: 
-- Last Updated By: 

--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Warning_Log_CSRCompleted] @strCSRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@nvcEmpID Nvarchar(10),
@dtmDate datetime

SET @strFormStatus = 'Completed'
SET @dtmDate  = GETDATE()   
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@strCSRin,@dtmDate)

SET @nvcSQL = 'SELECT [wl].[FormName] strFormID,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName,
		[eh].[Mgr_Name]	strCSRMgrName,
		[S].[Status]	strFormStatus,
		[wl].[SubmittedDate] SubmittedDate
FROM [EC].[Employee_Hierarchy] eh join [EC].[Warning_Log] wl
ON eh.Emp_ID = wl.EmpID join [EC].[DIM_Status] s
ON wl.StatusiD = s.StatusID
Where eh.[Emp_LanID] = '''+@strCSRin+'''
and [S].[Status] = '''+@strFormStatus+'''
and wl.Active = 1
and (wl.EmpID = '''+@nvcEmpID+''' and wl.EmpID <> ''999999'')
Order By [wl].[SubmittedDate] DESC'

		
EXEC (@nvcSQL)	
END -- sp_SelectFrom_Warning_Log_CSRCompleted



GO





******************************************************************

--6. Create SP  [EC].[sp_SelectFrom_Warning_Log_SUPCSRCompleted] 


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Warning_Log_SUPCSRCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Warning_Log_SUPCSRCompleted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	10/09/2014
--	Description: *	This procedure selects the CSR Warning records from the Warning_Log table
-- Last Modified Date: 12/02/2014
-- Last Updated By: Susmitha Palacherla
-- Modified to add functionality for acting managers during testing of SCR 13542.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Warning_Log_SUPCSRCompleted] 
@strCSRSUPin nvarchar(30),
@strSDatein datetime,
@strEDatein datetime,
@bitActive nvarchar(1)

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strSDate nvarchar(8),
@strEDate nvarchar(8),
@nvcSupID Nvarchar(10),
@dtmDate datetime

Set @strFormStatus = 'Completed'
Set @strSDate = convert(varchar(8),@strSDatein,112)
Set @strEDate = convert(varchar(8),@strEDatein,112)
Set @dtmDate  = GETDATE()   
Set @nvcSupID = EC.fn_nvcGetEmpIdFromLanID(@strCSRSUPin,@dtmDate)

SET @nvcSQL = 'SELECT	[wl].[FormName]	strFormID,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName, 
		[eh].[Mgr_Name]	strCSRMgrName, 
		[s].[Status]	strFormStatus,
		[sc].[SubCoachingSource]	strSource,
		[wl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh join  [EC].[Warning_Log] wl 
ON [wl].[EmpID] = [eh].[Emp_ID] JOIN  [EC].[DIM_Status]s
ON [wl].[StatusID] = [s].[StatusID] JOIN [EC].[DIM_Source]sc
ON [wl].[SourceID] = [sc].[SourceID]
WHERE ([eh].[Sup_LanID] =  '''+@strCSRSUPin+''' OR [eh].[Mgr_LanID] = '''+@strCSRSUPin+''')
and [s].[Status] = '''+@strFormStatus+'''
and convert(varchar(8),[wl].[SubmittedDate],112) >= '''+@strSDate+'''
and convert(varchar(8),[wl].[SubmittedDate],112) <= '''+@strEDate+'''
and [wl].[Active] like '''+ CONVERT(NVARCHAR,@bitActive) + '''
and ((eh.Sup_ID = '''+@nvcSupID+''' and eh.Sup_ID <> ''999999'')OR (eh.Mgr_ID = '''+@nvcSupID+''' and eh.Mgr_ID <> ''999999''))
Order By [wl].[SubmittedDate] DESC'

	
EXEC (@nvcSQL)	
--PRINT @nvcSQL
	    
END --sp_SelectFrom_Warning_Log_SUPCSRCompleted





GO





******************************************************************


--7. Create SP  [EC].[sp_SelectFrom_Warning_Log_MGRCSRCompleted] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Warning_Log_MGRCSRCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Warning_Log_MGRCSRCompleted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	10/09/2014
--	Description: *	This procedure selects the CSR Warning records from the Warning_Log table
-- Last Modified Date: 
-- Last Updated By: 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Warning_Log_MGRCSRCompleted] 
@strCSRMGRin nvarchar(30),
@strSDatein datetime,
@strEDatein datetime,
@bitActive nvarchar(1)
 
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strSDate nvarchar(8),
@strEDate nvarchar(8),
@nvcMgrID Nvarchar(10),
@dtmDate datetime

Set @strFormStatus = 'Completed'
Set @strSDate = convert(varchar(8),@strSDatein,112)
Set @strEDate = convert(varchar(8),@strEDatein,112)
Set @dtmDate  = GETDATE()   
Set @nvcMgrID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)
 

SET @nvcSQL = 'SELECT	[wl].[FormName]	strFormID,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName, 
		[eh].[Mgr_Name]	strCSRMgrName, 
		[s].[Status]	strFormStatus,
		[sc].[SubCoachingSource]	strSource,
		[wl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh join  [EC].[Warning_Log] wl 
ON [wl].[EmpID] = [eh].[Emp_ID] JOIN  [EC].[DIM_Status]s
ON [wl].[StatusID] = [s].[StatusID] JOIN [EC].[DIM_Source]sc
ON [wl].[SourceID] = [sc].[SourceID]
WHERE ([eh].[Mgr_LanID] = '''+@strCSRMGRin+''' OR [eh].[Sup_LanID] = '''+@strCSRMGRin+''')
and [s].[Status] = '''+@strFormStatus+'''
and convert(varchar(8),[wl].[SubmittedDate],112) >= '''+@strSDate+'''
and convert(varchar(8),[wl].[SubmittedDate],112) <= '''+@strEDate+'''
and [wl].[Active] like '''+ CONVERT(NVARCHAR,@bitActive) + '''
and ((eh.Mgr_ID = '''+@nvcMgrID+''' and eh.Mgr_ID <> ''999999'')OR (eh.Sup_ID = '''+@nvcMgrID+''' and eh.Sup_ID <> ''999999''))
Order By [wl].[SubmittedDate] DESC'
	
EXEC (@nvcSQL)	
	   
END --sp_SelectFrom_Warning_Log_MGRCSRCompleted
GO


******************************************************************


--8. Create SP  [EC].[sp_InactivateExpiredWarningLogs] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InactivateExpiredWarningLogs ' 
)
   DROP PROCEDURE [EC].[sp_InactivateExpiredWarningLogs] 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		   Susmitha Palacherla
-- Create Date:    10/27/2014
-- Description:	Inactivate Expired warning logs.
-- Warning Logs are considered as expired 13 Weeks after the Warning Given Date.
-- Last Modified Date:
-- Last Updated By: 

-- =============================================
CREATE PROCEDURE [EC].[sp_InactivateExpiredWarningLogs] 
AS
BEGIN

-- Inactivate Expired Warning logs 
-- Warnings expire 91 days (13 weeks) from warningGivenDate

BEGIN
UPDATE [EC].[Warning_Log]
SET [Active] = 0
WHERE DATEDIFF(D, [WarningGivenDate],GetDate()) > 91
OPTION (MAXDOP 1)
END


END  -- [EC].[sp_InactivateExpiredWarningLogs]

GO




******************************************************************



--9. Create SP  [EC].[sp_SelectFrom_Coaching_Log_SRMGREmployeeWarning] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_SRMGREmployeeWarning' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SRMGREmployeeWarning] 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	03/05/2015
--	Description: *	This procedure selects all the Warning logs for Employees that fall under the Senior Manager 
--  in the Hierarchy table.
-- Last Modified Date: -- Last Modified Date: 04/17/2015
-- Last Updated By: 
-- Created per SCR 14423 to extend dashboard functionality to senior leadership.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SRMGREmployeeWarning] 
@strEMPSRMGRin nvarchar(30),
@strSDatein datetime,
@strEDatein datetime,
@bitActive nvarchar(1)

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strSDate nvarchar(8),
@strEDate nvarchar(8),
@strSrMgrEmpID Nvarchar(10),
@dtmDate datetime


Set @strFormStatus = 'Completed'
Set @strSDate = convert(varchar(8),@strSDatein,112)
Set @strEDate = convert(varchar(8),@strEDatein,112)
Set @dtmDate  = GETDATE()   
Set @strSrMgrEmpID = EC.fn_nvcGetEmpIdFromLanID(@strEMPSRMGRin,@dtmDate)


SET @nvcSQL = ';WITH SrHierarchy As
(SELECT Emp_ID, [EC].[fn_strSrMgrLvl1EmpIDFromEmpID]([H].[Emp_ID])as Lvl1Mgr,
[EC].[fn_strSrMgrLvl2EmpIDFromEmpID]([H].[Emp_ID])as Lvl2Mgr,
[EC].[fn_strSrMgrLvl3EmpIDFromEmpID]([H].[Emp_ID])as Lvl3Mgr 
From [EC].[Employee_Hierarchy]H WITH (NOLOCK)
)
SELECT [wl].[FormName]	strFormID,
		[eh].[Emp_Name]	strEmpName,
		[eh].[Sup_Name]	strEmpSupName, 
		[eh].[Mgr_Name]	strEmpMgrName, 
		[s].[Status]	strFormStatus,
		[sc].[SubCoachingSource] strSource,
		[wl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh WITH (NOLOCK) JOIN [EC].[Warning_Log] wl WITH (NOLOCK) ON
[wl].[EmpID] = [eh].[Emp_ID] Join [EC].[DIM_Status] s ON
[wl].[StatusID] = [s].[StatusID] JOIN  [EC].[DIM_Source] sc ON
[wl].[SourceID] = [sc].[SourceID] JOIN SrHierarchy ON
SrHierarchy.Emp_ID = [eh].[Emp_ID]
WHERE (SrHierarchy.Lvl1Mgr = '''+@strSrMgrEmpID+''' OR
SrHierarchy.Lvl2Mgr = '''+@strSrMgrEmpID+''' OR SrHierarchy.Lvl3Mgr = '''+@strSrMgrEmpID+''')
and [s].[Status] = '''+@strFormStatus+'''
and convert(varchar(8),[wl].[SubmittedDate],112) >= '''+@strSDate+'''
and convert(varchar(8),[wl].[SubmittedDate],112) <= '''+@strEDate+'''
and [wl].[Active] like '''+ CONVERT(NVARCHAR,@bitActive) + '''
and SrHierarchy.Lvl1Mgr <> ''999999''
and SrHierarchy.Lvl2Mgr <> ''999999'' 
and SrHierarchy.Lvl3Mgr <> ''999999''
ORDER BY submitteddate desc'

		
EXEC (@nvcSQL)
--Print @nvcSQL	   
END --sp_SelectFrom_Coaching_Log_SRMGREmployeeWarning

GO







******************************************************************



