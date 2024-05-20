using eCoachingLog.Models.Common;
using eCoachingLog.Models.MyDashboard;
using eCoachingLog.Models.User;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace eCoachingLog.ViewModels
{
    public class MyDashboardQnViewModel : MyDashboardViewModel
    {

        // Supervisor creates/updates/ log summary
        public bool AllowCreateEditSummary { get; set; }
        // Supervisor coaches csr or isg/enters notes
        public bool AllowCoach { get; set; }
        // Csr/Isg reviews/enters notes 
        public bool AllowCsrReview { get; set; } // allow csr/isg review
        // Supervisor followup to determine if additional coaching needed
        public bool AllowFollowupReview { get; set; }
        public bool ReadOnly { get; set; }

        public bool ShowMyTeamPerformance { get; set; }
        public bool ShowMyPerformance { get; set; }
        // Last 3 months performance
        public string MonthMinus1
        {
            get
            {
                return DateTime.Now.AddMonths(-1).ToString("MMMM yyyy");
            }
        }
        public string MonthMinus2
        {
            get
            {
                return DateTime.Now.AddMonths(-2).ToString("MMMM yyyy");
            }
        }
        public string MonthMinus3
        {
            get
            {
                return DateTime.Now.AddMonths(-3).ToString("MMMM yyyy");
            }
        }
        public IList<QnStatistic> Statistic { get; set; }

        public MyDashboardQnViewModel()
        {
            this.LogCountList = new List<LogCount>();
            this.Statistic = new List<QnStatistic>();
        }

        public MyDashboardQnViewModel(User user) : base(user)
        {
        }

    }
}