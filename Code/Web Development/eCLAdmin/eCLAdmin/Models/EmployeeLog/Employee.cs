namespace eCLAdmin.Models.EmployeeLog
{
    public class Employee
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string SupervisorName { get; set; }
        public string SupervisorEmail { get; set; }
        public string ManagerName { get; set; }
        public string ManagerEmail { get; set; }
    }
}