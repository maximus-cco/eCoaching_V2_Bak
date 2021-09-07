using eCoachingLog.Models.User;
using eCoachingLog.Services;
using eCoachingLog.Utils;
using log4net;
using System;
using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
    public class LoginController : Controller
    {
		private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

		private readonly IUserService userService;

		public LoginController(IUserService userService)
		{
			logger.Debug("Entered LoginController(IUserService)");
			this.userService = userService;
		}

		// GET: Login
		public ActionResult Index()
        {
			string env = System.Configuration.ConfigurationManager.AppSettings["Environment"];
			// Load Test, display pseudo log in page
			if (String.Equals(env, "loadTest", StringComparison.OrdinalIgnoreCase))
			{
				return RedirectToAction("Index", "LoadTest");
			}

            string userLanId = User.Identity.Name.Replace(@"AD\", "");
            userLanId = userLanId.Replace(@"MAXCORP\", "");
            ////userLanId = "Helen.Aldana"; // director
            //userLanId = "202620"; // csr arc
            //userLanId = "204443"; //csr 
            //userLanId = "269878"; // supervisor
            ////userLanId = "82251"; // mgr
            ////userLanId = "62170"; // sr mgr
            ////userLanId = "229690"; // analyst
            ////userLanId = "225709"; // employee
            ////userLanId = "236583"; // restricted?
            ////userLanId = "228072"; // hr

            // dev
            //userLanId = "204443"; //csr
            //userLanId = "269878"; // supervisor

            // local
            // select * from ec.coaching_log where coachingid=185588
            //select* From ec.Coaching_Log_Quality_Now_Evaluations
            //where eval_date > '2021-01-01 12:15:36.000'
            //order by coachingid
            //select* from ec.coaching_log where coachingid = 185588 or empid = '230543'
            //select* from ec.coaching_log where SubmittedDate > '2021-05-20 10:46:39.580' and sourceid = 236 and empid = '230543'
            //update ec.coaching_log set empID = '230543', supid = '227819', mgrid = '229596' where coachingid in (185766,185767,185775)
            //select* from ec.coaching_log where coachingid in (185766,185767,185775)
            //update ec.coaching_log set formname = 'eCL-M-230543-185766' where coachingid in (185766)
            //update ec.coaching_log set formname = 'eCL-M-230543-185767' where coachingid in (185767)
            //update ec.coaching_log set formname = 'eCL-M-230543-185775' where coachingid in (185775)

            userLanId = "230543"; // role: csr
            //userLanId = "227819"; // role: supervisor
            userLanId = "227830"; // role: manager
            //userLanId = "225829"; // role: manager
            //userLanId = "247648"; // role: director
            //userLanId = "225427"; // role: director

            //userLanId = "228072"; // hr

            //userLanId = "202620"; // csr arc
            //userLanId = "269878"; // 202620 supervisor
            //userLanId = "229690"; // analyst
            //userLanId = "225709"; // employee
            //userLanId = "236583"; // restricted?


            User user = this.userService.Authenticate(userLanId);
            // todo: remove, set csr as arc
           //user.Role = Constants.USER_ROLE_ARC;

            Session["AuthenticatedUser"] = user;

			return RedirectToAction("Index", this.userService.DetermineLandingPage(user));
		}
	}
}