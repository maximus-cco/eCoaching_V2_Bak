﻿using eCoachingLog.Utils;
using System;

namespace eCoachingLog.Models.User
{
    public class User
    {
        public string EmployeeId { get; set; }
        public string LanId { get; set; }
        public string Name { get; set; }
        public string JobCode { get; set; }
        public string Role { get; set; }
        public int SiteId { get; set; }
        public string SiteName { get; set; }
        public bool IsSubcontractor { get; set; }
        public bool IsCsrRelated { get; set; } // Indicates whether this user is a CSR's/ISG's supervisor, managager, etc.
        public bool IsProductionPlanningRelated { get; set; } // Indicates whether this user is a Production Planning employee's supervisor, managager, etc.
        public bool IsEcl { get; set; }        // Be able to view all logs on Historical Dashboard
        public bool IsPm { get; set; }         // Be able to view subcontractor logs
        public bool IsPma { get; set; }        // Be able to view subcontractor logs + submit subcontractor logs 
        public bool IsDirPm { get; set; }      // Be able to view subcontractor logs
        public bool IsDirPma { get; set; }     // Be able to view subcontractor logs + submit subcontractor logs
        public bool IsQam { get; set; } 
        public bool IsAccessNewSubmission { get; set; } // Whether the user is allowed to access New Submission page
        public bool IsAccessMyDashboard { get; set; }   // Whether the user is allowed to access My Dashboard page
        public bool IsAccessHistoricalDashboard { get; set; } // Whether the user is allowed to access Historical Dashboard page
        public bool IsExportExcel { get; set; } // Whether the user is allowed to export data to excel on Historical Dashboard page
        public bool ShowFollowup // Whether to display follow up information on dashboards
        {
            get
            {
                return this.IsSupervisor;
            }
            set
            {
                // todo:
            }
        }

        public bool IsAnalyst
        {
            get
            {
                return string.Equals(this.Role, Constants.USER_ROLE_ANALYST, StringComparison.OrdinalIgnoreCase);
            }
        }

        public bool IsArc
        {
            get
            {
                return string.Equals(this.Role, Constants.USER_ROLE_ARC, StringComparison.OrdinalIgnoreCase);
            }
        }

        public bool IsIsg
        {
            get
            {
                return string.Equals(this.Role, Constants.USER_ROLE_ISG, StringComparison.OrdinalIgnoreCase);
            }
        }

        public bool IsCsr
        {
            get
            {
                return string.Equals(this.Role, Constants.USER_ROLE_CSR, StringComparison.OrdinalIgnoreCase);
            }
        }

        public bool IsEmployee
        {
            get
            {
                return string.Equals(this.Role, Constants.USER_ROLE_EMPLOYEE, StringComparison.OrdinalIgnoreCase);
            }
        }

        public bool IsSupervisor
        {
            get
            {
                return string.Equals(this.Role, Constants.USER_ROLE_SUPERVISOR, StringComparison.OrdinalIgnoreCase);
            }
        }

        public bool IsManager
        {
            get
            {
                return string.Equals(this.Role, Constants.USER_ROLE_MANAGER, StringComparison.OrdinalIgnoreCase);
            }
        }

        public bool IsDirector
        {
            get
            {
                return string.Equals(this.Role, Constants.USER_ROLE_DIRECTOR, StringComparison.OrdinalIgnoreCase);
            }
        }

        public bool IsHr
        {
            get
            {
                return string.Equals(this.Role, Constants.USER_ROLE_HR, StringComparison.OrdinalIgnoreCase);
            }
        }

        public User()
        {
            this.EmployeeId = "-1";
            this.LanId = string.Empty;
            this.Name = string.Empty;
            this.JobCode = string.Empty;
            this.Role = string.Empty;
            this.IsSubcontractor = false;
            this.IsEcl = false;
            this.IsAccessNewSubmission = false;
            this.IsAccessMyDashboard = false;
            this.IsAccessHistoricalDashboard = false;
            this.IsExportExcel = false;
            this.ShowFollowup = false;
        }
    }
}