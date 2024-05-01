using eCoachingLog.Utils;
using log4net;
using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
    public class HomeController : BaseController
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public ActionResult Index()
        {
            logger.Debug("Entered HomeController.Index");

			if (ShowMaintenancePage())
			{
				return new FilePathResult(System.Web.Hosting.HostingEnvironment.MapPath(Constants.MAINTENANCE_PAGE), "text/html");
			}

			return RedirectToAction("Index", "Login");
		}

        public ActionResult SessionExpired()
        {
			Session.Clear();
            Session.Abandon();
			return View();
        }
    }
}