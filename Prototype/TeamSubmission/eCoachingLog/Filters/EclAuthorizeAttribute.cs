using eCoachingLog.Models.User;
using log4net;
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
			User user = (User)session["AuthenticatedUser"];
			if (session.IsNewSession || user == null) // Check if user is null as well.Sometimes it is new session, but it tells me false
            {
                logger.Debug("returning from OnAuthorization - session is NEW!");

                // Return, so SessionCheckAttribute.OnActionExecuting will be called, 
                // User will be sent to session expire page from there.
                return;
            }

			// Access control string: controller name
			string controllerName = filterContext.ActionDescriptor.ControllerDescriptor.ControllerName;
			// Action name
			string actionName = filterContext.ActionDescriptor.ActionName;
			bool isAccessAllowed = false;
			if ("NewSubmission" == controllerName)
			{
				isAccessAllowed = user.IsAccessNewSubmission;
			}
			else if ("MyDashboard" == controllerName)
			{
				isAccessAllowed = user.IsAccessMyDashboard;
			}
			else if ("HistoricalDashboard" == controllerName)
			{
				isAccessAllowed = user.IsAccessHistoricalDashboard;
				if ("ExportToExcel" == actionName)
				{
					isAccessAllowed = user.IsExportExcel;
				}
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
