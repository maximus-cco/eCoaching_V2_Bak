/*
sp_SelectSurvey4Reminder(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectSurvey4Reminder' 
)
   DROP PROCEDURE [EC].[sp_SelectSurvey4Reminder]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:		       Susmitha Palacherla
--	Create Date:	   2/25/2016
--	Description: This procedure queries db for surveys active after 48 hrs to send reminders.
--  Created  per TFS 2052 to setup reminders for CSR survey.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectSurvey4Reminder]
AS

BEGIN
DECLARE	
@intHrs int,
@nvcSQL nvarchar(max)


SET @intHrs = 48 
 
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
WHERE  SRH.[Status]= ''Open''
AND DATEDIFF(HH,SRH.[NotificationDate],GetDate()) > '''+CONVERT(VARCHAR,@intHrs)+''' 
Order By SRH.SurveyID'

EXEC (@nvcSQL)	
	    
END --sp_SelectSurvey4Reminder

GO

