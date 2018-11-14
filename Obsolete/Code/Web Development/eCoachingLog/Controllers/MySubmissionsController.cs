using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
    public class MySubmissionsController : Controller
    {
        // GET: MySubmissions
        public ActionResult Index()
        {
            ViewBag.SubTitle = "My Submissions";
            return View();
        }
    }
}