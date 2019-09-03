using eCoachingLog.Models.Common;
using System;
using System.Collections.Generic;

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

		// Followup
		public DateTime? DateFollowup { get; set; }
		public string DetailsFollowup { get; set; }
		// Research related
		public bool IsCoachingRequired { get; set; }
		// result from dropdown list
		public string MainReasonNotCoachable { get; set; }
		public string DetailReasonNotCoachable { get; set; }
		public string DetailReasonCoachable { get; set; }
	
		// CSE related
		public bool? IsConfirmedCse { get; set; }
		public DateTime? DateReviewed { get; set; }
		public string ReasonNotCse { get; set; }
		public string Comment { get; set; }

		public bool IsRegularPendingForm { get; set; }
		public bool IsResearchPendingForm { get; set; }
		public bool IsCsePendingForm { get; set; }
		public bool IsAcknowledgeForm { get; set; }
		public bool IsShortCallPendingSupervisorForm { get; set; }
		public bool IsShortCallPendingManagerForm { get; set; }
		public bool IsFollowupPendingSupervisorForm { get; set; }
		public bool IsFollowupPendingCsrForm { get; set; }

		public bool IsAckOpportunity { get; set; }
		public bool IsMoreReviewRequired { get; set; }
		public bool IsAckOverTurnedAppeal { get; set; }

		public bool IsReviewForm { get; set; }

		public bool Acknowledge { get; set; }

		public IList<ShortCall> ShortCallList { get; set; }
		public string Comments { get; set; }
		public DateTime? DateConfirmed { get; set; }
	}
}