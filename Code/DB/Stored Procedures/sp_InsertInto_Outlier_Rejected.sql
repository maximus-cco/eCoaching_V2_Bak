SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		        Susmitha Palacherla
-- Create date:        4/24/2017
-- Description:	 
-- Populates Reject Reason(s) and Inserts Rejected logs to Rejected table.
-- Initial revision. TFS 6377 - 04/24/2017
-- Updated to add rejection logic for invalid LCS Review Mgr ID - TFS 6612 - 05/22/2017
-- Removed status check for BRL and BRN feeds  - TFS 8793 - 11/16/2017
-- Modified during Encryption of sensitive data. Limited attributes being stored for rejected logs. TFS 7856 - 11/23/2017
-- Changes to suppport Incentives Data Discrepancy feed - TFS 18154 - 09/15/2020
-- Modified to support eCoaching Log for Subcontractors - TFS 27527 - 02/01/2024
--  Modified to Support ISG Alignment Project. TFS 28026 - 05/06/2024
-- Modified to support ASR Feed. TFS 28298 - 06/26/2024
-- =============================================
CREATE OR ALTER PROCEDURE [EC].[sp_InsertInto_Outlier_Rejected]
AS
BEGIN


-- Determine and populate Reject Reasons
-- Employee Site Inactive
UPDATE [EC].[Outlier_Coaching_Stage]
SET [Reject_Reason]= 'Employee Site Inactive.'
FROM [EC].[Outlier_Coaching_Stage] os JOIN [EC].[Employee_Hierarchy] eh 
ON os.CSR_EMPID = eh.Emp_ID JOIN [EC].[DIM_SITE] s
ON eh.Emp_Site = s.[City]
WHERE s.isActive = 0
AND [Reject_Reason] is NULL;
 
 WAITFOR DELAY '00:00:00.01' ;-- Wait for 1 ms

-- Employee not found in Hierrachy table
UPDATE [EC].[Outlier_Coaching_Stage]
SET [Reject_Reason]= N'Employee Not found in Hierarchy table.'
WHERE (CSR_EMPID = '' OR
CSR_EMPID NOT IN 
(SELECT DISTINCT EMP_ID FROM [EC].[Employee_Hierarchy]))
AND [Reject_Reason]is NULL;
         
WAITFOR DELAY '00:00:00.01'; -- Wait for 1 ms

-- Employee not Active
UPDATE [EC].[Outlier_Coaching_Stage]
SET [Reject_Reason]= 'Employee not Active.'
WHERE (CSR_EMPID NOT IN 
(SELECT DISTINCT EMP_ID FROM [EC].[Employee_Hierarchy] WHERE Active = 'A'))
AND [Reject_Reason]is NULL;

 WAITFOR DELAY '00:00:00.01' ;-- Wait for 1 ms
     
-- Incorrect Module
UPDATE [EC].[Outlier_Coaching_Stage]
SET [Reject_Reason]= 
CASE 
WHEN [Emp_Role] = 'O' THEN 'Invalid Role for Log generation'
WHEN LEFT(Report_Code,LEN(Report_Code)-8) = 'MSRS'  AND [Emp_Role] <> 'S'
THEN 'Employee not a Supervisor'
WHEN LEFT(Report_Code,LEN(Report_Code)-8) = 'IDD'  AND [Emp_Role] NOT IN ('S', 'M', 'QS', 'LS', 'TS')
THEN 'Employee not a Supervisor or Lead'
WHEN LEFT(Report_Code,LEN(Report_Code)-8) NOT IN ('BRL', 'BRN', 'MSRS', 'IDD', 'ASR')  AND [Emp_Role] NOT IN ( 'C', 'I')
THEN 'Employee not a CSR OR ISG' 
ELSE NULL END
WHERE [Reject_Reason]is NULL;
   
WAITFOR DELAY '00:00:00.01'; -- Wait for 1 ms

-- Review Manager not found in Hierrachy table
UPDATE [EC].[Outlier_Coaching_Stage]
SET [Reject_Reason]= N'Review Manager not active or valid.'
WHERE Report_Code LIKE 'LCS%'
AND (RMgr_ID = '' OR
RMgr_ID NOT IN 
(SELECT DISTINCT EMP_ID FROM [EC].[Employee_Hierarchy]
 WHERE Emp_Job_Code = 'WACS50'
 AND Active = 'A'))
AND [Reject_Reason] is NULL;

--Insert Rejected Records into Rejected Table
INSERT INTO [EC].[Outlier_Coaching_Rejected]
           ([Report_ID]
           ,[Report_Code]
		   ,[CSR_EMPID]
           ,[Source]
           ,[Event_Date]
           ,[Submitted_Date]
           ,[FileName]
           ,[Rejected_Reason]
           ,[Rejected_Date]
       )
 SELECT S.[Report_ID]
      ,S.[Report_Code]
	  ,S.[CSR_EMPID]
      ,S.[Source]
      ,S.[Event_Date]
      ,S.[Submitted_Date]
      ,S.[FileName]
      ,s.[Reject_Reason]
      ,GETDATE()
   FROM [EC].[Outlier_Coaching_Stage]S left outer join [EC].[Outlier_Coaching_Rejected] R 
  ON S.Report_ID = R.Report_ID and S.Report_Code = R.Report_Code 
  WHERE R.Report_ID is NULL and R.Report_Code is NULL 
  AND S.[Reject_Reason] is not NULL ;               

END -- sp_InsertInto_Outlier_Rejected
GO