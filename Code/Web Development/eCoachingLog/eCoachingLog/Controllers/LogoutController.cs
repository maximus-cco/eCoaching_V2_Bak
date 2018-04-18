using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
    public class LogoutController : BaseController
    {
        // GET: Logout
        public ActionResult Index()
        {
            Session.Abandon();
            return View();
        }
    }
}