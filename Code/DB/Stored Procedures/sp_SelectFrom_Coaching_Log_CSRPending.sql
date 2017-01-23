/*
sp_SelectFrom_Coaching_Log_CSRPending(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_CSRPending' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_CSRPending]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/2011
--  Description: Displays an Employees Pending logs in the My Dashboard.
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Lan ID association by date.
-- Modified per TFS 3598 to add Coaching Reason fields and use sp_executesql - 8/15/2016
-- Modified per TFS 3923 to fix slow running stored procedures in my dashboard - 9/22/2016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_CSRPending] @strCSRin nvarchar(30)
AS

BEGIN

SET NOCOUNT ON

DECLARE	
@nvcSQL nvarchar(max),
@ParmDefinition NVARCHAR(1000),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30),
@nvcEmpID Nvarchar(10),
@dtmDate datetime

 SET @dtmDate  = GETDATE()   
 SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@strCSRin,@dtmDate)
 SET @strFormStatus = 'Pending Employee Review'
 SET @strFormStatus2 = 'Pending Acknowledgement'

SET @nvcSQL = 'WITH TempMain AS 
(SELECT DISTINCT x.strFormID
				,x.strCoachingID
				,x.strCSRName
				,x.strFormStatus
			    ,x.SubmittedDate				  
FROM (SELECT [cl].[FormName]	strFormID,
        [cl].[CoachingID]	strCoachingID,
		[eh].[Emp_Name]	strCSRName,
		[s].[Status]	strFormStatus,
		[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] s ON 
cl.StatusID = s.StatusID
where  cl.EmpID = @nvcEmpIDparam 
and ([S].[Status] = '''+@strFormStatus+''' or [S].[Status] = '''+@strFormStatus2+''')
and cl.EmpID <> ''999999''
GROUP BY [cl].[FormName],[cl].[CoachingID],[eh].[Emp_Name],
[S].[Status],[cl].[SubmittedDate])X )

SELECT strFormID
		,strCSRName
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
	    
END --sp_SelectFrom_Coaching_Log_CSRPending


GO

