/*
sp_Select_Rec_Employee_Hierarchy(03).sql
Last Modified Date: 05/04/2018
Last Modified By: Susmitha Palacherla

Version 03: Modified during Historical dashboard move to new architecture - TFS 7138 - 05/04/2018

Version 02: Modified during Submissions move to new architecture - TFS 7136 - 04/10/2018

Version 01:  Initial Revision - Created during encryption of secure data. TFF 7856 - 01/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Rec_Employee_Hierarchy' 
)
   DROP PROCEDURE [EC].[sp_Select_Rec_Employee_Hierarchy]
GO


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
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Rec_Employee_Hierarchy]
@EmployeeId nvarchar(10)
AS


OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert]


BEGIN

SELECT [Emp_ID]
  	  ,CONVERT(nvarchar(70),DecryptByKey(Emp_Name)) AS [Emp_Name]
      ,CONVERT(nvarchar(50),DecryptByKey(Emp_Email)) AS [Emp_Email]
	  ,CONVERT(nvarchar(30),DecryptByKey(Emp_LanID)) AS [Emp_LanID]
	  ,[Sup_ID]
      ,CONVERT(nvarchar(70),DecryptByKey(Sup_Name)) AS [Sup_Name]
	  ,CONVERT(nvarchar(50),DecryptByKey(Sup_Email)) AS [Sup_Email]
	  ,[Mgr_ID]
	  ,CONVERT(nvarchar(70),DecryptByKey(Mgr_Name)) AS [Mgr_Name]
	  ,CONVERT(nvarchar(50),DecryptByKey(Mgr_Email)) AS [Mgr_Email]
 FROM [EC].[Employee_Hierarchy]
 WHERE [Emp_ID]= @EmployeeId


CLOSE SYMMETRIC KEY [CoachingKey]      
END --sp_Select_Rec_Employee_Hierarchy


GO



