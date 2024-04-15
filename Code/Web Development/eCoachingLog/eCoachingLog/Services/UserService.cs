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
			if (user == null || user.Name == "Unknown")
			{
				return Constants.UNAUTHORIZED;
			}

			if (user.IsAccessMyDashboard)
			{
                if (!user.IsDirector && user.IsCsrRelated && user.SiteId != 25) // 25: Peckham - NO QN
                {
                    return Constants.MY_DASHBOARD_QN;
                }

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
			return userRepository.GetLoadTestUsers();
		}
	}
}