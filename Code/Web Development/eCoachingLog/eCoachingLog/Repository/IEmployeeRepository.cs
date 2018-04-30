using eCoachingLog.Models.Common;
using System.Collections.Generic;

namespace eCoachingLog.Repository
{
	public interface IEmployeeRepository
    {
        List<Employee> GetEmployeesByModule(int moduleId, int siteId, string userEmpId);
        List<Employee> GetEmployeesByModule(int moduleId, string userLanId);
        Employee GetEmployee(string employeeId);
        List<Employee> GetEmployees(string userLanId, int logTypeId, int moduleId, string action);
		//IList<Employee> GetEmployeesBySiteAndTitle(int siteId, int titleId);
		IList<Employee> GetAllSubmitters();
		IList<Employee> GetManagersBySite(int siteId);
		IList<Employee> GetSupervisorsByMgr(string mgrId);
		IList<Employee> GetEmployeesBySup(string supId, int empStatus);
	}
}
