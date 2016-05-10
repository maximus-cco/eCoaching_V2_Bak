using System.Web.Mvc;

namespace eCLAdmin.Controllers
{
    public class UnauthorizedController : BaseController
    {
        //
        // GET: /Unauthorized/
        public ActionResult Index()
        {
            Session.Abandon();
            return View();
        }
	}
}