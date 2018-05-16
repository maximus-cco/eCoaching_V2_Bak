using eCoachingLog.Models.User;
using System.Collections.Generic;

namespace eCoachingLog.Services
{
    public interface IUserService
    {
        List<User> GetAllUsers();
        User GetUserByLanId(string lanId);
    }
}