/*
sp_Select_Employees_BySite_NotIn_Hist_ACL(01).sql
Last Modified Date: 01/18/2017
Last Modified By: Susmitha Palacherla


Version 01:  Initial Revision - Created during encryption of secure data. TFF 7856 - 01/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Employees_BySite_NotIn_Hist_ACL' 
)
   DROP PROCEDURE [EC].[sp_Select_Employees_BySite_NotIn_Hist_ACL]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--	====================================================================
--	Author:	Susmitha Palacherla
--	Create Date: 01/18/2018
--	Description: Returns active records from Historical Dashboard ACL table
--  Revision History:    
--  Initial Revision. Created to replace embedded sql in UI code during encryption of sensitive data. TFS 7856. 01/18/2018
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Employees_BySite_NotIn_Hist_ACL]
@SiteId INT
AS


OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert]


BEGIN

DECLARE 
@SiteCity nvarchar(30)

SET @SiteCity = (SELECT City FROM EC.DIM_SITE WHERE SiteID = @SiteId)

SELECT CONVERT(nvarchar(30),DecryptByKey(eh.Emp_LanID)) AS Emp_LanID, 
        CONVERT(nvarchar(50),DecryptByKey(eh.Emp_Name)) AS Emp_Name
FROM EC.Employee_Hierarchy eh
WHERE eh.Active = 'A'
AND eh.Emp_Site = @siteCity
AND CONVERT(nvarchar(30),DecryptByKey(eh.Emp_LanID))
NOT IN (SELECT CONVERT(nvarchar(30),DecryptByKey(User_LanID))
       FROM EC.Historical_Dashboard_ACL where End_Date = 99991231)
       ORDER BY Emp_Name
	 





CLOSE SYMMETRIC KEY [CoachingKey]      
END --sp_Select_Employees_BySite_NotIn_Hist_ACL




GO


