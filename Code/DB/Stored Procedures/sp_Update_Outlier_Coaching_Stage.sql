/*
sp_Update_Outlier_Coaching_Stage(07).sql
Last Modified Date: 09/15/2020
Last Modified By: Susmitha Palacherla

Version 07: Changes to suppport Incentives Data Discrepancy feed - TFS 18154 - 09/15/2020
Version 06: Updated to support Maximus IDs - TFS 13777 - 05/29/2019
Version 05: Updated to support Encryption of sensitive data - TFS 7856 - 11/27/2017
Version 04: Added Additional Job codes and Roles - TFS 8793 - 11/16/2017
Version 03: Updated to fix typo in Missing Site and Comments - TFS 6147 - 06/02/2017
Version 02: slight update to EmpID update logic - Suzy Palacherla -  TFS 6377 - 04/24/2017
Version 01: Document Initial Revision - Suzy Palacherla -  TFS 6377 - 04/24/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update_Outlier_Coaching_Stage' 
)
   DROP PROCEDURE [EC].[sp_Update_Outlier_Coaching_Stage]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		   Susmitha Palacherla
-- Create date: 04/24/2017
-- Description:	Performs the following actions.
-- Populates EmpID and or lanID depending on incoming files as needed
-- Populate missing program and site values from employee table
-- Populates Role and Active status 
-- Rejects records and deletes rejected records per business rules.
-- Initial revision. TFS 6377 - 04/24/2017
-- Updated to fix typo in Missing Site and Comments - TFS 6147 - 06/02/2017
-- Added Additional Job codes and Roles - TFS 8793 - 11/16/2017
-- Updated to support Encryption of sensitive data - TFS 7856 - 11/27/2017
-- Updated to support Maximus IDs - TFS 13777 - 05/29/2019
-- Changes to suppport Incentives Data Discrepancy feed - TFS 18154 - 09/15/2020
-- =============================================
CREATE PROCEDURE [EC].[sp_Update_Outlier_Coaching_Stage] 
@Count INT OUTPUT
AS
BEGIN

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 

-- Populate LanID for Employee ID coming in file (LCS, IAE and IAT)
UPDATE [EC].[Outlier_Coaching_Stage]
SET [CSR_LANID]= [EC].[fn_strEmpLanIDFromEmpID]([CSR_EMPID])
WHERE [CSR_LANID]IS NULL AND NOT ISNULL([CSR_EMPID],' ') like '%.%';

WAITFOR DELAY '00:00:00.01'; -- Wait for 1 ms

--  Populate EmpID and or LanID for files that can
--  have either EmpID or LanID arrive in strCSR
-- (All Other OMR Files)
-- For Files where EmpID sent in strCSR. Copy it to EmpID
UPDATE [EC].[Outlier_Coaching_Stage]
SET [CSR_EMPID] = [CSR_LANID]
WHERE NOT ISNULL([CSR_LANID],' ') like '%.%' AND [CSR_EMPID] IS NULL;
 
WAITFOR DELAY '00:00:00.01'; -- Wait for 1 ms  
  
-- Replace above copied EmpIds with LANIds
UPDATE [EC].[Outlier_Coaching_Stage]
SET [CSR_LANID]= [EC].[fn_strEmpLanIDFromEmpID]([CSR_LANID])
WHERE NOT ISNULL([CSR_LANID],' ') like '%.%';
     
WAITFOR DELAY '00:00:00.01'; -- Wait for 1 ms

 -- Populate EmpID for lanID coming in strCSR (non LCS, IAE, IAT, BRL, BRN)
 UPDATE [EC].[Outlier_Coaching_Stage]
SET [CSR_EMPID]= [EC].[fn_nvcGetEmpIdFromLanId] ([CSR_LANID],[Submitted_Date])
WHERE  ISNULL([CSR_LANID],' ') like '%.%' AND [CSR_EMPID] IS NULL;
 
WAITFOR DELAY '00:00:00.01'; -- Wait for 1 ms  
 
-- Replace unknown Employee Ids with ''
UPDATE [EC].[Outlier_Coaching_Stage]
SET [CSR_EMPID]= ''
WHERE [CSR_EMPID]='999999';
      
WAITFOR DELAY '00:00:00.01'; -- Wait for 1 ms

-- Populate Missing program
UPDATE [EC].[Outlier_Coaching_Stage]
SET [Program]= H.[Emp_Program]
FROM [EC].[Outlier_Coaching_Stage]S JOIN [EC].[Employee_Hierarchy]H
ON S.[CSR_EMPID]=H.[Emp_ID]
WHERE (S.Program IS NULL OR S.Program ='');
       
WAITFOR DELAY '00:00:00.01'; -- Wait for 1 ms

-- Populate Missing Site
UPDATE [EC].[Outlier_Coaching_Stage]
SET [CSR_Site]= H.[Emp_Site]
FROM [EC].[Outlier_Coaching_Stage]S JOIN [EC].[Employee_Hierarchy]H
ON S.[CSR_EMPID]=H.[Emp_ID]
WHERE (S.CSR_Site IS NULL OR S.CSR_Site ='');
      
WAITFOR DELAY '00:00:00.01'; -- Wait for 1 ms

-- Populate Roles AND Active
UPDATE [EC].[Outlier_Coaching_Stage]
SET [Emp_Role]= 
    CASE WHEN EMP.[Emp_Job_Code] like 'WACS0%' THEN 'C'
    WHEN EMP.[Emp_Job_Code] = 'WACS40' THEN 'S'
    WHEN  EMP.[Emp_Job_Code]in ('WACQ02', 'WACQ03','WACQ12') THEN 'Q'
	WHEN  EMP.[Emp_Job_Code]in ('WACQ13') THEN 'QS' -- Quality Supervisor
    WHEN  EMP.[Emp_Job_Code]in ('WIHD01','WIHD02','WIHD03','WIHD04','WABA11','WISA03') THEN 'L'
	WHEN  EMP.[Emp_Job_Code]in ('WIHD40','WPPT40') THEN 'LS'-- LSA Supervisor
	WHEN  EMP.[Emp_Job_Code]in ('WTTR02','WTTI02','WTTR12','WTTR13','WTID13') THEN 'T'
	WHEN  EMP.[Emp_Job_Code]in ('WTTR40','WTTR50') THEN 'TS'-- Training Supervisor
	WHEN  EMP.[Emp_Job_Code]in ('WABA01','WABA02','WABA03') THEN 'AD'
	WHEN  EMP.[Emp_Job_Code]in ('WPSM11') THEN 'AR'
	WHEN  EMP.[Emp_Job_Code]in ('WMPL02','WMPL03') THEN 'PP'
    WHEN  EMP.[Emp_Job_Code]in ('WPPM11') THEN 'PA'
    ELSE 'O' END
   ,[Emp_Active] =
    CASE WHEN  EMP.[Active] in ('T', 'D', 'P', 'L')THEN 'N'
    ELSE 'A' END
FROM [EC].[Outlier_Coaching_Stage] STAGE JOIN [EC].[Employee_Hierarchy]EMP
ON LTRIM(STAGE.CSR_EMPID) = LTRIM(EMP.Emp_ID);

WAITFOR DELAY '00:00:00.01'; -- Wait for 1 ms

-- Reject records not belonging to CSRs and Supervisors
EXEC [EC].[sp_InsertInto_Outlier_Rejected]; 
WAITFOR DELAY '00:00:00.01'; -- Wait for 1 ms

-- Delete rejected records
DELETE FROM [EC].[Outlier_Coaching_Stage]
WHERE [Reject_Reason]is not NULL;
SELECT @Count = @@ROWCOUNT;

WAITFOR DELAY '00:00:00.01'; -- Wait for 1 ms

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];	


END  -- [EC].[sp_Update_Outlier_Coaching_Stage]
GO


