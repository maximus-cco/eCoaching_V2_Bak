using System.Web.Mvc;

namespace eCLAdmin.Filters
{
    public class EclExceptionAttribute : IExceptionFilter
    {
        readonly log4net.ILog logger = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public void OnException(ExceptionContext filterContext)
        {
            logger.Error(filterContext.Exception.StackTrace);
            logger.Error(filterContext.Exception.Message);

            filterContext.Result = new ViewResult
            {
                ViewName = "~/Views/Shared/Error.cshtml"
            };

            filterContext.ExceptionHandled = true;
        }
    }
}