using eCoachingLog.Models.User;
using eCoachingLog.Services;
using eCoachingLog.ViewModels;
using log4net;
using System;
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
            var sessionId = Session == null ? null : Session.SessionID;
            logger.Debug("************SessionID=" + sessionId);

            string env = System.Configuration.ConfigurationManager.AppSettings["environment"];

            string userLanId = User.Identity.Name;
            userLanId = userLanId.Replace(@"AD\", "");
            User user = userService.GetUserByLanId(userLanId);
			           

            //var roleName = Enum.GetName(typeof(UserRoles), user.Role.Id);
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