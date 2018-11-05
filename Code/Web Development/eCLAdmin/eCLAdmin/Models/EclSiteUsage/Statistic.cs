using System;

namespace eCLAdmin.Models.EclSiteUsage
{
	public class Statistic
	{
		public string TimeSpan { get; set; }
		public int TotalHitsNewSubmission { get; set; }
		public int TotalUsersNewSubmission { get; set; }
		public int TotalHitsMyDashboard { get; set; }
		public int TotalUsersMyDashboard { get; set; }
		public int TotalHitsHistorical { get; set; }
		public int TotalUsersHistorical { get; set; }
		public int TotalHitsReview { get; set; }
		public int TotalUsersReview { get; set; }

		public Statistic()
		{
			this.TimeSpan = string.Empty;
			this.TotalHitsNewSubmission = 0;
			this.TotalUsersNewSubmission = 0;
			this.TotalHitsMyDashboard = 0;
			this.TotalUsersMyDashboard = 0;
			this.TotalHitsHistorical = 0;
			this.TotalUsersHistorical = 0;
			this.TotalHitsReview = 0;
			this.TotalUsersReview = 0;
		}
	}
}