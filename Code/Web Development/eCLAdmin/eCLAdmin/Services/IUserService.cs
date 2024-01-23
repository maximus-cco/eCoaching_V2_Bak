using eCLAdmin.Models.User;
using System.Collections.Generic;

namespace eCLAdmin.Services
{
    public interface IUserService
    {
        List<eCoachingAccessControlRole> GetEcoachingAccessControlRoles();

        List<User> GetAllUsers();

        User GetUserByLanId(string lanId);

        bool UserIsEntitled(User user, string entitlementName);

        List<eCoachingAccessControl> GetEcoachingAccessControlList();

        bool DeleteEcoachingAccessControl(int rowId, string deletedBy);

        eCoachingAccessControl GetEcoachingAccessControl(int rowId);

        List<NameLanId> GetEcoachingAccessControlsToAdd(string siteId);
        
        bool UpdateEcoachingAccessControl(eCoachingAccessControl user);

        int AddEcoachingAccessControl(eCoachingAccessControl user);
    }
}