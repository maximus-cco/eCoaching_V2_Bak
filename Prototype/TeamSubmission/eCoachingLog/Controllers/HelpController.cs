using System.Web.Mvc;

namespace eCoachingLog.Controllers
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
			return Redirect(Utils.Constants.REPORT_ISSUE_URL);
		}
	}
}