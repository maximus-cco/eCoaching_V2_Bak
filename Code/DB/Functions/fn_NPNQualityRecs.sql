/*
fn_NPNQualityRecs(03).sql
Last Modified Date: 11/27/2017
Last Modified By: Susmitha Palacherla

Version 03: Updated to support protection sensitive data. Removed LanID from Select. TFS 7856 - 11/27/2017
Version 02: Additional update from V&V feedback - TFS 5653 - 03/02/2017
Version 01: Document Initial Revision - TFS 5653 - 02/28/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_NPNQualityRecs' 
)
   DROP FUNCTION [EC].[fn_NPNQualityRecs]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:		      Susmitha Palacherla
-- Create date:       02/28/2017
-- Description:	
-- Selects the IQS logs eligible for a follow up NPN log for given date range.
-- Last update by:   Susmitha Palacherla
-- Initial Revision - Created as part of  TFS 5653 - 02/28/2017
-- Updated to support protection sensitive data. Removed LanID from Select. TFS 7856 - 11/27/2017
-- =============================================
CREATE FUNCTION [EC].[fn_NPNQualityRecs] 
(
	@intBeginDate int,  -- YYYYMMDD
	@intEndDate int     -- YYYYMMDD
)
RETURNS 
@Table_NPNQualityRecs TABLE 
(
    [EmpID] [nvarchar](10) NOT NULL,
	[EmpLanID] [nvarchar](30) NOT NULL,
	[ProgramName] [nvarchar](20) NULL,
	[SiteID] [int] NOT NULL,
	[EventDate] [datetime] NULL,
	[VerintID] [nvarchar](30) NULL,
	[NPNCode] [nvarchar](10) NOT NULL

)
AS
BEGIN

DECLARE

@BeginDate NVARCHAR(8),
@EndDate NVARCHAR(8)


  
  INSERT @Table_NPNQualityRecs
  (
    [EmpID], 
	[EmpLanID], 
	[ProgramName], 
	[SiteID], 
	[EventDate], 
	[VerintID], 
	[NPNCode]
 
  )
 
  SELECT DISTINCT CL.[EmpID], 
	'-',
	SUBSTRING(CL.[ProgramName], 1,20),
	CL.[SiteID], 
	CL.[EventDate], 
	CL.[VerintID],
    substring(CL.[Description], patindex ('%#NPNFFM%', CL.[Description]), 8) as NPNCode
    
FROM EC.Coaching_Log CL with (nolock) join EC.Employee_Hierarchy EH
ON CL.EmpID = EH. Emp_ID
left outer join (Select * from EC.Coaching_Log with (nolock) where SourceID = 218)CN
on CL.VerintID  = CN.VerintID 
and CL.EmpID  = CN.EmpID 
and CL.EventDate = CN.EventDate
where CL.[SourceID] = 223
AND CL.[Description] like '%NPNFFM%'
AND NOT (CL.[Description] like '%PPOM%' OR CL.VerintFormName like '%PPOM%')
AND CL.[StatusID] <> 2
AND EH.[Active] = 'A'
AND [EC].[fn_intDatetime_to_YYYYMMDD](CL.[SubmittedDate]) BETWEEN @intBeginDate AND @intEndDate 
and (CN.VerintID is null and CN.EmpID is null and CN.EventDate is null) 



RETURN 
END -- fn [ec].[fn_NPNQualityRecs] 

GO


