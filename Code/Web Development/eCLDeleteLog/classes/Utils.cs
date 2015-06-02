using eCLDeleteLog.classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;

namespace eCLDeleteLog.classes
{
    public class Utils
    {
        /// <summary>
        /// Check against database name
        /// John is the only one that has access to production
        /// </summary>
        /// <returns></returns>
        public static bool IsSiteAccessAllowed()
        {
            string databaseName = GetDatabaseName();
            string userId = GetUserLanId();

            if (IsProductionDB(databaseName))
            {
                // only John has access to production
                return string.Equals("JohnEric.Tiongson", userId, StringComparison.OrdinalIgnoreCase);
            }
            else if (IsSystemTestDB(databaseName))
            {
                return (string.Equals("lili.huang", userId, StringComparison.OrdinalIgnoreCase) ||
                            string.Equals("Doug.Stearns", userId, StringComparison.OrdinalIgnoreCase) ||
                            string.Equals("Jourdain.Augustin", userId, StringComparison.OrdinalIgnoreCase));
            }
            else if (IsDevelopmentDB(databaseName))
            {
                return true;
            }

            return false;
        }

        public static string GetDatabaseName()
        {
            string connectionString = WebConfigurationManager.ConnectionStrings["CoachingConnectionString"].ConnectionString;
            string dataSource = connectionString.Split(';')[0];
            return dataSource.Split('=')[1];
        }

        public static string GetUserLanId()
        {
            return (HttpContext.Current.User.Identity.Name.ToLower()).Replace("ad\\", "");
        }

        public static bool IsProductionDB(string databaseName)
        {
            return string.Equals(Constants.ProductionDB, databaseName, StringComparison.OrdinalIgnoreCase);
        }

        public static bool IsSystemTestDB(string databaseName)
        {
            return string.Equals(Constants.SystemTestDB, databaseName, StringComparison.OrdinalIgnoreCase);
        }

        public static bool IsDevelopmentDB(string databaseName)
        {
            return string.Equals(Constants.DevelopmentDB, databaseName, StringComparison.OrdinalIgnoreCase);
        }
    }
}