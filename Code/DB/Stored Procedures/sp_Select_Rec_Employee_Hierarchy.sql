SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:	Susmitha Palacherla
--	Create Date: 01/18/2018
--	Description: Returns a record from Employee Hierarchy table table given an Employee ID.
--  Revision History:    
--  Initial Revision. Created to replace embedded sql in UI code during encryption of sensitive data. TFS 7856. 01/18/2018
--  Modified during Submissions move to new architecture - TFS 7136 - 04/10/2018
--  Modified during Historical dashboard move to new architecture - TFS 7138 - 05/04/2018
--  Modified to increase email param size to 250 chars. TFS 25490 - 10/19/2022
--  Modified to add subcontractor flag. TFS 28080- 05/01/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_Select_Rec_Employee_Hierarchy]
@EmployeeId nvarchar(10)
AS


OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert]


BEGIN

SELECT [Emp_ID]
  	  ,CONVERT(nvarchar(70),DecryptByKey(Emp_Name)) AS [Emp_Name]
      ,CONVERT(nvarchar(250),DecryptByKey(Emp_Email)) AS [Emp_Email]
	  ,CONVERT(nvarchar(30),DecryptByKey(Emp_LanID)) AS [Emp_LanID]
	  ,[isSub] IsSubcontractor
	  ,[Sup_ID]
      ,CONVERT(nvarchar(70),DecryptByKey(Sup_Name)) AS [Sup_Name]
	  ,CONVERT(nvarchar(250),DecryptByKey(Sup_Email)) AS [Sup_Email]
	  ,[Mgr_ID]
	  ,CONVERT(nvarchar(70),DecryptByKey(Mgr_Name)) AS [Mgr_Name]
	  ,CONVERT(nvarchar(250),DecryptByKey(Mgr_Email)) AS [Mgr_Email]
 FROM [EC].[Employee_Hierarchy]
 WHERE [Emp_ID]= @EmployeeId


CLOSE SYMMETRIC KEY [CoachingKey]      
END --sp_Select_Rec_Employee_Hierarchy
GO


