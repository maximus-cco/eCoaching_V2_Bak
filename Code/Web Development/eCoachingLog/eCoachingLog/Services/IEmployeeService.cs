using eCoachingLog.Models.Common;
using System.Collections.Generic;

namespace eCoachingLog.Services
{
	public interface IEmployeeService
    {
        Employee GetEmployee(string employeeId);
        List<Employee> GetEmployees(string userLanId, int logTypeId, int moduleId, string action);
        List<Employee> GetEmployeesByModule(int moduleId, int siteId);
        List<Employee> GetEmployeesByModule(int moduleId, string userLanId);
        List<Employee> GetPendingReviewers(string userLanId, int moduleId, int logStatusId);
        List<Employee> GetAssignToList(string userLanId, int moduleId, int logStatusId, string originalReviewer);

		IList<Employee> GetEmployeesBySiteAndTitle(int siteId, int titleId);
		IList<Employee> GetAllSubmitters();
	}
}
