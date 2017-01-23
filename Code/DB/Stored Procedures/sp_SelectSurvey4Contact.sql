/*
sp_SelectSurvey4Contact(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectSurvey4Contact' 
)
   DROP PROCEDURE [EC].[sp_SelectSurvey4Contact]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--	====================================================================
--	Author:		       Susmitha Palacherla
--	Create Date:	   8/21/2015
--	Description: 	   This procedure queries db for newly added Survey records to send out notification.
--  Created  per TFS 549 to setup CSR survey.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectSurvey4Contact]
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormMail nvarchar (30)

--Set @strFormMail = 'jourdain.augustin@gdit.com'
 
SET @nvcSQL = 'SELECT   SRH.SurveyID	SurveyID	
		,SRH.FormName	FormName
		,SRH.Status		Status
		,eh.Emp_Email	EmpEmail
		,eh.Emp_Name	EmpName
		,SRH.CreatedDate	CreatedDate
		,CONVERT(VARCHAR(10), DATEADD(dd,5,SRH.CreatedDate) , 101) ExpiryDate
		,SRH.EmailSent	EmailSent
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Survey_Response_Header] SRH WITH (NOLOCK)
ON eh.Emp_ID = SRH.EmpID
WHERE SRH.EmailSent = ''False''
Order By SRH.SurveyID'
--and [strCSREmail] = '''+@strFormMail+'''
EXEC (@nvcSQL)	
	    
END --sp_SelectSurvey4Contact





GO

