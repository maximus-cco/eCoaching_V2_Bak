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
    public class ReportController : BaseController
    {
        private readonly ILog logger = LogManager.GetLogger(typeof(ReportController));

        // GET: Report
        public ActionResult ReportTemplate(string ReportName, string ReportDescription, int Width, int Height)
        {
            //Server.MapPath("~/Content/Images/ecl-logo-small.png");

            logger.Debug("%%%%%%%%%%%%%%%%%inside report controller");

            string reportAspxPath = "~/Reports/ReportTemplate.aspx";// Server.MapPath("~/Reports/ReportTemplate.aspx");

            logger.Debug("!!!!!=" + reportAspxPath);

            var rptInfo = new ReportInfo
            {
                ReportName = ReportName,
                ReportDescription = ReportDescription,
                
                ReportURL = String.Format(reportAspxPath + "?ReportName={0}&Height={1}", ReportName, Height),


                Width = Width,
                Height = Height
            };

            logger.Debug("!!!!!URL=" + rptInfo.ReportURL);
            logger.Debug("%%%%%%%%%%%%%%%%%leaving report controller");

            Session["JobCode"] = GetUserFromSession().JobCode;

            return View(rptInfo);
        }
    }
}