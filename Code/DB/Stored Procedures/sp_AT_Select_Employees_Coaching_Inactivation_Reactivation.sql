/*
sp_AT_Select_Employees_Coaching_Inactivation_Reactivation(02).sql
Last Modified Date: 6/30/2017
Last Modified By: Susmitha Palacherla

Version 02: Allow for Inactivation of completed logs from admin tool - TFS 5223 - 6/30/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/

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
--	=====================================================================
CREATE PROCEDURE [EC].[sp_AT_Select_Employees_Coaching_Inactivation_Reactivation] 

@strRequesterLanId nvarchar(30),@strActionin nvarchar(10), @intModulein int
AS

BEGIN
DECLARE	
@nvcTableName nvarchar(20),
@nvcWhere nvarchar(50),
@strRequesterID nvarchar(10),
@intRequesterSiteID int,
@strConditionalSite nvarchar(100),
@strATCoachAdminUser nvarchar(10),
@dtmDate datetime,
@nvcSQL nvarchar(max)

SET @dtmDate  = GETDATE()   
SET @strRequesterID = EC.fn_nvcGetEmpIdFromLanID(@strRequesterLanId,@dtmDate)
SET @intRequesterSiteID = EC.fn_intSiteIDFromEmpID(@strRequesterID)
SET @strATCoachAdminUser = EC.fn_strCheckIfATCoachingAdmin(@strRequesterID) 

SET @strConditionalSite = ' '
IF @strATCoachAdminUser <> 'YES'

BEGIN
	SET @strConditionalSite = ' AND Fact.SiteID = '''+CONVERT(NVARCHAR,@intRequesterSiteID)+''' '
END	

IF @strActionin = N'Inactivate'

SET @nvcSQL = 'SELECT DISTINCT Emp.Emp_ID,Emp.Emp_Name 
 FROM [EC].[Employee_Hierarchy] Emp JOIN [EC].[Coaching_Log] Fact WITH(NOLOCK)
 ON Emp.Emp_ID = Fact.EmpID  
 WHERE Fact.StatusID <> 2
 AND Fact.ModuleId = '''+CONVERT(NVARCHAR,@intModulein)+'''
 AND Fact.EmpID <> ''999999''
 AND Emp.Active NOT IN  (''T'',''D'')'
 + @strConditionalSite 
 + ' AND Fact.EmpLanID <> '''+@strRequesterLanId+''' 
 ORDER BY Emp.Emp_Name'

ELSE 

SET @nvcSQL = 'SELECT DISTINCT Emp.Emp_ID,Emp.Emp_Name 
 FROM [EC].[Employee_Hierarchy]Emp JOIN [EC].[Coaching_Log] Fact WITH(NOLOCK)
 ON Emp.Emp_ID = Fact.EmpID JOIN (Select * FROM
 [EC].[AT_Coaching_Inactivate_Reactivate_Audit]
 WHERE LastKnownStatus <> 2) Aud
 ON Aud.FormName = Fact.Formname
 WHERE Fact.StatusID = 2
 AND Fact.ModuleId = '''+CONVERT(NVARCHAR,@intModulein)+'''
 AND Fact.EmpID <> ''999999''
 AND Emp.Active = ''A''
 AND Fact.EmpLanID <> '''+@strRequesterLanId+''' 
 ORDER BY Emp.Emp_Name'
 
--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_AT_Select_Employees_Coaching_Inactivation_Reactivation
GO


