using System.Web.Mvc;

namespace eCLAdmin.Controllers
{
    public class ErrorController : BaseController
    {
        // GET: Error
        public ActionResult Index()
        {
            return View();
        }
    }
}