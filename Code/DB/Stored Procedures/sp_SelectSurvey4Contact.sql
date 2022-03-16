IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectSurvey4Contact' 
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
--  TFS 7856 encryption/decryption - emp name, emp lanid, email
--  Updated survey expiration timeframe. TFS 24201 - 03/09/2022
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_SelectSurvey4Contact]
AS

BEGIN

DECLARE	
  @nvcSQL nvarchar(max),
  @strFormMail nvarchar (30);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 
 
SET @nvcSQL = '
SELECT srh.SurveyID	SurveyID	
  ,srh.FormName	FormName
  ,srh.Status Status
  ,veh.Emp_Email	EmpEmail
  ,veh.Emp_Name EmpName
  ,srh.CreatedDate CreatedDate
  ,CONVERT(VARCHAR(10), DATEADD(dd, 7, srh.CreatedDate), 101) ExpiryDate
  ,srh.EmailSent EmailSent
FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK)
JOIN [EC].[Survey_Response_Header] srh WITH (NOLOCK) ON veh.Emp_ID = srh.EmpID
WHERE srh.EmailSent = ''False''
ORDER BY srh.SurveyID';

EXEC (@nvcSQL)	

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];
	    
END --sp_SelectSurvey4Contact
GO



 