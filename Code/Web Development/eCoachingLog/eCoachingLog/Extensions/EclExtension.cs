using eCoachingLog.Controllers;
using eCoachingLog.Models.Common;
using log4net;
using OfficeOpenXml;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web.Mvc;
using System.Data.SqlClient;
using eCoachingLog.Models.Survey;

namespace eCoachingLog.Extensions
{
	public static class EclExtension
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

		public static MemoryStream GenerateExcelFile(this LogBaseController controller, DataSet dataSet, List<string> sheetNames)
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
					ws.Cells["A1"].LoadFromDataTable(dataSet.Tables[i], true);

					// Set date columns format				
					for (var j = 0; j < dataSet.Tables[0].Columns.Count; j++)
					{
						if (dataSet.Tables[0].Columns[j].DataType.Name.Equals("DateTime"))
						{
							ws.Column(j + 1).Style.Numberformat.Format = "yyyy-mm-dd hh:mm";
						} // end if
					} // end for j
				} // end for i

				excelPackage.SaveAs(memoryStream);
			}
			return memoryStream;
		}

        public static IEnumerable<SelectListItem> ToSelectListItems(this IEnumerable<Site> siteList, int selectedValue)
        {
            return
                siteList.Select(site =>
                          new SelectListItem
                          {
                              Selected = (site.Id == selectedValue),
                              Text = site.Name,
                              Value = site.Id.ToString()
                          });
        }

		public static SqlParameter AddSurveyResponseTableType(this SqlParameterCollection target, string name, Survey survey)
		{
			DataTable dataTable = new DataTable();
			dataTable.Columns.Add("QuestionID", typeof(int));
			dataTable.Columns.Add("ResponseID", typeof(int));
			dataTable.Columns.Add("Comments", typeof(string));

			foreach (Question q in survey.Questions)
			{
				dataTable.Rows.Add(q.Id, q.SingleChoiceSelected, q.MultiLineText);
			}

			SqlParameter sqlParameter = target.AddWithValue(name, dataTable);
			sqlParameter.SqlDbType = SqlDbType.Structured;
			sqlParameter.TypeName = "EC.ResponsesTableType";

			return sqlParameter;
		}
	}
}