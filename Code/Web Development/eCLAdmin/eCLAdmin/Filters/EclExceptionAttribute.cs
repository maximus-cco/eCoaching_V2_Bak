using System;
using System.Text;
using System.Web.Mvc;
using System.Web.Routing;

namespace eCLAdmin.Filters
{
    public class EclExceptionAttribute : IExceptionFilter
    {
        readonly log4net.ILog logger = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public void OnException(ExceptionContext filterContext)
        {
			StringBuilder error = new StringBuilder();
			error.Append("Exception: ")
				.Append(filterContext.Exception.Message)
				.Append(Environment.NewLine)
				.Append(filterContext.Exception.StackTrace);
			logger.Error(error.ToString());

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