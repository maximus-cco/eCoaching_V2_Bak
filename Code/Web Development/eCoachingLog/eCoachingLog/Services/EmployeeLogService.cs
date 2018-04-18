using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.EmployeeLog;
using eCoachingLog.Models.User;
using eCoachingLog.Repository;
using log4net;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace eCoachingLog.Services
{
    public class EmployeeLogService : IEmployeeLogService 
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        private readonly IEmployeeLogRepository employeeLogRepository;

        public EmployeeLogService(IEmployeeLogRepository employeeLogRepository)
        {
            this.employeeLogRepository = employeeLogRepository;
        }

        public List<Module> GetModules(string userLanId, int logTypeId)
        {

            return employeeLogRepository.GetModules(userLanId, logTypeId);
        }

        public List<Module> GetModules(User user)
        {

            return employeeLogRepository.GetModules(user);
        }

        public List<LogBase> GetLogsByLogName(string logName)
        {
            return employeeLogRepository.GetLogsByLogName(logName);
        }

        public BaseLogDetail GetLogDetail(long logId, bool isCoaching)
        {
            BaseLogDetail logDetail = null;
            if (isCoaching)
            {
                logDetail = employeeLogRepository.GetCoachingDetail(logId);
            }
            else
            {
                logDetail = employeeLogRepository.GetWarningDetail(logId);
            }

            //logDetail.Reasons = logDetail.Reasons.Replace("|", "<br />");
            //logDetail.SubReasons = logDetail.SubReasons.Replace("|", "<br />");
            //logDetail.Value = logDetail.Value.Replace("|", "<br />");
            return logDetail;
        }

        public List<CallType> GetCallTypes(int moduleId)
        {
            return employeeLogRepository.GetCallTypes(moduleId);
        }

        public List<WarningType> GetWarningTypes(int moduleId, string source, bool specialReason, int reasonPriority, string employeeId, string userId)
        {
            return employeeLogRepository.GetWarningTypes(moduleId, source, specialReason, reasonPriority, employeeId, userId);
        }

        public List<WarningReason> GetWarningReasons(int warningTypeId, string directOrIndirect, int moduleId, string employeeId)
        {
            return employeeLogRepository.GetWarningReasons(warningTypeId, directOrIndirect, moduleId, employeeId);
        }

        public List<CoachingReason> GetCoachingReasons(string directOrIndirect, int moduleId, string userLanId, string employeeLanId, bool isSpecialResaon, int specialReasonPriority)
        {
            return employeeLogRepository.GetCoachingReasons(directOrIndirect, moduleId, userLanId, employeeLanId, isSpecialResaon, specialReasonPriority);
        }

        public List<string> GetValues(int reasonId, string directOrIndirect, int moduleId)
        {
            return employeeLogRepository.GetValues(reasonId, directOrIndirect, moduleId);
        }

        public List<CoachingSubReason> GetCoachingSubReasons(int reasonId, int moduleId, string directOrIndirect, string employeeLanId)
        {
            return employeeLogRepository.GetCoachingSubReasons(reasonId, moduleId, directOrIndirect, employeeLanId);
        }

        public List<Behavior> GetBehaviors(int moduleId)
        {
            return employeeLogRepository.GetBehaviors(moduleId);
        }

		public List<LogReason> GetReasonsByLogId(long logId)
		{
			List<LogReason> reasons = new List<LogReason>();
			var reasonTuples = employeeLogRepository.GetReasonsByLogId(logId);
			var distinctReasons = reasonTuples.Select(x => x.Item1).Distinct();

			foreach (var distinctReason in distinctReasons)
			{
				LogReason reason = new LogReason();
				reason.Description = distinctReason;
				reason.SubReasons = reasonTuples.Where(x => x.Item1 == distinctReason).Select(x => x.Item2).ToList();
				reason.Value = reasonTuples.Where(x => x.Item1 == distinctReason).Select(x => x.Item3).First();

				reasons.Add(reason);
			}

			return reasons;
		}

		public List<LogBase> GetLogList(string userLanId, string status, bool isCoaching, DateTime startTime, DateTime endTime, int pageSize, int startRowIndex, string sortBy, string sortAsc, string search)
		{
			List<LogBase> logs = employeeLogRepository.GetLogList(userLanId, status, isCoaching, startTime, endTime, pageSize, startRowIndex, sortBy, sortAsc, search);

			foreach (LogBase log in logs)
			{
				log.Reasons = log.Reasons.Replace("|", "<br />");
				log.SubReasons = log.SubReasons.Replace("|", "<br />");
				log.Value = log.Value.Replace("|", "<br />");
			}

			return logs;
		}

		public int GetLogListTotal(string userLanId, string status, bool isCoaching, DateTime startTime, DateTime endTime, string search)
		{
			return employeeLogRepository.GetLogListTotal(userLanId, status, isCoaching, startTime, endTime, search);
		}

		public IList<LogStatus> GetAllLogStatuses()
		{
			return this.employeeLogRepository.GetAllLogStatuses();
		}

		public IList<LogSource> GetAllLogSources(string userLanId)
		{
			return this.employeeLogRepository.GetAllLogSources(userLanId);
		}

		public IList<LogValue> GetAllLogValues()
		{
			return this.employeeLogRepository.GetAllLogValues();
		}

		public DataTable GetLogDataTable(LogFilter logFilter)
		{
			return this.employeeLogRepository.GetLogDataTable(logFilter);
		}
	}
}