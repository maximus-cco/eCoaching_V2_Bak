/*
eCoaching_Admin_Tool_Create(06).sql
Last Modified Date:09/20/2016
Last Modified By: Susmitha Palacherla

Version 06: Added records for additional admin users with jobcode WACQ13 per tfs 3877 - 09/20/2016
Tables #4,6,11

Version 05: Updates to SPs #3,4,13,14,15 per TFS 3441 to change functionality for inactive users - 09/09/2016

Version 04: Update to SP #16 per TFS 3416 to remove refernce to jobcode WISY13 - 07/26/2016

Version 03: Update to SP #3 per TFS 3091- 07/06/2016


Version 02: Updates from testing . TFS 1709 Admin tool setup - 6/10/2016

1. Additional rows in Tables #7,#8 and #10
2. Updated comments and Reason field sizes in tables #1,#2 and #3
3. Updated comments and Reason field sizes in procedures #1,#2 and #12
4. Updates to following procedures;
   #3 and #4 - select employees for inactivate/reactivate - Add restriction to not display logged in user.
   #6 -  select logs inactivate/reactivate - Add module filter.Show assigned user. Return lastknown status value.
   #9 -  select modules by lanid - resolve coaching user and warning admin conflict. Display all modules for coaching admin.
   #13 - Select reassign from users - logged in user sup vs mgr conflict
   #14 - select reassign to users - remove status filter
   #15 - Select logs reassign - Display assigned reviewer and add sup or mgr logic. lCS Status 6 logs display.

Version 01: Initial Revision . TFS 1709 Admin tool setup - 5/12/2016

Summary

Tables
1. [EC].[AT_Coaching_Inactivation_Reactivation_Audit]
2. [EC].[AT_Warning_Inactivation_Reactivation_Audit]
3. [EC].[AT_Coaching_Reassignment_Audit]
4. [EC].[AT_User]
6. [EC].[AT_Role]
5. [EC].[AT_User_Role_Link]
7. [EC].[AT_Entitlement]
8. [EC].[AT_Role_Entitlement_Link]
9. [EC].[AT_Action_Reasons]
10.[EC].[AT_Module_Access]
11.[EC].[AT_Role_Access]
12.[EC].[AT_Reassign_Status_For_Module]
13.[EC].[IdsTableType]


Procedures
1. [EC].[sp_AT_Coaching_Inactivation_Reactivation]
2. [EC].[sp_AT_Warning_Inactivation_Reactivation]
3. [EC].[sp_AT_Select_Employees_Coaching_Inactivation_Reactivation] 
4. [EC].[sp_AT_Select_Employees_Warning_Inactivation_Reactivation]
5. [EC].[sp_AT_Select_Employees_Inactivation_Reactivation]  
6. [EC].[sp_AT_Select_Logs_Inactivation_Reactivation]
7. [EC].[sp_AT_Check_Entitlements]
8. [EC].[sp_AT_Select_Action_Reasons] 
9. [EC].[sp_AT_Select_Modules_By_LanID] 
10.[EC].[sp_AT_Select_Roles_By_User]-- Not used
11.[EC].[sp_AT_Select_Status_By_Module] 
12.[EC].[sp_AT_Coaching_Reassignment]
13.[EC].[sp_AT_Select_ReassignFrom_Users] 
14.[EC].[sp_AT_Select_ReassignTo_Users] 
15.[EC].[sp_AT_Select_Logs_Reassign] 
16.[EC].[sp_AT_Populate_User] 



*/


 --Details

**************************************************************
--Tables
**************************************************************
--1.TABLE [EC].[AT_Coaching_Inactivation_Reactivation_Audit]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[AT_Coaching_Inactivate_Reactivate_Audit](
	[SeqNum] [int] IDENTITY(1,1) NOT NULL,
	[CoachingID] [bigint]NOT NULL,
	[FormName] [nvarchar](50) NOT NULL,
	[LastKnownStatus] [int] NOT NULL,
	[Action] [nvarchar](30) NOT NULL,
	[ActionTimestamp] [datetime] NOT NULL,
	[RequesterID] [nvarchar](30) NOT NULL,
	[Reason] [nvarchar](250) NOT NULL,
	[RequesterComments] [nvarchar](4000) NULL

) ON [PRIMARY]

GO

--**************************************************


--2.TABLE [EC].[AT_Warning_Inactivation_Reactivation_Audit]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[AT_Warning_Inactivate_Reactivate_Audit](
	[SeqNum] [int] IDENTITY(1,1) NOT NULL,
	[WarningID] [bigint]NOT NULL,
	[FormName] [nvarchar](50) NOT NULL,
	[LastKnownStatus] [int] NOT NULL,
	[Action] [nvarchar](30) NOT NULL,
	[ActionTimestamp] [datetime] NOT NULL,
	[RequesterID] [nvarchar](30) NOT NULL,
	[Reason] [nvarchar](250) NOT NULL,
	[RequesterComments] [nvarchar](4000) NULL

) ON [PRIMARY]

GO

--************************************************

--3. TABLE [EC].[AT_Coaching_Reassignment_Audit]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[AT_Coaching_Reassign_Audit](
	[SeqNum] [int] IDENTITY(1,1) NOT NULL,
	[CoachingID] [bigint] NOT NULL,
	[FormName] [nvarchar](50) NOT NULL,
	[LastKnownStatus] [int] NOT NULL,
	[ActionTimestamp] [datetime] NOT NULL,
	[RequesterID] [nvarchar](10) NOT NULL,
	[AssignedToID] [nvarchar](10) NOT NULL,
	[Reason] [nvarchar](250) NOT NULL,
	[RequesterComments] [nvarchar](4000) NULL
	
) ON [PRIMARY]

GO




--************************************************

--4. TABLE [EC].[AT_User]

Create Table [EC].[AT_User]
(
UserId NVARCHAR(10) NOT NULL,
UserLanID NVARCHAR(30) NOT NULL,
UserName NVARCHAR(50) NOT NULL,
EmpJobCode NVARCHAR(50) NOT NULL,
Active bit NULL,
PRIMARY KEY (UserId)
)
GO



INSERT INTO [EC].[AT_User]
            ([UserId],
            [UserLanID],
			[UserName],
			[EmpJobCode],
			[Active])        
VALUES
('500306','JohnEric.Tiongson', 'John Eric Z','WISY13',1),
('343549','Mark.Hackman', 'Hackman, Mark G','WACQ13',1),
('408246','Scott.Potter', 'Potter, Scott E','WACQ13',1)
          
GO



--************************************************

--5. TABLE [EC].[AT_Role]

Create Table [EC].[AT_Role]
(
RoleId int  IDENTITY(101,1) NOT NULL,
RoleDescription NVARCHAR(20) NOT NULL,
IsSysAdmin bit NOT NULL,
PRIMARY KEY (RoleId)
)
GO

INSERT INTO [EC].[AT_Role]
            ([RoleDescription],
			[IsSysAdmin])        
VALUES
('CoachingAdmin',1),
('CoachingUser',0),
('WarningAdmin',1),
('WarningUser',0)

          
GO



--************************************************

--6. TABLE [EC].[AT_User_Role_Link]

Create Table [EC].[AT_User_Role_Link]
(
UserId NVARCHAR(10) NOT NULL,
RoleId int NOT NULL,
PRIMARY KEY (UserId,RoleId)
)
GO

ALTER TABLE [EC].[AT_User_Role_Link]  WITH NOCHECK ADD CONSTRAINT [fkUserId] FOREIGN KEY([UserId])
REFERENCES [EC].[AT_User] ([UserId])
GO

ALTER TABLE [EC].[AT_User_Role_Link] CHECK CONSTRAINT [fkUserId]
GO

ALTER TABLE [EC].[AT_User_Role_Link]  WITH NOCHECK ADD  CONSTRAINT [fkRoleId] FOREIGN KEY([RoleId])
REFERENCES [EC].[AT_Role] ([RoleId])
GO

ALTER TABLE [EC].[AT_User_Role_Link] CHECK CONSTRAINT [fkRoleId]
GO



INSERT INTO [EC].[AT_User_Role_Link]
            ([UserId] ,
			[RoleId])  
VALUES
(500306,101),
(500306,103),
('343549',101),
('343549',103),
('408246',101),
('408246',103)


--************************************************

--7. TABLE [EC].[AT_Entitlement]

Create Table [EC].[AT_Entitlement]
(
EntitlementId int  IDENTITY(201,1) NOT NULL,
EntitlementDescription NVARCHAR(100) NOT NULL,
PRIMARY KEY (EntitlementId)
)
GO


