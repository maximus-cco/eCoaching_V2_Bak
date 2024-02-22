namespace eCoachingLog.Models.Common
{
    public class TextValue
    {
        public bool IsSelected { get; set; }
        public string Text { get; set; }
        public string Value { get; set; }
        public string Data { get; set; }

        public TextValue(string text, string value)
        {
            this.Text = text;
            this.Value = value;
        }

        public TextValue(string text, string value, string data)
        {
            this.Text = text;
            this.Value = value;
            this.Data = data;
        }
    }
}