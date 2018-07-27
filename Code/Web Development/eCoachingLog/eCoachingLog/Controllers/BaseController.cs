using eCoachingLog.Filters;
using eCoachingLog.Models.User;
using log4net;
using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
	[NoCache]
    public class BaseController : Controller
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        protected User GetUserFromSession()
        {
            User user = (User)Session["AuthenticatedUser"];
            if (user == null)
            {
                logger.Error("User in session is null!!!");
            }

            return user;
        }
    }
}