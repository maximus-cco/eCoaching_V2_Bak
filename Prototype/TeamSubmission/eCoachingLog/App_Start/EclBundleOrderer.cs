using System.Collections.Generic;
using System.Web.Optimization;

namespace eCoachingLog.App_Start
{
    public class EclBundleOrderer : IBundleOrderer
    {
        public virtual IEnumerable<BundleFile> OrderFiles(BundleContext context, IEnumerable<BundleFile> files)
        {
            return files;
        }
    }
}