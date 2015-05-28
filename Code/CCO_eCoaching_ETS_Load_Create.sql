/*
eCoaching_Outliers_Create(04).sql
Last Modified Date: 01/12/2015
Last Modified By: Susmitha Palacherla


Version 04:   01/12/2015
1. Updated per SCR to increase column size of Time_code column in ETS Rejected, Stage and Fact tables.
 [EC].[sp_Update_ETS_Coaching_Stage]  
 [EC].[sp_InsertInto_Coaching_Log_ETS]  
 [EC].[sp_InsertInto_ETS_Rejected]

Version 03:  12/15/14
1. Updated the following sps to incorporate the compliance reports per SCr 14031..


Version 02:  11/20/14
1. Additional changes from V&V feedback for SCR 13659 ETS feed Load.
Added 2 columns to table [EC].[ETS_Coaching_Stage] ( [Report_ID] and [Reject_Reason])
Modified existing SPs (#1 and #2)
Added 1 new SP (#4) [sp_InsertInto_ETS_Rejected]


Version 01:  11/14/14
1. Initial Revision. SCR 13659. 


Summary

Tables
1. Create Table [EC].[ETS_Coaching_Stage] 
2. Create Table [EC].[ETS_FileList]  
3. Create Table [EC].[ETS_Coaching_Rejected]
4. Create Table [EC].[ETS_Coaching_Fact] 
5. Create Table [EC].[ETS_Description]

SQL
1. Insert data into [EC].[ETS_Description]

Procedures
1. Create SP  [EC].[sp_Update_ETS_Coaching_Stage]  
2. Create SP  [EC].[sp_InsertInto_Coaching_Log_ETS]  
3. Create SP [EC].[sp_Update_ETS_Fact]
4. Create SP [EC].[sp_InsertInto_ETS_Rejected]
*/


 --Details

**************************************************************
--Tables
**************************************************************

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
	[Project_Number] [nvarchar](8) NULL,
	[Task_Number] [nvarchar](8) NULL,
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
	[Project_Number] [nvarchar](8) NULL,
	[Task_Number] [nvarchar](8) NULL,
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
	[Project_Number] [nvarchar](8) NULL,
	[Task_Number] [nvarchar](8) NULL,
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
--SQL
**************************************************************

--1. Insert data into [EC].[ETS_Description]

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
      


**************************************************************

--Procedures

**************************************************************

--1. Create SP  [EC].[sp_Update_ETS_Coaching_Stage]


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update_ETS_Coaching_Stage' 
)
   DROP PROCEDURE [EC].[sp_Update_ETS_Coaching_Stage]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		   Susmitha Palacherla
-- Create date: 10/30/2014
-- Description:	Performs the following actions.
-- Removes Alpha characters from first 2 positions of Emp_ID
-- Populate Employee and Hierarchy attributes from Employee Table
-- Inserts non CSR and supervisor records into Rejected table
-- Deletes rejected records.
-- Sets the detailed Description value by concatenating other attributes.
-- Last Modified Date - 01/05/2015
-- Last Modified By - Susmitha Palacherla
-- Modified per scr 14031 to incorporate the compliance reports.

-- =============================================
CREATE PROCEDURE [EC].[sp_Update_ETS_Coaching_Stage] 
@Count INT OUTPUT
AS
BEGIN



BEGIN
UPDATE [EC].[ETS_Coaching_Stage]
SET [Emp_ID]= [EC].[RemoveAlphaCharacters]([Emp_ID])  
OPTION (MAXDOP 1)
END  
    
    
WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms
    
-- Populate Attributes from Employee Table
BEGIN
UPDATE [EC].[ETS_Coaching_Stage]
SET [Emp_LanID] = EMP.[Emp_LanID]
    ,[Emp_Site]= EMP.[Emp_Site]
    ,[Emp_Program]= EMP.[Emp_Program]
    ,[Emp_SupID]= EMP.[Sup_ID]
    ,[Emp_MgrID]= EMP.[Mgr_ID]
    ,[Emp_Role]= 
    CASE WHEN EMP.[Emp_Job_Code]in ('WACS01', 'WACS02','WACS03') THEN 'C'
    WHEN EMP.[Emp_Job_Code] = 'WACS40' THEN 'S'
    ELSE 'O' END
    ,[TextDescription] = [EC].[fn_strETSDescriptionFromRptCode] (LEFT([Report_Code],LEN([Report_Code])-8))
