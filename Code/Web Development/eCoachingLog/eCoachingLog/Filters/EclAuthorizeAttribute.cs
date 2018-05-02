using eCoachingLog.Models.User;
using eCoachingLog.Services;
using eCoachingLog.Utils;
using log4net;
using System;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace eCoachingLog.Filters
{
    public class EclAuthorizeAttribute : AuthorizeAttribute
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public override void OnAuthorization(AuthorizationContext filterContext)
        {
            logger.Debug("Entered OnAuthorization");

            base.OnAuthorization(filterContext);

            HttpSessionStateBase session = filterContext.HttpContext.Session;
            if (session.IsNewSession)
            {
                logger.Debug("returning from OnAuthorization - session is NEW!");

                // Return, so SessionCheckAttribute.OnActionExecuting will be called, 
                // User will be sent to session expire page from there.
                return;
            }

            IUserService us = new UserService();
            User user = (User)session["AuthenticatedUser"];

			// Access control string: controller name
			string controllerName = filterContext.ActionDescriptor.ControllerDescriptor.ControllerName;
			bool isAccessAllowed = false;
			// TODO: have a db table configured to allow access each controller based on jobcodes
			// sp (getuser) to return controller access permission as well
			if ("NewSubmission" == controllerName)
			{
				isAccessAllowed = user.Role != UserRole.Employee && user.Role != UserRole.HR;
			}
			else if ("MyDashboard" == controllerName)
			{
				isAccessAllowed = user.Role != UserRole.HR;
			}
			else if ("HistoricalDashboard" == controllerName)
			{
				isAccessAllowed = user.Role != UserRole.Employee;
			}

			if (!isAccessAllowed)
			{
				/*User is not allowed to access the controller, return our 
                    custom '401 Unauthorized' access error. Since we are setting 
                    filterContext.Result to contain an ActionResult page, the controller's 
                    action will not run. */

				filterContext.Result = new RedirectToRouteResult(
											new RouteValueDictionary {
														 { "action", "Index" },
														 { "controller", "Unauthorized" } });
			}
		}
	}
}
