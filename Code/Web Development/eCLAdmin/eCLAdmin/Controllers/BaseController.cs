using eCLAdmin.Models.User;
using eCLAdmin.Services;
using log4net;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web.Mvc;

namespace eCLAdmin.Controllers
{
    public class BaseController : Controller
    {
        readonly ILog logger = LogManager.GetLogger(typeof(BaseController));
        protected readonly IEmployeeLogService employeeLogService;

        public BaseController() { }

        public BaseController(IEmployeeLogService employeeLogService)
        {
            logger.Debug("Entered BaseController(IEmployeeLogService)");
            this.employeeLogService = employeeLogService;
        }

        protected bool ShowMaintenancePage()
		{
			// Check if under maintenance
			var maintenancePage = System.Web.Hosting.HostingEnvironment.MapPath(Constants.MAINTENANCE_PAGE);
			logger.Debug("##########maintenancePage= " + maintenancePage);
			if (System.IO.File.Exists(maintenancePage))
			{
				string ipAddress = Request.UserHostAddress;
				logger.Debug("######ip=" + ipAddress);
				string[] addresses = Convert.ToString(ConfigurationManager.AppSettings["Prod.VnV.IPs"]).Split(',');
				// Send users to Maintenance page if not designated users doing Post Prod V&V
				if (!addresses.Where(a => a.Trim().Equals(ipAddress, StringComparison.InvariantCultureIgnoreCase)).Any())
				{
					return true;
				}
			}

			return false;
		}

		protected User GetUserFromSession()
        {
            User user = (User)Session["AuthenticatedUser"];
            if (user == null)
            {
                logger.Debug("User in session is null!!!");
            }

            return (User)Session["AuthenticatedUser"];
        }

        protected bool IsAccessAllowed(string entitlement)
        {
            User user = (User) Session["AuthenticatedUser"];
            IUserService userService = new UserService();
            return userService.UserIsEntitled(user, entitlement);
        }

        protected IEnumerable<SelectListItem> GetTypes(string action, bool includeAll)
        {
            User user = GetUserFromSession();
            List<Models.EmployeeLog.Type> typeList = employeeLogService.GetTypes(user, action);
            if (includeAll)
            {
                typeList.Insert(0, new Models.EmployeeLog.Type { Id = -1, Description = "All" });
            }
            typeList.Insert(0, new Models.EmployeeLog.Type { Id = -2, Description = "Select Log Type" });
            IEnumerable<SelectListItem> types = new SelectList(typeList, "Id", "Description");

            return types;
        }

        // Download the generated excel file
        public void Download()
        {
            string fileName = (string)Session["fileName"];
            try
            {
                MemoryStream memoryStream = (MemoryStream)Session["fileStream"];
                Response.Clear();
                Response.Buffer = true;
                Response.Charset = "UTF-8";
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                // Give user option to open or save the excel file
                Response.AddHeader("content-disposition", "attachment; filename=" + fileName);
                memoryStream.WriteTo(Response.OutputStream);
                Response.Flush();
                Response.End();
            }
            catch (Exception ex)
            {
                logger.Warn(string.Format("Failed to download excel file: {0}", fileName));
                logger.Warn(string.Format("Exception message: {0}", ex.Message));
            }
            finally
            {
                // Clean up Session["fileStream"]
                Session.Contents.Remove("fileStream");
            }
        }
    }
}