using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace eCLAdmin.ViewModels
{
    public class DashboardIndexViewModel
    {
        private string selectedMonthYear;
        public string SelectedMonthYear
        {
            get
            {
                return DateTime.Now.ToString("MMMM yyyy");
            }
            set
            {
                selectedMonthYear = value;
            }
        }

        public IEnumerable<SelectListItem> Months
        {
            get
            {
                var now = DateTime.Now;
                var lastTwelveMonths = Enumerable.Range(0, 12).Select(i => now.AddMonths(-i).ToString("MMMM yyyy"));

                return lastTwelveMonths.Select(
                            month => new SelectListItem
                            {
                                Text = month,
                                Value = Convert.ToDateTime(month).ToString("MMM yyyy", System.Globalization.CultureInfo.InvariantCulture)
                            });
            }
        }

        public int TotalPendingCoachings { get; set; }
        public int TotalPendingWarnings { get; set; }
        public int TotalCompletedCoachings { get; set; }
        public DashboardGraphViewModel GraphViewModel { get; set; }
    }
}