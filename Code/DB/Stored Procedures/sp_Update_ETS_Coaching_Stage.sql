/*
sp_Update_ETS_Coaching_Stage(02).sql
Last Modified Date: 3/22/2017
Last Modified By: Susmitha Palacherla

Version 02: Updated to support reused numeric part of Employee ID per TFS 6011 - 03/21/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/

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
-- Revision History
-- Last Modified By - Susmitha Palacherla
-- Modified per scr 14031 to incorporate the compliance reports - 01/05/2015
-- Updated to support reused numeric part of Employee ID per TFS 6011 - 03/21/2017
-- =============================================
CREATE PROCEDURE [EC].[sp_Update_ETS_Coaching_Stage] 
@Count INT OUTPUT
AS
BEGIN



BEGIN
UPDATE [EC].[ETS_Coaching_Stage]
SET [Emp_ID]= [EC].[RemoveAlphaCharacters](REPLACE(LTRIM(RTRIM([Emp_ID])),' ',''))
WHERE [Emp_ID] NOT IN
 (SELECT DISTINCT [Emp_ID]FROM [EC].[Employee_Ids_With_Prefixes])
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


