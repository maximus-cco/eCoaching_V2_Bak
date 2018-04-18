using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.EmployeeLog;
using eCoachingLog.Models.User;
using System;
using System.Collections.Generic;
using System.Data;

namespace eCoachingLog.Services
{
    public interface IEmployeeLogService
    {
        List<Module> GetModules(string userLanId, int logTypeId);
        List<Module> GetModules(User user);
        List<LogBase> GetLogsByLogName(string logName);
        BaseLogDetail GetLogDetail(long logId, bool isCoaching);
        // Get call record id and id format
        List<CallType> GetCallTypes(int moduleId);
        List<WarningType> GetWarningTypes(int moduleId, string source, bool specialReason, int reasonPriority, string employeeId, string userId);
        List<WarningReason> GetWarningReasons(int warningTypeId, string directOrIndirect, int moduleId, string employeeId);
        List<CoachingReason> GetCoachingReasons(string directOrIndirect, int moduleId, string userId, string employeeId, bool isSpecialResaon, int specialReasonPriority);
        List<CoachingSubReason> GetCoachingSubReasons(int reasonId, int moduleId, string directOrIndirect, string employeeLanId);
        List<Behavior> GetBehaviors(int moduleId);
        List<string> GetValues(int reasonId, string directOrIndirect, int moduleId);
		List<LogReason> GetReasonsByLogId(long logId);

		List<LogBase> GetLogList(string userLanId, string status, bool isCoaching, DateTime startTime, DateTime endTime, int pageSize, int startRowIndex, string sortBy, string sortAsc, string search);
		int GetLogListTotal(string userLanId, string status, bool isCoaching, DateTime startTime, DateTime endTime, string search);

		IList<LogStatus> GetAllLogStatuses();
		IList<LogSource> GetAllLogSources(string userLanId);
		IList<LogValue> GetAllLogValues();

		DataTable GetLogDataTable(LogFilter filter);
	}
}
