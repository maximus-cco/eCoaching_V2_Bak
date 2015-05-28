/*
File: eCoaching_Functions.sql (12)
Last Modified By: Susmitha Palacherla
Date: 05/25/2015


Version 12, 05/25/2015
1. Added the following Functions 2 functions(#28 and #29) to support the LCSAT feed per SCR 14818.
[EC].[fn_strEmpEmailFromEmpID] 
[EC].[fn_strEmpLanIDFromEmpID] 


Version 11, 03/19/2015
1. Added the following Functions 3 functions to support sr management dashboard per scr 14423.
[EC].[fn_strSrMgrLvl1EmpIDFromEmpID]  
[EC].[fn_strSrMgrLvl2EmpIDFromEmpID] 
[EC].[fn_strSrMgrLvl3EmpIDFromEmpID] 

Version 10, 02/20/2015
1. Modified fn #3 to handle multiple open ended employee id to lan id mappings per SCR 14375.
    [EC].[fn_intGetSiteIDFromLanID]

Version 09, 01/09/2015
1. Added 1 function #24 and modified 1 fn # 22related to ETS compliance feed SCR 14031.
 [EC].[fn_strEmpNameFromEmpID]  -- Added
 [EC].[fn_intSubCoachReasonIDFromETSRptCode] -- Modified

Version 08, 12/18/2014
1.Updated FN  [EC].[fn_intSubCoachReasonIDFromRptCode]
to add translation for new OMR report TR2 per SCR 14028.

Version 07, 11/21/2014
1. Added the following Function to support SCR 13826 for Verint sources.
   [EC].[fn_intSourceIDFromSource] 

Version 06, 11/14/2014
1. Added the following Functions 2 functions related to ETS feed SCR 13659.
 [EC].[fn_strETSDescriptionFromRptCode] 
 [EC].[fn_intSubCoachReasonIDFromETSRptCode] 

Version 05, 10/22/2014
1.  Marked the following Functions as Not being used.
[EC].[fn_Encrypt] 
[EC].[fn_Decrypt] 

Version 04, 10/13/2014
1.  Added  3 new Functions to support DirectHierarchy check, 
Encryption/Decryption for CSR Warnings module. SCR 13479.
[EC].[fn_strDirectUserHierarchy] 
[EC].[fn_Encrypt] 
[EC].[fn_Decrypt] 

Version 03, 08/29/2014
1. Updated the function [EC].[fn_strSiteNameFromSiteLocation] to 
use the new loaction address for Arlington.
2. Added new Function [EC].[fnSplit_WithRowID] 

Version 02, 07/28/2014
1. Updated the follwing function per SCR 12983 to change and or fix the update logic.
FUNCTION [EC].[fn_nvcGetEmpIdFromLanId] 

Version 1, 03/02/2014
1. Initial Revision.

To install, run section of the file as necessary


List of Functions:
1. [EC].[fn_dtYYYYMMDD_to_Datetime] 
2. [EC].[fn_intDatetime_to_YYYYMMDD] 
3. [EC].[fn_intGetSiteIDFromLanID] 
4. [EC].[fn_intSiteIDFromEmpID] 
5. [EC].[fn_intSubCoachReasonIDFromRptCode]
6. [EC].[fn_nvcGetEmpIdFromLanId]
7. [EC].[fn_nvcHtmlEncode]
8. [EC].[fn_strAddSpaceToName]
9. [EC].[fn_strMgrEmpIDFromEmpID]
10. [EC].[fn_strSiteNameFromSiteLocation]
11. [EC].[fn_strStatusIDFromIQSEvalID]
12. [EC].[fn_strStatusIDFromStatus]
13. [EC].[fn_strUserName]
14. [EC].[RemoveAlphaCharacters] 
15. [EC].[fn_intSiteIDFromSite] 
16. [EC].[fn_intSourceIDFromOldSource] 
17. [EC].[fnSplit_WithRowID] 
18.  [EC].[fn_strDirectUserHierarchy] 
19. [EC].[fn_Encrypt] -- (Not Being Used)
20. [EC].[fn_Decrypt] -- (Not Being Used)
21. [EC].[fn_strETSDescriptionFromRptCode] 
22. [EC].[fn_intSubCoachReasonIDFromETSRptCode] 
23. [EC].[fn_intSourceIDFromSource] 
24. [EC].[fn_strEmpNameFromEmpID]
25. [EC].[fn_strSrMgrLvl1EmpIDFromEmpID]  
26. [EC].[fn_strSrMgrLvl2EmpIDFromEmpID] 
27. [EC].[fn_strSrMgrLvl3EmpIDFromEmpID] 
*/


/*****************************************************/
/*  FUNCTIONS */
/*****************************************************/

--1. FUNCTION  [EC].[fn_dtYYYYMMDD_to_Datetime] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_dtYYYYMMDD_to_Datetime' 
)
   DROP FUNCTION [EC].[fn_dtYYYYMMDD_to_Datetime]
GO

/****** Object:  UserDefinedFunction [EC].[fn_dtYYYYMMDD_to_Datetime]    Script Date: 03/13/2014 15:21:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 01/22/2014
-- Description:	Given an integer representing a date in 
-- format YYYYMMDD, return the corresponding datetime value.
-- =============================================
CREATE FUNCTION [EC].[fn_dtYYYYMMDD_to_Datetime] 
(
	@intYYYYMMDD int
)
RETURNS datetime
AS
BEGIN
	DECLARE 
	  @dtYYYYMMDD datetime,
	  @strYYYYMMDD nchar(8)

  SET @strYYYYMMDD = cast(@intYYYYMMDD as nchar(8))
  SET @dtYYYYMMDD = cast(@strYYYYMMDD as datetime)

	RETURN @dtYYYYMMDD
END  -- fn_dtYYYYMMDD_to_Datetime()
GO


/*****************************************************/


--2. FUNCTION [EC].[fn_intDatetime_to_YYYYMMDD] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_intDatetime_to_YYYYMMDD' 
)
   DROP FUNCTION [EC].[fn_intDatetime_to_YYYYMMDD]
GO


/****** Object:  UserDefinedFunction [EC].[fn_intDatetime_to_YYYYMMDD]    Script Date: 03/13/2014 15:24:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 02/05/2014
-- Description:	Given a datetime value, return an integer
--   in format YYYYMMDD representing the date.
-- =============================================
CREATE FUNCTION [EC].[fn_intDatetime_to_YYYYMMDD]  
(
	@dtDatetime datetime
)
RETURNS int
AS
BEGIN
	DECLARE 
	  @strYYYYMMDD nchar(8),
	  @intYYYYMMDD int
	  
	SET @strYYYYMMDD = convert(nchar(8), @dtDatetime, 112)
	SET @intYYYYMMDD = cast(@strYYYYMMDD as int) 

	RETURN @intYYYYMMDD
END
GO

/*****************************************************/


