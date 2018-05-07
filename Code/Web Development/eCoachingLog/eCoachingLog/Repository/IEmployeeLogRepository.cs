using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.EmployeeLog;
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
        List<WarningType> GetWarningTypes(int moduleId, string source, bool specialReason, int reasonPriority, string employeeId, string userId);
        List<WarningReason> GetWarningReasons(int reasonId, string directOrIndirect, int moduleId, string employeeId);
        List<CoachingReason> GetCoachingReasons(string directOrIndirect, int moduleId, string userId, string employeeId, bool isSpecialResaon, int specialReasonPriority);
        List<CoachingSubReason> GetCoachingSubReasons(int reasonId, int moduleId, string directOrIndirect, string employeeLanId);
        List<Behavior> GetBehaviors(int moduleId);
        List<string> GetValues(int reasonId, string directOrIndirect, int moduleId);

		//List<LogBase> GetLogList(string userLanId, string status, bool isCoaching, DateTime startTime, DateTime endTime, int pageSize, int startRowIndex, string sortBy, string sortAsc, string search);
		//int GetLogListTotal(string userLanId, string status, bool isCoaching, DateTime startTime, DateTime endTime, string search);

		IList<LogStatus> GetAllLogStatuses();
		IList<LogSource> GetAllLogSources(string userEmpId);
		IList<LogValue> GetAllLogValues();

		DataTable GetLogDataTable(LogFilter logFilter, string userId);

		List<LogBase> GetLogList(LogFilter logFilter, string userId, int pageSize, int rowStartIndex, string sortBy, string sortDirection, string search);
		int GetLogListTotal(LogFilter logFilter, string userId, string search);
	}
}
