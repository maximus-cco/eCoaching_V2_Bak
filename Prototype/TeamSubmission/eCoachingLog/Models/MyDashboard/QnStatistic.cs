using System;

namespace eCoachingLog.Models.MyDashboard
{
    public class QnStatistic
    {
        public DateTime ThisMonthMinus1 { get; set; }

        public string Name { get; set; }
        public int ThisMonthMinus1Improved { get; set; }
        public int ThisMonthMinus1Followup { get; set; }
        public int ThisMonthMinus2Improved { get; set; }
        public int ThisMonthMinus2Followup { get; set; }
        public int ThisMonthMinus3Improved { get; set; }
        public int ThisMonthMinus3Followup { get; set; }
    }
}