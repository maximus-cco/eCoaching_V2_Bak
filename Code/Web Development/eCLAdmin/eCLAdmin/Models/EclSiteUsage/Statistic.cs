using System.ComponentModel.DataAnnotations;

namespace eCLAdmin.Models.EclSiteUsage
{
	public class Statistic
	{
		public string TimeSpan { get; set; }
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
		public string TimeSpanXLabel { get; set; }

		public Statistic()
		{
			this.TimeSpan = string.Empty;
			this.TimeSpanXLabel = string.Empty;
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