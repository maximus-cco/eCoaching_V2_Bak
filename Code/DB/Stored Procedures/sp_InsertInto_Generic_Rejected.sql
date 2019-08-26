/*
sp_InsertInto_Generic_Rejected(01).sql
Last Modified Date: 08/27/2019
Last Modified By: Susmitha Palacherla

Version 02: Modified to support ATT AP% feeds. TFS 15095  - 08/27/2019
Version 01: Document Initial Revision - Added support for DTT generic feed. - TFS 7646 - 9/1/2017
*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Generic_Rejected' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_Generic_Rejected]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		   Susmitha Palacherla
-- Create date: 8/31/2017
-- Description:	Determines rejection Reason for Generic logs.
-- Populates the records with reject reasons to the Reject table.
-- Revision History:
-- Initial Revision. DTT Feed - TFS 7646 - 08/31/2017
-- Modified to support AP% feeds. TFS 15095  - 8/27/2019
-- =============================================
CREATE PROCEDURE [EC].[sp_InsertInto_Generic_Rejected] 

AS
BEGIN


-- Reject Logs where Active Employee record does not exist

BEGIN
UPDATE [EC].[Generic_Coaching_Stage]
SET [Reject_Reason]= N'Record does not belong to Active Employee.'
WHERE (CSR_EMPID NOT IN 
(SELECT DISTINCT EMP_ID FROM [EC].[Employee_Hierarchy]
 WHERE Active = 'A'))
 OR CSR_EMPID = '999999'
AND [Reject_Reason]is NULL
	
OPTION (MAXDOP 1)
END  
       
WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

-- Reject Logs that are  for Sup Module and Employee does not have a Sup job code.(DTT)
BEGIN
UPDATE [EC].[Generic_Coaching_Stage]
SET [Reject_Reason]= 
     CASE WHEN [Report_Code] like 'DTT%'
     AND [Emp_Role] <> 'S' THEN N'Employee does not have a Supervisor job code.'
ELSE NULL END
WHERE [Emp_Role] <> 'S' and [Reject_Reason]is NULL
OPTION (MAXDOP 1)
END  
       
WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

-- Reject Logs that are for CSR Module and Employee does not have a CSR job code.(SEA)
BEGIN
UPDATE [EC].[Generic_Coaching_Stage]
SET [Reject_Reason]= CASE WHEN ([Report_Code] not like 'DTT%' AND [Report_Code] not like 'OTH%' )
AND [Emp_Role] <> 'C' THEN N'Employee does not have a CSR job code.'
ELSE NULL END
WHERE [Emp_Role] <> 'C' AND [Reject_Reason]is NULL
OPTION (MAXDOP 1)
END  
      
WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

 -- Reject Logs where Module submitted does not match Employee record (OTH)
 BEGIN
 UPDATE [EC].[Generic_Coaching_Stage]
SET [Reject_Reason]= CASE WHEN [Report_Code] like 'OTH%'
AND [Module_ID] <> [EC].[fn_intModuleIDFromEmpID](CSR_EMPID)
THEN N'Module submitted does not match Employee job code.'
ELSE NULL END
WHERE [Reject_Reason]is NULL

 OPTION (MAXDOP 1)
END  
      
WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

-- Write rejected records to Rejected table.

BEGIN
INSERT INTO [EC].[Generic_Coaching_Rejected]
           ([Report_ID]
		   ,[Report_Code]
           ,[Event_Date]
           ,[FileName]
           ,[Rejected_Reason]
           ,[Rejected_Date])
          SELECT s.[Report_ID]
		   ,S.[Report_Code]
           ,S.[Event_Date]
           ,S.[FileName]
           ,S.[Reject_Reason]
           ,GETDATE()
           FROM [EC].[Generic_Coaching_Stage] S
           WHERE S.[Reject_Reason] is not NULL
      

OPTION (MAXDOP 1)
END

END  -- [EC].[sp_InsertInto_Generic_Rejected]
GO


