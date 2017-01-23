/*
sp_InactivateCoachingLogsForTerms(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InactivateCoachingLogsForTerms' 
)
   DROP PROCEDURE [EC].[sp_InactivateCoachingLogsForTerms]
GO


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
-- =============================================
CREATE PROCEDURE [EC].[sp_InactivateCoachingLogsForTerms] 
AS
BEGIN

 DECLARE @EWFMSiteCount INT
 
 -- Inactivate Warnings logs for Termed Employees


SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

BEGIN TRY

-- Log records being inactivated to Audit table and 
-- Inactivate Warning logs for Termed Employees
BEGIN
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
ON W.[EmpLanID] = H.[Emp_LanID]
AND W.[EmpID] = H.[Emp_ID]
WHERE CAST(H.[End_Date] AS DATETIME)< GetDate()
AND H.[Active] = 'D'
AND H.[End_Date]<> '99991231'
AND W.[StatusID] <> 2	 
OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms


BEGIN
UPDATE [EC].[Warning_Log]
SET [StatusID] = 2
FROM [EC].[Warning_Log] W JOIN [EC].[Employee_Hierarchy]H
ON W.[EmpLanID] = H.[Emp_LanID]
AND W.[EmpID] = H.[Emp_ID]
WHERE CAST(H.[End_Date] AS DATETIME)< GetDate()
AND H.[Active] = 'D'
AND H.[End_Date]<> '99991231'
AND W.[StatusID] <> 2
OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms


-- Inactivate Surveys for Termed Employees

BEGIN
UPDATE [EC].[Survey_Response_Header]
SET [Status] = 'Inactive'
,[InactivationDate] = GETDATE()
,[InactivationReason] = 'Employee Not Active'
FROM [EC].[Survey_Response_Header]SH  JOIN [EC].[Employee_Hierarchy]H
ON SH.[EmpLanID] = H.[Emp_LanID]
AND SH.[EmpID] = H.[Emp_ID]
WHERE CAST(H.[End_Date] AS DATETIME)< GetDate()
AND H.[Active] in ('T','D')
AND H.[End_Date]<> '99991231'
AND SH.[Status] = 'Open'
AND [InactivationReason] IS NULL
OPTION (MAXDOP 1)
END


WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms


 -- Inactivate Expired Survey records (5 days after creation date)

BEGIN
UPDATE [EC].[Survey_Response_Header]
SET [Status] = 'Inactive'
,[InactivationDate] = GETDATE()
,[InactivationReason] = 'Survey Expired'
WHERE DATEDIFF(DAY, [CreatedDate],  GETDATE())>= 5
AND [Status]  = 'Open'
AND [InactivationReason] IS NULL
OPTION (MAXDOP 1)
END


WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms



--Log records being inactivated to Audit table and 
--Inactivate Coaching logs for Termed Employees

BEGIN
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
ON C.[EmpLanID] = H.[Emp_LanID]
AND C.[EmpID] = H.[Emp_ID]
WHERE CAST(H.[End_Date] AS DATETIME)< GetDate()
AND H.[Active] in ('T','D')
AND H.[End_Date]<> '99991231'
AND C.[StatusID] not in (1,2)	 
OPTION (MAXDOP 1)		 
END


WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

BEGIN
UPDATE [EC].[Coaching_Log]
SET [StatusID] = 2
FROM [EC].[Coaching_Log] C JOIN [EC].[Employee_Hierarchy]H
ON C.[EmpLanID] = H.[Emp_LanID]
AND C.[EmpID] = H.[Emp_ID]
WHERE CAST(H.[End_Date] AS DATETIME)< GetDate()
AND H.[Active] in ('T','D')
AND H.[End_Date]<> '99991231'
AND C.[StatusID] not in (1,2)
OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

-- Log records being inactivated to Audit table and 
-- Inactivate Coaching logs for Employees on Extended Absence


BEGIN
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
ON C.[EmpLanID] = H.[Emp_LanID]
AND C.[EmpID] = LTRIM(H.[Emp_ID])
WHERE H.[Emp_Status]= 'EA'
AND H.[Emp_LanID] IS NOT NULL
AND C.[StatusID] not in (1,2) 
OPTION (MAXDOP 1)		 
END


WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms


BEGIN
UPDATE [EC].[Coaching_Log]
SET [StatusID] = 2
FROM [EC].[Coaching_Log] C JOIN [EC].[EmpID_To_SupID_Stage]H
ON C.[EmpLanID] = H.[Emp_LanID]
AND C.[EmpID] = LTRIM(H.[Emp_ID])
WHERE H.[Emp_Status]= 'EA'
AND H.[Emp_LanID] IS NOT NULL
AND C.[StatusID] not in (1,2)
OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

-- Log records being inactivated to Audit table and 
-- Inactivate Coaching logs for CSRs and Sup Module eCLs for Employees not arriving in eWFM feed.


SET @EWFMSiteCount = (SELECT count(DISTINCT Emp_Site_Code) FROM [EC].[EmpID_To_SupID_Stage])
IF @EWFMSiteCount >= 14



BEGIN
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
		 ,'Employee not in feed'
		 ,'Employee Hierarchy Load Process'
FROM [EC].[Coaching_Log] C LEFT OUTER JOIN [EC].[EmpID_To_SupID_Stage] S
ON C.EMPID = LTRIM(S.EMP_ID)
WHERE C.[StatusID] not in (1,2)
AND C.[ModuleID]  in (1,2)
AND S.EMP_ID IS NULL
OPTION (MAXDOP 1)
END
		 

WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

BEGIN
UPDATE [EC].[Coaching_Log]
SET [StatusID] = 2
FROM [EC].[Coaching_Log] C LEFT OUTER JOIN [EC].[EmpID_To_SupID_Stage] S
ON C.EMPID = LTRIM(S.EMP_ID)
WHERE C.[StatusID] not in (1,2)
AND C.[ModuleID]  in (1,2)
AND S.EMP_ID IS NULL
OPTION (MAXDOP 1)
END


COMMIT TRANSACTION
END TRY

  BEGIN CATCH
  ROLLBACK TRANSACTION
  END CATCH

END  -- [EC].[sp_InactivateCoachingLogsForTerms]







GO

