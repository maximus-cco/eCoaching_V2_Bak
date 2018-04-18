using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using eCoachingLog.Services;
using log4net;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Mvc;

namespace eCoachingLog.Extensions
{
    public static class EclExtensionMethods
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

        public static SqlParameter AddIdsTableType(this SqlParameterCollection target, string name, List<long> values)
        {
            DataTable dataTable = new DataTable();
            dataTable.Columns.Add("ID", typeof(long));
            foreach (long value in values)
            {
                dataTable.Rows.Add(value);
            }

            SqlParameter sqlParameter = target.AddWithValue(name, dataTable);
            sqlParameter.SqlDbType = SqlDbType.Structured;
            sqlParameter.TypeName = "EC.IdsTableType";

            return sqlParameter;
        }

        //public static IEnumerable<SelectListItem> ToSelectListItems(this IEnumerable<eCoachingAccessControlRole> roles, string selectedValue)
        //{
        //    return
        //        roles.Select(role =>
        //                  new SelectListItem
        //                  {
        //                      Selected = (role.Value.ToUpper() == selectedValue),
        //                      Text = role.Name,
        //                      Value = role.Value
        //                  });
        //}

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