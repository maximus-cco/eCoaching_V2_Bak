using eCLAdmin.Models.EclSiteUsage;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace eCLAdmin.ViewModels
{
	public class EclSiteUsageViewModel
	{
		public string Start { get; set; }
		public string End { get; set; }
		public string ByWhat { get; set; }
		public string HeaderText { get; set; }
		public string TimeSpanColumnHeader { get; set; }
		[DisplayFormat(DataFormatString = "{0: #,##0}")]
		public int TotalHitsNewSubmission { get; set; }
		[DisplayFormat(DataFormatString = "{0: #,##0}")]
		public int TotalUsersNewSubmission { get; set; }
		[DisplayFormat(DataFormatString = "{0: #,##0}")]
		public int TotalHitsMyDashboard { get; set; }
		[DisplayFormat(DataFormatString = "{0: #,##0}")]
		public int TotalUsersMyDashboard { get; set; }
		[DisplayFormat(DataFormatString = "{0: #,##0}")]
		public int TotalHitsHistorical { get; set; }
		[DisplayFormat(DataFormatString = "{0: #,##0}")]
		public int TotalUsersHistorical { get; set; }
		[DisplayFormat(DataFormatString = "{0: #,##0}")]
		public int TotalHitsReview { get; set; }
		[DisplayFormat(DataFormatString = "{0: #,##0}")]
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