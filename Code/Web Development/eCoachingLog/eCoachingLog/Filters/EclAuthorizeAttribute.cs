using eCoachingLog.Models.User;
using eCoachingLog.Services;
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

            // Entitlement string: controller-action
            string entitlementRequired = String.Format("{0}-{1}",
                    filterContext.ActionDescriptor.ControllerDescriptor.ControllerName,
                    filterContext.ActionDescriptor.ActionName);

            logger.Debug("entitlementRequired='" + entitlementRequired + "'");

            // Check if user is allowed to run the controller's action
            if (!us.UserIsEntitled(user, entitlementRequired))
            {
                /*User doesn't have the required entitlement, return our 
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
