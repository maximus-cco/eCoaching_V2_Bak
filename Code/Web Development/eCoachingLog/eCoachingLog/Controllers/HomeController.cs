using eCoachingLog.Models.User;
using eCoachingLog.Services;
using eCoachingLog.ViewModels;
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
            User user = userService.GetUserByLanId(userLanId);
            if (user == null)
            {
                return RedirectToAction("Index", "Unauthorized");
            }

			Session["AuthenticatedUser"] = user;
			// Landing page
			return RedirectToAction("Index", "NewSubmission");
        }

        public JsonResult KeepSessionAlive()
        {
            logger.Debug("######id=" + Session.SessionID);
            NewSubmissionViewModel vm = (NewSubmissionViewModel)Session["newSubmissionVM"];

            return Json(string.Empty, JsonRequestBehavior.AllowGet);
        }

        public ActionResult SessionExpire()
        {
            Session.Abandon();

            return View();
        }
    }
}