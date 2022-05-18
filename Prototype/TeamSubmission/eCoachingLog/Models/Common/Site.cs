using System.Collections.Generic;
using System.Web.Mvc;

namespace eCoachingLog.Models.Common
{
    public class Site
    {
        public int Id { get; set; }
        public string Name { get; set; }

        public List<SelectListItem> Tests { get; set; }
    }
}