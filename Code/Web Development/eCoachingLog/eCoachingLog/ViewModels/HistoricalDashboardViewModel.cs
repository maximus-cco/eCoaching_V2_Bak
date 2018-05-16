namespace eCoachingLog.ViewModels
{
	public class HistoricalDashboardViewModel : BaseViewModel
	{
		// Datatables column show/hide
		public bool ShowSupNameColumn { get; set; }
		// Whether Export to Exel is allowed
		public bool IsExportExcel { get; set; }

	}
}