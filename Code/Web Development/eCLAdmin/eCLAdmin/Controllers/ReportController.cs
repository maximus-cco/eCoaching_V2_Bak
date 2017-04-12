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

        public ActionResult Index()
        {
            return View();
        }

        [EclAuthorize]
        public ActionResult RunCoachingSummary()
        {
            return View(Constants.REPORT_TEMPLATE, 
                            GetReportInfo(Constants.COACHING_SUMMARY_REPORT_NAME,
                                Constants.COACHING_SUMMARY_REPORT_DESCRIPTION,
                                Constants.REPORT_WIDTH,
                                Constants.REPORT_HEIGHT));
        }

        [EclAuthorize]
        public ActionResult RunWarningSummary()
        {
            return View(Constants.REPORT_TEMPLATE,
                            GetReportInfo(Constants.WARNING_SUMMARY_REPORT_NAME,
                                Constants.WARNING_SUMMARY_REPORT_DESCRIPTION,
                                Constants.REPORT_WIDTH,
                                Constants.REPORT_HEIGHT));
        }

        [EclAuthorize]
        public ActionResult RunHierarchySummary()
        {
            return View(Constants.REPORT_TEMPLATE,
                            GetReportInfo(Constants.HIERARCHY_SUMMARY_REPORT_NAME,
                                Constants.HIERARCHY_SUMMARY_REPORT_DESCRIPTION,
                                Constants.REPORT_WIDTH,
                                Constants.REPORT_HEIGHT));
        }

        [EclAuthorize]
        public ActionResult RunAdminActivitySummary()
        {
            return View(Constants.REPORT_TEMPLATE,
                            GetReportInfo(Constants.ADMIN_ACTIVITY_REPORT_NAME,
                                Constants.ADMIN_ACTIVITY_REPORT_DESCRIPTION,
                                Constants.REPORT_WIDTH,
                                Constants.REPORT_HEIGHT));
        }

        private ReportInfo GetReportInfo(string reportName, string reportDescription, int width, int height)
        {
            logger.Debug("Inside GetReportInfo");

            Session["LanId"] = GetUserFromSession().LanId;
            var rptInfo = new ReportInfo
            {
                ReportName = reportName,
                ReportDescription = reportDescription,
                ReportURL = String.Format("~/Reports/ReportTemplate.aspx" + "?ReportName={0}&Height={1}", reportName, height),
                Width = width,
                Height = height
            };

            return rptInfo;
        }
    }
}