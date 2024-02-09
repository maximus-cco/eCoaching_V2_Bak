using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using System.Collections.Generic;

namespace eCoachingLog.Repository
{
	public interface IEmployeeRepository
    {
        IList<Employee> GetEmployeesByModule(int moduleId, int siteId, string userEmpId);
        Employee GetEmployee(string employeeId);
		IList<Employee> GetAllSubmitters();
		IList<Employee> GetManagersBySite(int siteId);
		IList<Employee> GetSupervisorsByMgr(string mgrId, int siteId);
		IList<Employee> GetEmployeesBySup(int siteId, string mgrId, string supId, int empStatus);

		IList<Employee> GetSupsForMgrMyPending(User user);
		IList<Employee> GetEmpsForMgrMyPending(User user);
		IList<Employee> GetEmpsForSupMyTeamPending(User user);
		IList<Employee> GetSupsForMgrMyTeamPending(User user);
		IList<Employee> GetEmpsForMgrMyTeamPending(User user);
		IList<Employee> GetMgrsForSupMyTeamCompleted(User user);
		IList<Employee> GetEmpsForSupMyTeamCompleted(User user);
		IList<Employee> GetSupsForMgrMyTeamCompleted(User user);
		IList<Employee> GetEmpsForMgrMyTeamCompleted(User user);

		IList<Employee> GetFiltersForMySubmission(User user, string filterType);
	}
}
