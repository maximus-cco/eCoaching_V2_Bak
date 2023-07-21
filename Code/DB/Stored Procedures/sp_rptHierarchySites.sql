DROP PROCEDURE IF EXISTS [EC].[sp_rptHierarchySites]; 
GO

/*************************************************************************************** 
--	Author:				LH
--	Create Date:		07/11/2023
--	Description:		Returns all sites, include "All" and "Other".
--  Last Modified:  
--  Last Modified By: 
--  Revision History:	#26819 - Replace SSRS reports with datatables.
***************************************************************************************/
CREATE PROCEDURE [EC].[sp_rptHierarchySites] 
AS

SET NOCOUNT ON;
SELECT Site
FROM (
	SELECT 'All' AS Site
	UNION
	SELECT DISTINCT Emp_Site AS Site
	FROM EC.Employee_Hierarchy eh  
	JOIN EC.DIM_Site ds ON eh.Emp_Site = ds.city
	WHERE Emp_Site <> 'Unknown'
	UNION
	SELECT DISTINCT 'Other' AS Site
	FROM EC.Employee_Hierarchy 
	WHERE Emp_Site = 'Other'
) AS S
ORDER BY 
    CASE
        WHEN Site = 'All' THEN 0
		WHEN Site = 'Other' THEN 2
		ELSE 1
    END, Site;

GO

