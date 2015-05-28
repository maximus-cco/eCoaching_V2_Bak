/*
eCoaching_Log_Create(17).sql
Last Modified Date: 02/16/2015
Last Modified By: Susmitha Palacherla

Version 17:
Updates to [EC].[sp_SelectFrom_Coaching_Log_HistoricalSUP](SP # 6) to support warnings 
display for HR job codes per SCR 14065.


Version 16:
Additional post V&V Updates to support Compliance ETS Reports per SCR 14031.
1.Update to procedure #50.

Version 15:
Updates to support Compliance ETS Reports per SCR 14031.
1.Update to procedures #45 and #50.


Version 14:
1. Update to  [EC].[sp_Select_Modules_By_Job_Code] (SP # 56 ) to support LSA Module
 SCR 13653


Version 13:
Post V&V Updates for SCR 13891
1.Update to Review SP (update2) #s 47


Version 12:
Updates for SCr 13891
1. Update to Table #1 Coaching_log to add 2 new fields.
2. Update to insert into coaching log sp #1 to add supid and mgrid at time of submission
3.Update to Review SPs #s 46,47,48,50,52 to capture Reviewer ID.
4. Update to select for review sp #  45 to add Reviewer Name to the return.


Version 11:
1. Update to 1 procedure (SP # 56) to set warning flag for supervisors to 1.
  (Modules by job code)SCR 13542

Version 10:
1. Update 1 procedure (SP # 8) to add source filter that was
  discovered to be missing during testing for SCR 13659.

Version 09:
1. Additional Update to (SP # 47) to update MgrReviewAutoDate and MgrNotes
   fields for Manager updates.  per SCR 13631.
2. Additional Update to (SP # 62) to replace'Other' as a SubCoaching Reason 
   for Progressive Warnings functionality with Other Policy (non-Security/Privacy) per SCR 13479. 
3. Changes for SCR 13659- ETS Feed Load
    Altered table Coaching_Log to add 2 additional columns. SupID and MgrID.
4. Modified (SP # 17) to allow acting managers to review Pending supervisor
   review eCLs per SCR 13794.


Version 08:
1. Additonal Update to (SP # 62) to support 'Other' as a SubCoaching Reason 
   for Progressive Warnings functionality per SCR 13479.


Version 07:
1. Updated 1 procedures to support ETS as a SubCoaching Reason 
   for Progressive Warnings functionality per SCR 13479.(SP # 62).
  

Version 06:
1. Updated 2 procedures to support Progressive Warnings functionality
    per SCR 13479.(SP #'s 56 and 60).
  

Version 05:
1. Updated sp_Select_CallID_By_Module(61) to remove sort order per program request.

Version 04:
1. Added several new procedures and modified existing procedures to
   support the modular design to add 2 new Supervisor and Quality Modules.
   All references to CSRID and CSR were updated to EmpID and EmpLanID respectively.

Version 03:
1. Updated [EC].[sp_SelectFrom_Coaching_Log_HistoricalSUP] (6)  per SCR 13265 
    to group multiple coaching reasons and display total count per eCL in dashboards.

Version 02: 
1.  Updated per SCR 13054 to Import additional attribute VerintFormName
     Updated impacted tables to add new Column and Stored procedures
      Table [EC].[Coaching_Log] and SP [EC].[sp_InsertInto_Coaching_Log](1)
2.  Updated per SCR 12930 to display VerintFormName on Review dashboard.
      [EC].[sp_SelectReviewFrom_Coaching_Log] (45)
3.  Updated per SCR 13138 to support insertion of Quality logs from web interface.
     SP [EC].[sp_InsertInto_Coaching_Log]
4. Updated sp [EC].[sp_Update5Review_Coaching_Log] (50) per SCR 13213 to 
    add Coaching Reason 'OMR / Exceptions' to the filter criteria for the review page.

Version 01: Initial Revision 

******************************************************************/


--4. Create SP  [EC].[sp_SelectFrom_Coaching_Log_CSRCompleted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_CSRCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_CSRCompleted]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
-- Last Modified Date: 08/20/2014
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSR and CSRID to EmpLanID and EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_CSRCompleted] @strCSRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

 Set @strFormStatus = 'Completed'

SET @nvcSQL = 'SELECT [cl].[FormName] strFormID,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName,
		[eh].[Mgr_Name]	strCSRMgrName,
		[S].[Status]	strFormStatus,
		[cl].[SubmittedDate] SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and eh.[Emp_LanID] = '''+@strCSRin+'''
and [S].[Status] = '''+@strFormStatus+'''
Order By [cl].[SubmittedDate] DESC'

		
EXEC (@nvcSQL)	
END -- sp_SelectFrom_Coaching_Log_CSRCompleted


GO




--******************************************************************

--5. Create SP  [EC].[sp_SelectFrom_Coaching_Log_CSRPending]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_CSRPending' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_CSRPending]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSR and CSRID to EmpLanID and EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_CSRPending] @strCSRin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30)


 Set @strFormStatus = 'Pending Employee Review'
 Set @strFormStatus2 = 'Pending Acknowledgement'

SET @nvcSQL = 'SELECT [cl].[FormName] strFormID,
		[eh].[Emp_Name]	strCSRName,
		[S].[Status]	strFormStatus,
		[cl].[SubmittedDate] SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and eh.[Emp_LanID] = '''+@strCSRin+'''
and ([S].[Status] = '''+@strFormStatus+''' or [S].[Status] = '''+@strFormStatus2+''')
Order By [cl].[SubmittedDate] DESC'

		
EXEC (@nvcSQL)	
	    
END -- sp_SelectFrom_Coaching_Log_CSRPending


GO




--******************************************************************

--6. Create SP  [EC].[sp_SelectFrom_Coaching_Log_HistoricalSUP]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_HistoricalSUP' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_HistoricalSUP]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	4/30/12
--	Description: *	This procedure selects the CSR e-Coaching completed records to display on SUP historical page
-- Last Modified Date: 02/10/2015
-- Last Updated By: Susmitha Palacherla
-- Modified per SCR 14065 to add warning sections for HR display.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_HistoricalSUP] 

@strSourcein nvarchar(100),
@strCSRSitein nvarchar(30),
@strCSRin nvarchar(30),
@strSUPin nvarchar(30),
@strMGRin nvarchar(30),
@strSDatein datetime,
@strEDatein datetime,
@strIsOpp nvarchar(8),
@strStatusin nvarchar(30), 
@strIsForce nvarchar(8),
@strjobcode  nvarchar(20)

AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@nvcSQL1 nvarchar(max),
@nvcSQL2 nvarchar(20),
@nvcSQL3 nvarchar(max),
@nvcSQL4 nvarchar(100),
@strFormStatus nvarchar(30),
--@strFormStatus2 nvarchar(30),
--@strFormStatus3 nvarchar(30),
--@strFormStatus4 nvarchar(30),
@strSDate nvarchar(8),
@strEDate nvarchar(8)


Set @strFormStatus = 'Inactive'
--Set @strFormStatus2 = 'Pending CSR Review'
--Set @strFormStatus3 = 'Pending Supervisor Review'
--Set @strFormStatus4 = 'Pending Manager Review'

Set @strSDate = convert(varchar(8),@strSDatein,112)
Set @strEDate = convert(varchar(8),@strEDatein,112)


SET @nvcSQL1 = 'select	 x.strFormID
		,x.strCSRName
		,x.strCSRSupName
		,x.strCSRMgrName
		,x.strFormStatus
		,x.strSource
		,x.SubmittedDate
		,x.strSubmitterName
		,x.numOpportunity
		,x.numReinforcement
		,x.orderkey
from (
SELECT [cl].[FormName]	strFormID
		,[eh].[Emp_Name]	strCSRName
		,[eh].[Sup_Name]	strCSRSupName
		,[eh].[Mgr_Name]	strCSRMgrName
		,[s].[Status]		strFormStatus
		,[so].[SubCoachingSource]	strSource
		,[cl].[SubmittedDate]	SubmittedDate
		,[sh].[Emp_Name]	strSubmitterName
		,SUM(case when [clr].[Value] = ''Opportunity'' THEN 1 ELSE 0 END) numOpportunity
		,SUM(case when [clr].[Value] = ''Reinforcement'' THEN 1 ELSE 0 END) numReinforcement
		,''ok1'' orderkey
		FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK)
ON cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh
ON cl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s
ON cl.StatusID = s.StatusID JOIN [EC].[DIM_Source] so
ON cl.SourceID = so.SourceID JOIN [EC].[DIM_Site] si
ON cl.SiteID = si.SiteID JOIN  [EC].[Coaching_Log_Reason] clr
ON cl.CoachingID = clr.CoachingID
WHERE [so].[SubCoachingSource] Like '''+@strSourcein+'''
and [s].[Status] Like '''+@strStatusin+'''
AND ISNULL([eh].[Emp_Name], '' '') LIKE '''+@strCSRin+''' 
AND ISNULL([eh].[Sup_Name], '' '') LIKE '''+@strSUPin+''' 
AND ISNULL([eh].[Mgr_Name], '' '') LIKE '''+@strMGRin+''' 
and ISNULL([si].[City], '' '') LIKE '''+@strCSRSitein+'''
and convert(varchar(8),[cl].[SubmittedDate],112) >= '''+@strSDate+'''
and convert(varchar(8),[cl].[SubmittedDate],112) <= '''+@strEDate+'''
and [s].[Status] <> '''+@strFormStatus+'''
GROUP BY [cl].[FormName],[eh].[Emp_Name],[eh].[Sup_Name],[eh].[Mgr_Name],
[s].[Status],[so].[SubCoachingSource],[cl].[SubmittedDate],[sh].[Emp_Name]
) x
where ISNULL(x.numOpportunity, '' '') LIKE '''+@strIsOpp+'''
and ISNULL(x.numReinforcement, '' '') LIKE '''+@strIsForce+''''


SET @nvcSQL2 = ' UNION ALL '

SET @nvcSQL3 = 'select	 x.strFormID
		,x.strCSRName
		,x.strCSRSupName
		,x.strCSRMgrName
		,x.strFormStatus
		,x.strSource
		,x.submitteddate
		,x.strSubmitterName
		,x.numOpportunity
		,x.numReinforcement
		,x.orderkey
from (
SELECT [wl].[FormName]	strFormID
		,[eh].[Emp_Name]	strCSRName
		,[eh].[Sup_Name]	strCSRSupName
		,[eh].[Mgr_Name]	strCSRMgrName
		,[s].[Status]		strFormStatus
		,[so].[SubCoachingSource]	strSource
		,[wl].[SubmittedDate]	submitteddate
		,[sh].[Emp_Name]	strSubmitterName
		,SUM(case when [wlr].[Value] = ''Opportunity'' THEN 1 ELSE 0 END) numOpportunity
		,SUM(case when [wlr].[Value] = ''Reinforcement'' THEN 1 ELSE 0 END) numReinforcement
		,''ok2'' orderkey
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Warning_Log] wl WITH(NOLOCK)
ON wl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh
ON wl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s
ON wl.StatusID = s.StatusID JOIN [EC].[DIM_Source] so
ON wl.SourceID = so.SourceID JOIN [EC].[DIM_Site] si
ON wl.SiteID = si.SiteID JOIN  [EC].[Warning_Log_Reason] wlr
ON wl.WarningID = wlr.WarningID
WHERE [so].[SubCoachingSource] Like '''+@strSourcein+'''
and [s].[Status] Like '''+@strStatusin+'''
AND ISNULL([eh].[Emp_Name], '' '') LIKE '''+@strCSRin+''' 
AND ISNULL([eh].[Sup_Name], '' '') LIKE '''+@strSUPin+''' 
AND ISNULL([eh].[Mgr_Name], '' '') LIKE '''+@strMGRin+''' 
and ISNULL([si].[City], '' '') LIKE '''+@strCSRSitein+'''
and convert(varchar(8),[wl].[SubmittedDate],112) >= '''+@strSDate+'''
and convert(varchar(8),[wl].[SubmittedDate],112) <= '''+@strEDate+'''
and [s].[Status] <> '''+@strFormStatus+'''
GROUP BY [wl].[FormName],[eh].[Emp_Name],[eh].[Sup_Name],[eh].[Mgr_Name],
[s].[Status],[so].[SubCoachingSource],[wl].[SubmittedDate],[sh].[Emp_Name]
) x
where ISNULL(x.numOpportunity, '' '') LIKE '''+@strIsOpp+'''
and ISNULL(x.numReinforcement, '' '') LIKE '''+@strIsForce+''''


 SET @nvcSQL4 = ' ORDER BY orderkey, submitteddate desc'

IF @strjobcode in ('WHER13', 'WHER50',
'WHHR12', 'WHHR13', 'WHHR14',
'WHHR50', 'WHHR60', 'WHHR80')

SET @nvcSQL = @nvcSQL1 + @nvcSQL2 +  @nvcSQL3 + @nvcSQL4

ELSE

SET @nvcSQL = @nvcSQL1 + @nvcSQL4

EXEC (@nvcSQL)	

--PRINT @nvcSQL
	    
END -- sp_SelectFrom_Coaching_Log_HistoricalSUP



GO









--******************************************************************


