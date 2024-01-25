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

        public List<eCoachingAccessControlRole> GetEcoachingAccessControlRoles()
        {
            var roles = new List<eCoachingAccessControlRole>();
            var r1 = new eCoachingAccessControlRole();
            r1.Name = "ECL";
            r1.Value = "ECL";
            var r2 = new eCoachingAccessControlRole();
            r2.Name = "ARC";
            r2.Value = "ARC";
            var r3 = new eCoachingAccessControlRole();
            r3.Name = "Director";
            r3.Value = "DIR";
            var r4 = new eCoachingAccessControlRole();
            r4.Name = "Director Partner Management";
            r4.Value = "DIRPM";
            var r5 = new eCoachingAccessControlRole();
            r5.Name = "Director Partner Management Advanced";
            r5.Value = "DIRPMA";
            var r6 = new eCoachingAccessControlRole();
            r6.Name = "Partner Management";
            r6.Value = "PM";
            var r7 = new eCoachingAccessControlRole();
            r7.Name = "Partner Management Advanced";
            r7.Value = "PMA";

            roles.Add(r2);
            roles.Add(r1);
            roles.Add(r3);
            //roles.Add(r4);
            //roles.Add(r5);
            roles.Add(r6);
            roles.Add(r7);

            return roles;
        }
    }
}