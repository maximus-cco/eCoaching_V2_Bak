/*
sp_Select_ReasonNotCoachable_By_ReportCode(01).sql
Last Modified Date: 06/12/2018
Last Modified By: Susmitha Palacherla


Version 01: Document Initial Revision created during My dashboard redesign.  TFS 7137 - 05/28/2018

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Reasons_By_ReportCode' 
)
   DROP PROCEDURE [EC].[sp_Select_Reasons_By_ReportCode]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	06/12/2108
--	Description: *	This procedure takes a ReportCode and returns the list of Reasons.
-- Last Modified By: Susmitha Palacherla
-- Created during My Dashboard move to new architecture - TFS 7137 - 06/12/2018
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Reasons_By_ReportCode] 
@nvcReportCode nvarchar(20)

AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max)
	


SET @nvcSQL = 'Select [Reason] FROM [EC].[Reasons_By_ReportCode]
WHERE [ReportCode] = '''+ @nvcReportCode  +'''
ORDER BY CASE WHEN [Reason] = ''Other'' THEN 1 ELSE 0 END, [Reason]'


--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_Reasons_By_ReportCode
GO



