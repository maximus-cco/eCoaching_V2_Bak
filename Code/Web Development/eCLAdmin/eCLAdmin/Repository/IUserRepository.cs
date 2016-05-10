using eCLAdmin.Models.User;
using System.Collections.Generic;

namespace eCLAdmin.Repository
{
    public interface IUserRepository
    {
        List<User> GetAllUsers();

        User GetUserByLanId(string lanId);

        List<Entitlement> GetEntitlementsByUserLanId(string lanId);
    }
}