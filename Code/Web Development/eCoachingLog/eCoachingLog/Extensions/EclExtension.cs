using eCoachingLog.Controllers;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using eCoachingLog.Services;
using log4net;
using OfficeOpenXml;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web.Mvc;

namespace eCoachingLog.Extensions
{
	public static class EclExtension
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public static bool IsEntitled(this ControllerBase controller, string entitlementName)
        {
            User user = (User)controller.ControllerContext.HttpContext.Session["AuthenticatedUser"];
            IUserService us = new UserService();
            if (user == null)
            {
                string userLanId = controller.ControllerContext.HttpContext.User.Identity.Name;
                userLanId = userLanId.Replace(@"AD\", "");
                user = us.GetUserByLanId(userLanId);
                controller.ControllerContext.HttpContext.Session["AuthenticatedUser"] = user;
            }

            //return us.UserIsEntitled(user, entitlementName);
            return true;
        }

		public static MemoryStream GenerateExcelFile(this LogBaseController controller, DataTable dataTable)
		{
			ExcelPackage excelPackage;
			MemoryStream memoryStream = new MemoryStream();
			using (excelPackage = new ExcelPackage())
			{
				var workSheet = excelPackage.Workbook.Worksheets.Add("eCoachingLog");
				workSheet.Cells["A1"].LoadFromDataTable(dataTable, true);
				// Set date columns format				
				for (var i = 0; i < dataTable.Columns.Count; i++)
				{
					if (dataTable.Columns[i].DataType.Name.Equals("DateTime"))
					{
						workSheet.Column(i + 1).Style.Numberformat.Format = "yyyy-mm-dd hh:mm";
					}
				}
				excelPackage.SaveAs(memoryStream);
			}
			return memoryStream;
		}

		public static IEnumerable<SelectListItem> ToSelectListItems(this IEnumerable<NameLanId> nameLanIdList, string selectedValue)
        {
            return
                nameLanIdList.Select(nameLanId =>
                          new SelectListItem
                          {
                              Selected = (nameLanId.LanId.ToUpper() == selectedValue),
                              Text = nameLanId.Name,
                              Value = nameLanId.LanId
                          });
        }

        public static IEnumerable<SelectListItem> ToSelectListItems(this IEnumerable<Site> siteList, int selectedValue)
        {
            return
                siteList.Select(site =>
                          new SelectListItem
                          {
                              Selected = (site.Id == selectedValue),
                              Text = site.Name,
                              Value = site.Id.ToString()
                          });
        }
    }
}