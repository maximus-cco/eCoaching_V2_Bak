using eCoachingLog.Controllers;
using eCoachingLog.Models.Common;
using log4net;
using OfficeOpenXml;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web.Mvc;

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
					var dataTable = dataSet.Tables[i];
					// Set date columns format				
					for (var j = 0; j < dataTable.Columns.Count; j++)
					{
						if (dataTable.Columns[j].DataType.Name.Equals("DateTime"))
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

		public static IDictionary<string, string> GetErrors(this ModelStateDictionary msDictionary)
		{
			return msDictionary
					.Where(x => x.Value.Errors.Count > 0)
					.ToDictionary(
						kvp => kvp.Key,
						kvp => kvp.Value.Errors.Select(e => e.ErrorMessage).FirstOrDefault()
					);
		}
	}
}