using eCLAdmin.Models.Dashboard;
using eCLAdmin.Models.EmployeeLog;
using eCLAdmin.Repository;
using log4net;
using System;
using System.Collections.Generic;

namespace eCLAdmin.Services
{
    public class DashboardService : IDashboardService
    {
        readonly ILog logger = LogManager.GetLogger(typeof(DashboardService));

        private readonly IDashboardRepository dashboardRepository;

        public DashboardService(IDashboardRepository dashboardRepository)
        {
            this.dashboardRepository = dashboardRepository;
        }

        public int GetLogCount(string userLanId, string status, bool isCoaching, DateTime startTime, DateTime endTime)
        {
            return dashboardRepository.GetLogCount(userLanId, status, isCoaching, startTime, endTime);
        }

        public List<EmployeeLog> GetLogList(string userLanId, string status, bool isCoaching, DateTime startTime, DateTime endTime, int pageSize, int startRowIndex, string sortBy, string sortAsc, string search)
        {
            List<EmployeeLog> logs = dashboardRepository.GetLogList(userLanId, status, isCoaching, startTime, endTime, pageSize, startRowIndex, sortBy, sortAsc, search);
            
            foreach(EmployeeLog log in logs)
            {
                log.Reasons = log.Reasons.Replace("|", "<br />");
                log.SubReasons = log.SubReasons.Replace("|", "<br />");
                log.Value = log.Value.Replace("|", "<br />");
            }

            return logs;
        }

        public List<ChartCoachingCompleted> GetChartDataCoachingCompleted(string userLanId, DateTime startTime, DateTime endTime)
        {
            return dashboardRepository.GetChartDataCoachingCompleted(userLanId, startTime, endTime);
        }

        public List<ChartCoachingPending> GetChartDataCoachingPending(string userLanId, DateTime startTime, DateTime endTime)
        {
            return dashboardRepository.GetChartDataCoachingPending(userLanId, startTime, endTime);
        }

        public List<ChartWarningActive> GetChartDataWarningActive(string userLanId, DateTime startTime, DateTime endTime)
        {
            return dashboardRepository.GetChartDataWarningActive(userLanId, startTime, endTime);
        }

        public int GetLogListTotal(string userLanId, string status, bool isCoaching, DateTime startTime, DateTime endTime, string search)
        {
            return dashboardRepository.GetLogListTotal(userLanId, status, isCoaching, startTime, endTime, search);
        }
    }
}