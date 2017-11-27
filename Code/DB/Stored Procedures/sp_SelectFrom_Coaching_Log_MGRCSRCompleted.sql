/*
sp_SelectFrom_Coaching_Log_MGRCSRCompleted(02).sql
Last Modified Date: 11/27/2017
Last Modified By: Susmitha Palacherla

Version 01: Modified to support additional Modules (show logs where Mgr is sup of log owner) - TFS 8793 - 11/16/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MGRCSRCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MGRCSRCompleted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/2011
--	Description: This procedure selects the completed e-Coaching records 
--  for a given Manager's employees in the Manager Dashboard.
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Lan ID association by date.
-- Modified per TFS 3598 to add Coaching Reason fields and use sp_executesql - 8/15/2016
-- Modified per TFS 3923 to fix slow running stored procedures in my dashboard - 9/22/2016
-- Modified to support additional Modules (show logs where Mgr is sup of log owner) per TFS 8793 - 11/16/2017
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MGRCSRCompleted] 

@strSourcein nvarchar(100),
@strCSRMGRin nvarchar(30),
@strCSRSUPin nvarchar(30),
@strCSRin nvarchar(30),
@strSDatein datetime,
@strEDatein datetime
 
AS

BEGIN

Set NoCount ON

DECLARE	
@nvcSQL nvarchar(max),
@ParmDefinition NVARCHAR(1000),
@strFormStatus nvarchar(30),
@strSDate nvarchar(8),
@strEDate nvarchar(8),
@nvcMGRID Nvarchar(10),
@dtmDate datetime

SET @strFormStatus = 'Completed'
SET @strSDate = convert(varchar(8),@strSDatein,112)
SET @strEDate = convert(varchar(8),@strEDatein,112)
SET @dtmDate  = GETDATE()   
SET @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)

 

SET @nvcSQL = 'WITH TempMain AS 
(SELECT DISTINCT x.strFormID
				,x.strCoachingID
				,x.strCSRName
				,x.strCSRSupName
				,x.strCSRMgrName
				,x.strFormStatus
				,x.strSource
				,x.SubmittedDate				  
FROM (SELECT [cl].[FormName]	strFormID,
        [cl].[CoachingID]	strCoachingID,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName, 
		[eh].[Mgr_Name]	strCSRMgrName, 
		[s].[Status]	strFormStatus,
		[sc].[SubCoachingSource]	strSource,
		[cl].[SubmittedDate]	SubmittedDate
		FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
[cl].[EmpID] = [eh].[Emp_ID]Join [EC].[DIM_Status] s ON
[cl].[StatusID] = [s].[StatusID] JOIN  [EC].[DIM_Source] sc ON
[cl].[SourceID] = [sc].[SourceID] 
where (eh.[Mgr_ID] = @nvcMGRIDparam OR eh.[Sup_ID] = @nvcMGRIDparam)
and [S].[Status] = '''+@strFormStatus+'''
and [sc].[SubCoachingSource] Like @strSourceinparam
and [eh].[Emp_Name] Like @strCSRinparam
and [eh].[Sup_Name] Like  @strCSRSUPinparam
and convert(varchar(8),[cl].[SubmittedDate],112) >= @strSDateinparam
and convert(varchar(8),[cl].[SubmittedDate],112) <= @strEDateinparam
and eh.[Mgr_ID] <> ''999999''
GROUP BY [cl].[FormName],[cl].[CoachingID],[eh].[Emp_Name],[eh].[Sup_Name],
[eh].[Mgr_Name],[S].[Status],[sc].[SubCoachingSource],[cl].[SubmittedDate])X )

SELECT strFormID
		,strCSRName
		,strCSRSupName
		,strCSRMgrName
	   	,strFormStatus
	   	,strSource
	  	,SubmittedDate
	    ,[EC].[fn_strCoachingReasonFromCoachingID](T.strCoachingID) strCoachingReason
	    ,[EC].[fn_strSubCoachingReasonFromCoachingID](T.strCoachingID)strSubCoachingReason
	    ,[EC].[fn_strValueFromCoachingID](T.strCoachingID)strValue	
	     FROM TempMain T              
		 ORDER BY SubmittedDate DESC' 

	
	
SET @ParmDefinition = N'@strSourceinparam nvarchar(100),@nvcMGRIDparam nvarchar(10),@strCSRSUPinparam nvarchar(30),
@strCSRinparam nvarchar(30), @strSDateinparam datetime, @strEDateinparam datetime'	
--EXEC (@nvcSQL)
--PRINT 	@nvcSQL

EXECUTE sp_executesql @nvcSQL, @ParmDefinition,
@strSourceinparam = @strSourcein,@nvcMGRIDparam = @nvcMGRID,@strCSRSUPinparam = @strCSRSUPin,
@strCSRinparam = @strCSRin, @strSDateinparam = @strSDatein, @strEDateinparam = @strEDatein;

	    
If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
ErrorHandler:
    Return(@@ERROR)
	    
END --sp_SelectFrom_Coaching_Log_MGRCSRCompleted




GO


