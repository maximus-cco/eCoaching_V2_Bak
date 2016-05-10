using eCLAdmin.Models.EmployeeLog;
using System.Collections.Generic;

namespace eCLAdmin.Services
{
    public interface IEmployeeService
    {
        List<Employee> GetEmployees();

        Employee GetEmployee(string employeeId);

        List<Employee> GetEmployees(string userLanId, int logTypeId, int moduleId, string action);

        List<Employee> GetPendingReviewers(string userLanId, int moduleId, int logStatusId);

        List<Employee> GetAssignToList(string userLanId, int moduleId, int logStatusId, string originalReviewer);
    }
}
