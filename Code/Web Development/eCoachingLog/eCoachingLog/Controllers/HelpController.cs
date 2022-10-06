using eCoachingLog.Services;
using log4net;
using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
    public class HelpController : Controller
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        private readonly IStaticDataService staticDataService;

        public HelpController(IStaticDataService staticDataService)
        {
            logger.Debug("Entered HelpController(IStaticDataService)");
            this.staticDataService = staticDataService;
        }

        // GET: Help
        public ActionResult Index()
        {
            return View();
        }

		public ActionResult SubmitTicket()
		{
            if (Session["SubmitTicketUrl"] == null)
            {
                Session["SubmitTicketUrl"] = this.staticDataService.Get("Submit Ticket");
            } 

			return Redirect((string)Session["SubmitTicketUrl"]);
		}
	}
}