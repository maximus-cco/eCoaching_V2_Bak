namespace eCLAdmin.Models.Common
{
    public class IdName
    {
        public int Id { get; set; }
        public string Name { get; set; }

        public IdName() { }
        public IdName(int id, string name)
        {
            this.Id = id;
            this.Name = name;
        }
    }
}