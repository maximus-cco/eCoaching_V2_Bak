using eCoachingLog.Models.User;
using log4net;
using System.Web.Mvc;
using System.Web.Routing;

namespace eCoachingLog.Filters
{
    public class SessionCheckAttribute : ActionFilterAttribute
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            logger.Debug("Entered OnActionExecuting...");

            base.OnActionExecuting(filterContext);

            var session = filterContext.HttpContext.Session;
            logger.Debug("!!!!!!!!!SessionID=" + session.SessionID);
			User user = (User)session["AuthenticatedUser"];
			if (session.IsNewSession || user == null) // To be safe, check user in session null as well
            {
                // session has expired, redirect to session expired page
                if (filterContext.HttpContext.Request.IsAjaxRequest())
                {
                    logger.Debug("!!!!!!!!!!ajax call session expired!");
                    // http://stackoverflow.com/questions/29414682/how-to-handle-ajax-beginform-onerror-onfailure-callback
                    filterContext.HttpContext.Response.TrySkipIisCustomErrors = true;

                    filterContext.Result = new HttpStatusCodeResult(403, "Session Expired");
                }
                else
                {
                    logger.Debug("!!!!!!!! Session expired!");
                    filterContext.Result = new RedirectToRouteResult(
                                new RouteValueDictionary {
                                                { "action", "SessionExpired" },
                                                { "controller", "Home" } });
                }
            }
        }
    }
}