--7. Create SP  [EC].[sp_SelectFrom_Coaching_Log_MGRCSRCompleted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MGRCSRCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MGRCSRCompleted]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the CSR e-Coaching records from the Coaching_Log table
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSR and CSRID to EmpLanID and EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MGRCSRCompleted] 

@strSourcein nvarchar(100),
@strCSRMGRin nvarchar(30),
@strCSRSUPin nvarchar(30),
@strCSRin nvarchar(30),
@strSDatein datetime,
@strEDatein datetime
 
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strSDate nvarchar(8),
@strEDate nvarchar(8)

Set @strFormStatus = 'Completed'
Set @strSDate = convert(varchar(8),@strSDatein,112)
Set @strEDate = convert(varchar(8),@strEDatein,112)
 

SET @nvcSQL = 'SELECT	[cl].[FormName]	strFormID,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName, 
		[eh].[Mgr_Name]	strCSRMgrName, 
		[s].[Status]	strFormStatus,
		[sc].[SubCoachingSource]	strSource,
		[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[DIM_Source] sc,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where [cl].[EmpID] = [eh].[Emp_ID]
and [cl].[StatusID] = [s].[StatusID]
and [cl].[SourceID] = [sc].[SourceID]
and [eh].[Mgr_LanID] = '''+@strCSRMGRin+'''
and [S].[Status] = '''+@strFormStatus+'''
and [sc].[SubCoachingSource] Like '''+@strSourcein+'''
and [eh].[Emp_Name] Like '''+@strCSRin+'''
and [eh].[Sup_Name] Like  '''+@strCSRSUPin+''' 
and convert(varchar(8),[cl].[SubmittedDate],112) >= '''+@strSDate+'''
and convert(varchar(8),[cl].[SubmittedDate],112) <= '''+@strEDate+'''
Order By [cl].[SubmittedDate] DESC'
	
EXEC (@nvcSQL)	
	   
END --sp_SelectFrom_Coaching_Log_MGRCSRCompleted


GO





--******************************************************************

--8. Create SP  [EC].[sp_SelectFrom_Coaching_Log_MGRCSRPending]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MGRCSRPending' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MGRCSRPending]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the CSR e-Coaching records from the Coaching_Log table
-- Where the status is Prnding Review. 
-- Last Modified Date: 11/19/2014
-- Last Updated By: Susmitha Palacherla
-- Modified to add missing Source filter discovered during testing for SCR 13659.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MGRCSRPending] 

@strCSRMGRin nvarchar(30),
@strCSRSUPin nvarchar(30),
@strSourcein nvarchar(100),
@strCSRin nvarchar(30) 

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max)




SET @nvcSQL = 'SELECT [cl].[FormName]	strFormID,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName, 
		[eh].[Mgr_Name]	strCSRMgrName, 
		[s].[Status]	strFormStatus,
		[sc].[SubCoachingSource] strSource,
		[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[DIM_Source] sc,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where [cl].[EmpID] = [eh].[Emp_ID]
and [cl].[StatusID] = [s].[StatusID]
and [cl].[SourceID] = [sc].[SourceID]  
and [eh].[Mgr_LanID] = '''+@strCSRMGRin+'''
and [S].[Status] like ''Pending%''
and [sc].[SubCoachingSource] Like '''+@strSourcein+'''
and [eh].[Emp_Name] Like '''+@strCSRin+'''
and [eh].[Sup_Name] Like '''+@strCSRSUPin+'''
Order By [SubmittedDate] DESC'
		
EXEC (@nvcSQL)	   
END --sp_SelectFrom_Coaching_Log_MGRCSRPending

GO






--******************************************************************


--9. Create SP  [EC].[sp_SelectFrom_Coaching_Log_MGRPending]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MGRPending' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MGRPending]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the CSR e-Coaching records from the Coaching_Log table
-- Where the status is Pending Review. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename  CSRID to EmpID to support the Modular design.
--	=====================================================================

CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MGRPending] 
@strCSRMGRin nvarchar(30),
@strCSRin nvarchar(30),
@strCSRSUPin nvarchar(30) 

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus1 nvarchar(50),
@strFormStatus2 nvarchar(50),
@strFormStatus3 nvarchar(50),
@strFormStatus4 nvarchar(50),
@strFormStatus5 nvarchar(50),
@strFormStatus6 nvarchar(50)


 Set @strFormStatus1 = 'Pending Manager Review'
 Set @strFormStatus2 = 'Pending Supervisor Review'
 Set @strFormStatus3 = 'Pending Acknowledgement'
 Set @strFormStatus4 = 'Pending Sr. Manager Review'
 Set @strFormStatus5 = 'Pending Deputy Program Manager Review'
 Set @strFormStatus6 = 'Pending Quality Lead Review'

