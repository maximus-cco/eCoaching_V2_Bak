using eCoachingLog.Models.User;
using log4net;
using System.Web.Mvc;
using System.Web.Routing;

namespace eCoachingLog.Filters
{
    public class EclExceptionAttribute : IExceptionFilter
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public void OnException(ExceptionContext filterContext)
        {
			User user = (User)filterContext.HttpContext.Session["AuthenticatedUser"];
			var userId = user == null ? "usernull" : user.EmployeeId;
			logger.Error("[" + userId + "] " + filterContext.Exception);

            // Error, redirect to error page
            if (filterContext.HttpContext.Request.IsAjaxRequest())
            {
                logger.Debug("!!!!!!!!!!ajax call exception thrown!");
                // http://stackoverflow.com/questions/29414682/how-to-handle-ajax-beginform-onerror-onfailure-callback
                filterContext.HttpContext.Response.TrySkipIisCustomErrors = true;

                filterContext.Result = new HttpStatusCodeResult(404, "Error");
            }
            else
            {
                logger.Debug("!!!!!!!! regular call exception thrown!");
                filterContext.Result = new RedirectToRouteResult(
                            new RouteValueDictionary {
                                                { "action", "Index" },
                                                { "controller", "Error" } });
            }

            filterContext.ExceptionHandled = true;
        }
    }
}