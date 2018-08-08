using eCLAdmin.Models.User;
using eCLAdmin.Services;
using log4net;
using System;
using System.Configuration;
using System.Linq;
using System.Web.Mvc;

namespace eCLAdmin.Controllers
{
    public class HomeController : BaseController
    {
        readonly ILog logger = LogManager.GetLogger(typeof(HomeController));

        private IUserService userService = new UserService();

        public ActionResult Index()
        {
            logger.Debug("Entered HomeController.Index");

			// Check if under maintenance, index.html is the maintenance page
			var indexPage = System.Web.Hosting.HostingEnvironment.MapPath("~/index.html");
			logger.Debug("##########maintenancePage= " + indexPage);
			if (System.IO.File.Exists(indexPage))
			{
				string ipAddress = Request.UserHostAddress;
				logger.Debug("######ip=" + ipAddress);
				string[] addresses = Convert.ToString(ConfigurationManager.AppSettings["Prod.VnV.IPs"]).Split(',');
				// Send users to Maintenance page if not designated users doing Post Prod V&V
				if (!addresses.Where(a => a.Trim().Equals(ipAddress, StringComparison.InvariantCultureIgnoreCase)).Any())
				{
					return new FilePathResult(indexPage, "text/html");
				}
			}

			string userLanId = User.Identity.Name;
            userLanId = userLanId.Replace(@"AD\", "");
            User user = userService.GetUserByLanId(userLanId);
            if (user == null)
            {
                return RedirectToAction("Index", "Unauthorized");
            }

            Session["AuthenticatedUser"] = user;

            logger.Debug("Leaving HomeController.Index");

            if (userService.UserIsEntitled(user, "SeniorManagerDashboard"))
            {
                return RedirectToAction("Index", "Dashboard");
            }

            return View();
        }

        public ActionResult SessionExpire()
        {
            Session.Abandon();

            return View();
        }
    }
}