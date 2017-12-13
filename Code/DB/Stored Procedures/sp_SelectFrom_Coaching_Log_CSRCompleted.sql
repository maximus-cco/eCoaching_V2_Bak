IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_CSRCompleted' 
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
-- TFS 7856 encryption/decryption - emp name
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
@dtmDate datetime;

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

SET @dtmDate  = GETDATE()   
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@strCSRin,@dtmDate)
SET @strFormStatus = 'Completed'

SET @nvcSQL = 'WITH TempMain 
AS 
(
  SELECT DISTINCT x.strFormID
    ,x.strCoachingID
    ,x.strCSRName
    ,x.strCSRSupName
    ,x.strCSRMgrName
    ,x.strFormStatus
    ,x.SubmittedDate				  
  FROM 
  (
    SELECT [cl].[FormName] strFormID,
      [cl].[CoachingID] strCoachingID,
      [veh].[Emp_Name] strCSRName,
      [veh].[Sup_Name] strCSRSupName, 
      [veh].[Mgr_Name] strCSRMgrName, 
      [s].[Status] strFormStatus,
      [cl].[SubmittedDate] SubmittedDate
	FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
	JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON cl.EmpID = veh.Emp_ID 
	JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID
	WHERE cl.EmpID = @nvcEmpIDparam 
      AND [S].[Status] = ''' + @strFormStatus + '''
      AND  cl.EmpID <> ''999999''
    GROUP BY [cl].[FormName], [cl].[CoachingID], [veh].[Emp_Name], [veh].[Sup_Name], [veh].[Mgr_Name], [S].[Status], [cl].[SubmittedDate]
  ) X 
)

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
ORDER BY SubmittedDate DESC';
		
SET @ParmDefinition = N'@nvcEmpIDparam  nvarchar(10)';

EXECUTE sp_executesql 
  @nvcSQL, 
  @ParmDefinition,
  @nvcEmpIDparam = @nvcEmpID;
	    
-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 

If @@ERROR <> 0 GoTo ErrorHandler;

SET NOCOUNT OFF;

Return(0);
  
ErrorHandler:
    Return(@@ERROR);
	    
END --sp_SelectFrom_Coaching_Log_CSRCompleted
GO