/*
sp_Select_Employee_Details(02).sql
Last Modified Date: 05/16/2018
Last Modified By: Susmitha Palacherla

Version 02; Updated during MySubmission move to new architecture - TFS 7137 - 05/16/2018 
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
--	Create Date:	04/10/2018 
--	Description: *	This procedure takes an Employee Lan ID and returns the Employee details.
--  Initial Revision. Created during Submissions move to new architecture - TFS 7136 - 04/10/2018 
--  Updated during My Dashboard move to new architecture - TFS 7137 - 05/16/2018 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Employee_Details] 
@nvcEmpLanin nvarchar(30)

AS
BEGIN
	DECLARE	
	@nvcEmpID nvarchar(10),
	@nvcEmpRole nvarchar(40),
    @dtmDate datetime,
	@nvcSQL nvarchar(max);
	

OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert] 
SET @dtmDate  = GETDATE()   
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@nvcEmpLanin,@dtmDate)
SET @nvcEmpRole = [EC].[fn_strGetUserRole](@nvcEmpID)


SET @nvcSQL = ';WITH UserRole (Emp_ID, Role)
 AS 
(SELECT EH.[Emp_ID], [EC].[fn_strGetUserRole](EH.[Emp_ID])
FROM EC.Employee_Hierarchy EH WITH (NOLOCK) 
WHERE EH.[Emp_ID] = '''+@nvcEmpID+ ''')
SELECT EH.[Emp_ID]
                ,VEH.[Emp_Name] 
	            ,VEH.[Sup_Name]
				,VEH.[Mgr_Name]
				,EH.[Emp_Site] 
				,EH.[Emp_Job_Code] 
			    ,UR.[Role]
				,RA.[NewSubmission]
				,RA.[MyDashboard]
				,RA.[HistoricalDashboard]
				,[EC].[fn_strCheckIf_ExcelExport](EH.[Emp_ID],UR.[Role]) ExcelExport
				,[EC].[fn_strCheckIf_ACLRole](EH.[Emp_ID], ''ECL'') ECLUser
 FROM [EC].[View_Employee_Hierarchy] VEH  WITH (NOLOCK)  JOIN  [EC].[Employee_Hierarchy]EH WITH (NOLOCK) 
 ON VEH.[Emp_ID]= EH.[Emp_ID] JOIN UserRole UR
 ON EH.[Emp_ID] = UR.[Emp_ID] JOIN [EC].[UI_Role_Page_Access] RA
 ON RA.RoleName = UR.Role
 WHERE EH.[Emp_ID] = '''+@nvcEmpID+ ''''

--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_Employee_Details



GO



