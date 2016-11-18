namespace eCLAdmin.Models.EmployeeLog
{
    public class EmployeeLog
    {
        public long ID { get; set; }
        public string FormType { get; set; }
        public string FormName { get; set; }
        public string EmployeeName { get; set; }
        public string SupervisorName { get; set; }
        public string ManagerName { get; set; }
        public string SubmitterName { get; set; }
        public string Source { get; set; }
        public string Status { get; set; }
        public int StatusId { get; set; }
        public int PreviousStatusId { get; set; }
        public string CreatedDate { get; set; }

        public string Reasons { get; set; }
        public string SubReasons { get; set; }
        public string Value { get; set; }
    }
}