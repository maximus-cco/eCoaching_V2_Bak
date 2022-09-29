namespace eCoachingLog.ViewModels
{
	public class HistoricalDashboardViewModel : BaseViewModel
	{
		// Whether Export to Exel is allowed
		public bool IsExportExcel { get; set; }

        public bool AllowSearchWarning { get; set; }

	}
}