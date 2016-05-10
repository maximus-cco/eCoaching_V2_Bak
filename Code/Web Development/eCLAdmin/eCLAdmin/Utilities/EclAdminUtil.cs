using eCLAdmin.Extensions;
using eCLAdmin.ViewModels;
using log4net;
using System.Collections.Generic;

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
            string logType = "unknown";

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
    }
}