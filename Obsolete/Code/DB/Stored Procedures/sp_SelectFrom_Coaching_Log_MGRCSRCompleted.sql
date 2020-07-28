/*
sp_SelectFrom_Coaching_Log_MGRCSRCompleted(03).sql
Last Modified Date: 01/18/2018
Last Modified By: Susmitha Palacherla

Version 03 : TFS 7856 encryption/decryption - emp name, landid, email- 12/13/2017
Version 02: Modified to support additional Modules (show logs where Mgr is sup of log owner) - TFS 8793 - 11/16/2017
Version 01: Document Initial Revision - TFS 5223 - 1/18/2017
*/

IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MGRCSRCompleted' 
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
-- TFS 7856 encryption/decryption - emp name, landid, email- 12/13/2017
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

SET NOCOUNT ON;

DECLARE	
@nvcSQL nvarchar(max),
@ParmDefinition NVARCHAR(1000),
@strFormStatus nvarchar(30),
@strSDate nvarchar(8),
@strEDate nvarchar(8),
@nvcMGRID Nvarchar(10),
@dtmDate datetime;

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

SET @strFormStatus = 'Completed';
SET @strSDate = convert(varchar(8),@strSDatein,112);
SET @strEDate = convert(varchar(8),@strEDatein,112);
SET @dtmDate  = GETDATE();
SET @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate);

SET @nvcSQL = 'WITH TempMain 
AS 
( 
  SELECT DISTINCT x.strFormID
    ,x.strCoachingID
    ,x.strCSRName
    ,x.strCSRSupName
    ,x.strCSRMgrName
    ,x.strFormStatus
    ,x.strSource
    ,x.SubmittedDate				  
  FROM 
  (
    SELECT [cl].[FormName] strFormID,
      [cl].[CoachingID] strCoachingID,
      [veh].[Emp_Name] strCSRName,
      [veh].[Sup_Name] strCSRSupName, 
      [veh].[Mgr_Name] strCSRMgrName, 
      [s].[Status] strFormStatus,
      [sc].[SubCoachingSource] strSource,
      [cl].[SubmittedDate] SubmittedDate
    FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
	JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
	JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON [cl].[EmpID] = [eh].[Emp_ID]
	JOIN [EC].[DIM_Status] s ON [cl].[StatusID] = [s].[StatusID] 
	JOIN  [EC].[DIM_Source] sc ON [cl].[SourceID] = [sc].[SourceID] 
    WHERE (eh.[Mgr_ID] = @nvcMGRIDparam OR eh.[Sup_ID] = @nvcMGRIDparam)
      AND [S].[Status] = ''' + @strFormStatus+'''
      AND [sc].[SubCoachingSource] LIKE @strSourceinparam
      AND [veh].[Emp_Name] LIKE @strCSRinparam
      AND [veh].[Sup_Name] LIKE  @strCSRSUPinparam
      AND convert(varchar(8), [cl].[SubmittedDate], 112) >= @strSDateinparam
      AND convert(varchar(8), [cl].[SubmittedDate], 112) <= @strEDateinparam
      AND eh.[Mgr_ID] <> ''999999''
    GROUP BY [cl].[FormName], [cl].[CoachingID], [veh].[Emp_Name], [veh].[Sup_Name], [veh].[Mgr_Name], [S].[Status], [sc].[SubCoachingSource], [cl].[SubmittedDate]
  ) X 
)

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
ORDER BY SubmittedDate DESC';
	
SET @ParmDefinition = N'
  @strSourceinparam nvarchar(100),
  @nvcMGRIDparam nvarchar(10),
  @strCSRSUPinparam nvarchar(30),
  @strCSRinparam nvarchar(30), 
  @strSDateinparam datetime, 
  @strEDateinparam datetime';	

EXECUTE sp_executesql 
  @nvcSQL, 
  @ParmDefinition,
  @strSourceinparam = @strSourcein, 
  @nvcMGRIDparam = @nvcMGRID, 
  @strCSRSUPinparam = @strCSRSUPin,
  @strCSRinparam = @strCSRin, 
  @strSDateinparam = @strSDatein, 
  @strEDateinparam = @strEDatein;

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 
	    
If @@ERROR <> 0 GoTo ErrorHandler;

SET NOCOUNT OFF;
Return(0);
  
ErrorHandler:
    Return(@@ERROR);
	    
END --sp_SelectFrom_Coaching_Log_MGRCSRCompleted
GO


