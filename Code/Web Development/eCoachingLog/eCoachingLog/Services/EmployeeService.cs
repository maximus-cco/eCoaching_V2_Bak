using eCoachingLog.Models.Common;
using eCoachingLog.Repository;
using System.Collections.Generic;

namespace eCoachingLog.Services
{
	public class EmployeeService : IEmployeeService
    {
        private readonly IEmployeeRepository employeeRepository;

        public EmployeeService(IEmployeeRepository employeeRepository)
        {
            this.employeeRepository = employeeRepository;
        }

        public List<Employee> GetEmployeesByModule(int moduleId, int siteId)
        {
            return employeeRepository.GetEmployeesByModule(moduleId, siteId);
        }

        public List<Employee> GetEmployeesByModule(int moduleId, string userLanId)
        {
            return employeeRepository.GetEmployeesByModule(moduleId, userLanId);
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

		public IList<Employee> GetEmployeesBySiteAndTitle(int siteId, int titleId)
		{
			return employeeRepository.GetEmployeesBySiteAndTitle(siteId, titleId);
		}

		public IList<Employee> GetAllSubmitters()
		{
			return employeeRepository.GetAllSubmitters();
		}
	}
}