SET @nvcSQL = 'SELECT [cl].[FormName]	strFormID,
		[eh].[Emp_LanID] strCSR,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName, 
		[s].[Status]	strFormStatus,
		[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where [cl].[EmpID] = [eh].[Emp_ID]
and [cl].[StatusID] = [s].[StatusID]
and ((([eh].[Mgr_LanID] =  '''+@strCSRMGRin+''') and ([S].[Status] = '''+@strFormStatus1+''' OR [S].[Status] = '''+@strFormStatus4+''' OR [S].[Status] = '''+@strFormStatus5+''')) 
OR (([eh].[Sup_LanID] =  '''+@strCSRMGRin+''') and ([S].[Status] = '''+@strFormStatus1+''' OR [S].[Status] = '''+@strFormStatus2+''' OR [S].[Status] = '''+@strFormStatus3+''' OR [S].[Status] = '''+@strFormStatus6+''')))
and [eh].[Emp_Name] Like '''+@strCSRin+'''
and [eh].[Sup_Name] Like '''+@strCSRSUPin+'''
Order By [SubmittedDate] DESC'
		
EXEC (@nvcSQL)	
--Print @nvcsql
	    
END -- sp_SelectFrom_Coaching_Log_MGRPending




GO




--******************************************************************


--10. Create SP  [EC].[sp_SelectFrom_Coaching_Log_MyCompSubmitted_DashboardStaff]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MyCompSubmitted_DashboardStaff' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MyCompSubmitted_DashboardStaff]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the support staff's submitted comopleted records from the Coaching_Log table and displayed on dashboard
-- Where the user's LAN is strSubmitter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename  CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MyCompSubmitted_DashboardStaff] 
@strUserin nvarchar(30),
@strCSRin nvarchar(30), 
@strCSRSupin nvarchar(30),
@strCSRMgrin nvarchar(30) 

AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

 Set @strFormStatus = 'Completed'

SET @nvcSQL = 'SELECT [cl].[FormName]	strFormID
		,[s].[Status]	strFormStatus
		,[eh].[Emp_Name]	strCSRName
		,[eh].[Sup_Name]	strCSRSupName
		,[eh].[Mgr_Name]	strCSRMgrName
		,[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
WHERE cl.EmpID = eh.Emp_ID
AND cl.StatusID = s.StatusID
AND cl.SubmitterID = sh.EMP_ID 
AND sh.Emp_LanID = '''+@strUserin+''' 
AND [eh].[Emp_Name]= '''+@strCSRin+''' 
AND [eh].[Sup_Name]= '''+@strCSRSupin+''' 
AND [eh].[Mgr_Name]= '''+@strCSRMgrin+''' 
and s.[Status] <> '''+@strFormStatus+'''
Order By [cl].[SubmittedDate] DESC'

		
EXEC (@nvcSQL)	
	    
END -- sp_SelectFrom_Coaching_Log_MyCompSubmitted_DashboardStaff


GO






--******************************************************************


--11. Create SP  [EC].[sp_SelectFrom_Coaching_Log_MyPenSubmitted_DashboardStaff]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MyPenSubmitted_DashboardStaff' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MyPenSubmitted_DashboardStaff]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the support staff's submitted pending records from the Coaching_Log table and displayed on dashboard
-- Where the user's LAN is strSubmitter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename  CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MyPenSubmitted_DashboardStaff] 
@strUserin nvarchar(30),
@strCSRin nvarchar(30), 
@strCSRSupin nvarchar(30),
@strCSRMgrin nvarchar(30) 

AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30),
@strFormStatus3 nvarchar(30)


 Set @strFormStatus = 'Pending Employee Review'
 Set @strFormStatus2 = 'Pending Manager Review'
 Set @strFormStatus3 = 'Pending Supervisor Review'


SET @nvcSQL = 'SELECT
		 cl.FormName	strFormID
		,S.Status	strFormStatus
		,eh.Emp_Name	strCSRName
		,eh.Sup_Name	strCSRSupName
		,eh.Mgr_Name	strCSRMgrName
		,cl.SubmittedDate	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.SubmitterID = sh.Emp_ID
and sh.Emp_LanID = '''+@strUserin+''' 
and eh.Emp_Name Like '''+@strCSRin+'%''
and eh.Sup_Name Like '''+@strCSRSupin+'%''
and eh.Mgr_Name Like '''+@strCSRMgrin+'%''
and ((S.Status = '''+@strFormStatus+''') or (S.Status = '''+@strFormStatus2+''') or (S.Status = '''+@strFormStatus3+'''))
Order By cl.SubmittedDate DESC'

		
EXEC (@nvcSQL)	
	    
END --sp_SelectFrom_Coaching_Log_MyPenSubmitted_DashboardStaff


GO






--******************************************************************


--12. Create SP  [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_Dashboard]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MySubmitted_Dashboard' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_Dashboard]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the user's recent submitted records from the Coaching_Log table and displayed on dashboard (includes completed)
-- Where the user's LAN is strSubmitter.
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename  CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_Dashboard] 
@strUserin nvarchar(30)

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'


SET @nvcSQL = 'SELECT [cl].[FormName]	strFormID,
		[s].[Status]	strFormStatus,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName,
		[eh].[Mgr_Name]	strCSRMgrName,
		[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strUserin+''' 
and s.[Status] <> '''+@strFormStatus+'''
Order By [cl].[SubmittedDate] DESC'
		
EXEC (@nvcSQL)	
    
END --sp_SelectFrom_Coaching_Log_MySubmitted_Dashboard


GO

--******************************************************************

--13. Create SP  [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_DashboardMGR]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MySubmitted_DashboardMGR' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_DashboardMGR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the Supervisor user's submitted records from the Coaching_Log table and displayed on dashboard (includes completed)
--  Where the user's LAN is strSubmitter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_DashboardMGR] 
@strUserin nvarchar(30),
@strCSRin nvarchar(30), 
@strCSRSupin nvarchar(30),
@strCSRMgrin nvarchar(30), 
@strStatusin nvarchar(30) 

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'

SET @nvcSQL = 'SELECT  cl.[FormName] strFormID,
		s.[Status]	strFormStatus,
		eh.[Emp_Name]	strCSRName,
		eh.[Sup_Name]	strCSRSupName,
		eh.[Mgr_Name]	strCSRMgrName,
		cl.[SubmittedDate] SubmittedDate
from EC.Coaching_Log cl WITH(NOLOCK),
	EC.Employee_Hierarchy eh,
	EC.DIM_Status s
where cl.StatusID = s.StatusID
and cl.EmpID = eh.Emp_ID
and cl.submitterID = (
select sh.emp_ID
from EC.Employee_Hierarchy sh
where sh.emp_LanID = '''+@strUserin+''')
and eh.[Emp_Name] LIKE '''+@strCSRin+'''
and eh.[Sup_Name] LIKE '''+@strCSRSupin+'''
and eh.[Mgr_Name] LIKE '''+@strCSRMgrin+'''
and s.[Status] LIKE '''+@strStatusin+'''
and s.[Status] <> '''+@strFormStatus+'''

Order by cl.[SubmittedDate] DESC'

		
EXEC (@nvcSQL)	
	    
END --sp_SelectFrom_Coaching_Log_MySubmitted_DashboardMGR


GO





--******************************************************************


--14. Create SP  [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_DashboardSUP]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MySubmitted_DashboardSUP' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_DashboardSUP]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the Supervisor user's submitted records from the Coaching_Log table and displayed on dashboard (includes completed)
-- Where the user's LAN is strSubmitter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_DashboardSUP] 
@strUserin nvarchar(30),
@strCSRin nvarchar(30), 
@strCSRSupin nvarchar(30),
@strCSRMgrin nvarchar(30), 
@strStatusin nvarchar(30) 

AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'


SET @nvcSQL = 'SELECT  cl.[FormName] strFormID,
		s.[Status]	strFormStatus,
		eh.[Emp_Name]	strCSRName,
		eh.[Sup_Name]	strCSRSupName,
		eh.[Mgr_Name]	strCSRMgrName,
		cl.[SubmittedDate] SubmittedDate
from EC.Coaching_Log cl WITH(NOLOCK),
	EC.Employee_Hierarchy eh,
	EC.DIM_Status s
where cl.StatusID = s.StatusID
and cl.EmpID = eh.Emp_ID
and cl.submitterID = (
select sh.emp_ID
from EC.Employee_Hierarchy sh
where sh.emp_LanID = '''+@strUserin+''')
and eh.[Emp_Name] LIKE '''+@strCSRin+'''
and eh.[Sup_Name] LIKE '''+@strCSRSupin+'''
and eh.[Mgr_Name] LIKE '''+@strCSRMgrin+'''
and s.[Status] LIKE '''+@strStatusin+'''
and s.[Status] <> '''+@strFormStatus+'''
Order by cl.[SubmittedDate] DESC'
	
EXEC (@nvcSQL)	
	    
END --sp_SelectFrom_Coaching_Log_MySubmitted_DashboardSUP


GO






--******************************************************************

--15. Create SP  [EC].[sp_SelectFrom_Coaching_Log_SUPCSRCompleted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_SUPCSRCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SUPCSRCompleted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the SUP e-Coaching records from the Coaching_Log table
-- Where the status is Completed. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SUPCSRCompleted] 
@strSourcein nvarchar(100),
@strCSRSUPin nvarchar(30),
@strCSRin nvarchar(30),
@strCSRMGRin nvarchar(30),
@strSDatein datetime,
@strEDatein datetime

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strSDate nvarchar(8),
@strEDate nvarchar(8)

Set @strFormStatus = 'Completed'
Set @strSDate = convert(varchar(8),@strSDatein,112)
Set @strEDate = convert(varchar(8),@strEDatein,112)

SET @nvcSQL = 'SELECT	[cl].[FormName]	strFormID,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName, 
		[eh].[Mgr_Name]	strCSRMgrName, 
		[s].[Status]	strFormStatus,
		[sc].[SubCoachingSource]	strSource,
		[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[DIM_Source] sc,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where [cl].[EmpID] = [eh].[Emp_ID]
and [cl].[StatusID] = [s].[StatusID]
and [cl].[SourceID] = [sc].[SourceID]
and [eh].[Sup_LanID] =  '''+@strCSRSUPin+''' 
and [eh].[Mgr_Name] Like '''+@strCSRMGRin+'''
and [S].[Status] = '''+@strFormStatus+'''
and [eh].[Emp_Name] Like '''+@strCSRin+'''
and [sc].[SubCoachingSource] Like '''+@strSourcein+'''
and convert(varchar(8),[cl].[SubmittedDate],112) >= '''+@strSDate+'''
and convert(varchar(8),[cl].[SubmittedDate],112) <= '''+@strEDate+'''
Order By [cl].[SubmittedDate] DESC'

	
EXEC (@nvcSQL)	
	    
END --sp_SelectFrom_Coaching_Log_SUPCSRCompleted


GO







--******************************************************************


--16. Create SP  [EC].[sp_SelectFrom_Coaching_Log_SUPCSRPending]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_SUPCSRPending' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SUPCSRPending]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the CSR e-Coaching records from the Coaching_Log table
-- Where the status is Prnding Review. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SUPCSRPending] 

@strCSRSUPin nvarchar(30),
@strCSRin nvarchar(30), 
@strSourcein nvarchar(100)

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max)


