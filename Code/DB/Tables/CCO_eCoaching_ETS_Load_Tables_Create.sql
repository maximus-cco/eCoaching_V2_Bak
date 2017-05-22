/*
CCO_eCoaching_ETS_Load_Tables_Create.sql(02).sql
Last Modified Date: 5/22/2017
Last Modified By: Susmitha Palacherla


Version 02: Update tables 1,3 and 4
to accommodate longer Task and project numbers - TFS 6624 - 5/22/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


**************************************************************

--Table list

**************************************************************


1. Create Table [EC].[ETS_Coaching_Stage] 
2. Create Table [EC].[ETS_FileList]  
3. Create Table [EC].[ETS_Coaching_Rejected]
4. Create Table [EC].[ETS_Coaching_Fact] 
5. Create Table [EC].[ETS_Description]


**************************************************************

--Table creates

**************************************************************/


--1. Create Table [EC].[ETS_Coaching_Stage]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[ETS_Coaching_Stage](
	[Report_Code] [nvarchar](20) NULL,
                  [Report_ID][int] NULL,
	[Event_Date] [datetime] NULL,
	[Submitted_Date] [datetime] NULL,
	[Emp_ID] [nvarchar](20) NULL,
	[Emp_LanID] [nvarchar](30) NULL,
	[Emp_Site] [nvarchar](20) NULL,
	[Emp_Program] [nvarchar](30) NULL,
	[Emp_SupID] [nvarchar](20) NULL,
	[Emp_MgrID] [nvarchar](20) NULL,
	[Emp_Role] [nvarchar](3) NULL,
	[Project_Number] [nvarchar](20) NULL,
	[Task_Number] [nvarchar](20) NULL,
	[Task_Name] [nvarchar](60) NULL,
	[Time_Code] [nvarchar](30) NULL,
	[Associated_Person] [nvarchar](30) NULL,
	[Hours] [nvarchar](8) NULL,
	[Sat] [nvarchar](8) NULL,
	[Sun] [nvarchar](8) NULL,
	[Mon] [nvarchar](8) NULL,
	[Tue] [nvarchar](8) NULL,
	[Wed] [nvarchar](8) NULL,
	[Thu] [nvarchar](8) NULL,
	[Fri] [nvarchar](8) NULL,
	[Exemp_Status] [nvarchar](20) NULL,
	[TextDescription] [nvarchar](max) NULL,
	[FileName] [nvarchar](260) NULL,
                  [Reject_Reason] [nvarchar](200) NULL
) ON [PRIMARY]

GO






**************************************************************

--2. Create Table [EC].[ETS_FileList]


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[ETS_FileList](
	[File_SeqNum] [int] IDENTITY(1,1) NOT NULL,
	[File_Name] [nvarchar](260) NULL,
	[File_LoadDate] [datetime] NULL,
	[Count_Staged] [int] NULL,
	[Count_Loaded] [int] NULL,
	[Count_Rejected] [int] NULL
) ON [PRIMARY]

GO


**************************************************************

--3. Create Table [EC].[ETS_Coaching_Rejected]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[ETS_Coaching_Rejected](
	[Report_Code] [nvarchar](20) NULL,
	[Event_Date] [datetime] NULL,
	[Emp_ID] [nvarchar](20) NULL,
	[Emp_LanID] [nvarchar](30) NULL,
	[Emp_Site] [nvarchar](20) NULL,
	[Emp_Program] [nvarchar](30) NULL,
	[Emp_SupID] [nvarchar](20) NULL,
	[Emp_MgrID] [nvarchar](20) NULL,
	[Emp_Role] [nvarchar](3) NULL,
	[Project_Number] [nvarchar](20) NULL,
	[Task_Number] [nvarchar](20) NULL,
	[Task_Name] [nvarchar](60) NULL,
	[Time_Code] [nvarchar](30) NULL,
	[Associated_Person] [nvarchar](30) NULL,
	[Hours] [nvarchar](8) NULL,
	[Sat] [nvarchar](8) NULL,
	[Sun] [nvarchar](8) NULL,
	[Mon] [nvarchar](8) NULL,
	[Tue] [nvarchar](8) NULL,
	[Wed] [nvarchar](8) NULL,
	[Thu] [nvarchar](8) NULL,
	[Fri] [nvarchar](8) NULL,
	[Exemp_Status] [nvarchar](20) NULL,
	[FileName] [nvarchar](260) NULL,
	[Reject_Reason] [nvarchar](200) NULL,
	[Reject_Date] [datetime] NULL
) ON [PRIMARY]

GO

**************************************************************

--4. Create Table [EC].[ETS_Coaching_Fact]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[ETS_Coaching_Fact](
	[Report_Code] [nvarchar](20) NULL,
	[Event_Date] [datetime] NULL,
	[Emp_ID] [nvarchar](20) NULL,
	[Project_Number] [nvarchar](20) NULL,
	[Task_Number] [nvarchar](20) NULL,
	[Task_Name] [nvarchar](60) NULL,
	[Time_Code] [nvarchar](30) NULL,
	[Associated_Person] [nvarchar](30) NULL,
	[Hours] [nvarchar](8) NULL,
	[Sat] [nvarchar](8) NULL,
	[Sun] [nvarchar](8) NULL,
	[Mon] [nvarchar](8) NULL,
	[Tue] [nvarchar](8) NULL,
	[Wed] [nvarchar](8) NULL,
	[Thu] [nvarchar](8) NULL,
	[Fri] [nvarchar](8) NULL,
	[Exemp_Status] [nvarchar](20) NULL,
	[Inserted_Date] [datetime] NULL,
	[FileName] [nvarchar](260) NULL
) ON [PRIMARY]

