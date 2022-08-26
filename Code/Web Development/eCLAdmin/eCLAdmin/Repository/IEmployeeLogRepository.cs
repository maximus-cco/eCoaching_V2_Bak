using eCLAdmin.Models.EmployeeLog;
using System.Collections.Generic;

namespace eCLAdmin.Repository
{
    public interface IEmployeeLogRepository
    {
        List<Module> GetModules(string userLanId, int logTypeId);

        List<EmployeeLog> GetLogsByEmpIdAndAction(int moduleId, int logTypeId, string employeeId, string action, string userLanId);

        EmployeeLog GetLogByLogName(int logTypeId, string logName, string action, string userLanId);

        List<EmployeeLog> GetPendingLogsByReviewerEmpId(int moduleId, int statusId, string reviewerEmpId);

        List<Status> GetPendingStatuses(int moduleId);

        List<Reason> GetReasons(int logTypeId, string action);

        void ProcessActivation(string userLanId, string action, int employeeLogType, List<long> employeeLogIds, int reasonId, string otherReasonText, string comment);

        void ProcessReassignment(string userLanId, List<long> employeeLogIds, string assignedToEmployeeId, int reasonId, string otherReasonText, string comment);

        List<EmployeeLog> GetLogsByLogName(string logName);

        CoachingLogDetail GetCoachingDetail(long logId);

        WarningLogDetail GetWarningDetail(long logId);

        bool Delete(long logId, bool isCoaching);
    }

}