SET @nvcSQL = 'SELECT	[cl].[FormName]	strFormID,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName, 
		[eh].[Mgr_Name]	strCSRMgrName, 
		[s].[Status]	strFormStatus,
		[sc].[SubCoachingSource]	strSource,
		[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[DIM_Source] sc,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where [cl].[EmpID] = [eh].[Emp_ID]
and [cl].[StatusID] = [s].[StatusID]
and [cl].[SourceID] = [sc].[SourceID]
and [eh].[Sup_LanID] =  '''+@strCSRSUPin+'''
and [S].[Status] like ''Pending%''
and [eh].[Emp_Name] Like '''+@strCSRin+'''
and [sc].[SubCoachingSource] Like '''+@strSourcein+'''
Order By [eh].[Sup_LanID],[cl].[SubmittedDate] DESC'

		
EXEC (@nvcSQL)	
	    
END--sp_SelectFrom_Coaching_Log_SUPCSRPending



GO



--******************************************************************

--17. Create SP  [EC].[sp_SelectFrom_Coaching_Log_SUPPending]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_SUPPending' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SUPPending]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the CSR e-Coaching records from the Coaching_Log table
-- Where the status is Prnding Review. 
-- Last Modified Date: 11/17/2014
-- Last Updated By: Susmitha Palacherla
-- Modified per SCR 13794 to allow acting Managers to view Supervisor level records.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SUPPending] @strCSRSUPin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus1 nvarchar(30),
@strFormStatus2 nvarchar(30),
@strFormStatus3 nvarchar(30),
@strFormStatus4 nvarchar(30),
@strFormStatus5 nvarchar(30)

 Set @strFormStatus1 = 'Pending Supervisor Review'
 Set @strFormStatus2 = 'Pending Acknowledgement'
 Set @strFormStatus3 = 'Pending Manager Review'
 Set @strFormStatus4 = 'Pending Quality Lead Review'
 Set @strFormStatus5 = 'Pending Employee Review'
 
SET @nvcSQL = 'SELECT [cl].[FormName] strFormID,
			[eh].[Emp_LanID] strCSR,
			[eh].[Emp_Name]	strCSRName,
			[eh].[Sup_Name] strCSRSupName,
			[S].[Status]	strFormStatus,
			[cl].[SubmittedDate] SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and (((eh.[Sup_LanID] = '''+@strCSRSUPin+''' OR eh.[Mgr_LanID] = '''+@strCSRSUPin+''' )
and ([S].[Status] = '''+@strFormStatus1+''' OR [S].[Status] = '''+@strFormStatus2+'''OR [S].[Status] = '''+@strFormStatus3+'''OR [S].[Status] = '''+@strFormStatus4+'''))
or (eh.[Emp_LanID] = '''+@strCSRSUPin+''' and [S].[Status] = '''+@strFormStatus5+'''))

Order By [cl].[SubmittedDate] DESC'
		
EXEC (@nvcSQL)	
--Print @nvcSQL
	    
END --sp_SelectFrom_Coaching_Log_SUPPending



GO






--******************************************************************


--18. Create SP  [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogDistinctCSRCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	4/30/12
--	Description: *	This procedure selects the distinct CSRs from completed e-Coaching records to display on Historical dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted] 

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)


 Set @strFormStatus = 'Inactive'

SET @nvcSQL = 'SELECT DISTINCT eh.Emp_Name	CSR,
		s.City	strCSRSite
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Site] s,
	 [EC].[DIM_Status] st,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.SiteID = s.SiteID
and cl.StatusID = st.StatusID
and st.Status <> '''+@strFormStatus+'''
Order By eh.Emp_Name ASC'

		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogDistinctCSRCompleted


GO


--******************************************************************

--19. Create SP  [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted2]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogDistinctCSRCompleted2' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted2]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	4/30/12
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted2] 

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'

SET @nvcSQL = 'SELECT DISTINCT eh.Emp_Name	CSR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] st,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = st.StatusID
and st.Status <> '''+@strFormStatus+'''
Order By eh.Emp_Name ASC'

		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogDistinctCSRCompleted2


