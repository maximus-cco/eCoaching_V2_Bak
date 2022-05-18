using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace eCoachingLog.Models.Common
{
	public class LogCountByStatusForSite
	{
		public string SiteName { get; set; }
		public string Status { get; set; }
		public int Count { get; set; }
	}
}