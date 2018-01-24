/*
sp_SelectReviewFrom_Coaching_Log_For_Delete(02).sql
Last Modified Date: 3/21/2017
Last Modified By: Susmitha Palacherla

Version 02: Updated to add IsCoaching to return. TFS 5641 - 03/21/2017
Version 01: Document Initial Revision - TFS 5223 - 1/25/2017
*/

IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectReviewFrom_Coaching_Log_For_Delete' 
)
   DROP PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log_For_Delete]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	06/08/2015
--	Description: 	This procedure displays the Coaching Log attributes for given Form Name.
--  Revision History: 
--  Initial Revision per SCR 14478- 06/08/2015
--  Upadted to add IsCoaching to return. TFS 5641 - 03/21/2017
--  TFS 7856 encryption/decryption - emp name, emp lanid, email
--	=====================================================================

CREATE PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log_For_Delete] 
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
	    
END --sp_SelectReviewFrom_Coaching_Log_For_Delete
GO