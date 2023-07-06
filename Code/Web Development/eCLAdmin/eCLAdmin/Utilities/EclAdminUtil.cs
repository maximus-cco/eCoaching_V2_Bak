using eCLAdmin.Extensions;
using eCLAdmin.ViewModels;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;

namespace eCLAdmin.Utilities
{
    public static class EclAdminUtil
    {
        static readonly ILog logger = LogManager.GetLogger(typeof(EclAdminUtil));

        public static IDictionary<int, List<string>> BuildLogStatusNamesDictionary(List<EmployeeLogSelectEditorViewModel> logs)
        {
            IDictionary<int, List<string>> dict = new Dictionary<int, List<string>>();
            foreach (var log in logs)
            {
                int key = log.PreviousStatusId;
                string value = log.FormName;
                List<string> logNames = null;

                if (!dict.TryGetValue(key, out logNames))
                {
                    logNames = new List<string>();
                }

                logNames.Add(value);
                dict[key] = logNames;
            }

            return dict;
        }

        public static string GetLogTypeNameById(int logTypeId)
        {
            if (logTypeId == -1)
            {
                return "All";
            }

            if (logTypeId == -2)
            {
                return "";
            }

            string logType = null;
            var typeList = Enum.GetValues(typeof(EmployeeLogType))
               .Cast<EmployeeLogType>()
               .Select(t => new eCLAdmin.Models.EmployeeLog.Type
               {
                   Id = ((int)t),
                   Description = t.ToString()
               });

            logType = typeList.Where(x => x.Id == logTypeId).Select(y => y.Description).First();

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
    }
}