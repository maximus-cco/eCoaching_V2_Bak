using eCLAdmin.Repository;
using eCLAdmin.Services;
using log4net;
using SimpleInjector;
using SimpleInjector.Integration.Web;
using SimpleInjector.Integration.Web.Mvc;
using System;
using System.IO;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;

namespace eCLAdmin
{
	public class MvcApplication : System.Web.HttpApplication
    {
        readonly ILog logger = LogManager.GetLogger(typeof(MvcApplication));

        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);

            log4net.Config.XmlConfigurator.Configure(new FileInfo(Server.MapPath("~/Web.config")));

            //GlobalFilters.Filters.Add(new SessionCheckAttribute());
            //FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);

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
            container.Register<IStaticDataService, StaticDataService>(Lifestyle.Scoped);
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
            if (ex != null)
            {
                logger.Debug("ex: " + ex.InnerException.Message + 
                    Environment.NewLine + ex.InnerException.StackTrace);
            }
            else
            {
                logger.Debug("exception is null");
            }

            Server.ClearError();

            logger.Debug("Redirect to error");
            Response.Redirect("/Error/Index");
        }

    }
}
