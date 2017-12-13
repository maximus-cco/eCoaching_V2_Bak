/*
sp_SelectFrom_Coaching_Log_MGRCSRPending(02).sql
Last Modified Date: 11/27/2017
Last Modified By: Susmitha Palacherla

Version 02: Modified to support additional Modules (show logs where Mgr is sup of log owner)- TFS 8793 - 11/16/2017
Version 01: Document Initial Revision - TFS 5223 - 1/18/2017
*/

IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MGRCSRPending' 
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
--  Modified per TFS 3598 to add Coaching Reason fields and use sp_executesql - 8/15/2016
--  Modified per TFS 3923 to fix slow running stored procedures in my dashboard - 9/22/2016
--  Modified to support additional Modules (show logs where Mgr is sup of log owner) per TFS 8793 - 11/16/2017
--  TFS 7856 encryption/decryption - emp name
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
@dtmDate datetime;

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

SET @dtmDate  = GETDATE()   
SET @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)

SET @nvcSQL = N'
SELECT [cl].[FormName] strFormID,
       [veh].[Emp_Name] strCSRName,
       CASE 
         WHEN (cl.[statusId]in (6,8) AND cl.[ModuleID] NOT IN (-1, 2) AND cl.[ReassignedToID]is NOT NULL AND [ReassignCount]<> 0)
           THEN [EC].[fn_strEmpNameFromEmpID](cl.[ReassignedToID])
         WHEN (cl.[statusId]= 5 AND cl.[ModuleID] = 2 AND cl.[ReassignedToID]is NOT NULL AND [ReassignCount]<> 0)
           THEN [EC].[fn_strEmpNameFromEmpID](cl.[ReassignedToID])
         ELSE [veh].[Sup_Name]
       END strCSRSupName,	
       [veh].[Mgr_Name] strCSRMgrName, 
       [s].[Status]	strFormStatus,
       [sc].[SubCoachingSource] strSource,
       [cl].[SubmittedDate]	SubmittedDate,
       [EC].[fn_strCoachingReasonFromCoachingID]([cl].[CoachingID]) strCoachingReason,
       [EC].[fn_strSubCoachingReasonFromCoachingID]([cl].[CoachingID]) strSubCoachingReason,
	   [EC].[fn_strValueFromCoachingID]([cl].[CoachingID]) strValue
FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON [cl].[EmpID] = [eh].[Emp_ID] 
JOIN [EC].[DIM_Status] s ON [cl].[StatusID] = [s].[StatusID] 
JOIN  [EC].[DIM_Source] sc ON [cl].[SourceID] = [sc].[SourceID] 
WHERE (eh.[Mgr_ID] = @nvcMGRIDparam OR eh.[Sup_ID] = @nvcMGRIDparam OR (cl.[ReassignedToID] IN (SELECT DISTINCT Emp_ID FROM EC.Employee_Hierarchy WHERE Sup_ID = @nvcMGRIDparam)))
  AND [veh].[Emp_Name] LIKE @strCSRinparam
  AND [veh].[Sup_Name] LIKE @strCSRSUPinparam
  AND [S].[Status] LIKE ''Pending%''
  AND [sc].[SubCoachingSource] LIKE @strSourceinparam
  AND @nvcMGRIDparam <> ''999999''
ORDER BY [SubmittedDate] DESC'

	
SET @ParmDefinition = N'
  @nvcMGRIDparam nvarchar(10),
  @strCSRSUPinparam nvarchar(30),
  @strSourceinparam nvarchar(100),
  @strCSRinparam nvarchar(30)';

EXECUTE sp_executesql 
  @nvcSQL, 
  @ParmDefinition, 
  @nvcMGRIDparam = @nvcMGRID, 
  @strCSRSUPinparam = @strCSRSUPin, 
  @strSourceinparam = @strSourcein, 
  @strCSRinparam = @strCSRin;

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 
	    
If @@ERROR <> 0 GoTo ErrorHandler;

SET NOCOUNT OFF;

Return(0);
  
ErrorHandler:
    Return(@@ERROR);
	    
END --sp_SelectFrom_Coaching_Log_MGRCSRPending
GO