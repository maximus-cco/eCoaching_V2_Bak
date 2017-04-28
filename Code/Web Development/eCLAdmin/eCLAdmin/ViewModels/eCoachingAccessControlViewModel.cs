using eCLAdmin.Models.User;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace eCLAdmin.ViewModels
{
    public class eCoachingAccessControlViewModel
    {
        public int RowId { get; set; }

        [Display(Name = "LanID:")]
        [Required(ErrorMessage = "LanID is required.")]
        [AllowHtml]
        public string LanId { get; set; }

        [Display(Name = "Name:")]
        [Required(ErrorMessage = "Name is required.")]
        [AllowHtml]
        public string Name { get; set; }

        [Display(Name = "Role:")]
        [Required(ErrorMessage = "Role is required.")]
        [AllowHtml]
        public string Role { get; set; }

        public IEnumerable<SelectListItem> RoleList { get; set; }

        public string UpdatedBy { get; set; }


        public static implicit operator eCoachingAccessControl(eCoachingAccessControlViewModel userVM)
        {
            return new eCoachingAccessControl
            {
                RowId = userVM.RowId,
                LanId = userVM.LanId,
                Name = userVM.Name,
                Role = userVM.Role,
                UpdatedBy = userVM.UpdatedBy
            };
        }

        public static implicit operator eCoachingAccessControlViewModel(eCoachingAccessControl user)
        {
            return new eCoachingAccessControlViewModel
            {
                RowId = user.RowId,
                LanId = user.LanId,
                Name = user.Name,
                Role = user.Role,
                UpdatedBy = user.UpdatedBy
            };
        }
    }
}