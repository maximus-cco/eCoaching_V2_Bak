namespace eCoachingLog.Models.User
{
    public class User
    {
        public string EmployeeId { get; set; }
        public string LanId { get; set; }
        public string Name { get; set; }
        public string Role { get; set;}
		// Whether the user is allowed to access New Submission page
		public bool IsAccessNewSubmission { get; set; }
		// Whether the user is allowed to access My Dashboard page
		public bool IsAccessMyDashboard { get; set; }
		// Whether the user is allowed to access Historical Dashboard page
		public bool IsAccessHistoricalDashboard { get; set; }
		// Whether the user is allowed to export data to excel on Historical Dashboard page
		public bool IsExportExcel { get; set; }

        public User()
        {
            this.EmployeeId = "-1";
			this.LanId = string.Empty;
			this.Name = string.Empty;
			this.Role = string.Empty;
			this.IsAccessNewSubmission = false;
			this.IsAccessMyDashboard = false;
			this.IsAccessHistoricalDashboard = false;
			this.IsExportExcel = false;
        }
    }
}