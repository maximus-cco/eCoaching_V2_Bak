using eCoachingLog.Models.User;
using eCoachingLog.Services;
using eCoachingLog.Utils;
using log4net;
using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
	public class HomeController : BaseController
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        private IUserService userService = new UserService();

        public ActionResult Index()
        {
            logger.Debug("Entered HomeController.Index");

			string userLanId = User.Identity.Name;
			userLanId = userLanId.Replace(@"AD\", "");
			User user = this.userService.GetUserByLanId(userLanId);
			if (user == null)
			{
				return RedirectToAction("Index", "Unauthorized");
			}

			Session["AuthenticatedUser"] = user;
			// Landing page: Historical Dashboard for HR users; My Dashboard for all other users
			if (user.Role == Constants.USER_ROLE_HR)
			{
				return RedirectToAction("Index", "HistoricalDashboard");
			}
			return RedirectToAction("Index", "MyDashboard");
        }

        public JsonResult KeepSessionAlive()
        {
            logger.Debug("######id=" + Session.SessionID);
            return Json(string.Empty, JsonRequestBehavior.AllowGet);
        }

        public ActionResult SessionExpired()
        {
            Session.Abandon();
            return View();
        }
    }
}