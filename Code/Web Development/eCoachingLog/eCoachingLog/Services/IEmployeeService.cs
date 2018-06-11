using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
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

		IList<Employee> GetSupsForMgrMyPending(User user);
		IList<Employee> GetEmpsForMgrMyPending(User user);
		IList<Employee> GetEmpsForSupMyTeamPending(User user);
		IList<Employee> GetSupsForMgrMyTeamPending(User user);
		IList<Employee> GetEmpsForMgrMyTeamPending(User user);
		IList<Employee> GetMgrsForSupMyTeamCompleted(User user);
		IList<Employee> GetEmpsForSupMyTeamCompleted(User user);
		IList<Employee> GetSupsForMgrMyTeamCompleted(User user);
		IList<Employee> GetEmpsForMgrMyTeamCompleted(User user);

		//IList<Employee> GetSupsForMySubmission(User user);

		IList<Employee> GetFilterForMySubmission(User user, string filter);
	}
}
