using System.Collections.Generic;
using System.Web.Mvc;

namespace eCLAdmin.ViewModels.Reports
{
    public class WarningSearchViewModel : ReportBaseViewModel
    {
        public IEnumerable<SelectListItem> WarningReasonSelectList { get; set; }
        public IEnumerable<SelectListItem> WarningSubReasonSelectList { get; set; }
        public IEnumerable<SelectListItem> LogStateSelectList { get; set; }
        public string SelectedWarningReason { get; set; }
        public string SelectedWarningSubReason { get; set; }
        public string SelectedLogState { get; set; }
    }
}