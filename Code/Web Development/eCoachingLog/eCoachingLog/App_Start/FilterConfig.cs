using eCoachingLog.Filters;
using System.Web.Mvc;

namespace eCoachingLog
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            //filters.Add(new NoCacheAttribute());
            filters.Add(new EclExceptionAttribute());
            filters.Add(new HandleErrorAttribute());
        }
    }
}
