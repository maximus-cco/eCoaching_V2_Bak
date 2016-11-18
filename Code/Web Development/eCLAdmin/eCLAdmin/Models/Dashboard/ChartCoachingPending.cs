using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace eCLAdmin.Models.Dashboard
{
    public class ChartCoachingPending : ChartBase
    {
        // Pending Acknowledgement
        public int a { get; set; }
        // Pending Employee Review
        public int b { get; set; }
        // Pending Manager Review
        public int c { get; set; }
        // Pending Sr. Manager Review
        public int d { get; set; }
        // Pending Supervisor Review
        public int e { get; set; }
    }
}