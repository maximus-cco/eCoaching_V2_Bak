using eCLAdmin.Models.Report;
using System.Collections.Generic;

namespace eCLAdmin.Services
{
    public interface IReportService
    {
        List<eCLAdmin.Models.EmployeeLog.Action> GetActions(int logTypeId);
        List<string> GetLogNames(string logType, string action, string startDate, string endDate);

        // Admin Activity Report
        List<AdminActivity> GetActivityList(string logType, string action, string logName, string startDate, string endDate, string logOrEmpName, int pageSize, int rowStartIndex, out int totalRows);
    }
}