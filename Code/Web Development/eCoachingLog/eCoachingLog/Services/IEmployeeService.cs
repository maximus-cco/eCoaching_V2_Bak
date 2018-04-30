using eCoachingLog.Models.Common;
using System.Collections.Generic;

namespace eCoachingLog.Services
{
	public interface IEmployeeService
    {
        Employee GetEmployee(string employeeId);
        List<Employee> GetEmployeesByModule(int moduleId, int siteId, string userEmpId);
        List<Employee> GetEmployeesByModule(int moduleId, string userLanId);

		//IList<Employee> GetEmployeesBySiteAndTitle(int siteId, int titleId);
		IList<Employee> GetAllSubmitters();

		IList<Employee> GetManagersBySite(int siteId);
		IList<Employee> GetSupervisorsByMgr(string mgrId);
		IList<Employee> GetEmployeesBySup(string supId, int employeeStatus);
	}
}
