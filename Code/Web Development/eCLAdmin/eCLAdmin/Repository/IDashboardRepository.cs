using eCLAdmin.Models.Dashboard;
using eCLAdmin.Models.EmployeeLog;
using System;
using System.Collections.Generic;

namespace eCLAdmin.Repository
{
    public interface IDashboardRepository
    {
        int GetLogCount(string userLanId, string status, bool isCoaching, DateTime startTime, DateTime endTime);
        List<EmployeeLog> GetLogList(string userLanId, string status, bool isCoaching, DateTime startTime, DateTime endTime, int pageSize, int startRowIndex, string sortBy, string sortAsc, string search);
        int GetLogListTotal(string userLanId, string status, bool isCoaching, DateTime startTime, DateTime endTime, string search);
        CoachingLogDetail GetCoachingDetail(long id);
        WarningLogDetail GetWarningDetail(long id);
        List<ChartCoachingCompleted> GetChartDataCoachingCompleted(string userLanId, DateTime startTime, DateTime endTime);
        List<ChartCoachingPending> GetChartDataCoachingPending(string userLanId, DateTime startTime, DateTime endTime);
        List<ChartWarningActive> GetChartDataWarningActive(string userLanId, DateTime startTime, DateTime endTime);
    }
}
