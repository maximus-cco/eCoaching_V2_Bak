/*
eCoaching_Maintenance_Create(01).sql
Last Modified Date: 04/03/2014
Last Modified By: Susmitha Palacherla



Version 01: Initial Revision for redesign.

Summary

Tables
1. Create Table  [EC].[Migrated_Employees]
2. Create Table  [EC].[Historical_Dashboard_ACL]


Procedures
1. Create SP [EC].[sp_Update_Migrated_User_Logs] 
2. Create SP [EC].[sp_SelectCoaching4Contact] 
3. Create SP [EC].[sp_UpdateFeedMailSent] 
4. Create SP [EC].[sp_InsertInto_Historical_Dashboard_ACL] 
5. Create SP [EC].[sp_DeleteFromHistoricalDashboardACL] 
6. Create SP [EC].[sp_SelectFrom_Historical_Dashboard_ACL] 
7. Create SP [EC].[sp_UpdateHistorical_Dashboard_ACL] 
8. [EC].[sp_Check_AgentRole]

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

*********************************************************



--2. Create Table  [EC].[Historical_Dashboard_ACL]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Historical_Dashboard_ACL](
	[Row_ID] [int] IDENTITY(1,1) NOT NULL,
	[User_LanID] [nvarchar](30) NOT NULL,
	[User_Name] [nvarchar](30) NOT NULL,
	[Role] [nvarchar](30) NOT NULL,
	[End_Date] [nvarchar](10) NOT NULL,
	[Updated_By] [nvarchar](30) NULL,
	[IsAdmin] [nvarchar](1) NULL,
 CONSTRAINT [PK_Historical_Dashboard_ACL] PRIMARY KEY CLUSTERED 
(
	[Row_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[User_LanID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [EC].[Historical_Dashboard_ACL] ADD  DEFAULT (N'ECL') FOR [Role]
GO

ALTER TABLE [EC].[Historical_Dashboard_ACL] ADD  DEFAULT (N'99991231') FOR [End_Date]
GO

ALTER TABLE [EC].[Historical_Dashboard_ACL] ADD  DEFAULT (N'N') FOR [IsAdmin]
GO





**************************************************************



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


/****** Object:  StoredProcedure [EC].[sp_Update_Migrated_User_Logs]    Script Date: 01/15/2014 20:15:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		   Susmitha Palacherla
-- Create date: 04/05/2014
-- Description:	Updates historical Coaching logs for Migrated users

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
BEGIN
UPDATE [EC].[EmployeeID_To_LanID]
SET [LANID] = H.[Emp_LanID]
FROM [EC].[EmployeeID_To_LanID]L JOIN [EC].[Employee_Hierarchy]H
ON L.[EMPID] = H.[Emp_ID]
WHERE L.[LANID] <>  H.[Emp_LanID]
OPTION (MAXDOP 1)
END


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

SET @sentValue = 0 --1
SET @intNumID = CAST(@nvcNumID as INT)
   
  	UPDATE [EC].[Coaching_Log]
	   SET EmailSent = @sentValue
	WHERE CoachingID = @intNumID
	
END --sp_UpdateFeedMailSent
GO


***************************************************************************************************************

-4. Create SP  [EC].[sp_InsertInto_Historical_Dashboard_ACL] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Historical_Dashboard_ACL' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_Historical_Dashboard_ACL]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--    ====================================================================
--    Author:                 Susmitha Palacherla
--    Create Date:     09/06/2012
--    Description:     This procedure inserts user records into the Historical_Dashboard_ACL table. 
--	  Last Update:	10/18/2013
--    last Modified by: Susmitha Palacherla
--    Modified per SCR 10617 to removed hard coded authorized users and look at the Isadmin flag in the ACL Table.
--    =====================================================================
CREATE PROCEDURE [EC].[sp_InsertInto_Historical_Dashboard_ACL]
  (
    @nvcACTION Nvarchar(10),
	@nvcLANID	Nvarchar(30),
	@nvcUserLANID	Nvarchar(30),
	@nvcRole	Nvarchar(30),
	@nvcErrorMsgForEndUser Nvarchar(180) OUT

)
AS
BEGIN
	

	DECLARE @nvcHierarchyLevel	Nvarchar(20),
	        @nvcSQL Nvarchar(max),
	        @ROWID int,
	        @ENDDATE nvarchar(10),
	        @nvcIsAdmin Nvarchar(1)
	SET @nvcErrorMsgForEndUser = N''


   -- Removing the domain name from the Lanid.
	  SET @nvcLANID = SUBSTRING(@nvcLANID, CHARINDEX('\', @nvcLANID) + 1, LEN(@nvcLANID))
   -- Checking the App Role of the User
	  SET @nvcIsAdmin = (SELECT CASE WHEN End_Date = '99991231' THEN [ISADMIN] ELSE 'N'  END
                        FROM [EC].[Historical_Dashboard_ACL]WHERE [User_LanID] = @nvcLANID)
	  
	
			
--	Checking if the Inserter is authorized to insert.

IF @nvcIsAdmin = 'Y'
BEGIN

      IF @nvcACTION = 'ADD'  
      BEGIN
      
           IF EXISTS (SELECT Emp_LANID From [EC].[Employee_Hierarchy] WHERE Emp_LANID = @nvcUserLANID)
           BEGIN
           
			SELECT @ROWID = ROW_ID from [EC].[Historical_Dashboard_ACL]
			WHERE [User_LanID]=@nvcUserLANID
			
			SELECT @ENDDATE = End_Date from [EC].[Historical_Dashboard_ACL]
			WHERE [User_LanID]=@nvcUserLANID
						
                IF @ROWID IS NULL 
                BEGIN
                        					  
							 INSERT INTO [EC].[Historical_Dashboard_ACL]
							 ([User_LanID]
							 ,[User_Name]
							 ,[Role]
							 ,[Updated_By])
							 VALUES
							 (@nvcUserLanID ,EC.fn_strUserName(@nvcUserLanID),
							 @nvcRole, @nvcLANID
							  ) 
			SET @nvcErrorMsgForEndUser = N'Requested user ' + EC.fn_strUserName(@nvcUserLanID) + N' successfully added.'
			     END   --@ROWID IS NULL 			    			     
			ELSE
			
			IF @ENDDATE = '99991231'
				BEGIN
				SET @nvcErrorMsgForEndUser = N'Requested user ' + EC.fn_strUserName(@nvcUserLanID) + N' already exists in the system. You may select the existing record and update the Role.'
				END --@ENDDATE = '99991231'
			ELSE
			IF @ENDDATE <> '99991231'
				BEGIN
				UPDATE [EC].[Historical_Dashboard_ACL]
				SET End_Date = '99991231' ,
				    [Role]= @nvcRole
				WHERE [User_LanID]=@nvcUserLANID
				SET @nvcErrorMsgForEndUser = N'Requested user ' + EC.fn_strUserName(@nvcUserLanID) + N' has been Re-activated as an ' + @nvcRole + N' user.'
			END --@ENDDATE <> '99991231'
						 
			END	
			
			
			     ELSE
			     BEGIN
			     SET @nvcErrorMsgForEndUser = N'Requested user ' + @nvcUserLANID + N' is not a valid user'
			    
			     END --EXISTS @nvcUserLANID
		END	--@nvcACTION = 'ADD'  		
     ELSE
 
 
    IF @nvcACTION = 'REMOVE'  
         UPDATE [EC].[Historical_Dashboard_ACL]
         SET [END_DATE] = CONVERT(nvarchar(10),getdate(),112),
         [Updated_By] = @nvcLANID 
         Where User_LanID = @nvcUserLANID
    
    
	 END --@nvcACTION = 'REMOVE' 
 
ELSE		
		
BEGIN
SET @nvcErrorMsgForEndUser = N'Requester ' + @nvclanid + N' is not authorized to ADD/REMOVE Records.'

END	--@nvcIsAdmin = 'Y'		
	
END --sp_InsertInto_Historical_Dashboard_ACL
GO



***************************************************************************************************************

-5. Create SP  [EC].[sp_DeleteFromHistoricalDashboardACL] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_DeleteFromHistoricalDashboardACL' 
)
   DROP PROCEDURE [EC].[sp_DeleteFromHistoricalDashboardACL]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	09/19/2012
--	Description: 	Delete record from Historical dashboard ACL table 
--	Last Update:	09/18/2013
-- last Modified by: Susmitha Palacherla
-- Modified per SCR 10617 to removed hard coded authorized users and look at the Isadmin flag in the ACL Table.
--	=====================================================================

CREATE PROCEDURE [EC].[sp_DeleteFromHistoricalDashboardACL]
  (
    @nvcACTION Nvarchar(10),
	@nvcLANID	Nvarchar(30),
	@nvcUserLANID	Nvarchar(30),
	@nvcRole	Nvarchar(20) = NULL,
	@nvcErrorMsgForEndUser Nvarchar(180) OUT
)
AS
BEGIN
	

	DECLARE @nvcHierarchyLevel	Nvarchar(20),
            @nvcSQL Nvarchar(max),
	        @ROWID int,
	        @nvcIsAdmin Nvarchar(1)
	        
	SET @nvcErrorMsgForEndUser = N''	

   -- Removing the domain name from the Lanid.
	  SET @nvcLANID = SUBSTRING(@nvcLANID, CHARINDEX('\', @nvcLANID) + 1, LEN(@nvcLANID))
   -- Checking the App Role of the User
	  SET @nvcIsAdmin = (SELECT CASE WHEN End_Date = '99991231' THEN [ISADMIN] ELSE 'N'  END
                        FROM [EC].[Historical_Dashboard_ACL]WHERE [User_LanID] = @nvcLANID)
	  

	
--	Checking if the User is authorized to remove.

IF @nvcIsAdmin = 'Y'
BEGIN
  
   IF @nvcACTION = 'REMOVE'  
         UPDATE [EC].[Historical_Dashboard_ACL]
         SET [END_DATE] = CONVERT(nvarchar(10),getdate(),112),
         [Updated_By] = @nvcLANID 
         Where User_LanID = @nvcUserLANID
   ELSE
       SET @nvcErrorMsgForEndUser = N'Action ' + @nvcACTION + N' is not an acceptable action.'
    END --@nvcACTION = 'REMOVE' 
ELSE		
		
BEGIN
     SET @nvcErrorMsgForEndUser = N'Requester ' + @nvclanid + N' is not authorized to ADD/REMOVE Records.'
END	-- @nvcIsAdmin = 'Y'		
	
END --sp_DeleteFromHistoricalDashboardACL
GO

***************************************************************************************************************

-6. Create SP  [EC].[sp_SelectFrom_Historical_Dashboard_ACL] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Historical_Dashboard_ACL' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Historical_Dashboard_ACL]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	09/2012
--	Last Update:	<>
--	Description: *	This procedure selects the user records from the Historical_Dashboard_ACL table
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Historical_Dashboard_ACL] 

(
 @nvcRole Nvarchar(30)
)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max)


SET @nvcSQL = 'SELECT [Row_ID],[User_LanID],[User_Name],[Role]
FROM [EC].[Historical_Dashboard_ACL]
where (Role = '''+@nvcRole+''' AND End_Date > getdate())
Order by [User_LanID]'
		
EXEC (@nvcSQL)		
	    
END -- sp_SelectFrom_Historical_Dashboard_ACL
GO



***************************************************************************************************************

-7. Create SP  [EC].[sp_UpdateHistorical_Dashboard_ACL] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_UpdateHistorical_Dashboard_ACL' 
)
   DROP PROCEDURE [EC].[sp_UpdateHistorical_Dashboard_ACL]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--    ====================================================================
--    Author:                 Jourdain Augustin
--    Create Date:      <09/20/12>
--    Last Update:      <>
--    Description: *    This procedure allows supervisors to update the e-Coaching records from review page. 
--    =====================================================================
CREATE PROCEDURE [EC].[sp_UpdateHistorical_Dashboard_ACL]
(
      @nvcRowID Nvarchar(30),
      @nvcLANID Nvarchar(30),
      @nvcUserLANID Nvarchar(30),
      @nvcRole Nvarchar(30)
       --UNUSED PARAMETERS
  --  @nvcRole VARCHAR(30) = NULL

)
AS
BEGIN
            
       UPDATE [EC].[Historical_Dashboard_ACL]
	   SET [User_LanID] = @nvcUserLANID, [Role] = @nvcRole, [User_Name] = EC.fn_strUserName(@nvcUserLANID),
	   [Updated_By] = @nvcLANID
	   WHERE Row_ID = @nvcRowID
  
END -- sp_UpdateHistorical_Dashboard_ACL
GO

***************************************************************************************************



--8. Create SP  [EC].[sp_Check_AgentRole]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Check_AgentRole' 
)
   DROP PROCEDURE [EC].[sp_Check_AgentRole]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure returns the Row_ID from the ACl table if agent belongs to the role being checked. 
--  Last Update:    03/12/2014 - Updated per SCR 12359 to add NOLOCK Hint
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Check_AgentRole]
(
 @nvcLANID	Nvarchar(30),
 @nvcRole	Nvarchar(30)
)
AS
Declare
 @ROWID INT

BEGIN

	SELECT @ROWID = [Row_ID]
	FROM  [EC].[Historical_Dashboard_ACL] WITH(NOLOCK)
	WHERE  [User_LanID] = @nvcLANID
	AND [Role]= @nvcRole
	AND [End_Date]='99991231'


IF @ROWID IS NULL RETURN 0
ELSE
RETURN 	 @ROWID	
    
END
GO


******************************************************************

