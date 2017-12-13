IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectSurvey4Reminder' 
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
--  TFS 7856 encryption/decryption - emp name, emp lanid, email
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectSurvey4Reminder]
AS

BEGIN

DECLARE	
  @intHrs int,
  @nvcSQL nvarchar(max);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 

SET @intHrs = 48;
 
SET @nvcSQL = '
SELECT srh.SurveyID	SurveyID	
  ,srh.FormName	FormName
  ,srh.Status Status
  ,veh.Emp_Email EmpEmail
  ,veh.Emp_Name EmpName
  ,srh.CreatedDate CreatedDate
  ,CONVERT(VARCHAR(10), DATEADD(dd, 5, srh.CreatedDate), 101) ExpiryDate
  ,srh.EmailSent EmailSent
FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
JOIN [EC].[Survey_Response_Header] srh WITH (NOLOCK) ON veh.Emp_ID = srh.EmpID
WHERE srh.[Status]= ''Open'' 
  AND DATEDIFF(HH, srh.[NotificationDate], GetDate()) > ''' + CONVERT(VARCHAR, @intHrs) + ''' 
ORDER BY srh.SurveyID';

EXEC (@nvcSQL)	

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];
	    
END --sp_SelectSurvey4Reminder
GO