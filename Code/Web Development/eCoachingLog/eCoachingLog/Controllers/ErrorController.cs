using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
    public class ErrorController : BaseController
    {
        // GET: Error
        public ActionResult Index()
        {
            Session.Abandon();

            return View();
        }
    }
}