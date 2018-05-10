using eCoachingLog.Models.Common;
using System.Collections.Generic;

namespace eCoachingLog.Repository
{
	public interface IEmployeeRepository
    {
        IList<Employee> GetEmployeesByModule(int moduleId, int siteId, string userEmpId);
        Employee GetEmployee(string employeeId);
		IList<Employee> GetAllSubmitters();
		IList<Employee> GetManagersBySite(int siteId);
		IList<Employee> GetSupervisorsByMgr(string mgrId);
		IList<Employee> GetEmployeesBySup(int siteId, string mgrId, string supId, int empStatus);
	}
}
