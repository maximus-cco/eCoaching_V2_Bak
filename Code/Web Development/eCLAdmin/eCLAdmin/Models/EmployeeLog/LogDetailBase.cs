using System;

namespace eCLAdmin.Models.EmployeeLog
{
    public class LogDetailBase
    {
        public long LogId { get; set; }
        public string FormName { get; set; }
        public string Source { get; set; }
        public string Status { get; set; }
        public string Type { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeSite { get; set; }
        public string SupervisorName { get; set; }
        public string ManagerName { get; set; }
        public string SubmitterName { get; set; }
        public string CreatedDate { get; set; } // SubmittedDate
        public string EventDate { get; set; } // Date happened

        //public List<Reason> Reasons { get; set; }
        public string Reasons { get; set; }
        public string SubReasons { get; set; }
        public string Value { get; set; }

        public bool IsTypeDirect
        {
            get
            {
                return String.IsNullOrWhiteSpace(Type) ? false : "Direct".Equals(Type.Trim(), StringComparison.OrdinalIgnoreCase);
            }
        }
    }
}