FROM [EC].[ETS_Coaching_Stage] STAGE JOIN [EC].[Employee_Hierarchy]EMP
ON LTRIM(STAGE.Emp_ID) = LTRIM(EMP.Emp_ID)

OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

-- Reject records not belonging to CSRs and Supervisors
BEGIN
EXEC [EC].[sp_InsertInto_ETS_Rejected] 
END

WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms


-- Delete rejected records

BEGIN
DELETE FROM [EC].[ETS_Coaching_Stage]
WHERE [Reject_Reason]is not NULL

SELECT @Count =@@ROWCOUNT

OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

-- Assign Record ID

BEGIN

DECLARE @id INT 
SET @id = 0 
UPDATE [EC].[ETS_Coaching_Stage]
SET @id = [Report_ID] = @id + 1 

OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

-- Populate TextDescription by concatenating the individual detail fields.

BEGIN
UPDATE [EC].[ETS_Coaching_Stage]
SET [TextDescription] = 
CASE WHEN LEFT([Report_Code],LEN([Report_Code])-8)= 'OAE' THEN ([TextDescription] + CHAR(13) + CHAR (10) + ' ' + CHAR(13) + CHAR (10) + 
LEFT([Event_Date],LEN([Event_Date])-8)+ ' | ' + [EC].[fn_strEmpNameFromEmpID] (Emp_ID))
WHEN LEFT([Report_Code],LEN([Report_Code])-8)= 'OAS' THEN ([TextDescription] + CHAR(13) + CHAR (10) + ' ' + CHAR(13) + CHAR (10) + 
LEFT([Event_Date],LEN([Event_Date])-13)+ ' | ' + [EC].[fn_strEmpNameFromEmpID] (Emp_ID)+ ' | ' + [Associated_Person])
ELSE ([TextDescription] + CHAR(13) + CHAR (10) + ' ' + CHAR(13) + CHAR (10) +  'The date, project and task numbers, time code, total and daily hours are below:' 
+ CHAR(13) + CHAR (10) + ' ' + CHAR(13) + CHAR (10) +  LEFT([Event_Date],LEN([Event_Date])-8)+ ' | ' + [Project_Number]+ ' | ' + [Task_Number] 
      + ' | ' + [Task_Name] + ' | ' + [Time_Code]  + ' | ' + [Associated_Person] + ' | ' + [Hours] 
      + ' | ' + [Sat] + ' | ' + [Sun] + ' | ' + [Mon] + ' | ' + [Tue] + ' | ' + [Wed] + ' | ' + [Thu] + ' | ' + [Fri] )END

OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

END  -- [EC].[sp_Update_ETS_Coaching_Stage]



GO







**************************************************************

--2. Create SP  [EC].[sp_InsertInto_Coaching_Log_ETS]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Coaching_Log_ETS' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_Coaching_Log_ETS]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      11/07/2014
--    Description:     This procedure inserts the ETS records into the Coaching_Log table. 
--                     The main attributes of the eCL are written to the Coaching_Log table.
--                     The Coaching Reasons are written to the Coaching_Reasons Table.
-- Last Modified Date: 01/06/2015
-- Last Updated By: Susmitha Palacherla
-- Changes for incorporating Compliance Reports per SCR 14031.

--    =====================================================================
CREATE PROCEDURE [EC].[sp_InsertInto_Coaching_Log_ETS]
@Count INT OUTPUT
  
