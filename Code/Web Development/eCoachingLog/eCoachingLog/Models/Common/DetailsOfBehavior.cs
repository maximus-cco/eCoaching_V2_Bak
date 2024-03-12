namespace eCoachingLog.Models.Common
{
    public class DetailsOfBehavior
    {
        public string Behavior { get; set; } // txtDescription
        public string Medal { get; set; }
        public string Heating { get; set; }

        public bool IsGold { get; set; }
        public bool IsSilver { get; set; }
        public bool IsBronze { get; set; }
        public bool IsHonorMention { get; set; }
        public bool IsHeat { get; set; }

        public DetailsOfBehavior()
        {

        }

        public DetailsOfBehavior(string behavior, bool isGold, bool isSilver, bool isBronze, bool isHonorMention, bool isHeat)
        {
            this.Behavior = behavior;
            this.IsGold = isGold;
            this.IsSilver = isSilver;
            this.IsBronze = isBronze;
            this.IsHonorMention = isHonorMention;
            this.IsHeat = isHeat;
        }
    }
}