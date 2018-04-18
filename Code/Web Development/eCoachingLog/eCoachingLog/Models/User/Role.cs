using System.Collections.Generic;

namespace eCoachingLog.Models.User
{
    public class Role
    {
        public int Id { get; set; }
        public string Name { get; set; }
        //public List<Entitlement> Entitlements = new List<Entitlement>();

        public Role()
        {
            Id = -1;
            Name = "";
            //Entitlements = new List<Entitlement>();
        }
    }
}