GO


--******************************************************************

--20. Create SP  [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogDistinctMGRCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	7/12/12
--	Description: *	This procedure selects the distinct MGRs from completed e-Coaching records to display on Historical dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted] 

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'

SET @nvcSQL = 'SELECT DISTINCT eh.Mgr_Name MGR,
		s.City	strCSRSite
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Site] s,
	 [EC].[DIM_Status] st,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.SiteID = s.SiteID
and cl.StatusID = st.StatusID
and st.Status <> '''+@strFormStatus+'''
Order By eh.Mgr_Name ASC'

		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogDistinctMGRCompleted


GO




--******************************************************************


--21. Create SP  [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted2]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogDistinctMGRCompleted2' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted2]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	7/12/12
--	Description: *	This procedure selects the distinct MGRs from completed e-Coaching records to display on Historical dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted2] 

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'

SET @nvcSQL = 'SELECT DISTINCT eh.Mgr_Name MGR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] st,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = st.StatusID
and st.Status <> '''+@strFormStatus+'''
Order By eh.Mgr_Name ASC'

		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogDistinctMGRCompleted2


GO




--******************************************************************

--22. Create SP  [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogDistinctSUPCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	7/12/12
--	Description: *	This procedure selects the distinct SUPs from completed e-Coaching records to display on Historical dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted] 

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)


 Set @strFormStatus = 'Inactive'

SET @nvcSQL = 'SELECT DISTINCT eh.Sup_Name	SUP,
		s.City	strCSRSite
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Site] s,
	 [EC].[DIM_Status] st,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.SiteID = s.SiteID
and cl.StatusID = st.StatusID
and st.Status <> '''+@strFormStatus+'''
Order By eh.Sup_Name ASC'

		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogDistinctSUPCompleted


GO

--******************************************************************


--23. Create SP  [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted2]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogDistinctSUPCompleted2' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted2]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	7/12/12
--	Description: *	This procedure selects the distinct SUPs from completed e-Coaching records to display on Historical dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted2] 

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'


SET @nvcSQL = 'SELECT DISTINCT eh.Sup_Name	SUP
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] st,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = st.StatusID
and st.Status <> '''+@strFormStatus+'''
Order By eh.Sup_Name ASC'

		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogDistinctSUPCompleted2


GO


--******************************************************************


--24. Create SP  [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSR]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctCSR' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSR]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSR] @strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30),
@strFormStatus3 nvarchar(30)

Set @strFormStatus = 'Pending Manager Review'
Set @strFormStatus2 = 'Pending Supervisor Review'
Set @strFormStatus3 = 'Pending Acknowledgement'


SET @nvcSQL = 'SELECT DISTINCT	[eh].[Emp_Name]	CSR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where [cl].[EmpID] = [eh].[Emp_ID]
and [cl].[StatusID] = [s].[StatusID]
and (([eh].[Mgr_LanID] =  '''+@strCSRMGRin+''' and [S].[Status] = '''+@strFormStatus+''') OR ([eh].[Sup_LanID] =  '''+@strCSRMGRin+''' and ([S].[Status] = '''+@strFormStatus2+''' or [S].[Status] = '''+@strFormStatus3+''')))
Order By [eh].[Emp_Name] ASC'
		
		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogMgrDistinctCSR


GO

--******************************************************************


--25. Create SP  [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRSubmitted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctCSRSubmitted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRSubmitted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRSubmitted] 
@strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'

SET @nvcSQL = 'SELECT distinct [eh].[Emp_Name]	CSR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strCSRMGRin+''' 
and s.[Status] <> '''+@strFormStatus+'''
Order By [eh].[Emp_Name] ASC'	

		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogMgrDistinctCSRSubmitted


GO



--******************************************************************


--26. Create SP  [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRTeam]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctCSRTeam' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRTeam]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRTeam] 

@strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max)


SET @nvcSQL = 'SELECT DISTINCT [eh].[Emp_Name]	CSR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and eh.[Mgr_LanID] = '''+@strCSRMGRin+'''
and [S].[Status] like ''Pending%''
Order By [eh].[Emp_Name] ASC'
		
EXEC (@nvcSQL)	

End -- sp_SelectFrom_Coaching_LogMgrDistinctCSRTeam



GO



--******************************************************************

--27. Create SP  [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRTeamCompleted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctCSRTeamCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRTeamCompleted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRTeamCompleted] 

@strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)


 Set @strFormStatus = 'Completed'

SET @nvcSQL = 'SELECT DISTINCT [eh].[Emp_Name]	CSR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and eh.[Mgr_LanID] = '''+@strCSRMGRin+'''
and [S].[Status] = '''+@strFormStatus+'''
Order By [eh].[Emp_Name] ASC'
		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogMgrDistinctCSRTeamCompleted


GO



--******************************************************************


--28. Create SP  [EC].[sp_SelectFrom_Coaching_LogMgrDistinctMGRSubmitted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctMGRSubmitted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctMGRSubmitted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct supervisors from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctMGRSubmitted] 
@strCSRMGRin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'

SET @nvcSQL = 'SELECT distinct [eh].[Mgr_Name]	MGR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strCSRMGRin+''' 
and s.[Status] <> '''+@strFormStatus+'''
Order By [eh].[Mgr_Name] ASC'	

		
EXEC (@nvcSQL)	

End -- sp_SelectFrom_Coaching_LogMgrDistinctMGRSubmitted


GO




--******************************************************************

--29. Create SP  [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUP]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctSUP' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUP]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUP] @strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30),
@strFormStatus3 nvarchar(30)

Set @strFormStatus = 'Pending Manager Review'
Set @strFormStatus2 = 'Pending Supervisor Review'
Set @strFormStatus3 = 'Pending Acknowledgement'

		
SET @nvcSQL = 'SELECT DISTINCT	[eh].[Sup_Name]	SUP
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where [cl].[EmpID] = [eh].[Emp_ID]
and [cl].[StatusID] = [s].[StatusID]
and (([eh].[Mgr_LanID] =  '''+@strCSRMGRin+''' and [S].[Status] = '''+@strFormStatus+''') OR ([eh].[Sup_LanID] =  '''+@strCSRMGRin+''' and ([S].[Status] = '''+@strFormStatus2+''' or [S].[Status] = '''+@strFormStatus3+''')))
Order By [eh].[Sup_Name] ASC'
		

		
EXEC (@nvcSQL)	

End -- sp_SelectFrom_Coaching_LogMgrDistinctSUP


GO

--******************************************************************


