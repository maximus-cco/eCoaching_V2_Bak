/*
eCoaching_Admin_Tool_Tables_Create(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


**************************************************************

--Table list

**************************************************************

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





**************************************************************

--Table creates

**************************************************************/

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
('WarningUser',0),
('SeniorManager',0)

          
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
('ReactivateWarningLogs'),
('SeniorManagerDashboard')


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
(103,207),
(105,208)



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
           ('WACQ13','Sr Specialist, Quality (CS)',103,'WarningAdmin',0,1),
           ('WACS60','Sr Manager, Customer Service',105,'SeniorManager',1,1)
      

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




