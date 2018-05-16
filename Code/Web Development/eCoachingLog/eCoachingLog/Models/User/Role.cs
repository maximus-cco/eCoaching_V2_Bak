namespace eCoachingLog.Models.User
{
    public class Role
    {
        public int Id { get; set; }
        public string Name { get; set; }

        public Role()
        {
            Id = -1;
            Name = "";
        }
    }
}