using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
    public class UnauthorizedController : BaseController
    {
        //
        // GET: /Unauthorized/
        public ActionResult Index()
        {
			Session.Clear();
            Session.Abandon();
            return View();
        }
	}
}