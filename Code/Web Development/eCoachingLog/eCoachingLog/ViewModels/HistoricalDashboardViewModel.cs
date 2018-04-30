using eCoachingLog.Models.Common;
using System;

namespace eCoachingLog.ViewModels
{
	public class HistoricalDashboardViewModel : BaseViewModel
	{
		// Datatables column show/hide
		public bool ShowSupNameColumn { get; set; }

		//public HistoricalDashboardViewModel() : base()
		//{
		//	this.Search = new LogFilter();
		//}
	}
}