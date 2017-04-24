/*
sp_Update_Outlier_Coaching_Stage(01).sql
Last Modified Date: 04/24/2017
Last Modified By: Susmitha Palacherla



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
-- =============================================
CREATE PROCEDURE [EC].[sp_Update_Outlier_Coaching_Stage] 
@Count INT OUTPUT
AS
BEGIN


-- Populate LanID for Employee ID coming in file (LCS, IAE and IAT)
BEGIN
UPDATE [EC].[Outlier_Coaching_Stage]
SET [CSR_LANID]= [EC].[fn_strEmpLanIDFromEmpID]([CSR_EMPID])
WHERE [CSR_LANID]IS NULL AND NOT ISNULL([CSR_EMPID],' ') like '%.%'
OPTION (MAXDOP 1)
END  

WAITFOR DELAY '00:00:00.01' -- Wait for 3 ms

--  Populate EmpID and or LanID for files that can
--  have either EmpID or LanID arrive in strCSR
-- (All Other OMR Files)

-- EmpID sent in strCSR. Copy to EmpID
BEGIN
UPDATE [EC].[Outlier_Coaching_Stage]
SET [CSR_EMPID]=[CSR_LANID]
WHERE NOT ISNULL([CSR_LANID],' ') like '%.%'
OPTION (MAXDOP 1)
END 
 
WAITFOR DELAY '00:00:00.01' -- Wait for 3 ms  
 
-- Replace above copied EmpIds with LANIds
BEGIN
UPDATE [EC].[Outlier_Coaching_Stage]
SET [CSR_LANID]= [EC].[fn_strEmpLanIDFromEmpID]([CSR_LANID])
WHERE NOT ISNULL([CSR_LANID],' ') like '%.%'
OPTION (MAXDOP 1)
END  
      
WAITFOR DELAY '00:00:00.01' -- Wait for 3 ms

 -- Populate EmpID for lanID coming in strCSR (non LCS, IAE, IAT, BRL, BRN)
BEGIN
UPDATE [EC].[Outlier_Coaching_Stage]
SET [CSR_EMPID]= [EC].[fn_nvcGetEmpIdFromLanId] ([CSR_LANID],[Submitted_Date])
WHERE  ISNULL([CSR_LANID],' ') like '%.%'
OPTION (MAXDOP 1)
END 
 
WAITFOR DELAY '00:00:00.01' -- Wait for 3 ms  
 
-- Replace unknown Employee Ids with ''
BEGIN
UPDATE [EC].[Outlier_Coaching_Stage]
SET [CSR_EMPID]= ''
WHERE  [CSR_EMPID]='999999'
OPTION (MAXDOP 1)
END  
      
WAITFOR DELAY '00:00:00.01' -- Wait for 3 ms

-- Populate Missing program
BEGIN
UPDATE [EC].[Outlier_Coaching_Stage]
SET [Program]= H.[Emp_Program]
FROM [EC].[Outlier_Coaching_Stage]S JOIN [EC].[Employee_Hierarchy]H
ON S.[CSR_EMPID]=H.[Emp_ID]
WHERE (S.Program IS NULL OR S.Program ='')
OPTION (MAXDOP 1)
END  
      
WAITFOR DELAY '00:00:00.01' -- Wait for 3 ms


-- Populate Missing Site
BEGIN
UPDATE [EC].[Outlier_Coaching_Stage]
SET [Program]= H.[Emp_Site]
FROM [EC].[Outlier_Coaching_Stage]S JOIN [EC].[Employee_Hierarchy]H
ON S.[CSR_EMPID]=H.[Emp_ID]
WHERE (S.CSR_Site IS NULL OR S.CSR_Site ='')
OPTION (MAXDOP 1)
END  
      
WAITFOR DELAY '00:00:00.01' -- Wait for 3 ms

-- Populate Roles AND Active
BEGIN
UPDATE [EC].[Outlier_Coaching_Stage]
SET [Emp_Role]= 
    CASE WHEN EMP.[Emp_Job_Code]in ('WACS01', 'WACS02','WACS03') THEN 'C'
    WHEN EMP.[Emp_Job_Code] = 'WACS40' THEN 'S'
    WHEN  EMP.[Emp_Job_Code]in ('WACQ02', 'WACQ03','WACQ12 ') THEN 'Q'
    ELSE 'O' END
   ,[Emp_Active] =
    CASE WHEN  EMP.[Active] in ('T', 'D', 'P', 'L')THEN 'N'
    ELSE 'A' END
FROM [EC].[Outlier_Coaching_Stage] STAGE JOIN [EC].[Employee_Hierarchy]EMP
ON LTRIM(STAGE.CSR_EMPID) = LTRIM(EMP.Emp_ID)

OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.01' -- Wait for 3 ms

-- Reject records not belonging to CSRs and Supervisors
BEGIN
EXEC [EC].[sp_InsertInto_Outlier_Rejected] 
END

WAITFOR DELAY '00:00:00.01' -- Wait for 3 ms


-- Delete rejected records

BEGIN
DELETE FROM [EC].[Outlier_Coaching_Stage]
WHERE [Reject_Reason]is not NULL

SELECT @Count =@@ROWCOUNT
OPTION (MAXDOP 1)
END


WAITFOR DELAY '00:00:00.01' -- Wait for 3 ms


END  -- [EC].[sp_Update_Outlier_Coaching_Stage]


GO





