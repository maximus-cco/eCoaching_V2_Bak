using System;

namespace eCoachingLog.Models.Common
{
    public class Site : ICloneable
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public bool IsSubcontractorSite { get; set; }

        // deep copy
        public object Clone()
        {
            return new Site
            {
                Id = Id,
                Name = Name,
                IsSubcontractorSite = IsSubcontractorSite
            };
        }
    }
}