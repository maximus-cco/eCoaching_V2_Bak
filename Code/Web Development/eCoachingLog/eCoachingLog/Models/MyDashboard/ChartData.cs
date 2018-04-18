using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace eCoachingLog.Models.MyDashboard
{
	public class ChartData
	{
		public IList<string> xLabels { get; set; }
		public IList<ChartDatasets> datasets {get; set;}

		public ChartData()
		{
			xLabels = new List<string>();
			datasets = new List<ChartDatasets>();
		}
	}
}