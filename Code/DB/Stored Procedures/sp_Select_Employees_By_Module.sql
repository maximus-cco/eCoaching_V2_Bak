/*
sp_Select_Employees_By_Module(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



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
--  Last Modified date: 04/15/2015
--  Modified per SCR 14512 while adding Training Module to restrict  users with certain 
--  job codes from submitting Training ecls for some job codes.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Employees_By_Module] 

@strModulein nvarchar(30), @strCSRSitein nvarchar(30)= NULL,
@strUserLanin nvarchar(20)

AS

BEGIN
DECLARE	
@isBySite BIT,
@nvcEmpJobCode nvarchar(30),
@nvcEmpID nvarchar(10),
@dtmDate datetime,
@nvcSQL nvarchar(max),
@nvcSQL01 nvarchar(1000),
@nvcSQL02 nvarchar(1000),
@nvcSQL03 nvarchar(1000),
@nvcSQL04 nvarchar(1000)

SET @dtmDate  = GETDATE()  
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@strUserLanin,@dtmDate)
SET @nvcEmpJobCode = (SELECT Emp_Job_Code From EC.Employee_Hierarchy
WHERE Emp_ID = @nvcEmpID)

-- General Selection of employees based on Job codes flagged in Employee Selection table.

SET @nvcSQL01 = 'select [Emp_Name] + '' ('' + [Emp_LanID] + '') '' + [Emp_Job_Description] as FrontRow1
	  ,[Emp_Name] + ''$'' + [Emp_Email] + ''$'' + [Emp_LanID] + ''$'' + [Sup_Name] + ''$'' + [Sup_Email] + ''$'' + [Sup_LanID] + ''$'' + [Sup_Job_Description] + ''$'' + [Mgr_Name] + ''$'' + [Mgr_Email] + ''$'' + [Mgr_LanID] + ''$'' + 

[Mgr_Job_Description]  + ''$'' + [Emp_Site] as BackRow1, [Emp_Site]
       from [EC].[Employee_Hierarchy] WITH (NOLOCK) JOIN [EC].[Employee_Selection]
       on [EC].[Employee_Hierarchy].[Emp_Job_Code]= [EC].[Employee_Selection].[Job_Code]
where [EC].[Employee_Selection].[is'+ @strModulein + ']= 1
and [Emp_lanID] <> '''+@strUserLanin+ ''''


-- Conditional filter for Modules that are flagged as BySite in DIM Module

SET @nvcSQL02 = ' and [Emp_Site] = ''' +@strCSRSitein + ''''


-- Conditional Filter to restrtict Training staff with specific job codes to submit only for certain job codes.

SET @nvcSQL03 = ' and [Emp_Job_Code] NOT IN (''WTTR12'', ''WTTR13'', ''WTID13'')' 


-- Generic  Filter for all scenarios.

SET @nvcSQL04 = ' and [End_Date] = ''99991231''
and [Emp_LanID]is not NULL and [Sup_LanID] is not NULL and [Mgr_LanID]is not NULL
order By [Emp_Name] ASC'

--IF @strModulein = 'CSR'
SET @isBySite = (SELECT BySite FROM [EC].[DIM_Module] Where [Module] = @strModulein and isActive =1)
IF @isBySite = 1

SET @nvcSQL = @nvcSQL01 + @nvcSQL02 +@nvcSQL04 
ELSE

IF @nvcEmpJobCode IN ('WTTR12', 'WTTR13', 'WTID13') 

SET @nvcSQL = @nvcSQL01 + @nvcSQL03 + @nvcSQL04 

ELSE
SET @nvcSQL = @nvcSQL01 + @nvcSQL04 

--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_Employees_By_Module

GO

