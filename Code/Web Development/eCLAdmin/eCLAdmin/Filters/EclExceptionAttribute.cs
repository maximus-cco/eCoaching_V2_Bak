using System.Web.Mvc;
using System.Web.Routing;

namespace eCLAdmin.Filters
{
    public class EclExceptionAttribute : IExceptionFilter
    {
        readonly log4net.ILog logger = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public void OnException(ExceptionContext filterContext)
        {
			logger.Error("Exception: " + filterContext.Exception.StackTrace);

			filterContext.Result = new RedirectToRouteResult(
				new RouteValueDictionary
				{
					{ "controller", "Error" },
					{ "action", "Index" }
				});
	
			filterContext.ExceptionHandled = true;
		}
	}
}