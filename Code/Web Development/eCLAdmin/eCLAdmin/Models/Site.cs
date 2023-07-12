namespace eCLAdmin.Models
{
    public class Site
    {
        public string Id { get; set; }
        public string Name { get; set; }

        public Site() { }
        public Site(string id, string name)
        {
            this.Id = id;
            this.Name = name;
        }
    }
}