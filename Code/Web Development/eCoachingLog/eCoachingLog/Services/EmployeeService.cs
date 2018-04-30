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

        public List<Employee> GetEmployeesByModule(int moduleId, int siteId, string userEmpId)
        {
            return employeeRepository.GetEmployeesByModule(moduleId, siteId, userEmpId);
        }

        public List<Employee> GetEmployeesByModule(int moduleId, string userLanId)
        {
            return employeeRepository.GetEmployeesByModule(moduleId, userLanId);
        }

        public Employee GetEmployee(string employeeId)
        {
            return employeeRepository.GetEmployee(employeeId);
        }

		//public IList<Employee> GetEmployeesBySiteAndTitle(int siteId, int titleId)
		//{
		//	return employeeRepository.GetEmployeesBySiteAndTitle(siteId, titleId);
		//}

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

		public IList<Employee> GetEmployeesBySup(string supId, int empStatus)
		{
			return employeeRepository.GetEmployeesBySup(supId, empStatus);
		}
	}
}