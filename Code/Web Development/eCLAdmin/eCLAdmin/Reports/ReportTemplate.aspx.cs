using Microsoft.Reporting.WebForms;
using log4net;
using System;
using System.Web.UI.WebControls;

namespace eCLAdmin.Reports
{
    public partial class ReportTemplate : System.Web.UI.Page
    {

        private readonly ILog logger = LogManager.GetLogger(typeof(ReportTemplate));

        protected void Page_Load(object sender, EventArgs e)
        {
            logger.Debug("@@@@@@@@@@@@@@@@@@@@@@@@Inside Page_Load");

            if (!IsPostBack)
            {
                try
                {
                    String reportFolder = System.Configuration.ConfigurationManager.AppSettings["SSRSReportsFolder"].ToString();

                    rvSiteMapping.Height = Unit.Pixel(Convert.ToInt32(Request["Height"]) - 58);
                    rvSiteMapping.ProcessingMode = Microsoft.Reporting.WebForms.ProcessingMode.Remote;

                    rvSiteMapping.ServerReport.ReportServerUrl = new Uri(System.Configuration.ConfigurationManager.AppSettings["ECL.Properties.Reports.BaseSsrsUrl"]);
                    rvSiteMapping.ServerReport.ReportPath = String.Format("/{0}/Reports/{1}", reportFolder, Request["ReportName"].ToString());

                    logger.Debug("URL=" + rvSiteMapping.ServerReport.ReportServerUrl);
                    logger.Debug("Path=" + rvSiteMapping.ServerReport.ReportPath);


                    ReportParameter param = new ReportParameter("LanId", (string) Session["LanId"]);
                    rvSiteMapping.ServerReport.SetParameters(new ReportParameter[] { param });

                    rvSiteMapping.ServerReport.Refresh();
                }
                catch (Exception ex)
                {
                    logger.Debug("##############" + ex.StackTrace);
                }
            }

            logger.Debug("@@@@@@@@@@@@@@@@@@@@@@@@Leaving page_load");

        }
    }
}