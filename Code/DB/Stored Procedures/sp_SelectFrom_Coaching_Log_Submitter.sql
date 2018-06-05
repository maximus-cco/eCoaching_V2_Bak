/*
sp_SelectFrom_Coaching_Log_Submitter(01).sql
Last Modified Date: 04/30/2018
Last Modified By: Susmitha Palacherla


Version 01: Document Initial Revision created during hist dashboard redesign.  TFS 7138 - 04/30/2018

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_Submitter' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_Submitter]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	04/23/2018
--	Description: *	This procedure selects a list of all Submitters 
-- This Procedure is only looking for Submitters of Active logs.
-- Created during Hist dashboard move to new architecture - TFS 7138 - 04/20/2018
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_Submitter] 


AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];




SET @nvcSQL = '
SELECT   X.SubmitterID, X.Submitter
FROM (
       SELECT ''-1'' SubmitterID, ''All Submitters'' Submitter,  01 Sortorder
       UNION
       SELECT DISTINCT sh.Emp_ID SubmitterID, vsh.Emp_Name Submitter,  02 Sortorder
       FROM [EC].[Coaching_Log] cl WITH(NOLOCK) JOIN  [EC].[Employee_Hierarchy] sh 
	   ON cl.[SubmitterID] = sh.[EMP_ID] JOIN  [EC].[View_Employee_Hierarchy] vsh WITH (NOLOCK) 
	   ON sh.[EMP_ID] = vsh.[EMP_ID]
	   WHERE cl.StatusID <> 2 
	   AND vsh.Emp_Name IS NOT NULL 
		 AND cl.SubmitterID  <> ''999999''
) X
ORDER BY X.Sortorder, X.Submitter'
		
EXEC (@nvcSQL)	
--PRINT @nvcSQL

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 

End --sp_SelectFrom_Coaching_Log_Submitter

GO



