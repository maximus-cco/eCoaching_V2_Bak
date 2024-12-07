﻿using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.EmployeeLog;
using eCoachingLog.Models.MyDashboard;
using eCoachingLog.Models.User;
using System;
using System.Collections.Generic;
using System.Data;

namespace eCoachingLog.Repository
{
	public interface IEmployeeLogRepository
    {
        List<Module> GetModules(User user);
        CoachingLogDetail GetCoachingDetail(long logId);
        WarningLogDetail GetWarningDetail(long logId);
		List<Tuple<string, string, string>> GetReasonsByLogId(long logId, bool isCoaching);
		List<CallType> GetCallTypes(int moduleId);
        List<WarningType> GetWarningTypes(int moduleId, string source, bool specialReason, int reasonPriority, string employeeId, string userId, int? sourceId);
        List<WarningReason> GetWarningReasons(int reasonId, string directOrIndirect, int moduleId, string employeeId, int? sourceId);
        List<CoachingReason> GetCoachingReasons(string directOrIndirect, int moduleId, string userId, string employeeId, bool isSpecialResaon, int specialReasonPriority, int? sourceId);
        List<CoachingSubReason> GetCoachingSubReasons(int reasonId, int moduleId, string directOrIndirect, string employeeLanId, int sourceId);
        List<Behavior> GetBehaviors(int moduleId);
        List<string> GetValues(int reasonId, string directOrIndirect, int moduleId, int sourceId);

		IList<LogStatus> GetAllLogStatuses();
		IList<LogSource> GetAllLogSources(string userEmpId);
		IList<LogValue> GetAllLogValues();

		// Historical Dashboard - export to excel
		DataSet GetLogDataTableToExport(LogFilter logFilter, string userId);
		int GetLogCountToExport(LogFilter filter, string userId);
		// My Dashboard - director - export to excel
		DataSet GetLogDataTableToExport(int siteId, string status, string start, string end, string userId);
		int GetLogCountToExport(int siteId, string status, string start, string end, string userId);

		List<LogBase> GetLogList(LogFilter logFilter, string userId, int pageSize, int rowStartIndex, string sortBy, string sortDirection, string search);
		int GetLogListTotal(LogFilter logFilter, User user, string search);

        List<LogBase> GetLogListQn(LogFilter logFilter, string userId, int pageSize, int rowStartIndex, string sortBy, string sortDirection, string search);
        int GetLogListTotalQn(LogFilter logFilter, User user, string search);

        IList<LogState> GetWarningStatuses(User user);

		IList<LogCount> GetLogCounts(User user);
        IList<LogCount> GetLogCountsQn(User user);

        IList<ChartDataset> GetChartDataSets(User user);

		IList<LogCountForSite> GetLogCountsForSites(User user, DateTime start, DateTime end);
		IList<LogCountByStatusForSite> GetLogCountByStatusForSites(User user, DateTime start, DateTime end);

        CoachingLogDetail GetScorecardsAndSummary(long logId);

        IList<QnStatistic> GetPast3MonthStatisticQn(User user);

        IList<TextValue> GetReasons(int sourceId, User user);
        IList<TextValue> GetSubReasons(int sourceId, User user);

    }
}
