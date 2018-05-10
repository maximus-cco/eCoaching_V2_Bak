using eCoachingLog.Models.Common;
using System.Collections.Generic;

namespace eCoachingLog.Services
{
	public interface IEmployeeService
    {
        Employee GetEmployee(string employeeId);
        IList<Employee> GetEmployeesByModule(int moduleId, int siteId, string userEmpId);
		IList<Employee> GetAllSubmitters();
		IList<Employee> GetManagersBySite(int siteId);
		IList<Employee> GetSupervisorsByMgr(string mgrId);
		IList<Employee> GetEmployeesBySup(int siteId, string mgrId, string supId, int employeeStatus);
	}
}
