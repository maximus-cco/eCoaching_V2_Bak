namespace eCoachingLog.Models.Common
{
    public class LogBase
    {
        public long ID { get; set; }
        public string FormType { get; set; }
        public string FormName { get; set; }
        public string LogNewText { get; set; }
        public string EmployeeName { get; set; }
        public string SupervisorName { get; set; }
        public string ManagerName { get; set; }
        public string SubmitterName { get; set; }
        public string Source { get; set; }
        public string Status { get; set; }
        public string CreatedDate { get; set; }
        public string WarningDate { get; set; }
        public bool IsFollowupRequired { get; set; }
        public string FollowupDueDate { get; set; }
        public bool HasFollowupHappened { get; set; }
        public string Reasons { get; set; }
        public string SubReasons { get; set; }
        public string Value { get; set; }
        public string WarningType { get; set; }
        public string WarningReasons { get; set; }
        public bool IsCoaching { get; set; }

        // TODO: remove
        public string QnBatchNumber { get; set; }
        public string ComplianceCategory { get; set; }
        public string NoncompliantBehavior { get; set; }
        public string CoachingDate { get; set; }
        public string BehaviorRolloffDate { get; set; }
        public string CoachingWarningLevel { get; set; }

        // prototype
        public bool IsFiveEvalLog { get; set; }
        public bool IsOneEvalLog { get; set; }
    }
}