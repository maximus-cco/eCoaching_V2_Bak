using eCoachingLog.Models.User;
using System.Collections.Generic;

namespace eCoachingLog.Repository
{
    public interface IUserRepository
    {
        List<User> GetAllUsers();

        User GetUserByLanId(string lanId);

        List<Entitlement> GetEntitlementsByUserLanId(string lanId);
    }
}