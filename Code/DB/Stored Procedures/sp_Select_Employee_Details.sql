/*
sp_Select_Employee_Details(01).sql
Last Modified Date: 04/10/2018
Last Modified By: Susmitha Palacherla


Version 01: Initial Revision. Created during Submissions move to new architecture - TFS 7136 - 04/10/2018 

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Employee_Details' 
)
   DROP PROCEDURE [EC].[sp_Select_Employee_Details]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	04/15/2018
--	Description: *	This procedure takes an Employee Lan ID and returns the Employee details.
--      Initial Revision. Created during Submissions move to new architecture - TFS 7136 - 04/10/2018 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Employee_Details] 
@nvcEmpLanin nvarchar(30)

AS
BEGIN
	DECLARE	
	@nvcEmpID Nvarchar(10),
    @dtmDate datetime,
	@nvcSQL nvarchar(max)
	

OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert] 
SET @dtmDate  = GETDATE()   
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@nvcEmpLanin,@dtmDate)



SET @nvcSQL = 'SELECT EH.[Emp_ID]
                ,VEH.[Emp_Name] 
	            ,VEH.[Sup_Name]
				,VEH.[Mgr_Name]
				,EH.[Emp_Site] 
 FROM [EC].[View_Employee_Hierarchy] VEH  WITH (NOLOCK)  JOIN  [EC].[Employee_Hierarchy]EH WITH (NOLOCK) 
 ON VEH.[Emp_ID]= EH.[Emp_ID] 
 WHERE EH.[Emp_ID] = '''+@nvcEmpID+ ''''

--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_Employee_Details


GO



