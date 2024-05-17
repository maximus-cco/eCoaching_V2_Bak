
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	7/31/14
--	Description: *	This procedure takes the lan ID of the user and looks up the job code.
--  If Job code exists in the submisison table returns the valid submission modules.
--  If job code does not exist in the submisisons table returns 'CSR' as a valid sumission module.
--  Last Modified By: Susmitha Palacherla
--  Modified per TFS 861 to add Warnings to all Modules - 10/21/2015 
-- Modified per TFS 3877 to hard code Employee Ids for Mark Hackman and Scott Potter
-- to allow LSA and Training submissions which their job code does not have access to - 09/21/2016
--  Modified to support Encryption of sensitive data (Open key)- TFS 7856 - 10/23/2017
-- Modified during Submissions move to new architecture - TFS 7136 - 04/10/2018
-- Modified to Support ISG Alignment Project. TFS 28026 - 05/06/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_Select_Modules_By_Job_Code] 
@nvcEmpIDin nvarchar(10)

AS
BEGIN
	DECLARE	

	@nvcSQL nvarchar(max),
	@nvcEmpJobCode nvarchar(30),
	@nvcCSR nvarchar(30)


-- Open Symmetric Key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]  


SET @nvcEmpJobCode = (SELECT Emp_Job_Code From EC.Employee_Hierarchy
WHERE Emp_ID = @nvcEmpIDin)

--print @nvcEmpJobCode

SET @nvcCSR = (SELECT CASE WHEN [CSR]= 1 THEN N'CSR'  ELSE NULL END  as Module FROM [EC].[Module_Submission]
WHERE Job_Code = @nvcEmpJobCode)

--print @nvcCSR

if @nvcCSR is null

SET @nvcSQL = 'SELECT TOP 1 CASE WHEN [CSR]= 1 THEN N''CSR'' ELSE N''CSR'' END as Module, 1 AS ModuleID 
from [EC].[Module_Submission]
UNION
SELECT TOP 1 CASE WHEN [ISG]= 1 THEN N''ISG'' ELSE N''ISG'' END as Module, 10 AS ModuleID 
from [EC].[Module_Submission]'
 
ELSE

SET @nvcSQL = 'SELECT Module, ModuleID FROM 
(SELECT CASE WHEN [CSR]= 1 THEN N''CSR'' ELSE N''CSR'' END as Module, 1 AS ModuleID from [EC].[Module_Submission] 
where Job_Code = '''+@nvcEmpJobCode+'''
UNION
SELECT CASE WHEN [ISG]= 1 THEN N''ISG'' ELSE N''ISG'' END as Module, 10 AS ModuleID from [EC].[Module_Submission] 
where Job_Code = '''+@nvcEmpJobCode+'''
UNION
SELECT CASE WHEN [Supervisor]= 1 THEN N''Supervisor'' ELSE NULL END as Module, 2 AS ModuleID from [EC].[Module_Submission] 
where Job_Code = '''+@nvcEmpJobCode+'''
UNION 
SELECT CASE WHEN [Quality]= 1 THEN N''Quality'' ELSE NULL END as Module, 3 AS ModuleID from [EC].[Module_Submission] 
where Job_Code = '''+@nvcEmpJobCode+'''
UNION 
SELECT CASE WHEN [LSA]= 1 THEN N''LSA'' ELSE NULL END as Module, 4 AS ModuleID from [EC].[Module_Submission] 
where Job_Code = '''+@nvcEmpJobCode+''' OR '''+@nvcEmpIDin+''' in (''343549'',''408246'')
UNION 
SELECT CASE WHEN [Training]= 1 THEN N''Training'' ELSE NULL END as Module, 5 AS ModuleID from [EC].[Module_Submission] 
where Job_Code = '''+@nvcEmpJobCode+''' OR '''+@nvcEmpIDin+''' in (''343549'',''408246''))AS Modulelist
where Module is not Null '
Print @nvcSQL

EXEC (@nvcSQL)	

  -- Clode Symmetric Key
  CLOSE SYMMETRIC KEY [CoachingKey] 

END --sp_Select_Modules_By_Job_Code

GO


