using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace eCLAdmin.Models.User
{
    public class User
    {
        public bool IsSubcontractor { get; set; }
        public bool IsSystemAdmin { get; set; }
        public bool IsSubcontractorAdmin { get; set; }
        public int SiteId { get; set; }

        [Display(Name = "ID")]
        public string EmployeeId { get; set; }

        [Display(Name = "User Lan ID")]
        public string LanId { get; set; }

        [Display(Name = "User Name")]
        public string Name { get; set; }

        [Display(Name = "Job Code")]
        public string JobCode { get; set; }

        public List<Role> Roles { get; set; }

        public List<Entitlement> Entitlements { get; set; }

        public bool IsCco
        {
            get
            {
                return !IsSubcontractor;
            }
        }

        public User()
        {
            EmployeeId = "-1";
            LanId = "";
            Name = "";
            JobCode = "";
            Roles = new List<Role>();
            Entitlements = new List<Entitlement>();
        }

        public User(string name)
        {
            Name = name;
        }

        public User(string employeeId, string lanId, string name, string jobCode)
        {
            EmployeeId = employeeId;
            LanId = lanId;
            Name = name;
            JobCode = jobCode;
        }
    }
}