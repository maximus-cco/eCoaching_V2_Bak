using eCLAdmin.Models.EmployeeLog;
using System.Collections.Generic;

namespace eCLAdmin.Repository
{
    public interface IEmployeeLogRepository
    {
        List<Module> GetModules(string userLanId, int logTypeId);

        List<EmployeeLog> GetLogsByEmpIdAndAction(int moduleId, int logTypeId, string employeeId, string action);

        List<EmployeeLog> GetPendingLogsByReviewerEmpId(int moduleId, int statusId, string reviewerEmpId);

        List<Status> GetPendingStatuses(int moduleId);

        List<Reason> GetReasons(int logTypeId, string action);

        void ProcessActivation(string userLanId, string action, int employeeLogType, List<long> employeeLogIds, int reasonId, string otherReasonText, string comment);

        void ProcessReassignment(string userLanId, List<long> employeeLogIds, string assignedToEmployeeId, int reasonId, string otherReasonText, string comment);
    }

}
