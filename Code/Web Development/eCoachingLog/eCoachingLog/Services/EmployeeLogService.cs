using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.EmployeeLog;
using eCoachingLog.Models.MyDashboard;
using eCoachingLog.Models.User;
using eCoachingLog.Repository;
using eCoachingLog.Utils;
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
				if (logDetail.IsQn || logDetail.IsQnSupervisor)
				{
                    var temp = employeeLogRepository.GetScorecardsAndSummary(logId);
                    ((CoachingLogDetail)logDetail).Scorecards = temp.Scorecards;
                    ((CoachingLogDetail)logDetail).QnSummaryList = temp.QnSummaryList;
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

		public List<LogReason> GetReasonsByLogId(long logId, bool isCoaching, string selectedReasonText, string selectedSubReasonText)
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

                if (!string.IsNullOrEmpty(selectedReasonText) && reason.Description == selectedReasonText)
                {
                    reason.Description = EclUtil.BoldSubstring(reason.Description, reason.Description);
                }

                if (!string.IsNullOrEmpty(selectedSubReasonText))
                {
                    for (int i = 0; i < reason.SubReasons.Count(); i++)
                    {
                        if (reason.SubReasons[i] == selectedSubReasonText)
                        {
                            reason.SubReasons[i] = EclUtil.BoldSubstring(reason.SubReasons[i], reason.SubReasons[i]);
                        }
                    }
                }

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
						log.LogNewText += "&nbsp;<span class='glyphicon glyphicon-bell'></span>";

						var today = DateTime.Now;
						var followupDueDate = DateTime.Parse(log.FollowupDueDate.Replace(Constants.TIMEZONE, ""));
						// Log NOT Completed && Follow-up has not happened yet
						if (!string.Equals(log.Status.Trim(), Constants.LOG_STATUS_COMPLETED_TEXT, StringComparison.OrdinalIgnoreCase)
								&& !log.HasFollowupHappened)
						{
							if (today.Date == followupDueDate.Date)
							{
								log.LogNewText += " Due";
							}
							else if (today.Date > followupDueDate.Date)
							{
								log.LogNewText += " Overdue";
							}
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

				// Created Date displays timezone
				// log.CreatedDate = EclUtil.AppendTimeZone(log.CreatedDate);
				// Reasons
				log.Reasons = log.Reasons.Replace("|", "<br />");
				log.SubReasons = log.SubReasons.Replace("|", "<br />");
				log.Value = log.Value.Replace("|", "<br />");

                // if search by reason and sub reason, bold the selected reason and sub reason if not ALL
                if (logFilter.ReasonId != -1 && !string.IsNullOrEmpty(logFilter.ReasonText))
                {
                    log.Reasons = EclUtil.BoldSubstring(log.Reasons, logFilter.ReasonText);
                }

                if (logFilter.SubReasonId != -1 && !string.IsNullOrEmpty(logFilter.SubReasonText))
                {
                    log.SubReasons = EclUtil.BoldSubstring(log.SubReasons, logFilter.SubReasonText);
                }
            }

			return logs;
		}

        public List<LogBase> GetLogListQn(LogFilter logFilter, string userId, int pageSize, int startRowIndex, string sortBy, string sortDirection, string search)
        {
            List<LogBase> logs = employeeLogRepository.GetLogListQn(logFilter, userId, pageSize, startRowIndex, sortBy, sortDirection, search);
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
                }
                catch (Exception ex)
                {
                    logger.Debug("Error converting createdate to datetime: " + ex.Message);
                }

                // Created Date displays timezone
                // log.CreatedDate = EclUtil.AppendTimeZone(log.CreatedDate);
                // Reasons
                log.Reasons = log.Reasons.Replace("|", "<br />");
                log.SubReasons = log.SubReasons.Replace("|", "<br />");
                log.Value = log.Value.Replace("|", "<br />");
            }

            return logs;
        }

        public int GetLogListTotal(LogFilter logFilter, User user, string search)
		{
			return employeeLogRepository.GetLogListTotal(logFilter, user, search);
		}

        public int GetLogListTotalQn(LogFilter logFilter, User user, string search)
        {
            return employeeLogRepository.GetLogListTotalQn(logFilter, user, search);
        }

        public IList<LogStatus> GetAllLogStatuses()
		{
			return this.employeeLogRepository.GetAllLogStatuses();
		}

        public IList<LogStatus> GetQnLogPendingStatuses()
        {
            var all = GetAllLogStatuses();
            var pendingStatusList = new List<LogStatus>();
            pendingStatusList.Add(new LogStatus(Constants.ALL_STATUSES, "All Pending Statuses"));
            foreach (var a in all)
            {
                if (a.Id == Constants.LOG_STATUS_PENDING_EMPLOYEE_REVIEW ||
                    a.Id == Constants.LOG_STATUS_PENDING_SUPERVISOR_REVIEW ||
                    a.Id == Constants.LOG_STATUS_PENDING_FOLLOWUP_PREPARATION ||
                    a.Id == Constants.LOG_STATUS_PENDING_FOLLOWUP_COACHING ||
                    a.Id == Constants.LOG_STATUS_PENDING_FOLLOWUP_EMPLOYEE_REVIEW)
                {
                    pendingStatusList.Add(a);
                }
            }

            pendingStatusList = pendingStatusList.OrderBy(x => x.Description).ToList(); 

            return pendingStatusList;
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

        public IList<LogCount> GetLogCountsQn(User user)
        {
            return employeeLogRepository.GetLogCountsQn(user);
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

        public IList<QnStatistic> GetPast3MonthStatisticQn(User user)
        {
            return employeeLogRepository.GetPast3MonthStatisticQn(user);
        }

        public IList<TextValue> GetReasons(int sourceId, User user)
        {
            return employeeLogRepository.GetReasons(sourceId, user);
        }

        public IList<TextValue> GetSubReasons(int sourceId, User user)
        {
            return employeeLogRepository.GetSubReasons(sourceId, user);
        }

    }
}