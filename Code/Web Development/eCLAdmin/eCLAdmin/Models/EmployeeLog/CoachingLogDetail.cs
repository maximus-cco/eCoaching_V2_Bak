using System;

namespace eCLAdmin.Models.EmployeeLog
{
    public class CoachingLogDetail : LogDetailBase
    {
        public string ReassignedSupervisorName { get; set; }
        public string ReassignedManagerName { get; set; }

        // Supervisor who did the review
        public string ReviewedSupervisorName { get; set; }
        // Manager who did the review
        public string ReviewedManagerName { get; set; }

        public bool IsIqs { get; set; }
        public bool IsUcid { get; set; }
        public bool IsVerintMonitor { get; set; }
        public bool IsBehaviorAnalyticsMonitor { get; set; }
        public bool IsNgdActivityId { get; set; }
        public bool IsCtc { get; set; }
        public bool IsCse { get; set; }

        public string Ucid { get; set; }
        public string VerintId { get; set; }
        public string VerintFormName { get; set; }
        public string CoachingMonitor { get; set; }
        public string BehaviorAnalyticsId { get; set; }
        public string NgdActivityId { get; set; }

        public string Behavior { get; set; } // txtDescription
        public string CoachingNotes { get; set; } // txtCoachingNotes
        public string MgrNotes { get; set; }

        public string SupReviewedAutoDate { get; set; }
        public string MgrReviewManualDate { get; set; }
        public string MgrReviewAutoDate { get; set; }

        public string EmployeeReviewDate { get; set; }
        public string EmployeeComments { get; set; }
    }
}