/*
File: fn_intGetSiteIDFromLanID(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/
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

