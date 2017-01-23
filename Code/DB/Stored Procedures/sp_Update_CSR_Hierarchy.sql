/*
sp_Update_CSR_Hierarchy(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update_CSR_Hierarchy' 
)
   DROP PROCEDURE [EC].[sp_Update_CSR_Hierarchy]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		   Susmitha Palacherla
-- Create Date: 01/20/2014
-- Description:	Performs the following actions.
-- Adds an End Date to an Employee record with a Hierarchy change.
-- Inserts a new row for the Updated Hierarchy.
-- Last Modified Date: 08/21/2014
-- Last Modified By: Susmitha Palacherla
-- Modified to remove the condition to insert and update records for CSRS only. 
-- This will support the Modul approcah being implemented to support non CSR ecls.

-- =============================================
CREATE PROCEDURE [EC].[sp_Update_CSR_Hierarchy] 
AS
BEGIN


-- Assigns End_Date to CSR records with changed Hierarchy.
BEGIN
UPDATE [EC].[CSR_Hierarchy]
SET [EndDate] = DATEADD(dd, DATEDIFF(dd, 0, GETDATE()), 0)
FROM [EC].[Employee_Hierarchy]EH JOIN [EC].[CSR_Hierarchy]CH
ON EH.[Emp_ID]= CH.[EmpID]
WHERE (EH.[Sup_ID]<> CH.[SupID]OR EH.[Mgr_ID]<> CH.[MgrID])
AND (EH.[Sup_ID]IS NOT NULL AND EH.[Mgr_ID] IS NOT NULL)
AND CH.[EndDate] = '9999-12-31 00:00:00.000'
OPTION (MAXDOP 1)
END


WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms


-- Inserts new rows for CSRs with changed Hierarchy.
BEGIN
;
With LatestRecord as
(Select [EmpID], max([EndDate])as LEnd_Date from [EC].[CSR_Hierarchy]
 GROUP BY [EmpID])
INSERT INTO [EC].[CSR_Hierarchy]
           ([EmpID]
           ,[SupID]
           ,[MgrID]
           ,[StartDate]
           ,[EndDate]
            )
SELECT distinct EH.[Emp_ID]
,EH.[Sup_ID]
,EH.[Mgr_ID]
, DATEADD(dd, DATEDIFF(dd, 0, GETDATE()), 0)
,'9999-12-31 00:00:00.000'
FROM [EC].[Employee_Hierarchy]EH  JOIN
(SELECT C.* FROM [EC].[CSR_Hierarchy] C JOIN  LatestRecord L
ON C. EMPID =L.EMPID WHERE L.LEnd_Date <> '9999-12-31 00:00:00.000') AS CH
on EH.Emp_ID = CH.EmpID
--where EH.[Emp_Job_Code]in ('WACS01','WACS02','WACS03')
WHERE (EH.[Sup_ID]<> CH.[SupID]OR EH.[Mgr_ID]<> CH.[MgrID])
AND (EH.[Sup_ID]IS NOT NULL AND EH.[Mgr_ID] IS NOT NULL)
OPTION (MAXDOP 1)
END


WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms
    
-- Inserts New CSR records 

BEGIN
INSERT INTO [EC].[CSR_Hierarchy]
           ([EmpID]
           ,[SupID]
           ,[MgrID]
           ,[StartDate]
           ,[EndDate] )
SELECT EH.[Emp_ID]
,EH.[Sup_ID]
,EH.[Mgr_ID]
, DATEADD(dd, DATEDIFF(dd, 0, GETDATE()), 0)
,'9999-12-31 00:00:00.000'
FROM [EC].[Employee_Hierarchy]EH LEFT OUTER JOIN [EC].[CSR_Hierarchy]CH
ON EH.[Emp_ID]= CH.[EmpID]
WHERE CH.[EmpID]IS NULL
--AND EH.[Emp_Job_Code]in ('WACS01','WACS02','WACS03')
OPTION (MAXDOP 1)
END


WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms


END --sp_Update_CSR_Hierarchy




GO

