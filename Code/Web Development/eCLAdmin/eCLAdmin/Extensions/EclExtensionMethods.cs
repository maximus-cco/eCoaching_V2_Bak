using eCLAdmin.Models;
using eCLAdmin.Models.User;
using eCLAdmin.Services;
using log4net;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Mvc;

namespace eCLAdmin.Extensions
{
    public static class EclExtensionMethods
    {
        static ILog logger = LogManager.GetLogger(typeof(EclExtensionMethods));

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

        public static SqlParameter AddWithValueSafe(this SqlParameterCollection parameters, string parameterName, object value)
        {
            return parameters.AddWithValue(parameterName, value ?? DBNull.Value);
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

        // MailStageTableType
        public static SqlParameter AddMailStageTableType(this SqlParameterCollection target, string name, IList<Email> mailList)
        {
            DataTable dataTable = new DataTable();
            dataTable.Columns.Add("LogID", typeof(long));
            dataTable.Columns.Add("LogName", typeof(string));
            dataTable.Columns.Add("To", typeof(string));
            dataTable.Columns.Add("Cc", typeof(string));
            dataTable.Columns.Add("From", typeof(string));
            dataTable.Columns.Add("FromDisplayName", typeof(string));
            dataTable.Columns.Add("Subject", typeof(string));
            dataTable.Columns.Add("Body", typeof(string));
            dataTable.Columns.Add("IsHtml", typeof(bool));

            foreach (var m in mailList)
            {
                dataTable.Rows.Add(
                    m.LogId,
                    m.LogName,
                    m.StrTo,
                    m.StrCc,
                    m.From,
                    m.FromDisplayName,
                    m.Subject,
                    m.Body,
                    m.IsBodyHtml
               );
            }
            SqlParameter sqlParameter = target.AddWithValue(name, dataTable);
            sqlParameter.SqlDbType = SqlDbType.Structured;
            sqlParameter.TypeName = "EC.MailStageTableType";

            return sqlParameter;
        }

        public static IEnumerable<SelectListItem> ToSelectListItems(this IEnumerable<eCoachingAccessControlRole> roles, string selectedValue)
        {
            return
                roles.Select(role =>
                          new SelectListItem
                          {
                              Selected = (role.Value.ToUpper() == selectedValue),
                              Text = role.Name,
                              Value = role.Value
                          });
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

        public static IEnumerable<SelectListItem> ToSelectListItems(this IEnumerable<Site> siteList, string selectedValue)
        {
            return
                siteList.Select(site =>
                          new SelectListItem
                          {
                              Selected = (site.Id == selectedValue),
                              Text = site.Name,
                              Value = site.Id
                          });
        }

        public static IDictionary<string, string> GetErrors(this ModelStateDictionary msDictionary)
        {
            var errors = new Dictionary<string, string>();

            errors = msDictionary.Where(x => x.Value.Errors.Count > 0).ToDictionary(
                    kvp => kvp.Key,
                    kvp => kvp.Value.Errors.Select(e => e.ErrorMessage).FirstOrDefault()
                );

            return errors;
        }
    }
}