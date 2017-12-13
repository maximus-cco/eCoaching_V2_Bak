IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_Whoisthis' 
)
   DROP PROCEDURE [EC].[sp_Whoisthis]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	<7/23/13>
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 06/12/2015
-- Updated per SCR 14966 to use the Employee ID as input parameter instead of Emp Lan ID 
-- and added SupID and MgrID to the return.
-- TFS 7856 encryption/decryption - emp name, emp lanid, email
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Whoisthis] 
(
  @strUserIDin Nvarchar(30)
)
AS

BEGIN

DECLARE	
  @nvcSQL nvarchar(max);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 

SET @nvcSQL = '
SELECT 
  veh.Sup_LanID + 
  ''$'' + 
  eh.Sup_ID + 
  ''$'' + 
  veh.Mgr_LanID + 
  ''$'' + 
  eh.Mgr_ID AS Flow
FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK)
JOIN [EC].[Employee_Hierarchy] eh WITH (NOLOCK) ON veh.Emp_ID = eh.Emp_ID
WHERE veh.Emp_ID = '''+ @strUserIDin+'''';
		
EXEC (@nvcSQL)	

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];

END --sp_Whoisthis
GO