GO

**************************************************************

--5. Create Table [EC].[ETS_Description]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[ETS_Description](
	[ReportCode] [nvarchar](20) NOT NULL,
	[ReportDescription] [nvarchar](100) NULL,
	[Description] [nvarchar](max) NULL
) ON [PRIMARY]

GO


**************************************************************


--5b. Insert data into [EC].[ETS_Description]

INSERT INTO [EC].[ETS_Description]
           ([ReportCode]
           ,[ReportDescription]
           ,[Description])
     VALUES
          ('EA','Excused Absence',
  N'The employee recorded incorrect Excused Absence hours.
  All paid leave (General Leave or floating Holiday time) must be exhausted before using Excused Absence 080984 | 3517.
  Excused Absence cannot be taken for full days of leave and you must have some worked hours recorded for the days this project|task code is used.
  Exempt employees absent for a full day must use LWOP 080984 | 9005.'),
          ('EOT','Exempt Over Time',
  N'The exempt employee incorrectly recorded overtime hours.
  Exempt employees are expected to occasionally exceed the standard workweek (Saturday through Friday) as assigned tasks may demand. 
  In most cases such work, which exceeds the standard workweek, is not eligible for additional pay and should be recorded as straight time.
  CCO exempt employees should not charge overtime without direction from CCO Communications.'),
          ('FWH','Future Worked Hours',
  N'The employee has entered worked hours in advance.  
  The only circumstances in which worked hours should be entered in advance are:
   When the employee’s Friday shift doesn’t start until after the stated deadline for them to sign their timecard or
   When the employee is working off-site or traveling and will not have access to ETS.
   If this employee doesn’t fall under one of these situations please coach them and have them remove the future worked hours from their timecard.'),
          ('FWHA','Future Worked Hours (Approver)',
   N'The employee has approved a timecard with worked hours entered in advance.  
  The only circumstances in which worked hours should be entered in advance are:
   When the employee’s Friday shift doesn’t start until after the stated deadline for them to approve timecards or
   When the employee is working off-site or traveling and will not have access to ETS for approvals.
   If this employee doesn’t fall under one of these situations please coach them and have them remove the future worked hours from their timecard.'),
          ('HOL','Incorrect Holiday',
N'The non-exempt employee recorded incorrect hours on a holiday or recorded holiday hours on an incorrect day. 
As a reminder, per HR-POL-203 Holidays, for employees with GSA administered benefits:
Holiday can only be recorded on the day it is observed. 
To receive holiday pay, other paid hours must be recorded in the week in which a holiday is observed. 
 If an employee works on the observed holiday, holiday and time worked would be recorded.  
If the observed holiday falls on an employee’s scheduled day-off, only holiday hours would be recorded. 
Leave time cannot be recorded on a day in which a holiday is recorded. 
Shift and bilingual premiums do not apply to holiday hours. 
When an employee takes a fixed holiday off, the time must be charged in a whole-day increment to holiday, regardless of the total number of hours worked in the particular pay period.'),
          ('HOLA','Incorrect Holiday (Approver)',
N'A timecard was approved with incorrect hours recorded on a holiday or holiday hours recorded on an incorrect day. 
As a reminder, per HR-POL-203 Holidays, for employees with GSA administered benefits:
Holiday can only be recorded on the day it is observed. 
To receive holiday pay, other paid hours must be recorded in the week in which a holiday is observed. 
If an employee works on the observed holiday, holiday and time worked would be recorded.  
If the observed holiday falls on an employee’s scheduled day-off, only holiday hours would be recorded. 
Leave time cannot be recorded on a day in which a holiday is recorded. 
Shift and bilingual premiums do not apply to holiday hours. 
When an employee takes a fixed holiday off, the time must be charged in a whole-day increment to holiday, regardless of the total number of hours worked in the particular pay 
period.'),
          ('ITD','Invalid Timecodes Direct',
  N'The employee recorded worked hours with a time code that is not valid in the CCO program.
  Please see your supervisor for a list of valid time codes used in the CCO.'),
          ('ITDA','Invalid Timecodes Direct (Approver)',
  N'The employee approved a timecard with a time code that is not valid in the CCO program.  
  The list of valid time codes can be found in the Common_CCO_Time_Codes document on CCO Knowledge Net under the timekeeping category.'),
          ('ITI','Invalid Timecodes Indirect',
   N'The employee recorded paid leave with an invalid time code.  
   Paid leave is not eligible for shift or bilingual premium.  All paid leave must be recorded with time code of 01 or *.'),
          ('ITIA','Invalid Timecodes Indirect (Approver)',
  N'The employee approved a timecard that had paid leave with and invalid time code. 
  Paid leave is not eligible for shift or bilingual premium.  
  All paid leave must be recorded with time code of 01 or *.'),
          ('UTL','Utilization','TBD'),
          ('UTLA','Utilization (Approver)','TBD'),
  ('OAE','Outstanding Action (Employee) ',
  N'The employee either did not sign his or her timecard by the Friday deadline for the period below, or it was signed with errors and rejected. 
      Please review and take action as necessary.

     The time period and employee name are below:'),
          ('OAS','Outstanding Action (Supervisor)',
  N'The supervisor did not approve or reject the timecard below by the Friday deadline.
      Please review and take action as necessary.

      The time period, manager name, and name of employee whose timecard requires action are below:')

GO
      


--**************************************************************

