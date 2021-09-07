using eCoachingLog.Models.User;
using eCoachingLog.Services;
using eCoachingLog.Utils;
using log4net;
using System;
using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
    public class LoginController : Controller
    {
		private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

		private readonly IUserService userService;

		public LoginController(IUserService userService)
		{
			logger.Debug("Entered LoginController(IUserService)");
			this.userService = userService;
		}

		// GET: Login
		public ActionResult Index()
        {
			string env = System.Configuration.ConfigurationManager.AppSettings["Environment"];
			// Load Test, display pseudo log in page
			if (String.Equals(env, "loadTest", StringComparison.OrdinalIgnoreCase))
			{
				return RedirectToAction("Index", "LoadTest");
			}

            string userLanId = User.Identity.Name.Replace(@"AD\", "");
            userLanId = userLanId.Replace(@"MAXCORP\", "");
            User user = this.userService.Authenticate(userLanId);
            Session["AuthenticatedUser"] = user;

			return RedirectToAction("Index", this.userService.DetermineLandingPage(user));
		}
	}
}