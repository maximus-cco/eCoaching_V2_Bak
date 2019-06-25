/*
sp_Update_Training_Coaching_Stage(02).sql
Last Modified Date: 06/24/2019
Last Modified By: Susmitha Palacherla

Version 02:  Modified to translate Legacy Ids to Maximus ids. TFS 14790 - 06/24/2019
Version 01:  Initial Revision - Created during encryption of secure data. TFF 7856 - 11/27/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update_Training_Coaching_Stage' 
)
   DROP PROCEDURE [EC].[sp_Update_Training_Coaching_Stage]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		   Susmitha Palacherla
-- Create date: 11/27/2017
-- Description:	Performs the following actions.
-- Revision History
-- Last Modified By - Susmitha Palacherla
-- Initial Revision - Created during encryption of secure data. TFF 7856 - 11/27/2017
-- Modified to translate Legacy Ids to Maximus ids. TFS 14790 - 06/24/2019
-- =============================================
CREATE PROCEDURE [EC].[sp_Update_Training_Coaching_Stage] 
@Count INT OUTPUT
AS
BEGIN

-- Open the symmetric key with which to encrypt the data.  
OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert];  

 --Lookup Maximus ID 
BEGIN
UPDATE [EC].[Training_Coaching_Stage]
SET [CSR_EMPID] = EH.[Emp_ID]
FROM [EC].[Training_Coaching_Stage] TS JOIN [EC].[Employee_Hierarchy] EH
ON TS.[CSR_EMPID]= EH.Legacy_Emp_ID
WHERE ([Report_Code] like 'SDR%' OR [Report_Code] like 'ODT%')

OPTION (MAXDOP 1)
END  

WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

-- Populate Lan ID

BEGIN
UPDATE [EC].[Training_Coaching_Stage]
SET [CSR_LANID]= [EC].[fn_strEmpLanIDFromEmpID]([CSR_EMPID])
OPTION (MAXDOP 1)
END  
    
    
WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms
    
-- Populate Program from Employee Table
BEGIN
UPDATE [EC].[Training_Coaching_Stage]
SET [Program]= H.[Emp_Program]
FROM [EC].[Training_Coaching_Stage]S JOIN [EC].[Employee_Hierarchy]H
ON S.[CSR_EMPID]=H.[Emp_ID]
WHERE (S.Program IS NULL OR S.Program ='')

OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

-- Determine and populate Reject Reasons
-- No Maximus ID found for the Legacy ID.

BEGIN
UPDATE [EC].[Training_Coaching_Stage]
SET [Reject_Reason]= N'No Maximus ID found for the Legacy ID.'
WHERE CSR_EMPID IN
(SELECT TS.CSR_EMPID
 FROM [EC].[Training_Coaching_Stage] TS
 WHERE NOT EXISTS
	(SELECT NULL
     FROM [EC].[Employee_Hierarchy] EH
     WHERE TS.[CSR_EMPID]= EH.Emp_ID))
	 AND ([Report_Code] like 'SDR%' OR [Report_Code] like 'ODT%')
AND [Reject_Reason]is NULL

	
OPTION (MAXDOP 1)
END


-- Employee not an Actice CSR

BEGIN
UPDATE [EC].[Training_Coaching_Stage]
SET [Reject_Reason]= N'Record does not belong to an active CSR.'
WHERE (CSR_EMPID = '' OR
CSR_EMPID NOT IN 
(SELECT DISTINCT EMP_ID FROM [EC].[Employee_Hierarchy]
 WHERE Emp_Job_Code IN ('WACS01', 'WACS02', 'WACS03')
 AND Active NOT IN ('T','D','P','L') and Emp_LanID <> 'Unknown'
 ))
AND [Reject_Reason]is NULL
	
OPTION (MAXDOP 1)
END  


WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

--Insert Rejected Records into Rejected Table
BEGIN
INSERT INTO [EC].[Training_Coaching_Rejected]
           ([Report_ID]
           ,[Report_Code]
           ,[Source]
           ,[Event_Date]
           ,[Submitted_Date]
		   ,[FileName]
           ,[Rejected_Reason]
           ,[Rejected_Date]
       )
 SELECT S.[Report_ID]
      ,S.[Report_Code]
      ,S.[Source]
      ,S.[Event_Date]
      ,S.[Submitted_Date]
	  ,S.[FileName]
      ,s.[Reject_Reason]
      ,GETDATE()
   FROM [EC].[Training_Coaching_Stage]S left outer join [EC].[Training_Coaching_Rejected] R 
  ON S.Report_ID = R.Report_ID and S.Report_Code = R.Report_Code 
  WHERE R.Report_ID is NULL and R.Report_Code is NULL 
  AND S.[Reject_Reason] is not NULL                

OPTION (MAXDOP 1)
END
    
-- Delete rejected records

BEGIN
DELETE FROM [EC].[Training_Coaching_Stage]
WHERE [Reject_Reason]is not NULL

SELECT @Count =@@ROWCOUNT

OPTION (MAXDOP 1)
END





  -- Clode Symmetric Key
  CLOSE SYMMETRIC KEY [CoachingKey] 



END  -- [EC].[sp_Update_Training_Coaching_Stage]


GO



