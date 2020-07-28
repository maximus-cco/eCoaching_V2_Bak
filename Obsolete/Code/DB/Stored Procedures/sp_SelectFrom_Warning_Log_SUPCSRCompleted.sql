IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_Warning_Log_SUPCSRCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Warning_Log_SUPCSRCompleted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	10/09/2014
--	Description: *	This procedure selects the CSR Warning records from the Warning_Log table
--  Last Updated By: Susmitha Palacherla
--  Modified SCR 13542 to add functionality for acting managers  - 12/02/2014
--  Modified per TFS 3598 to add Warning Reason fields and use sp_executesql - 8/15/2016 
--  Modified per TFS 3923 to fix slow running stored procedures in my dashboard - 9/22/2016
--  TFS 7856 encryption/decryption - emp name, emp lanid, email
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Warning_Log_SUPCSRCompleted] 
@strCSRSUPin nvarchar(30),
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
  @nvcSupID Nvarchar(10);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 

SET @strFormStatus = 'Completed'
SET @strSDate = convert(varchar(8), @strSDatein, 112)
SET @strEDate = convert(varchar(8), @strEDatein, 112)
SET @nvcSupID = EC.fn_nvcGetEmpIdFromLanID(@strCSRSUPin, GETDATE())

SET @nvcSQL = 'WITH TempMain 
AS 
(
  SELECT DISTINCT x.strFormID
    ,x.strWarningID
    ,x.strCSRName
    ,x.strCSRSupName
    ,x.strCSRMgrName
    ,x.strFormStatus
    ,x.strSource
    ,x.SubmittedDate				  
  FROM
  (
    SELECT [wl].[FormName] strFormID,
      [wl].[WarningID] strWarningID,
      [veh].[Emp_Name] strCSRName,
      [veh].[Sup_Name] strCSRSupName, 
      [veh].[Mgr_Name] strCSRMgrName, 
      [s].[Status] strFormStatus,
      [sc].[SubCoachingSource] strSource,
      [wl].[SubmittedDate] SubmittedDate
    FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK)
	JOIN [EC].[Employee_Hierarchy] eh ON [eh].[Emp_ID] = [veh].[Emp_ID]
	JOIN [EC].[Warning_Log] wl ON [wl].[EmpID] = [eh].[Emp_ID] 
	JOIN [EC].[DIM_Status] s ON [wl].[StatusID] = [s].[StatusID] 
	JOIN [EC].[DIM_Source] sc ON [wl].[SourceID] = [sc].[SourceID]
    WHERE ([eh].[Sup_ID] =  @nvcSupIDparam OR [eh].[Mgr_ID] = @nvcSupIDparam)
      AND [s].[Status] = ''' + @strFormStatus + '''
      AND convert(varchar(8), [wl].[SubmittedDate], 112) >= @strSDateinparam
      AND convert(varchar(8), [wl].[SubmittedDate], 112) <= @strEDateinparam
      AND [wl].[Active] LIKE ''' + CONVERT(NVARCHAR, @bitActive) + '''
      AND (eh.Sup_ID <> ''999999''OR eh.Mgr_ID <> ''999999'')
    GROUP BY [wl].[FormName], [wl].[WarningID], [veh].[Emp_Name], [veh].[Sup_Name], [veh].[Mgr_Name], [s].[Status], [sc].[SubCoachingSource], [wl].[SubmittedDate]
  ) X
)

SELECT strFormID
  ,strCSRName
  ,strCSRSupName
  ,strCSRMgrName
  ,strFormStatus
  ,SubmittedDate
  ,[EC].[fn_strCoachingReasonFromWarningID](strWarningID) strCoachingReason
  ,[EC].[fn_strSubCoachingReasonFromWarningID](strWarningID)strSubCoachingReason
FROM TempMain T              
ORDER BY SubmittedDate DESC'; 

SET @ParmDefinition = N'
  @nvcSupIDparam nvarchar(10),
  @strSDateinparam datetime, 
  @strEDateinparam datetime';

EXECUTE sp_executesql 
  @nvcSQL, 
  @ParmDefinition,
  @nvcSupIDparam = @nvcSupID,
  @strSDateinparam = @strSDatein, 
  @strEDateinparam = @strEDatein;
  
-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	  
	    
If @@ERROR <> 0 GoTo ErrorHandler

SET NOCOUNT OFF;

Return(0);
  
ErrorHandler:
    Return(@@ERROR);
	    
END --sp_SelectFrom_Warning_Log_SUPCSRCompleted
GO