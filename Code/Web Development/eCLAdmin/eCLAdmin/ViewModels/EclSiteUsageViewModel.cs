using eCLAdmin.Models.EclSiteUsage;
using System;
using System.Collections.Generic;

namespace eCLAdmin.ViewModels
{
	public class EclSiteUsageViewModel
	{
		public string Start { get; set; }
		public string End { get; set; }
		public string ByWhat { get; set; }
		public string HeaderText { get; set; }
		public string TimeSpanColumnHeader { get; set; }
		public int TotalHitsNewSubmission { get; set; }
		public int TotalUsersNewSubmission { get; set; }
		public int TotalHitsMyDashboard { get; set; }
		public int TotalUsersMyDashboard { get; set; }
		public int TotalHitsHistorical { get; set; }
		public int TotalUsersHistorical { get; set; }
		public int TotalHitsReview { get; set; }
		public int TotalUsersReview { get; set; }
		public IList<Statistic> Statistics { get; set; }

		public EclSiteUsageViewModel()
		{
			this.Start = DateTime.Now.AddDays(-1).ToString(Constants.MMDDYYYY);
			this.End = DateTime.Now.ToString(Constants.MMDDYYYY);
			this.ByWhat = String.Empty;
			this.Statistics = new List<Statistic>();
		}
	}
}