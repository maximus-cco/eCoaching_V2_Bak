using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace eCoachingLog.Models.User
{
    public class User
    {
        public string EmployeeId { get; set; }
        public string LanId { get; set; }
        public string Name { get; set; }
        public string JobCode { get; set; }
        public UserRole Role{get; set;}
        public List<Entitlement> Entitlements { get; set; }

        public bool IsInRole(UserRole role)
        {
            return this.Role == role;
        }

        public User()
        {
            EmployeeId = "-1";
            LanId = "";
            Name = "";
            JobCode = "";
           // Roles = new List<Role>();
            Entitlements = new List<Entitlement>();
        }

        public User(string name)
        {
            this.Name = name;
        }

        public User(string employeeId, string lanId, string name, string jobCode)
        {
            this.EmployeeId = employeeId;
            this.LanId = lanId;
            this.Name = name;
            this.JobCode = jobCode;
        }
    }
}