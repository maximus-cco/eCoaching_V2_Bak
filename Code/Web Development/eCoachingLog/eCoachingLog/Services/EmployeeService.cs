using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using eCoachingLog.Repository;
using log4net;
using System.Collections.Generic;

namespace eCoachingLog.Services
{
	public class EmployeeService : IEmployeeService
    {
		private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

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

		public IList<Employee> GetSupsForMgrMyPending(User user)
		{
			if (user == null)
			{
				logger.Info("User is null.");
				return new List<Employee>();
			}
			return employeeRepository.GetSupsForMgrMyPending(user);
		}

		public IList<Employee> GetEmpsForMgrMyPending(User user)
		{
			if (user == null)
			{
				logger.Info("User is null.");
				return new List<Employee>();
			}
			return employeeRepository.GetEmpsForMgrMyPending(user);
		}

		public IList<Employee> GetEmpsForSupMyTeamPending(User user)
		{
			if (user == null)
			{
				logger.Info("User is null.");
				return new List<Employee>();
			}
			return employeeRepository.GetEmpsForSupMyTeamPending(user);
		}

		public IList<Employee> GetSupsForMgrMyTeamPending(User user)
		{
			if (user == null)
			{
				logger.Info("User is null.");
				return new List<Employee>();
			}
			return employeeRepository.GetSupsForMgrMyTeamPending(user);
		}

		public IList<Employee> GetEmpsForMgrMyTeamPending(User user)
		{
			if (user == null)
			{
				logger.Info("User is null.");
				return new List<Employee>();
			}
			return employeeRepository.GetEmpsForMgrMyTeamPending(user);
		}

		public IList<Employee> GetMgrsForSupMyTeamCompleted(User user)
		{
			if (user == null)
			{
				logger.Info("User is null.");
				return new List<Employee>();
			}
			return employeeRepository.GetMgrsForSupMyTeamCompleted(user);
		}

		public IList<Employee> GetEmpsForSupMyTeamCompleted(User user)
		{
			if (user == null)
			{
				logger.Info("User is null.");
				return new List<Employee>();
			}
			return employeeRepository.GetEmpsForSupMyTeamCompleted(user);
		}

		public IList<Employee> GetSupsForMgrMyTeamCompleted(User user)
		{
			if (user == null)
			{
				logger.Info("User is null.");
				return new List<Employee>();
			}
			return employeeRepository.GetSupsForMgrMyTeamCompleted(user);
		}

		public IList<Employee> GetEmpsForMgrMyTeamCompleted(User user)
		{
			if (user == null)
			{
				logger.Info("User is null.");
				return new List<Employee>();
			}
			return employeeRepository.GetEmpsForMgrMyTeamCompleted(user);
		}
	}
}