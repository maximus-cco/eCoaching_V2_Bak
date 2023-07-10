using eCLAdmin.Models.Report;
using System.Collections.Generic;
using System.Data;

namespace eCLAdmin.Repository
{
    public interface IReportRepository
    {
        List<eCLAdmin.Models.EmployeeLog.Action> GetActions(string logType);
        List<string> GetLogNames(string logType, string action, string startDate, string endDate);
        List<AdminActivity> GetActivityList(string logType, string action, string logName, string startDate, string endDate, string logOrEmpName,
            int pageSize, int rowStartIndex, out int totalRows);
        DataSet GetActivityList(string logType, string action, string logName, string startDate, string endDate, string logOrEmpName);
    }
}
