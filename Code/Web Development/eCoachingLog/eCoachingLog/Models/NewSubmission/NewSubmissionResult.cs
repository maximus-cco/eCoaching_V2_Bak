using eCoachingLog.Models.Common;

namespace eCoachingLog.Models
{
    public class NewSubmissionResult
    {
        public Employee Employee { get; set; }
        public string LogId { get; set; }
        public string LogName { get; set; }
        public string CreateDateTime { get; set; }
        public string Error { get; set; }

        public NewSubmissionResult ()
        {
            Employee = new Employee();
        }

    }
}