using eCLAdmin.Extensions;
using eCLAdmin.Models.EmployeeLog;
using eCLAdmin.Models.User;
using eCLAdmin.Repository;
using log4net;
using System;
using System.Collections.Generic;

namespace eCLAdmin.Services
{
    public class EmployeeLogService : IEmployeeLogService 
    {
        readonly ILog logger = LogManager.GetLogger(typeof(EmployeeLogService));

        private readonly IEmployeeLogRepository employeeLogRepository;

        public EmployeeLogService(IEmployeeLogRepository employeeLogRepository)
        {
            this.employeeLogRepository = employeeLogRepository;
        }

        public List<Module> GetModules(string userLanId, int logTypeId)
        {

            return employeeLogRepository.GetModules(userLanId, logTypeId);
        }

        public List<Models.EmployeeLog.Type> GetTypes(User user, string action)
        {
            List<Models.EmployeeLog.Type> types = new List<Models.EmployeeLog.Type>();
            List<Entitlement> entitlements = user.Entitlements;

            // reassign - only return coaching
            if (Constants.LOG_ACTION_REASSIGN.Equals(action))
            {
                Models.EmployeeLog.Type type = new Models.EmployeeLog.Type();
                type.Id = (int)EmployeeLogType.Coaching;
                type.Description = EmployeeLogType.Coaching.ToDescription();
                types.Add(type);

                return types;
            }

            foreach (Entitlement entitlement in entitlements)
            {
                if (Constants.LOG_ACTION_REACTIVATE.Equals(action))
                {
                    if (entitlement.Name.Equals(Constants.ENTITLEMENT_REACTIVATE_COACHING_LOGS))
                    {
                        Models.EmployeeLog.Type type = new Models.EmployeeLog.Type();
                        type.Id = (int)EmployeeLogType.Coaching;
                        type.Description = EmployeeLogType.Coaching.ToDescription();
                        types.Add(type);
                    }

                    if (entitlement.Name.Equals(Constants.ENTITLEMENT_REACTIVATE_WARNING_LOGS))
                    {
                        Models.EmployeeLog.Type type = new Models.EmployeeLog.Type();
                        type.Id = (int)EmployeeLogType.Warning;
                        type.Description = EmployeeLogType.Warning.ToDescription();
                        types.Add(type);
                    }

                    continue;
                }

                if (entitlement.Name.Equals(Constants.ENTITLEMENT_MANAGE_COACHING_LOGS))
                {
                    Models.EmployeeLog.Type type = new Models.EmployeeLog.Type();
                    type.Id = (int)EmployeeLogType.Coaching;
                    type.Description = EmployeeLogType.Coaching.ToDescription();
                    types.Add(type);
                }

                if (entitlement.Name.Equals(Constants.ENTITLEMENT_MANAGE_WARNING_LOGS))
                {
                    Models.EmployeeLog.Type type = new Models.EmployeeLog.Type();
                    type.Id = (int)EmployeeLogType.Warning;
                    type.Description = EmployeeLogType.Warning.ToDescription();
                    types.Add(type);
                }
            }
            
            return types;
        }

        public List<EmployeeLog> SearchLog(bool searchByLogName, int moduleId, int logTypeId, string employeeId, string logName, string action, string userLanId)
        {
            if (searchByLogName)
            {
                moduleId = -1;
                employeeId = null;
            }
            else
            {
                logName = null;
            }

            return employeeLogRepository.SearchLog(moduleId, logTypeId, employeeId, logName?.Trim(), action, userLanId);
        }

        public EmployeeLog GetLogByLogName(int logTypeId, string logName, string action, string userLanId)
        {
            return employeeLogRepository.GetLogByLogName(logTypeId, logName, action, userLanId);
        }

        public List<EmployeeLog> SearchLogForReassign(bool searchByLogName, int moduleId, int statusId, string reviewerEmpId, string logName)
        {
            if (searchByLogName)
            {
                moduleId = -1;
                statusId = -2;
                reviewerEmpId = null;
            }
            else
            {
                logName = null;
            }

            return employeeLogRepository.SearchLogForReassign(moduleId, statusId, reviewerEmpId, logName);

        }

        public List<Status> GetPendingStatuses(int moduleId)
        {
            var statusList = employeeLogRepository.GetPendingStatuses(moduleId);
            statusList.Insert(0, new Status { Id = -2, Description = "All" });
            return statusList;
        }

        public List<Reason> GetReasons(int logTypeId, string action)
        {
            List<Reason> reasons = new List<Reason>();
            try
            {
                reasons = employeeLogRepository.GetReasons(logTypeId, action);
            }
            catch (Exception ex)
            {
                logger.Debug("Exception thrown: " + ex.Message);
                throw ex;
            }

            return reasons;
        }

        public bool ProcessActivation(string userLanId, string action, int employeeLogType, List<long> employeeLogIds, int reasonId, string otherReasonText, string comment)
        {
            bool retValue = false;

            try
            {
                employeeLogRepository.ProcessActivation(userLanId, action, employeeLogType, employeeLogIds, reasonId, otherReasonText, comment);
                retValue = true;
            }
            catch (Exception ex)
            {
                logger.Debug("Exception thrown: " + ex.Message);
            }

            return retValue;
        }

        public bool ProcessReassignment(string userLanId, List<long> employeeLogIds, string assignedToEmployeeId, int reasonId, string otherReasonText, string comment)
        {
            bool retValue = false;

            try
            {
                employeeLogRepository.ProcessReassignment(userLanId, employeeLogIds, assignedToEmployeeId, reasonId, otherReasonText, comment);
                retValue = true;
            }
            catch (Exception ex)
            {
                logger.Debug("Exception thrown: " + ex.Message);
            }

            return retValue;
        }

        public List<EmployeeLog> GetLogsByLogName(string logName)
        {
            return employeeLogRepository.GetLogsByLogName(logName);
        }

        public LogDetailBase GetLogDetail(long logId, bool isCoaching)
        {
            LogDetailBase logDetail = null;
            if (isCoaching)
            {
                logDetail = employeeLogRepository.GetCoachingDetail(logId);
            }
            else
            {
                logDetail = employeeLogRepository.GetWarningDetail(logId);
            }

            logDetail.Reasons = logDetail.Reasons.Replace("|", "<br />");
            logDetail.SubReasons = logDetail.SubReasons.Replace("|", "<br />");
            logDetail.Value = logDetail.Value.Replace("|", "<br />");
            return logDetail;
        }

        public bool Delete(long logId, bool isCoaching)
        {
            return employeeLogRepository.Delete(logId, isCoaching);
        }
    }
}