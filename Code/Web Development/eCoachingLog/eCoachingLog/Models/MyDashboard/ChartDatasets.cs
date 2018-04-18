using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace eCoachingLog.Models.MyDashboard
{
	public class ChartDatasets
	{
		public string label { get; set; }
		public IList<int> data {get; set;}
		public bool fill { get; set; }
		public string backgroundColor { get; set; }
		public string borderColor { get; set; }

		public ChartDatasets()
		{
			data = new List<int>();
		}
	}
}