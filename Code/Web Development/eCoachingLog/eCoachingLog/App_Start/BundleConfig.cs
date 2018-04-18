using eCoachingLog.App_Start;
using System.Web.Optimization;

namespace eCoachingLog
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            // javascript across web app
            var scriptBundle = new ScriptBundle("~/bundles/scripts");
            scriptBundle.Orderer = new EclBundleOrderer();
            scriptBundle.Include(
                        "~/Scripts/modernizr-*",
                        "~/Scripts/jquery-{version}.js",
                        "~/Scripts/jquery.validate.js",
                        "~/Scripts/jquery.validate.unobtrusive.js",
                        "~/Scripts/jquery.unobtrusive-ajax.js",
                        "~/Scripts/jquery.dataTables.js",
                        "~/Scripts/jquery.userTimeout.js",
                        "~/Scripts/moment.js",
                        "~/Scripts/bootstrap.js",
                        "~/Scripts/bootstrap-datetimepicker.js",
                        "~/Scripts/bootstrap-multiselect.js",
                        "~/Scripts/dataTables.bootstrap.js",
						"~/Scripts/dataTables.responsive.js",
						"~/Scripts/respond.js",
                        "~/Scripts/raphael.js",
						// Chart I'm going to use!
						"~/Scripts/Chart.js",
                        "~/Scripts/eCoachingLog/layout.js");
            bundles.Add(scriptBundle);

            // javascript bundle for New Submission
            var newSubmissionScriptBundle = new ScriptBundle("~/bundles/scripts/newSubmission");
            newSubmissionScriptBundle.Orderer = new EclBundleOrderer();
            newSubmissionScriptBundle.Include(
                "~/Scripts/eCoachingLog/newSubmission.js");
            bundles.Add(newSubmissionScriptBundle);

			// javascript bundle for Review
			var reviewScriptBundle = new ScriptBundle("~/bundles/scripts/review");
			reviewScriptBundle.Orderer = new EclBundleOrderer();
			reviewScriptBundle.Include(
				"~/Scripts/eCoachingLog/review.js");
			bundles.Add(reviewScriptBundle);

			// TODO: chart
			var eclChartScriptBundle = new ScriptBundle("~/bundles/scripts/eclChart");
			eclChartScriptBundle.Orderer = new EclBundleOrderer();
			eclChartScriptBundle.Include(
                        "~/Scripts/eCoachingLog/eclChart.js");
            bundles.Add(eclChartScriptBundle);

            // javascript bundle for dashboard
            var dashboardScriptBundle = new ScriptBundle("~/bundles/scripts/dashboard");
            dashboardScriptBundle.Orderer = new EclBundleOrderer();
            dashboardScriptBundle.Include(
                        "~/Scripts/eCoachingLog/dashboard.js");
            bundles.Add(dashboardScriptBundle);

            // javascript bundle for mydashboard coaching list
            var logListScriptBundle = new ScriptBundle("~/bundles/scripts/myDashboardLogList");
			logListScriptBundle.Orderer = new EclBundleOrderer();
			logListScriptBundle.Include(
						"~/Scripts/eCoachingLog/logList.js");
            bundles.Add(logListScriptBundle);

			// javascript bundle for mydashboard warning list
			var myDashboardWarningListScriptBundle = new ScriptBundle("~/bundles/scripts/myDashboardWarningList");
			myDashboardWarningListScriptBundle.Orderer = new EclBundleOrderer();
			myDashboardWarningListScriptBundle.Include(
						"~/Scripts/eCoachingLog/myDashboardWarningList.js");
			bundles.Add(myDashboardWarningListScriptBundle);

			// javascript bundle for mydashboard review
			var myDashboardReviewScriptBundle = new ScriptBundle("~/bundles/scripts/myDashboardReview");
            myDashboardReviewScriptBundle.Orderer = new EclBundleOrderer();
            myDashboardReviewScriptBundle.Include(
                        "~/Scripts/eCoachingLog/myDashboardReview.js");
            bundles.Add(myDashboardReviewScriptBundle);


			// javascript bundle for historical dashboard search
			var hisDashboardSearchScriptBundle = new ScriptBundle("~/bundles/scripts/historicalDashboardSearch");
			hisDashboardSearchScriptBundle.Orderer = new EclBundleOrderer();
			hisDashboardSearchScriptBundle.Include(
						"~/Scripts/eCoachingLog/historicalDashboardSearch.js");
			bundles.Add(hisDashboardSearchScriptBundle);

			// css across web app
			bundles.Add(new StyleBundle("~/Content/css").Include(
					   "~/Content/bootstrap.css",
                       "~/Content/bootstrap-datetimepicker.min.css",
                       "~/Content/bootstrap-multiselect.css",
                       "~/Content/dataTables.bootstrap.css",
                       "~/Content/dataTables.responsive.css",
                       //"~/Content/morris.css",
                       "~/Content/sb-admin-2.css",
                       "~/Content/site.css"
            ));
        }
    }
}
