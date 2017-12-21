/*
sp_InsertInto_IQS_Rejected(02).sql
Last Modified Date: 11/27/2017
Last Modified By: Susmitha Palacherla

Version 02: Modified to support Encryption of sensitive data - Open key - TFS 7856 - 11/27/2017

Version 01: Document Initial Revision - Incorporate ATA forms in IQS feed. - TFS 7541 - 9/18/2017
*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_IQS_Rejected' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_IQS_Rejected]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		   Susmitha Palacherla
-- Create date: 9/18/2017
-- Description:	Determines rejection reason and rejects  logs.
-- Revision History:
-- Initial Revision. Incorporate ATA scorecards - TFS 7541 - 09/18/2017
-- Updated to support Encryption of sensitive data - TFS 7856 - 11/27/2017
-- =============================================
CREATE PROCEDURE [EC].[sp_InsertInto_IQS_Rejected] 
@Count INT OUTPUT

AS
BEGIN

-- Open Symmetric Key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]  

-- Populate Emp Lan ID, Role and Module
BEGIN
UPDATE [EC].[Quality_Coaching_Stage]
SET [User_LANID] = CONVERT(nvarchar(30),DecryptByKey(EMP.[Emp_LanID]))
    ,[Emp_Role]= 
    CASE WHEN EMP.[Emp_Job_Code]in ('WACS01', 'WACS02','WACS03') THEN 'C'
    WHEN EMP.[Emp_Job_Code] = 'WACS40' THEN 'S'
	WHEN EMP.[Emp_Job_Code] IN ('WACQ02','WACQ03','WACQ12') THEN 'Q'
    WHEN EMP.[Emp_Job_Code] IN ('WIHD01','WIHD02','WIHD03','WIHD04') THEN 'L'
    WHEN EMP.[Emp_Job_Code] IN ('WTID13','WTTI02','WTTR12','WTTR13') THEN 'T'
    ELSE 'O' END
	, [Module] = CASE WHEN [VerintFormName] like '%ATA%' THEN 3 ELSE 1 END
FROM [EC].[Quality_Coaching_Stage] STAGE JOIN [EC].[Employee_Hierarchy]EMP
ON LTRIM(STAGE.User_EMPID) = LTRIM(EMP.Emp_ID)

OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms


-- Reject Logs where Active Employee record does not exist

BEGIN
UPDATE [EC].[Quality_Coaching_Stage]
SET [Reject_Reason]= N'Record does not belong to Active Employee.'
WHERE (User_EMPID NOT IN 
(SELECT DISTINCT EMP_ID FROM [EC].[Employee_Hierarchy]
 WHERE Active = 'A'))
 OR User_EMPID = '999999'
AND [Reject_Reason]is NULL
	
OPTION (MAXDOP 1)
END  
       
WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

-- Reject Logs that are  for Quality Module and Employee does not have a Qualityjob code-(ATA)
BEGIN
UPDATE [EC].[Quality_Coaching_Stage]
SET [Reject_Reason]= CASE WHEN [Module] = 3
AND [Emp_Role] <> 'Q' THEN N'Employee does not have a Quality job code.'
ELSE NULL END
WHERE [Emp_Role] <> 'Q' and [Reject_Reason]is NULL
OPTION (MAXDOP 1)
END  
       
WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

-- Reject Logs that are for CSR Module and Employee does not have a CSR job code.(Non ATA)
BEGIN
UPDATE [EC].[Quality_Coaching_Stage]
SET [Reject_Reason]= CASE WHEN [Module] = 1
AND [Emp_Role] <> 'C' THEN N'Employee does not have a CSR job code.'
ELSE NULL END
WHERE [Emp_Role] <> 'C' AND [Reject_Reason]is NULL
OPTION (MAXDOP 1)
END  
      
WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms



-- Write rejected records to Rejected table.

BEGIN
INSERT INTO [EC].[Quality_Coaching_Rejected]
           ([Eval_ID]
		   ,[Eval_Date]
		   ,[Eval_Site_ID]
		   ,[User_EmpID]
		   ,[Journal_ID]
		   ,[Call_Date]
		   ,[VerintFormName]
		   ,[Reject_reason]
		   ,[Date_Rejected])
            SELECT s.[Eval_ID]
		   ,s.[Eval_Date]
		   ,s.[Eval_Site_ID]
		   ,s.[User_EmpID]
		   ,s.[Journal_ID]
		   ,s.[Call_Date]
		   ,s.[VerintFormName]
		   ,s.[Reject_reason]
		   ,GETDATE()
           FROM [EC].[Quality_Coaching_Stage] s
           WHERE s.[Reject_Reason] is not NULL
      

OPTION (MAXDOP 1)
END

  -- Clode Symmetric Key
  CLOSE SYMMETRIC KEY [CoachingKey] 
-- Delete rejected records

BEGIN
DELETE FROM [EC].[Quality_Coaching_Stage]
WHERE [Reject_reason]is not NULL
SELECT @Count = @@ROWCOUNT

OPTION (MAXDOP 1)
END

END  -- [EC].[sp_InsertInto_Quality_Rejected]

GO


