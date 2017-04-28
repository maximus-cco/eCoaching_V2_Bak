using eCLAdmin.Models.User;
using System.Collections.Generic;

namespace eCLAdmin.Repository
{
    public interface IUserRepository
    {
        List<User> GetAllUsers();

        User GetUserByLanId(string lanId);

        List<Entitlement> GetEntitlementsByUserLanId(string lanId);

        List<eCoachingAccessControl> GetEcoachingAccessControlList();

        List<NameLanId> GetEcoachingAccessControlsToAdd(string siteId);

        bool DeleteEcoachingAccessControl(int rowId, string updatedBy);

        eCoachingAccessControl GetEcoachingAccessControl(int rowId);

        bool UpdateEcoachingAccessControl(eCoachingAccessControl user);

        int AddEcoachingAccessControl(eCoachingAccessControl user);
    }
}