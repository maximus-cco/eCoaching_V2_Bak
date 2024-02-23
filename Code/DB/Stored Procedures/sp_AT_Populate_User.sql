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
--  Update to Support Report access for Early Life Supervisors. TFS 24924 - 7/11/2022
--  Modified to support eCoaching Log for Subcontractors - TFS 27527 - 02/01/2024
-- =============================================
CREATE OR ALTER PROCEDURE [EC].[sp_AT_Populate_User] 
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
    WHERE(EH.Active in ('T', 'D') OR
    EH.Emp_Job_Code NOT IN 
	(SELECT DISTINCT JobCode FROM [EC].[AT_Role_Access]) OR
	(EH.Active = 'A' AND EH.Emp_Job_Code <> U.EmpJobCode))
     AND U.Active = 1;

-- Inactivate User Records for ELS Role Supervisors where ELS Role is Inactive in ACL Table

UPDATE [EC].[AT_User] 
	SET [Active] = 0
	FROM [EC].[AT_User]  U INNER JOIN
	(SELECT EC.fn_nvcGetEmpIdFromLanId(CONVERT(nvarchar(30),DecryptByKey([User_LanID])), getdate()) AS Emp_ID
	FROM [EC].[Historical_Dashboard_ACL] WHERE Role = 'ELS'  AND End_Date <> 99991231) ELS
	ON ELS.Emp_ID = U.UserId 
    WHERE U.EmpJobCode = 'WACS40'
    AND U.Active = 1;
	

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
	WHERE (EH.Active = 'A' AND EH.Emp_Job_Code IN 
	(SELECT DISTINCT JobCode FROM [EC].[AT_Role_Access] WHERE AddToUser = 1))
     AND U.Active = 0;

-- Reactivate User Records for ELS Role Supervisors where ELS Role is Active in ACL Table

UPDATE [EC].[AT_User] 
	SET [Active] = 1,
	EmpJobCode = E.Emp_Job_Code 
	FROM [EC].[AT_User] U INNER JOIN [EC].[Employee_Hierarchy] E
	ON E.Emp_ID = U.UserId INNER JOIN
	(SELECT EC.fn_nvcGetEmpIdFromLanId(CONVERT(nvarchar(30),DecryptByKey([User_LanID])), getdate()) AS Emp_ID
	FROM [EC].[Historical_Dashboard_ACL] WHERE Role = 'ELS'  AND End_Date = 99991231) ELS
	ON ELS.Emp_ID = U.UserId 
    WHERE U.EmpJobCode IN ( 'WACS40', 'WACS50')
    AND U.Active = 0;

-- Update lanid for users if different from employee table

 UPDATE [EC].[AT_User] 
	SET UserLanID = EH.Emp_LanID
	FROM [EC].[Employee_Hierarchy] EH JOIN [EC].[AT_User]U
	ON EH.Emp_ID = U.UserId
    WHERE U.Active = 1
	AND CONVERT(nvarchar(30),DecryptByKey(EH.Emp_LanID)) <> CONVERT(nvarchar(30),DecryptByKey(U.UserLanID))
	AND CONVERT(nvarchar(30),DecryptByKey(EH.Emp_LanID)) IS NOT NULL ;
	 
    
-- Inserts new user records for users having AddToUser = 1 for their job codes

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
						  WHERE [AddToUser] = 1);

-- Insert new user records for ELS Sups
	INSERT INTO [EC].[AT_User]
	([UserId],[UserLanID],[UserName],[EmpJobCode],[Active] )
							  SELECT EH.[Emp_ID]
				  		      ,EH.[Emp_LanID]
				  		      ,EH.[Emp_Name]
				  		      ,EH.[Emp_Job_Code]
							  ,1
						  FROM  (SELECT EC.fn_nvcGetEmpIdFromLanId(CONVERT(nvarchar(30),DecryptByKey([User_LanID])), getdate()) AS Emp_ID
						  FROM [EC].[Historical_Dashboard_ACL] WHERE Role = 'ELS' AND End_Date = 99991231) ELS
						  INNER JOIN [EC].[Employee_Hierarchy]EH ON EH.Emp_ID = ELS.Emp_ID LEFT OUTER JOIN [EC].[AT_User]U
						  ON EH.Emp_ID = U.UserId
  						  WHERE EH.Emp_Job_Code = 'WACS40'
						  AND U.UserId IS NULL;


-- Inserts new user role links for jobcode and role combinations having AddToUser = 1 

	INSERT INTO [EC].[AT_User_Role_Link]
	([UserId],[RoleID])
			SELECT URA.UserId, URA.RoleId FROM 
		    (SELECT U.[UserId],RA.[RoleId]
			FROM [EC].[AT_User]U JOIN [EC].[AT_Role_Access] RA
			ON U.[EmpJobCode] = RA.[JobCode]
			WHERE RA.[AddToUser]= 1
			AND U.Active = 1) URA LEFT OUTER JOIN [EC].[AT_User_Role_Link]URL
			ON URA.UserId = URL.UserId
			AND URA.RoleId = URL.RoleId
			WHERE ( URL.UserId is NULL and URL.RoleId is NULL);

-- Inserts new user role links for ELS Role users and jobcode and role combinations having AddToUser = 0 
	INSERT INTO [EC].[AT_User_Role_Link]
	([UserId],[RoleID])
			 SELECT URA.UserId, URA.RoleId FROM 
		    (SELECT U.[UserId],RA.[RoleId]
			FROM [EC].[AT_User]U JOIN [EC].[AT_Role_Access] RA
			ON U.[EmpJobCode] = RA.[JobCode] INNER JOIN
	(SELECT EC.fn_nvcGetEmpIdFromLanId(CONVERT(nvarchar(30),DecryptByKey([User_LanID])), getdate()) AS Emp_ID
	FROM [EC].[Historical_Dashboard_ACL] WHERE Role = 'ELS'  AND End_Date = 99991231) ELS
	ON ELS.Emp_ID = U.UserId 
			WHERE 1 = 1
			AND RA.[AddToUser]= 0
			AND U.Active = 1) URA LEFT OUTER JOIN [EC].[AT_User_Role_Link]URL
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


