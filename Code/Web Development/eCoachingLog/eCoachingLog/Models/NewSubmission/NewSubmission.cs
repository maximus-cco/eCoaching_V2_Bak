using eCoachingLog.Models.Common;
using System;
using System.Collections.Generic;

namespace eCoachingLog.Models
{
    public class NewSubmission
    {
        public int ModuleId { get; set; }

        public int? SiteId { get; set; }
        public Employee Employee { get; set; }
        public int? ProgramId { get; set; }
		public string ProgramName { get; set; }
        public int? BehaviorId { get; set; }
		public string BehaviorName { get; set; }
        // User delivers the coaching session
        public bool? IsDirect { get; set; } 
        public DateTime? CoachingDate { get; set; }
        public DateTime? WarningDate { get; set; }
        public bool? IsCse { get; set; }
        public bool? IsWarning { get; set; }
        public List<CoachingReason> CoachingReasons { get; set; }
        public string BehaviorDetail { get; set; }
        public string Plans { get; set; }
        public int SourceId { get; set; }
        public bool IsCallAssociated { get; set; }
        public string CallTypeName { get; set; }
        public string CallId { get; set; }

		public bool? IsFollowupRequired { get; set; }
		public DateTime? FollowupDueDate { get; set; }

        public int? WarningTypeId { get; set; }
        public int? WarningReasonId { get; set; }

        public int StatusId { get; set; }
	}
}