using eCLAdmin.Models.Dashboard;
using System.Collections.Generic;

namespace eCLAdmin.ViewModels
{
    public class DashboardGraphViewModel
    {
        public IEnumerable<ChartCoachingCompleted> CoachingCompleted { get; set; }

        public IEnumerable<ChartCoachingPending> CoachingPending { get; set; }
        public IEnumerable<ChartWarningActive> WarningActive { get; set; }
    }
}