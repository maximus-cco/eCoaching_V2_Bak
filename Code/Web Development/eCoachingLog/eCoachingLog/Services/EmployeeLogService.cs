using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.EmployeeLog;
using eCoachingLog.Models.MyDashboard;
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

        public List<Module> GetModules(User user)
        {

            return employeeLogRepository.GetModules(user);
        }

        public BaseLogDetail GetLogDetail(long logId, bool isCoaching)
        {
            BaseLogDetail logDetail = null;
            if (isCoaching)
            {
                logDetail = employeeLogRepository.GetCoachingDetail(logId);
				if (logDetail.IsQualityNowLog)
				{
					logDetail.Scorecards = employeeLogRepository.GetScorecards(logId);
				}
            }
            else
            {
                logDetail = employeeLogRepository.GetWarningDetail(logId);
            }
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

		public List<LogReason> GetReasonsByLogId(long logId, bool isCoaching)
		{
			List<LogReason> reasons = new List<LogReason>();
			var reasonTuples = employeeLogRepository.GetReasonsByLogId(logId, isCoaching);
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

		public List<LogBase> GetLogList(LogFilter logFilter, string userId, int pageSize, int startRowIndex, string sortBy, string sortDirection, string search)
		{
			List<LogBase> logs = employeeLogRepository.GetLogList(logFilter, userId, pageSize, startRowIndex, sortBy, sortDirection, search);
			foreach (LogBase log in logs)
			{
				// Log New Text
				try
				{
					if (!string.IsNullOrEmpty(log.CreatedDate) && (DateTime.Today - Convert.ToDateTime(log.CreatedDate)).Days < 1)
					{
						log.LogNewText = "New!";
					}
					else
					{
						log.LogNewText = string.Empty;
					}


					if (log.IsFollowupRequired)
					{
						var today = DateTime.Now;
						var followupDueDate = DateTime.Parse(log.FollowupDueDate.Replace("PDT", ""));
						if (today.Date == followupDueDate.Date)
						{
							log.LogNewText += "&nbsp;<span class='glyphicon glyphicon-bell'></span> Due";
						}
						else if (today.Date > followupDueDate.Date)
						{
							log.LogNewText += "&nbsp;<span class='glyphicon glyphicon-bell'></span> Overdue";
						}
						else
						{
							log.LogNewText += "&nbsp;<span class='glyphicon glyphicon-bell'></span>";
						}
					}
					// To be safe, clean follow up date if followup is not required, in case there is inconsistant data
					else
					{
						log.FollowupDueDate = null;
					}
				}
				catch (Exception ex)
				{
					logger.Debug("Error converting createdate to datetime: " + ex.Message);
				}

				// Created Date displays PDT
				// log.CreatedDate = eCoachingLogUtil.AppendPdt(log.CreatedDate);
				// Reasons
				log.Reasons = log.Reasons.Replace("|", "<br />");
				log.SubReasons = log.SubReasons.Replace("|", "<br />");
				log.Value = log.Value.Replace("|", "<br />");
			}

			return logs;
		}

		public int GetLogListTotal(LogFilter logFilter, string userId, string search)
		{
			return employeeLogRepository.GetLogListTotal(logFilter, userId, search);
		}

		public IList<LogStatus> GetAllLogStatuses()
		{
			return this.employeeLogRepository.GetAllLogStatuses();
		}

		public IList<LogSource> GetAllLogSources(string userEmpId)
		{
			return this.employeeLogRepository.GetAllLogSources(userEmpId);
		}

		public IList<LogValue> GetAllLogValues()
		{
			return this.employeeLogRepository.GetAllLogValues();
		}

		public DataSet GetLogDataTableToExport(LogFilter logFilter, string userId)
		{
			return this.employeeLogRepository.GetLogDataTableToExport(logFilter, userId);
		}

		public int GetLogCountToExport(LogFilter logFilter, string userId)
		{
			return this.employeeLogRepository.GetLogCountToExport(logFilter, userId);
		}

		public DataSet GetLogDataTableToExport(int siteId, string status, string start, string end, string userId)
		{
			return this.employeeLogRepository.GetLogDataTableToExport(siteId, status, start, end, userId);
		}

		public int GetLogCountToExport(int siteId, string status, string start, string end, string userId)
		{
			return this.GetLogCountToExport(siteId, status, start, end, userId);
		}

		public IList<LogState> GetWarningStatuses(User user)
		{
			if (user == null)
			{
				logger.Info("User is null.");
				return new List<LogState>();
			}
			return employeeLogRepository.GetWarningStatuses(user);
		}

		public IList<LogCount> GetLogCounts(User user)
		{
			return employeeLogRepository.GetLogCounts(user);
		}

		public IList<ChartDataset> GetChartDataSets(User user)
		{
			return employeeLogRepository.GetChartDataSets(user);
		}

		public IList<LogCountForSite> GetLogCountsForSites(User user, DateTime start, DateTime end)
		{
			return employeeLogRepository.GetLogCountsForSites(user, start, end);
		}

		public IList<LogCountByStatusForSite> GetLogCountByStatusForSites(User user, DateTime start, DateTime end)
		{
			return employeeLogRepository.GetLogCountByStatusForSites(user, start, end);
		}
	}
}