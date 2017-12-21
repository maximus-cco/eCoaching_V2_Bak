/*
sp_Update_Quality_Other_Coaching_Stage(01).sql
Last Modified Date: 11/27/2017
Last Modified By: Susmitha Palacherla


Version 01:  Initial Revision - Created during encryption of secure data. TFF 7856 - 11/27/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update_Quality_Other_Coaching_Stage' 
)
   DROP PROCEDURE [EC].[sp_Update_Quality_Other_Coaching_Stage]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		   Susmitha Palacherla
-- Create date: 12/14/2017
-- Description:	Performs the following actions.
-- Populates EmpID and or lanID depending on incoming files as needed
-- Populate missing program values from employee table
-- Populates Role and Active status 
-- Rejects records and deletes rejected records per business rules.
-- Initial revision. Created during encryption of sensitive data - TFS 7856 - 04/24/2017
-- =============================================
CREATE PROCEDURE [EC].[sp_Update_Quality_Other_Coaching_Stage] 
@Count INT OUTPUT
AS
BEGIN

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 

-- For Files where EmpID sent in strCSR. Copy directly to EmpID (KUD)
BEGIN
UPDATE [EC].[Quality_Other_Coaching_Stage]
SET [Emp_ID]=[Emp_LanID]
WHERE NOT ISNULL([Emp_LANID],' ') like '%.%'
AND [Emp_ID] IS NULL
OPTION (MAXDOP 1)
END  

WAITFOR DELAY '00:00:00.01' -- Wait for 1 ms

-- For Files where Emp LanID sent in strCSR.
-- Lookup Employee ID and Populate into (HFC)

BEGIN
UPDATE [EC].[Quality_Other_Coaching_Stage]
SET [EMP_ID]= [EC].[fn_nvcGetEmpIdFromLanId] ([EMP_LANID],[Submitted_Date])
WHERE  ISNULL([Emp_LANID],' ') like '%.%'
AND [Emp_ID] IS NULL
OPTION (MAXDOP 1)
END 
 
WAITFOR DELAY '00:00:00.01' -- Wait for 1 ms  

-- Replace unknown Employee Ids with ''

BEGIN
UPDATE [EC].[Quality_Other_Coaching_Stage]
SET [EMP_ID]= ''
WHERE  [EMP_ID]='999999'
OPTION (MAXDOP 1)
END 
 
WAITFOR DELAY '00:00:00.01' -- Wait for 1 ms  

-- Populate SubmitterID as 999999 where NULL
BEGIN

UPDATE [EC].[Quality_Other_Coaching_Stage]
SET [Submitter_ID]= '999999'
WHERE [Submitter_ID] IS NULL
OPTION (MAXDOP 1)
END  
      
WAITFOR DELAY '00:00:00.01' -- Wait for 1 ms

 -- Populate Program Value from Employee table where missing
BEGIN
UPDATE [EC].[Quality_Other_Coaching_Stage]
SET [Program]= H.[Emp_Program]
FROM [EC].[Quality_Other_Coaching_Stage]S JOIN [EC].[Employee_Hierarchy]H
ON S.[EMP_ID]=H.[Emp_ID]
WHERE ([Program] IS NULL OR [Program]= '')
OPTION (MAXDOP 1)
END 
 
WAITFOR DELAY '00:00:00.01' -- Wait for 1 ms  


-- Determine and populate Reject Reasons

-- Employee not an Actice CSR (HFC and KUD)

BEGIN
UPDATE [EC].[Quality_Other_Coaching_Stage]
SET [Reject_Reason]= N'Record does not belong to an active CSR.'
WHERE (EMP_ID = '' OR
EMP_ID NOT IN 
(SELECT DISTINCT EMP_ID FROM [EC].[Employee_Hierarchy]
 WHERE Emp_Job_Code IN ('WACS01', 'WACS02', 'WACS03')
 AND Active NOT IN ('T','D','P','L') 
 ))
 AND (Report_Code lIKE 'HFC%' OR Report_Code LIKE 'KUD%')
AND [Reject_Reason]is NULL
	
OPTION (MAXDOP 1)
END  


WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms


-- Employee not an Actice Supervisor (CTC)

BEGIN
UPDATE [EC].[Quality_Other_Coaching_Stage]
SET [Reject_Reason]= N'Record does not belong to an active Supervisor.'
WHERE (EMP_ID = '' OR
EMP_ID NOT IN 
(SELECT DISTINCT EMP_ID FROM [EC].[Employee_Hierarchy]
 WHERE Emp_Job_Code = 'WACS40'
 AND Active NOT IN ('T','D','P','L') 
 ))
AND Report_Code lIKE 'CTC%' 
AND [Reject_Reason]is NULL
	
OPTION (MAXDOP 1)
END  


WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

--Insert Rejected Records into Rejected Table
BEGIN
INSERT INTO [EC].[Quality_Other_Coaching_Rejected]
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
   FROM [EC].[Quality_Other_Coaching_Stage]S left outer join [EC].[Quality_Other_Coaching_Rejected] R 
  ON S.Report_ID = R.Report_ID and S.Report_Code = R.Report_Code 
  WHERE R.Report_ID is NULL and R.Report_Code is NULL 
  AND S.[Reject_Reason] is not NULL                

OPTION (MAXDOP 1)
END
    
-- Delete rejected records

BEGIN
DELETE FROM [EC].[Quality_Other_Coaching_Stage]
WHERE [Reject_Reason]is not NULL

SELECT @Count =@@ROWCOUNT

OPTION (MAXDOP 1)
END



-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];	


END  -- [EC].[sp_Update_Quality_Other_Coaching_Stage]

GO


