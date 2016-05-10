using eCLAdmin.Models.User;
using System.Collections.Generic;

namespace eCLAdmin.Services
{
    public interface IUserService
    {
        List<User> GetAllUsers();

        User GetUserByLanId(string lanId);

        bool UserIsEntitled(User user, string entitlementName);

        //List<Entitlement> GetEntitlementsByUserLanId(string userLanId);
    }
}