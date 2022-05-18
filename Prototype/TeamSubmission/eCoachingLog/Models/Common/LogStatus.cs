namespace eCoachingLog.Models.Common
{
    public class LogStatus
    {
        public int Id { get; set; } 
        public string Description { get; set; }

        public LogStatus()
        {
        }

        public LogStatus(int id, string description)
        {
            this.Id = id;
            this.Description = description;
        }
    }
}