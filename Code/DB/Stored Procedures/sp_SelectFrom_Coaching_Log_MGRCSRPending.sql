/*
sp_SelectFrom_Coaching_Log_MGRCSRPending(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MGRCSRPending' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MGRCSRPending]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/2011
--	Description: This procedure selects the Pendingd e-Coaching records 
--  for a given Manager's employees in the Manager Dashboard.
--  Last Updated By: Susmitha Palacherla
--  Revision History:
--  Modified per scr 14422 - dashboard redesign - 04/16/2015
--  1. To Replace old style joins.
--  2. Lan ID association by date.
--  Modified per TFS 1709 - Admin tool setup to add non hierarchy sups - 5/4/2016
-- Modified per TFS 3598 to add Coaching Reason fields and use sp_executesql - 8/15/2016
-- Modified per TFS 3923 to fix slow running stored procedures in my dashboard - 9/22/2016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MGRCSRPending] 

@strCSRMGRin nvarchar(30),
@strCSRSUPin nvarchar(30),
@strSourcein nvarchar(100),
@strCSRin nvarchar(30) 

AS

BEGIN

Set NoCount ON

DECLARE	
@nvcSQL nvarchar(max),
@ParmDefinition NVARCHAR(1000),
@nvcMGRID Nvarchar(10),
@dtmDate datetime


SET @dtmDate  = GETDATE()   
SET @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)

SET @nvcSQL = N'SELECT [cl].[FormName]	strFormID,
		[eh].[Emp_Name]	strCSRName,
	    CASE 
	     WHEN (cl.[statusId]in (6,8) AND cl.[ModuleID] in (1,3,4,5) AND cl.[ReassignedToID]is NOT NULL and [ReassignCount]<> 0)
		 THEN [EC].[fn_strEmpNameFromEmpID](cl.[ReassignedToID])
		 WHEN (cl.[statusId]= 5 AND cl.[ModuleID] = 2 AND cl.[ReassignedToID]is NOT NULL and [ReassignCount]<> 0)
		 THEN [EC].[fn_strEmpNameFromEmpID](cl.[ReassignedToID])
		 ELSE [eh].[Sup_Name]
	END  strCSRSupName,	
		[eh].[Mgr_Name]	strCSRMgrName, 
		[s].[Status]	strFormStatus,
		[sc].[SubCoachingSource] strSource,
		[cl].[SubmittedDate]	SubmittedDate,
	    [EC].[fn_strCoachingReasonFromCoachingID]([cl].[CoachingID]) strCoachingReason,
	    [EC].[fn_strSubCoachingReasonFromCoachingID]([cl].[CoachingID])strSubCoachingReason,
	    [EC].[fn_strValueFromCoachingID]([cl].[CoachingID])strValue
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
[cl].[EmpID] = [eh].[Emp_ID] Join [EC].[DIM_Status] s ON
[cl].[StatusID] = [s].[StatusID] JOIN  [EC].[DIM_Source] sc ON
[cl].[SourceID] = [sc].[SourceID] 
where (eh.[Mgr_ID] = @nvcMGRIDparam OR 
(cl.[ReassignedToID] IN 
(SELECT DISTINCT Emp_ID FROM EC.Employee_Hierarchy 
WHERE Sup_ID = @nvcMGRIDparam)))
and [eh].[Emp_Name] Like @strCSRinparam
and [eh].[Sup_Name] Like @strCSRSUPinparam
and [S].[Status] like ''Pending%''
and [sc].[SubCoachingSource] Like @strSourceinparam
and @nvcMGRIDparam <> ''999999''
Order By [SubmittedDate] DESC'

	
SET @ParmDefinition = N'@nvcMGRIDparam nvarchar(10),@strCSRSUPinparam nvarchar(30),
@strSourceinparam nvarchar(100),@strCSRinparam nvarchar(30)'
--EXEC (@nvcSQL)
--PRINT 	@nvcSQL

EXECUTE sp_executesql @nvcSQL, @ParmDefinition,
@nvcMGRIDparam = @nvcMGRID,@strCSRSUPinparam = @strCSRSUPin,
@strSourceinparam = @strSourcein,@strCSRinparam = @strCSRin;

	    
If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
ErrorHandler:
    Return(@@ERROR)
	    
END --sp_SelectFrom_Coaching_Log_MGRCSRPending



GO

