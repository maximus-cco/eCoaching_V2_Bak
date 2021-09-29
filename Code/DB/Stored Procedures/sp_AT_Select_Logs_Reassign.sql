
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Select_Logs_Reassign' 
)
   DROP PROCEDURE [EC].[sp_AT_Select_Logs_Reassign]
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
--  Revision History:
--  Initial Revision. Admin tool setup, TFS 1709- 4/27/12016
--  Updated to add Employees in Leave status for Reassignment per TFS 3441 - 09/07/2016
--  Modified to support Encryption of sensitive data (Open key and use employee View for emp attributes. TFS 7856 - 10/23/2017
--  Updated to incorporate a follow-up process for eCoaching submissions - TFS 13644 -  08/28/2019
-- Modified during changes to QN Workflow. TFS 22187 - 09/20/2021
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_AT_Select_Logs_Reassign] 
@istrOwnerin nvarchar(10), @intStatusIdin INT, @intModuleIdin INT
AS

BEGIN
DECLARE	
@strConditionalWhere nvarchar(100),
@nvcSQL nvarchar(max)

OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert]


IF ((@intStatusIdin IN (6,8,10,11,12) AND @intModuleIdin IN (1,3,4,5))
OR (@intStatusIdin = 5 AND @intModuleIdin = 2))

BEGIN
SET @strConditionalWhere = ' WHERE EH.Sup_ID = '''+@istrOwnerin+''' '
END

ELSE IF 
((@intStatusIdin = 5 AND @intModuleIdin IN (1,3,4,5))
OR (@intStatusIdin = 7 AND @intModuleIdin = 2))

BEGIN
SET @strConditionalWhere = ' WHERE EH.Mgr_ID = '''+@istrOwnerin+''' '
END

-- Check for 3 scenarios
--1. Original hierarchy owner
--2. Reassigned owner
--3. Review owner for LCS

SET @nvcSQL = 'SELECT cfact.CoachingID,  
        cfact.FormName strFormName,
		veh.Emp_Name	strEmpName,
		veh.Sup_Name	strSupName,
	    CASE
		 WHEN cfact.[strReportCode] like ''LCS%'' AND cfact.[MgrID] <> eh.[Mgr_ID]
		 THEN [EC].[fn_strEmpNameFromEmpID](cfact.[MgrID])+ '' (Assigned Reviewer)''
		 ELSE veh.Mgr_Name END strMgrName,
		 sh.Emp_Name strSubmitter,
		s.Status,
		cfact.SubmittedDate strCreatedDate 
     FROM [EC].[Coaching_Log]cfact WITH(NOLOCK) JOIN 
     
     (SELECT fact.CoachingID
     FROM [EC].[Coaching_Log]fact WITH(NOLOCK) JOIN [EC].[Employee_Hierarchy] eh
	 ON [Fact].[EMPID] = [eh].[Emp_ID]
	 AND NOT(fact.statusid = 5 AND ISNULL(fact.strReportCode,'' '') LIKE ''LCS%'')'
	 + @strConditionalWhere +
	 'AND fact.ReassignCount = 0
	
	
     UNION
     
     SELECT fact.CoachingID 
     FROM [EC].[Coaching_Log]fact WITH(NOLOCK) JOIN [EC].[Employee_Hierarchy] rm
	 ON [Fact].[ReassignedToID] = [rm].[Emp_ID]
	 WHERE rm.Emp_ID = '''+@istrOwnerin+''' 
	 AND (fact.ReassignCount < 2 and fact.ReassignCount <> 0)
	 AND fact.ReassignedToID is not NULL
	 
	 
     UNION
     
     SELECT fact.CoachingID 
     FROM [EC].[Coaching_Log]fact WITH(NOLOCK) JOIN [EC].[Employee_Hierarchy] rm
	 ON [Fact].[MgrID] = [rm].[Emp_ID]
	 WHERE rm.Emp_ID = '''+@istrOwnerin+''' 
	 AND fact.strReportCode like ''LCS%''
	 AND fact.ReassignCount = 0
	 )Selected 
	 
	 ON Selected.CoachingID = cfact.CoachingID JOIN [EC].[Employee_Hierarchy] eh
	 ON [cfact].[EMPID] = [eh].[Emp_ID] JOIN [EC].[View_Employee_Hierarchy] veh
     ON VEH.Emp_ID = Eh.Emp_ID JOIN [EC].[View_Employee_Hierarchy] sh
	 ON [cfact].[SubmitterID] = [sh].[Emp_ID]JOIN [EC].[DIM_Status] s
	 ON [cfact].[StatusID] = [s].[StatusID]
	 
	WHERE cfact.StatusId = '''+CONVERT(NVARCHAR,@intStatusIdin)+'''
	AND cfact.Moduleid = '''+CONVERT(NVARCHAR,@intModuleIdin)+'''
  	AND eh.Active NOT IN  (''T'',''D'') 
   ORDER BY cfact.FormName DESC'
   
--Print @nvcSQL

EXEC (@nvcSQL)	
CLOSE SYMMETRIC KEY [CoachingKey]  
END --sp_AT_Select_Logs_Reassign
GO


