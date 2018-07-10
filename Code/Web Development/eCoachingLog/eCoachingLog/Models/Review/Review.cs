using eCoachingLog.Models.Common;
using System;

namespace eCoachingLog.Models.Review
{
	public class Review
	{
		public CoachingLogDetail LogDetail { get; set; }
		public WarningLogDetail WarningLogDetail { get; set; }

		public int LogStatusLevel { get; set; }

		// Common
		public DateTime? DateCoached { get; set; }
		public string DetailsCoached { get; set; }

		// Research related
		public bool IsCoachingRequired { get; set; }
		// result from dropdown list
		public string MainReasonNotCoachable { get; set; }
		public string DetailReasonNotCoachable { get; set; }
		public string DetailReasonCoachable { get; set; }
	
		// CSE related
		public bool? IsCse { get; set; }
		public DateTime? DateReviewed { get; set; }
		public string ReasonNotCse { get; set; }
		public string EmployeeComments { get; set; }

		public bool IsRegularPendingForm { get; set; }
		public bool IsResearchPendingForm { get; set; }
		public bool IsCsePendingForm { get; set; }
		public bool IsAcknowledgeForm { get; set; }

		public bool IsAckOpportunityLog { get; set; }
		public bool IsReinforceLog { get; set; }

		public bool IsReviewForm { get; set; }

		public bool Acknowledge { get; set; }
	}
}