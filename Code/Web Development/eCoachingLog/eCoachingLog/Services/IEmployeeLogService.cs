using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.EmployeeLog;
using eCoachingLog.Models.User;
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
		IList<LogSource> GetAllLogSources(string userEmpId);
		IList<LogValue> GetAllLogValues();
		DataTable GetLogDataTable(LogFilter filter, string userId);
		List<LogBase> GetLogList(LogFilter logFilter, string userId, int pageSize, int startRowIndex, string sortBy, string sortDirection, string search);
		int GetLogListTotal(LogFilter logFiler, string userId, string search);
	}
}
