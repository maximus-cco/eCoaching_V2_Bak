using eCoachingLog.Extensions;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;

namespace eCoachingLog.Utils
{
	public static class EclUtil
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public static string AppendTimeZone(string str)
        {
            if (String.IsNullOrWhiteSpace(str))
            {
                return str;
            }

            return str + " " + Constants.TIMEZONE;
        }

		public static string CleanInput(string strIn)
		{
			string strOut = HttpUtility.HtmlEncode(strIn);
			return strOut;
		}

        public static string RemoveToken(string str, string token)
        {
            if (string.IsNullOrEmpty(str) || string.IsNullOrEmpty(token))
            {
                return str;
            }

            return str.Replace(token, "");
        }
        
        public static List<string> ConvertToList(string str, string delimiter)
        {
            if (string.IsNullOrEmpty(str))
            {
                return new List<string>();
            }

            return str.Split(',').ToList<string>();
        }

        public static string ConvertToString(List<string> list, string delimiter)
        {
            if (list == null || list.Count == 0)
            {
                return "";
            }

            if (String.IsNullOrEmpty(delimiter))
            {
                delimiter = ", ";
            }

            return String.Join<string>(delimiter, list);
        }

        public static string BoldSubstring(string str, string subStr)
        {
            if (String.IsNullOrEmpty(str) || String.IsNullOrEmpty(subStr))
            {
                return str;
            }

            return str.Replace(subStr, "<b>" + subStr + "</b>");
        }

        public static string Sanitize(string str)
        {
            if (string.IsNullOrEmpty(str))
            {
                return str;
            }

            var retStr = Regex.Replace(str, "&lt;script", "&lt; script", RegexOptions.IgnoreCase);
            retStr = Regex.Replace(retStr, "&lt;form", "&lt; form", RegexOptions.IgnoreCase);

            return retStr;
        }
    }
}