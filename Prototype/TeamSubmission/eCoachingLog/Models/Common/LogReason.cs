using System.Collections.Generic;

namespace eCoachingLog.Models.Common
{
    public class LogReason
    {
        public int Id { get; set; }
        public string Description { get; set; }
		public List<string> SubReasons { get; set; }
		public string Value { get; set; }
    }
}