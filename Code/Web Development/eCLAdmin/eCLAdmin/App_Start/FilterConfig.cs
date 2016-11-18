using eCLAdmin.Filters;
using System.Web.Mvc;

namespace eCLAdmin
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new EclExceptionAttribute());
            filters.Add(new HandleErrorAttribute());
        }
    }
}
