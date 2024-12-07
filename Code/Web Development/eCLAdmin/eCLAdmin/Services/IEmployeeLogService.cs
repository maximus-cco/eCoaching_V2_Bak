﻿using eCLAdmin.Models.EmployeeLog;
using eCLAdmin.Models.User;
using System.Collections.Generic;

namespace eCLAdmin.Services
{
    public interface IEmployeeLogService
    {
        List<Module> GetModules(string userLanId, int logTypeId);

        List<Models.EmployeeLog.Type> GetTypes(User user, string action);

        // search log for inactivate/reactivate
        List<EmployeeLog> SearchLog(bool searchByLogName, int moduleId, int logTypeId, string employeeId, string logName, string action, string userLanId);

        EmployeeLog GetLogByLogName(int logTypeId, string logName, string action, string userLanId);

        // search log for reassign
        List<EmployeeLog> SearchLogForReassign(bool searchByLogName, int moduleId, int statusId, string reviewerEmpId, string logName, User user);

        List<Status> GetPendingStatuses(int moduleId);

        List<Reason> GetReasons(int logTypeId, string action);

        bool ProcessActivation(string userLanId, string action, int employeeLogType, List<long> employeeLogIds, int reasonId, string otherReasonText, string comment);

        bool ProcessReassignment(string userLanId, List<long> employeeLogIds, string assignedToEmployeeId, int reasonId, string otherReasonText, string comment);

        List<EmployeeLog> GetLogsByLogName(string logName);

        LogDetailBase GetLogDetail(long logId, bool isCoaching);

        bool Delete(long logId, bool isCoaching);
    }
}
