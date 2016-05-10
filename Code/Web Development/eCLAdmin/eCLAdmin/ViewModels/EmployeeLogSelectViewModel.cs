using System.Collections.Generic;
using System.Linq;

namespace eCLAdmin.ViewModels
{
    public class EmployeeLogSelectViewModel
    {
        public List<EmployeeLogSelectEditorViewModel> EmployeeLogs { get; set; }

        public EmployeeLogSelectViewModel()
        {
            this.EmployeeLogs = new List<EmployeeLogSelectEditorViewModel>();
        }

        public List<long> GetSelectedIds()
        {
            return (from employeeLogs in this.EmployeeLogs where employeeLogs.Selected select employeeLogs.ID).ToList();
        }

        public List<string> GetSelectedLogNames()
        {
            return (from employeeLogs in this.EmployeeLogs where employeeLogs.Selected select employeeLogs.FormName).ToList();
        }

        public List<EmployeeLogSelectEditorViewModel> GetSelectedLogs()
        {
            return (from employeeLogs in this.EmployeeLogs where employeeLogs.Selected select employeeLogs).ToList();
        }
    }
}