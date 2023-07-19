using eCLAdmin.Models.EmployeeLog;
using eCLAdmin.Models.Report;
using eCLAdmin.Models.User;
using eCLAdmin.ViewModels.Reports;
using System.Collections.Generic;
using System.Data;

namespace eCLAdmin.Repository
{
    public interface IReportRepository
    {
        List<eCLAdmin.Models.EmployeeLog.Action> GetActions(string logType);
        List<string> GetLogNames(string logType, string action, string startDate, string endDate);
        List<Module> GetEmployeeLevels(User user);
        List<Reason> GetReasonsByModuleId(int moduleId, bool isWarning);
        List<Reason> GetSubreasons(int reasonId, bool isWarning);
        List<Status> GetLogStatusList(int moduleId, bool isWarning);
        List<Status> GetWarningLogStates(); // Active, Expired, All
        // admin activity summary report
        List<AdminActivity> GetActivityList(string logType, string action, string logName, string startDate, string endDate, string logOrEmpName,
            int pageSize, int rowStartIndex, out int totalRows);
        DataSet GetActivityList(string logType, string action, string logName, string startDate, string endDate, string logOrEmpName);
        // employee hierarchy report
        List<EmployeeHierarchy> GetEmployeeHierarchy(string site, string employeeId, int pageSize, int rowStartIndex, out int totalRows);
        DataSet GetEmployeeHierarchy(string site, string employeeId);
        // coaching log report
        List<CoachingLog> GetCoachingLogs(CoachingSearchViewModel search, out int totalRows);
        DataSet GetCoachingLogs(CoachingSearchViewModel search);
        // coaching log qn report
        List<CoachingLogQn> GetCoachingLogQns(QualityNowSearchViewModel search, out int totalRows);
        DataSet GetCoachingLogQns(QualityNowSearchViewModel search);
        // warning report
        List<WarningLog> GetWarningLogs(WarningSearchViewModel search, out int totalRows);
        DataSet GetWarningLogs(WarningSearchViewModel search);
    }
}