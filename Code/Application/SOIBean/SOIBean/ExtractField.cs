using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SOIBean
{
    class ExtractField
    {
        public ExtractField()
        {
            // initialize our booleans
            CanUpdate = false;
            AlwaysUpdate = false;
            IsSPKey = false;
            IsSPUnique = false;
            LookupId = false;
        }

        public string ColumnName { get; set; }
        public string KeyName { get; set; }
        public bool CanUpdate { get; set; }
        public bool AlwaysUpdate { get; set; }
        public bool IsSPKey { get; set; }
        public bool IsSPUnique { get; set; }
        public bool LookupId { get; set; }

        /// <summary>
        /// Optional - Default value to use if field value is null.
        /// </summary>
        public string Default { get; set; }

        /// <summary>
        /// Does the field have a default value specified?
        /// </summary>
        /// <returns>True if default value exists; false otherwise.</returns>
        public bool HasDefault()
        {
            return !string.IsNullOrEmpty(Default);
        }
    }
}
