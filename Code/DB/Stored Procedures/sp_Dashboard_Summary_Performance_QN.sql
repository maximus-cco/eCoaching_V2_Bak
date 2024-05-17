
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	08/03/2021
--	Description: *	This procedure returns the Improved or Follow-up required counts
--                  for the previous 3 months. CSRs can see their own performance where as Supervisors 
--                  and Managers can see their team performance.

--  Initial Revision. Quality Now workflow enhancement. TFS 22187 - 09/03/2021
-- Modified to Support ISG Alignment Project. TFS 28026 - 05/06/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_Dashboard_Summary_Performance_QN] 
@nvcUserId nvarchar(10)

AS

BEGIN
set nocount on;
DECLARE	
@nvcEmpRole nvarchar(40),
@nvcCols nvarchar(max),
@nvcSQL nvarchar(max);


OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert] 
SET @nvcEmpRole = [EC].[fn_strGetUserRole](@nvcUserId )
--PRINT @nvcEmpRole

  declare
 @sdate datetime = (select DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-3, 0))  --First day of 3 months ago
,@edate datetime = (select DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)); --Last Day of previous month


  ;with emp as
(select distinct eh.emp_id as EmpID
from ec.Employee_Hierarchy eh 
where (@nvcEmpRole in ('CSR','ISG', 'ARC') and eh.emp_id = @nvcUserId)
or (@nvcEmpRole in ('Supervisor', 'Manager') and (eh.Emp_Job_Code like N'WACS0%')
and (eh.Sup_ID = @nvcUserId OR eh.Mgr_ID = @nvcUserId OR eh.SrMgrLvl1_ID = @nvcUserId OR eh.SrMgrLvl2_ID = @nvcUserId))
and Active = 'A'
)


 --select * from  emp;

 ,months as 
(select distinct  dd.[CalendarYearMonth], (dd.[MonthName] + ' ' + convert(nvarchar(4),dd.[CalendarYear])) as YearMonth
from  EC.DIM_Date dd
where Fulldate between convert(nvarchar(23), @sdate, 121)   and   convert(nvarchar(23), @edate, 121) 
)

,empmonths as
(
select emp.* , months.YearMonth
from emp, months
)
--select * from empmonths;

,rawcounts as
(
select eh.empid,  cl.CoachingID,
  (dd.[MonthName] + ' ' + convert(nvarchar(4),dd.[CalendarYear])) as YearMonth,
COALESCE(IsFollowupRequired, 2) as IsFollowupRequired
from emp eh left join ec.Coaching_Log cl WITH (NOLOCK)
on eh.empid = cl.empid inner join  EC.DIM_Date dd
on dateadd(dd, datediff(dd, 0, cl.SubmittedDate),0) = dd.Fulldate 
where SubmittedDate between   convert(nvarchar(23), @sdate, 121)   and  convert(nvarchar(23), @edate, 121)
and sourceid = 235 )

 --select * from rawcounts

   ,counts as 
 (select r.empid, rtrim(r.YearMonth)as CalendarYearMonth, 
sum(case when IsFollowupRequired = 0 then 1 else 0 end)  improved, 
sum(case when r.IsFollowupRequired = 1 then 1 else 0 end) followup
from rawcounts r
group by r.empid, r.YearMonth)

--select * from counts

,tempresult as
(select em.EmpID, veh.Emp_Name as EmpName,  em.YearMonth, coalesce(c.improved, 0) Improved, coalesce(c.followup, 0) FollowUp
from empmonths em inner join EC.View_Employee_Hierarchy veh
on em.EmpID = veh.Emp_ID left join counts c
on em.EmpID = c.EmpID and em.YearMonth = c.CalendarYearMonth)

--select * from tempresult;

select * into #temp from tempresult;

-- Variable @nvcSQL holds the new columns the data will be pivoted on to be used in the dynamic pivot sql

select @nvcCols = STUFF((SELECT ',' + QUOTENAME(YearMonth+'_'+col) 
                   from #temp t cross apply
                    (
                    	select 'Improved', 1 union all
						select 'Followup', 2
                    ) c (col, so)
                    group by  col, so, YearMonth
                    order by CASE when YearMonth like 'Jan%' then 1
					when YearMonth like 'Feb%' then 2
					when YearMonth like 'Mar%' then 3
					when YearMonth like 'Apr%' then 4
					when YearMonth like 'May%' then 5
					when YearMonth like 'Jun%' then 6
					when YearMonth like 'Jul%' then 7
					when YearMonth like 'Aug%' then 8
					when YearMonth like 'Sep%' then 9
					when YearMonth like 'Oct%' then 10
					when YearMonth like 'Nov%' then 11
					when YearMonth like 'Dec%' then 12  END, so
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

--print @nvcCols;
--[August 2021_Improved],[August 2021_Followup],[July 2021_Improved],[July 2021_Followup],[June 2021_Improved],[June 2021_Followup]

/*

-- Unpivot the data

select EmpID, EmpName, col = YearMonth + '_' + col, value
from #temp t cross apply
(
	select 'Improved', Improved  union all
	select 'Followup', FollowUp 
) c (col, value);

-- Then pivot back to display the rows as columns
-- This is the static pivot with actual values hardcoded used for testing

select EmpID, EmpName, 
    [July 2021_Improved], [July 2021_Followup], [June 2021_Improved], [June 2021_Followup],
    [August 2021_Improved], [August 2021_Followup]
from
(
    select EmpID, EmpName,
        col = YearMonth+'_'+col, 
        value
  from #temp t cross apply
	(
		select 'Improved', Improved  union all
		select 'Followup', FollowUp 
	) c (col, value)
) d
pivot
(
    max(value)
    for col in ( [July 2021_Improved], [July 2021_Followup], [June 2021_Improved], [June 2021_Followup],
    [August 2021_Improved], [August 2021_Followup])
) piv;
*/

set @nvcSQL = 'SELECT EmpID, EmpName,' + @nvcCols + ' 
            from 
            (
                select EmpID, EmpName, 
                    col = YearMonth + ''_'' + col,
                    value
                from #temp t 
				cross apply
                (
					select ''Improved'', Improved  union all
					select ''Followup'', FollowUp 
				) c (col, value)
            ) x
            pivot 
            (
               max(value)
                for col in (' + @nvcCols + ')
            ) p '

			
--Print (@nvcSQL)
Exec(@nvcSQL)

-- Drop Temp table
Drop table #temp;

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 
	    
If @@ERROR <> 0 GoTo ErrorHandler;

SET NOCOUNT OFF;

Return(0);
  
ErrorHandler:
    Return(@@ERROR);
	    
END --sp_Dashboard_Summary_Performance_QN
GO


