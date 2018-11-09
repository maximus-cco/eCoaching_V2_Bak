using eCLAdmin.App_Start;
using System.Web.Optimization;

namespace eCLAdmin
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
                         "~/Scripts/select2.js",
                        "~/Scripts/jquery.validate.js",
                        "~/Scripts/jquery.validate.unobtrusive.js",
                        "~/Scripts/jquery.unobtrusive-ajax.js",
                        "~/Scripts/jquery.dataTables.js",
						"~/Scripts/moment.js",
						"~/Scripts/bootstrap.js",
						"~/Scripts/bootstrap-datetimepicker.js",
						"~/Scripts/dataTables.bootstrap.js",
                        "~/Scripts/respond.js",
                        "~/Scripts/raphael.js",
                        "~/Scripts/eCLAdmin/layout.js");
            bundles.Add(scriptBundle);

            // javascript bundle for dashboard index 
            var dashboardIndexScriptBundle = new ScriptBundle("~/bundles/scripts/dashboardIndex");
            dashboardIndexScriptBundle.Orderer = new EclBundleOrderer();
            dashboardIndexScriptBundle.Include(
                        "~/Scripts/morris.js",
						"~/Scripts/eCLAdmin/dashboardIndex.js");
            bundles.Add(dashboardIndexScriptBundle);

            // javascript bundle for dashboard chart
            var dashboardChartScriptBundle = new ScriptBundle("~/bundles/scripts/dashboardChart");
            dashboardChartScriptBundle.Orderer = new EclBundleOrderer();
            dashboardChartScriptBundle.Include(
                        "~/Scripts/eCLAdmin/dashboardChart.js");
            bundles.Add(dashboardChartScriptBundle);

            // javascript bundle for dashboard
            var dashboardScriptBundle = new ScriptBundle("~/bundles/scripts/dashboard");
            dashboardScriptBundle.Orderer = new EclBundleOrderer();
            dashboardScriptBundle.Include(
                        "~/Scripts/eCLAdmin/dashboard.js");
            bundles.Add(dashboardScriptBundle);

            // javascript bundle for dashboard list
            var dashboardListScriptBundle = new ScriptBundle("~/bundles/scripts/dashboardList");
            dashboardListScriptBundle.Orderer = new EclBundleOrderer();
            dashboardListScriptBundle.Include(
                        "~/Scripts/eCLAdmin/dashboardList.js");
            bundles.Add(dashboardListScriptBundle);

            // javascript bundle for 'log search for delete'
            var logSearchForDeleteScriptBundle = new ScriptBundle("~/bundles/scripts/logSearchForDelete");
            logSearchForDeleteScriptBundle.Orderer = new EclBundleOrderer();
            logSearchForDeleteScriptBundle.Include(
                        "~/Scripts/eCLAdmin/logSearchForDelete.js");
            bundles.Add(logSearchForDeleteScriptBundle);

            // javascript bundle for 'log delete'
            var logDeleteScriptBundle = new ScriptBundle("~/bundles/scripts/logDelete");
            logDeleteScriptBundle.Orderer = new EclBundleOrderer();
            logDeleteScriptBundle.Include(
                        "~/Scripts/eCLAdmin/logDelete.js");
            bundles.Add(logDeleteScriptBundle);

            // javascript bundle for eCoaching Access Control list
            var eCoachingAccessControlListScriptBundle = new ScriptBundle("~/bundles/scripts/eCoachingAccessControlList");
            eCoachingAccessControlListScriptBundle.Orderer = new EclBundleOrderer();
            eCoachingAccessControlListScriptBundle.Include(
                        "~/Scripts/eCLAdmin/eCoachingAccessControlList.js");
            bundles.Add(eCoachingAccessControlListScriptBundle);

            // javascript bundle for eCoaching Access Control delete
            var eCoachingAccessControlDeleteScriptBundle = new ScriptBundle("~/bundles/scripts/eCoachingAccessControlDelete");
            eCoachingAccessControlDeleteScriptBundle.Orderer = new EclBundleOrderer();
            eCoachingAccessControlDeleteScriptBundle.Include(
                        "~/Scripts/eCLAdmin/eCoachingAccessControlDelete.js");
            bundles.Add(eCoachingAccessControlDeleteScriptBundle);

            // javascript bundle for eCoaching Access Control update
            var eCoachingAccessControlUpdateScriptBundle = new ScriptBundle("~/bundles/scripts/eCoachingAccessControlUpdate");
            eCoachingAccessControlUpdateScriptBundle.Orderer = new EclBundleOrderer();
            eCoachingAccessControlUpdateScriptBundle.Include(
                        "~/Scripts/eCLAdmin/eCoachingAccessControlUpdate.js");
            bundles.Add(eCoachingAccessControlUpdateScriptBundle);

            // javascript bundle for eCoaching Access Control add
            var eCoachingAccessControlAddScriptBundle = new ScriptBundle("~/bundles/scripts/eCoachingAccessControlAdd");
            eCoachingAccessControlAddScriptBundle.Orderer = new EclBundleOrderer();
            eCoachingAccessControlAddScriptBundle.Include(
                        "~/Scripts/eCLAdmin/eCoachingAccessControlAdd.js");
            bundles.Add(eCoachingAccessControlAddScriptBundle);

			// javascript bundle for ecl site usage
			var eclSiteUsageScriptBundle = new ScriptBundle("~/bundles/scripts/eclSiteUsage");
			eclSiteUsageScriptBundle.Orderer = new EclBundleOrderer();
			eclSiteUsageScriptBundle.Include(
						"~/Scripts/eCLAdmin/eclSiteUsage.js",
						"~/Scripts/eCLAdmin/dateTimePicker.js");
			bundles.Add(eclSiteUsageScriptBundle);
			// javascript bundle for ecl site usage chart
			var eclSiteUsageChartScriptBundle = new ScriptBundle("~/bundles/scripts/eclSiteUsageChart");
			eclSiteUsageChartScriptBundle.Orderer = new EclBundleOrderer();
			eclSiteUsageChartScriptBundle.Include(
						"~/Scripts/morris.js",
						"~/Scripts/eCLAdmin/eclSiteUsageChart.js");
			bundles.Add(eclSiteUsageChartScriptBundle);

			// css across web app
			bundles.Add(new StyleBundle("~/Content/css").Include(
					   "~/Content/*.css"));
		}
    }
}
