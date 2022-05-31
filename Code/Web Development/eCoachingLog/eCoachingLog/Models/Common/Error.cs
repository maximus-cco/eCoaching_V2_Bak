namespace eCoachingLog.Models.Common
{
    public class Error
    {
        public string Key { get; set; }
        public string Value { get; set; }

        public Error()
        {
        }

        public Error(string key, string value)
        {
            this.Key = key;
            this.Value = value;
        }
    }
}