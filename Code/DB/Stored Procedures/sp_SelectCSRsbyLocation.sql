/*
sp_SelectCSRsbyLocation(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectCSRsbyLocation' 
)
   DROP PROCEDURE [EC].[sp_SelectCSRsbyLocation]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	12/13/13
--	Description: 	This procedure selects the CSRs from a table by location
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectCSRsbyLocation] 

@strCSRSitein nvarchar(30)

AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strEDate nvarchar(8),
@strRole1 nvarchar(30),
@strRole2 nvarchar(30),
@strRole3 nvarchar(30),
@strRole4 nvarchar(30)


Set @strEDate = '99991231'
Set @strRole1 = 'WACS01'
Set @strRole2 = 'WACS02'
Set @strRole3 = 'WACS03'
Set @strRole4 = '%Engineer%'

SET @nvcSQL = 'SELECT [Emp_Name] + '' ('' + [Emp_LanID] + '') '' + [Emp_Job_Description] as FrontRow1
	  ,[Emp_Name] + ''$'' + [Emp_Email] + ''$'' + [Emp_LanID] + ''$'' + [Sup_Name] + ''$'' + [Sup_Email] + ''$'' + [Sup_LanID] + ''$'' + [Sup_Job_Description] + ''$'' + [Mgr_Name] + ''$'' + [Mgr_Email] + ''$'' + [Mgr_LanID] + ''$'' + [Mgr_Job_Description] as BackRow1, [Emp_Site]
       FROM [EC].[Employee_Hierarchy] WITH (NOLOCK)
where (([Emp_Job_Code] Like '''+@strRole1+''') OR ([Emp_Job_Code] Like '''+@strRole2+''') OR ([Emp_Job_Code] Like '''+@strRole3+''') OR ([Emp_Job_Description] Like '''+@strRole4+''')) 
and [End_Date] = ''99991231''
and [Emp_Site] = '''+@strCSRSitein+'''
and [Emp_LanID]is not NULL and [Sup_LanID] is not NULL and [Mgr_LanID]is not NULL
Order By [Emp_Site] ASC, [Emp_Name] ASC'

EXEC (@nvcSQL)	
	    
END -- sp_SelectCSRsbyLocation

GO

