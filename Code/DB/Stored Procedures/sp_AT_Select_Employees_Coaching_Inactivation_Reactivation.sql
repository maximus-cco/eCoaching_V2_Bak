
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Select_Employees_Coaching_Inactivation_Reactivation' 
)
   DROP PROCEDURE [EC].[sp_AT_Select_Employees_Coaching_Inactivation_Reactivation]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/21/2016
--	Description: *	This procedure returns the list of Employees who have 
--  Coaching logs for Inactivation or Reactivation.
--  Last Modified By: Susmitha Palacherla
--  Revision History:
--  Initial Revision. Admin tool setup, TFS 1709- 4/20/12016
--  Updated to remove Mgr site restriction for non admins, TFS 3091 - 07/05/2016
--  Updated to add Employees in Leave status for Inactivation, TFS 3441 - 09/07/2016
--  Updated to allow for Inactivation of completed logs from admin tool - TFS 7152 - 06/30/2017
--  Modified to support Encryption of sensitive data (Open keys and use employee View for emp attributes. TFS 7856 - 10/23/2017
--  Modified to support cross site access for Virtual East Managers. TFS 23378 - 10/29/2021 
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_AT_Select_Employees_Coaching_Inactivation_Reactivation] 

@strRequesterLanId nvarchar(30),@strActionin nvarchar(10), @intModulein int
AS

BEGIN
DECLARE	
@nvcTableName nvarchar(20),
@nvcWhere nvarchar(50),
@strRequesterID nvarchar(10),
@intRequesterSiteID int,
@strATCoachAdminUser nvarchar(10),
@dtmDate datetime,
@nvcSQL nvarchar(max)

OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert]


SET @dtmDate  = GETDATE()   
SET @strRequesterID = EC.fn_nvcGetEmpIdFromLanID(@strRequesterLanId,@dtmDate)
SET @intRequesterSiteID = EC.fn_intSiteIDFromEmpID(@strRequesterID)
SET @strATCoachAdminUser = EC.fn_strCheckIfATCoachingAdmin(@strRequesterID) 

-- If Action is Inactivation

IF @strActionin = N'Inactivate' 
   BEGIN
	  IF @strATCoachAdminUser = 'YES'
	  
--Special conditions for Coaching Admins 
--Display Users with Completed logs submitted in the last 3 months
--No site Restriction

         BEGIN
			 SET @nvcSQL = 'SELECT DISTINCT Emp.Emp_ID,VEH.Emp_Name 
			 FROM [EC].[Employee_Hierarchy] Emp JOIN [EC].[Coaching_Log] Fact WITH(NOLOCK)
			 ON Emp.Emp_ID = Fact.EmpID  JOIN [EC].[View_Employee_Hierarchy] VEH 
			 ON VEH.Emp_ID = Emp.Emp_ID
			 WHERE (Fact.StatusID not in (1,2) 
			 OR (Fact.StatusID = 1 AND Fact.SubmittedDate > DATEADD(MM,-3, GETDATE())))
			 AND Fact.ModuleId = '''+CONVERT(NVARCHAR,@intModulein)+'''
			 AND Fact.EmpID <> ''999999''
			 AND Emp.Active NOT IN  (''T'',''D'')
			 AND Fact.EmpID <> '''+@strRequesterId+''' 
			 ORDER BY VEH.Emp_Name'
      END
      
         ELSE
         
  --For Non Coaching Admins(Regular users like supervisors and Managers)
  --Do not display usesr with completed logs
  --Display only users with Coaching logs at the same site as the logged in user
       
       BEGIN
			 SET @nvcSQL = 'SELECT DISTINCT Emp.Emp_ID,VEH.Emp_Name 
			 FROM [EC].[Employee_Hierarchy] Emp JOIN [EC].[Coaching_Log] Fact WITH(NOLOCK)
			 ON Emp.Emp_ID = Fact.EmpID  JOIN [EC].[View_Employee_Hierarchy] VEH 
			 ON VEH.Emp_ID = Emp.Emp_ID
			 WHERE Fact.StatusID NOT IN (1,2)
			 AND Fact.ModuleId = '''+CONVERT(NVARCHAR,@intModulein)+'''
			 AND Fact.EmpID <> ''999999''
			 AND Emp.Active NOT IN  (''T'',''D'')
			  AND 
			 (Fact.SiteID = '''+CONVERT(NVARCHAR,@intRequesterSiteID)+'''
		      OR
			 (Emp.Sup_ID =  '''+@strRequesterId+'''  OR Emp.Mgr_ID = '''+@strRequesterId+''' ))
			 AND Fact.EmpID <> '''+@strRequesterId+''' 
			 ORDER BY VEH.Emp_Name'
	 END 
END

ELSE 


-- If Action is Reactivation

     BEGIN
		SET @nvcSQL = 'SELECT DISTINCT Emp.Emp_ID,VEH.Emp_Name 
			 FROM [EC].[Employee_Hierarchy] Emp JOIN [EC].[Coaching_Log] Fact WITH(NOLOCK)
			 ON Emp.Emp_ID = Fact.EmpID  JOIN [EC].[View_Employee_Hierarchy] VEH 
			 ON VEH.Emp_ID = Emp.Emp_ID JOIN (Select * FROM
		 [EC].[AT_Coaching_Inactivate_Reactivate_Audit]
		 WHERE LastKnownStatus <> 2) Aud
		 ON Aud.FormName = Fact.Formname
		 WHERE Fact.StatusID = 2
		 AND Fact.ModuleId = '''+CONVERT(NVARCHAR,@intModulein)+'''
		 AND Fact.EmpID <> ''999999''
		 AND Emp.Active = ''A''
		 AND [EC].[fn_strEmpLanIDFromEmpID](Fact.EmpID) <> '''+@strRequesterLanId+''' 
		 ORDER BY VEH.Emp_Name'
    END
    
Print @nvcSQL

EXEC (@nvcSQL)	
CLOSE SYMMETRIC KEY [CoachingKey]  
END --sp_AT_Select_Employees_Coaching_Inactivation_Reactivation

GO


