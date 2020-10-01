/*
sp_InsertInto_Outlier_Rejected(06).sql
Last Modified Date: 09/15/2020
Last Modified By: Susmitha Palacherla

Version 06: Changes to suppport Incentives Data Discrepancy feed - TFS 18154 - 09/15/2020
Version 05: Modified to support Encryption of sensitive data - Open key - TFS 7856 - 11/23/2017
Version 04: Removed status check for BRL and BRN feeds  - TFS 8793 - 11/16/2017
Version 03: Updated to add rejection logic for invalid LCS Review Mgr ID - Suzy Palacherla -  TFS 6612 - 05/22/2017
Version 02: Missed Program insert into Rejected Table - Suzy Palacherla -  TFS 6377 - 04/25/2017
Version 01: Document Initial Revision - Suzy Palacherla -  TFS 6377 - 04/24/2017
*/



IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Outlier_Rejected' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_Outlier_Rejected]
GO

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
-- =============================================
CREATE PROCEDURE [EC].[sp_InsertInto_Outlier_Rejected]
AS
BEGIN


-- Determine and populate Reject Reasons

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
SET [Reject_Reason]= CASE WHEN Emp_Active = 'N' THEN 'Employee not Active'
ELSE NULL END
WHERE [Reject_Reason]is NULL;
 
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
WHEN LEFT(Report_Code,LEN(Report_Code)-8) NOT IN ('BRL', 'BRN', 'MSRS', 'IDD')  AND [Emp_Role] <> 'C'
THEN 'Employee not a CSR' 
ELSE NULL END
WHERE [Reject_Reason]is NULL;
   
WAITFOR DELAY '00:00:00.01'; -- Wait for 1 ms

-- Employee not found in Hierrachy table
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
   FROM [EC].[Outlier_Coaching_Stage]S left outer join [EC].[Outlier_Coaching_Rejected] R 
  ON S.Report_ID = R.Report_ID and S.Report_Code = R.Report_Code 
  WHERE R.Report_ID is NULL and R.Report_Code is NULL 
  AND S.[Reject_Reason] is not NULL ;               

END -- sp_InsertInto_Outlier_Rejected
GO


