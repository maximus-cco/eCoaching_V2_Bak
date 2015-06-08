/*
eCoaching_Maintenance_Create(10).sql
Last Modified Date: 06/08/2015
Last Modified By: Susmitha Palacherla

Version 10: 
1. Updated SP #5 [EC].[sp_SelectReviewFrom_Coaching_Log_For_Delete] per SCR 14478
to add label CoachingID for Coaching or Warning Log.

Version 09: 
1. Added SP #5 [EC].[sp_SelectReviewFrom_Coaching_Log_For_Delete] per SCR 14478.

Version 08: 
1. Updated SP #2 [EC].[sp_SelectCoaching4Contact] to support LCSAT feed per SCR 14818.


Version 07: 
1. Changes for SCR 14634 Inactivations from Feed.
   Added Create for new table [EC].[Inactivations_Stage]
   Added New procedure  #4 [EC].[sp_Inactivations_From_Feed] 
   Marked Table #1 and SP #1 as obsolete.

Version 06: 
1. Updated SP #2 [EC].[sp_SelectCoaching4Contact] to add source IDs 222,223,224
    for new Quality sources for SCR 13826.

Version 05: 
1. Updated SP #2 [EC].[sp_SelectCoaching4Contact] to add source ID 221
    for new ETS feed per SCR 13659.

Version 04: 
1. Updated procedure impacted by the Phase II Modular design.


Version 03: 
1. Updated SP # 1[EC].[sp_Update_Migrated_User_Logs] per SCR 12982 
    to remove updates to Employee ID To Lan ID table until correct logic can be identified.
2. Removed historical dashboard related code which is being maintained in code doc
    CCO_eCoaching_Historical_Dashboard_Create.sql.


Version 02: 
1. Updated PROCEDURE [EC].[sp_UpdateFeedMailSent]
    to set @sentValue to 1 per SCR 12957.


Version 01: 
1. Initial Revision for redesign.

Summary

Tables
1. Create Table  [EC].[Migrated_Employees] -- Obsolete
2. Create Table [EC].[Inactivations_Stage]



Procedures
1. Create SP [EC].[sp_Update_Migrated_User_Logs] -- Obsolete
2. Create SP [EC].[sp_SelectCoaching4Contact] 
3. Create SP [EC].[sp_UpdateFeedMailSent] 
4. Create SP [EC].[sp_Inactivations_From_Feed] 
5. Create SP [EC].[sp_SelectReviewFrom_Coaching_Log_For_Delete]

*/


 --Details

/**************************************************************
--Tables
**************************************************************

--1. Create Table  [EC].[Migrated_Employees]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Migrated_Employees](
	[Emp_ID] [nvarchar](20) NOT NULL,
	[Emp_VNGT_LanID] [nvarchar](30) NULL,
	[Emp_AD_LanID] [nvarchar](30) NULL,
	[Emp_Name] [nvarchar](70) NULL,
	[Emp_Email] [nvarchar](50) NULL
) ON [PRIMARY]

GO


--2. Create Table [EC].[Inactivations_Stage]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Inactivations_Stage](
	[FormName] [nvarchar](50) NULL,
	[Message] [nvarchar](100) NULL,
	[ProcessDate] [datetime] NULL
) ON [PRIMARY]

GO


--**************************************************************/

--Procedures

--**************************************************************

--1. Create SP  [EC].[sp_Update_Migrated_User_Logs] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update_Migrated_User_Logs' 
)
   DROP PROCEDURE [EC].[sp_Update_Migrated_User_Logs]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		   Susmitha Palacherla
-- Create date: 04/05/2014
-- Description:	Updates historical Coaching logs for Migrated users
-- Last Modified Date: 08/13/2014
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSR and CSRID to EmpLanID and EmpID to support the Modular design.

-- =============================================
CREATE PROCEDURE [EC].[sp_Update_Migrated_User_Logs] 
AS
BEGIN

-- Update CSR value in Coaching logs for migrated users
BEGIN
UPDATE [EC].[Coaching_Log]
SET [EmpLanID] = H.[Emp_LanID]
FROM [EC].[Coaching_Log]F JOIN [EC].[Employee_Hierarchy]H
ON F.[EmpID] = H.[Emp_ID]
WHERE F.[EmpLanID] <>  H.[Emp_LanID]
AND H.[Emp_LanID] is not NULL AND H.[Emp_LanID] <> ''
OPTION (MAXDOP 1)
END

END  -- [EC].[sp_Update_Migrated_User_Logs]
GO



--******************************************************************

-2. Create SP  [EC].[sp_SelectCoaching4Contact] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectCoaching4Contact' 
)
   DROP PROCEDURE [EC].[sp_SelectCoaching4Contact]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:		       Jourdain Augustin
