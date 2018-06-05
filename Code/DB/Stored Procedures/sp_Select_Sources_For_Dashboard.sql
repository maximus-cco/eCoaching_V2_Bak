/*
sp_Select_Sources_For_Dashboard(03).sql
Last Modified Date: 04/30/2018
Last Modified By: Susmitha Palacherla

Version 03 : Modified during Hist dashboard move to new architecture - TFS 7138 - 04/30/2018

Version 02: --  Modified to support Encryption of sensitive data. TFS 7856 - 11/28/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Sources_For_Dashboard' 
)
   DROP PROCEDURE [EC].[sp_Select_Sources_For_Dashboard]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	03/06/2015
--	Description: *	This procedure selects Sources to be displayed in the dashboard
--  Source dropdown list.
--  Last Modified: 4/6/2016
--  Last Modified By: Susmitha Palacherla
--  Modified to add additional HR job code WHHR70 - TFS 1423 - 12/15/2015
--  Modified to reference table for HR job codes - TFS 2332 - 4/6/2016
--  Modified to support Encryption of sensitive data. TFS 7856 - 11/28/2017
-- Modified during Hist dashboard move to new architecture - TFS 7138 - 04/20/2018
--	====================================================================
CREATE PROCEDURE [EC].[sp_Select_Sources_For_Dashboard] 
@nvcEmpID nvarchar(10)

AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max),
	@nvcDisplayWarnings nvarchar(5)

	
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert] 		

SET @nvcDisplayWarnings = (SELECT ISNULL (EC.fn_strCheckIf_HRUser(@nvcEmpID),'NO')) 

-- Check users job code and show 'Warning' as a source only for HR users.
IF @nvcDisplayWarnings = 'YES'

SET @nvcSQL = 'SELECT X.SourceId, X.Source FROM
(SELECT ''-1'' SourceId, ''All Sources'' Source,  01 Sortorder From [EC].[DIM_Source]
UNION
SELECT CONVERT(nvarchar,[SourceId]) SourceId, 
[SubCoachingSource] Source,  02 Sortorder From [EC].[DIM_Source]
Where [CoachingSource] = ''Direct''
and [SubCoachingSource] <> ''Unknown''
and [isActive]= 1)X
ORDER BY X.Sortorder, X.Source'

ELSE

SET @nvcSQL = 'SELECT X.SourceId, X.Source FROM
(SELECT ''-1'' SourceId, ''All Sources'' Source,  01 Sortorder From [EC].[DIM_Source]
UNION
SELECT  CONVERT(nvarchar,[SourceId]) SourceId,
[SubCoachingSource] Source, 02 Sortorder From [EC].[DIM_Source]
Where [CoachingSource] = ''Direct''
and[SubCoachingSource] not in ( ''Warning'',''Unknown'')
and [isActive]= 1)X
ORDER BY X.Sortorder, X.Source'

--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_Sources_For_Dashboard

GO



