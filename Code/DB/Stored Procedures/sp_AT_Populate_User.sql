/*
sp_AT_Populate_User(02).sql
Last Modified Date:  03/10/2020
Last Modified By: Susmitha Palacherla


Version 02: Update lanid if diffrent from employee table - TFS 16529 - 03/10/2020
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
--  Update lanid if diffrent from employee table - TFS 16529 - 03/10/2020
-- =============================================
CREATE PROCEDURE [EC].[sp_AT_Populate_User] 
AS
BEGIN

SET TRANSACTION ISOLATION LEVEL READ COMMITTED  --- May be snapshot isolation for longer reporting queries
BEGIN TRANSACTION

BEGIN TRY

-- Open Symmetric Key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

-- Inactivate termed users and those with job code changes
-- that result in a non allowed job code. 
  
UPDATE [EC].[AT_User] 
	SET [Active] = 0
	FROM [EC].[Employee_Hierarchy] EH JOIN [EC].[AT_User]U
	ON EH.Emp_ID = U.UserId 
    WHERE(EH.Active in ('T', 'D')OR
    EH.Emp_Job_Code NOT IN 
	(SELECT DISTINCT JobCode FROM [EC].[AT_Role_Access])
	OR(EH.Active = 'A' AND EH.Emp_Job_Code <> U.EmpJobCode))
     AND U.Active <> 0;


-- Delete Role link tables for Inactive users

	DELETE URL
	FROM [EC].[AT_User]U JOIN EC.AT_User_Role_Link URL
	ON U.UserId = URL.UserId
	WHERE U.Active = 0;
	

-- Reactivate users with Active status or with job code changes
-- that result in an allowed job code. 

    UPDATE [EC].[AT_User] 
	SET [Active] = 1,
	EmpJobCode = EH.Emp_Job_Code
	FROM [EC].[Employee_Hierarchy] EH JOIN [EC].[AT_User]U
	ON EH.Emp_ID = U.UserId
	AND (EH.Active = 'A' AND EH.Emp_Job_Code IN 
	(SELECT DISTINCT JobCode FROM [EC].[AT_Role_Access]))
     AND U.Active = 0;

-- Update lanid for users if different from employee table

 UPDATE [EC].[AT_User] 
	SET UserLanID = EH.Emp_LanID
	FROM [EC].[Employee_Hierarchy] EH JOIN [EC].[AT_User]U
	ON EH.Emp_ID = U.UserId
    WHERE U.Active = 1
	AND CONVERT(nvarchar(30),DecryptByKey(EH.Emp_LanID)) <> CONVERT(nvarchar(30),DecryptByKey(U.UserLanID))
        AND CONVERT(nvarchar(30),DecryptByKey(EH.Emp_LanID)) IS NOT NULL ;

	 
    
-- Inserts new user records 

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
						  WHERE [AddToUser] =1);


-- Inserts new user role link records 

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
			WHERE ( URL.UserId is NULL and URL.RoleId is NULL);
						
 -- Clode Symmetric Key
  CLOSE SYMMETRIC KEY [CoachingKey]; 

COMMIT TRANSACTION
END TRY

  BEGIN CATCH
  ROLLBACK TRANSACTION
  END CATCH


END --sp_AT_Populate_User
GO




