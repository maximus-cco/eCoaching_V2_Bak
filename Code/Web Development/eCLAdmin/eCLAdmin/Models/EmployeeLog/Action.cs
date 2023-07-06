namespace eCLAdmin.Models.EmployeeLog
{
    public class Action
    {
        public int Id { get; set; }
        public string Description { get; set; }

        public Action() { }
        public Action(int id, string description)
        {
            Id = id;
            Description = description;
        }
    }
}