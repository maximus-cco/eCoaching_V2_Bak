using eCoachingLog.Models.User;
using eCoachingLog.Services;
using log4net;
using System.Collections.Generic;
using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
    public class LoadTestController : Controller
    {
		private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

		private readonly IUserService userService;

		public LoadTestController(IUserService userService)
		{
			logger.Debug("Entered LoadTestController(IUserService)");
			this.userService = userService;
		}

		// GET: LoadTest
		public ActionResult Index()
        {
			var userList = this.userService.GetLoadTestUsers();
			var userSelectList = new List<SelectListItem>();
			foreach (var user in userList)
			{
				userSelectList.Add(new SelectListItem() { Text = user.Name + " (" + user.Role + ")", Value = user.LanId });
			}

			ViewData["userList"] = userSelectList;
            return View();
        }

		[HttpPost]
		public ActionResult Login(string userLanId)
		{
			User user = this.userService.Authenticate(userLanId);
			Session["AuthenticatedUser"] = user;

			return RedirectToAction("Index", this.userService.DetermineLandingPage(user));
		}
	}
}