/*
sp_SelectFrom_Warning_Log_MGRCSRCompleted(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Warning_Log_MGRCSRCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Warning_Log_MGRCSRCompleted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	10/09/2014
--	Description: *	This procedure selects the CSR Warning records from the Warning_Log table
--  Modified per TFS 3598 to add Warning Reason fields and use sp_executesql - 8/15/2016 
--  Modified per TFS 3923 to fix slow running stored procedures in my dashboard - 9/22/2016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Warning_Log_MGRCSRCompleted] 
@strCSRMGRin nvarchar(30),
@strSDatein datetime,
@strEDatein datetime,
@bitActive nvarchar(1)
 
AS

BEGIN
SET NOCOUNT ON

DECLARE	
@nvcSQL nvarchar(max),
@ParmDefinition NVARCHAR(1000),
@strFormStatus nvarchar(30),
@strSDate nvarchar(8),
@strEDate nvarchar(8),
@nvcMgrID Nvarchar(10),
@dtmDate datetime

Set @strFormStatus = 'Completed'
Set @strSDate = convert(varchar(8),@strSDatein,112)
Set @strEDate = convert(varchar(8),@strEDatein,112)
Set @dtmDate  = GETDATE()   
Set @nvcMgrID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)
 

SET @nvcSQL = 'WITH TempMain AS 
(SELECT DISTINCT x.strFormID
				,x.strWarningID
				,x.strCSRName
				,x.strCSRSupName
				,x.strCSRMgrName
				,x.strFormStatus
				,x.strSource
			    ,x.SubmittedDate				  
FROM (SELECT	[wl].[FormName]	strFormID,
        [wl].[WarningID]	strWarningID,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName, 
		[eh].[Mgr_Name]	strCSRMgrName, 
		[s].[Status]	strFormStatus,
		[sc].[SubCoachingSource]	strSource,
		[wl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh join  [EC].[Warning_Log] wl 
ON [wl].[EmpID] = [eh].[Emp_ID] JOIN  [EC].[DIM_Status]s
ON [wl].[StatusID] = [s].[StatusID] JOIN [EC].[DIM_Source]sc
ON [wl].[SourceID] = [sc].[SourceID]
WHERE ([eh].[Mgr_ID] = @nvcMgrIDparam OR [eh].[Sup_ID] = @nvcMgrIDparam)
and [s].[Status] = '''+@strFormStatus+'''
and convert(varchar(8),[wl].[SubmittedDate],112) >= @strSDateinparam
and convert(varchar(8),[wl].[SubmittedDate],112) <= @strEDateinparam
and [wl].[Active] like '''+ CONVERT(NVARCHAR,@bitActive) + '''
and (eh.Mgr_ID <> ''999999''OR eh.Sup_ID <> ''999999'')
GROUP BY [wl].[FormName],[wl].[WarningID],[eh].[Emp_Name],[eh].[Sup_Name] ,
[eh].[Mgr_Name],[S].[Status],[sc].[SubCoachingSource],[wl].[SubmittedDate])X )

SELECT strFormID
		,strCSRName
		,strCSRSupName
		,strCSRMgrName
	   	,strFormStatus
	   	,SubmittedDate
        ,[EC].[fn_strCoachingReasonFromWarningID](strWarningID) strCoachingReason
	    ,[EC].[fn_strSubCoachingReasonFromWarningID](strWarningID)strSubCoachingReason
	     FROM TempMain T              
		 ORDER BY SubmittedDate DESC' 

	
SET @ParmDefinition = N'@nvcMgrIDparam nvarchar(30),@strSDateinparam datetime, @strEDateinparam datetime'	
--EXEC (@nvcSQL)	
--PRINT @nvcSQL

EXECUTE sp_executesql @nvcSQL, @ParmDefinition,
@nvcMgrIDparam = @nvcMgrID,@strSDateinparam = @strSDatein, @strEDateinparam = @strEDatein;
	    
	    
If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
ErrorHandler:
    Return(@@ERROR)
	    
END --sp_SelectFrom_Warning_Log_MGRCSRCompleted


GO

