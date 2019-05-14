using System.Web.Mvc;

namespace eCoachingLog.Models.Common
{
	public class CoachingLogDetail : BaseLogDetail
    {
        public string ReassignedSupervisorName { get; set; }
        public string ReassignedManagerName { get; set; }

		public string ReassignedToEmpId { get; set; }

        // Supervisor who did the review
        public string ReviewedSupervisorName { get; set; }
        // Manager who did the review
        public string ReviewedManagerName { get; set; }

        public bool IsIqs { get; set; }
        public bool IsUcId { get; set; }
        public bool IsVerintMonitor { get; set; }
        public bool IsBehaviorAnalyticsMonitor { get; set; }
        public bool IsNgdActivityId { get; set; }
        public bool? IsConfirmedCse { get; set; }
		public bool? IsSubmittedAsCse { get; set; }

		public bool IsCtc { get; set; }
		public bool IsHigh5Club { get; set; }
		public bool IsKudo { get; set; }
		public bool IsAttendance { get; set; }
		public bool IsMsr { get; set; }
		public bool IsMsrs { get; set; }
		public bool IsLowCsat { get; set; }
		public bool IsCurrentCoachingInitiative { get; set; }
		public bool IsOmrException { get; set; }
		public bool IsEtsOae { get; set; }
		public bool IsEtsOas { get; set; }
		public bool IsEtsHnc { get; set; }
		public bool IsEtsIcc { get; set; }
		public bool IsOmrIae { get; set; }
		public bool IsOmrIaef { get; set; }
		public bool IsOmrIat { get; set; }
		public bool IsOmrShortCall { get; set; }
		public bool IsTrainingShortDuration { get; set; }
		public bool IsTrainingOverdue { get; set; }
		public bool IsBrn { get; set; }
		public bool IsBrl { get; set; } // break time exceeded
		public bool IsDtt { get; set; } // New Attendance Discrepancy feed
		public bool IsPbh { get; set; }
		public bool IsOta { get; set; } // OverTurned Appeal

		public bool HasEmpAcknowledged { get; set; }
		public bool HasSupAcknowledged { get; set; }

		public string UcId { get; set; }
        public string VerintId { get; set; }
        public string VerintFormName { get; set; }
        public string CoachingMonitor { get; set; }
        public string BehaviorAnalyticsId { get; set; }
        public string NgdActivityId { get; set; }

        public string Behavior { get; set; } // txtDescription
		[AllowHtml]
        public string CoachingNotes { get; set; } // txtCoachingNotes
        public string CoachingDate { get; set; } // Date coached
		[AllowHtml]
		public string MgrNotes { get; set; }

        public string SupReviewedAutoDate { get; set; }
        public string MgrReviewManualDate { get; set; }
        public string MgrReviewAutoDate { get; set; }

		// For completed IQS log: Reviewed and acknowledged Quality Monitor on
		// For all others: Reviewed and acknowledged Coaching on
		public string EmployeeReviewLabel { get; set; }
		public string EmployeeReviewDate { get; set; }
        public string Comment { get; set; }

		public string LogDescription { get; set; }

		public bool IsCoachingRequired { get; set; }

		public int ModuleId { get; set; }
		public string ModuleName { get; set; }
    }
}