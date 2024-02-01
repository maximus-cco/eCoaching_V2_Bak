namespace eCoachingLog.Models.Common
{
	public class LogCountByStatusForSite
	{
		public string SiteName { get; set; }
        public bool IsSubcontractorSite { get; set; }
		public string Status { get; set; }
		public int Count { get; set; }
	}
}