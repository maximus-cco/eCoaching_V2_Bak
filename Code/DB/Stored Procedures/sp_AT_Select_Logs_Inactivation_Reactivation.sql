/*
sp_AT_Select_Logs_Inactivation_Reactivation(02).sql
Last Modified Date: 7/7/2017
Last Modified By: Susmitha Palacherla

Version 03: additional chnanges per requirements update.
Allow for Inactivation of completed logs from admin tool - TFS 7152 -  7/7/2017

Version 02: Allow for Inactivation of completed logs from admin tool - TFS 7152 - 6/30/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Select_Logs_Inactivation_Reactivation' 
)
   DROP PROCEDURE [EC].[sp_AT_Select_Logs_Inactivation_Reactivation]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/21/2016
--	Description: *	This procedure returns the list of Coaching or Warning logs 
--  in the appropriate Status for the Action for the selected Employee.
--  Last Modified By: 
--  Last Modified date: 
--  Revision History:
--  Initial Revision. Admin tool setup, TFS 1709- 4/2/12016
--  Updated to allow for Inactivation of completed logs from admin tool - TFS 7152 - 06/30/2017
--	=====================================================================
CREATE PROCEDURE [EC].[sp_AT_Select_Logs_Inactivation_Reactivation] 

@strRequesterLanId nvarchar(30),@strTypein nvarchar(10)= NULL, @strActionin nvarchar(10), @strEmployeein nvarchar(10),  @intModuleIdin INT
AS

BEGIN
DECLARE	
@nvcTableName nvarchar(500),
@nvcWhere nvarchar(200),
@strRequesterID nvarchar(10),
@strATCoachAdminUser nvarchar(10),
@dtmDate datetime,
@nvcSQL nvarchar(max),
@strID nvarchar(30)

SET @dtmDate  = GETDATE()   
SET @strRequesterID = EC.fn_nvcGetEmpIdFromLanID(@strRequesterLanId,@dtmDate)
SET @strATCoachAdminUser = EC.fn_strCheckIfATCoachingAdmin(@strRequesterID) 

IF @strTypein = N'Coaching' 
SET @strID = 'Fact.CoachingID LogID, '
ELSE 
SET @strID = 'Fact.WarningID LogID, '

IF @strTypein = N'Coaching' AND @strActionin = 'Inactivate'
SET @nvcTableName = ' FROM [EC].[Coaching_Log] Fact WITH(NOLOCK) '

IF @strTypein = N'Warning' AND @strActionin = 'Inactivate'
SET @nvcTableName = ' FROM [EC].[Warning_Log] Fact WITH(NOLOCK) '

IF @strTypein = N'Coaching' AND @strActionin = 'Reactivate'
SET @nvcTableName = ',Aud.LastKnownStatus, [EC].[fn_strStatusFromStatusID](Aud.LastKnownStatus)LKStatus
 FROM [EC].[Coaching_Log] Fact WITH(NOLOCK) JOIN (Select * FROM
 [EC].[AT_Coaching_Inactivate_Reactivate_Audit] WHERE LastKnownStatus <> 2) Aud
 ON Aud.FormName = Fact.Formname '

IF @strTypein = N'Warning' AND @strActionin = 'Reactivate'
SET @nvcTableName = ',Aud.LastKnownStatus, [EC].[fn_strStatusFromStatusID](Aud.LastKnownStatus)LKStatus 
 FROM [EC].[Warning_Log] Fact WITH(NOLOCK) JOIN (Select * FROM
 [EC].[AT_Warning_Inactivate_Reactivate_Audit] WHERE LastKnownStatus <> 2) Aud
 ON Aud.FormName = Fact.Formname '


IF @strActionin = N'Inactivate' 
   BEGIN
	  IF @strATCoachAdminUser = 'YES'

--Special conditions for Coaching Admins 
--Display  Completed logs submitted in the last 3 months

         BEGIN
			 SET @nvcWhere = ' WHERE (Fact.StatusID not in (1,2) 
			 OR (Fact.StatusID = 1 AND Fact.SubmittedDate > DATEADD(MM,-3, GETDATE()))) '
         END
      
         ELSE
         
  --For Non Coaching Admins(Regular users like Supervisors and Managers)
  --Do not display  completed logs
       
       BEGIN
			 SET @nvcWhere = ' WHERE Fact.StatusID not in (1,2)  '
	   END 
  END

ELSE 

-- If Action is Reactivation

     BEGIN
		SET @nvcWhere = ' WHERE Fact.StatusID = 2 '
     END


 SET @nvcSQL = 'SELECT DISTINCT '+@strID+' 
        fact.FormName strFormName,
		eh.Emp_Name	strEmpName,
		eh.Sup_Name	strSupName,
	    CASE
		 WHEN  fact.[strReportCode] like ''LCS%'' AND fact.[MgrID] <> eh.[Mgr_ID]
		 THEN [EC].[fn_strEmpNameFromEmpID](fact.[MgrID])+ '' (Assigned Reviewer)''
		 ELSE eh.Mgr_Name END strMgrName,
		sh.Emp_Name strSubmitter,
		s.Status,
		Fact.SubmittedDate strCreatedDate '
  +  @nvcTableName +
 'JOIN [EC].[Employee_Hierarchy] eh
	 ON [Fact].[EMPID] = [eh].[Emp_ID] JOIN [EC].[Employee_Hierarchy] sh
	 ON [Fact].[SubmitterID] = [sh].[Emp_ID] JOIN [EC].[DIM_Status] s
	 ON [Fact].[StatusID] = [s].[StatusID] '+
 @nvcWhere +
 'AND EmpID = '''+@strEmployeein+'''
  AND [Fact].[ModuleId] = '''+CONVERT(NVARCHAR,@intModuleIdin)+'''
  ORDER BY Fact.FormName DESC'


--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_AT_Select_Logs_Inactivation_Reactivation





GO


