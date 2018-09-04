using System.Web.Mvc;

namespace eCLAdmin.Controllers
{
    public class HelpController : Controller
    {
        // GET: Help
        public ActionResult Index()
        {
            return View();
        }

		public ActionResult ReportIssue()
		{
			return Redirect(Constants.REPORT_ISSUE_URL);
		}
    }
}