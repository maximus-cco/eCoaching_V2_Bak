using System;

namespace eCoachingLog.Models.Common
{
	public class LogCountForSite
	{
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

		// Put it in View model
		//public IEnumerable<SelectListItem> Months
		//{
		//	get
		//	{
		//		var now = DateTime.Now;
		//		var lastTwelveMonths = Enumerable.Range(0, 12).Select(i => now.AddMonths(-i).ToString("MMMM yyyy"));

		//		return lastTwelveMonths.Select(
		//					month => new SelectListItem
		//					{
		//						Text = month,
		//						Value = Convert.ToDateTime(month).ToString("MMM yyyy", System.Globalization.CultureInfo.InvariantCulture)
		//					});
		//	}
		//}

	}
}