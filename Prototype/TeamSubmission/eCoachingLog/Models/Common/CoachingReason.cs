using System;
using System.Collections.Generic;

namespace eCoachingLog.Models.Common
{
    public class CoachingReason
    {
		public int ID { get; set; }
        public String Text { get; set; }
        public bool IsChecked { get; set; }

        public bool? IsOpportunity { get; set; }
		public bool OpportunityOption { get; set; }
		public bool ReinforcementOption { get; set; }

		public List<CoachingSubReason>  SubReasons { get; set; }
        public int[] SubReasonIds { get; set; }

		// Help to return form data
		// See:
		//_NewSubmissionCoachingReasons.cshtml
		//_NewSubmissionCoachingReason.cshtml
		public int Index { get; set; }

		public CoachingReason()
        {
            this.SubReasons = new List<CoachingSubReason>();
        }
    }
}