AS
BEGIN

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY
      
      DECLARE @maxnumID INT
       -- Fetches the maximum CoachingID before the insert.
      SET @maxnumID = (SELECT IsNUll(MAX([CoachingID]), 0) FROM [EC].[Coaching_Log])    
      
      
      -- Inserts records from the Quality_Coaching_Stage table to the Coaching_Log Table

         INSERT INTO [EC].[Coaching_Log]
           ([FormName]
           ,[ProgramName]
           ,[SourceID]
           ,[StatusID]
           ,[SiteID]
           ,[EmpLanID]
           ,[EmpID]
           ,[SubmitterID]
           ,[EventDate]
           ,[isAvokeID]
		   ,[isNGDActivityID]
           ,[isUCID]
           ,[isVerintID]
           ,[Description]
	       ,[SubmittedDate]
           ,[StartDate]
           ,[isCSE]
           ,[isCSRAcknowledged]
           ,[numReportID]
           ,[strReportCode]
           ,[ModuleID]
           ,[SupID]
           ,[MgrID]
           )

            SELECT DISTINCT
            lower(es.Emp_LanID)	[FormName],
            es.Emp_Program   [ProgramName],
            221             [SourceID],
            CASE es.emp_role when 'C' THEN 6 
            WHEN 'S' THEN 5 ELSE -1 END[StatusID],
            [EC].[fn_intSiteIDFromEmpID](LTRIM(es.EMP_ID))[SiteID],
            lower(es.Emp_LanID)	[EmpLanID],
            es.EMP_ID [EmpID],
            '999999'	 [SubmitterID],       
            es.Event_Date [EventDate],
            0			[isAvokeID],
		    0			[isNGDActivityID],
            0			[isUCID],
            0          [isVerintID],
            REPLACE(EC.fn_nvcHtmlEncode(es.TextDescription), CHAR(13) + CHAR(10) ,'<br />')[Description],	
            es.Submitted_Date  [SubmittedDate], 
		    es.Event_Date	[StartDate],
		    0 [isCSE],			
		    0 [isCSRAcknowledged],
		    es.Report_ID [numReportID],
		    es.Report_Code [strReportCode],
		    CASE es.emp_role when 'C' THEN 1
            WHEN 'S' THEN 2 ELSE -1 END [ModuleID],
          	ISNULL(es.[Emp_SupID],'999999')  [SupID],
		    ISNULL(es.[Emp_MgrID],'999999')  [MgrID]
            
FROM [EC].[ETS_Coaching_Stage] es 
left outer join EC.Coaching_Log cf on es.Report_Code = cf.strReportCode
and es.Event_Date = cf.EventDate and  es.Report_ID = cf.numReportID
where cf.strReportCode is null and cf.EventDate is NULL and cf.numReportID is NULL
OPTION (MAXDOP 1)

SELECT @Count =@@ROWCOUNT

WAITFOR DELAY '00:00:00:05'  -- Wait for 5 ms

UPDATE [EC].[Coaching_Log]
SET [FormName] = 'eCL-'+[FormName] +'-'+ convert(varchar,CoachingID)
where [FormName] not like 'eCL%'    
OPTION (MAXDOP 1)

WAITFOR DELAY '00:00:00:05'  -- Wait for 5 ms

 
  -- Inserts records into Coaching_Log_reason table for each record inserted into Coaching_log table.

INSERT INTO [EC].[Coaching_Log_Reason]
           ([CoachingID]
           ,[CoachingReasonID]
           ,[SubCoachingReasonID]
           ,[Value])
    SELECT cf.[CoachingID],
           22,
           [EC].[fn_intSubCoachReasonIDFromETSRptCode](LEFT(cf.strReportCode,LEN(cf.strReportCode)-8)),
           CASE WHEN LEFT(cf.strReportCode,LEN(cf.strReportCode)-8) IN ('OAE','OAS')
           THEN 'Research Required' ELSE 'Opportunity' END
          /* CASE LEFT(cf.strReportCode,LEN(cf.strReportCode)-8)
           WHEN 'OAE' THEN 'Research Required'
           WHEN 'OAS' THEN 'Research Required'
           ELSE 'Opportunity' END */
    FROM [EC].[ETS_Coaching_Stage] es  INNER JOIN  [EC].[Coaching_Log] cf      
    ON (es.[Report_Code] = cf.[strReportCode]
   and es.Event_Date = cf.EventDate and es.Emp_ID = cf.EmpID and es.Report_ID = cf.numReportID)
    LEFT OUTER JOIN  [EC].[Coaching_Log_Reason] cr
    ON cf.[CoachingID] = cr.[CoachingID]  
    WHERE cr.[CoachingID] IS NULL 
 OPTION (MAXDOP 1)  

                  
