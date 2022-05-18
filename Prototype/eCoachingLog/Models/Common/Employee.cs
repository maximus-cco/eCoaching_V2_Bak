namespace eCoachingLog.Models.Common
{
    public class Employee
    {
        public string Id { get; set; }
        public string LanId { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string SupervisorId { get; set; }
        public string SupervisorName { get; set; }
        public string SupervisorLanId { get; set; }
        public string SupervisorJobDesc { get; set; }
        public string SupervisorEmail { get; set; }
        public string ManagerId { get; set; }
        public string ManagerName { get; set; }
        public string ManagerLanId { get; set; }
        public string ManagerJobDesc { get; set; }
        public string ManagerEmail { get; set; }

        //// used to send email (one log per employee)
        //public string LogName { get; set; }
    }
}