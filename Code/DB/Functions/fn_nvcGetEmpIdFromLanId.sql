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
-- Last Modified By: Susmitha Palacherla
-- Modified to fix the logic for looking up the Employee ID - SCR 12983 - 07/25/2014
-- Modified to support Encrypted attributes. TFS 7856 - 11/01/2017
-- Modified to support Maxcorp ids - TFS 16529 - 03/13/2020
-- Modified to support eCoaching Log for Subcontractors - TFS 27527 - 02/01/2024
--	=============================================
CREATE OR ALTER FUNCTION [EC].[fn_nvcGetEmpIdFromLanId] 
(
  @nvcLanID Nvarchar(30),
  @dtmDate Datetime
)
RETURNS nvarchar(10)
AS
BEGIN
 

--OPEN SYMMETRIC KEY [CoachingKey]  
--DECRYPTION BY CERTIFICATE [CoachingCert]


DECLARE      @nvcLanIDX Nvarchar(30) = (REPLACE(REPLACE(@nvcLanID, 'Maxcorp\', ''),'AD\','')),
	         @nvcEmpID Nvarchar(10),
	         @intDate Int = EC.fn_intDatetime_to_YYYYMMDD (@dtmDate),
	         @intlanempid Int,
	         @intehempid Int
	

	-- Get count of Employee IDs for given lan ID in the Employe ID To lan ID Table
	
SET @intlanempid = (
			SELECT COUNT(EmpID)
			FROM EC.View_EmployeeID_To_LanID
			WHERE 
			LanID = @nvcLanIDX AND
			@intDate BETWEEN StartDate AND EndDate
			)
	
	-- IF at least one Employee ID is found in Lan ID table
	
IF  @intlanempid > 0

-- If exactly one Employee is Found return that Employee ID
BEGIN

IF  @intlanempid = 1
	BEGIN
	    SET @nvcEmpID = (
	   SELECT DISTINCT EmpID
	   FROM EC.View_EmployeeID_To_LanID
	    WHERE 
	    LanID = @nvcLanIDX AND
	    @intDate BETWEEN StartDate AND EndDate)
	END --@intlanempid = 1
	  
ELSE 	

-- If more than one Employee iD is found, return the one with the latest start date
  
	BEGIN
	  	 SET @nvcEmpID = (
		  SELECT DISTINCT LATEST.EmpID FROM
		 (SELECT LAN.* FROM EC.View_EmployeeID_To_LanID LAN
		  JOIN (SELECT LanID, MAX(StartDate)StartDate FROM [EC].[View_EmployeeID_To_LanID] GROUP BY LanID)MLAN
		  ON LAN.LanID = MLAN.lanID 
		  AND LAN.StartDate = MLAN.StartDate) AS LATEST
		  WHERE LATEST.LanID =  @nvcLanIDX AND 
		  @intDate BETWEEN LATEST.StartDate AND LATEST.EndDate
		  )
     END -- --@intlanempid > 1
 END -- @intlanempid > 0   
   
ELSE

-- If No Employee Ids are found in the Employee ID To lan ID Table
-- Get count of Employee IDs for given Lan ID in the Employe Hierarchy Table

 BEGIN
  
	SET @intehempid = (
	SELECT COUNT(Emp_ID)
	FROM EC.Employee_Hierarchy
	WHERE CONVERT(nvarchar(30),DecryptByKey(Emp_LanID)) = @nvcLanIDX AND
	@intDate BETWEEN Start_Date AND End_Date
	)
-- If exactly one Employee ID is found return it
	
IF  @intehempid = 1	

	 BEGIN
	      SET @nvcEmpID = 
		  (SELECT DISTINCT Emp_ID
		  FROM EC.Employee_Hierarchy
		  WHERE CONVERT(nvarchar(30),DecryptByKey(Emp_LanID)) = @nvcLanIDX
		  AND @intDate BETWEEN Start_Date AND End_Date
		  )
     END
 -- If more than one Employee ID is found, return the one with the latest start date    
 
 IF  @intehempid > 1

       BEGIN
	  	 SET @nvcEmpID = (
		  SELECT DISTINCT LATEST.Emp_ID FROM
		 (SELECT EH.* FROM EC.Employee_Hierarchy EH
		  JOIN (SELECT CONVERT(nvarchar(30),DecryptByKey(Emp_LanID)) AS [Emp_LanID], MAX(Start_Date)Start_Date
		  FROM EC.Employee_Hierarchy GROUP BY CONVERT(nvarchar(30),DecryptByKey(Emp_LanID)) )MEH
		  ON CONVERT(nvarchar(30),DecryptByKey(EH.Emp_LanID))  = MEH.Emp_LanID 
		  AND EH.Start_Date = MEH.Start_Date) AS LATEST
		  WHERE LATEST.Emp_LanID = @nvcLanIDX AND 
		  @intDate BETWEEN LATEST.Start_Date AND LATEST.End_Date
		  )
     END

IF  @intehempid = 0	

	 BEGIN
	      SET @nvcEmpID = 
		  (SELECT DISTINCT Emp_ID
		  FROM EC.Employee_Hierarchy
		  WHERE Emp_ID = @nvcLanIDX OR CONVERT(nvarchar(30),DecryptByKey(Emp_LanID)) = @nvcLanIDX
		  AND @intDate > Start_Date
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


