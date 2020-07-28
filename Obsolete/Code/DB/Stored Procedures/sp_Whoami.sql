IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_Whoami' 
)
   DROP PROCEDURE [EC].[sp_Whoami]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	07/22/13
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 4/4/2016
-- TFS 605 - Return lower employee ID and look for Active not in ('T','D')- 8/25/2015
-- TFS 2323 - Unknown user can be authenticated - Restrict user in SP return - 4/4/2016
-- TFS 2332 - Controlling access for HR users from backend - 4/7/2016
-- TFS 7856 encryption/decryption - emp name, emp lanid, email
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Whoami] 
(
  @strUserin Nvarchar(30)
)
AS

BEGIN

DECLARE	
  @EmpID nvarchar(100),
  @nvcEmpJobCode nvarchar(30),
  @nvcHRCondition nvarchar(1000),
  @nvcSQL nvarchar(max);
  
-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 

SET @nvcHRCondition = '';
SET @EmpID = (Select [EC].[fn_nvcGetEmpIdFromLanId](@strUserin, GETDATE()));
SET @nvcEmpJobCode = (SELECT Emp_Job_Code From EC.Employee_Hierarchy WHERE Emp_ID = @EmpID);

IF @nvcEmpJobCode LIKE 'WH%'
BEGIN
  SET @nvcHRCondition = ' AND [Emp_Job_Code] LIKE ''WH%'' AND [Active]= ''A''';
END

SET @nvcSQL = '
SELECT 
  Emp_Job_Code AS EmpJobCode,
  veh.Emp_Email AS EmpEmail,
  veh.Emp_Name AS EmpName,
  lower(veh.Emp_ID) AS EmpID
FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK)
JOIN [EC].[Employee_Hierarchy] eh ON veh.Emp_ID = eh.Emp_ID
WHERE veh.Emp_ID = ''' + @EmpID + '''
  AND Active NOT IN (''T'', ''D'')
  AND veh.Emp_ID <> ''999999''' + @nvcHRCondition
		
EXEC (@nvcSQL)

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];

END --sp_Whoami
GO