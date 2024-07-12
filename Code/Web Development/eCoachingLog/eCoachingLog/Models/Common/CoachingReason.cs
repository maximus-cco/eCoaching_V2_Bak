using eCoachingLog.Utils;
using System;
using System.Collections.Generic;
using System.Web.Mvc;

namespace eCoachingLog.Models.Common
{
    public class CoachingReason
    {
		public int ID { get; set; }
        public String Text { get; set; }
        public bool IsChecked { get; set; }

        // opportunity, reinforcement, or research required?
        public string Type { get; set; }
		public bool OpportunityOption { get; set; }
		public bool ReinforcementOption { get; set; }
        public bool ResearchOption { get; set; }

		public List<CoachingSubReason>  SubReasons { get; set; }
        public int[] SubReasonIds { get; set; }

        public bool AllowMultiSubReason
        {
            get
            {
                return ID != Constants.REASON_CALL_EFFICIENCY;
            }
        }

        public IEnumerable<SelectListItem> SubReasonSelectList
        {
            get
            {
                return new SelectList(SubReasons, "ID", "Text");
            }
        }

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