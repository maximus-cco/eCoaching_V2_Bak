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
-- Modified to support ATT AP% feeds. TFS 15095  - 8/27/2019
-- Modified to support eCoaching Log for Subcontractors - TFS 27527 - 02/01/2024
-- Modified to Support ISG Alignment Project. TFS 28026 - 05/06/2024
-- =============================================
CREATE OR ALTER PROCEDURE [EC].[sp_InsertInto_Generic_Rejected] 

AS
BEGIN

-- Employee Site Inactive
UPDATE [EC].[Generic_Coaching_Stage]
SET [Reject_Reason]= 'Employee Site Inactive.'
FROM [EC].[Generic_Coaching_Stage] gs JOIN [EC].[Employee_Hierarchy] eh 
ON gs.CSR_EMPID = eh.Emp_ID JOIN [EC].[DIM_SITE] s
ON eh.Emp_Site = s.[City]
WHERE s.isActive = 0
AND [Reject_Reason] is NULL;
 
 WAITFOR DELAY '00:00:00.01' ;-- Wait for 1 ms

-- Reject Logs where Active Employee record does not exist
UPDATE [EC].[Generic_Coaching_Stage]
SET [Reject_Reason]= N'Record does not belong to Active Employee.'
WHERE (CSR_EMPID NOT IN 
(SELECT DISTINCT EMP_ID FROM [EC].[Employee_Hierarchy]
 WHERE Active = 'A'))
 OR CSR_EMPID = '999999'
AND [Reject_Reason]is NULL;
       
WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

-- Reject Logs that are  for Sup Module and Employee does not have a Sup job code.(DTT)
UPDATE [EC].[Generic_Coaching_Stage]
SET [Reject_Reason]= 
     CASE WHEN [Report_Code] like 'DTT%'
     AND [Emp_Role] <> 'S' THEN N'Employee does not have a Supervisor job code.'
ELSE NULL END
WHERE [Emp_Role] <> 'S' and [Reject_Reason]is NULL;
       
WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

-- Reject Logs that are for CSR Module and Employee does not have a CSR job code.(SEA)
UPDATE [EC].[Generic_Coaching_Stage]
SET [Reject_Reason]= CASE WHEN ([Report_Code] not like 'DTT%' AND [Report_Code] not like 'OTH%' )
AND [Emp_Role] NOT IN ( 'C', 'I') THEN N'Employee does not have a CSR or ISG job code.'
ELSE NULL END
WHERE [Emp_Role] <> 'C' AND [Reject_Reason]is NULL;
      
WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

 -- Reject Logs where Module submitted does not match Employee record (OTH)
 UPDATE [EC].[Generic_Coaching_Stage]
SET [Reject_Reason]= CASE WHEN [Report_Code] like 'OTH%'
AND [Module_ID] <> [EC].[fn_intModuleIDFromEmpID](CSR_EMPID)
THEN N'Module submitted does not match Employee job code.'
ELSE NULL END
WHERE [Reject_Reason]is NULL;
     
WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

-- Write rejected records to Rejected table.
INSERT INTO [EC].[Generic_Coaching_Rejected]
           ([Report_ID]
		   ,[Report_Code]
		   ,[CSR_EMPID]
           ,[Event_Date]
           ,[FileName]
           ,[Rejected_Reason]
           ,[Rejected_Date])
          SELECT s.[Report_ID]
		   ,S.[Report_Code]
		   ,S.[CSR_EMPID]
           ,S.[Event_Date]
           ,S.[FileName]
           ,S.[Reject_Reason]
           ,GETDATE()
FROM [EC].[Generic_Coaching_Stage] S left outer join [EC].[Generic_Coaching_Rejected] R 
  ON S.Report_ID = R.Report_ID and S.Report_Code = R.Report_Code 
  WHERE R.Report_ID is NULL and R.Report_Code is NULL 
  AND S.[Reject_Reason] is not NULL ;  

      
END  -- [EC].[sp_InsertInto_Generic_Rejected]
GO


