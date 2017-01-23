/*
CCO_eCoaching_Common_Indexes_Create.sql(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

**************************************************************

--Index List by Table

**************************************************************


-- Coaching_Log
IDX_Coaching_Log_FormName_submittedDate
IDX_Coaching_Log_SubmitterID
IDX_Coaching_Log_K6_K1_K4_K5_K9_K8_K24
_dta_index_Coaching_Log_28_2105058535__K8_K4_K5_K24_2
_dta_index_Coaching_Log_26_1333579789__K8_K56_K43_K53_K36_K5_K24_1_2
_dta_index_Coaching_Log_26_1333579789__K5_K24_K41_1_8
_dta_index_Coaching_Log_31_418100530__K5_K8_K24_2_9
_dta_index_Coaching_Log_26_1333579789__K41_K5_K32_K1_K8_K4_2_9_24
_dta_index_Coaching_Log_26_1333579789__K5_K32_K41_K8_K1




-- Coaching_Log_Reason
IDX_Coaching_Log_Reason_Value
_dta_index_Coaching_Log_Reason_26_1269579561__K1_K4



-- Warning_Log
_dta_index_Warning_Log_26_1828201563__K17_K5_K15_K16_K1_K8


-- Employee_Hierarchy
IDX_Employee_Hierarchy_Emp_LANID
IDX_Employee_Hierarchy_Emp_Sup_Mgr_Names
IDX_Employee_Hierarchy_Sup_ID
IDX_Employee_Hierarchy_Mgr_ID
_dta_index_Employee_Hierarchy_28_69575286__K4_K1_2_10_16
_dta_index_Employee_Hierarchy_26_846626059__K24_K1_K25_K26
_dta_index_Employee_Hierarchy_26_846626059__K26_K1_K24_K25
_dta_index_Employee_Hierarchy_26_846626059__K25_K1_K24_K26




**************************************************************

--Index Creates

**************************************************************/

	


-- 1. Coaching_Log - IDX_Coaching_Log_FormName_submittedDate


--old cl 1

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Coaching_Log_FormName_SubmittedDate') 
    DROP INDEX IDX_Coaching_Log_FormName_SubmittedDate ON [EC].[Coaching_Log]; 
GO

CREATE NONCLUSTERED INDEX [IDX_Coaching_Log_FormName_submittedDate] ON [EC].[Coaching_Log]
     (
     [FormName]ASC, [SubmittedDate] ASC
     )
      WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


--*************************************************************************

-- 2. Coaching_Log - IDX_Coaching_Log_SubmitterID

--old cl 2

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Coaching_Log_SubmitterID') 
    DROP INDEX [IDX_Coaching_Log_SubmitterID]
ON [EC].[Coaching_Log]; 
GO

CREATE NONCLUSTERED INDEX [IDX_Coaching_Log_SubmitterID] ON [EC].[Coaching_Log]
     (
	[SubmitterID] ASC
     )
   INCLUDE ([FormName], [StatusID], [EmpID], [SubmittedDate])
      WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO




--*************************************************************************

-- 3. Coaching_Log - IDX_Coaching_Log_K6_K1_K4_K5_K9_K8_K24

--old cl 3

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Coaching_Log_K6_K1_K4_K5_K9_K8_K24') 
    DROP INDEX IDX_Coaching_Log_K6_K1_K4_K5_K9_K8_K24 
ON [EC].[Coaching_Log]; 
GO

CREATE NONCLUSTERED INDEX [IDX_Coaching_Log_K6_K1_K4_K5_K9_K8_K24] ON [EC].[Coaching_Log] 
(
	[SiteID] ASC,
	[CoachingID] ASC,
	[SourceID] ASC,
	[StatusID] ASC,
	[SubmitterID] ASC,
	[EmpID] ASC,
	[SubmittedDate] ASC
	)
INCLUDE ([FormName])
WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO


--*************************************************************************

-- 4. Coaching_Log - _dta_index_Coaching_Log_28_2105058535__K8_K4_K5_K24_2



