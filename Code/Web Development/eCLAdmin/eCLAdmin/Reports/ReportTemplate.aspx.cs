using Microsoft.Reporting.WebForms;
using log4net;
using System;
using System.Web.UI.WebControls;
using System.Web.UI;

namespace eCLAdmin.Reports
{
    public partial class ReportTemplate : System.Web.UI.Page
    {

        private readonly ILog logger = LogManager.GetLogger(typeof(ReportTemplate));

        protected void Page_Load(object sender, EventArgs e)
        {
            logger.Debug("Inside Page_Load");
            string reportName = String.Empty;

            // Fix [Possible] Cross-site Request Forgery
            ValidateForgeryToken(this.Page, forgeryToken);

            if (!IsPostBack)
            {
                try
                {
                    string reportFolder = System.Configuration.ConfigurationManager.AppSettings["SSRSReportsFolder"].ToString();
                    reportName = Request["ReportName"].ToString();

                    rvSiteMapping.ProcessingMode = Microsoft.Reporting.WebForms.ProcessingMode.Remote;

                    rvSiteMapping.ServerReport.ReportServerUrl = new Uri(System.Configuration.ConfigurationManager.AppSettings["ECL.Properties.Reports.BaseSsrsUrl"]);
                    rvSiteMapping.ServerReport.ReportPath = String.Format("/{0}/Reports/{1}", reportFolder, reportName);

                    logger.Debug("URL=" + rvSiteMapping.ServerReport.ReportServerUrl);
                    logger.Debug("Path=" + rvSiteMapping.ServerReport.ReportPath);

                    if (reportName == Constants.COACHING_SUMMARY_REPORT_NAME ||
                            reportName == Constants.WARNING_SUMMARY_REPORT_NAME)
                    {
                        ReportParameter param = new ReportParameter("LanID", (string)Session["LanId"]);
                        rvSiteMapping.ServerReport.SetParameters(new ReportParameter[] { param });

                        rvSiteMapping.ServerReport.Refresh();
                    }
                }
                catch (Exception ex)
                {
                    logger.Debug("Exception when trying to render report:" + reportName + ". " + ex.Message);
                }
            }

            logger.Debug("Leaving page_load");

        }

        public static void ValidateForgeryToken(Page page, HiddenField forgeryToken)
        {
            if (!page.IsPostBack)
            {
                Guid antiforgeryToken = Guid.NewGuid();
                page.Session["AntiforgeryToken"] = antiforgeryToken;
                forgeryToken.Value = antiforgeryToken.ToString();
            }
            else
            {
                Guid stored = (Guid)page.Session["AntiforgeryToken"];
                Guid sent = new Guid(forgeryToken.Value);
                if (sent != stored)
                {
                    page.Session.Abandon();
                    page.Response.Redirect("~/Error");
                }
            }
        }

    }
}