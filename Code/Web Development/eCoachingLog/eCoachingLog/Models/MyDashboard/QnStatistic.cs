using System;

namespace eCoachingLog.Models.MyDashboard
{
    public class QnStatistic
    {
        public DateTime ThisMonth { get; set; }

        public string Name { get; set; }
        public int ThisMonthImproved { get; set; }
        public int ThisMonthFollowup { get; set; }
        public int ThisMonthMinus1Improved { get; set; }
        public int ThisMonthMinus1Followup { get; set; }
        public int ThisMonthMinus2Improved { get; set; }
        public int ThisMonthMinus2Followup { get; set; }

        public string ThisMonthStr
        {
            get
            {
                return ThisMonth.ToString("MMMM yyyy");
            }
        }

        public QnStatistic()
        {
            this.ThisMonth = DateTime.Now;
        }

        public QnStatistic( DateTime cMonth, string name,
             int cImproved, int cFollowup, 
             int pImproved, int pFollowup,
             int ppImproved, int ppFollowup)
        {
            this.Name = name;
            this.ThisMonth = cMonth;
            this.ThisMonthImproved = cImproved;
            this.ThisMonthFollowup = cFollowup;
            this.ThisMonthMinus1Improved = pImproved;
            this.ThisMonthMinus1Followup = pFollowup;
            this.ThisMonthMinus2Improved = ppImproved;
            this.ThisMonthMinus2Followup = ppFollowup;
        }
    }
}