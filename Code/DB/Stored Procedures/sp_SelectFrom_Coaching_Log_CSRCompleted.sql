/*
sp_SelectFrom_Coaching_Log_CSRCompleted(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_CSRCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_CSRCompleted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
-- Author:			Susmitha Palacherla
-- Create Date:	11/16/11
-- Description: Displays an Employee's Completed logs in the My Dashboard.
-- Last Modified Date: 04/16/2015
-- Last Updated By: Susmitha Palacherla
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Lan ID association by date.
-- Modified per TFS 3598 to add Coaching Reason fields and use sp_executesql - 8/15/2016
-- Modified per TFS 3923 to fix slow running stored procedures in my dashboard - 9/22/2016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_CSRCompleted] @strCSRin nvarchar(30)
AS


BEGIN

SET NOCOUNT ON

DECLARE	
@nvcSQL nvarchar(max),
@ParmDefinition NVARCHAR(1000),
@strFormStatus nvarchar(30),
@nvcEmpID Nvarchar(10),
@dtmDate datetime

 SET @dtmDate  = GETDATE()   
 SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@strCSRin,@dtmDate)
 SET @strFormStatus = 'Completed'

SET @nvcSQL = 'WITH TempMain AS 
(SELECT DISTINCT x.strFormID
				,x.strCoachingID
				,x.strCSRName
				,x.strCSRSupName
				,x.strCSRMgrName
				,x.strFormStatus
			    ,x.SubmittedDate				  
FROM (SELECT [cl].[FormName]	strFormID,
        [cl].[CoachingID]	strCoachingID,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name] strCSRSupName, 
		[eh].[Mgr_Name]	strCSRMgrName, 
		[s].[Status]	strFormStatus,
		[cl].[SubmittedDate]	SubmittedDate
		FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] s ON 
cl.StatusID = s.StatusID
where cl.EmpID = @nvcEmpIDparam 
and [S].[Status] = '''+@strFormStatus+'''
and  cl.EmpID <> ''999999''
GROUP BY [cl].[FormName],[cl].[CoachingID],[eh].[Emp_Name],[eh].[Sup_Name] ,
[eh].[Mgr_Name],[S].[Status],[cl].[SubmittedDate])X )

SELECT strFormID
		,strCSRName
		,strCSRSupName
		,strCSRMgrName
	   	,strFormStatus
	   	,SubmittedDate
	    ,[EC].[fn_strCoachingReasonFromCoachingID](T.strCoachingID) strCoachingReason
	    ,[EC].[fn_strSubCoachingReasonFromCoachingID](T.strCoachingID)strSubCoachingReason
	    ,[EC].[fn_strValueFromCoachingID](T.strCoachingID)strValue	
	     FROM TempMain T              
		 ORDER BY SubmittedDate DESC' 


		
SET @ParmDefinition = N'@nvcEmpIDparam  nvarchar(10)'
		
--EXEC (@nvcSQL)	

EXECUTE sp_executesql @nvcSQL, @ParmDefinition,
                     @nvcEmpIDparam = @nvcEmpID;
	    

If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
ErrorHandler:
    Return(@@ERROR)
	    
END --sp_SelectFrom_Coaching_Log_CSRCompleted


GO

