/*
Last Modified Date: 08/15/2018
Last Modified By: Susmitha Palacherla

Modified to support QN Bingo eCoaching logs. TFS 15063 - 08/15/2019
*/



IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectCoaching4Contact' 
)
   DROP PROCEDURE [EC].[sp_SelectCoaching4Contact]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:		       Jourdain Augustin
--	Create Date:	   6/10/2013
--	Description: 	   This procedure queries db for feed records to send out mail
--  Last Updated By: Susmitha Palacherla
--  last Modified date: 7/15/2016
--  Modified per TFS 644 to add extra attribute 'OMRARC' to support IAE, IAT Feeds -- 09/21/2015
--  Modified per TFS 2283 to add Source 210 for Training feed -- 3/22/2016
--  Modified per TFS 2268 to add Source 231 for CTC Quality Other feed - 6/15/2016
--  Modified per TFS 3179 & 3186 to add Source 218 for HFC & KUD Quality Other feeds - 7/15/2016
--  Modified to make allow more ad-hoc loads by adding more values to the file. TFS 4916 -12/9/2016
--  Modified to add condition for IQS(Quality logs) per TFS 5085 - 12/29/2016
--  Modified to add support for QS Lead Email for OMR Breaks feeds per TFS 6377 - 04/24/2017
--  TFS 7856 encryption/decryption - emp name, emp lanid, email
--  TFS 7137 Move dashboards to new architecture. Replaced Module with ModuleID - 06/22/2018
--  TFS 13332 Modified to add condition for Quality Now -  03/01/2019
--  Updated to exclude BQN logs to support QN Bingo eCoaching logs. TFS 15063 - 08/12/2019
-- --	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectCoaching4Contact]
AS

BEGIN

DECLARE	
  @nvcSQL nvarchar(max),
  @strFormStatus1 nvarchar(30),
  @strFormStatus2 nvarchar(30),
  @intSource1 int,
  @intSource2 int,
  @strFormType nvarchar(30),
  @strFormMail nvarchar(30);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 
 
SET @nvcSQL = '
SELECT cl.CoachingID numID	
  ,cl.FormName strFormID
  ,s.Status strFormStatus
  ,veh.Emp_Email strCSREmail
  ,veh.Sup_Email strCSRSupEmail
  ,CASE 
     WHEN cl.[strReportCode] LIKE ''LCS%'' THEN [EC].[fn_strEmpEmailFromEmpID](cl.[MgrID])
	 ELSE veh.Mgr_Email 
   END strCSRMgrEmail
  ,so.SubCoachingSource	strSource
  ,veh.Emp_Name strCSRName
  ,so.CoachingSource strFormType
  ,cl.SubmittedDate	SubmittedDate
  ,cl.CoachingDate CoachingDate
  ,cl.EmailSent	EmailSent
  ,cl.sourceid
  ,cl.isCSE
  ,cl.ModuleID
  ,CASE 
     WHEN SUBSTRING(cl.strReportCode, 1, 3) IN (''IAT'', ''IAE'') THEN 1 
	 ELSE 0 
   END OMRARC
FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK)
JOIN [EC].[Employee_Hierarchy] eh WITH (NOLOCK) ON eh.Emp_ID = veh.Emp_ID
JOIN [EC].[Coaching_Log] cl WITH (NOLOCK) ON eh.Emp_ID = cl.EMPID 
JOIN [EC].[DIM_Status] s ON s.StatusID = cl.StatusID 
JOIN [EC].[DIM_Source] so ON so.SourceID = cl.SourceID 
JOIN [EC].[DIM_Module] mo ON mo.ModuleID = cl.ModuleID 
WHERE S.Status NOT IN (''Completed'',''Inactive'')
  AND (cl.strReportCode IS NOT NULL OR cl.SourceID IN (211, 222, 223, 224, 230,235,236))
  AND ISNULL(cl.strReportCode, '''') NOT LIKE ''BQN%''
  AND cl.EmailSent = ''False''
  AND (
        (s.status =''Pending Acknowledgement'' AND veh.Emp_Email IS NOT NULL AND veh.Sup_Email IS NOT NULL AND veh.Sup_Email <> ''Unknown'')
        OR (s.Status =''Pending Supervisor Review'' AND veh.Sup_Email IS NOT NULL AND veh.Sup_Email <> ''Unknown'')
        OR ((s.Status =''Pending Manager Review'' OR s.Status =''Pending Sr. Manager Review'') AND veh.Mgr_Email IS NOT NULL AND veh.Mgr_Email <> ''Unknown'')
        OR (s.Status =''Pending Employee Review'' AND veh.Emp_Email IS NOT NULL AND veh.Emp_Email <> ''Unknown'')
        OR (s.Status =''Pending Quality Lead Review'' AND veh.Sup_Email IS NOT NULL AND veh.Sup_Email <> ''Unknown'')
      )
  AND LEN(cl.FormName) > 10
ORDER BY cl.SubmittedDate DESC';

EXEC (@nvcSQL)	

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];	
	    
PRINT @nvcsql	    
	    
END --sp_SelectCoaching4Contact
GO



