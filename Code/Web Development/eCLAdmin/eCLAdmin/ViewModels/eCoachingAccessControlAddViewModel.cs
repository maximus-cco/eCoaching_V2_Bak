using eCLAdmin.Models.User;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace eCLAdmin.ViewModels
{
    public class eCoachingAccessControlAddViewModel
    {
        public int RowId { get; set; }

        [Display(Name = "Name:")]
        [Required(ErrorMessage = "Name is required.")]
        [AllowHtml]
        public string LanId { get; set; }
        public string Name { get; set; }
        public IEnumerable<SelectListItem> NameList { get; set; }

        [Display(Name = "Role:")]
        [Required(ErrorMessage = "Role is required.")]
        [AllowHtml]
        public string Role { get; set; }
        //public IEnumerable<SelectListItem> RoleList { get; set; }

        [Display(Name = "Site:")]
        [Required(ErrorMessage = "Select a site.")]
        public int SiteId { get; set; }
        public IEnumerable<SelectListItem> SiteList { get; set; }

        public string UpdatedBy { get; set; }

        public static implicit operator eCoachingAccessControl(eCoachingAccessControlAddViewModel userVM)
        {
            return new eCoachingAccessControl
            {
                //RowId = userVM.RowId,
                LanId = userVM.LanId,
                Name = userVM.Name,
                Role = userVM.Role,
                UpdatedBy = userVM.UpdatedBy
            };
        }
    }
}