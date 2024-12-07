﻿using eCLAdmin.Models.User;
using eCLAdmin.Services;
using log4net;
using System.Web.Mvc;

namespace eCLAdmin.Controllers
{
    public class HomeController : BaseController
    {
        private static readonly ILog logger = LogManager.GetLogger(typeof(HomeController));

        private IUserService userService = new UserService();

        public ActionResult Index()
        {
            logger.Debug("Entered HomeController.Index");

            if (ShowMaintenancePage())
			{
				return new FilePathResult(System.Web.Hosting.HostingEnvironment.MapPath(Constants.MAINTENANCE_PAGE), "text/html");
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

            return View();
        }

        public ActionResult SessionExpire()
        {
            Session.Abandon();

            return View();
        }
    }
}