INSERT INTO [EC].[AT_Entitlement]
            ([EntitlementDescription])
		     
VALUES
('EmployeeLog-SearchForInactivate'),
('EmployeeLog-SearchForReassign'),
('EmployeeLog-SearchForReactivate'),
('ManageCoachingLogs'),
('ManageWarningLogs'),
('ReactivateCoachingLogs'),
('ReactivateWarningLogs')


--************************************************

--8. TABLE [EC].[AT_Role_Entitlement_Link]


Create Table [EC].[AT_Role_Entitlement_Link]
(
RoleId int NOT NULL,
EntitlementId int NOT NULL,
PRIMARY KEY (RoleId,EntitlementId)
)
GO


ALTER TABLE [EC].[AT_Role_Entitlement_Link]  WITH NOCHECK ADD  CONSTRAINT [fkEntRoleId] FOREIGN KEY([RoleId])
REFERENCES [EC].[AT_Role] ([RoleId])
GO

ALTER TABLE [EC].[AT_Role_Entitlement_Link] CHECK CONSTRAINT [fkEntRoleId]
GO

ALTER TABLE [EC].[AT_Role_Entitlement_Link]  WITH NOCHECK ADD CONSTRAINT [fkEntitlementId] FOREIGN KEY([EntitlementId])
REFERENCES [EC].[AT_Entitlement] ([EntitlementId])
GO

ALTER TABLE [EC].[AT_Role_Entitlement_Link] CHECK CONSTRAINT [fkEntitlementId]
GO





INSERT INTO [EC].[AT_Role_Entitlement_Link]
(RoleId,EntitlementId)
VALUES
(101,201),
(101,202),
(101,203),
(101,204),
(102,201),
(102,202),
(102,204),
(103,201),
(103,203),
(103,205),
(101,206),
(103,207)



--****************************************************


--9. TABLE [EC].[AT_Action_Reasons]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[AT_Action_Reasons](
    [ReasonId] [int] IDENTITY(1,1) NOT NULL,
	[Reason] [nvarchar](100) NOT NULL,
	[isActive] [bit] NULL,
	[Coaching] [bit] NULL,
	[Warning] [bit] NULL,
	[Inactivate] [bit] NULL,
	[Reactivate] [bit] NULL,
	[Reassign] [bit] NULL
) ON [PRIMARY]

GO


INSERT INTO [EC].[AT_Action_Reasons]
           ([Reason]
           ,[isActive]
           ,[Coaching]
           ,[Warning]
           ,[Inactivate]
           ,[Reactivate]
           ,[Reassign])
     VALUES
           ('Error in submission',1,1,1,1,0,0),
           ('Extended absence',1,1,0,1,0,0),
           ('Termed',1,1,0,1,0,0),
           ('Other',1,1,1,1,1,1),
           ('HR request',1,0,1,1,0,0),
           ('Error in inactivation',1,1,1,0,1,0),
           ('Return to work',1,1,1,0,1,0),
           ('Supervisor / manager unavailable',1,1,0,0,0,1),
           ('Team change',1,1,0,0,0,1)
      
GO




***************************************


--10. TABLE [EC].[AT_Module_Access]


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[AT_Module_Access](
	[JobCode] [nvarchar](50) NOT NULL,
	[JobCodeDescription] [nvarchar](50)NOT NULL,
	[ModuleId] [int] NOT NULL,
	[Module] [nvarchar](20) NOT NULL,
	[isActive][bit]NOT NULL,
	) ON [PRIMARY]

GO



INSERT INTO [EC].[AT_Module_Access]
           ([JobCode]
           ,[JobCodeDescription]
           ,[ModuleId]
           ,[Module]
           ,[isActive])
              VALUES
           ('WISY13','Sr Analyst, Systems',1,'CSR',1),
           ('WISY13','Sr Analyst, Systems',2,'Supervisor',1),
           ('WISY13','Sr Analyst, Systems',3,'Quality',1),
           ('WISY13','Sr Analyst, Systems',4,'LSA',1),
           ('WISY13','Sr Analyst, Systems',5,'Training',1),
           ('WACS50','Manager, Customer Service',1,'CSR',1),
           ('WACS60','Sr Manager, Customer Service',2,'Supervisor',1),
           ('WACS50','Manager, Customer Service',2,'Supervisor',1),
           ('WACS60','Sr Manager, Customer Service',1,'CSR',1)
           ('WIHD50','Manager, Help Desk',4,'LSA',1),
           ('WTTR50','Manager, Training',5,'Training',1),
           ('WPPM13','Sr Analyst, Program',3,'Quality',1) 
           

--***************************************

--11. TABLE [EC].[AT_Role_Access]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[AT_Role_Access](
	[JobCode] [nvarchar](50) NOT NULL,
	[JobCodeDescription] [nvarchar](50)NOT NULL,
	[RoleId] [int] NOT NULL,
	[RoleDescription] [nvarchar](20) NOT NULL,
	[AddToUser][bit]NOT NULL,
	[isActive][bit]NOT NULL,
	) ON [PRIMARY]

GO



INSERT INTO [EC].[AT_Role_Access]
           ([JobCode]
           ,[JobCodeDescription]
           ,[RoleId]
           ,[RoleDescription]
           ,[AddToUser]
           ,[isActive])
              VALUES
           ('WISY13','Sr Analyst, Systems',101,'CoachingAdmin',0,1),
           ('WACS50','Manager, Customer Service',102,'CoachingUser',1,1),
           ('WACS60','Sr Manager, Customer Service',102,'CoachingUser',1,1),
           ('WIHD50','Manager, Help Desk',102,'CoachingUser',1,1),
           ('WTTR50','Manager, Training',102,'CoachingUser',1,1),
           ('WPPM13','Sr Analyst, Program',102,'CoachingUser',1,1),
           ('WISY13','Sr Analyst, Systems',103,'WarningAdmin',0,1),
           ('WACQ13','Sr Specialist, Quality (CS)',101,'CoachingAdmin',0,1),
           ('WACQ13','Sr Specialist, Quality (CS)',103,'WarningAdmin',0,1)
      

--***************************************

--12. TABLE  [EC].[AT_Reassign_Status_For_Module]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[AT_Reassign_Status_For_Module](
	[ModuleId] [int] NOT NULL,
	[Module] [nvarchar](20) NOT NULL,
	[StatusId] [int] NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[isActive] [bit] NOT NULL
) ON [PRIMARY]

GO



INSERT INTO [EC].[AT_Reassign_Status_For_Module]
           ([ModuleId]
           ,[Module]
           ,[StatusId] 
	       ,[Status] 
           ,[isActive])
     VALUES
            (1,'CSR',5, 'Pending Manager Review',1),
            (1,'CSR',6, 'Pending Supervisor Review',1),
            (2,'Supervisor',5, 'Pending Manager Review',1),
            (2,'Supervisor',7, 'Pending Sr.Manager Review',1),
            (3,'Quality',8, 'Pending Quality Lead Review',1),
            (4,'LSA',6, 'Pending Supervisor Review',1),
            (5,'Training',5, 'Pending Manager Review',1),
            (5,'Training',6, 'Pending Supervisor Review',1)
            


--***************************************

--13. TYPE [EC].[IdsTableType]

CREATE TYPE [EC].[IdsTableType] AS TABLE(
	[ID] [bigint] NOT NULL
)
GO



--***************************************




/**************************************************************



**************************************************************

--Procedures

**************************************************************/

--1. [EC].[sp_AT_Coaching_Inactivation_Reactivation]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Coaching_Inactivation_Reactivation' 
)
   DROP PROCEDURE [EC].[sp_AT_Coaching_Inactivation_Reactivation]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------
