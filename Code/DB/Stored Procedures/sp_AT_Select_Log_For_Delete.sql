SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/15/2021
--	Description: 	This procedure displays the Coaching Log or Warning Log attributes for given Form Name.
--  Revision History: 
--  Initial Revision created during migration to AWS to correctly associate functionality with Admin Tool - TFS 20970

--	=====================================================================

CREATE OR ALTER PROCEDURE [EC].[sp_AT_Select_Log_For_Delete] 
@strFormIDin nvarchar(50)

AS

BEGIN

DECLARE	
  @intCoachID bigint,
  @nvcSQL nvarchar(max);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 

SET @intCoachID = (SELECT [CoachingID] FROM [EC].[Coaching_Log] WITH (NOLOCK) WHERE [FormName] = @strFormIDin);
	 	
IF @intCoachID IS NOT NULL		
  SET @nvcSQL = '
  SELECT [CoachingID] CoachingID,
    [FormName],
    veh.Emp_LanID EmpLanID,
    [EmpID],
    [SourceID],
    1 [isCoaching]
  FROM [EC].[Coaching_Log] cl WITH (NOLOCK)
  JOIN [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) ON cl.EmpID = veh.Emp_ID
  WHERE [FormName] = ''' + @strFormIDin + '''';
	 
ELSE
  SET @nvcSQL = '
  SELECT [WarningID] CoachingID,
    [FormName],
    veh.Emp_LanID EmpLanID,
    [EmpID],
    [SourceID],
    0 [isCoaching]
  FROM [EC].[Warning_Log] wl WITH (NOLOCK)
  JOIN [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) ON wl.EmpID = veh.Emp_ID
  WHERE [FormName] = ''' + @strFormIDin + '''';	 		

EXEC (@nvcSQL)
Print (@nvcSQL)

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];
	    
END --sp_AT_Select_Log_For_Delete
GO


