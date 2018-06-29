using eCoachingLog.Extensions;
using log4net;
using System;
using System.Text.RegularExpressions;
using System.Web;

namespace eCoachingLog.Utils
{
	public static class eCoachingLogUtil
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public static string AppendPdt(string str)
        {
            if (String.IsNullOrWhiteSpace(str))
            {
                return str;
            }

            return str + " PDT";
        }

		public static string CleanInput(string strIn)
		{
			string strOut = HttpUtility.HtmlEncode(strIn);
			return strOut;
		}
    }
}