-- MULTIPLE ASTERISKS (***) DESIGNATE SECTIONS OF THE STORED PROCEDURE TEMPLATE THAT SHOULD BE CUSTOMIZED
---------------------------------------------------------------------------------------------------------
-- REQUIRED PARAMETERS:
-- INPUT: @***sampleInputVariable varchar(35)***
-- OUTPUT: @returnCode int, @returnMessage varchar(100)
-- The following 2 statements need to be executed when re-creating this stored procedure:
-- drop procedure [EC].[sp_AT_Coaching_Inactivation_Reactivation]
-- go
CREATE PROCEDURE [EC].[sp_AT_Coaching_Inactivation_Reactivation] (
  @strRequesterLanId NVARCHAR(50),
  @strAction NVARCHAR(30), 
  @tableIds IdsTableType READONLY,
  @intReasonId INT, 
  @strReasonOther NVARCHAR(250)= NULL, 
  @strComments NVARCHAR(4000)= NULL, 
     
-------------------------------------------------------------------------------------
-- THE FOLLOWING CODE SHOULD NOT BE MODIFIED
@returnCode int OUTPUT,
@returnMessage varchar(100) OUTPUT
)
as
   declare @storedProcedureName varchar(80)
   declare @transactionCount int
   set @transactionCount = @@trancount
   set @returnCode = 0
   set @returnMessage = 'ok'
   -- If already in transaction, don't start another
   if @@trancount > 0
   begin
      save transaction currentTransaction
   end
   else
   begin
      begin transaction currentTransaction
   end
-- THE PRECEDING CODE SHOULD NOT BE MODIFIED
-------------------------------------------------------------------------------------
   set @storedProcedureName = 'sp_AT_Coaching_Inactivation_Reactivation'
-------------------------------------------------------------------------------------
-- Notes: set @returnCode and @returnMessage as appropriate
--        @returnCode defaults to '0',  @returnMessage defaults to 'ok'
--        IMPORTANT: do NOT place "return" statements in this custom code section
--        IF no severe error occurs,
--           @returnCode and @returnMessage will contain the values set by you
--        IF this procedure is not nested within another procedure,
--           you can force a rollback of the transaction
--              by setting @returnCode to a negative number
-------------------------------------------------------------------------------------
-- sample: select * from table where column = @sampleInputVariable
-- sample: update table set column = @sampleInputVariable where column = someValue
-- sample: insert into table (column1, column2) values (value1, value2)
-------------------------------------------------------------------------------------
-- *** BEGIN: INSERT CUSTOM CODE HERE ***
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SET NOCOUNT ON;


DECLARE @strRequestrID nvarchar(10),
        @strReason NVARCHAR(250),
        @intStatusID int,
        @intLKStatusID int,
     	@dtmDate datetime
     	

SET @dtmDate  = GETDATE()   
SET @strRequestrID = EC.fn_nvcGetEmpIdFromLanID(@strRequesterLanId,@dtmDate)
SET @strReason = (SELECT [Reason] FROM [EC].[AT_Action_Reasons]WHERE [ReasonId]= @intReasonId)

IF @strReason = 'Other'
BEGIN
SET @strReason = 'Other - ' + @strReasonOther
END
             
  INSERT INTO [EC].[AT_Coaching_Inactivate_Reactivate_Audit]
           ([CoachingID],[FormName],[LastKnownStatus],[Action]
           ,[ActionTimestamp] ,[RequesterID] ,[Reason],[RequesterComments])
      SELECT [CoachingID], [Formname], [StatusID],  @strAction,
      Getdate(), @strRequestrID, @strReason, @strComments 
      FROM  [EC].[Coaching_Log]CL JOIN @tableIds ID ON
      CL.CoachingID = ID.ID 

          
             
WAITFOR DELAY '00:00:00:02'  -- Wait for 2 ms
    --PRINT 'STEP1'


UPDATE [EC].[Coaching_Log]
SET StatusID = (SELECT  CASE @strAction
						WHEN 'Inactivate' THEN 2 ELSE [EC].[fn_intLastKnownStatusForCoachingID](CL.CoachingID) END)
FROM [EC].[Coaching_Log]CL JOIN @tableIds ID ON
CL.CoachingID = ID.ID						
						
          

-- *** END: INSERT CUSTOM CODE HERE ***
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-- THE FOLLOWING CODE SHOULD NOT BE MODIFIED
   if @@error <> 0
   begin
      set @returnCode = @@error
      set @returnMessage = 'Error in stored procedure ' + @storedProcedureName
      rollback transaction currentTransaction
      return -1
   end
   --  We were NOT already in a transaction so one was started
   --  Therefore safely commit this transaction
   if @transactionCount = 0
   begin
      if @returnCode >= 0
      begin
         commit transaction
      end
      else -- custom code set the return code as negative, causing rollback
      begin
         rollback transaction currentTransaction
      end
   end
   -- if return message was not changed from default, do so now
   if @returnMessage = 'ok'
   begin
      set @returnMessage = @storedProcedureName + ' completed successfully'
   end
return 0
-- THE PRECEDING CODE SHOULD NOT BE MODIFIED
GO





--***************************************



--2. [EC].[sp_AT_Warning_Inactivation_Reactivation]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Warning_Inactivation_Reactivation' 
)
   DROP PROCEDURE [EC].[sp_AT_Warning_Inactivation_Reactivation]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



---------------------------------------------------------------------------------------------------------
-- MULTIPLE ASTERISKS (***) DESIGNATE SECTIONS OF THE STORED PROCEDURE TEMPLATE THAT SHOULD BE CUSTOMIZED
---------------------------------------------------------------------------------------------------------
-- REQUIRED PARAMETERS:
-- INPUT: @***sampleInputVariable varchar(35)***
-- OUTPUT: @returnCode int, @returnMessage varchar(100)
-- The following 2 statements need to be executed when re-creating this stored procedure:
-- drop procedure [EC].[sp_AT_Warning_Inactivation_Reactivation]
-- go
CREATE PROCEDURE [EC].[sp_AT_Warning_Inactivation_Reactivation] (
  @strRequesterLanId NVARCHAR(50),
  @strAction NVARCHAR(30), 
  @tableIds IdsTableType READONLY,
  @intReasonId INT, 
  @strReasonOther NVARCHAR(250)= NULL, 
  @strComments NVARCHAR(4000)= NULL, 
     
-------------------------------------------------------------------------------------
-- THE FOLLOWING CODE SHOULD NOT BE MODIFIED
@returnCode int OUTPUT,
@returnMessage varchar(100) OUTPUT
)
as
   declare @storedProcedureName varchar(80)
   declare @transactionCount int
   set @transactionCount = @@trancount
   set @returnCode = 0
   set @returnMessage = 'ok'
   -- If already in transaction, don't start another
   if @@trancount > 0
   begin
      save transaction currentTransaction
   end
   else
   begin
      begin transaction currentTransaction
   end
-- THE PRECEDING CODE SHOULD NOT BE MODIFIED
-------------------------------------------------------------------------------------
   set @storedProcedureName = 'sp_AT_Warning_Inactivation_Reactivation'
-------------------------------------------------------------------------------------
-- Notes: set @returnCode and @returnMessage as appropriate
--        @returnCode defaults to '0',  @returnMessage defaults to 'ok'
--        IMPORTANT: do NOT place "return" statements in this custom code section
--        IF no severe error occurs,
--           @returnCode and @returnMessage will contain the values set by you
--        IF this procedure is not nested within another procedure,
--           you can force a rollback of the transaction
--              by setting @returnCode to a negative number
-------------------------------------------------------------------------------------
-- sample: select * from table where column = @sampleInputVariable
-- sample: update table set column = @sampleInputVariable where column = someValue
-- sample: insert into table (column1, column2) values (value1, value2)
-------------------------------------------------------------------------------------
-- *** BEGIN: INSERT CUSTOM CODE HERE ***
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SET NOCOUNT ON;


DECLARE @strRequestrID nvarchar(10),
        @strReason NVARCHAR(250),
        @intStatusID int,
        @intLKStatusID int,
     	@dtmDate datetime
     	

SET @dtmDate  = GETDATE()   
SET @strRequestrID = EC.fn_nvcGetEmpIdFromLanID(@strRequesterLanId,@dtmDate)
SET @strReason = (SELECT [Reason] FROM [EC].[AT_Action_Reasons]WHERE [ReasonId]= @intReasonId)

IF @strReason = 'Other'
BEGIN
SET @strReason = 'Other - ' + @strReasonOther
END
             
  INSERT INTO [EC].[AT_Warning_Inactivate_Reactivate_Audit]
           ([WarningID],[FormName],[LastKnownStatus],[Action]
           ,[ActionTimestamp] ,[RequesterID] ,[Reason],[RequesterComments])
      SELECT [WarningID], [Formname], [StatusID],  @strAction,
      Getdate(), @strRequestrID, @strReason, @strComments 
      FROM  [EC].[Warning_Log]CL JOIN @tableIds ID ON
      CL.WarningID = ID.ID 

          
             
WAITFOR DELAY '00:00:00:02'  -- Wait for 2 ms
    --PRINT 'STEP1'