COMMIT TRANSACTION
END TRY

      
      BEGIN CATCH
      IF @@TRANCOUNT > 0
      ROLLBACK TRANSACTION


    DECLARE @ErrorMessage NVARCHAR(4000)
    DECLARE @ErrorSeverity INT
    DECLARE @ErrorState INT

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE()

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
  END CATCH  
END -- sp_InsertInto_Coaching_Log_ETS


GO






***************************************************************************************************

--3. Create SP   [EC].[sp_Update_ETS_Fact]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update_ETS_Fact' 
)
   DROP PROCEDURE [EC].[sp_Update_ETS_Fact]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      11/11/2014
--    Description:     This procedure inserts new ETS records into Fact table.
--   Modified Date:    
--   Description:    
--    =====================================================================
CREATE PROCEDURE [EC].[sp_Update_ETS_Fact]
  
AS
BEGIN

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY
      

 -- Append new records to ETS Fact Table

INSERT INTO [EC].[ETS_Coaching_Fact]
           ([Report_Code]
           ,[Event_Date]
           ,[Emp_ID]
           ,[Project_Number]
           ,[Task_Number]
           ,[Task_Name]
           ,[Time_Code]
           ,[Associated_Person]
           ,[Hours]
           ,[Sat]
           ,[Sun]
           ,[Mon]
           ,[Tue]
           ,[Wed]
           ,[Thu]
           ,[Fri]
           ,[Exemp_Status]
           ,[Inserted_Date]
           ,[FileName])
   SELECT S.[Report_Code]
      ,S.[Event_Date]
      ,S.[Emp_ID]
      ,S.[Project_Number]
      ,S.[Task_Number]
      ,S.[Task_Name]
      ,S.[Time_Code]
      ,S.[Associated_Person]
      ,S.[Hours]
      ,S.[Sat]
      ,S.[Sun]
      ,S.[Mon]
      ,S.[Tue]
      ,S.[Wed]
      ,S.[Thu]
      ,S.[Fri]
      ,S.[Exemp_Status]
      ,GETDATE()
      ,S.[FileName]
  FROM [EC].[ETS_Coaching_Stage]S LEFT OUTER JOIN [EC].[ETS_Coaching_Fact]F
  ON S.[Report_Code] = F.[Report_Code]
  AND S.[Emp_ID]= F.[Emp_ID]
  AND S.[Event_Date]= F.[Event_Date]
  WHERE  F.[Report_Code]IS NULL AND F.[Emp_ID]IS NULL AND F.[Event_Date]IS NULL
                  
COMMIT TRANSACTION
END TRY

      
      BEGIN CATCH
      IF @@TRANCOUNT > 0
      ROLLBACK TRANSACTION


    DECLARE @ErrorMessage NVARCHAR(4000)
    DECLARE @ErrorSeverity INT
    DECLARE @ErrorState INT

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE()

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
  END CATCH  
END -- sp_Update_ETS_Fact
GO


***************************************************************************************************

--4. Create SP   [EC].[sp_InsertInto_ETS_Rejected]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_ETS_Rejected' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_ETS_Rejected]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		   Susmitha Palacherla
-- Create date: 11/19/14
-- Description:	Determines rejection Reason for ETS logs.
-- Populates the records with reject reasons to the Reject table.
-- Last Modified Date - 01/05/2015
-- Last Modified By - Susmitha Palacherla
-- Modified per scr 14031 to incorporate the compliance reports.
-- =============================================
CREATE PROCEDURE [EC].[sp_InsertInto_ETS_Rejected] 

