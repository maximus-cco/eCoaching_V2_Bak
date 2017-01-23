/*
sp_AT_Populate_User(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Populate_User' 
)
   DROP PROCEDURE [EC].[sp_AT_Populate_User]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		   Susmitha Palacherla
-- Create Date: 4/27/12016
-- Description:	Performs the following actions.
-- Updates existing records and Inserts New records from the Employee table.
-- Last Modified By: Susmitha Palacherla
-- Revision History:
--  Initial Revision. Admin tool setup, TFS 1709- 4/27/12016
--  Update admin job code, TFS 3416 - 7/26/2016
--  Updated logic for role assignment for job code change within allowed job codes during TFS 3027 - 11/28/2016
-- =============================================
CREATE PROCEDURE [EC].[sp_AT_Populate_User] 
AS
BEGIN

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

BEGIN TRY
-- Inactivate termed users and those with job code changes
-- that result in a non allowed job code. 
 
BEGIN
	
UPDATE [EC].[AT_User] 
	SET [Active] = 0
	FROM [EC].[Employee_Hierarchy] EH JOIN [EC].[AT_User]U
	ON EH.Emp_ID = U.UserId 
    WHERE(EH.Active in ('T', 'D')OR
    EH.Emp_Job_Code NOT IN 
	(SELECT DISTINCT JobCode FROM [EC].[AT_Role_Access])
	OR(EH.Active = 'A' AND EH.Emp_Job_Code <> U.EmpJobCode))
     AND U.Active <> 0

OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms


-- Delete Role link tables for Inactive users

BEGIN
	DELETE URL
	FROM [EC].[AT_User]U JOIN EC.AT_User_Role_Link URL
	ON U.UserId = URL.UserId
	WHERE U.Active = 0
	

OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.03' -- Wait for 3 ms

-- Reactivate users with Active status or with job code changes
-- that result in an allowed job code. 

BEGIN
    UPDATE [EC].[AT_User] 
	SET [Active] = 1,
	EmpJobCode = EH.Emp_Job_Code
	FROM [EC].[Employee_Hierarchy] EH JOIN [EC].[AT_User]U
	ON EH.Emp_ID = U.UserId
	AND (EH.Active = 'A' AND EH.Emp_Job_Code IN 
	(SELECT DISTINCT JobCode FROM [EC].[AT_Role_Access]))
     AND U.Active = 0

OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms
    
-- Inserts new user records 

BEGIN
	INSERT INTO [EC].[AT_User]
	([UserId],[UserLanID],[UserName],[EmpJobCode],[Active] )
							  SELECT EH.[Emp_ID]
				  		      ,EH.[Emp_LanID]
				  		      ,EH.[Emp_Name]
				  		      ,EH.[Emp_Job_Code]
							  ,1
						  FROM [EC].[Employee_Hierarchy]EH Left outer Join [EC].[AT_User]U
						  ON EH.Emp_ID = U.UserId
						  WHERE (U.UserId IS NULL and EH.Emp_ID <> '')
						  AND EH.Active = 'A'
						  AND EH.Emp_Job_Code IN 
						 (SELECT DISTINCT JobCode FROM [EC].[AT_Role_Access]
						  WHERE [AddToUser] =1)

OPTION (MAXDOP 1)
END


-- Inserts new user role link records 

BEGIN
	INSERT INTO [EC].[AT_User_Role_Link]
	([UserId],[RoleID])
			SELECT URA.UserId, URA.RoleId FROM 
		    (SELECT U.[UserId],RA.[RoleId]
			FROM [EC].[AT_User]U JOIN [EC].[AT_Role_Access] RA
			ON U.[EmpJobCode] = RA.[JobCode]
			WHERE RA.[AddToUser]=1
			AND U.Active = 1)URA LEFT OUTER JOIN [EC].[AT_User_Role_Link]URL
			ON URA.UserId = URL.UserId
			AND URA.RoleId = URL.RoleId
			WHERE ( URL.UserId is NULL and URL.RoleId is NULL)
						

OPTION (MAXDOP 1)
END


COMMIT TRANSACTION
END TRY

  BEGIN CATCH
  ROLLBACK TRANSACTION
  END CATCH


END --sp_AT_Populate_User


GO