UPDATE [EC].[Warning_Log]
SET StatusID = (SELECT  CASE @strAction
WHEN 'Inactivate' THEN 2 ELSE 1 END)
FROM [EC].[Warning_Log]CL JOIN @tableIds ID ON
CL.WarningID = ID.ID						
						
          

-- *** END: INSERT CUSTOM CODE HERE ***
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-- THE FOLLOWING CODE SHOULD NOT BE MODIFIED
   if @@error <> 0
   begin
      set @returnCode = @@error
      set @returnMessage = 'Error in stored procedure ' + @storedProcedureName
      rollback transaction currentTransaction
      return -1
   end
   --  We were NOT already in a transaction so one was started
   --  Therefore safely commit this transaction
   if @transactionCount = 0
   begin
      if @returnCode >= 0
      begin
         commit transaction
      end
      else -- custom code set the return code as negative, causing rollback
      begin
         rollback transaction currentTransaction
      end
   end
   -- if return message was not changed from default, do so now
   if @returnMessage = 'ok'
   begin
      set @returnMessage = @storedProcedureName + ' completed successfully'
   end
return 0
-- THE PRECEDING CODE SHOULD NOT BE MODIFIED
GO






--***************************************

--3. [EC].[sp_AT_Select_Employees_Coaching_Inactivation_Reactivation] 



IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Select_Employees_Coaching_Inactivation_Reactivation' 
)
   DROP PROCEDURE [EC].[sp_AT_Select_Employees_Coaching_Inactivation_Reactivation]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/21/2016
--	Description: *	This procedure returns the list of Employees who have 
--  Coaching logs for Inactivation or Reactivation.
--  Last Modified By: Susmitha Palacherla
--  Revision History:
--  Initial Revision. Admin tool setup, TFS 1709- 4/20/12016
--  Updated to remove Mgr site restriction for non admins, TFS 3091 - 07/05/2016
--  Updated to add Employees in Leave status for Inactivation, TFS 3441 - 09/07/2016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_AT_Select_Employees_Coaching_Inactivation_Reactivation] 

@strRequesterLanId nvarchar(30),@strActionin nvarchar(10), @intModulein int
AS

BEGIN
DECLARE	
@nvcTableName nvarchar(20),
@nvcWhere nvarchar(50),
@strRequesterID nvarchar(10),
@intRequesterSiteID int,
@strConditionalSite nvarchar(100),
@strATCoachAdminUser nvarchar(10),
@dtmDate datetime,
@nvcSQL nvarchar(max)

SET @dtmDate  = GETDATE()   
SET @strRequesterID = EC.fn_nvcGetEmpIdFromLanID(@strRequesterLanId,@dtmDate)
SET @intRequesterSiteID = EC.fn_intSiteIDFromEmpID(@strRequesterID)
SET @strATCoachAdminUser = EC.fn_strCheckIfATCoachingAdmin(@strRequesterID) 

SET @strConditionalSite = ' '
IF @strATCoachAdminUser <> 'YES'

