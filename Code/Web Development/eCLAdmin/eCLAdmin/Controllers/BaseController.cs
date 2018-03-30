using eCLAdmin.Models.User;
using eCLAdmin.Services;
using log4net;
using System.Web.Mvc;

namespace eCLAdmin.Controllers
{
    public class BaseController : Controller
    {
        readonly ILog logger = LogManager.GetLogger(typeof(BaseController));

		protected User GetUserFromSession()
        {
            User user = (User)Session["AuthenticatedUser"];
            if (user == null)
            {
                logger.Debug("User in session is null!!!");
            }

            return (User)Session["AuthenticatedUser"];
        }

        protected bool IsAccessAllowed(string entitlement)
        {
            User user = (User) Session["AuthenticatedUser"];
            IUserService userService = new UserService();
            return userService.UserIsEntitled(user, entitlement);
        }
    }
}