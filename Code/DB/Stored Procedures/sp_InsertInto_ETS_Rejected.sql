/*
sp_InsertInto_ETS_Rejected(02).sql
Last Modified Date: 7/26/2017
Last Modified By: Susmitha Palacherla

Version 02: Updated to incorporate HNC and ICC Reports per TFS 7174 - 07/26/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/

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
-- Modified to support HNC and ICC Reports for CSRs. TFS 7174 - 07/21/2017
-- =============================================
CREATE PROCEDURE [EC].[sp_InsertInto_ETS_Rejected] 

AS
BEGIN

-- Determine and populate Reject Reasons
-- Reject logs with incorrect or non-supported ETS report Code 

BEGIN
UPDATE [EC].[ETS_Coaching_Stage]
SET [Reject_Reason]= N'Report Code not valid.'
WHERE LEFT([Report_Code],LEN([Report_Code])-8) NOT IN 
(SELECT DISTINCT ReportCode FROM [EC].[ETS_Description])
	
OPTION (MAXDOP 1)
END  

    
WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

-- Reject Logs with Employee not found.

BEGIN
UPDATE [EC].[ETS_Coaching_Stage]
SET [Reject_Reason]= N'Employee Not found in Hierarchy table.'
WHERE EMP_ID NOT IN 
(SELECT DISTINCT EMP_ID FROM [EC].[Employee_Hierarchy])
AND [Reject_Reason]is NULL
	
OPTION (MAXDOP 1)
END  
       
WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

-- Reject Logs that can only be for Sup Module and Employee does not have a Sup job code.
BEGIN
UPDATE [EC].[ETS_Coaching_Stage]
SET [Reject_Reason]= CASE WHEN LEFT(Report_Code,LEN(Report_Code)-8) IN ('FWHA','HOLA','ITDA', 'ITIA', 'UTLA','OAS','EOT') 
AND [Emp_Role] <> 'S' THEN N'Approver does not have a Supervisor job code.'
ELSE NULL END
WHERE [Emp_Role] <> 'S' and [Reject_Reason]is NULL
OPTION (MAXDOP 1)
END  
       
WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

-- Reject Logs that can only be for CSR Module and Employee does not have a CSR job code.
BEGIN
UPDATE [EC].[ETS_Coaching_Stage]
SET [Reject_Reason]= CASE WHEN LEFT(Report_Code,LEN(Report_Code)-8) IN ('HNC', 'ICC')
AND [Emp_Role] <> 'C' THEN N'Employee does not have a CSR job code.'
ELSE NULL END
WHERE [Emp_Role] <> 'C' AND [Reject_Reason]is NULL
OPTION (MAXDOP 1)
END  
       
WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

--Reject logs that can be for either CSR or Sup Module and do not have supporting job codes.
BEGIN
UPDATE [EC].[ETS_Coaching_Stage]
SET [Reject_Reason]= CASE WHEN LEFT(Report_Code,LEN(Report_Code)-8) IN ('EA','FWH','HOL','ITD', 'ITI', 'UTL', 'OAE')
AND [Emp_Role] not in ( 'C','S') THEN N'Employee does not have a CSR or Supervisor job code.'
ELSE NULL END
WHERE [Emp_Role] NOT in ('C','S')AND [Reject_Reason]is NULL
OPTION (MAXDOP 1)
END  
   
   
WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

 

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