BEGIN
	SET @strConditionalSite = ' AND Fact.SiteID = '''+CONVERT(NVARCHAR,@intRequesterSiteID)+''' '
END	

IF @strActionin = N'Inactivate'

SET @nvcSQL = 'SELECT DISTINCT Emp.Emp_ID,Emp.Emp_Name 
 FROM [EC].[Employee_Hierarchy] Emp JOIN [EC].[Coaching_Log] Fact WITH(NOLOCK)
 ON Emp.Emp_ID = Fact.EmpID  
 WHERE Fact.StatusID NOT IN (1,2)
 AND Fact.ModuleId = '''+CONVERT(NVARCHAR,@intModulein)+'''
 AND Fact.EmpID <> ''999999''
 AND Emp.Active NOT IN  (''T'',''D'')'
 + @strConditionalSite 
 + ' AND Fact.EmpLanID <> '''+@strRequesterLanId+''' 
 ORDER BY Emp.Emp_Name'

ELSE 

SET @nvcSQL = 'SELECT DISTINCT Emp.Emp_ID,Emp.Emp_Name 
 FROM [EC].[Employee_Hierarchy]Emp JOIN [EC].[Coaching_Log] Fact WITH(NOLOCK)
 ON Emp.Emp_ID = Fact.EmpID JOIN (Select * FROM
 [EC].[AT_Coaching_Inactivate_Reactivate_Audit]
 WHERE LastKnownStatus <> 2) Aud
 ON Aud.FormName = Fact.Formname
 WHERE Fact.StatusID = 2
 AND Fact.ModuleId = '''+CONVERT(NVARCHAR,@intModulein)+'''
 AND Fact.EmpID <> ''999999''
 AND Emp.Active = ''A''
 AND Fact.EmpLanID <> '''+@strRequesterLanId+''' 
 ORDER BY Emp.Emp_Name'
 
--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_AT_Select_Employees_Coaching_Inactivation_Reactivation




GO

--***************************************


--4. [EC].[sp_AT_Select_Employees_Warning_Inactivation_Reactivation] 



IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Select_Employees_Warning_Inactivation_Reactivation' 
)
   DROP PROCEDURE [EC].[sp_AT_Select_Employees_Warning_Inactivation_Reactivation]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/21/2016
--	Description: *	This procedure returns the list of Employees who have 
--  Warning logs for Inactivation or Reactivation.
--  Last Modified By: 
--  Last Modified date: 
--  Revision History:
--  Initial Revision. Admin tool setup, TFS 1709- 4/20/12016
--  Updated to add Employees in Leave status for Inactivation, TFS 3441 - 09/07/2016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_AT_Select_Employees_Warning_Inactivation_Reactivation] 

@strRequesterLanId nvarchar(30),@strActionin nvarchar(10), @intModulein int
AS

BEGIN
DECLARE	
@nvcTableName nvarchar(20),
@nvcWhere nvarchar(50),
@strRequesterID nvarchar(10),
@strRequesterSiteID int,
@dtmDate datetime,
@nvcSQL nvarchar(max)

SET @dtmDate  = GETDATE()   
SET @strRequesterID = EC.fn_nvcGetEmpIdFromLanID(@strRequesterLanId,@dtmDate)



IF @strActionin = N'Inactivate'

SET @nvcSQL = 'SELECT DISTINCT Emp.Emp_ID,Emp.Emp_Name 
 FROM [EC].[Employee_Hierarchy] Emp JOIN [EC].[Warning_Log] Fact WITH(NOLOCK)
 ON Emp.Emp_ID = Fact.EmpID  
 WHERE Fact.StatusID = 1
 AND Fact.ModuleId = '''+CONVERT(NVARCHAR,@intModulein)+'''
 AND Fact.EmpID <> ''999999''
 AND Emp.Active NOT IN  (''T'',''D'')
 AND Fact.EmpLanID <> '''+@strRequesterLanId+''' 
 ORDER BY Emp.Emp_Name'

ELSE 

SET @nvcSQL = 'SELECT DISTINCT Emp.Emp_ID,Emp.Emp_Name 
 FROM [EC].[Employee_Hierarchy]Emp JOIN [EC].[Warning_Log] Fact WITH(NOLOCK)
 ON Emp.Emp_ID = Fact.EmpID JOIN (Select * FROM
 [EC].[AT_Warning_Inactivate_Reactivate_Audit]
 WHERE LastKnownStatus = 1) Aud
 ON Aud.FormName = Fact.Formname
 WHERE Fact.StatusID = 2
 AND Fact.ModuleId = '''+CONVERT(NVARCHAR,@intModulein)+'''
 AND Fact.EmpID <> ''999999''
  AND Emp.Active = ''A''
 AND Fact.EmpLanID <> '''+@strRequesterLanId+''' 
 ORDER BY Emp.Emp_Name'
 
--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_AT_Select_Employees_Warning_Inactivation_Reactivation

GO








--***************************************

--5. [EC].[sp_AT_Select_Employees_Inactivation_Reactivation] 



IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Select_Employees_Inactivation_Reactivation' 
)
   DROP PROCEDURE [EC].[sp_AT_Select_Employees_Inactivation_Reactivation]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/21/2016
--	Description: *	This procedure calls the Coaching or Warning Inactivation 
--  Reactivation procedure based on the strType passed in.
--  Last Modified By: 
--  Last Modified date: 
--  Revision History:
--  Initial Revision. Admin tool setup, TFS 1709- 4/20/12016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_AT_Select_Employees_Inactivation_Reactivation] 

@strRequesterLanId nvarchar(30),@strTypein nvarchar(10), @strActionin nvarchar(10), @intModulein int
AS


BEGIN

IF @strTypein = N'Coaching'
BEGIN 
EXEC [EC].[sp_AT_Select_Employees_Coaching_Inactivation_Reactivation] @strRequesterLanId ,@strActionin , @intModulein 
END

IF @strTypein = N'Warning'
BEGIN 
EXEC [EC].[sp_AT_Select_Employees_Warning_Inactivation_Reactivation]@strRequesterLanId ,@strActionin , @intModulein 
END


END --sp_AT_Select_Employees_Inactivation_Reactivation
GO






--***************************************

--6. [EC].[sp_AT_Select_Logs_Inactivation_Reactivation]


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Select_Logs_Inactivation_Reactivation' 
)
   DROP PROCEDURE [EC].[sp_AT_Select_Logs_Inactivation_Reactivation]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/21/2016
--	Description: *	This procedure returns the list of Coaching or Warning logs 
--  in the appropriate Status for the Action for the selected Employee.
--  Last Modified By: 
--  Last Modified date: 
--  Revision History:
--  Initial Revision. Admin tool setup, TFS 1709- 4/2/12016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_AT_Select_Logs_Inactivation_Reactivation] 

@strTypein nvarchar(10)= NULL, @strActionin nvarchar(10), @strEmployeein nvarchar(10),  @intModuleIdin INT
AS

BEGIN
DECLARE	
@nvcTableName nvarchar(500),
@nvcWhere nvarchar(100),
@nvcSQL nvarchar(max),
@strID nvarchar(30)


IF @strTypein = N'Coaching' 
SET @strID = 'Fact.CoachingID LogID, '
ELSE 
SET @strID = 'Fact.WarningID LogID, '

IF @strTypein = N'Coaching' AND @strActionin = 'Inactivate'
SET @nvcTableName = ' FROM [EC].[Coaching_Log] Fact WITH(NOLOCK) '

IF @strTypein = N'Warning' AND @strActionin = 'Inactivate'
SET @nvcTableName = ' FROM [EC].[Warning_Log] Fact WITH(NOLOCK) '

IF @strTypein = N'Coaching' AND @strActionin = 'Reactivate'
SET @nvcTableName = ',Aud.LastKnownStatus, [EC].[fn_strStatusFromStatusID](Aud.LastKnownStatus)LKStatus
 FROM [EC].[Coaching_Log] Fact WITH(NOLOCK) JOIN (Select * FROM
 [EC].[AT_Coaching_Inactivate_Reactivate_Audit] WHERE LastKnownStatus <> 2) Aud
 ON Aud.FormName = Fact.Formname '

IF @strTypein = N'Warning' AND @strActionin = 'Reactivate'
SET @nvcTableName = ',Aud.LastKnownStatus, [EC].[fn_strStatusFromStatusID](Aud.LastKnownStatus)LKStatus 
 FROM [EC].[Warning_Log] Fact WITH(NOLOCK) JOIN (Select * FROM
 [EC].[AT_Warning_Inactivate_Reactivate_Audit] WHERE LastKnownStatus <> 2) Aud
 ON Aud.FormName = Fact.Formname '


IF @strActionin = N'Reactivate'
SET @nvcWhere = ' WHERE Fact.StatusID = 2 '
ELSE 
IF @strTypein = N'Coaching' AND @strActionin = 'Inactivate'
SET @nvcWhere = ' WHERE Fact.StatusID NOT IN (1,2) '
ELSE
IF @strTypein = N'Warning' AND @strActionin = 'Inactivate'
SET @nvcWhere = ' WHERE Fact.StatusID <> 2 '



 SET @nvcSQL = 'SELECT DISTINCT '+@strID+' 
        fact.FormName strFormName,
		eh.Emp_Name	strEmpName,
		eh.Sup_Name	strSupName,
	    CASE
		 WHEN  fact.[strReportCode] like ''LCS%'' AND fact.[MgrID] <> eh.[Mgr_ID]
		 THEN [EC].[fn_strEmpNameFromEmpID](fact.[MgrID])+ '' (Assigned Reviewer)''
		 ELSE eh.Mgr_Name END strMgrName,
		sh.Emp_Name strSubmitter,
		s.Status,
		Fact.SubmittedDate strCreatedDate '
  +  @nvcTableName +
 'JOIN [EC].[Employee_Hierarchy] eh
	 ON [Fact].[EMPID] = [eh].[Emp_ID] JOIN [EC].[Employee_Hierarchy] sh
	 ON [Fact].[SubmitterID] = [sh].[Emp_ID] JOIN [EC].[DIM_Status] s
	 ON [Fact].[StatusID] = [s].[StatusID] '+
 @nvcWhere +
 'AND EmpID = '''+@strEmployeein+'''
  AND [Fact].[ModuleId] = '''+CONVERT(NVARCHAR,@intModuleIdin)+'''
  ORDER BY Fact.FormName DESC'


--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_AT_Select_Logs_Inactivation_Reactivation

GO






--***************************************

--7. [EC].[sp_AT_Check_Entitlements]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Check_Entitlements' 
)
   DROP PROCEDURE [EC].[sp_AT_Check_Entitlements]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/22/2016
--	Description: *	This procedure returns the list of Entitlements 
--  within the eCoaching admin tool for a given user.
--  Last Modified By: 
--  Last Modified date: 
--  Revision History:
--  Initial Revision. Admin tool setup, TFS 1709- 4/2/12016
 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_AT_Check_Entitlements] 
@nvcEmpLanIDin nvarchar(30)

AS
BEGIN
	DECLARE	

	@nvcSQL nvarchar(max),
	@nvcEmpID nvarchar(10),
    @dtmDate datetime

SET @dtmDate  = GETDATE()  
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@nvcEmpLanIDin,@dtmDate)



 


SET @nvcSQL = 'SELECT DISTINCT [EntitlementId], [EntitlementDescription]
               FROM [EC].[AT_Entitlement]
               WHERE [EntitlementId] IN (
					 SELECT DISTINCT([EntitlementId]) 
                     FROM [EC].[AT_Role_Entitlement_Link]
		             WHERE [RoleId] IN (
                            SELECT DISTINCT([RoleId]) 
                            FROM [EC].[AT_User_Role_Link] ur 
		                    JOIN [EC].[AT_User]u ON u.UserId = ur.UserId 
		                     WHERE u.UserID = '''+@nvcEmpID+'''))'

--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_AT_Check_Entitlements
GO





--***************************************


--8. [EC].[sp_AT_Select_Action_Reasons] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Select_Action_Reasons' 
)
   DROP PROCEDURE [EC].[sp_AT_Select_Action_Reasons]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/18/2016
--	Description: *	This procedure takes a value of either Coaching or Warning and 
-- the Action Type and returns the Reasons for that Action Type.
-- Last Modified By:
-- Last Modified Date: 
-- Initial revision to set up admin tool - TFS 1709 - 4/18/2016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_AT_Select_Action_Reasons] 
@strType nvarchar(20), @strAction nvarchar(20)
AS
BEGIN
	DECLARE	
	
	@nvcSQL nvarchar(max)
	
	

SET @nvcSQL = 'Select [ReasonID],[Reason] FROM [EC].[AT_Action_Reasons]
Where ' + @strType +' = 1 
and ' + @strAction +'= 1
Order by CASE WHEN [Reason]= ''Other'' THEN 1 ELSE 0 END'


--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_AT_Select_Action_Reasons
GO







--***************************************


--9. [EC].[sp_AT_Select_Modules_By_LanID] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Select_Modules_By_LanID' 
)
   DROP PROCEDURE [EC].[sp_AT_Select_Modules_By_LanID]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO










--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/21/2016
--	Description: *	This procedure returns the list of Module(s) for the logged in user. 
--  Last Modified By: 
--  Revision History:
--  Initial Revision. Admin tool setup, TFS 1709- 4/27/12016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_AT_Select_Modules_By_LanID] 
@nvcEmpLanIDin nvarchar(30),@strTypein nvarchar(10)= NULL

AS
BEGIN
	DECLARE	

	@nvcSQL nvarchar(max),
	@nvcEmpID nvarchar(10),
	@strATWarnAdminUser nvarchar(10),
	@strATCoachAdminUser nvarchar(10),
	@nvcEmpJobCode nvarchar(30),
	@dtmDate datetime

SET @dtmDate  = GETDATE()  
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@nvcEmpLanIDin,@dtmDate)
SET @nvcEmpJobCode = (SELECT Emp_Job_Code From EC.Employee_Hierarchy
WHERE Emp_ID = @nvcEmpID)
SET @strATWarnAdminUser = EC.fn_strCheckIfATWarningAdmin(@nvcEmpID) 
SET @strATCoachAdminUser = EC.fn_strCheckIfATCoachingAdmin(@nvcEmpID) 


IF ((@strATWarnAdminUser = 'YES' AND @strATCoachAdminUser = 'YES')
   OR (@strTypein is NULL AND @strATCoachAdminUser = 'YES')
   OR (@strTypein = 'Coaching' AND @strATCoachAdminUser = 'YES')
   OR (@strTypein = 'Warning' AND @strATWarnAdminUser = 'YES'))

SET @nvcSQL = 'SELECT DISTINCT ModuleId, Module 
			   FROM [EC].[AT_Module_Access]
			   WHERE [isActive]=1
			   ORDER BY Module'
			   
ELSE

SET @nvcSQL = 'SELECT ModuleId, Module 
			   FROM [EC].[AT_Module_Access]
			   WHERE [JobCode]= '''+@nvcEmpJobCode+'''
			   AND [isActive]=1
			   ORDER BY Module'

--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_AT_Select_Modules_By_LanID








GO













--***************************************


--10. [EC].[sp_AT_Select_Roles_By_User]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Select_Roles_By_User' 
)
   DROP PROCEDURE [EC].[sp_AT_Select_Roles_By_User]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/21/2016
--	Description: *	This procedure returns the list of Role(s) for the logged in user. 
--  Last Modified By: 
--  Revision History:
--  Initial Revision. Admin tool setup, TFS 1709- 4/27/12016
 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_AT_Select_Roles_By_User] 
@nvcEmpLanIDin nvarchar(30)

AS
BEGIN
	DECLARE	

	@nvcSQL nvarchar(max),
	@nvcEmpID nvarchar(10),
	@dtmDate datetime

SET @dtmDate  = GETDATE()  
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@nvcEmpLanIDin,@dtmDate)


SET @nvcSQL = 'SELECT U.[UserId], [RoleDescription]
FROM [EC].[AT_User] U JOIN [EC].[AT_User_Role_Link] URL
ON U.[UserId]= URL.[UserId]JOIN [EC].[AT_ROLE]R ON
R.[RoleId]= URL.[RoleId]
WHERE U.[UserId]= '''+@nvcEmpID+''''

--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_AT_Select_Roles_By_User

GO



--***************************************

--11.[EC].[sp_AT_Select_Status_By_Module] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Select_Status_By_Module' 
)
   DROP PROCEDURE [EC].[sp_AT_Select_Status_By_Module]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/21/2016
--	Description: *	This procedure returns the list of Status(es) for a selected Module 
--  Last Modified By: 
--  Revision History:
--  Initial Revision. Admin tool setup, TFS 1709- 4/27/12016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_AT_Select_Status_By_Module] 
@intModuleIdin INT

AS
BEGIN
	DECLARE	

	@nvcSQL nvarchar(max)




SET @nvcSQL = 'SELECT StatusId, Status
			   FROM [EC].[AT_Reassign_Status_For_Module]
			   WHERE [ModuleID]= '''+CONVERT(NVARCHAR,@intModuleIdin)+'''
			   AND [isActive]=1'

--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_AT_Select_Status_By_Module

GO




--***************************************


--12. [EC].[sp_AT_Coaching_Reassignment]


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Coaching_Reassignment' 
)
   DROP PROCEDURE [EC].[sp_AT_Coaching_Reassignment]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------
-- MULTIPLE ASTERISKS (***) DESIGNATE SECTIONS OF THE STORED PROCEDURE TEMPLATE THAT SHOULD BE CUSTOMIZED
---------------------------------------------------------------------------------------------------------
-- REQUIRED PARAMETERS:
-- INPUT: @***sampleInputVariable varchar(35)***
-- OUTPUT: @returnCode int, @returnMessage varchar(100)
-- The following 2 statements need to be executed when re-creating this stored procedure:
-- drop procedure [EC].[sp_AT_Coaching_Reassignment]
-- go
CREATE PROCEDURE [EC].[sp_AT_Coaching_Reassignment] (
  @strRequesterLanId NVARCHAR(50),
  @tableIds IdsTableType READONLY,
  @strAssignedId NVARCHAR(10),
  @intReasonId INT, 
  @strReasonOther NVARCHAR(250)= NULL, 
  @strComments NVARCHAR(4000)= NULL, 
     

-------------------------------------------------------------------------------------
-- THE FOLLOWING CODE SHOULD NOT BE MODIFIED
@returnCode int OUTPUT,
@returnMessage varchar(100) OUTPUT
)
as
   declare @storedProcedureName varchar(80)
   declare @transactionCount int
   set @transactionCount = @@trancount
   set @returnCode = 0
   set @returnMessage = 'ok'
   -- If already in transaction, don't start another
   if @@trancount > 0
   begin
      save transaction currentTransaction
   end
   else
   begin
      begin transaction currentTransaction
   end
-- THE PRECEDING CODE SHOULD NOT BE MODIFIED
-------------------------------------------------------------------------------------
   set @storedProcedureName = 'sp_AT_Coaching_Reassignment'
-------------------------------------------------------------------------------------
-- Notes: set @returnCode and @returnMessage as appropriate
--        @returnCode defaults to '0',  @returnMessage defaults to 'ok'
--        IMPORTANT: do NOT place "return" statements in this custom code section
--        IF no severe error occurs,
--           @returnCode and @returnMessage will contain the values set by you
--        IF this procedure is not nested within another procedure,
--           you can force a rollback of the transaction
--              by setting @returnCode to a negative number
-------------------------------------------------------------------------------------
-- sample: select * from table where column = @sampleInputVariable
-- sample: update table set column = @sampleInputVariable where column = someValue
-- sample: insert into table (column1, column2) values (value1, value2)
-------------------------------------------------------------------------------------
-- *** BEGIN: INSERT CUSTOM CODE HERE ***
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SET NOCOUNT ON;


DECLARE @strRequestrID nvarchar(10),
        @strReason NVARCHAR(250),
        @intStatusID int,
        @intLKStatusID int,
     	@dtmDate datetime
     	

SET @dtmDate  = GETDATE()   
SET @strRequestrID = EC.fn_nvcGetEmpIdFromLanID(@strRequesterLanId,@dtmDate)
SET @strReason = (SELECT [Reason] FROM [EC].[AT_Action_Reasons]WHERE [ReasonId]= @intReasonId)

IF @strReason = 'Other'
BEGIN
SET @strReason = 'Other - ' + @strReasonOther
END
             
  INSERT INTO [EC].[AT_Coaching_Reassign_Audit]
           ([CoachingID],[FormName],[LastKnownStatus],
           [ActionTimestamp] ,[RequesterID],[AssignedToID],[Reason],[RequesterComments])
      SELECT [CoachingID], [Formname], [StatusID], 
      Getdate(), @strRequestrID,@strAssignedId, @strReason, @strComments 
      FROM  [EC].[Coaching_Log]CL JOIN @tableIds ID ON
      CL.CoachingID = ID.ID 

          
             
WAITFOR DELAY '00:00:00:02'  -- Wait for 2 ms
    --PRINT 'STEP1'


UPDATE [EC].[Coaching_Log]
SET [ReassignedToID] =  @strAssignedId,
    [ReassignDate]= Getdate(),
	[ReassignCount] = ReassignCount + 1
FROM [EC].[Coaching_Log]CL JOIN @tableIds ID 
ON CL.CoachingID = ID.ID 
								
						
          

-- *** END: INSERT CUSTOM CODE HERE ***
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-- THE FOLLOWING CODE SHOULD NOT BE MODIFIED
   if @@error <> 0
   begin
      set @returnCode = @@error
      set @returnMessage = 'Error in stored procedure ' + @storedProcedureName
      rollback transaction currentTransaction
      return -1
   end
   --  We were NOT already in a transaction so one was started
   --  Therefore safely commit this transaction
   if @transactionCount = 0
   begin
      if @returnCode >= 0
      begin
         commit transaction
      end
      else -- custom code set the return code as negative, causing rollback
      begin
         rollback transaction currentTransaction
      end
   end
   -- if return message was not changed from default, do so now
   if @returnMessage = 'ok'
   begin
      set @returnMessage = @storedProcedureName + ' completed successfully'
   end
return 0
-- THE PRECEDING CODE SHOULD NOT BE MODIFIED

GO







--***************************************

--13.[EC].[sp_AT_Select_ReassignFrom_Users] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Select_ReassignFrom_Users' 
)
   DROP PROCEDURE [EC].[sp_AT_Select_ReassignFrom_Users]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/28/2016
--	Description: *	This procedure selects the list of users that currently have 
--  ecls assigned to them. Same module and site as the logged in user performing the reassign.
-- Last Updated By: 
-- Initial revision per TFS 1709 - 4/28/2016
-- Updated to add Employees in Leave status for Reassignment and 
-- removed Active check for reassigned and review managers per TFS 3441 - 09/07/2016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_AT_Select_ReassignFrom_Users] 
@strRequesterin nvarchar(30), @intModuleIdin INT, @intStatusIdin INT
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@nvcRequesterID nvarchar(10),
@intRequesterSiteID int,
@strATAdminUser nvarchar(10),
@strConditionalSelect nvarchar(100),
@strConditionalSite nvarchar(100),
@strConditionalRestrict nvarchar(100),
@dtmDate datetime

SET @dtmDate  = GETDATE()   
SET @nvcRequesterID = EC.fn_nvcGetEmpIdFromLanID(@strRequesterin,@dtmDate)
SET @intRequesterSiteID = EC.fn_intSiteIDFromEmpID(@nvcRequesterID)
SET @strATAdminUser = EC.fn_strCheckIfATSysAdmin(@nvcRequesterID) 

IF ((@intStatusIdin IN (6,8) AND @intModuleIdin IN (1,3,4,5))
OR (@intStatusIdin = 5 AND @intModuleIdin = 2))

BEGIN
SET @strConditionalSelect = N'SELECT DISTINCT eh.SUP_ID UserID, eh.SUP_Name UserName '
SET @strConditionalRestrict = N'AND eh.SUP_ID <> '''+@nvcRequesterID+''' ' 
END

ELSE IF 
((@intStatusIdin = 5 AND @intModuleIdin IN (1,3,4,5))
OR (@intStatusIdin = 7 AND @intModuleIdin = 2))

BEGIN
SET @strConditionalSelect = N'SELECT DISTINCT eh.MGR_ID UserID, eh.MGR_Name UserName '
SET @strConditionalRestrict = N'AND eh.MGR_ID <> '''+@nvcRequesterID+''''
END
		
SET @strConditionalSite = ' '
IF @strATAdminUser <> 'YES'

BEGIN
	SET @strConditionalSite = ' AND cl.SiteID = '''+CONVERT(NVARCHAR,@intRequesterSiteID)+''' '
END			 

-- Non reassigned and Non LCS eCLs
-- UNION
-- Reassigned ecls
-- UNION
-- Non reassigned LCS ecls

SET @nvcSQL = @strConditionalSelect +
'FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ' +
' ON cl.EmpID = eh.Emp_ID 
WHERE cl.ModuleID = '''+CONVERT(NVARCHAR,@intModuleIdin)+'''
AND cl.StatusId= '''+CONVERT(NVARCHAR,@intStatusIdin)+'''
AND CL.ReassignCount = 0
AND NOT (CL.statusid = 5 AND ISNULL(CL.strReportCode,'' '') like ''LCS%'')'
+ @strConditionalSite 
+ @strConditionalRestrict
+ 'AND (eh.SUP_Name is NOT NULL AND eh.MGR_Name is NOT NULL)
AND eh.Active NOT IN  (''T'',''D'')

UNION 


SELECT DISTINCT rm.Emp_ID UserID, rm.Emp_Name UserName
FROM [EC].[Employee_Hierarchy] rm JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) 
ON cl.ReassignedToID = rm.Emp_ID JOIN [EC].[Employee_Hierarchy] eh
ON eh.Emp_ID = cl.EmpID
WHERE cl.ModuleID = '''+CONVERT(NVARCHAR,@intModuleIdin)+'''
AND cl.StatusId= '''+CONVERT(NVARCHAR,@intStatusIdin)+'''
AND cl.ReassignedToID is not NULL 
AND (cl.ReassignCount < 2 and cl.ReassignCount <> 0)
AND (rm.Emp_Name is NOT NULL AND rm.Emp_Name <> ''Unknown'')'
+ @strConditionalSite 
+ 'AND rm.Emp_ID <> '''+@nvcRequesterID+''' 
AND eh.Active NOT IN  (''T'',''D'')

UNION 

SELECT DISTINCT rm.Emp_ID UserID, rm.Emp_Name UserName
FROM [EC].[Employee_Hierarchy] rm JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) 
ON cl.MgrID = rm.Emp_ID JOIN [EC].[Employee_Hierarchy] eh
ON eh.Emp_ID = cl.EmpID
WHERE cl.ModuleID = '''+CONVERT(NVARCHAR,@intModuleIdin)+'''
AND cl.StatusId= '''+CONVERT(NVARCHAR,@intStatusIdin)+'''
AND cl.MgrID is not NULL
AND cl.strReportCode like ''LCS%''
AND CL.ReassignCount = 0
AND (rm.Emp_Name is NOT NULL AND rm.Emp_Name <> ''Unknown'')'
+ @strConditionalSite 
+ 'AND rm.Emp_ID <> '''+@nvcRequesterID+''' 
AND eh.Active NOT IN  (''T'',''D'')
Order By UserName'

--PRINT @nvcSQL		
EXEC (@nvcSQL)


End --sp_AT_Select_ReassignFrom_Users

GO





--***************************************


--14.[EC].[sp_AT_Select_ReassignTo_Users] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Select_ReassignTo_Users' 
)
   DROP PROCEDURE [EC].[sp_AT_Select_ReassignTo_Users]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/28/2016
--	Description: *	This procedure selects the list of users that an ECL
-- can be reassigned to. users at the same level and site as the original owner. 
-- Last Updated By: 
-- Initial revision per TFS 1709 - 4/28/2016
-- Updated to add Employees in Leave status for Reassignment and 
-- added Active check for reassigned to supervisors and managers per TFS 3441 - 09/07/2016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_AT_Select_ReassignTo_Users] 
@strRequesterin nvarchar(30),@strFromUserIdin nvarchar(10), @intModuleIdin INT, @intStatusIdin INT
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@nvcRequesterID nvarchar(10),
--@nvcRequesterJobCode Nvarchar(30),
--@intModuleID INT,
@intRequesterSiteID int,
@intFromUserSiteID int,
@strSelect nvarchar(1000),
@dtmDate datetime

--cl.ModuleID = '''+CONVERT(NVARCHAR,@intModuleIdin)+'''
SET @dtmDate  = GETDATE()   
SET @nvcRequesterID = EC.fn_nvcGetEmpIdFromLanID(@strRequesterin,@dtmDate)
--SET @intRequesterSiteID = EC.fn_intSiteIDFromEmpID(@nvcRequesterID)
SET @intFromUserSiteID = EC.fn_intSiteIDFromEmpID(@strFromUserIdin)

IF ((@intStatusIdin IN (6,8) AND @intModuleIdin IN (1,3,4,5))
OR (@intStatusIdin = 5 AND @intModuleIdin = 2))


BEGIN
SET @nvcSQL = N'SELECT DISTINCT sh.EMP_ID UserID, sh.Emp_Name UserName
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy]sh
ON eh.SUP_ID = sh.EMP_ID
WHERE cl.SiteID = '''+CONVERT(NVARCHAR,@intFromUserSiteID)+'''
AND (eh.SUP_Name is NOT NULL AND eh.SUP_Name <> ''Unknown'')
AND eh.SUP_ID <> '''+@strFromUserIdin+''' 
AND eh.Active NOT IN (''T'',''D'')
AND sh.Active = ''A''
Order By UserName'
END

ELSE IF 
((@intStatusIdin = 5 AND @intModuleIdin IN (1,3,4,5))
OR (@intStatusIdin = 7 AND @intModuleIdin = 2))

BEGIN

SET @nvcSQL = N'SELECT DISTINCT mh.EMP_ID UserID, mh.Emp_Name UserName
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy]mh
ON eh.MGR_ID = mh.EMP_ID
WHERE cl.SiteID = '''+CONVERT(NVARCHAR,@intFromUserSiteID)+'''
AND (eh.MGR_Name is NOT NULL AND eh.MGR_Name <> ''Unknown'')
AND eh.MGR_ID <> '''+@strFromUserIdin+'''
AND eh.Active NOT IN (''T'',''D'')
AND mh.Active = ''A''
Order By UserName'
END
			 

--PRINT @nvcSQL		
EXEC (@nvcSQL)


End --sp_AT_Select_ReassignTo_Users





GO





--***************************************


--15.[EC].[sp_AT_Select_Logs_Reassign] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Select_Logs_Reassign' 
)
   DROP PROCEDURE [EC].[sp_AT_Select_Logs_Reassign]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/21/2016
--	Description: *	This procedure returns the list of Coaching or Warning logs 
--  in the appropriate Status for the Action for the selected Employee.
--  Last Modified By: 
--  Revision History:
--  Initial Revision. Admin tool setup, TFS 1709- 4/27/12016
--  Updated to add Employees in Leave status for Reassignment per TFS 3441 - 09/07/2016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_AT_Select_Logs_Reassign] 
@istrOwnerin nvarchar(10), @intStatusIdin INT, @intModuleIdin INT
AS

BEGIN
DECLARE	
@strConditionalWhere nvarchar(100),
@nvcSQL nvarchar(max)


IF ((@intStatusIdin IN (6,8) AND @intModuleIdin IN (1,3,4,5))
OR (@intStatusIdin = 5 AND @intModuleIdin = 2))

BEGIN
SET @strConditionalWhere = ' WHERE EH.Sup_ID = '''+@istrOwnerin+''' '
END

ELSE IF 
((@intStatusIdin = 5 AND @intModuleIdin IN (1,3,4,5))
OR (@intStatusIdin = 7 AND @intModuleIdin = 2))

BEGIN
SET @strConditionalWhere = ' WHERE EH.Mgr_ID = '''+@istrOwnerin+''' '
END

-- Check for 3 scenarios
--1. Original hierarchy owner
--2. Reassigned owner
--3. Review owner for LCS

SET @nvcSQL = 'SELECT cfact.CoachingID,  
        cfact.FormName strFormName,
		eh.Emp_Name	strEmpName,
		eh.Sup_Name	strSupName,
	    CASE
		 WHEN cfact.[strReportCode] like ''LCS%'' AND cfact.[MgrID] <> eh.[Mgr_ID]
		 THEN [EC].[fn_strEmpNameFromEmpID](cfact.[MgrID])+ '' (Assigned Reviewer)''
		 ELSE eh.Mgr_Name END strMgrName,
		 sh.Emp_Name strSubmitter,
		s.Status,
		cfact.SubmittedDate strCreatedDate 
     FROM [EC].[Coaching_Log]cfact WITH(NOLOCK) JOIN 
     
     (SELECT fact.CoachingID
     FROM [EC].[Coaching_Log]fact WITH(NOLOCK) JOIN [EC].[Employee_Hierarchy] eh
	 ON [Fact].[EMPID] = [eh].[Emp_ID]
	 AND NOT(fact.statusid = 5 AND ISNULL(fact.strReportCode,'' '') LIKE ''LCS%'')'
	 + @strConditionalWhere +
	 'AND fact.ReassignCount = 0
	
	
     UNION
     
     SELECT fact.CoachingID 
     FROM [EC].[Coaching_Log]fact WITH(NOLOCK) JOIN [EC].[Employee_Hierarchy] rm
	 ON [Fact].[ReassignedToID] = [rm].[Emp_ID]
	 WHERE rm.Emp_ID = '''+@istrOwnerin+''' 
	 AND (fact.ReassignCount < 2 and fact.ReassignCount <> 0)
	 AND fact.ReassignedToID is not NULL
	 
	 
     UNION
     
     SELECT fact.CoachingID 
     FROM [EC].[Coaching_Log]fact WITH(NOLOCK) JOIN [EC].[Employee_Hierarchy] rm
	 ON [Fact].[MgrID] = [rm].[Emp_ID]
	 WHERE rm.Emp_ID = '''+@istrOwnerin+''' 
	 AND fact.strReportCode like ''LCS%''
	 AND fact.ReassignCount = 0
	 )Selected 
	 
	 ON Selected.CoachingID = cfact.CoachingID JOIN [EC].[Employee_Hierarchy] eh
	 ON [cfact].[EMPID] = [eh].[Emp_ID] JOIN [EC].[Employee_Hierarchy] sh
	 ON [cfact].[SubmitterID] = [sh].[Emp_ID]JOIN [EC].[DIM_Status] s
	 ON [cfact].[StatusID] = [s].[StatusID]
	 
	WHERE cfact.StatusId = '''+CONVERT(NVARCHAR,@intStatusIdin)+'''
	AND cfact.Moduleid = '''+CONVERT(NVARCHAR,@intModuleIdin)+'''
  	AND eh.Active NOT IN  (''T'',''D'') 
   ORDER BY cfact.FormName DESC'
   
--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_AT_Select_Logs_Reassign

GO





--***************************************


--16.[EC].[sp_AT_Populate_User] 


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Populate_User' 
)
   DROP PROCEDURE [EC].[sp_AT_Populate_User]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:		   Susmitha Palacherla
-- Create Date: 4/27/12016
-- Description:	Performs the following actions.
-- Updates existing records and Inserts New records from the Employee table.
-- Last Modified By: Susmitha Palacherla
-- Revision History:
--  Initial Revision. Admin tool setup, TFS 1709- 4/27/12016
--  Update admin job code, TFS 3416 - 7/26/2016
-- =============================================

CREATE PROCEDURE [EC].[sp_AT_Populate_User] 
AS
BEGIN

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

BEGIN TRY
-- Inactivate termed users and those with job code changes
-- that result in a non allowed job code. 
 
BEGIN
	
UPDATE [EC].[AT_User] 
	SET [Active] = 0
	FROM [EC].[Employee_Hierarchy] EH JOIN [EC].[AT_User]U
	ON EH.Emp_ID = U.UserId 
    WHERE(EH.Active in ('T', 'D')OR EH.Emp_Job_Code NOT IN 
	(SELECT DISTINCT JobCode FROM [EC].[AT_Role_Access]))
     AND U.Active <> 0

OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

-- Reactivate users with Active status or with job code changes
-- that result in an allowed job code. 

BEGIN
    UPDATE [EC].[AT_User] 
	SET [Active] = 1
	FROM [EC].[Employee_Hierarchy] EH JOIN [EC].[AT_User]U
	ON EH.Emp_ID = U.UserId
	AND (EH.Active = 'A' AND EH.Emp_Job_Code IN 
	(SELECT DISTINCT JobCode FROM [EC].[AT_Role_Access]))
     AND U.Active = 0

OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms
    
-- Inserts new user records 

BEGIN
	INSERT INTO [EC].[AT_User]
	([UserId],[UserLanID],[UserName],[EmpJobCode],[Active] )
							  SELECT EH.[Emp_ID]
				  		      ,EH.[Emp_LanID]
				  		      ,EH.[Emp_Name]
				  		      ,EH.[Emp_Job_Code]
							  ,1
						  FROM [EC].[Employee_Hierarchy]EH Left outer Join [EC].[AT_User]U
						  ON EH.Emp_ID = U.UserId
						  WHERE (U.UserId IS NULL and EH.Emp_ID <> '')
						  AND EH.Active = 'A'
						  AND EH.Emp_Job_Code IN 
						 (SELECT DISTINCT JobCode FROM [EC].[AT_Role_Access]
						  WHERE [AddToUser] =1)

OPTION (MAXDOP 1)
END


-- Inserts new user role link records 

BEGIN
	INSERT INTO [EC].[AT_User_Role_Link]
	([UserId],[RoleID])
			SELECT URA.UserId, URA.RoleId FROM 
		    (SELECT U.[UserId],RA.[RoleId]
			FROM [EC].[AT_User]U JOIN [EC].[AT_Role_Access] RA
			ON U.[EmpJobCode] = RA.[JobCode]
			WHERE RA.[AddToUser]=1
			AND U.Active = 1)URA LEFT OUTER JOIN [EC].[AT_User_Role_Link]URL
			ON URA.UserId = URL.UserId
			AND URA.RoleId = URL.RoleId
			WHERE ( URL.UserId is NULL and URL.RoleId is NULL)
						

OPTION (MAXDOP 1)
END

-- Delete Role link tables for Inactive users

BEGIN
	DELETE URL
	FROM [EC].[AT_User]U JOIN EC.AT_User_Role_Link URL
	ON U.UserId = URL.UserId
	WHERE U.Active = 0
	

OPTION (MAXDOP 1)
END

COMMIT TRANSACTION
END TRY

  BEGIN CATCH
  ROLLBACK TRANSACTION
  END CATCH


END --sp_AT_Populate_User

GO





--***************************************

