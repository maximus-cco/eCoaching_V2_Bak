/*
sp_SelectCoaching4ContactOMRShortCalls(01).sql
Last Modified Date:  07/05/2019
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision. New logic for handling Short calls - TFS 14108 - 07/05/2019

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectCoaching4ContactOMRShortCalls' 
)
   DROP PROCEDURE [EC].[sp_SelectCoaching4ContactOMRShortCalls]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
-- Author:		        Susmitha Palacherla
-- Create date:        07/05/2019
-- Selects short call records for CSR Notification
-- Initial Revision - TFS 14108 - 07/05/2019
-- --	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectCoaching4ContactOMRShortCalls]
AS

BEGIN

DECLARE	
  @intHrs int,
  @nvcSQL nvarchar(max)
--AND DATEDIFF(HH, [NotificationDate], GetDate()) < ''' + CONVERT(VARCHAR, @intHrs) + '''  
--SET @intHrs =1
-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 
 
SET @nvcSQL = '
SELECT cl.CoachingID numID	
  ,cl.FormName strFormID
  ,s.Status strFormStatus
  ,veh.Emp_Email strCSREmail
  ,veh.Emp_Name strCSRName
FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK)
JOIN [EC].[Employee_Hierarchy] eh WITH (NOLOCK) ON eh.Emp_ID = veh.Emp_ID
JOIN [EC].[Coaching_Log] cl WITH (NOLOCK) ON eh.Emp_ID = cl.EMPID 
JOIN [EC].[DIM_Status] s ON s.StatusID = cl.StatusID 
WHERE S.StatusID  = 6
AND SUBSTRING(strReportCode, 1, 3) = ''ISQ'' 
AND cl.EmailSent = ''False''
AND  veh.Emp_Email IS NOT NULL
AND LEN(cl.FormName) > 10
ORDER BY cl.SubmittedDate DESC';

EXEC (@nvcSQL)	

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];	
	    
PRINT @nvcsql	    
	    
END --sp_SelectCoaching4ContactOMRShortCalls
GO

