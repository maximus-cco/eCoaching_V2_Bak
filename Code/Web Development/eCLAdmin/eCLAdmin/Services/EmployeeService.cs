using eCLAdmin.Models.EmployeeLog;
using eCLAdmin.Repository;
using System.Collections.Generic;

namespace eCLAdmin.Services
{
    public class EmployeeService : IEmployeeService
    {
        private readonly IEmployeeRepository employeeRepository;

        public EmployeeService(IEmployeeRepository employeeRepository)
        {
            this.employeeRepository = employeeRepository;
        }

        public Employee GetEmployee(string employeeId)
        {
            return employeeRepository.GetEmployee(employeeId);
        }

        public List<Employee> GetEmployees(string userLanId, int logTypeId, int moduleId, string action)
        {
            return employeeRepository.GetEmployees(userLanId, logTypeId, moduleId, action);
        }

        public List<Employee> GetPendingReviewers(string userLanId, int moduleId, int logStatusId)
        {
            return employeeRepository.GetPendingReviewers(userLanId, moduleId, logStatusId);
        }

        public List<Employee> GetAssignToList(string userLanId, int moduleId, int logStatusId, string originalReviewer)
        {
            return employeeRepository.GetAssignToList(userLanId, moduleId, logStatusId, originalReviewer);
        }
    }
}