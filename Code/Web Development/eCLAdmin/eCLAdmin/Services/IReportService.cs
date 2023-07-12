using eCLAdmin.Models.Report;
using System.Collections.Generic;
using System.Data;

namespace eCLAdmin.Services
{
    public interface IReportService
    {
        List<eCLAdmin.Models.EmployeeLog.Action> GetActions(int logTypeId);
        List<string> GetLogNames(string logType, string action, string startDate, string endDate);

        // Admin Activity Report
        List<AdminActivity> GetActivityList(string logType, string action, string logName, string startDate, string endDate, string logOrEmpName, int pageSize, int rowStartIndex, out int totalRows);
        // Export to excel
        DataSet GetActivityList(string logType, string action, string logName, string startDate, string endDate, string logOrEmpName);

        // Employee Hierarchy Report
        List<EmployeeHierarchy> GetEmployeeHierarchy(string site, string employeeId, int pageSize, int rowStartIndex, out int totalRows);
        // Export to excel
        DataSet GetEmployeeHierarchy(string site, string employeeId);
    }
}