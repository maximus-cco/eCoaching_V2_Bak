using eCoachingLog.Extensions;
using log4net;
using System;

namespace eCoachingLog.Utils
{
	public static class eCoachingLogUtil
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public static string GetLogTypeNameById(int logTypeId)
        {
            string logType = null;

            // Set log type
            if (logTypeId == (int)EmployeeLogType.Coaching)
            {
                logType = EmployeeLogType.Coaching.ToDescription();
            }
            else if (logTypeId == (int)EmployeeLogType.Warning)
            {
                logType = EmployeeLogType.Warning.ToDescription();
            }

            return logType;
        }

        public static string AppendPdt(string str)
        {
            if (String.IsNullOrWhiteSpace(str))
            {
                return str;
            }

            return str + " PDT";
        }

        public static string GetAppUrl()
        {
            string env = System.Configuration.ConfigurationManager.AppSettings["Environment"];
            string url = Constants.ECOACHING_URL_ST;

            if (string.CompareOrdinal("prod", env) == 0)
            {
                url = Constants.ECOACHING_URL_PROD;
            }

            return url;
        }
    }
}