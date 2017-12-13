IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_SUPCSRPending' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SUPCSRPending]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/2011
--	Description: This procedure selects the pending e-Coaching records 
--  for a given supervisor's employees in the supervisor Dashboard.
--  Last Updated By: Susmitha Palacherla
--  Last Modified Date:04/16/2015
--  Modified during dashboard redesign SCR 14422.
--    1. To Replace old style joins.
--    2. Lan ID association by date.
--  Modified per TFS 3598 to add Coaching Reason fields and use sp_executesql - 8/15/2016
--  Modified per TFS 3923 to fix slow running stored procedures in my dashboard - 9/22/2016
--  TFS 7856 encryption/decryption - emp name
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SUPCSRPending] 

@strCSRSUPin nvarchar(30),
@strCSRin nvarchar(30), 
@strSourcein nvarchar(100)

AS

BEGIN
SET NOCOUNT ON

DECLARE	
@nvcSQL nvarchar(max),
@ParmDefinition NVARCHAR(1000),
@nvcSUPID Nvarchar(10),
@dtmDate datetime;

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

SET @dtmDate  = GETDATE()   
SET @nvcSUPID = EC.fn_nvcGetEmpIdFromLanID(@strCSRSUPin,@dtmDate)

SET @nvcSQL = 'WITH TempMain AS (
SELECT DISTINCT x.strFormID
				,x.strCoachingID
				,x.strCSRName
				,x.strCSRSupName
				,x.strCSRMgrName
				,x.strFormStatus
				,x.strSource
				,x.SubmittedDate
FROM (SELECT [cl].[FormName] strFormID,
		[cl].[CoachingID]strCoachingID,
		[veh].[Emp_Name] strCSRName,
		[veh].[Sup_Name] strCSRSupName, 
		[veh].[Mgr_Name] strCSRMgrName, 
		[s].[Status] strFormStatus,
		[sc].[SubCoachingSource] strSource,
		[cl].[SubmittedDate] SubmittedDate
      FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
	  JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
	  JOIN [EC].[Coaching_Log] cl WITH (NOLOCK) ON cl.EmpID = eh.Emp_ID 
	  JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
	  JOIN [EC].[DIM_Source] sc ON cl.SourceID = sc.SourceID 
      WHERE [eh].[Sup_ID] = @nvcSUPIDparam 
        AND [S].[Status] LIKE ''Pending%''
        AND RTRIM(LTRIM([eh].[Emp_Name])) LIKE @strCSRinparam
        AND [sc].[SubCoachingSource] LIKE @strSourceinparam
        AND [eh].[Sup_ID] <> ''999999''
      GROUP BY [cl].[FormName], [cl].[CoachingID], [veh].[Emp_Name], [veh].[Sup_Name], [veh].[Mgr_Name], [S].[Status], [sc].[SubCoachingSource], [cl].[SubmittedDate]
) x )
	
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
	
SET @ParmDefinition = N'
  @nvcSUPIDparam nvarchar(10),
  @strCSRinparam nvarchar(30), 
  @strSourceinparam nvarchar(100)';
		
--EXEC (@nvcSQL)	
--PRINT @nvcSQL

EXECUTE sp_executesql @nvcSQL, @ParmDefinition,
@nvcSUPIDparam = @nvcSUPID,@strCSRinparam = @strCSRin, @strSourceinparam = @strSourcein;

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 
	    
If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
ErrorHandler:
    Return(@@ERROR)
	    
END --sp_SelectFrom_Coaching_Log_SUPCSRPending
GO