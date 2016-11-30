using log4net;
using System.Web.Mvc;
using System.Web.Routing;

namespace eCLAdmin.Filters
{
    public class SessionCheckAttribute : ActionFilterAttribute
    {
        readonly ILog logger = LogManager.GetLogger(typeof(SessionCheckAttribute));

        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            logger.Debug("Entered OnActionExecuting...");

            base.OnActionExecuting(filterContext);

            var session = filterContext.HttpContext.Session;
            if (session.IsNewSession)
            {
                // session has expired, redirect to session expired page

                if (filterContext.HttpContext.Request.IsAjaxRequest())
                {
                    logger.Debug("!!!!!!!!!!ajax call session expired!");
                    filterContext.HttpContext.Response.StatusCode = 403;
                    // http://stackoverflow.com/questions/29414682/how-to-handle-ajax-beginform-onerror-onfailure-callback
                    filterContext.HttpContext.Response.TrySkipIisCustomErrors = true;
                }
                else
                {
                    filterContext.Result = new RedirectToRouteResult(
                                new RouteValueDictionary {
                                                { "action", "SessionExpire" },
                                                { "controller", "Home" } });
                }
            }
        }
    }
}