--30. Create SP  [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPSubmitted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctSUPSubmitted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPSubmitted]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct supervisors from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPSubmitted] 
@strCSRMGRin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'

SET @nvcSQL = 'SELECT distinct [eh].[Sup_Name]	SUP
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strCSRMGRin+''' 
and s.[Status] <> '''+@strFormStatus+'''
Order By [eh].[Sup_Name] ASC'	

		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogMgrDistinctSUPSubmitted


GO



--******************************************************************

--31. Create SP  [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPTeam]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctSUPTeam' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPTeam]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPTeam] 

@strCSRMGRin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max)


SET @nvcSQL = 'SELECT DISTINCT [eh].[Sup_Name]	SUP
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and eh.[Mgr_LanID] = '''+@strCSRMGRin+'''
and [S].[Status] like ''Pending%''
Order By [eh].[Sup_Name] ASC'
		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogMgrDistinctSUPTeam



GO


--******************************************************************


--32. Create SP  [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPTeamCompleted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctSUPTeamCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPTeamCompleted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPTeamCompleted] 

@strCSRMGRin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)


 Set @strFormStatus = 'Completed'

SET @nvcSQL = 'SELECT DISTINCT [eh].[Sup_Name]	SUP
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and eh.[Mgr_LanID] = '''+@strCSRMGRin+'''
and [S].[Status] = '''+@strFormStatus+'''
Order By [eh].[Sup_Name] ASC'

		
EXEC (@nvcSQL)	

End -- sp_SelectFrom_Coaching_LogMgrDistinctSUPTeamCompleted


GO



--******************************************************************

--33. Create SP  [EC].[sp_SelectFrom_Coaching_LogStaffDistinctCompletedCSRSubmitted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogStaffDistinctCompletedCSRSubmitted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctCompletedCSRSubmitted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on staff dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctCompletedCSRSubmitted] 
@strCSRMGRin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)


Set @strFormStatus = 'Completed'
		
SET @nvcSQL = 'SELECT distinct [eh].[Emp_Name]	CSR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strCSRMGRin+''' 
and s.[Status] <> '''+@strFormStatus+'''
Order By [eh].[Emp_Name] ASC'		

EXEC (@nvcSQL)	

End -- sp_SelectFrom_Coaching_LogStaffDistinctCompletedCSRSubmitted


GO


--******************************************************************

--34. Create SP  [EC].[sp_SelectFrom_Coaching_LogStaffDistinctCompletedMGRSubmitted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogStaffDistinctCompletedMGRSubmitted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctCompletedMGRSubmitted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the distinct managers from e-Coaching records to display on staff dashboard for filter. 
--  Last Update:    03/07/2014
--  Updated per SCR 12369 to add NOLOCK Hint 
--	Last Update:	<03/11/2014>  - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctCompletedMGRSubmitted] 
@strCSRMGRin nvarchar(30)

AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Completed'
		
SET @nvcSQL = 'SELECT distinct [eh].[Mgr_Name]	MGR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strCSRMGRin+''' 
and s.[Status] <> '''+@strFormStatus+'''
Order By [eh].[Mgr_Name] ASC'		

EXEC (@nvcSQL)	

End

GO



--******************************************************************


--35. Create SP  [EC].[sp_SelectFrom_Coaching_LogStaffDistinctCompletedSUPSubmitted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogStaffDistinctCompletedSUPSubmitted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctCompletedSUPSubmitted]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct Supervisors from e-Coaching records to display on staff dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctCompletedSUPSubmitted] 
@strCSRMGRin nvarchar(30)

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Completed'	

SET @nvcSQL = 'SELECT distinct [eh].[Sup_Name]	SUP
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strCSRMGRin+''' 
and s.[Status] <> '''+@strFormStatus+'''
Order By [eh].[Sup_Name] ASC'

EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogStaffDistinctCompletedSUPSubmitted


GO


--******************************************************************

--36. Create SP  [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingCSRSubmitted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogStaffDistinctPendingCSRSubmitted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingCSRSubmitted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on staff dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingCSRSubmitted] 
@strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30)

Set @strFormStatus = 'Completed'
Set @strFormStatus2 = 'Inactive'


SET @nvcSQL = 'SELECT distinct [eh].[Emp_Name]	CSR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strCSRMGRin+''' 
and s.[Status] <> '''+@strFormStatus+'''
AND S.Status <> '''+@strFormStatus2+'''
Order By [eh].[Emp_Name] ASC'		

		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogStaffDistinctPendingCSRSubmitted


GO

--******************************************************************


--37. Create SP  [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingMGRSubmitted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogStaffDistinctPendingMGRSubmitted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingMGRSubmitted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct managers from e-Coaching records to display on staff dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingMGRSubmitted] 
@strCSRMGRin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30)

Set @strFormStatus = 'Completed'
Set @strFormStatus2 = 'Inactive'

SET @nvcSQL = 'SELECT distinct [eh].[Mgr_Name]	MGR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strCSRMGRin+''' 
		AND S.Status <> '''+@strFormStatus+'''
		AND S.Status <> '''+@strFormStatus2+'''
Order By [eh].[Mgr_Name] ASC'		

 
EXEC (@nvcSQL)	

End -- sp_SelectFrom_Coaching_LogStaffDistinctPendingMGRSubmitted


GO




--******************************************************************


--38. Create SP  [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingSUPSubmitted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogStaffDistinctPendingSUPSubmitted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingSUPSubmitted]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct Supervisors from e-Coaching records to display on staff dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingSUPSubmitted]  
@strCSRMGRin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30)

