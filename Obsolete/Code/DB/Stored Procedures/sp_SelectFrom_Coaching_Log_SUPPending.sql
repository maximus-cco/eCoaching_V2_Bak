IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_SUPPending' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SUPPending]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: This procedure selects the Pending e-Coaching records 
--  for a given Supervisor in the Supervisor Dashboard.
--  Last Updated By: Susmitha Palacherla
--  Modified per SCR 14422 during dashboard resdesign - 6/16/2016
--    1. To Replace old style joins.
--    2. Lan ID association by date.
--  Modified per TFS 1710 Admin Tool setup - 5/2/2016
--  Modified per TFS 2268 CTC feed to add "Pending Acknowledgement" to filter - 5/2/2016
--  Modified per TFS 3598 to add Coaching Reason fields and use sp_executesql - 8/15/2016
--  Modified per TFS 3923 to fix slow running stored procedures in my dashboard - 9/22/2016
--  TFS 7856 encryption/decryption - emp name
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SUPPending] @strCSRSUPin nvarchar(30)
AS

BEGIN
SET NOCOUNT ON
DECLARE	
@nvcSQL nvarchar(max),
@ParmDefinition NVARCHAR(1000),
@strFormStatus1 nvarchar(30),
@strFormStatus2 nvarchar(30),
@strFormStatus3 nvarchar(30),
@strFormStatus4 nvarchar(30),
@strFormStatus5 nvarchar(30),
@nvcSUPID Nvarchar(10),
@dtmDate datetime;

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

SET @strFormStatus1 = 'Pending Supervisor Review'
SET @strFormStatus2 = 'Pending Acknowledgement'
SET @strFormStatus3 = 'Pending Manager Review'
SET @strFormStatus4 = 'Pending Quality Lead Review'
SET @strFormStatus5 = 'Pending Employee Review'
SET @dtmDate  = GETDATE()   
SET @nvcSUPID = EC.fn_nvcGetEmpIdFromLanID(@strCSRSUPin,@dtmDate)
 
SET @nvcSQL = 'WITH TempMain AS (
SELECT DISTINCT x.strFormID
               ,x.strCoachingID
               ,x.strCSR
               ,x.strCSRName
               ,x.strCSRSupName
               ,x.strFormStatus
               ,x.SubmittedDate
FROM (
        SELECT [cl].[FormName] strFormID,
               [cl].[CoachingID]strCoachingID,
               [veh].[Emp_LanID] strCSR,
               [veh].[Emp_Name]	strCSRName,
               [veh].[Sup_Name] strCSRSupName,
               [S].[Status]	strFormStatus,
               [cl].[SubmittedDate] SubmittedDate
        FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
		JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
		JOIN [EC].[Coaching_Log] cl WITH (NOLOCK) ON cl.EmpID = eh.Emp_ID 
		JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID
        WHERE 
		  (
            ([ReassignCount]= 0 AND (eh.[Sup_ID] = @nvcSUPIDparam OR eh.[Mgr_ID] = @nvcSUPIDparam)
               AND ([S].[Status] = '''+@strFormStatus1+''' OR [S].[Status] = '''+@strFormStatus2+''' OR [S].[Status] = '''+@strFormStatus3+''' OR [S].[Status] = '''+@strFormStatus4+'''))
            OR (cl.[ReassignedToId] = @nvcSUPIDparam AND [ReassignCount]<> 0 AND [S].[Status] = '''+@strFormStatus1+''')
            OR (eh.[Emp_ID] = @nvcSUPIDparam AND [S].[Status] = '''+@strFormStatus2+''')
            OR (eh.[Emp_ID] = @nvcSUPIDparam AND [S].[Status] = '''+@strFormStatus5+''')
          )
          AND '''+@nvcSUPID+'''  <> ''999999''
        GROUP BY [cl].[FormName],[cl].[CoachingID],[veh].[Emp_LanID],[veh].[Emp_Name],[veh].[Sup_Name],[S].[Status],[cl].[SubmittedDate]
     ) X 
)

SELECT strFormID
      ,strCSR
      ,strCSRName
      ,strCSRSupName
      ,strFormStatus
      ,SubmittedDate
      ,[EC].[fn_strCoachingReasonFromCoachingID](T.strCoachingID) strCoachingReason
      ,[EC].[fn_strSubCoachingReasonFromCoachingID](T.strCoachingID)strSubCoachingReason
      ,[EC].[fn_strValueFromCoachingID](T.strCoachingID)strValue	        
FROM TempMain T
ORDER BY SubmittedDate DESC'

SET @ParmDefinition = N'@nvcSUPIDparam nvarchar(10)'
		
--EXEC (@nvcSQL)	
--Print @nvcSQL

EXECUTE sp_executesql @nvcSQL, @ParmDefinition, @nvcSUPIDparam = @nvcSUPID;

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 

If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
ErrorHandler:
    Return(@@ERROR)
	    
END --sp_SelectFrom_Coaching_Log_SUPPending
GO


