using eCLAdmin.Models;
using eCLAdmin.Models.User;
using eCLAdmin.Repository;
using log4net;
using System.Collections.Generic;
using System.Linq;

namespace eCLAdmin.Services
{
    public class UserService : IUserService
    {
        private readonly ILog logger = LogManager.GetLogger(typeof(UserService));
        private IUserRepository userRepository = new UserRepository();

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

        public List<eCoachingAccessControl> GetEcoachingAccessControlList()
        {
            return userRepository.GetEcoachingAccessControlList();
        }

        public bool DeleteEcoachingAccessControl(int rowId, string updatedBy)
        {
            return userRepository.DeleteEcoachingAccessControl(rowId, updatedBy);
        }

        public eCoachingAccessControl GetEcoachingAccessControl(int rowId)
        {
            return userRepository.GetEcoachingAccessControl(rowId);
        }

        public bool UpdateEcoachingAccessControl(eCoachingAccessControl user)
        {
            return userRepository.UpdateEcoachingAccessControl(user);
        }

        public List<NameLanId> GetEcoachingAccessControlsToAdd(string siteId)
        {
            return userRepository.GetEcoachingAccessControlsToAdd(siteId);
        }

        public int AddEcoachingAccessControl(eCoachingAccessControl user)
        {
            return userRepository.AddEcoachingAccessControl(user);
        }
    }
}