Set @strFormStatus = 'Completed'
Set @strFormStatus2 = 'Inactive'

 
SET @nvcSQL = 'SELECT distinct [eh].[Sup_Name]	SUP
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strCSRMGRin+''' 
		AND S.Status <> '''+@strFormStatus+'''
		AND S.Status <> '''+@strFormStatus2+'''
Order By [eh].[Sup_Name] ASC' 
 
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogStaffDistinctPendingSUPSubmitted


GO




--******************************************************************


--39. Create SP  [EC].[sp_SelectFrom_Coaching_LogSupDistinctCSR]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogSupDistinctCSR' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctCSR]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctCSR] @strCSRSUPin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'

SET @nvcSQL = 'SELECT DISTINCT eh.[Emp_Name] AS CSR
FROM [EC].[Coaching_Log] cl WITH(NOLOCK),
[EC].[Employee_Hierarchy] eh,
[EC].[Employee_Hierarchy] sh,
[EC].[DIM_Status] s
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.SubmitterID = sh.emp_ID
and sh.Emp_LanID = '''+@strCSRSUPin+''' 
and s.Status <> '''+@strFormStatus+'''
Order By CSR ASC'
		
EXEC (@nvcSQL)	

End -- sp_SelectFrom_Coaching_LogSupDistinctCSR


GO






--******************************************************************


--40. Create SP  [EC].[sp_SelectFrom_Coaching_LogSupDistinctCSRTeam]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogSupDistinctCSRTeam' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctCSRTeam]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctCSRTeam] 

@strCSRSUPin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max)



SET @nvcSQL = 'SELECT DISTINCT [eh].[Emp_Name]	CSR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and eh.[Sup_LanID] = '''+@strCSRSUPin+'''
and [S].[Status] like ''Pending%''
Order By [eh].[Emp_Name] ASC'
		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogSupDistinctCSRTeam



GO




--******************************************************************

--41. Create SP  [EC].[sp_SelectFrom_Coaching_LogSupDistinctCSRTeamCompleted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogSupDistinctCSRTeamCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctCSRTeamCompleted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctCSRTeamCompleted] 

@strCSRSUPin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)


 Set @strFormStatus = 'Completed'


SET @nvcSQL = 'SELECT DISTINCT [eh].[Emp_Name]	CSR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and [eh].[Sup_LanID] = '''+@strCSRSUPin+'''
and [S].[Status] = '''+@strFormStatus+'''
Order By [eh].[Emp_Name] ASC'
		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogSupDistinctCSRTeamCompleted


GO



--******************************************************************


--42. Create SP  [EC].[sp_SelectFrom_Coaching_LogSupDistinctMGR]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogSupDistinctMGR' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctMGR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct supervisors from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctMGR] @strCSRSUPin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'

SET @nvcSQL = 'SELECT DISTINCT eh.[Mgr_Name] AS MGR
FROM [EC].[Coaching_Log] cl WITH(NOLOCK),
[EC].[Employee_Hierarchy] eh,
[EC].[Employee_Hierarchy] sh,
[EC].[DIM_Status] s
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.SubmitterID = sh.Emp_ID
and sh.Emp_LanID = '''+@strCSRSUPin+''' 
and s.Status <> '''+@strFormStatus+'''
Order By MGR ASC'
		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogSupDistinctMGR


GO


--******************************************************************

--43. Create SP  [EC].[sp_SelectFrom_Coaching_LogSupDistinctMGRTeamCompleted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogSupDistinctMGRTeamCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctMGRTeamCompleted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct managers for supervisors from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctMGRTeamCompleted]

 @strCSRSUPin nvarchar(30)

AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Completed'

SET @nvcSQL = 'SELECT DISTINCT [eh].[Mgr_Name]	MGR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and [eh].[Sup_LanID] = '''+@strCSRSUPin+'''
and [S].[Status] = '''+@strFormStatus+'''
Order By [eh].[Mgr_Name] ASC'
		
EXEC (@nvcSQL)	

End  --sp_SelectFrom_Coaching_LogSupDistinctMGRTeamCompleted


GO



--******************************************************************



--44. Create SP  [EC].[sp_SelectFrom_Coaching_LogSupDistinctSUP]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogSupDistinctSUP' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctSUP]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct supervisors from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctSUP] @strCSRSUPin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'

SET @nvcSQL = 'SELECT DISTINCT eh.[Sup_Name] AS SUP
FROM [EC].[Coaching_Log] cl WITH(NOLOCK),
[EC].[Employee_Hierarchy] eh,
[EC].[Employee_Hierarchy] sh,
[EC].[DIM_Status] s
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.SubmitterID = sh.Emp_ID
and sh.Emp_LanID = '''+@strCSRSUPin+''' 
and s.Status <> '''+@strFormStatus+'''
Order By SUP ASC'
		
EXEC (@nvcSQL)	

End -- sp_SelectFrom_Coaching_LogSupDistinctSUP


GO



--******************************************************************




--55. Create SP  [EC].[sp_Select_Employees_By_Module]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Employees_By_Module' 
)
   DROP PROCEDURE [EC].[sp_Select_Employees_By_Module]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	7/31/14
--	Description: *	This procedure pulls the list of Employee names to be displayed 
--  in the drop downs for the selected Module using the job_code in the Employee_Selection table.
--  Created to replace the sp_SelectCSRsbyLocation used by the original CSR Module 
--  Last Modified By: Susmitha Palacherla
--  Last Modified date:02/19/2015
--  Modified per SCR 14323 to restrict users from submitting ecls for themselves by
--  by preventing them from appearing in the drop downs.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Employees_By_Module] 

@strModulein nvarchar(30), @strCSRSitein nvarchar(30)= NULL,
@strUserLanin nvarchar(20)

AS

BEGIN
DECLARE	
@isBySite BIT,
@nvcSQL nvarchar(max),
@nvcSQL01 nvarchar(max),
@nvcSQL02 nvarchar(max),
@nvcSQL03 nvarchar(max)

SET @nvcSQL01 = 'select [Emp_Name] + '' ('' + [Emp_LanID] + '') '' + [Emp_Job_Description] as FrontRow1
	  ,[Emp_Name] + ''$'' + [Emp_Email] + ''$'' + [Emp_LanID] + ''$'' + [Sup_Name] + ''$'' + [Sup_Email] + ''$'' + [Sup_LanID] + ''$'' + [Sup_Job_Description] + ''$'' + [Mgr_Name] + ''$'' + [Mgr_Email] + ''$'' + [Mgr_LanID] + ''$'' + 

[Mgr_Job_Description]  + ''$'' + [Emp_Site] as BackRow1, [Emp_Site]
       from [EC].[Employee_Hierarchy] WITH (NOLOCK) JOIN [EC].[Employee_Selection]
       on [EC].[Employee_Hierarchy].[Emp_Job_Code]= [EC].[Employee_Selection].[Job_Code]
where [EC].[Employee_Selection].[is'+ @strModulein + ']= 1
and [Emp_lanID] <> '''+@strUserLanin+ ''''

SET @nvcSQL02 = ' and [Emp_Site] = ''' +@strCSRSitein + ''''


SET @nvcSQL03 = ' and [End_Date] = ''99991231''
and [Emp_LanID]is not NULL and [Sup_LanID] is not NULL and [Mgr_LanID]is not NULL
order By [Emp_Name] ASC'

--IF @strModulein = 'CSR'
SET @isBySite = (SELECT BySite FROM [EC].[DIM_Module] Where [Module] = @strModulein and isActive =1)
IF @isBySite = 1

SET @nvcSQL = @nvcSQL01 + @nvcSQL02 +@nvcSQL03 
ELSE
SET @nvcSQL = @nvcSQL01 + @nvcSQL03 

--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_Employees_By_Module

GO




--******************************************************************
