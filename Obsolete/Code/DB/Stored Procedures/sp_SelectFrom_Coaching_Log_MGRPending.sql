/*
sp_SelectFrom_Coaching_Log_MGRPending(02).sql
Last Modified Date: 11/27/2017
Last Modified By: Susmitha Palacherla


Version 02: Modified to support additional Modules per TFS 8793 - 11/16/2017
Version 01: Document Initial Revision - TFS 5223 - 1/18/2017
*/

IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MGRPending' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MGRPending]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ====================================================================
-- Author:			Susmitha Palacherla
-- Create Date:	11/16/11
-- Description: This procedure selects the Pending e-Coaching records 
-- for a given Manager in the Manager Dashboard.
-- Last Updated By: Susmitha Palacherla
-- Modified per SCR 14422 during dashboard resdesign - 04/16/2015
-- 1. To Replace old style joins.
-- 2. Lan ID association by date.
-- Updated per SCR 14818 to support rotating managers for Low CSAT - 05/22/2015
-- Modified per TFS 1710 Admin Tool setup - 5/2/2016
-- Modified per TFS 3598 to add Coaching Reason fields and use sp_executesql - 8/15/2016
-- Modified per TFS 3923 to fix slow running stored procedures in my dashboard - 9/22/2016
-- Modified to support additional Modules per TFS 8793 - 11/16/2017
-- TFS 7856 encryption/decryption - emp name
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MGRPending] 
@strCSRMGRin nvarchar(30),
@strCSRin nvarchar(30),
@strCSRSUPin nvarchar(30) 

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus1 nvarchar(50),
@strFormStatus2 nvarchar(50),
@strFormStatus3 nvarchar(50),
@strFormStatus4 nvarchar(50),
@strFormStatus5 nvarchar(50),
@strFormStatus6 nvarchar(50),
@strFormStatus7 nvarchar(50),
@nvcMGRID Nvarchar(10),
@dtmDate datetime;

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

SET @strFormStatus1 = 'Pending Manager Review'
SET @strFormStatus2 = 'Pending Supervisor Review'
SET @strFormStatus3 = 'Pending Acknowledgement'
SET @strFormStatus4 = 'Pending Sr. Manager Review'
SET @strFormStatus5 = 'Pending Deputy Program Manager Review'
SET @strFormStatus6 = 'Pending Quality Lead Review'
SET @strFormStatus7 = 'Pending Employee Review'
SET @dtmDate  = GETDATE()   
SET @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)
 
SET @nvcSQL = '
SELECT [cl].[FormName]	strFormID,
       [veh].[Emp_LanID] strCSR,
       [veh].[Emp_Name]	strCSRName,
       [veh].[Sup_Name]	strCSRSupName, 
       [s].[Status]	strFormStatus,
       [cl].[SubmittedDate]	SubmittedDate,
       [EC].[fn_strCoachingReasonFromCoachingID]([cl].[CoachingID]) strCoachingReason,
       [EC].[fn_strSubCoachingReasonFromCoachingID]([cl].[CoachingID])strSubCoachingReason,
       [EC].[fn_strValueFromCoachingID]([cl].[CoachingID])strValue
FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
JOIN [EC].[Coaching_Log] cl WITH (NOLOCK) ON cl.EmpID = eh.Emp_ID 
JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID
WHERE [veh].[Emp_Name] LIKE ''' + @strCSRin + '''
  AND [veh].[Sup_Name] LIKE ''' + @strCSRSUPin + '''
  AND (
        ((ISNULL([cl].[strReportCode], '' '') NOT LIKE ''LCS%'') AND [ReassignCount] = 0 AND eh.[Mgr_ID] = ''' + @nvcMGRID + '''
          AND([S].[Status] = ''' + @strFormStatus1 + ''' OR [S].[Status] = ''' + @strFormStatus4 + ''' OR [S].[Status] = ''' + @strFormStatus5 + ''')) 
        OR ((ISNULL([cl].[strReportCode], '' '') NOT LIKE ''LCS%'') AND [ReassignCount] = 0 AND eh.[Sup_ID] = ''' + @nvcMGRID + '''
          AND ([S].[Status] = ''' + @strFormStatus1 + ''' OR [S].[Status] = ''' + @strFormStatus2 + ''' OR [S].[Status] = ''' + @strFormStatus3 + ''' OR [S].[Status] = ''' + @strFormStatus6 + '''))
        OR ((ISNULL([cl].[strReportCode], '' '') NOT LIKE ''LCS%'') AND cl.[ReassignedToID] = ''' + @nvcMGRID + ''' AND [ReassignCount] <> 0
          AND ([S].[Status] = ''' + @strFormStatus1 + ''' OR [S].[Status] = ''' + @strFormStatus4 + ''' OR [S].[Status] = ''' + @strFormStatus5 + '''))
        OR ((ISNULL([cl].[strReportCode],'' '') NOT LIKE ''LCS%'') AND cl.[EmpID] = ''' + @nvcMGRID + ''' AND [S].[Status] = ''' + @strFormStatus7 + ''') 
        OR ([cl].[strReportCode] LIKE ''LCS%'' AND [ReassignCount] = 0 AND cl.[MgrID] = ''' + @nvcMGRID + ''' AND [S].[Status] = ''' + @strFormStatus1 + ''')
        OR ([cl].[strReportCode] LIKE ''LCS%'' AND cl.[ReassignedToID] = '''+@nvcMGRID+''' AND [ReassignCount]<> 0 AND [S].[Status] = ''' + @strFormStatus1 + ''')
        OR ([cl].[strReportCode] LIKE ''LCS%'' AND [ReassignCount] = 0 AND eh.[Sup_ID] =''' + @nvcMGRID + ''' AND [S].[Status] = ''' + @strFormStatus2 + ''')
      )
  AND ''' + @nvcMGRID + ''' <> ''999999''
GROUP BY [cl].[CoachingID], [cl].[FormName], [veh].[Emp_LanID], [veh].[Emp_Name], [veh].[Sup_Name], [s].[Status], [cl].[SubmittedDate]
ORDER BY [SubmittedDate] DESC'

EXEC (@nvcSQL);

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 
	    
If @@ERROR <> 0 GoTo ErrorHandler;

SET NOCOUNT OFF;

Return(0);
  
ErrorHandler:
    Return(@@ERROR);
	    
END --sp_SelectFrom_Coaching_Log_MGRPending
GO