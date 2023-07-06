namespace eCLAdmin.Models.Report
{
    public class AdminActivity
    {
        // report columns
        public int ModuleId { get; set; } // Employee Level ID
        public string ModuleName { get; set; } // Employee Level
        public string LogName { get; set; } // Form Name
        public string LastKnownStatus { get; set; } // Last Known Status
        public string Action { get; set; } // Action
        public string ActionDate { get; set; } // Action Date
        public string RequesterId { get; set; } // Requester ID
        public string RequesterName { get; set; } // Requester Name
        public string AssignedToId { get; set; } // Assigned To ID
        public string AssignedToName { get; set; } // Assigned To Name
        public string Reason { get; set; } // Reason
        public string RequesterComments { get; set; } // Requester Comments
    }
}