AS
BEGIN

-- Determine and populate Reject Reasons


BEGIN
UPDATE [EC].[ETS_Coaching_Stage]
SET [Reject_Reason]= N'Report Code not valid.'
WHERE LEFT([Report_Code],LEN([Report_Code])-8) NOT IN 
(SELECT DISTINCT ReportCode FROM [EC].[ETS_Description])
	
OPTION (MAXDOP 1)
END  
    
  
    
WAITFOR DELAY '00:00:00.03' -- Wait for 5 ms


BEGIN
UPDATE [EC].[ETS_Coaching_Stage]
SET [Reject_Reason]= N'Employee Not found in Hierarchy table.'
WHERE EMP_ID NOT IN 
(SELECT DISTINCT EMP_ID FROM [EC].[Employee_Hierarchy])
AND [Reject_Reason]is NULL
	
OPTION (MAXDOP 1)
END  
    
    
WAITFOR DELAY '00:00:00.03' -- Wait for 5 ms


BEGIN
UPDATE [EC].[ETS_Coaching_Stage]
SET [Reject_Reason]= CASE WHEN LEFT(Report_Code,LEN(Report_Code)-8) IN ('EA', 'EOT','FWH','HOL','ITD', 'ITI', 'UTL', 'OAE')
AND [Emp_Role]not in ( 'C','S') THEN N'Employee does not have a CSR or Supervisor job code.'
WHEN LEFT(Report_Code,LEN(Report_Code)-8) IN ('FWHA','HOLA','ITDA', 'ITIA', 'UTLA','OAS') 
AND [Emp_Role] <> 'S' THEN N'Approver does not have a Supervisor job code.'
ELSE NULL END
WHERE [Emp_Role] NOT in ('C','S')AND [Reject_Reason]is NULL
OPTION (MAXDOP 1)
END  
   


    
WAITFOR DELAY '00:00:00.03' -- Wait for 5 ms
    

-- Write rejected records to Rejected table.

BEGIN
INSERT INTO [EC].[ETS_Coaching_Rejected]
           ([Report_Code]
           ,[Event_Date]
           ,[Emp_ID]
           ,[Emp_LanID]
           ,[Emp_Site]
           ,[Emp_Program]
           ,[Emp_SupID]
           ,[Emp_MgrID]
           ,[Emp_Role]
           ,[Project_Number]
           ,[Task_Number]
           ,[Task_Name]
           ,[Time_Code]
           ,[Associated_Person]
           ,[Hours]
           ,[Sat]
           ,[Sun]
           ,[Mon]
           ,[Tue]
           ,[Wed]
           ,[Thu]
           ,[Fri]
           ,[Exemp_Status]
           ,[FileName]
           ,[Reject_Reason]
           ,[Reject_Date])
          SELECT S.[Report_Code]
           ,S.[Event_Date]
           ,S.[Emp_ID]
           ,S.[Emp_LanID]
           ,S.[Emp_Site]
           ,S.[Emp_Program]
           ,S.[Emp_SupID]
           ,S.[Emp_MgrID]
           ,S.[Emp_Role]
           ,S.[Project_Number]
           ,S.[Task_Number]
           ,S.[Task_Name]
           ,S.[Time_Code]
           ,S.[Associated_Person]
           ,S.[Hours]
           ,S.[Sat]
           ,S.[Sun]
           ,S.[Mon]
           ,S.[Tue]
           ,S.[Wed]
           ,S.[Thu]
           ,S.[Fri]
           ,S.[Exemp_Status]
           ,S.[FileName]
           ,S.[Reject_Reason]
           ,GETDATE()
           FROM [EC].[ETS_Coaching_Stage] S
           WHERE S.[Reject_Reason] is not NULL
      

OPTION (MAXDOP 1)
END

END  -- [EC].[sp_InsertInto_ETS_Rejected]


GO





