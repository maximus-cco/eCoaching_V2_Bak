using eCoachingLog.Utils;
using System;

namespace eCoachingLog.Models.User
{
    public class User
    {
        public string EmployeeId { get; set; }
        public string LanId { get; set; }
        public string Name { get; set; }
		public string JobCode { get; set; }
        public string Role { get; set;}
		// Be able to view all logs on Historical Dashboard if true 
		public bool IsEcl { get; set; }
		// Whether the user is allowed to access New Submission page
		public bool IsAccessNewSubmission { get; set; }
		// Whether the user is allowed to access My Dashboard page
		public bool IsAccessMyDashboard { get; set; }
		// Whether the user is allowed to access Historical Dashboard page
		public bool IsAccessHistoricalDashboard { get; set; }
		// Whether the user is allowed to export data to excel on Historical Dashboard page
		public bool IsExportExcel { get; set; }
		// Whether to display follow up information on dashboards
		public bool ShowFollowup
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

        public string Title
        {
            get
            {
                if (this.IsCsr)
                {
                    return "CSR";
                }

                if (this.IsSupervisor)
                {
                    return "Supervisor";
                }

                return "";
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
			this.IsEcl = false;
			this.IsAccessNewSubmission = false;
			this.IsAccessMyDashboard = false;
			this.IsAccessHistoricalDashboard = false;
			this.IsExportExcel = false;
			this.ShowFollowup = false;
        }
    }
}