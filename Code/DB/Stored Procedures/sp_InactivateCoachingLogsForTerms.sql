SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		   Susmitha Palacherla
-- Create Date:    04/09/2014
-- Description:	Inactivate Coaching logs for Termed Employees.
-- Last Modified By: Susmitha Palacherla
-- Revision History:
-- Modified per TFS 549 - To Inactivate Surveys for termed Employees and Expired Surveys.
-- Surveys expire 5 days from Creation date - 09/04/2015
-- Admin tool setup per TFS 1709-  To log Inactivations in audit tables - 4/27/12016
-- Updated to not Inactivate Warning logs for termed Employees per TFS 3441 - 09/08/2016
--  Modified to support Encryption of sensitive data. Removed joins on LanID. TFS 7856 - 10/23/2017
-- Updated to support Legacy Ids to Maximus Ids - TFS 13777 - 05/22/2019
-- Updated to Revise stored procedures causing deadlocks. TFS 21713 - 6/17/2021
-- Updated survey expiration timeframe. TFS 24201 - 03/09/2022
-- Updated to remove lanid check for EA inactivations. TFS 26268 - 03/07/2023 

-- =============================================
CREATE OR ALTER PROCEDURE [EC].[sp_InactivateCoachingLogsForTerms] 

AS
BEGIN

 DECLARE @EWFMSiteCount INT
 
 -- Inactivate Warnings logs for Termed Employees

BEGIN TRANSACTION

BEGIN TRY

-- Inactivate Warning logs for Termed Employees
-- Log records being inactivated to Audit table 

INSERT INTO [EC].[AT_Warning_Inactivate_Reactivate_Audit]
           ([WarningID]
           ,[FormName]
           ,[LastKnownStatus]
           ,[Action]
           ,[ActionTimestamp]
           ,[RequesterID]
           ,[Reason]
           ,[RequesterComments]
          )
   SELECT W.WarningID
		 ,W.FormName
		 ,W.StatusID
		 ,'Inactivate'
		 ,GetDate()
	 	 ,'999998'
		 ,'Employee Deceased'
		 ,'Employee Hierarchy Load Process'
FROM [EC].[Warning_Log] W JOIN [EC].[Employee_Hierarchy]H
ON W.[EmpID] = H.[Emp_ID]
WHERE CAST(H.[End_Date] AS DATETIME)< GetDate()
AND H.[Active] = 'D'
AND H.[End_Date]<> '99991231'
AND W.[StatusID] <> 2;	 


 WAITFOR DELAY '00:00:00.02'; -- Wait for 2 ms

-- Inactivate the Warning logs

UPDATE [EC].[Warning_Log]
SET [StatusID] = 2
FROM [EC].[Warning_Log] W JOIN [EC].[Employee_Hierarchy]H
ON W.[EmpID] = H.[Emp_ID]
WHERE CAST(H.[End_Date] AS DATETIME)< GetDate()
AND H.[Active] = 'D'
AND H.[End_Date]<> '99991231'
AND W.[StatusID] <> 2;


 WAITFOR DELAY '00:00:00.02'; -- Wait for 2 ms


-- Inactivate Surveys for Termed Employees

UPDATE [EC].[Survey_Response_Header]
SET [Status] = 'Inactive'
,[InactivationDate] = GETDATE()
,[InactivationReason] = 'Employee Not Active'
FROM [EC].[Survey_Response_Header]SH  JOIN [EC].[Employee_Hierarchy]H
ON SH.[EmpID] = H.[Emp_ID]
WHERE CAST(H.[End_Date] AS DATETIME)< GetDate()
AND H.[Active] in ('T','D')
AND H.[End_Date]<> '99991231'
AND SH.[Status] = 'Open'
AND [InactivationReason] IS NULL;


 WAITFOR DELAY '00:00:00.02'; -- Wait for 2 ms


 -- Inactivate Expired Survey records (7 days after creation date)
 
UPDATE [EC].[Survey_Response_Header]
SET [Status] = 'Inactive'
,[InactivationDate] = GETDATE()
,[InactivationReason] = 'Survey Expired'
WHERE DATEDIFF(DAY, [CreatedDate],  GETDATE())>= 7
AND [Status]  = 'Open'
AND [InactivationReason] IS NULL;


 WAITFOR DELAY '00:00:00.02'; -- Wait for 2 ms

--Inactivate Coaching logs for Termed Employees
--Log records being inactivated to Audit table 

INSERT INTO [EC].[AT_Coaching_Inactivate_Reactivate_Audit]
           ([CoachingID]
           ,[FormName]
           ,[LastKnownStatus]
           ,[Action]
           ,[ActionTimestamp]
           ,[RequesterID]
           ,[Reason]
           ,[RequesterComments]
          )
   SELECT C.CoachingID
		 ,C.FormName
		 ,C.StatusID
		 ,'Inactivate'
		 ,GetDate()
		 ,'999998'
		 ,'Employee Inactive'
		 ,'Employee Hierarchy Load Process'
FROM [EC].[Coaching_Log] C JOIN [EC].[Employee_Hierarchy]H
ON C.[EmpID] = H.[Emp_ID]
WHERE CAST(H.[End_Date] AS DATETIME)< GetDate()
AND H.[Active] in ('T','D')
AND H.[End_Date]<> '99991231'
AND C.[StatusID] not in (1,2); 

 WAITFOR DELAY '00:00:00.02'; -- Wait for 2 ms

-- Inactivate the Coaching logs for terms

UPDATE [EC].[Coaching_Log]
SET [StatusID] = 2
FROM [EC].[Coaching_Log] C JOIN [EC].[Employee_Hierarchy]H
ON C.[EmpID] = H.[Emp_ID]
WHERE CAST(H.[End_Date] AS DATETIME)< GetDate()
AND H.[Active] in ('T','D')
AND H.[End_Date]<> '99991231'
AND C.[StatusID] not in (1,2);


 WAITFOR DELAY '00:00:00.02'; -- Wait for 2 ms

-- Inactivate Coaching logs for Employees on Extended Absence
-- Log records being inactivated to Audit table and 

INSERT INTO [EC].[AT_Coaching_Inactivate_Reactivate_Audit]
           ([CoachingID]
           ,[FormName]
           ,[LastKnownStatus]
           ,[Action]
           ,[ActionTimestamp]
           ,[RequesterID]
           ,[Reason]
           ,[RequesterComments]
          )
   SELECT C.CoachingID
		 ,C.FormName
		 ,C.StatusID
		 ,'Inactivate'
		 ,GetDate()
		 ,'999998'
		 ,'Employee on EA'
		 ,'Employee Hierarchy Load Process'
FROM [EC].[Coaching_Log] C JOIN [EC].[EmpID_To_SupID_Stage]H
ON C.[EmpID] = LTRIM(H.[Emp_ID])
WHERE H.[Emp_Status]= 'EA'
AND C.[StatusID] not in (1,2);

 WAITFOR DELAY '00:00:00.02'; -- Wait for 2 ms

-- Inactivate the Coaching logs for EA

UPDATE [EC].[Coaching_Log]
SET [StatusID] = 2
FROM [EC].[Coaching_Log] C JOIN [EC].[EmpID_To_SupID_Stage]H
ON C.[EmpID] = LTRIM(H.[Emp_ID])
WHERE H.[Emp_Status]= 'EA'
AND C.[StatusID] not in (1,2);


COMMIT TRANSACTION
END TRY

  BEGIN CATCH
  ROLLBACK TRANSACTION
  END CATCH

END  -- [EC].[sp_InactivateCoachingLogsForTerms]
GO


