/*
eCoaching_Maintenance_Create(03).sql
Last Modified Date: 06/30/2014
Last Modified By: Susmitha Palacherla

Version 03: 
1. Updated [EC].[sp_Update_Migrated_User_Logs] per SCR 12982 
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
1. Create Table  [EC].[Migrated_Employees]



Procedures
1. Create SP [EC].[sp_Update_Migrated_User_Logs] 
2. Create SP [EC].[sp_SelectCoaching4Contact] 
3. Create SP [EC].[sp_UpdateFeedMailSent] 


*/


 --Details

**************************************************************
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




**************************************************************

--Procedures

**************************************************************

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
-- Last Modified By: Susmitha Palacherela
-- Last Modified Date: 06/30/2014
-- Updated per SCR 12982 to remove update to Employee ID To Lan ID table
-- until correct logic can be identified.

-- =============================================
CREATE PROCEDURE [EC].[sp_Update_Migrated_User_Logs] 
AS
BEGIN

-- Update CSR value in Coaching logs for migrated users
BEGIN
UPDATE [EC].[Coaching_Log]
SET [CSR] = H.[Emp_LanID]
FROM [EC].[Coaching_Log]F JOIN [EC].[Employee_Hierarchy]H
ON F.[CSRID] = H.[Emp_ID]
WHERE F.[CSR] <>  H.[Emp_LanID]
OPTION (MAXDOP 1)
END



-- Update Lan ID value in Employee ID To Lan ID table for migrated users
/*
BEGIN
UPDATE [EC].[EmployeeID_To_LanID]
SET [LANID] = H.[Emp_LanID]
FROM [EC].[EmployeeID_To_LanID]L JOIN [EC].[Employee_Hierarchy]H
ON L.[EMPID] = H.[Emp_ID]
WHERE L.[LANID] <>  H.[Emp_LanID]
OPTION (MAXDOP 1)
END
*/
END  -- [EC].[sp_Update_Migrated_User_Logs]


GO







******************************************************************

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
--  Last Modified by:  Susmitha Palacherla
--	Last Modified Date:9/19/2013
--  SCR 11051 to add numid to select list and numid length check to where clause.
--	Last Modified Date: 3/28/2013 - Adapted for new eCoaching DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectCoaching4Contact]
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus1 nvarchar(30),
@strFormStatus2 nvarchar(30),
@strSource nvarchar(30),
@strSource2 nvarchar(30),
@strFormType nvarchar(30),
@strFormMail nvarchar (30)

 Set @strFormStatus1 = 'Completed'
 Set @strFormStatus2 = 'Inactive'
 Set @strSource = 'OMR'
 Set @strSource2 = 'IQS'
 
 Set @strFormType = 'Indirect'
--Set @strFormMail = 'jourdain.augustin@gdit.com'
 
SET @nvcSQL = 'SELECT   cl.CoachingID	numID	
		,cl.FormName	strFormID
		,s.Status		strFormStatus
		,eh.Emp_Email	strCSREmail
		,eh.Sup_Email	strCSRSupEmail
		,eh.Mgr_Email	strCSRMgrEmail
		,so.SubCoachingSource	strSource
		,eh.Emp_Name	strCSRName
		,so.CoachingSource	strFormType
		,cl.SubmittedDate	SubmittedDate
		,cl.CoachingDate	CoachingDate
		,cl.EmailSent	EmailSent
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl,
	 [EC].[DIM_Source] so,
	 [EC].[Coaching_Log_Reason] clr
WHERE cl.CSRID = eh.Emp_ID
AND cl.StatusID = s.StatusID
AND cl.SourceID = so.SourceID
AND cl.CoachingID = clr.CoachingID
AND S.Status <> '''+@strFormStatus1+'''
AND S.Status <> '''+@strFormStatus2+'''
AND ([so].[SubCoachingSource] Like '''+@strSource+'%'' OR [so].[SubCoachingSource] LIKE '''+@strSource2+'%'') 
AND cl.EmailSent = ''False''
AND ((so.CoachingSource =''Pending Acknowledgement'' and eh.Emp_Email is NOT NULL and eh.Sup_Email is NOT NULL)
OR (s.Status =''Pending Supervisor Review'' and eh.Sup_Email is NOT NULL)
OR (s.Status =''Pending Manager Review'' and eh.Mgr_Email is NOT NULL)
OR (s.Status =''Pending CSR Review'' and eh.Emp_Email is NOT NULL))
AND LEN(cl.FormName) > 10
Order By cl.SubmittedDate DESC'


--and [strCSREmail] = '''+@strFormMail+'''
EXEC (@nvcSQL)	
	    
END -- sp_SelectCoaching4Contact
GO

***************************************************************************************************************


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


***************************************************************************************************************

