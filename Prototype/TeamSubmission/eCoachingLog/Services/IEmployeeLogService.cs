using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.EmployeeLog;
using eCoachingLog.Models.MyDashboard;
using eCoachingLog.Models.Review;
using eCoachingLog.Models.User;
using System;
using System.Collections.Generic;
using System.Data;

namespace eCoachingLog.Services
{
	public interface IEmployeeLogService
    {
        List<Module> GetModules(User user);
        BaseLogDetail GetLogDetail(long logId, bool isCoaching);
        // Get call record id and id format
        List<CallType> GetCallTypes(int moduleId);
        List<WarningType> GetWarningTypes(int moduleId, string source, bool specialReason, int reasonPriority, string employeeId, string userId);
        List<WarningReason> GetWarningReasons(int warningTypeId, string directOrIndirect, int moduleId, string employeeId);
        List<CoachingReason> GetCoachingReasons(string directOrIndirect, int moduleId, string userId, string employeeId, bool isSpecialResaon, int specialReasonPriority);
        List<CoachingSubReason> GetCoachingSubReasons(int reasonId, int moduleId, string directOrIndirect, string employeeLanId);
        List<Behavior> GetBehaviors(int moduleId);
        List<string> GetValues(int reasonId, string directOrIndirect, int moduleId);
		List<LogReason> GetReasonsByLogId(long logId, bool isCoaching);
		IList<LogStatus> GetAllLogStatuses();
        IList<LogStatus> GetQnLogPendingStatuses();
        IList<LogSource> GetAllLogSources(string userEmpId);
		IList<LogValue> GetAllLogValues();
		// Historical Dashboard page - export to excel
		DataSet GetLogDataTableToExport(LogFilter filter, string userId);
		int GetLogCountToExport(LogFilter filter, string userId);
		// Get logs for director that the director is in charge of, for the specified site, status, start/end dates
		// My Dashboard page - Director - export to excel
		DataSet GetLogDataTableToExport(int siteId, string status, string start, string end, string userId);
		int GetLogCountToExport(int siteId, string status, string start, string end, string userId);

		List<LogBase> GetLogList(LogFilter logFilter, string userId, int pageSize, int startRowIndex, string sortBy, string sortDirection, string search);
		int GetLogListTotal(LogFilter logFiler, User user, string search);

        List<LogBase> GetLogListQn(LogFilter logFilter, string userId, int pageSize, int startRowIndex, string sortBy, string sortDirection, string search);
        int GetLogListTotalQn(LogFilter logFiler, User user, string search);

        //List<LogBase> GetLogList_QN_Followup(LogFilter logFilter, string userId, int pageSize, int startRowIndex, string sortBy, string sortDirection, string search);

        IList<LogState> GetWarningStatuses(User user);

		IList<LogCount> GetLogCounts(User user);
		IList<ChartDataset> GetChartDataSets(User user);
        IList<LogCount> GetLogCountsQn(User user);
        //IList<ChartDataset> GetChartDataSetsQn(User user);
        IList<QnStatistic> GetPast3MonthStatisticQn(User user);

        IList<LogCountForSite> GetLogCountsForSites(User user, DateTime start, DateTime end);
		IList<LogCountByStatusForSite> GetLogCountByStatusForSites(User user, DateTime start, DateTime end);
	}
}
