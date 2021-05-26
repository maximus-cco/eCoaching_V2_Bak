using System.ComponentModel.DataAnnotations;

namespace eCoachingLog.Models.Common
{
	public class Scorecard
	{
		public string EvalId { get; set; }
		public string EvalName { get; set; }
		public string ScorecardName { get; set; }
		public string VerintId { get; set; }
		public string DateOfEvent { get; set; }
		public string Program { get; set; }
		public string CoachingMonitor { get; set; }
		public string SubmitterName { get; set; }
		public string BehaviorDetail { get; set; }
		public string BusinessProcess { get; set; }
		public string InfoAccuracy { get; set; }
		public string PrivacyDisclaimers { get; set; }
		public string IssueResolution { get; set; }
		public string CallEfficiency { get; set; }
		public string ActiveListening { get; set; }
		public string PersonalityFlexing { get; set; }
        public string Channel { get; set; }
        public string ActivityId { get; set; } // UCID/Verizon Call ID for Web Chat; DCN for Written Correspondence
        // Show Supervisors ONLY
        public string ContactReason { get; set; }
        public string ContactReasonComment { get; set;  }
        public string StartTemperature { get; set; }
		public string EndTemperature { get; set; }
	}
}