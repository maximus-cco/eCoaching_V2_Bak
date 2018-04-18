using eCoachingLog.Models.Common;
using System;

namespace eCoachingLog.ViewModels
{
	public class HistoricalDashboardViewModel : BaseViewModel
	{
		public int ActiveEmployee { get; set; }
		public string SubmitDateFrom { get; set; }
		public string SubmitDateTo { get; set; }

		public LogFilter Search { get; set; }

		// Datatables column show/hide
		public bool ShowSupNameColumn { get; set; }

		public HistoricalDashboardViewModel() : base()
		{
			this.Search = new LogFilter();
			this.ActiveEmployee = 1;
			this.SubmitDateFrom = DateTime.Now.AddDays(-30).ToString("yyyy-MM-dd");
			this.SubmitDateTo = DateTime.Now.ToString("yyyy-MM-dd");
		}
	}
}