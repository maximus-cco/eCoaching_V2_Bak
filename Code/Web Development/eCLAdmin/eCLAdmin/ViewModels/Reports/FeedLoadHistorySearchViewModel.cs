using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace eCLAdmin.ViewModels.Reports
{
    public class FeedLoadHistorySearchViewModel : ReportBaseViewModel
    {
        public IEnumerable<SelectListItem> CategorySelectList { get; set; }
        public IEnumerable<SelectListItem> ReportCodeSelectList { get; set; }

        public int SelectedCategory { get; set; }
        public int SelectedReportCode { get; set; }

        public FeedLoadHistorySearchViewModel() : base()
        {
            this.CategorySelectList = new List<SelectListItem>();
            this.ReportCodeSelectList = new List<SelectListItem>();
        }
    }
}