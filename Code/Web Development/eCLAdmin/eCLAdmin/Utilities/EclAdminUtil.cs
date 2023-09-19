using eCLAdmin.ViewModels;
using log4net;
using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

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

        public static MemoryStream GenerateExcelFile(DataSet dataSet, List<string> sheetNames)
        {
            ExcelPackage excelPackage;
            MemoryStream memoryStream = new MemoryStream();
            using (excelPackage = new ExcelPackage())
            {
                // Create sheet for each table contained in the dataset
                for (var i = 0; i < dataSet.Tables.Count; i++)
                {
                    var sheetName = i < sheetNames.Count ? sheetNames[i] : "Sheet" + i;
                    var ws = excelPackage.Workbook.Worksheets.Add(sheetName);
                    var dataTable = dataSet.Tables[i];
                    dataTable.Columns.Remove("RowNumber");
                    dataTable.Columns.Remove("TotalRows");
                    // Set date columns format				
                    for (var j = 0; j < dataTable.Columns.Count; j++)
                    {
                        if (dataTable.Columns[j].DataType.Name.Equals("DateTime"))
                        {
                            ws.Column(j + 1).Style.Numberformat.Format = "yyyy-mm-dd hh:mm";
                        } // end if
                    } // end j
                    ws.Cells["A1"].LoadFromDataTable(dataTable, true);
                } // end i

                excelPackage.SaveAs(memoryStream);
            }
            return memoryStream;
        }

        public static string RemoveNonAscii(string str)
        {
            string pattern = "[^ -~]+";
            Regex reg_exp = new Regex(pattern);
            return reg_exp.Replace(str, "");
        }
    }
}