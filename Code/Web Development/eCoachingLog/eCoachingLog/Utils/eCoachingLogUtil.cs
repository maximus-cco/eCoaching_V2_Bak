using eCoachingLog.Extensions;
using log4net;
using System;
using System.Text.RegularExpressions;

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

		// Strip potentially harmful characters entered into a text field.
		public static string CleanInput(string strIn)
		{
			if (!String.IsNullOrEmpty(strIn))
			{
				try
				{
					string reg = @"[^\w\.@-]";
					return Regex.Replace(strIn, reg, string.Empty, RegexOptions.None, TimeSpan.FromSeconds(2));
				}
				// Timeout, return empty string.
				catch (RegexMatchTimeoutException)
				{
					return String.Empty;
				}
			}

			return strIn;
		}
    }
}