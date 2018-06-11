using eCoachingLog.Models.User;
using eCoachingLog.Repository;
using log4net;
using System;
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
            User user = userRepository.GetUserByLanId(lanId);
			try
			{ 
				// Format user name
				string[] temp = user.Name.Split(',');
				user.Name = string.Format("{0} {1}", temp[1], temp[0]);
            }
			catch (Exception ex)
			{
				logger.Warn(ex.StackTrace);
			}

			return user;
        }
    }
}