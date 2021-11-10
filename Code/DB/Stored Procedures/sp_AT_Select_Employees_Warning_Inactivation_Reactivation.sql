
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Select_Employees_Warning_Inactivation_Reactivation' 
)
   DROP PROCEDURE [EC].[sp_AT_Select_Employees_Warning_Inactivation_Reactivation]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/21/2016
--	Description: *	This procedure returns the list of Employees who have 
--  Warning logs for Inactivation or Reactivation.
--  Last Modified By: 
--  Last Modified date: 
--  Revision History:
--  Initial Revision. Admin tool setup, TFS 1709- 4/20/12016
--  Updated to add Employees in Leave status for Inactivation, TFS 3441 - 09/07/2016
--  Modified to support Encryption of sensitive data (Open key and use employee View for emp attributes. TFS 7856 - 10/23/2017
--  Modified to support additional statuses for warnings. TFS 17102 - 5/1/2020 
--  Modified to allow lastknownstatus 4 warning log to be reactivated. TFS TFS 23378 - 11/9/2021
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_AT_Select_Employees_Warning_Inactivation_Reactivation] 

@strRequesterLanId nvarchar(30),@strActionin nvarchar(10), @intModulein int
AS

BEGIN
DECLARE	
@nvcTableName nvarchar(20),
@nvcWhere nvarchar(50),
@strRequesterID nvarchar(10),
@strRequesterSiteID int,
@dtmDate datetime,
@nvcSQL nvarchar(max)

OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert]


SET @dtmDate  = GETDATE()   
SET @strRequesterID = EC.fn_nvcGetEmpIdFromLanID(@strRequesterLanId,@dtmDate)



IF @strActionin = N'Inactivate'

SET @nvcSQL = 'SELECT DISTINCT Emp.Emp_ID,VEH.Emp_Name 
 FROM [EC].[Employee_Hierarchy] Emp JOIN [EC].[View_Employee_Hierarchy] VEH 
 ON VEH.Emp_ID = Emp.Emp_ID JOIN [EC].[Warning_Log] Fact WITH(NOLOCK)
 ON Emp.Emp_ID = Fact.EmpID  
 WHERE Fact.StatusID <> 2
 AND Fact.ModuleId = '''+CONVERT(NVARCHAR,@intModulein)+'''
 AND Fact.EmpID <> ''999999''
 AND Emp.Active NOT IN  (''T'',''D'')
 AND [EC].[fn_strEmpLanIDFromEmpID](Fact.EmpID) <> '''+@strRequesterLanId+''' 
 ORDER BY VEH.Emp_Name '

ELSE 

SET @nvcSQL = 'SELECT DISTINCT Emp.Emp_ID,VEH.Emp_Name  
 FROM [EC].[Employee_Hierarchy]Emp JOIN [EC].[View_Employee_Hierarchy] VEH 
 ON VEH.Emp_ID = Emp.Emp_ID JOIN [EC].[Warning_Log] Fact WITH(NOLOCK)
 ON Emp.Emp_ID = Fact.EmpID JOIN (Select * FROM
 [EC].[AT_Warning_Inactivate_Reactivate_Audit]
 WHERE LastKnownStatus in (1,4)) Aud
 ON Aud.FormName = Fact.Formname
 WHERE Fact.StatusID = 2
 AND Fact.ModuleId = '''+CONVERT(NVARCHAR,@intModulein)+'''
 AND Fact.EmpID <> ''999999''
  AND Emp.Active = ''A''
 AND [EC].[fn_strEmpLanIDFromEmpID](Fact.EmpID) <> '''+@strRequesterLanId+''' 
 ORDER BY VEH.Emp_Name '
 
--Print @nvcSQL

EXEC (@nvcSQL)	
CLOSE SYMMETRIC KEY [CoachingKey]  
END --sp_AT_Select_Employees_Warning_Inactivation_Reactivation

GO


