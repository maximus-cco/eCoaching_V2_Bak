/*
sp_Select_Modules_By_Job_Code(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Modules_By_Job_Code' 
)
   DROP PROCEDURE [EC].[sp_Select_Modules_By_Job_Code]
GO

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
-- 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Modules_By_Job_Code] 
@nvcEmpLanIDin nvarchar(30)

AS
BEGIN
	DECLARE	

	@nvcSQL nvarchar(max),
	@nvcEmpID nvarchar(10),
	@nvcEmpJobCode nvarchar(30),
	@nvcCSR nvarchar(30),
	@dtmDate datetime

SET @dtmDate  = GETDATE()  
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@nvcEmpLanIDin,@dtmDate)
SET @nvcEmpJobCode = (SELECT Emp_Job_Code From EC.Employee_Hierarchy
WHERE Emp_ID = @nvcEmpID)

SET @nvcCSR = (SELECT CASE WHEN [CSR]= 1 THEN N'CSR' ELSE NULL END  as Module FROM [EC].[Module_Submission]
WHERE Job_Code = @nvcEmpJobCode)

--print @nvcCSR

if @nvcCSR is null


/*
 The BySite string below is a combination of the  following
 1. whether site will be a selection
 2. Module Name
 3. Module ID
 4. Whether CSE will be displayed or not
 5. Whether warning will be displayed for Direct or Not
 6.Whether program will be a selection or not
 7. whether behavior will be a selection or not
*/

SET @nvcSQL = 'SELECT TOP 1 CASE WHEN [CSR]= 1 THEN N''CSR'' ELSE N''CSR'' END as Module, ''1-CSR-1-1-1-1-0'' as BySite
from [EC].[Module_Submission]'
 
ELSE

SET @nvcSQL = 'SELECT Module, BySite FROM 
(SELECT CASE WHEN [CSR]= 1 THEN N''CSR'' ELSE N''CSR'' END as Module, ''1-CSR-1-1-1-1-0'' as BySite from [EC].[Module_Submission] 
where Job_Code = '''+@nvcEmpJobCode+'''
UNION
SELECT CASE WHEN [Supervisor]= 1 THEN N''Supervisor'' ELSE NULL END as Module, ''0-Supervisor-2-1-1-1-0'' as BySite from [EC].[Module_Submission] 
where Job_Code = '''+@nvcEmpJobCode+'''
UNION 
SELECT CASE WHEN [Quality]= 1 THEN N''Quality'' ELSE NULL END as Module, ''0-Quality Specialist-3-0-1-1-0'' as BySite from [EC].[Module_Submission] 
where Job_Code = '''+@nvcEmpJobCode+'''
UNION 
SELECT CASE WHEN [LSA]= 1 THEN N''LSA'' ELSE NULL END as Module, ''0-LSA-4-0-1-1-0'' as BySite from [EC].[Module_Submission] 
where Job_Code = '''+@nvcEmpJobCode+''' OR '''+@nvcEmpID+''' in (''343549'',''408246'')
UNION 
SELECT CASE WHEN [Training]= 1 THEN N''Training'' ELSE NULL END as Module, ''0-Training-5-1-1-0-1'' as BySite from [EC].[Module_Submission] 
where Job_Code = '''+@nvcEmpJobCode+''' OR '''+@nvcEmpID+''' in (''343549'',''408246''))AS Modulelist
where Module is not Null '
--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_Modules_By_Job_Code




GO

