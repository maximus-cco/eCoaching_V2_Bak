using System.ComponentModel.DataAnnotations;

namespace eCoachingLog.Models.Common
{
	public class Scorecard
	{
		public string EvalName { get; set; }
		[Display(Name = "Form Name:")]
		public string ScorecardName { get; set; }
		public string VerintId { get; set; }
		[Display(Name = "Date of Event:")]
		public string DateOfEvent { get; set; }
		[Display(Name = "Coaching Monitor:")]
		public string CoachingMonitor { get; set; }
		[Display(Name = "Submitter:")]
		public string SubmitterName { get; set; }
		[Display(Name = "Details of the behavior being coached:")]
		public string BehaviorDetail { get; set; }
		[Display(Name = "Business Process:")]
		public string BusinessProcess { get; set; }
		[Display(Name = "Info Accuracy:")]
		public string InfoAccuracy { get; set; }
		[Display(Name = "Privacy Disclaimers:")]
		public string PrivacyDisclaimers { get; set; }
		[Display(Name = "Issue Resolution:")]
		public string IssueResolution { get; set; }
		[Display(Name = "Call Efficiency:")]
		public string CallEfficiency { get; set; }
		[Display(Name = "Active Listening:")]
		public string ActiveListening { get; set; }
		[Display(Name = "Personality Flexing:")]
		public string PersonalityFlexing { get; set; }
		// Show Supervisors ONLY
		[Display(Name = "Start Temperature:")]
		public string StartTemperature { get; set; }
		[Display(Name = "End Temperature:")]
		public string EndTemperature { get; set; }

		//public Scorecard()
		//{
		//	this.ScorecardName = "H: CCO QN Medicare - Quality v.1";
		//	this.CallId = "123456789";
		//	this.CoachingMonitor = "Yes";
		//	this.DateOfEvent = "01/25/2019 3:37:00 PM PDT";
		//	this.SubmitterName = "Leferink, William J";
		//	this.BehaviorDetail = "";
		//	this.BusinessProcess = "Compliant";
		//	this.InfoAccuracy = "Compliant";
		//	this.PrivacyDisclaimers = "Compliant";
		//	this.IssueResolution = "Novice";
		//	this.CallEfficiency = "Emerging";
		//	this.ActiveListening = "Effective";
		//	this.PersonalityFlexing = "Expert";

		//	this.StartTemperature = "1";
		//	this.EndTemperature = "5";
		//}
	}
}