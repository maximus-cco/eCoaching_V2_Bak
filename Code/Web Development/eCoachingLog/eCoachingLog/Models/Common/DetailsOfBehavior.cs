namespace eCoachingLog.Models.Common
{
    public class DetailsOfBehavior
    {
        public string Behavior { get; set; } // txtDescription
        public string Medal { get; set; }
        public string Heating { get; set; }

        // medals
        public bool IsGold { get; set; }
        public bool IsSilver { get; set; }
        public bool IsBronze { get; set; }
        public bool IsHonorMention { get; set; }
        // badges (heating)
        public bool IsActiveListening { get; set; }
        public bool IsBusinessProcess { get; set; }
        public bool IsCallEfficiency { get; set; }
        public bool IsInfoAccuracy { get; set; }
        public bool IsIssueResolution { get; set; }
        public bool IsPersonailityFlexing { get; set; }
        public bool IsPrivacyDisclaimers { get; set; }

        public DetailsOfBehavior()
        {

        }

        public DetailsOfBehavior(
            string behavior, 
            // medals
            bool isGold, 
            bool isSilver, 
            bool isBronze, 
            bool isHonorMention, 
            // badges (heating)
            bool isActiveListening, 
            bool isBusinessProcess, 
            bool isCallEfficiency, 
            bool isInfoAccuracy, 
            bool isIssueResolution,
            bool isPersonailityFlexing, 
            bool isPrivacyDisclaimers)
        {
            Behavior = behavior;
            IsGold = isGold;
            IsSilver = isSilver;
            IsBronze = isBronze;
            IsHonorMention = isHonorMention;
            IsActiveListening = isActiveListening;
            IsBusinessProcess = isBusinessProcess;
            IsCallEfficiency = isCallEfficiency;
            IsInfoAccuracy = isInfoAccuracy;
            IsIssueResolution = isIssueResolution;
            IsPersonailityFlexing = isPersonailityFlexing;
            IsPrivacyDisclaimers = isPrivacyDisclaimers;
        }
    }
}