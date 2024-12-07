﻿namespace eCoachingLog.Models.Common
{
    public class Employee
    {
        public string Id { get; set; }
        public bool IsSubcontractor { get; set; }
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
        public string NamePlusSupervisorName
        {
            get
            {
                if (Id == "-2")
                {
                    return "-- Select an Employee --";
                }
                return Name + "(Supervisor: " + SupervisorName + ")";
            }
        }
    }
}