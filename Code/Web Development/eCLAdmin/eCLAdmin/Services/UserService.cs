using eCLAdmin.Models.User;
using eCLAdmin.Repository;
using log4net;
using System.Collections.Generic;
using System.Linq;

namespace eCLAdmin.Services
{
    public class UserService : IUserService
    {
        private IUserRepository userRepository = new UserRepository();

        readonly ILog logger = LogManager.GetLogger(typeof(UserService));

        public List<User> GetAllUsers()
        {
            return userRepository.GetAllUsers();
        }
        
        public User GetUserByLanId(string lanId)
        {
            User user = userRepository.GetUserByLanId(lanId);
            if (user != null)
            {
                user.Entitlements = userRepository.GetEntitlementsByUserLanId(lanId);
            }

            return user;
        }
        
        public bool UserIsEntitled(User user, string entitlementName)
        {
            logger.Debug("Entered UserService.UserIsEntitled..........");

            if (user == null || user.LanId == "" || string.IsNullOrWhiteSpace(entitlementName) || user.Entitlements == null)
            {
                return false;
            }

            bool isEntitled = (user.Entitlements.Where (
                    e => e.Name == entitlementName).ToList().Count > 0);

            return isEntitled;
        }
    }
}