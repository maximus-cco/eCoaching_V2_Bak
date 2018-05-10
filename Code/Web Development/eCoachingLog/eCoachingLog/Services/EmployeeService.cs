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

        public IList<Employee> GetEmployeesByModule(int moduleId, int siteId, string userEmpId)
        {
            return employeeRepository.GetEmployeesByModule(moduleId, siteId, userEmpId);
        }

        public Employee GetEmployee(string employeeId)
        {
            return employeeRepository.GetEmployee(employeeId);
        }

		public IList<Employee> GetAllSubmitters()
		{
			return employeeRepository.GetAllSubmitters();
		}

		public IList<Employee> GetManagersBySite(int siteId)
		{
			return employeeRepository.GetManagersBySite(siteId);
		}

		public IList<Employee> GetSupervisorsByMgr(string mgrId)
		{
			return employeeRepository.GetSupervisorsByMgr(mgrId);
		}

		public IList<Employee> GetEmployeesBySup(int siteId, string mgrId, string supId, int empStatus)
		{
			return employeeRepository.GetEmployeesBySup(siteId, mgrId, supId, empStatus);
		}
	}
}