using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace eCLAdmin.Models.Dashboard
{
    public class ChartCoachingCompleted : ChartBase
    {
        // Did not meet goal
        public int a { get; set; }
        // Met goal
        public int b { get; set; }
        // Opportunity
        public int c { get; set; }
        // Reinforcement
        public int d { get; set; }
    }
}