using eCoachingLog.Repository;
using eCoachingLog.Services;
using log4net;
using SimpleInjector;
using SimpleInjector.Integration.Web;
using SimpleInjector.Integration.Web.Mvc;
using System;
using System.IO;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;

namespace eCoachingLog
{
    public class MvcApplication : System.Web.HttpApplication
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);

            log4net.Config.XmlConfigurator.Configure(new FileInfo(Server.MapPath("~/Web.config")));

            // 1. Create a new Simple Injector container
            var container = new Container();
            // Define scoped lifestyle - Per Web Request
            container.Options.DefaultScopedLifestyle = new WebRequestLifestyle();

            // 2. Configure the container (register)
            container.Register<IEmployeeService, EmployeeService>(Lifestyle.Scoped);
            container.Register<IEmployeeRepository, EmployeeRepository>(Lifestyle.Scoped);
            container.Register<IEmployeeLogService, EmployeeLogService>(Lifestyle.Scoped);
            container.Register<IEmployeeLogRepository, EmployeeLogRepository>(Lifestyle.Scoped);
            container.Register<IEmailService, EmailService>(Lifestyle.Scoped);
            container.Register<IUserService, UserService>(Lifestyle.Scoped);
            container.Register<ISiteService, SiteService>(Lifestyle.Scoped);
            container.Register<IProgramService, ProgramService>(Lifestyle.Scoped);
            container.Register<IStaticDataService, StaticDataService>(Lifestyle.Scoped);

            container.Register<IProgramRepository, ProgramRepository>(Lifestyle.Scoped);
            container.Register<INewSubmissionService, NewSubmissionService>(Lifestyle.Scoped);
            container.Register<INewSubmissionRepository, NewSubmissionRepository>(Lifestyle.Scoped);
			container.Register<ISurveyService, SurveyService>(Lifestyle.Scoped);
			container.Register<ISurveyRepository, SurveyRepository>(Lifestyle.Scoped);
			container.Register<IReviewRepository, ReviewRepository>(Lifestyle.Scoped);
			container.Register<IReviewService, ReviewService>(Lifestyle.Scoped);
            container.Register<IEmailRepository, EmailRepository>(Lifestyle.Scoped);
            container.Register<IStaticDataRepository, StaticDataRepository>(Lifestyle.Scoped);

            // 3. Optionally verify the container's configuration
            container.Verify();

            // 4. Store the container for use by the application
            DependencyResolver.SetResolver(new SimpleInjectorDependencyResolver(container));
			
			// Version Disclosure (ASP.NET MVC) - fix
            MvcHandler.DisableMvcResponseHeader = true; 
        }

        protected void Application_Error(object sender, EventArgs e) 
        {
            logger.Debug("Enter - Application_Error");

            Exception ex = Server.GetLastError();
			string exMsg = null;
            if (ex != null)
            {
				if (ex.InnerException != null)
				{
					exMsg = ex.InnerException.Message;
				}
				else
				{
					exMsg = ex.Message;
				}
				logger.Debug("ex: " + exMsg +
					Environment.NewLine + ex.StackTrace);
			}
            else
            {
                logger.Debug("exception is null");
            }

			Response.Clear();
			Server.ClearError();

			if (new HttpRequestWrapper(Request).IsAjaxRequest())
			{
				Response.TrySkipIisCustomErrors = true;
				Response.StatusCode = 404;
			}
			else
			{
				Response.Redirect("../Error/Index", false);
			}
        }

        protected void Session_Start(object sender, EventArgs e)
        {
            logger.Debug("@@@@@@@@@@@@@Enter - Session_Start - " + Session.SessionID);
        }

        protected void Session_End(object sender, EventArgs e)
        {
            var temp = Session == null ? null : Session.SessionID;
            logger.Debug("@@@@@@@@@@@@@@@@@@Enter - Session_End - " + temp);
        }

    }
}
