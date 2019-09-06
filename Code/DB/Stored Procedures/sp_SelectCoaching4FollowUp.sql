/*
sp_SelectCoaching4FollowUp(01).sql
Last Modified Date: 09/03/2019
Last Modified By: Susmitha Palacherla


Version 01:  Initial Revision. Follow-up process for eCoaching submissions - TFS 13644 -  09/03/2019

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectCoaching4FollowUp' 
)
   DROP PROCEDURE [EC].[sp_SelectCoaching4FollowUp]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:		       Susmitha Palacherla
--	Create Date:	   09/03/2019
--	Description: 	   This procedure queries db for logs due for followup and sends a notification alert to supervisors.
--  Initial Revision. Incorporate a follow-up process for eCoaching submissions - TFS 13644 -  09/03/2019
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectCoaching4FollowUp]
AS

BEGIN

DECLARE	
  @nvcSQL nvarchar(max)


-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 
 
SET @nvcSQL = '
SELECT cl.CoachingID numID	
  ,cl.FormName strFormID
  ,veh.Sup_Email strCSRSupEmail
  --,''susmithacpalacherla@maximus.com'' strCSRSupEmail
  ,veh.Emp_Name strCSRName
FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK)
JOIN [EC].[Employee_Hierarchy] eh WITH (NOLOCK) ON eh.Emp_ID = veh.Emp_ID
JOIN [EC].[Coaching_Log] cl WITH (NOLOCK) ON eh.Emp_ID = cl.EMPID 
WHERE cl.Statusid = 10
AND DATEADD(day, DATEDIFF(day, 0, cl.FollowupDueDate), 0) = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)
AND (veh.Sup_Email IS NOT NULL AND veh.Sup_Email <> ''Unknown'')
';

EXEC (@nvcSQL)	

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];	
	    
PRINT @nvcsql	    
	    
END --sp_SelectCoaching4FollowUp

GO

