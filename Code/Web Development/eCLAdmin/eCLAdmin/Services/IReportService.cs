using eCLAdmin.Models.Common;
using eCLAdmin.Models.EmployeeLog;
using eCLAdmin.Models.Report;
using eCLAdmin.Models.User;
using eCLAdmin.ViewModels.Reports;
using System.Collections.Generic;
using System.Data;

namespace eCLAdmin.Services
{
    public interface IReportService
    {
        List<eCLAdmin.Models.EmployeeLog.Action> GetActions(int logTypeId);
        List<string> GetLogNames(string logType, string action, string startDate, string endDate);
        List<Module> GetEmployeeLevels(User user);
        List<Reason> GetReasonsByModuleId(int moduleId, bool isWarning);
        List<Reason> GetSubreasons(int reasonId, bool isWarning);
        List<Status> GetLogStatusList(int moduleId, bool isWarning);
        List<Status> GetWarningLogStates(); // Active, Expired, All
        List<IdName> GetFeedCategories();
        List<IdName> GetFeedReportCodes(int category);

        // Admin Activity Report
        List<AdminActivity> GetActivityList(string logType, string action, string logName, string startDate, string endDate, string logOrEmpName, int pageSize, int rowStartIndex, out int totalRows);
        // Export to excel
        DataSet GetActivityList(string logType, string action, string logName, string startDate, string endDate, string logOrEmpName);

        // Employee Hierarchy Report
        List<EmployeeHierarchy> GetEmployeeHierarchy(string site, string employeeId, int pageSize, int rowStartIndex, out int totalRows);
        // Export to excel
        DataSet GetEmployeeHierarchy(string site, string employeeId);

        // Coaching Log Report
        List<CoachingLog> GetCoachingLogs(CoachingSearchViewModel search, out int totalRows);
        // Export to excel
        DataSet GetCoachingLogs(CoachingSearchViewModel search);

        // Coaching Log Qn Report
        List<CoachingLogQn> GetCoachingLogQns(QualityNowSearchViewModel search, out int totalRows);
        // Export to excel
        DataSet GetCoachingLogQns(QualityNowSearchViewModel search);

        // Warning Log Report
        List<WarningLog> GetWarningLogs(WarningSearchViewModel search, out int totalRows);
        // Export to excel
        DataSet GetWarningLogs(WarningSearchViewModel search);

        // Feed Load History Report
        List<FeedLoadHistory> GetFeedLoadHistory(string startDate, string endDate, int categoryId, int reportCodeId, int pageSize, int rowStartIndex, out int totalRows);
        // Export to excel
        DataSet GeFeedLoadHistory(string startDate, string endDate, int categoryId, int reportCodeId);
    }
}