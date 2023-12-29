using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace eCLAdmin.Models.Report
{
    public class FeedLoadHistory
    {
        // report columns
        public string LoadDate { get; set; } 
        public string Category { get; set; } 
        public string Code { get; set; } 
        public string Description { get; set; }
        public string FileName { get; set; } 
        public int TotalStaged { get; set; } 
        public int TotalLoaded { get; set; } 
        public int TotalRejected { get; set; }
    }
}