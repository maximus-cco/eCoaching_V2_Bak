using eCoachingLog.Models.Common;

namespace eCoachingLog.Models
{
    public class NewSubmissionResult
    {
        //public string EmployeeId { get; set; }
        //public string EmployeeName { get; set; }
        //public string EmployeeEmail { get; set; }
        //public string SupervisorEmail { get; set; }
        //public string ManagerEmail { get; set; }
        public Employee Employee { get; set; }
        public string LogName { get; set; }
        public string Error { get; set; }
    }
}