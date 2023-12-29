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

        public string SelectedCategory { get; set; }
        public string SelectedReportCode { get; set; }

        public FeedLoadHistorySearchViewModel() : base()
        {
            this.CategorySelectList = new List<SelectListItem>();
            this.ReportCodeSelectList = new List<SelectListItem>();
        }
    }
}