--old cl 4

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Coaching_Log_28_2105058535__K8_K4_K5_K24_2') 
    DROP INDEX _dta_index_Coaching_Log_28_2105058535__K8_K4_K5_K24_2
ON [EC].[Coaching_Log]; 
GO

CREATE NONCLUSTERED INDEX [_dta_index_Coaching_Log_28_2105058535__K8_K4_K5_K24_2] ON [EC].[Coaching_Log] 
(
	[EmpID] ASC,
	[SourceID] ASC,
	[StatusID] ASC,
	[SubmittedDate] ASC
)
INCLUDE ( [FormName]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
GO

--*************************************************************************

-- 5. Coaching_Log - _dta_index_Coaching_Log_26_1333579789__K8_K56_K43_K53_K36_K5_K24_1_2

-- pld cl 5 (set 2 - single return)

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Coaching_Log_26_1333579789__K8_K56_K43_K53_K36_K5_K24_1_2') 
    DROP INDEX _dta_index_Coaching_Log_26_1333579789__K8_K56_K43_K53_K36_K5_K24_1_2 
ON [EC].[Coaching_Log]; 
GO

CREATE NONCLUSTERED INDEX [_dta_index_Coaching_Log_26_1333579789__K8_K56_K43_K53_K36_K5_K24_1_2] ON [EC].[Coaching_Log] 
(
	[EmpID] ASC,
	[ReassignedToID] ASC,
	[MgrID] ASC,
	[ReassignCount] ASC,
	[strReportCode] ASC,
	[StatusID] ASC,
	[SubmittedDate] ASC
)
INCLUDE ( [CoachingID],
[FormName]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO


--*************************************************************************

-- 6. Coaching_Log - _dta_index_Coaching_Log_26_1333579789__K5_K24_K41_1_8

--sr dash cl 1


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Coaching_Log_26_1333579789__K5_K24_K41_1_8') 
    DROP INDEX _dta_index_Coaching_Log_26_1333579789__K5_K24_K41_1_8 
ON [EC].[Coaching_Log]; 
GO


CREATE NONCLUSTERED INDEX [_dta_index_Coaching_Log_26_1333579789__K5_K24_K41_1_8] ON [EC].[Coaching_Log] 
(
	[StatusID] ASC,
	[SubmittedDate] ASC,
	[ModuleID] ASC
)
INCLUDE ( [CoachingID],
[EmpID]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO

--*************************************************************************

-- 7. Coaching_Log - _dta_index_Coaching_Log_31_418100530__K5_K8_K24_2_9

--sr dash cl 2

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Coaching_Log_31_418100530__K5_K8_K24_2_9') 
    DROP INDEX _dta_index_Coaching_Log_31_418100530__K5_K8_K24_2_9 
ON [EC].[Coaching_Log]; 
GO


CREATE NONCLUSTERED INDEX [_dta_index_Coaching_Log_31_418100530__K5_K8_K24_2_9] ON [EC].[Coaching_Log] 
(
	[StatusID] ASC,
	[EmpID] ASC,
	[SubmittedDate] ASC
)
INCLUDE ( [FormName],
[SubmitterID]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO



--*********************************

-- 8. Coaching_Log - _dta_index_Coaching_Log_26_1333579789__K41_K5_K32_K1_K8_K4_2_9_24

--sr dash cl 3


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Coaching_Log_26_1333579789__K41_K5_K32_K1_K8_K4_2_9_24') 
    DROP INDEX _dta_index_Coaching_Log_26_1333579789__K41_K5_K32_K1_K8_K4_2_9_24 
ON [EC].[Coaching_Log] ; 
GO


--comp details

CREATE NONCLUSTERED INDEX [_dta_index_Coaching_Log_26_1333579789__K41_K5_K32_K1_K8_K4_2_9_24] ON [EC].[Coaching_Log] 
(
	[ModuleID] ASC,
	[StatusID] ASC,
	[CSRReviewAutoDate] ASC,
	[CoachingID] ASC,
	[EmpID] ASC,
	[SourceID] ASC
)
INCLUDE ( [FormName],
[SubmitterID],
[SubmittedDate]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO

--*********************************

-- 9. Coaching_Log - _dta_index_Coaching_Log_26_1333579789__K5_K32_K41_K8_K1

--sr dash cl 4


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Coaching_Log_26_1333579789__K5_K32_K41_K8_K1') 
    DROP INDEX _dta_index_Coaching_Log_26_1333579789__K5_K32_K41_K8_K1 
ON [EC].[Coaching_Log] ; 
GO


--comp by week

CREATE NONCLUSTERED INDEX [_dta_index_Coaching_Log_26_1333579789__K5_K32_K41_K8_K1] ON [EC].[Coaching_Log] 
(
	[StatusID] ASC,
	[CSRReviewAutoDate] ASC,
	[ModuleID] ASC,
	[EmpID] ASC,
	[CoachingID] ASC
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

GO




--****************************************************************

--1. Coaching_Log_Reason - IDX_Coaching_Log_Reason_Value


--old clr 1


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Coaching_Log_Reason_Value') 
    DROP INDEX IDX_Coaching_Log_Reason_Value ON [EC].[Coaching_Log_Reason]; 
GO


CREATE NONCLUSTERED INDEX [IDX_Coaching_Log_Reason_Value] ON [EC].[Coaching_Log_Reason]
     (
     [Value]ASC
     )
     WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO



--*************************************************************************

--2. Coaching_Log_Reason - _dta_index_Coaching_Log_Reason_26_1269579561__K1_K4

--sr dash clr 2

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Coaching_Log_Reason_26_1269579561__K1_K4') 
    DROP INDEX _dta_index_Coaching_Log_Reason_26_1269579561__K1_K4 
ON [EC].[Coaching_Log_Reason] ; 
GO


CREATE NONCLUSTERED INDEX [_dta_index_Coaching_Log_Reason_26_1269579561__K1_K4] ON [EC].[Coaching_Log_Reason] 
(
	[CoachingID] ASC,
	[Value] ASC
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO


--****************************************************************

--1. Warning_Log - _dta_index_Warning_Log_26_1828201563__K17_K5_K15_K16_K1_K8



IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Warning_Log_26_1828201563__K17_K5_K15_K16_K1_K8') 
    DROP INDEX _dta_index_Warning_Log_26_1828201563__K17_K5_K15_K16_K1_K8 
ON [EC].[Warning_Log] ; 
GO


CREATE NONCLUSTERED INDEX [_dta_index_Warning_Log_26_1828201563__K17_K5_K15_K16_K1_K8] ON [EC].[Warning_Log] 
(
	[Active] ASC,
	[StatusID] ASC,
	[SubmittedDate] ASC,
	[ModuleID] ASC,
	[WarningID] ASC,
	[EmpID] ASC
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO


--*************************************************************************

--1. employee_Hierarchy - IDX_Employee_Hierarchy_Emp_LANID

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Employee_Hierarchy_Emp_LANID') 
    DROP INDEX IDX_Employee_Hierarchy_Emp_LANID ON [EC].[Employee_Hierarchy]; 
GO
CREATE NONCLUSTERED INDEX [IDX_Employee_Hierarchy_Emp_LANID] ON [EC].[Employee_Hierarchy]
     (
     [Emp_LANID]ASC
     )
          WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

--*************************************************************************


--2. employee_Hierarchy - IDX_Employee_Hierarchy_Emp_Sup_Mgr_Names


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Employee_Hierarchy_Emp_Sup_Mgr_Names') 
    DROP INDEX IDX_Employee_Hierarchy_Emp_Sup_Mgr_Names ON [EC].[Employee_Hierarchy]; 
GO
CREATE NONCLUSTERED INDEX [IDX_Employee_Hierarchy_Emp_Sup_Mgr_Names] ON [EC].[Employee_Hierarchy]
     (
	[Emp_Name] ASC,
	[Sup_Name] ASC,
	[Mgr_Name] ASC   
      )
     INCLUDE ([Emp_ID])
          WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


--*************************************************************************

--3. employee_Hierarchy - IDX_Employee_Hierarchy_Sup_ID


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Employee_Hierarchy_Sup_ID') 
    DROP INDEX IDX_Employee_Hierarchy_Sup_ID ON [EC].[Employee_Hierarchy]; 
GO

CREATE NONCLUSTERED INDEX [IDX_Employee_Hierarchy_Sup_ID] ON [EC].[Employee_Hierarchy]
     (
     [Sup_ID]ASC
     )
          WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO



--*************************************************************************


--4. employee_Hierarchy - IDX_Employee_Hierarchy_Mgr_ID


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Employee_Hierarchy_Mgr_ID') 
    DROP INDEX IDX_Employee_Hierarchy_Mgr_ID ON [EC].[Employee_Hierarchy]; 
GO

CREATE NONCLUSTERED INDEX [IDX_Employee_Hierarchy_Mgr_ID] ON [EC].[Employee_Hierarchy]
     (
     [Mgr_ID]ASC
     )
          WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


--****************************************************************


--5. employee_Hierarchy - _dta_index_Employee_Hierarchy_28_69575286__K4_K1_2_10_16

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Employee_Hierarchy_28_69575286__K4_K1_2_10_16') 
    DROP INDEX _dta_index_Employee_Hierarchy_28_69575286__K4_K1_2_10_16 ON [EC].[Employee_Hierarchy]; 
GO

CREATE NONCLUSTERED INDEX [_dta_index_Employee_Hierarchy_28_69575286__K4_K1_2_10_16] ON [EC].[Employee_Hierarchy] 
(
	[Sup_LanID] ASC,
	[Emp_LanID] ASC,
	[Emp_ID] ASC
)
INCLUDE ( [Emp_Name],
[Sup_Name],
[Mgr_Name]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO




--****************************************************************


--6. employee_Hierarchy - _dta_index_Employee_Hierarchy_26_846626059__K24_K1_K25_K26


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Employee_Hierarchy_26_846626059__K24_K1_K25_K26') 
    DROP INDEX _dta_index_Employee_Hierarchy_26_846626059__K24_K1_K25_K26
ON [EC].[Employee_Hierarchy] ; 
GO


CREATE NONCLUSTERED INDEX [_dta_index_Employee_Hierarchy_26_846626059__K24_K1_K25_K26] ON [EC].[Employee_Hierarchy] 
(
	[SrMgrLvl1_ID] ASC,
	[Emp_ID] ASC,
	[SrMgrLvl2_ID] ASC,
	[SrMgrLvl3_ID] ASC

	
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO


--****************************************************************



--7. employee_Hierarchy - _dta_index_Employee_Hierarchy_26_846626059__K26_K1_K24_K25

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Employee_Hierarchy_26_846626059__K26_K1_K24_K25') 
    DROP INDEX _dta_index_Employee_Hierarchy_26_846626059__K26_K1_K24_K25 
ON [EC].[Employee_Hierarchy] ; 
GO


CREATE NONCLUSTERED INDEX [_dta_index_Employee_Hierarchy_26_846626059__K26_K1_K24_K25] ON [EC].[Employee_Hierarchy] 
(
	[SrMgrLvl3_ID] ASC,
	[Emp_ID] ASC,
	[SrMgrLvl1_ID] ASC,
	[SrMgrLvl2_ID] ASC
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO
--****************************************************************



--8. employee_Hierarchy - 
IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Employee_Hierarchy_26_846626059__K25_K1_K24_K26') 
    DROP INDEX _dta_index_Employee_Hierarchy_26_846626059__K25_K1_K24_K26 
ON [EC].[Employee_Hierarchy] ; 
GO


CREATE NONCLUSTERED INDEX [_dta_index_Employee_Hierarchy_26_846626059__K25_K1_K24_K26] ON [EC].[Employee_Hierarchy] 
(
	[SrMgrLvl2_ID] ASC,
	[Emp_ID] ASC,
	[SrMgrLvl1_ID] ASC,
	[SrMgrLvl3_ID] ASC
	
	
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO

--****************************************************************

