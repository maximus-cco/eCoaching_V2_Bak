using eCoachingLog.Filters;
using log4net;
using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
    [SessionCheck]
    public class DummyController : BaseController
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        // GET: Dummy
        public ActionResult Index()
        {
            return View();
        }

        public JsonResult KeepSessionAlive()
        {
            logger.Debug("KeepSessionAlive: id=" + Session.SessionID);
            return Json(string.Empty, JsonRequestBehavior.AllowGet);
        }
    }
}