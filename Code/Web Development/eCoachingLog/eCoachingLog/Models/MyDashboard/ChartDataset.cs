using System.Collections.Generic;

namespace eCoachingLog.Models.MyDashboard
{
	public class ChartDataset
	{
		public string label { get; set; }
		public IList<int> data {get; set;}
		public bool fill { get; set; }
		public string backgroundColor { get; set; }
		public string borderColor { get; set; }

		public ChartDataset()
		{
			data = new List<int>();
		}
	}
}