using eCoachingLog.Models.User;
using System.Collections.Generic;

namespace eCoachingLog.Repository
{
    public interface IUserRepository
    {
        User GetUserByLanId(string lanId);
		IList<User> GetLoadTestUsers();
    }
}