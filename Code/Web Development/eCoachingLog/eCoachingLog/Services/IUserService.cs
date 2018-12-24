using eCoachingLog.Models.User;
using System.Collections.Generic;

namespace eCoachingLog.Services
{
    public interface IUserService
    {
        List<User> GetAllUsers();
        User GetUserByLanId(string lanId);
		User Authenticate(string lanId);
		string DetermineLandingPage(User user);
		IList<User> GetLoadTestUsers();
    }
}