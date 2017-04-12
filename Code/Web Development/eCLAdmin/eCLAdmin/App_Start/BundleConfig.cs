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
                        "~/Scripts/jquery.validate.js",
                        "~/Scripts/jquery.validate.unobtrusive.js",
                        "~/Scripts/jquery.unobtrusive-ajax.js",
                        "~/Scripts/jquery.dataTables.js",
                        "~/Scripts/bootstrap.js",
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

            // css across web app
            bundles.Add(new StyleBundle("~/Content/css").Include(
                       "~/Content/*.css"));
        }
    }
}