--3. DROP/RECREATE FUNCTION [EC].[fn_intGetSiteIDFromLanID] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_intGetSiteIDFromLanID' 
)
   DROP FUNCTION [EC].[fn_intGetSiteIDFromLanID]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	=============================================
--	Author:		Susmitha Palacherla
--	Create Date: 03/05/2014
--	Description:	 
 --Given an LAN ID and a date, returns the  Employee ID of the
 --person who had that LAN ID on that date.
 --The Employee ID is then used to look up the site and site ID of the user.
 -- Last Modified By: Susmitha Palacherla
 -- Last modified Date: 02/20/2015
 -- Modified per SCR 14375 to handle multiple open ended employee ids mapped to a lanid
--	=============================================
CREATE FUNCTION [EC].[fn_intGetSiteIDFromLanID] 
(
  @nvcLanID NVARCHAR(20),
  @dtmDate DATETIME
)
RETURNS INT
AS
BEGIN
 
	 DECLARE @nvcEmpID NVARCHAR(10),
	         @intDate INT,
	         @strSiteName NVARCHAR(30),
	         @intSiteID INT,
	         @intlanempid Int,
	         @intehempid Int
	  
	
	SET @intDate = EC.fn_intDatetime_to_YYYYMMDD (@dtmDate)
	  
	-- Get count of Employee IDs for given lan ID in the Employe ID To lan ID Table
	
		SET @intlanempid = (
	SELECT COUNT(EmpID)
	FROM EC.EmployeeID_To_LanID
	WHERE 
	LanID = @nvclanID AND
	@intDate BETWEEN StartDate AND EndDate
	)
	
	-- IF at least one Employee ID is found
	
IF  @intlanempid > 0

-- If exactly one Employee is Found return that Employee ID
BEGIN

IF  @intlanempid = 1
	BEGIN
	    SET @nvcEmpID = (
	   SELECT DISTINCT EmpID
	   FROM EC.EmployeeID_To_LanID
	    WHERE 
	    LanID = @nvclanID AND
	    @intDate BETWEEN StartDate AND EndDate)
	END
	  
ELSE 	

-- If more than one Employee iD is found, return the one with the latest start date
  
	BEGIN
	  	 SET @nvcEmpID = (
		  SELECT DISTINCT LATEST.EmpID FROM
		 (SELECT LAN.* FROM EC.EmployeeID_To_LanID LAN
		  JOIN (SELECT LanID, MAX(StartDate)StartDate FROM [EC].[EmployeeID_To_LanID] GROUP BY LanID)MLAN
		  ON LAN.LanID = MLAN.lanID 
		  AND LAN.StartDate = MLAN.StartDate) AS LATEST
		  WHERE LATEST.LanID =  @nvclanID AND 
		  @intDate BETWEEN LATEST.StartDate AND LATEST.EndDate
		  )
     END
	END     
ELSE

-- If No Employee Ids are found in the Employee ID To lan ID Table
-- Get count of Employee IDs for given Lan ID in the Employe Hierarchy Table

 BEGIN
	SET @intehempid = (
	SELECT COUNT(Emp_ID)
	FROM EC.Employee_Hierarchy
	WHERE Emp_LanID = @nvclanID AND
	@intDate BETWEEN Start_Date AND End_Date
	)
-- If exactly one Employee ID is found return it
	
IF  @intehempid = 1	

	 BEGIN
	      SET @nvcEmpID = 
		  (SELECT DISTINCT Emp_ID
		  FROM EC.Employee_Hierarchy
		  WHERE Emp_LanID = @nvclanID
		  AND @intDate BETWEEN Start_Date AND End_Date
		  )
     END
 -- If more than one Employee ID is found, return the one with the latest start date    
 
  ELSE   
       BEGIN
	  	 SET @nvcEmpID = (
		  SELECT DISTINCT LATEST.Emp_ID FROM
		 (SELECT EH.* FROM EC.Employee_Hierarchy EH
		  JOIN (SELECT Emp_LanID, MAX(Start_Date)Start_Date FROM EC.Employee_Hierarchy GROUP BY Emp_LanID)MEH
		  ON EH.Emp_LanID = MEH.Emp_LanID 
		  AND EH.Start_Date = MEH.Start_Date) AS LATEST
		  WHERE LATEST.Emp_LanID =  @nvclanID AND 
		  @intDate BETWEEN LATEST.Start_Date AND LATEST.End_Date
		  )
     END
 END	
 
 -- If no Employee ID found for given Lan ID in the Employee ID to Lan ID table
 -- Then return '999999'
   
IF @nvcEmpID IS NULL 
SET @nvcEmpID = '999999'
	    
  SELECT  @strSiteName = [Emp_Site]
  FROM [EC].[Employee_Hierarchy]
  WHERE [Emp_ID] = @nvcEmpID
  
   
  IF @strSiteName is NULL OR @strSiteName ='OTHER'
  SET @strSiteName= N'Unknown'

  SELECT @intSiteID = [SiteID]
  FROM [EC].[DIM_Site]
  WHERE [City] = @strSiteName

   
  RETURN  @intSiteID

	
END --[EC].[fn_intGetSiteIDFromLanID] 



GO





*****************************************************************************


--4. Drop/Recreate Function [EC].[fn_intSiteIDFromEmpID] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_intSiteIDFromEmpID' 
)
   DROP FUNCTION [EC].[fn_intSiteIDFromEmpID]
GO

