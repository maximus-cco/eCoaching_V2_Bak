namespace eCoachingLog.Models.EmployeeLog
{
    public class Module
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public bool IsBySite { get; set; }
        public bool IsByBehavior { get; set; }
        public bool IsByProgram { get; set; }
    }
}