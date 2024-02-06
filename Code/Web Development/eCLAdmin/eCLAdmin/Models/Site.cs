namespace eCLAdmin.Models
{
    public class Site
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public bool IsSubcontractor { get; set; }

        public Site() { }
        public Site(string id, string name, bool isSubcontractor)
        {
            this.Id = id;
            this.Name = name;
            this.IsSubcontractor = isSubcontractor;
        }
    }
}