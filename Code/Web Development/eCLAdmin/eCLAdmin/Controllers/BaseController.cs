using log4net;
using System;
using System.Web.Mvc;

namespace eCLAdmin.Controllers
{
    public class BaseController : Controller
    {
        readonly ILog logger = LogManager.GetLogger(typeof(BaseController));

        protected override void OnException(ExceptionContext filterContext)
        {
            Exception ex = filterContext.Exception;
            logger.Error("Exception thrown: " + ex.Message);
            logger.Error(ex.StackTrace);

            filterContext.Result = this.RedirectToAction("Index", "Error");
            filterContext.ExceptionHandled = true;
        }
    }
}