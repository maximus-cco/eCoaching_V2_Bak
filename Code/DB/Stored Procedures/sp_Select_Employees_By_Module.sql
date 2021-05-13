/*
sp_Select_Employees_By_Module(03).sql
Last Modified Date: 5/11/2021
Last Modified By: Susmitha Palacherla

Version 03: Fix ambiguous column reference during employee selection in submission page. TFS 21223 - 5/11/2021
Version 02: Modified to support Encryption of sensitive data (Open keys and use employee View for emp attributes. TFS 7856 - 10/23/2017
Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Employees_By_Module' 
)
   DROP PROCEDURE [EC].[sp_Select_Employees_By_Module]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	7/31/14
--	Description: *	This procedure pulls the list of Employee names to be displayed 
--  in the drop downs for the selected Module using the job_code in the Employee_Selection table.
--  Created to replace the sp_SelectCSRsbyLocation used by the original CSR Module 
--  Last Modified By: Susmitha Palacherla
--  Revision History:
--  Modified to restrict certain Training job codes from submitting ecls for certain Training job codes.SCR 14512 - 04/15/2015
--  Modified to support Encryption of sensitive data (Open keys and use employee View for emp attributes. TFS 7856 - 10/23/2017
--  Modified during Submissions move to new architecture - TFS 7136 - 04/10/2018
--  Fix ambiguous column reference during employee selection in submission page. TFS 21223 - 5/11/2021
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Employees_By_Module] 

@intModuleIDin int, @strCSRSitein nvarchar(30)= NULL,
@strEmpIDin nvarchar(10)

AS

BEGIN
DECLARE	
@isBySite BIT,
@nvcEmpJobCode nvarchar(30),
@strModulein nvarchar(30),
@nvcSQL nvarchar(max),
@nvcSQL01 nvarchar(1000),
@nvcSQL02 nvarchar(1000),
@nvcSQL03 nvarchar(1000),
@nvcSQL04 nvarchar(1000)

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert]




SET @nvcEmpJobCode = (SELECT Emp_Job_Code From EC.Employee_Hierarchy
WHERE Emp_ID = @strEmpIDin)

SET @strModulein = (SELECT Module FROM [EC].[DIM_Module] WHERE [ModuleID] = @intModuleIDin)


-- General Selection of employees based on Job codes flagged in Employee Selection table.

SET @nvcSQL01 = 'SELECT EH.[Emp_ID]
                ,VEH.[Emp_Name] 
	            ,VEH.[Sup_Name]
				,VEH.[Mgr_Name]
				 ,EH.[Emp_Site] 
 FROM [EC].[View_Employee_Hierarchy] VEH  WITH (NOLOCK)  JOIN  [EC].[Employee_Hierarchy]EH WITH (NOLOCK) 
 ON VEH.[Emp_ID]= EH.[Emp_ID] JOIN [EC].[Employee_Selection]
 ON EH.[Emp_Job_Code]= [EC].[Employee_Selection].[Job_Code]
WHERE [EC].[Employee_Selection].[is'+ @strModulein + ']= 1
AND VEH.[Emp_ID] <> '''+@strEmpIDin+ ''''


-- Conditional filter for Modules that are flagged as BySite in DIM Module

SET @nvcSQL02 = ' AND VEH.[Emp_Site] = ''' +@strCSRSitein + ''''


-- Conditional Filter to restrtict Training staff with specific job codes to submit only for certain job codes.

SET @nvcSQL03 = ' AND VEH.[Emp_Job_Code] NOT IN (''WTTR12'', ''WTTR13'', ''WTID13'')' 


-- Generic  Filter for all scenarios.

SET @nvcSQL04 = ' AND [End_Date] = ''99991231''
AND VEH.[Emp_LanID]is not NULL and VEH.[Sup_LanID] is not NULL and VEH.[Mgr_LanID]is not NULL
ORDER BY VEH.[Emp_Name] ASC'

--IF @strModulein = 'CSR'
SET @isBySite = (SELECT BySite FROM [EC].[DIM_Module] Where [ModuleID] = @intModuleIDin and isActive =1)
IF @isBySite = 1

SET @nvcSQL = @nvcSQL01 + @nvcSQL02 +@nvcSQL04 
ELSE

IF @nvcEmpJobCode IN ('WTTR12', 'WTTR13', 'WTID13') 

SET @nvcSQL = @nvcSQL01 + @nvcSQL03 + @nvcSQL04 

ELSE
SET @nvcSQL = @nvcSQL01 + @nvcSQL04 

--Print @nvcSQL

EXEC (@nvcSQL)	

CLOSE SYMMETRIC KEY [CoachingKey]  
END --sp_Select_Employees_By_Module
GO



