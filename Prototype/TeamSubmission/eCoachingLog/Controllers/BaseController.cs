using eCoachingLog.Filters;
using eCoachingLog.Models.User;
using eCoachingLog.Utils;
using log4net;
using System;
using System.Configuration;
using System.Linq;
using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
	[NoCache]
    public class BaseController : Controller
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        protected User GetUserFromSession()
        {
            User user = (User)Session["AuthenticatedUser"];
            if (user == null)
            {
                logger.Error("User in session is null!!!");
            }

            return user;
        }

		protected bool ShowMaintenancePage()
		{
			// Check if under maintenance
			var maintenancePage = System.Web.Hosting.HostingEnvironment.MapPath(Constants.MAINTENANCE_PAGE);
			logger.Debug("##########maintenancePage= " + maintenancePage);
			if (System.IO.File.Exists(maintenancePage))
			{
				string ipAddress = Request.UserHostAddress;
				logger.Debug("######ip=" + ipAddress);
				string[] addresses = Convert.ToString(ConfigurationManager.AppSettings["Prod.VnV.IPs"]).Split(',');
				// Send users to Maintenance page if not designated users doing Post Prod V&V
				if (!addresses.Where(a => a.Trim().Equals(ipAddress, StringComparison.InvariantCultureIgnoreCase)).Any())
				{
					return true;
				}
			}

			return false;
		}
    }
}