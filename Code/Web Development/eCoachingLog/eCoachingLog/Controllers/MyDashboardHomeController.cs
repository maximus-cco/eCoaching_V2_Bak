using eCoachingLog.Filters;
using eCoachingLog.Services;
using log4net;
using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
    [EclAuthorize]
    [SessionCheck]
    public class MyDashboardHomeController : BaseController
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        private readonly IUserService userService;

        public MyDashboardHomeController(IUserService userService)
        {
            logger.Debug("Entered LoginController(IUserService)");
            this.userService = userService;
        }

        public ActionResult Index()
        {
            return RedirectToAction("Index", this.userService.DetermineLandingPage(GetUserFromSession()));
        }
    }
}