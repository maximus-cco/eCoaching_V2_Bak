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
-- Modified to support Legacy Ids to Maximus Ids - TFS 13777 - 05/22/2019
-- Modified to remove duplicates from PS file -  TFS 23042 - 09/22/2021
-- Modified to support eCoaching Log for Subcontractors - TFS 27527 - 02/01/2024
-- =============================================
CREATE OR ALTER PROCEDURE [EC].[sp_Update_Employee_Hierarchy_Stage] 
AS
BEGIN

DECLARE @RetryCounter INT
SET @RetryCounter = 1

RETRY: -- Label RETRY


BEGIN TRANSACTION
BEGIN TRY

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 

-- Encrypt name and LanID in Emp ID TO Sup ID Aspect data Staging table

UPDATE [EC].[EmpID_To_SupID_Stage]
SET [Emp_Name] = EncryptByKey(Key_GUID('CoachingKey'), [Emp_Name_Drop])
,[Emp_LanID]= EncryptByKey(Key_GUID('CoachingKey'), [Emp_LanID_Drop])
WHERE [Emp_Name] IS NULL AND [Emp_LanID]IS NULL;
 

WAITFOR DELAY '00:00:00.02'; -- Wait for 2 ms

-- Set Unencrypted name and Lan ID to NULL in Emp ID TO Sup ID Aspect data Staging table

UPDATE [EC].[EmpID_To_SupID_Stage]
SET [Emp_Name_Drop] = NULL
,[Emp_LanID_Drop]= NULL;
 
WAITFOR DELAY '00:00:00.02'; -- Wait for 2 ms



-- Remove Duplicate records in PS File from IQS

	 WITH Dups As
	 (SELECT [Emp_ID],ROW_NUMBER() over (partition by [Emp_ID]
           order by [Emp_ID],[Start_Date] DESC, 
		   CASE WHEN [Emp_LanID] NOT LIKE '%[^0-9]%' THEN 1 ELSE 2 END ASC, 
		   CASE WHEN COALESCE(LTRIM(RTRIM([Emp_Job_Code])),'') IN ('', 'AAAAAA') THEN 2 ELSE 1 END ASC ) RowNumber 
	FROM [EC].[Employee_Hierarchy_Stage]) 

  --SELECT * FROM Dups where RowNumber > 1;
    DELETE FROM Dups where RowNumber > 1;
	
WAITFOR DELAY '00:00:00.02'; -- Wait for 2 ms


-- Populate Emp_Name with Primary Name where No preferred Name populated.

UPDATE [EC].[Employee_Hierarchy_Stage]
SET [Emp_Name] = [Emp_Pri_Name]
WHERE LTRIM(RTRIM(Emp_Name)) = ',';
 
 WAITFOR DELAY '00:00:00.02' -- Wait for 2 ms

-- Removes # from LanID and Email address of inactive employees

UPDATE [EC].[Employee_Hierarchy_Stage]
SET [Emp_LanID]= REPLACE([Emp_LanID], '#',''),
    [Emp_Email]= REPLACE([Emp_Email], '#','');
 
 
 WAITFOR DELAY '00:00:00.02'; -- Wait for 2 ms


-- Remove leading and trailing spaces from Emp and Sup Ids from EWFM.

UPDATE [EC].[EmpID_To_SupID_Stage]
SET [Emp_ID]= REPLACE(LTRIM(RTRIM([Emp_ID])),' ',''),
   [Sup_ID]= REPLACE(LTRIM(RTRIM([Sup_ID])),' ','');

WAITFOR DELAY '00:00:00.02'; -- Wait for 2 ms

    
-- Set Sup_Emp_ID  and Program for CSRs from WFM

UPDATE [EC].[Employee_Hierarchy_Stage]
SET [Sup_Emp_ID] = [Sup_ID],
[Emp_Program]= 
CASE WHEN WFMSUP.[Emp_Program]like 'FFM%'
THEN 'Marketplace' ELSE 'Medicare' END
FROM [EC].[EmpID_To_SupID_Stage] WFMSUP JOIN [EC].[Employee_Hierarchy_Stage]HS
ON WFMSUP.Emp_ID = HS.Emp_ID
WHERE HS.[Emp_Job_Code] like 'WACS0%';

WAITFOR DELAY '00:00:00.02'; -- Wait for 2 ms

-- Set Sup_Emp_ID  for Sub Sups from WFM

UPDATE [EC].[Employee_Hierarchy_Stage]
SET [Sup_Emp_ID] = [Sup_ID]
FROM [EC].[EmpID_To_SupID_Stage] WFMSUP JOIN [EC].[Employee_Hierarchy_Stage]HS
ON WFMSUP.Emp_ID = HS.Emp_ID
WHERE WFMSUP.[Emp_Job_Code] <> 'CSC' AND WFMSUP.[Emp_Job_Code] like  '%SC'

WAITFOR DELAY '00:00:00.02'; -- Wait for 2 ms

-- Update Mgr_Emp_ID to be Supervisor's supervisor

UPDATE [EC].[Employee_Hierarchy_Stage]
SET Mgr_Emp_ID =[EC].[fn_strMgrEmpIDFromEmpID] (Emp_ID);


WAITFOR DELAY '00:00:00.02'; -- Wait for 2 ms


-- This will ensure that all users with missing sup id and mgr id will not be in the Employee_Hierarchy table.
DELETE FROM [EC].[Employee_Hierarchy_Stage]
WHERE EMP_JOB_CODE IN (SELECT DISTINCT JOB_CODE FROM EC.Employee_Selection)
AND ([Sup_Emp_ID] = ' ' OR [Sup_Emp_ID] is NULL OR [Mgr_Emp_ID] = ' ' OR  [Mgr_Emp_ID] is NULL);

WAITFOR DELAY '00:00:00.02'; -- Wait for 2 ms

-- Populates Supervisor attributes

UPDATE Emp
    SET [Sup_Name]= Sup.[Emp_Name],
    [Sup_Email]= Sup.[Emp_Email],
    [Sup_Job_Code]= Sup.[Emp_Job_Code],
    [Sup_Job_Description]= Sup.[Emp_Job_Description],
    [Sup_LanID]= Sup.[Emp_LanID]
   FROM [EC].[Employee_Hierarchy_Stage] as Emp Join [EC].[Employee_Hierarchy_Stage]as Sup
    ON Emp.[Sup_Emp_ID]= Sup.[EMP_ID];

 
 WAITFOR DELAY '00:00:00.02'; -- Wait for 2 ms
    
-- Populates Manager attributes

 UPDATE Emp
    SET [Mgr_Name]= Mgr.[Emp_Name],
    [Mgr_Email]= Mgr.[Emp_Email],
    [Mgr_Job_Code]= Mgr.[Emp_Job_Code],
    [Mgr_Job_Description]= Mgr.[Emp_Job_Description],
    [Mgr_LanID]= Mgr.[Emp_LanID]
    FROM [EC].[Employee_Hierarchy_Stage] as Emp Join [EC].[Employee_Hierarchy_Stage]as Mgr
    ON Emp.[Mgr_Emp_ID]= Mgr.[EMP_ID];

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


