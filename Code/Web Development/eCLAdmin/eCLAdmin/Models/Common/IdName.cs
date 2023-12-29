namespace eCLAdmin.Models.Common
{
    public class IdName
    {
        public string Id { get; set; }
        public string Name { get; set; }

        public IdName() { }
        public IdName(string id, string name)
        {
            this.Id = id;
            this.Name = name;
        }
    }
}