--	Create Date:	   6/10/13
--	Description: 	   This procedure queries db for feed records to send out mail
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date:  05/14/2015
-- Updated per SCR 14818 to support rotating managers for Low CSAT
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectCoaching4Contact]
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus1 nvarchar(30),
@strFormStatus2 nvarchar(30),
@intSource1 int,
@intSource2 int,
@strFormType nvarchar(30),
@strFormMail nvarchar (30)

 --Set @strFormStatus1 = 'Completed'
 --Set @strFormStatus2 = 'Inactive'


 --Set @strFormType = 'Indirect'
--Set @strFormMail = 'jourdain.augustin@gdit.com'
 
SET @nvcSQL = 'SELECT   cl.CoachingID	numID	
		,cl.FormName	strFormID
		,s.Status		strFormStatus
		,eh.Emp_Email	strCSREmail
		,eh.Sup_Email	strCSRSupEmail
		,CASE WHEN cl.[strReportCode] like ''LCS%'' 
		 THEN [EC].[fn_strEmpEmailFromEmpID](cl.[MgrID])
		 ELSE eh.Mgr_Email END	strCSRMgrEmail
		,so.SubCoachingSource	strSource
		,eh.Emp_Name	strCSRName
		,so.CoachingSource	strFormType
		,cl.SubmittedDate	SubmittedDate
		,cl.CoachingDate	CoachingDate
		,cl.EmailSent	EmailSent
		,cl.sourceid
		,cl.isCSE
		,mo.Module
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH (NOLOCK)
ON eh.Emp_ID = cl.EMPID JOIN [EC].[DIM_Status] s 
ON s.StatusID = cl.StatusID JOIN [EC].[DIM_Source] so
ON so.SourceID = cl.SourceID JOIN [EC].[DIM_Module] mo
ON mo.ModuleID = cl.ModuleID
WHERE S.Status not in (''Completed'',''Inactive'')
AND cl.SourceID in (211,212,221,222,223,224)
AND cl.EmailSent = ''False''
AND ((s.status =''Pending Acknowledgement'' and eh.Emp_Email is NOT NULL and eh.Sup_Email is NOT NULL)
OR (s.Status =''Pending Supervisor Review'' and eh.Sup_Email is NOT NULL)
OR (s.Status =''Pending Manager Review'' and eh.Mgr_Email is NOT NULL)
OR (s.Status =''Pending Employee Review'' and eh.Emp_Email is NOT NULL))
AND LEN(cl.FormName) > 10
Order By cl.SubmittedDate DESC'
--and [strCSREmail] = '''+@strFormMail+'''
EXEC (@nvcSQL)	
	    
END --sp_SelectCoaching4Contact

GO










--***************************************************************************************************************


-3. Create SP  [EC].[sp_UpdateFeedMailSent] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_UpdateFeedMailSent' 
)
   DROP PROCEDURE [EC].[sp_UpdateFeedMailSent]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--    ====================================================================
--    Author:           Jourdain Augustin
--    Create Date:      08/23/13
--    Description:      This procedure updates emailsent column to "True" for records from mail script. 
--    Last Update:      <>
--    Last Update:      03/27/2014 - Modified for redesigned DB
--    =====================================================================
CREATE PROCEDURE [EC].[sp_UpdateFeedMailSent]
(
      @nvcNumID nvarchar(30)
 
)
AS
BEGIN
DECLARE
@sentValue nvarchar(30),
@intNumID int

SET @sentValue = 1
SET @intNumID = CAST(@nvcNumID as INT)
   
  	UPDATE [EC].[Coaching_Log]
	   SET EmailSent = @sentValue
	WHERE CoachingID = @intNumID
	
END --sp_UpdateFeedMailSent
GO


--***************************************************************************************************************

-4. Create SP [EC].[sp_Inactivations_From_Feed] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Inactivations_From_Feed' 
)
   DROP PROCEDURE [EC].[sp_Inactivations_From_Feed]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		   Susmitha Palacherla
-- Create Date:    04/22/2015
-- Description:	Inactivate Coaching and Warning logs from feed files.
-- Initial revision per SCR 14634.
-- =============================================
CREATE PROCEDURE [EC].[sp_Inactivations_From_Feed] 
@strLogType nvarchar(20)
AS
BEGIN



 IF @strLogType = 'Coaching'
 -- Coaching logs 
 -- Set Message for Invalid Form Names

BEGIN
UPDATE [EC].[Inactivations_Stage]
SET [Message] = 'Form Name does not Exist.'
,[ProcessDate] = GETDATE()
WHERE [FormName] NOT IN 
(SELECT DISTINCT FormName FROM [EC].[Coaching_Log] C WITH (NOLOCK))
OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

 -- Set Message for Invalid Status

