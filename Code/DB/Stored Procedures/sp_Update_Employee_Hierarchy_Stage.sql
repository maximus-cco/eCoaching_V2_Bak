/*
sp_Update_Employee_Hierarchy_Stage(05).sql
Last Modified Date: 04/29/2019
Last Modified By: Susmitha Palacherla

Version 05: Modified to relax Deletes for missing Hierarchy - TFS 14249 - 04/29/2019
Version 04: Updated to support Encryption of sensitive data - TFS 7856 - 11/27/2017
Version 03: Updated to revise logic for supporting reused numeric part of Employee ID per TFS 8228 - 9/22/2017
Version 02: Updated to support reused numeric part of Employee ID per TFS 6011 - 03/21/2017
Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update_Employee_Hierarchy_Stage' 
)
   DROP PROCEDURE [EC].[sp_Update_Employee_Hierarchy_Stage]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		   Susmitha Palacherla
-- Create date: 12/2/2013
-- Description:	Performs the following actions.
-- Deletes records with missing Employee IDs
-- Removes Alpha characters from first 2 positions of Sup_EMP_ID, Mgr_Emp_ID
-- and all leading and trainilin spaces from the IDs
-- Removes # from LanID and Email address of inactive employees
-- Inserts Employee Ids Reusing the numeric part of an existing Employee ID into a tracking table
-- Removes Alpha characters from first 2 positions of all Emp_IDs 
-- that do not need the prefix retained for uniqueness.
-- Removes leading and Trailing spaces from emp and Sup Ids from eWFM staging table.
-- Updates CSR Sup ID values with the SUP from WFM
-- Deletes records with Missing SUP IDs
-- Populates Supervisor attributes
-- Populates Manager attributes
--Revision History:
-- Updated per TFS 641 to trim leading and trailing spaces in Employee and Supervisor Ids 
-- from eWFM and PeopleSoft before using in Employee Hierarchy table - 09/03/2015
-- Updated to support reused numeric part of Employee ID per TFS 6011 - 03/21/2017
-- Updated to revise logic for supporting reused numeric part of Employee ID per TFS 8228 - 9/22/2017
-- Updated to support Encryption of sensitive data - TFS 7856 - 11/27/2017
-- Modified to relax Deletes for missing Hierarchy - TFS 14249 - 04/29/2019
-- =============================================
CREATE PROCEDURE [EC].[sp_Update_Employee_Hierarchy_Stage] 
AS
BEGIN

DECLARE @RetryCounter INT
SET @RetryCounter = 1

RETRY: -- Label RETRY

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 



-- Encrypt name and LanID in Emp ID TO Sup ID Aspect data Staging table


BEGIN
UPDATE [EC].[EmpID_To_SupID_Stage]
SET [Emp_Name] = EncryptByKey(Key_GUID('CoachingKey'), [Emp_Name_Drop])
,[Emp_LanID]= EncryptByKey(Key_GUID('CoachingKey'), [Emp_LanID_Drop])
WHERE [Emp_Name] IS NULL AND [Emp_LanID]IS NULL
 
OPTION (MAXDOP 1)
END  
WAITFOR DELAY '00:00:00.02' -- Wait for 2 ms



-- Set Unecctypted name and Lan ID to NULL in Emp ID TO Sup ID Aspect data Staging table

BEGIN

UPDATE [EC].[EmpID_To_SupID_Stage]
SET [Emp_Name_Drop] = NULL
,[Emp_LanID_Drop]= NULL
 
OPTION (MAXDOP 1)
END  
WAITFOR DELAY '00:00:00.02' -- Wait for 2 ms


-- Delete records where Employee ID is a missing or a blank.
BEGIN
DELETE FROM [EC].[Employee_Hierarchy_Stage]
WHERE EMP_ID = ' ' or  EMP_ID is NULL
OPTION (MAXDOP 1)
END
WAITFOR DELAY '00:00:00.02' -- Wait for 2 ms

-- Populate Emp_Name with Primary Name where No preferred Name populated.

BEGIN
UPDATE [EC].[Employee_Hierarchy_Stage]
SET [Emp_Name] = [Emp_Pri_Name]
WHERE LTRIM(RTRIM(Emp_Name)) = ','
 
OPTION (MAXDOP 1)
END  
WAITFOR DELAY '00:00:00.02' -- Wait for 2 ms


-- Removes Alpha characters from first 2 positions of Sup_EMP_ID, Mgr_Emp_ID
-- and removes all leading and trailing spaces.
-- Removes # from LanID and Email address of inactive employees
BEGIN
UPDATE [EC].[Employee_Hierarchy_Stage]
SET [Sup_EMP_ID]= [EC].[RemoveAlphaCharacters](REPLACE(LTRIM(RTRIM([Sup_EMP_ID])),' ','')),
    [Mgr_Emp_ID]= [EC].[RemoveAlphaCharacters](REPLACE(LTRIM(RTRIM([Mgr_Emp_ID])),' ','')),
    [Emp_LanID]= REPLACE([Emp_LanID], '#',''),
    [Emp_Email]= REPLACE([Emp_Email], '#','')
 
OPTION (MAXDOP 1)
END  
 WAITFOR DELAY '00:00:00.02' -- Wait for 2 ms

-- Updates Hierarchy table to populate Hire_date with Start_Date and Employee ID with prefix if
-- record available in Staging table
BEGIN
UPDATE eh
SET  [Emp_ID_Prefix] = hs.[Emp_ID]
,[Hire_Date]= CONVERT(nvarchar(8),hs.[Hire_Date],112)
From [EC].[Employee_hierarchy] eh Join [EC].[Employee_Hierarchy_Stage]hs
ON REPLACE(LTRIM(RTRIM(eh.[Emp_ID])),' ','') = [EC].[RemoveAlphaCharacters](REPLACE(LTRIM(RTRIM(HS.[Emp_ID])),' ',''))
AND ([EC].[fn_strEmpFirstNameFromEmpName] (hs.Emp_Pri_Name) = [EC].[fn_strEmpFirstNameFromEmpName] (CONVERT(nvarchar(50),DecryptByKey(eh.Emp_Pri_Name)))
 OR [EC].[fn_strEmpLastNameFromEmpName] (hs.Emp_Pri_Name) =[EC].[fn_strEmpLastNameFromEmpName] (CONVERT(nvarchar(50),DecryptByKey(eh.emp_Pri_Name))))
 Where eh.Emp_ID_Prefix like 'WX%'
 
OPTION (MAXDOP 1)
END  
 WAITFOR DELAY '00:00:00.02' -- Wait for 2 ms


 -- Inserts Employee Ids sharing the numeric part of an existing Employee IDs
 -- into a tracking table

BEGIN
INSERT INTO [EC].[Employee_Ids_With_Prefixes]
	([Emp_ID],[Emp_Name],[Emp_LanID],[Start_Date],[Inserted_Date])

     SELECT S.[Emp_ID],
	   S.[Emp_Name],
	   S.[Emp_LanID],
	   S.[Start_Date],
	   GETDATE()[Inserted_Date]
 FROM 
 (SELECT HS.[Emp_ID],
		EncryptByKey(Key_GUID('CoachingKey'), HS.[Emp_Name])[Emp_Name],
		EncryptByKey(Key_GUID('CoachingKey'), HS.[Emp_LanID])[Emp_LanID],
		HS.[Start_Date]
  FROM [EC].[Employee_Hierarchy_Stage]HS LEFT OUTER JOIN[EC].[Employee_Hierarchy]H
  ON [EC].[RemoveAlphaCharacters](REPLACE(LTRIM(RTRIM(HS.[Emp_ID])),' ',''))= H.[Emp_ID]
	  WHERE CONVERT(nvarchar(8),HS.[Hire_Date],112) <> H.Hire_Date
	  AND REPLACE(LTRIM(RTRIM(HS.[Emp_ID_Prefix])),' ','') <> REPLACE(LTRIM(RTRIM(H.[Emp_ID_Prefix])),' ','')
	  AND HS.[Emp_ID] NOT IN 
 (SELECT DISTINCT EMPID FROM [EC].[EmployeeID_To_LanID])
 )S LEFT OUTER JOIN [EC].[Employee_Ids_With_Prefixes]PE
 ON S.Emp_ID = PE.Emp_ID
 WHERE PE.Emp_ID IS NULL
 
OPTION (MAXDOP 1)
END 
WAITFOR DELAY '00:00:00.02' -- Wait for 2 ms

-- Removes Alpha characters from first 2 positions of Emp_ID
-- and removes all leading and trailing spaces for those Employees
-- that do not need the prefix retained for uniqueness.

BEGIN
UPDATE [EC].[Employee_Hierarchy_Stage]
SET [Emp_ID]= [EC].[RemoveAlphaCharacters](REPLACE(LTRIM(RTRIM([Emp_ID])),' ',''))
WHERE [Emp_ID] NOT IN
 (SELECT DISTINCT [Emp_ID]FROM [EC].[Employee_Ids_With_Prefixes])
 
OPTION (MAXDOP 1)
END  
 WAITFOR DELAY '00:00:00.02' -- Wait for 2 ms

-- Remove leading and trailing spaces from Emp and Sup Ids from EWFM.
BEGIN
UPDATE [EC].[EmpID_To_SupID_Stage]
SET [Emp_ID]= REPLACE(LTRIM(RTRIM([Emp_ID])),' ',''),
   [Sup_ID]= REPLACE(LTRIM(RTRIM([Sup_ID])),' ','')
END
WAITFOR DELAY '00:00:00.02' -- Wait for 2 ms

    
-- Set Sup_Emp_ID  and Program for CSRs from WFM
BEGIN
UPDATE [EC].[Employee_Hierarchy_Stage]
SET [Sup_Emp_ID] = [Sup_ID],
[Emp_Program]= 
CASE WHEN WFMSUP.[Emp_Program]like 'FFM%'
THEN 'Marketplace' ELSE 'Medicare' END
FROM [EC].[EmpID_To_SupID_Stage] WFMSUP JOIN [EC].[Employee_Hierarchy_Stage]HS
ON WFMSUP.Emp_ID = HS.Emp_ID
WHERE HS.[Emp_Job_Code]in ('WACS01','WACS02','WACS03')
OPTION (MAXDOP 1)
END
WAITFOR DELAY '00:00:00.02' -- Wait for 2 ms




-- Update Mgr_Emp_ID to be Supervisor's supervisor
BEGIN
UPDATE [EC].[Employee_Hierarchy_Stage]
SET Mgr_Emp_ID =[EC].[fn_strMgrEmpIDFromEmpID] (Emp_ID)
OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms


-- This will ensure that all users with missing sup id and mgr id will not be in the Employee_Hierarchy table.
BEGIN


DELETE FROM [EC].[Employee_Hierarchy_Stage]
WHERE EMP_JOB_CODE IN (SELECT DISTINCT JOB_CODE FROM EC.Employee_Selection)
AND ([Sup_Emp_ID] = ' ' OR [Sup_Emp_ID] is NULL OR [Mgr_Emp_ID] = ' ' OR  [Mgr_Emp_ID] is NULL)



OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

-- Populates Supervisor attributes
BEGIN 
UPDATE Emp
    SET [Sup_Name]= Sup.[Emp_Name],
    [Sup_Email]= Sup.[Emp_Email],
    [Sup_Job_Code]= Sup.[Emp_Job_Code],
    [Sup_Job_Description]= Sup.[Emp_Job_Description],
    [Sup_LanID]= Sup.[Emp_LanID]
   FROM [EC].[Employee_Hierarchy_Stage] as Emp Join [EC].[Employee_Hierarchy_Stage]as Sup
    ON Emp.[Sup_Emp_ID]= Sup.[EMP_ID]
OPTION (MAXDOP 1)
 END
 
 WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms
    
-- Populates Manager attributes
BEGIN    
 UPDATE Emp
    SET [Mgr_Name]= Mgr.[Emp_Name],
    [Mgr_Email]= Mgr.[Emp_Email],
    [Mgr_Job_Code]= Mgr.[Emp_Job_Code],
    [Mgr_Job_Description]= Mgr.[Emp_Job_Description],
    [Mgr_LanID]= Mgr.[Emp_LanID]
    FROM [EC].[Employee_Hierarchy_Stage] as Emp Join [EC].[Employee_Hierarchy_Stage]as Mgr
    ON Emp.[Mgr_Emp_ID]= Mgr.[EMP_ID]
OPTION (MAXDOP 1)
END


-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];	 

COMMIT TRANSACTION
END TRY
      
      BEGIN CATCH
	--PRINT 'Rollback Transaction'
	ROLLBACK TRANSACTION
	DECLARE @DoRetry bit; -- Whether to Retry transaction or not
    DECLARE @ErrorMessage NVARCHAR(4000)
    DECLARE @ErrorSeverity INT
    DECLARE @ErrorState INT
    
     SET @doRetry = 0;
     SELECT @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE()
    
    
    IF ERROR_NUMBER() = 1205 -- Deadlock Error Number
	BEGIN
		SET @doRetry = 1; -- Set @doRetry to 1 only for Deadlock
	END
	IF @DoRetry = 1
	BEGIN
		SET @RetryCounter = @RetryCounter + 1 -- Increment Retry Counter By one
		IF (@RetryCounter > 3) -- Check whether Retry Counter reached to 3
		BEGIN
			RAISERROR(@ErrorMessage, 18, 1) -- Raise Error Message if 
				-- still deadlock occurred after three retries
		END
		ELSE
		BEGIN
			WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms
			GOTO RETRY	-- Go to Label RETRY
		END
	END
	ELSE
	BEGIN
    RAISERROR (@ErrorMessage, -- Message text.
               @ErrorSeverity, -- Severity.
               @ErrorState -- State.
               )
      
    IF ERROR_NUMBER() IS NULL
      RETURN 1
    ELSE IF ERROR_NUMBER() <> 0 
      RETURN ERROR_NUMBER()
    ELSE
      RETURN 1
   END
  END CATCH  

END  -- [EC].[sp_Update_Employee_Hierarchy_Stage]
GO




