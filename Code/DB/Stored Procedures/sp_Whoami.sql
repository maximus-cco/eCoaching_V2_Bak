/*
sp_Whoami(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Whoami' 
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
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Whoami] 

(
 @strUserin	Nvarchar(30)
)
AS

BEGIN
DECLARE	
@EmpID nvarchar(100),
@nvcEmpJobCode nvarchar(30),
@nvcHRCondition nvarchar(1000),
@nvcSQL nvarchar(max)

SET @nvcHRCondition = ''


SET @EmpID = (Select [EC].[fn_nvcGetEmpIdFromLanId](@strUserin,GETDATE()))
SET @nvcEmpJobCode = (SELECT Emp_Job_Code From EC.Employee_Hierarchy
WHERE Emp_ID = @EmpID)

IF @nvcEmpJobCode LIKE 'WH%'
SET @nvcHRCondition = ' AND [Emp_Job_Code] LIKE ''WH%'' AND [Active]= ''A'''

SET @nvcSQL = 'SELECT [Emp_Job_Code] as EmpJobCode,
                       [Emp_Email] as EmpEmail,
                       [Emp_Name] as EmpName,
                       lower([Emp_ID]) as EmpID
              FROM [EC].[Employee_Hierarchy]WITH(NOLOCK)
              WHERE [Emp_ID] = '''+@EmpID+'''
              AND [Active] not in  (''T'', ''D'')
              AND [Emp_ID] <> ''999999''' + @nvcHRCondition


              
            
		
EXEC (@nvcSQL)	
--Print @nvcSQL
END --sp_Whoami




GO

