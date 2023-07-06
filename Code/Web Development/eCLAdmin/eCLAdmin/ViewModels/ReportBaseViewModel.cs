using System;
using System.Collections.Generic;
using System.Web.Mvc;

namespace eCLAdmin.ViewModels
{
    public class BaseViewModel
    {
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string FreeTextSearch { get; set; }
        public IEnumerable<SelectListItem> LogTypeSelectList { get; set; }
        public IEnumerable<SelectListItem> ActionSelectList { get; set; }
        public IEnumerable<SelectListItem> LogNameSelectList { get; set; }

        public int SelectedTypeId { get; set; }
        public string SelectedAction { get; set; }
        public string SelectedLog { get; set; }

        public int PageSize { get; set; }

        public BaseViewModel()
        {
            this.StartDate = DateTime.Now.AddDays(-30).ToString("MM/dd/yyyy");
            this.EndDate = DateTime.Now.ToString("MM/dd/yyyy");
            this.LogTypeSelectList = new List<SelectListItem>();
            this.ActionSelectList = new List<SelectListItem>();
            this.LogNameSelectList = new List<SelectListItem>();
            this.PageSize = 25;
        } 
    }
}