/****** Object:  UserDefinedFunction [EC].[fn_intSiteIDFromEmpID]    Script Date: 03/13/2014 21:17:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 02/23/2014
-- Description:	Given an Employee ID returns the Employee site ID.
-- Last Modified by: Susmitha Palacherla
-- Last update: 

-- =============================================
CREATE FUNCTION [EC].[fn_intSiteIDFromEmpID] 
(
	@strEmpID nvarchar(10) 
)
RETURNS INT
AS
BEGIN
	DECLARE 
	  @strSiteName nvarchar(30),
	  @intSITEID INT
	

  SELECT  @strSiteName = [Emp_Site]
  FROM [EC].[Employee_Hierarchy]
  WHERE [Emp_ID] = @strEmpID
  
   
  IF @strSiteName is NULL OR @strSiteName ='OTHER'
  SET @strSiteName= N'Unknown'

  SELECT @intSiteID = [SiteID]
  FROM [EC].[DIM_Site]
  WHERE [City] = @strSiteName

  
  
  RETURN  @intSiteID
  
END --fn_intSiteIDFromEmpID


GO

*****************************************************************************
--5. Drop/Recreate Function  [EC].[fn_intSubCoachReasonIDFromRptCode]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_intSubCoachReasonIDFromRptCode' 
)
   DROP FUNCTION [EC].[fn_intSubCoachReasonIDFromRptCode]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         03/05/2014
-- Description:	  Given the 3 letter Outlier Report code returns the Sub coaching reason for the OMR log.
-- Last Modified Date: 12/17/2014
-- last Modified By: Susmitha Palacherla
-- Modified per SCR 14028 to add FFM Tier 2 Report
-- =============================================
CREATE FUNCTION [EC].[fn_intSubCoachReasonIDFromRptCode] (
  @strRptCode NVARCHAR(10)
)
RETURNS INT
AS
BEGIN
  DECLARE @intSubCoachReasonID INT
  
  IF @strRptCode IS NOT NULL
    SET @intSubCoachReasonID =
      CASE @strRptCode 
			WHEN N'CAN' THEN 20
			WHEN N'DFQ' THEN 21
			WHEN N'OPN' THEN 22
			WHEN N'ISQ' THEN 23
			WHEN N'OSC' THEN 24
			WHEN N'ACW' THEN 25
			WHEN N'AHT' THEN 26
			WHEN N'SPI' THEN 27
			WHEN N'ACO' THEN 28
			WHEN N'IAE' THEN 29
			WHEN N'IDE' THEN 30
			WHEN N'IEE' THEN 31
			WHEN N'INF' THEN 32
			WHEN N'ISG' THEN 33
			WHEN N'LCS' THEN 34
			WHEN N'NIT' THEN 35
			WHEN N'RME' THEN 36
			WHEN N'SLG' THEN 37
			WHEN N'TRN' THEN 38 
			WHEN N'TR2' THEN 109  
        ELSE -1
      END
    ELSE
    SET @intSubCoachReasonID = -1
        
RETURN @intSubCoachReasonID  

END  -- fn_intSubCoachReasonIDFromRptCode()

GO







*****************************************************************************
--6. Drop/Recreate Function [EC].[fn_nvcGetEmpIdFromLanId]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_nvcGetEmpIdFromLanId' 
)
   DROP FUNCTION [EC].[fn_nvcGetEmpIdFromLanId]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	=============================================
--	Author:		Susmitha Palacherla
--	Create Date: 02/05/2014
--	Description:	 
--  *  Given an LAN ID and a date, return the  Employee ID of the
--  person who had that LAN ID on that date.
-- last Modified Date: 07/25/2014
-- Last Modified By: Susmitha Palacherla
-- Modified per SCR 12893 to fix the logic for looking up the Employee ID
--	=============================================
CREATE FUNCTION [EC].[fn_nvcGetEmpIdFromLanId] 
(
  @nvcLanID Nvarchar(20),
  @dtmDate Datetime
)
RETURNS nvarchar(10)
AS
BEGIN
 
	 DECLARE @nvcEmpID Nvarchar(10),
	         @intDate Int,
	         @intlanempid Int,
	         @intehempid Int
	
	SET @intDate = EC.fn_intDatetime_to_YYYYMMDD (@dtmDate)
	
	-- Get count of Employee IDs for given lan ID in the Employe ID To lan ID Table
	
		SET @intlanempid = (
	SELECT COUNT(EmpID)
	FROM EC.EmployeeID_To_LanID
	WHERE 
	LanID = @nvclanID AND
	@intDate BETWEEN StartDate AND EndDate
	)
	
	-- IF at least one Employee ID is found
	
IF  @intlanempid > 0

-- If exactly one Employee is Found return that Employee ID
BEGIN

IF  @intlanempid = 1
	BEGIN
	    SET @nvcEmpID = (
	   SELECT DISTINCT EmpID
	   FROM EC.EmployeeID_To_LanID
	    WHERE 
	    LanID = @nvclanID AND
	    @intDate BETWEEN StartDate AND EndDate)
	END
	  
ELSE 	

-- If more than one Employee iD is found, return the one with the latest start date
  
	BEGIN
	  	 SET @nvcEmpID = (
		  SELECT DISTINCT LATEST.EmpID FROM
		 (SELECT LAN.* FROM EC.EmployeeID_To_LanID LAN
		  JOIN (SELECT LanID, MAX(StartDate)StartDate FROM [EC].[EmployeeID_To_LanID] GROUP BY LanID)MLAN
		  ON LAN.LanID = MLAN.lanID 
		  AND LAN.StartDate = MLAN.StartDate) AS LATEST
		  WHERE LATEST.LanID =  @nvclanID AND 
		  @intDate BETWEEN LATEST.StartDate AND LATEST.EndDate
		  )
     END
	END     
ELSE

-- If No Employee Ids are found in the Employee ID To lan ID Table
-- Get count of Employee IDs for given Lan ID in the Employe Hierarchy Table

 BEGIN
	SET @intehempid = (
	SELECT COUNT(Emp_ID)
	FROM EC.Employee_Hierarchy
	WHERE Emp_LanID = @nvclanID AND
	@intDate BETWEEN Start_Date AND End_Date
	)
-- If exactly one Employee ID is found return it
	
IF  @intehempid = 1	

	 BEGIN
	      SET @nvcEmpID = 
		  (SELECT DISTINCT Emp_ID
		  FROM EC.Employee_Hierarchy
		  WHERE Emp_LanID = @nvclanID
		  AND @intDate BETWEEN Start_Date AND End_Date
		  )
     END
 -- If more than one Employee ID is found, return the one with the latest start date    
 
  ELSE   
       BEGIN
	  	 SET @nvcEmpID = (
		  SELECT DISTINCT LATEST.Emp_ID FROM
		 (SELECT EH.* FROM EC.Employee_Hierarchy EH
		  JOIN (SELECT Emp_LanID, MAX(Start_Date)Start_Date FROM EC.Employee_Hierarchy GROUP BY Emp_LanID)MEH
		  ON EH.Emp_LanID = MEH.Emp_LanID 
		  AND EH.Start_Date = MEH.Start_Date) AS LATEST
		  WHERE LATEST.Emp_LanID =  @nvclanID AND 
		  @intDate BETWEEN LATEST.Start_Date AND LATEST.End_Date
		  )
     END
 END	
 
 -- If no Employee ID found for given Lan ID in the Employee ID to Lan ID table
 -- Then return '999999'
   
IF @nvcEmpID IS NULL 
SET @nvcEmpID = '999999'
RETURN 	@nvcEmpID

END --fn_nvcGetEmpIdFromLanId
GO




*****************************************************************************
--7. Drop/Recreate Function [EC].[fn_nvcHtmlEncode]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_nvcHtmlEncode' 
)
   DROP FUNCTION [EC].[fn_nvcHtmlEncode]
GO

/****** Object:  UserDefinedFunction [EC].[fn_nvcHtmlEncode]    Script Date: 03/13/2014 21:22:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		    Susmitha Palacherla
-- Create date:     06/08/2012
-- Last update by:  Susmitha Palacherla
--   Encodes special characters that can pose a security risk when sent to front end.
-- Last update:   09/22/2013  
-- Description:   Modified per SCR 11115 to accept Summary of Caller issues upto 7000 chars. had to use nvarchar(max)

-- =============================================
CREATE FUNCTION [EC].[fn_nvcHtmlEncode] 
( 
    @UnEncoded as nvarchar(max) 
) 
RETURNS nvarchar(max) 
AS 
BEGIN 
    -- Declare the return variable here 
    DECLARE @Encoded as nvarchar(max) 
 
    -- Add the T-SQL statements to compute the return value here 
    SELECT @Encoded =  
         Replace( 
         Replace( 
	   Replace( 
	   Replace( 
	   Replace( 
	   Replace( 
	   Replace( 
	   Replace( 
	   Replace( 
	   Replace( 
	   Replace( 
       Replace(@UnEncoded,'&','&amp;'), 
       '<', '&lt;'), 
       '>', '&gt;'), 
	   '`', '&#39;'), 
	   '"', '&quot;'), 
       '‘', '&lsquo;'), 
	   '’', '&rsquo;'), 
	   ''', '&prime;'), 
       '?', '&Prime;'), 
       '“', '&ldquo;'), 
	   '”', '&rdquo;'),
	   '-', '&ndash;')   

 
    -- Return the result of the function 
    RETURN @Encoded 
 
END 
GO


*****************************************************************************
--8. Drop/Recreate Function [EC].[fn_strAddSpaceToName]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strAddSpaceToName' 
)
   DROP FUNCTION [EC].[fn_strAddSpaceToName]
GO

/****** Object:  UserDefinedFunction [EC].[fn_strAddSpaceToName]    Script Date: 03/13/2014 21:23:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         07/30/2013
-- Last modified by:    
-- Last modified date:  
-- Description:	 
--  *  Given an Employee Name Adds a space after the comma.

-- =============================================
CREATE Function [EC].[fn_strAddSpaceToName](@Name VarChar(50))
RETURNS VarChar(50)
AS
BEGIN

	--SET @NAME = REPLACE(@NAME, ',' ,', ')
	SET @NAME=
	SUBSTRING(@NAME,1,(CHARINDEX(',',@NAME))) + ' ' + SUBSTRING(@NAME,(CHARINDEX(',',@NAME )+1),40)   
	                
       
	RETURN @NAME
    
END -- fn_strAddSpaceToName

GO



*****************************************************************************
--9. Drop/Recreate Function [EC].[fn_strMgrEmpIDFromEmpID]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strMgrEmpIDFromEmpID' 
)
   DROP FUNCTION [EC].[fn_strMgrEmpIDFromEmpID]
GO
/****** Object:  UserDefinedFunction [EC].[fn_strMgrEmpIDFromEmpID]    Script Date: 03/13/2014 21:25:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 07/23/2013
-- Description:	Given an Employee ID returns the Manager Employee ID.
-- Last Modified by: Susmitha Palacherla
-- Last update: 12/19/2013
-- Updated per SCR 11855 to use supervisors supervisor as Manager employee id.
-- =============================================
CREATE FUNCTION [EC].[fn_strMgrEmpIDFromEmpID] 
(
	@strEmpID nvarchar(10) 
)
RETURNS NVARCHAR(10)
AS
BEGIN
	DECLARE 
	  @strSupEmpID nvarchar(10),
	  @strMgrEmpID nvarchar(10)

  SELECT   @strSupEmpID = [Sup_Emp_ID]
  FROM [EC].[Employee_Hierarchy_Stage]
  WHERE [Emp_ID] = @strEmpID

  
  SELECT   @strMgrEmpID =[Sup_Emp_ID]
  FROM [EC].[Employee_Hierarchy_Stage]
  WHERE [Emp_ID] = @strSupEmpID 
  
  IF    @strMgrEmpID IS NULL 
  SET   @strMgrEmpID= N'999999'
  
  RETURN  @strMgrEmpID
  
END --fn_strMgrEmpIDFromEmpID
GO


*****************************************************************************
--10. Drop/Recreate Function [EC].[fn_strSiteNameFromSiteLocation]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strSiteNameFromSiteLocation' 
)
   DROP FUNCTION [EC].[fn_strSiteNameFromSiteLocation]
GO

/****** Object:  UserDefinedFunction [EC].[fn_strSiteNameFromSiteLocation]    Script Date: 03/13/2014 21:27:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         07/25/2013
-- Description:	  Given a site location returns the site name
-- Last modified by: Susmitha Palacherla   
-- Last modified date:  12/09/2013
-- Added mapping for new sites per SCR 11629 to sue automated PS file. all non CCO call center locations set to OTHER.

-- =============================================
CREATE FUNCTION [EC].[fn_strSiteNameFromSiteLocation] (
  @strSiteLocation NVARCHAR(50)
)
RETURNS NVARCHAR(20)
AS
BEGIN
  DECLARE @strSiteName NVARCHAR(20)
  
  IF @strSiteLocation IS NOT NULL
    SET @strSiteName =
      CASE @strSiteLocation 
        WHEN N'AZ-Phoenix-8900 N 22nd Avenue'       THEN N'Phoenix'
        WHEN N'FL-Lynn Haven-1002 Arthur Dr'     THEN N'Lynn Haven'
        WHEN N'FL-Riverview-3020 US Hwy 301 S'       THEN N'Riverview'
        WHEN N'IA-Coralville-2400 Oakdale Blv'        THEN N'Coralville'
        WHEN N'IA-Coralville-2450 Oakdale Blv'        THEN N'Coralville'
        WHEN N'KS-Lawrence-3833 Greenway Dr'      THEN N'Lawrence'
        WHEN N'KY-Corbin-14892 N USHighway25E'      THEN N'Corbin'
        WHEN N'KY-London-4550 Old Whitley Rd'     THEN N'London'
        WHEN N'KY-Winchester-1025 Bypass Rd'     THEN N'Winchester'
        WHEN N'LA-Bogalusa-411 IndustrialPkwy'     THEN N'Bogalusa'
        WHEN N'MS-Hattiesburg-5912 Highway 49'     THEN N'Hattiesburg'
        WHEN N'TX-Houston-5959 Corporate Dr'     THEN N'Houston'
        WHEN N'TX-Waco-1205 N Loop 340'        THEN N'Waco'
        WHEN N'UT-Layton-2195 N Univ Pk Blvd' THEN 'Layton'
        WHEN N'UT-Sandy-8475 S Sandy Parkway'       THEN N'Sandy'
        WHEN N'VA-Chester-701 Liberty Way'      THEN N'Chester'
         WHEN N'VA-Falls Church-5201 Leesburg'     THEN N'Arlington'
        ELSE 'OTHER'
      END
    ELSE
      SET @strSiteName = N'Unknown'
      
   --IF @strSiteName like '%HOME%'
   -- SET @strSiteName = 'Other'
    
  RETURN @strSiteName  
END  -- fn_strSiteNameFromSiteLocation()
GO



*****************************************************************************
--11. Drop/Recreate Function [EC].[fn_strStatusIDFromIQSEvalID]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strStatusIDFromIQSEvalID' 
)
   DROP FUNCTION [EC].[fn_strStatusIDFromIQSEvalID]
GO

/****** Object:  UserDefinedFunction [EC].[fn_strStatusIDFromIQSEvalID]    Script Date: 03/13/2014 21:29:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         02/23/2014
-- Last modified by:    
-- Last modified date:  
-- Description:	 
--  *  Given an IQS Eval ID determines the Status for the Coaching Log.
--  The Status is then used to look up the Status ID.

-- =============================================
CREATE FUNCTION [EC].[fn_strStatusIDFromIQSEvalID] (
 @strCSE NVARCHAR(20),@strOppor_Rein NVARCHAR(20)
)
RETURNS NVARCHAR(50)
AS
BEGIN
  DECLARE  @strStatus NVARCHAR(50),
           @strStatusID INT 
  
 
  IF @strCSE ='' and @strOppor_Rein in ('Opportunity','Opportunity-PWC','Did Not Meet Goal')
  SET @strStatus = 'Pending Supervisor Review'
  ELSE 
  IF @strCSE in ('1','2','3','4','5','6','7','8') and @strOppor_Rein in ('Opportunity','Opportunity-PWC','Did Not Meet Goal')
  SET @strStatus = 'Pending Manager Review'
  ELSE 
  IF @strOppor_Rein in ('Reinforcement','Met Goal')
  SET @strStatus= 'Pending Acknowledgement'
  
  IF @strStatus is NULL
  SET @strStatus = 'Unknown'
  
  SELECT @strStatusID = [StatusID] FROM [EC].[DIM_Status]
  WHERE [Status]= @strStatus
  
      
  RETURN @strStatusID
  
END  -- fn_strStatusIDFromIQSEvalID()
GO


*****************************************************************************
--12. Drop/Recreate Function [EC].[fn_strStatusIDFromStatus]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strStatusIDFromStatus' 
)
   DROP FUNCTION [EC].[fn_strStatusIDFromStatus]
GO
/****** Object:  UserDefinedFunction [EC].[fn_strStatusIDFromStatus]    Script Date: 03/13/2014 21:31:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         03/06/2014
-- Last modified by:    
-- Last modified date:  
-- Description:	 Given a Status returns the Status id from Status table.
--    
-- =============================================
CREATE FUNCTION [EC].[fn_strStatusIDFromStatus]
 (
 @strStatus NVARCHAR(30)
)
RETURNS INT
AS
BEGIN
  DECLARE  @strStatusID INT 
   
  SELECT @strStatusID = [StatusID] FROM [EC].[DIM_Status]
  WHERE [Status]= @strStatus
  
      
  RETURN @strStatusID
  
END  -- fn_strStatusIDFromStatus()

GO


****************************************************************************
--13. Drop/Recreate Function [EC].[fn_strUserName]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strUserName' 
)
   DROP FUNCTION [EC].[fn_strUserName]
GO
/****** Object:  UserDefinedFunction [EC].[fn_strUserName]    Script Date: 03/13/2014 21:32:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 09/21/2012
-- Description:	Given a LAN ID, fetches the User Name from the Employee Hierarchy table.
-- If no match is found returns 'Unknown'
-- Last Modified date: 09/18/2013
-- Modified By: Susmitha Palacherla
-- Modified to use Employee_Hierarchy Table
-- =============================================
CREATE FUNCTION [EC].[fn_strUserName] 
(
	@strUserLanId nvarchar(30)  -- LAN ID of person requesting CSR scorecard
)
RETURNS NVARCHAR(30)
AS
BEGIN
	DECLARE 
	  @strUserName nvarchar(30)

  -- Strip domain off of the @strRequesterLanId parameter.
  --SET @strUserLanId = RTRIM(SUBSTRING(@strUserLanId, CHARINDEX(N'\', @strUserLanId) + 1, 100))
  SET @strUserLanId = SUBSTRING(@strUserLanId, CHARINDEX('\', @strUserLanId) + 1, LEN(@strUserLanId))

  
  SELECT @strUserName = Emp_Name
  FROM [EC].[Employee_Hierarchy]
  WHERE Emp_LanID = @strUserLanId
  
  IF  @strUserName IS NULL 
  SET  @strUserName = N'UnKnown'
  
  RETURN  @strUserName 
END
GO


**************************************************


--14. FUNCTION [EC].[RemoveAlphaCharacters] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'RemoveAlphaCharacters' 
)
   DROP FUNCTION [EC].[RemoveAlphaCharacters]
GO


/****** Object:  UserDefinedFunction [EC].[RemoveAlphaCharacters]    Script Date: 12/03/2013 11:04:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         07/20/2013
-- Last modified by:    
-- Last modified date:  
-- Description:	 
--  *  Given an Employee ID or Other String removes the alpha characters 
-- If they exist in the first 2 Positions. 
-- =============================================
CREATE Function [EC].[RemoveAlphaCharacters](@Temp VarChar(10))
Returns VarChar(10)
AS
Begin

    Declare @RemoveValues as varchar(10) = '%[A-Za-z]%'
    While PatIndex(@RemoveValues, @Temp) > 0 and PatIndex(@RemoveValues, @Temp) <= 2
        Set @Temp = Stuff(@Temp, PatIndex(@RemoveValues, @Temp), 1, '')

    Return @Temp
End -- RemoveAlphaCharacters

GO
**************************************************


--15. FUNCTION [EC].[fn_intSiteIDFromSite] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_intSiteIDFromSite' 
)
   DROP FUNCTION [EC].[fn_intSiteIDFromSite]
GO

/****** Object:  UserDefinedFunction [EC].[fn_intSiteIDFromSite]    Script Date: 04/09/2014 09:29:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         03/05/2014
-- Description:	  Given the Site Name returns the Site ID. 
-- =============================================
CREATE FUNCTION [EC].[fn_intSiteIDFromSite] (
  @strSite NVARCHAR(20)
)
RETURNS INT
AS
BEGIN
  DECLARE @intSiteID INT
  
  IF @strSite IS NOT NULL
    SET @intSiteID =
      CASE @strSite
			WHEN N'Bogalusa' THEN 1
			WHEN N'Boise' THEN 2
			WHEN N'Brownsville' THEN 3
			WHEN N'Chester' THEN 4
			WHEN N'Coralville' THEN 5
			WHEN N'Corbin' THEN 6
			WHEN N'Hattiesburg' THEN 7
			WHEN N'Houston' THEN 8
			WHEN N'London' THEN 9
			WHEN N'Lawrence' THEN 10
			WHEN N'Layton' THEN 11
			WHEN N'Lynn Haven' THEN 12
			WHEN N'Pearl' THEN 13
			WHEN N'Phoenix' THEN 14
			WHEN N'Riverview' THEN 15
			WHEN N'Sandy' THEN 16
			WHEN N'Waco' THEN 17
			WHEN N'Winchester' THEN 18
			WHEN N'Arlington' THEN 19
            ELSE -1 END 
    ELSE
    SET @intSiteID = -1
        
RETURN @intSiteID  

END  -- fn_intSiteIDFromSite()

**************************************************


--16. FUNCTION [EC].[fn_intSourceIDFromOldSource] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_intSourceIDFromOldSource' 
)
   DROP FUNCTION [EC].[fn_intSourceIDFromOldSource]
GO

/****** Object:  UserDefinedFunction [EC].[fn_intSourceIDFromOldSource]    Script Date: 04/09/2014 09:31:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         03/05/2014
-- Description:	  Given the Old Form Type and Source value returns the Source ID. 
-- =============================================
CREATE FUNCTION [EC].[fn_intSourceIDFromOldSource] (
  @strFormType NVARCHAR(20), @strSource NVARCHAR(60)
)
RETURNS INT
AS
BEGIN
  DECLARE @intSourceID INT
  
  SET @intSourceID = ( SELECT [SourceID]
  FROM [EC].[Historical_Source]
  WHERE [strFormType]=@strFormType 
  AND[strSource]= @strSource)
  
 IF  @intSourceID  IS NULL SET @intSourceID =213
 
RETURN @intSourceID

END  -- fn_intSourceIDFromOldSource()

GO

********************************************************************

--17. FUNCTION [EC].[fnSplit_WithRowID] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fnSplit_WithRowID' 
)
   DROP FUNCTION [EC].[fnSplit_WithRowID]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      08/03/2014
--    Description:     This Function takes a string of values separated by commas 
--                     and parses it returning individual values with a row number.
--    =====================================================================

CREATE FUNCTION [EC].[fnSplit_WithRowID](
    @InputList NVARCHAR(200) -- List of delimited items
  , @Delimiter NVARCHAR(1)   -- delimiter that separates items
) RETURNS @List TABLE (RowID INT Identity (1,1),Item NVARCHAR(200))

BEGIN
DECLARE @Item VARCHAR(200)
WHILE CHARINDEX(@Delimiter,@InputList,0) <> 0
 BEGIN
 SELECT
  @Item=RTRIM(LTRIM(SUBSTRING(@InputList,1,CHARINDEX(@Delimiter,@InputList,0)-1))),
  @InputList=RTRIM(LTRIM(SUBSTRING(@InputList,CHARINDEX(@Delimiter,@InputList,0)+LEN(@Delimiter),LEN(@InputList))))
 
 IF LEN(@Item) > 0
  INSERT INTO @List SELECT @Item
 END

IF LEN(@InputList) > 0
 INSERT INTO @List SELECT @InputList -- Put the last item in
RETURN
END -- fnSplit


GO

************************************************************************************

--18. FUNCTION [EC].[fn_strDirectUserHierarchy] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strDirectUserHierarchy' 
)
   DROP FUNCTION [EC].[fn_strDirectUserHierarchy]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	=============================================
--	Author:		Susmitha Palacherla
--	Create Date: 09/29/2014
--	Description:	 
--  *  Given an CSR LAN ID, a Submitter LAN ID and a date, return the  Employee ID of the
-- CSR and Submitter. Then check to see if the Employee ID of the Submitter 
-- equals the employee ID of the Supervisor or Manager.
-- If it does the function returns a a 'Yes' to Indicate Direct Hierrachy.
-- last Modified Date: 
-- Last Modified By: 

--	=============================================
CREATE FUNCTION [EC].[fn_strDirectUserHierarchy] 
(
  @strCSRin Nvarchar(20),
  @strSubmitterin Nvarchar(20),
  @dtmDate Datetime
)
RETURNS nvarchar(10)
AS
BEGIN
 
	 DECLARE @strCSRID nvarchar(10),
	         @strSubmitterID nvarchar(10),
	         @strCSRSupID nvarchar(10),
	         @strCSRMgrID nvarchar(10),
	         @DirectHierarchy nvarchar(10)
	
	SET @strCSRID = [EC].[fn_nvcGetEmpIdFromLanId] (@strCSRin, @dtmDate)
	SET @strSubmitterID = [EC].[fn_nvcGetEmpIdFromLanId] (@strSubmitterin, @dtmDate)
	SET @strCSRSupID = (Select Sup_ID from EC.Employee_Hierarchy Where Emp_ID = @strCSRID)
	SET @strCSRMgrID = (Select Mgr_ID from EC.Employee_Hierarchy Where Emp_ID = @strCSRID)
	

 SET @DirectHierarchy =
 CASE WHEN @strSubmitterID = @strCSRSupID THEN 'Yes'
      WHEN @strSubmitterID = @strCSRMgrID THEN 'Yes'
      Else 'No' END
      

   
RETURN @DirectHierarchy

END --fn_strDirectUserHierarchy
GO

************************************************************************************

--19. FUNCTION [EC].[fn_Encrypt] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_Encrypt' 
)
   DROP FUNCTION [EC].[fn_Encrypt]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         10/08/2014
-- Description:	  Encrypts an input string using a predefined Encryption algorithm.
-- =============================================
CREATE FUNCTION [EC].[fn_Encrypt]
(
    @ValueToEncrypt varchar(max)
)
RETURNS varbinary(max)
AS
BEGIN
    -- Declare the return variable here
    DECLARE @Result varbinary(max)

    SET @Result = EncryptByKey(Key_GUID('WarnDescKey'), @ValueToEncrypt)

    -- Return the result of the function
    RETURN @Result
END --fn_Encrypt
GO

************************************************************************************

--20. FUNCTION [EC].[fn_Decrypt] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_Decrypt' 
)
   DROP FUNCTION [EC].[fn_Decrypt]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         10/08/2014
-- Description:	  Decrypts an input string using a predefined Encryption algorithm.
-- =============================================
CREATE FUNCTION [EC].[fn_Decrypt]

(
    @ValueToDecrypt varbinary(max)
)
RETURNS varchar(max)
AS
BEGIN
    -- Declare the return variable here
    DECLARE @Result varchar(max)

    SET @Result = DecryptByKey(@ValueToDecrypt)

    -- Return the result of the function
    RETURN @Result
END --fn_Decrypt

GO


************************************************************************************

--21. FUNCTION [EC].[fn_strETSDescriptionFromRptCode] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strETSDescriptionFromRptCode' 
)
   DROP FUNCTION [EC].[fn_strETSDescriptionFromRptCode]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         11/3/2014
-- Description:	        Given a 3 or 4 letter ETS Report Code returns the Text Description
-- associated with that Report. 
-- =============================================
CREATE FUNCTION [EC].[fn_strETSDescriptionFromRptCode] (
  @strRptCode NVARCHAR(10)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
  DECLARE @strDescription NVARCHAR(MAX)
  
  IF @strRptCode IS NOT NULL
  BEGIN
  SET @strDescription = (SELECT [Description] FROM [EC].[ETS_Description]
                         WHERE [ReportCode]= @strRptCode)       
	END
    ELSE
    SET @strDescription = NULL
        
RETURN @strDescription

END  -- fn_strETSDescriptionFromRptCode


GO




************************************************************************************

--22. FUNCTION [EC].[fn_intSubCoachReasonIDFromETSRptCode] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_intSubCoachReasonIDFromETSRptCode' 
)
   DROP FUNCTION [EC].[fn_intSubCoachReasonIDFromETSRptCode]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         11/11/2014
-- Description:	  Given the 3 or 4 letter ETS Report Code returns the Sub coaching reason for the ETS log.
-- Last Modified: 01/07/2015
-- Modified per SCR 14031 to incorporate ETS Outstanding Action (Compliance) reports.
-- =============================================
CREATE FUNCTION [EC].[fn_intSubCoachReasonIDFromETSRptCode] (
  @strRptCode NVARCHAR(10)
)
RETURNS INT
AS
BEGIN
  DECLARE @intSubCoachReasonID INT
  
  IF @strRptCode IS NOT NULL
    SET @intSubCoachReasonID =
      CASE @strRptCode 
 
			
			WHEN N'EA' THEN 97
			WHEN N'EOT' THEN 98
			WHEN N'FWH' THEN 99
			WHEN N'FWHA' THEN 100
			WHEN N'HOL' THEN 101
			WHEN N'HOLA' THEN 102
			WHEN N'ITD' THEN 103
			WHEN N'ITDA' THEN 104
			WHEN N'ITI' THEN 105
			WHEN N'ITIA' THEN 106
			WHEN N'UTL' THEN 107
			WHEN N'UTLA' THEN 108
                                                      WHEN N'OAE' THEN 120
			WHEN N'OAS' THEN 121
		
        ELSE -1
      END
    ELSE
    SET @intSubCoachReasonID = -1
        
RETURN @intSubCoachReasonID  

END  -- fn_intSubCoachReasonIDFromETSRptCode()


GO






************************************************************************************

--23. FUNCTION [EC].[fn_intSourceIDFromSource] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_intSourceIDFromSource' 
)
   DROP FUNCTION [EC].[fn_intSourceIDFromSource]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         11/21/2014
-- Description:	  Given the Source value returns the Source ID. 
-- =============================================
CREATE FUNCTION [EC].[fn_intSourceIDFromSource] (
  @strSourceType NVARCHAR(20), @strSource NVARCHAR(60)
)
RETURNS INT
AS
BEGIN
  DECLARE @intSourceID INT
  
  SET @intSourceID = ( SELECT [SourceID]
  FROM [EC].[DIM_Source]
  WHERE [CoachingSource]=@strSourceType
  AND [SubCoachingSource]= @strSource)
  
 IF  @intSourceID  IS NULL SET @intSourceID = -1
 
RETURN @intSourceID

END  -- fn_intSourceIDFromSource()

GO



************************************************************************************

--24. FUNCTION [EC].[fn_strEmpNameFromEmpID] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strEmpNameFromEmpID' 
)
   DROP FUNCTION [EC].fn_strEmpNameFromEmpID]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 01/05/2015
-- Description:	Given an Employee ID, fetches the User Name from the Employee Hierarchy table.
-- If no match is found returns 'Unknown'
-- Initial version : SCR 14031 for loading ETS Compliance Reports
-- =============================================
CREATE FUNCTION [EC].[fn_strEmpNameFromEmpID] 
(
	@strEmpId nvarchar(20)  --Emp ID of person 
)
RETURNS NVARCHAR(30)
AS
BEGIN
	DECLARE 
	  @strEmpName nvarchar(40)


  
  SELECT @strEmpName = Emp_Name
  FROM [EC].[Employee_Hierarchy]
  WHERE Emp_ID = @strEmpId
  
  IF  @strEmpName IS NULL 
  SET  @strEmpName = N'UnKnown'
  
  RETURN  @strEmpName 
END



GO


************************************************************************************

--25. FUNCTION [EC].[fn_strSrMgrLvl1EmpIDFromEmpID] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strSrMgrLvl1EmpIDFromEmpID' 
)
   DROP FUNCTION [EC].[fn_strSrMgrLvl1EmpIDFromEmpID]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 03/05/2015
-- Description:	Given an Employee ID returns the Sr Manager Employee ID.
-- First Looks up the Mgr Emp ID of the Employee from the Hierarchy table.
-- Then looks up the Supervisor of the Manager as the Senior Manager Level1
-- Last Modified by: 
-- Last update: 
-- Created per SCR 14423 to extend dashboard functionality to senior leadership.
-- =============================================
CREATE FUNCTION [EC].[fn_strSrMgrLvl1EmpIDFromEmpID] 
(
	@strEmpID nvarchar(10) 
)
RETURNS NVARCHAR(10)
AS
BEGIN
	DECLARE 
		 @strMgrEmpID nvarchar(10),
		 @strSrMgrLvl1EmpID nvarchar(10)

  SELECT   @strMgrEmpID = [Mgr_ID]
  FROM [EC].[Employee_Hierarchy]
  WHERE [Emp_ID] = @strEmpID

  IF    @strMgrEmpID IS NULL 
  SET   @strMgrEmpID= N'999999'
  
  SELECT   @strSrMgrLvl1EmpID =[Sup_ID]
  FROM [EC].[Employee_Hierarchy]
  WHERE [Emp_ID] =@strMgrEmpID
  
  IF     @strSrMgrLvl1EmpID IS NULL 
  SET    @strSrMgrLvl1EmpID = N'999999'
  
  RETURN   @strSrMgrLvl1EmpID
  
END --fn_strSrMgrLvl1EmpIDFromEmpID
GO





************************************************************************************

--26. FUNCTION [EC].[fn_strSrMgrLvl2EmpIDFromEmpID] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strSrMgrLvl2EmpIDFromEmpID' 
)
   DROP FUNCTION [EC].[fn_strSrMgrLvl2EmpIDFromEmpID]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 03/05/2015
-- Description:	Given an Employee ID returns the Sr Mananger level 2 Employee ID.
-- First Looks up the Mgr Emp ID of the Employee from the Hierarchy table.
-- Then looks up the Supervisor of the Manager as the Senior Manager.
-- Then looks up the Supervisor of the Senior Manager as the DSr Mananger level 2.
-- Last Modified by: 
-- Last update: 
-- Created per SCR 14423 to extend dashboard functionality to senior leadership.
-- =============================================
CREATE FUNCTION [EC].[fn_strSrMgrLvl2EmpIDFromEmpID] 
(
	@strEmpID nvarchar(10) 
)
RETURNS NVARCHAR(10)
AS
BEGIN
	DECLARE 
		 @strMgrEmpID nvarchar(10),
		 @strSrMgrLvl1EmpID nvarchar(10),
		 @strSrMgrLvl2EmpID nvarchar(10)

  SELECT   @strMgrEmpID = [Mgr_ID]
  FROM [EC].[Employee_Hierarchy]
  WHERE [Emp_ID] = @strEmpID

  IF    @strMgrEmpID IS NULL 
  SET   @strMgrEmpID= N'999999'
  
  SELECT   @strSrMgrLvl1EmpID =[Sup_ID]
  FROM [EC].[Employee_Hierarchy]
  WHERE [Emp_ID] =@strMgrEmpID
  
  IF     @strSrMgrLvl1EmpID IS NULL 
  SET    @strSrMgrLvl1EmpID = N'999999'
  
  SELECT   @strSrMgrLvl2EmpID =[Sup_ID]
  FROM [EC].[Employee_Hierarchy]
  WHERE [Emp_ID] = @strSrMgrLvl1EmpID
  
  IF     @strSrMgrLvl2EmpID IS NULL 
  SET    @strSrMgrLvl2EmpID = N'999999'
  
  RETURN  @strSrMgrLvl2EmpID
  
END --fn_strSrMgrLvl2EmpIDFromEmpID
GO





************************************************************************************

--27. FUNCTION [EC].[fn_strSrMgrLvl3EmpIDFromEmpID] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strSrMgrLvl3EmpIDFromEmpID' 
)
   DROP FUNCTION [EC].[fn_strSrMgrLvl3EmpIDFromEmpID]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 03/05/2015
-- Description:	Given an Employee ID returns the Regional Manager Employee ID.
-- First Looks up the Mgr Emp ID of the Employee from the Hierarchy table.
-- Then looks up the Supervisor of the Manager as the Senior Manager.
-- Then looks up the Supervisor of the Senior Manager as the Regional Manager.
-- Last Modified by: 
-- Last update: 
-- Created per SCR 14423 to extend dashboard functionality to senior leadership.
-- =============================================
CREATE FUNCTION [EC].[fn_strSrMgrLvl3EmpIDFromEmpID] 
(
	@strEmpID nvarchar(10) 
)
RETURNS NVARCHAR(10)
AS
BEGIN
	DECLARE 
		 @strMgrEmpID nvarchar(10),
		 @strSrMgrLvl1EmpID nvarchar(10),
		 @strSrMgrLvl2EmpID nvarchar(10),
		 @strSrMgrLvl3EmpID nvarchar(10)
		 

  SELECT   @strMgrEmpID = [Mgr_ID]
  FROM [EC].[Employee_Hierarchy]
  WHERE [Emp_ID] = @strEmpID

  IF    @strMgrEmpID IS NULL 
  SET   @strMgrEmpID= N'999999'
  
  SELECT   @strSrMgrLvl1EmpID =[Sup_ID]
  FROM [EC].[Employee_Hierarchy]
  WHERE [Emp_ID] =@strMgrEmpID
  
  IF     @strSrMgrLvl1EmpID IS NULL 
  SET    @strSrMgrLvl1EmpID = N'999999'
  
   SELECT   @strSrMgrLvl2EmpID =[Sup_ID]
  FROM [EC].[Employee_Hierarchy]
  WHERE [Emp_ID] = @strSrMgrLvl1EmpID
  
  IF    @strSrMgrLvl2EmpID IS NULL 
  SET   @strSrMgrLvl2EmpID= N'999999'
  
  SELECT   @strSrMgrLvl3EmpID =[Sup_ID]
  FROM [EC].[Employee_Hierarchy]
  WHERE [Emp_ID] = @strSrMgrLvl2EmpID
  
  IF     @strSrMgrLvl3EmpID IS NULL 
  SET    @strSrMgrLvl3EmpID = N'999999'
  
  RETURN  @strSrMgrLvl3EmpID
  
END --fn_strSrMgrLvl3EmpIDFromEmpID
GO




************************************************************************************

--28. FUNCTION [EC].[fn_strEmpEmailFromEmpID] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strEmpEmailFromEmpID' 
)
   DROP FUNCTION [EC].[fn_strEmpEmailFromEmpID]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 05/13/2015
-- Description:	Given an Employee ID, fetches the Email address from the Employee Hierarchy table.
-- If no match is found returns 'Unknown'
-- Initial version : SCR 14818 for loading LCSAT feed.
-- =============================================
CREATE FUNCTION [EC].[fn_strEmpEmailFromEmpID] 
(
	@strEmpId nvarchar(20)  --Emp ID of person 
)
RETURNS NVARCHAR(30)
AS
BEGIN
	DECLARE 
	  @strEmpEmail nvarchar(50)


  
  SELECT @strEmpEmail = Emp_Email
  FROM [EC].[Employee_Hierarchy]
  WHERE Emp_ID = @strEmpId
  
  IF  @strEmpEmail IS NULL 
  SET @strEmpEmail = N'UnKnown'
  
  RETURN  @strEmpEmail 
END -- fn_strEmpEmailFromEmpID

GO


--3e.

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




************************************************************************************

--29. FUNCTION [EC].[fn_strEmpLanIDFromEmpID] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strEmpLanIDFromEmpID' 
)
   DROP FUNCTION [EC].[fn_strEmpLanIDFromEmpID]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 05/13/2015
-- Description:	Given an Employee ID, fetches the Lan ID from the Employee Hierarchy table.
-- If no match is found returns 'Unknown'
-- Initial version : SCR 14818 for loading LCSAT feed.
-- =============================================
CREATE FUNCTION [EC].[fn_strEmpLanIDFromEmpID] 
(
	@strEmpId nvarchar(20)  --Emp ID of person 
)
RETURNS NVARCHAR(30)
AS
BEGIN
	DECLARE 
	  @strEmpLanID nvarchar(30)


  
  SELECT @strEmpLanID = Emp_LanID
  FROM [EC].[Employee_Hierarchy]
  WHERE Emp_ID = @strEmpId
  
  IF  @strEmpLanID IS NULL 
  SET @strEmpLanID = N'UnKnown'
  
  RETURN  @strEmpLanID 
END -- fn_strEmpLanIDFromEmpID


GO



************************************************************************************

--30. FUNCTION [EC].[xxxxxx] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'xxxxx' 
)
   DROP FUNCTION [EC].[xxxxxxx]
GO
