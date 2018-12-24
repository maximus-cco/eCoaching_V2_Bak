using eCoachingLog.Models.User;
using eCoachingLog.Repository;
using eCoachingLog.Utils;
using log4net;
using System.Collections.Generic;

namespace eCoachingLog.Services
{
	public class UserService : IUserService
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        private IUserRepository userRepository = new UserRepository();

        public List<User> GetAllUsers()
        {
            return userRepository.GetAllUsers();
        }
        
        public User GetUserByLanId(string lanId)
        {
            return userRepository.GetUserByLanId(lanId);
        }

		public User Authenticate(string lanId)
		{
			return GetUserByLanId(lanId);
		}

		public string DetermineLandingPage(User user)
		{
			if (user == null)
			{
				return Constants.UNAUTHORIZED;
			}

			if (user.IsAccessMyDashboard)
			{
				return Constants.MY_DASHBOARD;
			}

			if (user.IsAccessHistoricalDashboard)
			{
				return Constants.HISTORICAL_DASHBOARD;
			}

			if (user.IsAccessNewSubmission)
			{
				return Constants.NEW_SBUMISSION;
			}

			return Constants.UNAUTHORIZED;
		}

		public IList<User> GetLoadTestUsers()
		{
			// TODO: Get users from database
			// Create a table to hold Load Test users to choose from;
			// Write a stored procedure to get users (User Name, User LanID, User Role)
			// Call a method in UserRepository to get this information
			var userList = new List<User>();
			User user1 = new Models.User.User
			{
				EmployeeId = "333333",
				Name = "Bbbbb, Eeeee",
				LanId = "Eeeee.Bbbbb",
				Role = "CSR"
			};

			User user2 = new Models.User.User
			{
				EmployeeId = "222222",
				Name = "Mmmmmmmm, Tttttt",
				LanId = "Tttttt.Mmmmmmmm",
				Role = "Supervisor"
			};

			User user3 = new Models.User.User
			{
				EmployeeId = "888888",
				Name = "Sssss, Kkkkk",
				LanId = "Kkkkk.Sssss",
				Role = "Manager"
			};

			userList.Add(user1);
			userList.Add(user2);
			userList.Add(user3);

			return userList;
		}
	}
}