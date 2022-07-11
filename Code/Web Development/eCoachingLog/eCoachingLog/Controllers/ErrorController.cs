using log4net;
using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
    public class ErrorController : Controller
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        // GET: Error
        public ActionResult Index()
        {
            logger.Debug("##########Entered Error Index##########");
            Session.Clear();
			Session.Abandon();

            return View();
        }
    }
}