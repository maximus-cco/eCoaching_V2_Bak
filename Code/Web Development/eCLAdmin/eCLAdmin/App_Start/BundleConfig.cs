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
                        "~/Scripts/jquery.unobtrusive-ajax.js",
                        "~/Scripts/jquery.dataTables.js",
                        "~/Scripts/bootstrap.js",
                        "~/Scripts/dataTables.bootstrap.js",
                        "~/Scripts/respond.js",
                        "~/Scripts/raphael.js",
                        "~/Scripts/eCLAdmin/layout.js");
            bundles.Add(scriptBundle);

            // css across web app
            bundles.Add(new StyleBundle("~/Content/css").Include(
                       "~/Content/*.css"));
        }
    }
}
