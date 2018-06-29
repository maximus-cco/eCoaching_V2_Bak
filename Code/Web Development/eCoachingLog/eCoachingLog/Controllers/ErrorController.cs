using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
    public class ErrorController : BaseController
    {
        // GET: Error
        public ActionResult Index()
        {
			Session.Clear();
			Session.Abandon();
            return View();
        }
    }
}