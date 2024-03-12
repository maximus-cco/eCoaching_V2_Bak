using System.Collections.Generic;
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
        public bool IsBqns { get; set; } // Quality BINGO "Quality / BQNS"
        public bool IsBqm { get; set; }  // Quality Bingo "Quality / BQM"
        public bool IsBqms { get; set; } // Quality Bingo "Quality / BQMS"
        public bool IsOthAps { get; set; } // Attendance Policy Earback
        public bool IsOthApw { get; set; } // Attendance Policy Earback
        public bool IsIdd { get; set; } // incentives data feed
        public bool IsSurvey { get; set; } // survey from analytic team
        public bool IsOmrAudio { get; set; }
        public bool IsNgdsLoginOutsideShift { get; set; } // NGD ID system log ins outside of the shift

        public bool HasEmpAcknowledged { get; set; }
        public bool HasSupAcknowledged { get; set; }

        public string UcId { get; set; }
        public string VerintId { get; set; }
        public string VerintFormName { get; set; }
        public string CoachingMonitor { get; set; }
        public string BehaviorAnalyticsId { get; set; }
        public string NgdActivityId { get; set; }

        // Moved to DetailsOfBehavior
        //public string Behavior { get; set; } // txtDescription
        public DetailsOfBehavior BehaviorDetails{ get; set; }

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
		// Moved to BaseLogDetail
		// public string EmployeeReviewDate { get; set; }
        // public string Comment { get; set; }

		public string LogDescription { get; set; }

		public bool IsCoachingRequired { get; set; }

		public string ModuleName { get; set; }

		// Follow-up
		public bool IsFollowupRequired { get; set; }
		public string FollowupDueDate { get; set; }    // Date when followup is due
		public string FollowupActualDate { get; set; } // Date when followup happens
		public string FollowupDetails { get; set; }    // entered on the review page by supervisor
		public string FollowupSupAutoDate { get; set; }
		public string FollowupSupName { get; set; }
		public string FollowupEmpAutoDate { get; set; }
		public string FollowupEmpComments { get; set; }

        // QN
        public List<LogSummary> QnSummaryList { get; set; }
        public List<Scorecard> Scorecards { get; set; }
        public List<TextValue> LinkedLogs { get; set; } // linked additional call listening logs
        public string FollowupDecisionComments { get; set; } // comments whether followup coaching is required

        // quality pfd completed date
        public string PfdCompletedDate { get; set; }

        public string AudVerintIds { get; set; }

        public CoachingLogDetail()
        {
            this.QnSummaryList = new List<LogSummary>();
            this.Scorecards = new List<Scorecard>();
            this.LinkedLogs = new List<TextValue>();
            this.BehaviorDetails = new DetailsOfBehavior();
        }
    }
}