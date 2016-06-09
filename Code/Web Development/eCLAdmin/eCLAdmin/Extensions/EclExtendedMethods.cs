using eCLAdmin.Models.User;
using eCLAdmin.Services;
using log4net;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.Mvc;

namespace eCLAdmin.Extensions
{
    public static class EclExtendedMethods
    {
        static ILog logger = LogManager.GetLogger(typeof(EclExtendedMethods));

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

            return us.UserIsEntitled(user, entitlementName);
        }

        public static bool ShowPreviousStatus(this ControllerBase controller, string action)
        {
            bool retVal = false;
            if (!string.IsNullOrWhiteSpace(action) &&
                    string.Equals(action, Constants.LOG_ACTION_REACTIVATE, StringComparison.OrdinalIgnoreCase))
            {
                retVal = true;
            }

            return retVal;
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
    }
}