using eCLAdmin.Filters;
using eCLAdmin.Models.Report;
using log4net;
using System;
using System.Web.Mvc;

namespace eCLAdmin.Controllers
{
    [SessionCheck]
    public class ReportController : BaseController
    {
        private readonly ILog logger = LogManager.GetLogger(typeof(ReportController));

        [EclAuthorize]
        public ActionResult RunCoachingSummary()
        {
            return View(Constants.REPORT_TEMPLATE, 
                            GetReportInfo(Constants.COACHING_SUMMARY_REPORT_NAME,
                                                            Constants.COACHING_SUMMARY_REPORT_DESCRIPTION,
                                                            Constants.REPORT_WIDTH,
                                                            Constants.REPORT_HEIGHT));
        }

        private ReportInfo GetReportInfo(string reportName, string reportDescription, int width, int height)
        {
            //Server.MapPath("~/Content/Images/ecl-logo-small.png");

            logger.Debug("%%%%%%%%%%%%%%%%%inside GetReportInfo");

            string reportAspxPath = "~/Reports/ReportTemplate.aspx";// Server.MapPath("~/Reports/ReportTemplate.aspx");

            logger.Debug("!!!!!=" + reportAspxPath);

            var rptInfo = new ReportInfo
            {
                ReportName = reportName,
                ReportDescription = reportDescription,
                
                ReportURL = String.Format(reportAspxPath + "?ReportName={0}&Height={1}", reportName, height),


                Width = width,
                Height = height
            };

            logger.Debug("!!!!!URL=" + rptInfo.ReportURL);
            logger.Debug("%%%%%%%%%%%%%%%%%leaving report controller");

            Session["LanId"] = GetUserFromSession().LanId;

            return rptInfo;
        }
    }
}