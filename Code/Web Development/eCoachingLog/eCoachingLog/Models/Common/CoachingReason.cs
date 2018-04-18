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

        //public IEnumerable<SelectListItem> SubReasons { get; set; } 
        public List<CoachingSubReason>  SubReasons { get; set; }
        public int[] SubReasonIds { get; set; }

        public bool OpportunityOption { get; set; }
        public bool ReinforcementOption { get; set; }

        public CoachingReason()
        {
            this.SubReasonIds = new int[20];
            //this.SubReasons = Enumerable.Empty<SelectListItem>();
            this.SubReasons = new List<CoachingSubReason>();
        }
    }
}