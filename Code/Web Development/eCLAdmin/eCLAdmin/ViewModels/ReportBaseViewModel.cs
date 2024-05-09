using System;
using System.Collections.Generic;
using System.Web.Mvc;

namespace eCLAdmin.ViewModels
{
    public class ReportBaseViewModel
    {
        public int PageSize { get; set; }
        public int RowStartIndex { get; set; }

        public string StartDate { get; set; }
        public string EndDate { get; set; }
        [AllowHtml]
        public string FreeTextSearch { get; set; }

        public string HireDate{ get; set; }

        public IEnumerable<SelectListItem> LogTypeSelectList { get; set; }
        public IEnumerable<SelectListItem> ActionSelectList { get; set; }
        public IEnumerable<SelectListItem> LogNameSelectList { get; set; }
        public int SelectedTypeId { get; set; }
        public string SelectedAction { get; set; }
        public string SelectedLog { get; set; }

        public IEnumerable<SelectListItem> SiteSelectList { get; set; }
        public IEnumerable<SelectListItem> EmployeeSelectList { get; set; }
        public string SelectedSite { get; set; }
        public string SelectedEmployee { get; set; }

        public IEnumerable<SelectListItem> EmployeeLevelSelectList { get; set; }
        //public IEnumerable<SelectListItem> EmployeeSelectList { get; set; }
        public IEnumerable<SelectListItem> CoachingReasonSelectList { get; set; }
        public IEnumerable<SelectListItem> CoachingSubReasonSelectList { get; set; }
        public IEnumerable<SelectListItem> LogStatusSelectList { get; set; }
        public string SelectedEmployeeLevel { get; set; }
        public string SelectedCoachingReason { get; set; }
        public string SelectedCoachingSubReason { get; set; }
        public string SelectedLogStatus { get; set; }

        public ReportBaseViewModel()
        {
            this.PageSize = 100;

            //this.StartDate = DateTime.Now.AddDays(-30).ToString("MM/dd/yyyy");
            //this.EndDate = DateTime.Now.ToString("MM/dd/yyyy");
            this.LogTypeSelectList = new List<SelectListItem>();
            this.ActionSelectList = new List<SelectListItem>();
            this.LogNameSelectList = new List<SelectListItem>();
            this.SiteSelectList = new List<SelectListItem>();
            this.EmployeeSelectList = new List<SelectListItem>();
            this.EmployeeLevelSelectList = new List<SelectListItem>();
            this.CoachingReasonSelectList = new List<SelectListItem>();
            this.CoachingSubReasonSelectList = new List<SelectListItem>();
            this.LogStatusSelectList = new List<SelectListItem>();
        } 
    }
}