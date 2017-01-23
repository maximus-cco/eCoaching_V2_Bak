/*
sp_AT_Select_Logs_Inactivation_Reactivation(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



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
--	=====================================================================
CREATE PROCEDURE [EC].[sp_AT_Select_Logs_Inactivation_Reactivation] 

@strTypein nvarchar(10)= NULL, @strActionin nvarchar(10), @strEmployeein nvarchar(10),  @intModuleIdin INT
AS

BEGIN
DECLARE	
@nvcTableName nvarchar(500),
@nvcWhere nvarchar(100),
@nvcSQL nvarchar(max),
@strID nvarchar(30)


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


IF @strActionin = N'Reactivate'
SET @nvcWhere = ' WHERE Fact.StatusID = 2 '
ELSE 
IF @strTypein = N'Coaching' AND @strActionin = 'Inactivate'
SET @nvcWhere = ' WHERE Fact.StatusID NOT IN (1,2) '
ELSE
IF @strTypein = N'Warning' AND @strActionin = 'Inactivate'
SET @nvcWhere = ' WHERE Fact.StatusID <> 2 '



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

