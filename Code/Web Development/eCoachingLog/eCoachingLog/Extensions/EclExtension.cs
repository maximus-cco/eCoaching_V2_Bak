using eCoachingLog.Controllers;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using eCoachingLog.Services;
using eCoachingLog.Utils;
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

		public static MemoryStream GenerateExcelFile(this LogBaseController controller, DataTable dataTable)
		{
			ExcelPackage excelPackage;
			MemoryStream memoryStream = new MemoryStream();
			using (excelPackage = new ExcelPackage())
			{
				var workSheet = excelPackage.Workbook.Worksheets.Add("eCoachingLog");
				workSheet.Cells["A1"].LoadFromDataTable(dataTable, true);
				// Set date columns format				
				for (var i = 0; i < dataTable.Columns.Count; i++)
				{
					if (dataTable.Columns[i].DataType.Name.Equals("DateTime"))
					{
						workSheet.Column(i + 1).Style.Numberformat.Format = "yyyy-mm-dd hh:mm";
					}
				}
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