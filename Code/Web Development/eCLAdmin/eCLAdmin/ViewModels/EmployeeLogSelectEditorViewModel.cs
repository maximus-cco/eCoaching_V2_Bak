using eCLAdmin.Models.EmployeeLog;

namespace eCLAdmin.ViewModels
{
    public class EmployeeLogSelectEditorViewModel
    {
        public bool Selected { get; set; }
        public long ID { get; set; }
        public string FormName { get; set; }
        public string EmployeeName { get; set; }
        public string SupervisorName { get; set; }
        public string ManagerName { get; set; }
        public string SubmitterName { get; set; }
        public string Status { get; set; }
        public int StatusId { get; set; }
        public int PreviousStatusId { get; set; }
        public string CreatedDate { get; set; }

        public EmployeeLogSelectEditorViewModel()
        {
            Selected = false;
            ID = -1;
            FormName = null;
            EmployeeName = null;
            SupervisorName = null;
            ManagerName = null;
            SubmitterName = null;
            Status = null;
            StatusId = -1;
            PreviousStatusId = -1;
            CreatedDate = null;
        }

        public EmployeeLogSelectEditorViewModel(EmployeeLog employeeLog)
        {
            ID = employeeLog.ID;
            FormName = employeeLog.FormName;
            EmployeeName = employeeLog.EmployeeName;
            SupervisorName = employeeLog.SupervisorName;
            ManagerName = employeeLog.ManagerName;
            SubmitterName = employeeLog.SubmitterName;
            Status = employeeLog.Status;
            StatusId = employeeLog.StatusId;
            PreviousStatusId = employeeLog.PreviousStatusId;
            CreatedDate = employeeLog.CreatedDate;
        }
    }
}