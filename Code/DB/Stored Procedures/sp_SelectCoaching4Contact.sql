/*
sp_SelectCoaching4Contact(02).sql
Last Modified Date: 4/24/2017
Last Modified By: Susmitha Palacherla

Version 02: support for QS Lead Email for OMR Breaks feeds per TFS 6377 - 04/24/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectCoaching4Contact' 
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
-- Last Updated By: Susmitha Palacherla
-- last Modified date: 7/15/2016
-- Modified per TFS 644 to add extra attribute 'OMRARC' to support IAE, IAT Feeds -- 09/21/2015
-- Modified per TFS 2283 to add Source 210 for Training feed -- 3/22/2016
-- Modified per TFS 2268 to add Source 231 for CTC Quality Other feed - 6/15/2016
-- Modified per TFS 3179 & 3186 to add Source 218 for HFC & KUD Quality Other feeds - 7/15/2016
-- Modified to make allow more ad-hoc loads by adding more values to the file. TFS 4916 -12/9/2016
-- Modified to add condition for IQS(Quality logs)per TFS 5085 - 12/29/2016
-- Modified to add support for QS Lead Email for OMR Breaks feeds - 04/24/2017
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
@strFormMail nvarchar (30)

 --Set @strFormStatus1 = 'Completed'
 --Set @strFormStatus2 = 'Inactive'


 --Set @strFormType = 'Indirect'
--Set @strFormMail = 'jourdain.augustin@gdit.com'
 
SET @nvcSQL = 'SELECT   cl.CoachingID	numID	
		,cl.FormName	strFormID
		,s.Status		strFormStatus
		,eh.Emp_Email	strCSREmail
		,eh.Sup_Email	strCSRSupEmail
		,CASE WHEN cl.[strReportCode] like ''LCS%'' 
		 THEN [EC].[fn_strEmpEmailFromEmpID](cl.[MgrID])
		 ELSE eh.Mgr_Email END	strCSRMgrEmail
		,so.SubCoachingSource	strSource
		,eh.Emp_Name	strCSRName
		,so.CoachingSource	strFormType
		,cl.SubmittedDate	SubmittedDate
		,cl.CoachingDate	CoachingDate
		,cl.EmailSent	EmailSent
		,cl.sourceid
		,cl.isCSE
		,mo.Module
		,CASE WHEN SUBSTRING(cl.strReportCode,1,3)in (''IAT'',''IAE'')
		THEN 1 ELSE 0 END OMRARC	
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH (NOLOCK)
ON eh.Emp_ID = cl.EMPID JOIN [EC].[DIM_Status] s 
ON s.StatusID = cl.StatusID JOIN [EC].[DIM_Source] so
ON so.SourceID = cl.SourceID JOIN [EC].[DIM_Module] mo
ON mo.ModuleID = cl.ModuleID 
WHERE S.Status not in (''Completed'',''Inactive'')
AND (cl.strReportCode is not NULL OR cl.SourceID in (211,222,223,224,230))
AND cl.EmailSent = ''False''
AND ((s.status =''Pending Acknowledgement'' and eh.Emp_Email is NOT NULL and eh.Sup_Email is NOT NULL and eh.Sup_Email <> ''Unknown'')
OR (s.Status =''Pending Supervisor Review'' and eh.Sup_Email is NOT NULL and eh.Sup_Email <> ''Unknown'')
OR ((s.Status =''Pending Manager Review'' OR s.Status =''Pending Sr. Manager Review'') and eh.Mgr_Email is NOT NULL and eh.Mgr_Email <> ''Unknown'')
OR (s.Status =''Pending Employee Review'' and eh.Emp_Email is NOT NULL and eh.Emp_Email <> ''Unknown'')
OR (s.Status =''Pending Quality Lead Review'' and eh.Sup_Email is NOT NULL and eh.Sup_Email <> ''Unknown''))
AND LEN(cl.FormName) > 10
Order By cl.SubmittedDate DESC'
--and [strCSREmail] = '''+@strFormMail+'''
EXEC (@nvcSQL)	
	    
--PRINT @nvcsql	    
	    
END --sp_SelectCoaching4Contact





GO



