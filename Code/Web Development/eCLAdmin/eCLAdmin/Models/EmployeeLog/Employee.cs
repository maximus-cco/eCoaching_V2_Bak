namespace eCLAdmin.Models.EmployeeLog
{
    public class Employee
    {
        public bool IsSubcontractor { get; set; }
        public string Id { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string SupervisorName { get; set; }
        public string SupervisorEmail { get; set; }
        public string ManagerName { get; set; }
        public string ManagerEmail { get; set; }
        public int SiteId { get; set; }
        public string SiteName { get; set; }

        public bool IsCco
        {
            get
            {
                return !IsSubcontractor;
            }
        }

        public Employee()
        { }

        public Employee(string id, string name)
        {
            Id = id;
            Name = name;
        }

        public Employee(string id, string name, int siteId, string siteName, bool isSubcontractor)
        {
            Id = id;
            Name = name;
            SiteId = siteId;
            SiteName = siteName;
            IsSubcontractor = isSubcontractor;
        }
    }
}