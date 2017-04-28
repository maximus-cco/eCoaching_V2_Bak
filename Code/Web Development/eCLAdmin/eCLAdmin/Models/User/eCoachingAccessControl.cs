using eCLAdmin.ViewModels;

namespace eCLAdmin.Models.User
{
    public class eCoachingAccessControl
    {
        public int RowId { get; set; }
        public string LanId { get; set; }
        public string Name { get; set; }
        public string Role { get; set; }
        public string End_Date { get; set; }
        public string UpdatedBy { get; set; }
    }
}