BEGIN
UPDATE [EC].[Inactivations_Stage]
SET [Message] = 'Invalid Status for Inactivation.'
,[ProcessDate] = GETDATE()
FROM [EC].[Inactivations_Stage] I JOIN [EC].[Coaching_Log] C 
ON I.[FormName]= C.[FormName]
WHERE C.[StatusID] IN (1,2)
OPTION (MAXDOP 1)
END


WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms


-- Inactivate Coaching logs 

BEGIN
UPDATE [EC].[Coaching_Log]
SET [StatusID] = 2
FROM [EC].[Inactivations_Stage] I JOIN [EC].[Coaching_Log] C 
ON I.[FormName]= C.[FormName]
WHERE C.[StatusID] NOT IN (1,2)
OPTION (MAXDOP 1)
END



WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

 -- Set Message for Inactivated logs

BEGIN
UPDATE [EC].[Inactivations_Stage]
SET [Message] = 'Successful'
,[ProcessDate] = GETDATE()
FROM [EC].[Inactivations_Stage] I JOIN [EC].[Coaching_Log] C 
ON I.[FormName]= C.[FormName]
WHERE C.[StatusID] = 2
AND [Message] IS NULL
OPTION (MAXDOP 1)
END


WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

 IF @strLogType = 'Warning'
 
  -- Warning logs 
 -- Set Message for Invalid Form Names

BEGIN
UPDATE [EC].[Inactivations_Stage]
SET [Message] = 'Form Name does not Exist.'
,[ProcessDate] = GETDATE()
WHERE [FormName] NOT IN 
(SELECT DISTINCT FormName FROM [EC].[Warning_Log] C WITH (NOLOCK))
OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

 -- Set Message for Invalid Status

BEGIN
UPDATE [EC].[Inactivations_Stage]
SET [Message] = 'Invalid Status for Inactivation.'
,[ProcessDate] = GETDATE()
FROM [EC].[Inactivations_Stage] I JOIN [EC].[Warning_Log] W 
ON I.[FormName]= W.[FormName]
WHERE W.[StatusID] <> 1
OPTION (MAXDOP 1)
END


WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms


-- Inactivate Coaching logs 

BEGIN
UPDATE [EC].[Warning_Log]
SET [StatusID] = 2
FROM [EC].[Inactivations_Stage] I JOIN [EC].[Warning_Log]W
ON I.[FormName]= W.[FormName]
WHERE W.[StatusID] <> 2
OPTION (MAXDOP 1)
END


WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

 -- Set Message for Inactivated logs

BEGIN
UPDATE [EC].[Inactivations_Stage]
SET [Message] = 'Successful'
,[ProcessDate] = GETDATE()
FROM [EC].[Inactivations_Stage] I JOIN [EC].[Warning_Log] W
ON I.[FormName]= W.[FormName]
WHERE W.[StatusID] = 2
AND [Message] IS NULL
OPTION (MAXDOP 1)
END


WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms
END  -- [EC].[sp_Inactivations_From_Feed]

GO

--***************************************************************************************************************



-5. Create SP[EC].[sp_SelectReviewFrom_Coaching_Log_For_Delete]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectReviewFrom_Coaching_Log_For_Delete' 
)
   DROP PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log_For_Delete]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	05/04/2015
--	Description: 	This procedure displays the Coaching Log attributes for given Form Name.
--  Initial Revision per SCR 14478.

--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log_For_Delete] @strFormIDin nvarchar(50)
AS

BEGIN
DECLARE	

@intCoachID bigint,
@nvcSQL nvarchar(max)

SET @intCoachID = (SELECT  [CoachingID] FROM  [EC].[Coaching_Log] WITH (NOLOCK)
	 	WHERE [FormName] = @strFormIDin)
	 	
IF 	 @intCoachID IS NOT NULL

  SET @nvcSQL = 'SELECT  [CoachingID]CoachingID,
			[FormName],
			[EmpLanID],
			[EmpID],
			[SourceID]
		FROM  [EC].[Coaching_Log] WITH (NOLOCK)
	 	WHERE [FormName] = '''+@strFormIDin+''''
	 
ELSE

  SET @nvcSQL = 'SELECT  [WarningID]CoachingID,
			[FormName],
			[EmpLanID],
			[EmpID],
			[SourceID]
		FROM  [EC].[Warning_Log] WITH (NOLOCK)
	 	WHERE [FormName] = '''+@strFormIDin+''''
	 		

EXEC (@nvcSQL)
--Print (@nvcSQL)
	    
END --sp_SelectReviewFrom_Coaching_Log_For_Delete



GO






--***************************************************************************************************************