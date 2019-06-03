/*
sp_Update_Generic_Coaching_Stage(03).sql
Last Modified Date: 05/29/2019
Last Modified By: Susmitha Palacherla

Version 03: Updated to support Maximus IDs - TFS 13777 - 05/29/2019
Version 02:Updated to support Encryption of sensitive data - TFS 7856 - 11/27/2017
Version 01: Document Initial Revision - Added support for DTT generic feed. - TFS 7646 - 9/1/2017
*/



IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update_Generic_Coaching_Stage' 
)
   DROP PROCEDURE [EC].[sp_Update_Generic_Coaching_Stage]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		   Susmitha Palacherla
-- Create date: 08/31/2017
-- Description:	Performs the following actions.
-- Populate Employee and Hierarchy attributes from Employee Table
-- Inserts non CSR and Supervisor records into Rejected table
-- Deletes rejected records.
-- Last Modified By - Susmitha Palacherla
-- Revision History
-- Initial Revision. DTT Feed - TFS 7646 - 08/31/2017
-- Updated to support Encryption of sensitive data - TFS 7856 - 11/27/2017
-- Updated to support Maximus IDs - TFS 13777 - 05/29/2019
-- =============================================
CREATE PROCEDURE [EC].[sp_Update_Generic_Coaching_Stage] 
@Count INT OUTPUT
AS
BEGIN

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 

-- Populate Emp ID if LanID provided in File 
BEGIN
UPDATE [EC].[Generic_Coaching_Stage]
SET [CSR_EMPID]=[EC].[fn_nvcGetEmpIdFromLanId] ([CSR_LANID],Getdate()) 
WHERE [CSR_EMPID] is NULL
AND [CSR_LANID] IS NOT NULL

OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms
  
-- Populate Attributes from Employee Table
BEGIN
UPDATE [EC].[Generic_Coaching_Stage]
SET [CSR_LANID] = [EC].[fn_strEmpLanIDFromEmpID]([CSR_EMPID])
    ,[CSR_Site]= EMP.[Emp_Site]
    ,[Program]= EMP.[Emp_Program]
    ,[Emp_Role]= 
    CASE WHEN EMP.[Emp_Job_Code] like 'WACS0%' THEN 'C'
    WHEN EMP.[Emp_Job_Code] = 'WACS40' THEN 'S'
	WHEN EMP.[Emp_Job_Code] IN ('WACQ02','WACQ03','WACQ12') THEN 'Q'
    WHEN EMP.[Emp_Job_Code] IN ('WIHD01','WIHD02','WIHD03','WIHD04') THEN 'L'
    WHEN EMP.[Emp_Job_Code] IN ('WTID13','WTTI02','WTTR12','WTTR13') THEN 'T'
    ELSE 'O' END
FROM [EC].[Generic_Coaching_Stage] STAGE JOIN [EC].[Employee_Hierarchy]EMP
ON LTRIM(STAGE.CSR_EMPID) = LTRIM(EMP.Emp_ID)

OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

-- Reject records not belonging to CSRs and Supervisors
BEGIN
EXEC [EC].[sp_InsertInto_Generic_Rejected] 
END

WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms


-- Delete rejected records

BEGIN
DELETE FROM [EC].[Generic_Coaching_Stage]
WHERE [Reject_Reason]is not NULL
SELECT @Count = @@ROWCOUNT

OPTION (MAXDOP 1)
END

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];	



END  -- [EC].[sp_Update_Generic_Coaching_Stage]



GO


