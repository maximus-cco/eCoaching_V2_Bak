/*
sp_Update_EmployeeID_To_LanID(02).sql
Last Modified Date:  11/27/2017
Last Modified By: Susmitha Palacherla


Version 02: Updated to support Encryption of sensitive data - TFS 7856 - 11/27/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update_EmployeeID_To_LanID' 
)
   DROP PROCEDURE [EC].[sp_Update_EmployeeID_To_LanID]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		   Susmitha Palacherla
-- Create Date: 02/03/2014
-- Description:	Performs the following actions.
-- Adds an End Date to an Employee ID to lan ID combination that is different from the existing record.
-- Inserts new records for the changed and new combinations.
-- Last Modified By: Susmitha Palacherla
-- Last Modified Date: 07/25/2014
-- Modified to fix logic per SCR 12983.
-- Updated to support Encryption of sensitive data - TFS 7856 - 11/27/2017
-- =============================================
CREATE PROCEDURE [EC].[sp_Update_EmployeeID_To_LanID] 
AS
BEGIN

DECLARE @dtNow DATETIME
SET @dtNow = GETDATE()

 -- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];  
  
  -- Assigns End_Date to an Employee ID to Lan ID link for Termed Users
  

BEGIN
  ;WITH OpenRecords AS
  (SELECT * FROM [EC].[EmployeeID_To_LanID]LAN
   WHERE EndDate = 99991231)
  
	  UPDATE LAN
	  SET [EndDate] = [End_Date],
	  [DatetimeLastUpdated]= @dtNow
	  FROM [EC].[Employee_Hierarchy]EH 
	  JOIN OpenRecords LAN
	  ON EH.[Emp_ID]= LAN.[EmpID]
	  WHERE LAN.[EndDate] = '99991231'
	  AND EH.[Active]in ('T', 'D')
OPTION (MAXDOP 1)
END


PRINT N'STEP1'
WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

-- Inserts links for new Employee IDs 

BEGIN
         INSERT INTO [EC].[EmployeeID_To_LanID]
			   ([EmpID]
			   ,[StartDate]
			   ,[EndDate]
			   ,[LanID]
			   ,[DatetimeInserted]
			   ,[DatetimeLastUpdated])
			   
		(SELECT
			   Emp_ID,
			   Start_Date,
			   End_Date,
			   Emp_LanID,
			   @dtNow ,
			   @dtNow 
			   FROM [EC].[Employee_Hierarchy]EH WHERE EH.[ACTIVE] NOT IN ('T','D')
			   AND NOT EXISTS
			   (SELECT EMPID FROM [EC].[EmployeeID_To_LanID]LAN
			   WHERE EH.[Emp_ID]= LAN.[EmpID]))
			
OPTION (MAXDOP 1)
END


PRINT N'STEP2'
WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms  

  
-- Inserts links for new Employee IDs to Lan ID Pair

BEGIN
        INSERT INTO [EC].[EmployeeID_To_LanID]
			   ([EmpID]
			   ,[StartDate]
			   ,[EndDate]
			   ,[LanID]
			   ,[DatetimeInserted]
			   ,[DatetimeLastUpdated])
			   
		(SELECT
			   Emp_ID,
			   CONVERT(nvarchar(10),@dtNow,112),
			   End_Date,
			   Emp_LanID,
			   @dtNow ,
			   @dtNow 
			   FROM [EC].[Employee_Hierarchy]EH LEFT OUTER JOIN [EC].[EmployeeID_To_LanID]LAN
			   ON  CONVERT(nvarchar(30),DecryptByKey(EH.[Emp_LanID]))= CONVERT(nvarchar(30),DecryptByKey(LAN.[LanID]))
			   AND EH.[Emp_ID]= LAN.[EmpID]
			   WHERE LAN.[LanID]IS NULL
			   AND EH.[Emp_LanID] IS NOT NULL
			   AND EH.[ACTIVE] NOT IN ('T','D'))
OPTION (MAXDOP 1)
END

PRINT N'STEP3'
WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

    

-- Inserts a new link for a rehired Employee using the same lanid

BEGIN
 ;WITH OpenRecords AS
    (SELECT * FROM [EC].[EmployeeID_To_LanID]LAN
     WHERE EndDate = 99991231)
   
   
   INSERT INTO [EC].[EmployeeID_To_LanID]
			   ([EmpID]
			   ,[StartDate]
			   ,[EndDate]
			   ,[LanID]
			   ,[DatetimeInserted]
			   ,[DatetimeLastUpdated])
   
  (SELECT
			   Emp_ID,
			   Start_Date,
			   End_Date,
			   Emp_LanID,
			   @dtNow ,
			   @dtNow 
			   FROM [EC].[Employee_Hierarchy]EH WHERE EH.[ACTIVE] NOT IN ('T','D', 'L', 'P')
			   AND EMP_ID NOT IN
			   (SELECT EMP_ID FROM OpenRecords LAN
			   WHERE EH.[Emp_ID]= LAN.[EmpID]))


OPTION (MAXDOP 1)
END

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];	 

PRINT N'STEP4'
END --sp_Update_EmployeeID_To_LanID



GO


