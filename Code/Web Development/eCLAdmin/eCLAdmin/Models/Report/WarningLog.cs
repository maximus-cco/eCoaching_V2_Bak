namespace eCLAdmin.Models.Report
{
    public class WarningLog
    {
        public string ModuleId { get; set; }
        public string ModuleName { get; set; }
        public string WarningID { get; set; }
        public string LogName { get; set; }
        public string Status { get; set; }
        public string EmployeeID { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeHireDate { get; set; }
        public string Site { get; set; }
        public string SupervisorEmployeeID { get; set; }
        public string SupervisorName { get; set; }
        public string ManagerEmployeeID { get; set; }
        public string ManagerName { get; set; }
        public string CurrentSupervisorEmployeeID { get; set; }
        public string CurrentSupervisorName { get; set; }
        public string CurrentManagerEmployeeID { get; set; }
        public string CurrentManagerName { get; set; }
        public string WarningGivenDate { get; set; }
        public string SubmittedDate { get; set; }
        public string CSRReviewDate { get; set; }
        public string CSRComments { get; set; }
        public string ExpirationDate { get; set; }
        public string WarningSource { get; set; }
        public string SubWarningSource { get; set; }
        public string WarningReason { get; set; }
        public string WarningSubReason { get; set; }
        public string Value { get; set; }
        public string SubmitterID { get; set; }
        public string SubmitterName { get; set; }
        public string ProgramName { get; set; }
        public string Behavior { get; set; }
        public string State { get; set; }
    }
}