using eCLAdmin.Filters;
using eCLAdmin.Models.Report;
using eCLAdmin.Models.User;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace eCLAdmin.Controllers
{
    [SessionCheck]
    public class ReportController : BaseController
    {
        private readonly ILog logger = LogManager.GetLogger(typeof(ReportController));

        private readonly int REPORT_WIDTH = 100;
        private readonly int REPORT_HEIGHT = 650;
        private readonly string REPORT_TEMPLATE = "ReportTemplate";

        private readonly string COACHING_SUMMARY_REPORT_NAME = "CoachingSummary";
        private readonly string COACHING_SUMMARY_REPORT_DESCRIPTION = "Coaching Log Summary";
        private readonly string AD_HOC_REPORT_NAME = "";
        private readonly string AD_HOC_REPORT_DESCRIPTION = "";

        [EclAuthorize]
        public ActionResult RunCoachingSummary()
        {
            return View(REPORT_TEMPLATE, GetReportInfo(COACHING_SUMMARY_REPORT_NAME, COACHING_SUMMARY_REPORT_DESCRIPTION, REPORT_WIDTH, REPORT_HEIGHT));
        }

        public ReportInfo GetReportInfo(string reportName, string reportDescription, int width, int height)
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

            Session["JobCode"] = GetUserFromSession().JobCode;

            return rptInfo;
        }
    }
}