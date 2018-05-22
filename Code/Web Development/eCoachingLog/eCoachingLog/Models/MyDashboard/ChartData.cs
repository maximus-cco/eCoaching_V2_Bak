using System.Collections.Generic;

namespace eCoachingLog.Models.MyDashboard
{
	public class ChartData
	{
		public IList<string> xLabels { get; set; }
		public IList<ChartDataset> datasets {get; set;}

		public ChartData()
		{
			xLabels = new List<string>();
			datasets = new List<ChartDataset>();
		}
	}
}