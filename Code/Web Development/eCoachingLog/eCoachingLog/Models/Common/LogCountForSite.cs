using System;

namespace eCoachingLog.Models.Common
{
	public class LogCountForSite
	{
		public int SiteId { get; set; }
		public string SiteName { get; set; }
		public int TotalPending { get; set; }
		public int TotalCompleted { get; set; }
		public int TotalWarning { get; set; }

		private string selectedMonthYear;
		public string SelectedMonthYear
		{
			get
			{
				return DateTime.Now.ToString("MMMM yyyy");
			}
			set
			{
				selectedMonthYear = value;
			}
		}
	}
}