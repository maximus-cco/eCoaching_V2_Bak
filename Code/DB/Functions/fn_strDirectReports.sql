/*
fn_nvcHtmlDecode(01).sql
Last Modified Date: 08/21/2019
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 15144 - 08/21/2019

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strDirectReports' 
)
   DROP FUNCTION [EC].[fn_strDirectReports]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	=============================================
--	Author:		Susmitha Palacherla
--	Create Date: 08/19/2019
--	Description:	 
--  *  Given a Submitter ID, checks to see if the submitter has any direct Reports.
-- If they do, the function returns  a 'Yes' Else 'No'
-- Initial Revision- TFS 15144 - 08/19/2019
--	=============================================
CREATE FUNCTION [EC].[fn_strDirectReports] 
(
  @strSubmitterIDin nvarchar(20)

)
RETURNS nvarchar(10)
AS
BEGIN
 
	 DECLARE @intReportCount int,
	        @DirectReports nvarchar(10)
	

	SET @intReportCount = (SELECT COUNT(eh.emp_id) 
	                        FROM EC.Employee_Hierarchy eh
	                        WHERE eh.Active not in ('T', 'D')
                            AND eh.Sup_Id = @strSubmitterIDin)
	
	

    SET @DirectReports = 
	CASE WHEN @intReportCount > 0 THEN 'yes'
	ELSE 'No' END
      

   
RETURN @DirectReports
END --fn_strDirectReports

GO




