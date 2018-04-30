using eCoachingLog.Extensions;
using eCoachingLog.ViewModels;
using log4net;
using System;
using System.Collections.Generic;

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
            string env = System.Configuration.ConfigurationManager.AppSettings["environment"];
            string url = Constants.ECOACHING_URL_ST;

            if (string.CompareOrdinal("prod", env) == 0)
            {
                url = Constants.ECOACHING_URL_PROD;
            }

            return url;
        }

		//public static string GetModuleNameById(int moduleId)
		//{
		//    string moduleName = null;
		//    switch (moduleId)
		//    {
		//        case 1:
		//            moduleName = "CSR";
		//            break;
		//        case 2:
		//            moduleName = "Supervisor";
		//            break;
		//        case 3:
		//            moduleName = "Quality";
		//            break;
		//        case 4:
		//            moduleName = "LSA";
		//            break;
		//        case 5:
		//            moduleName = "Training";
		//            break;
		//        default:
		//            moduleName = "Unknown";
		//            break;
		//    }

		//    return moduleName;
		//}

		public static int GetProgramIdByName(string name)
        {
            int retVal = -1;
            if (name == "Marketplace")
            {
                retVal = 1;
            }
            else if (name == "Medicare")
            {
                retVal = 2;
            }
            else if (name == "NA")
            {
                retVal = 3;
            }
            return retVal;
        }

        //public static string GetWarningReasonTextById(int warningReasonId)
        //{
        //    string retVal = "unknown";
        //    if (warningReasonId == 28)
        //    {
        //        retVal = "Verbal Warning";
        //    }
        //    else if (warningReasonId == 29)
        //    {
        //        retVal = "Written Warning";
        //    }
        //    else if (warningReasonId == 30)
        //    {
        //        retVal = "Final Written Warning";
        //    }

        //    return retVal;
        //}

    }
}