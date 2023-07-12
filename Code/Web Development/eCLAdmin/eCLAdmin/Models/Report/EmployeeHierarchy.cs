namespace eCLAdmin.Models.Report
{
    public class EmployeeHierarchy
    {
        public string EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string SiteName { get; set; }
        public string EmployeeJobCode { get; set; }
        public string EmployeeJobDescription { get; set; }
        public string Program { get; set; }
        public string SupervisorEmployeeID { get; set; }
        public string SupervisorName { get; set; }
        public string SupervisorJobCode { get; set; }
        public string SupervisorJobDescription { get; set; }
        public string ManagerEmployeeID { get; set; }
        public string ManagerName { get; set; }
        public string ManagerJobCode { get; set; }
        public string ManagerJobDescription { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string Status { get; set; }
        public string AspectJobTitle { get; set; }
        public string AspectSkill { get; set; }
        public string AspectStatus { get; set; }
    }
}