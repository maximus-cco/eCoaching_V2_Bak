namespace eCoachingLog.Models.Common
{
	public class WarningLogDetail : BaseLogDetail
    {
		public string ModuleName { get; set; }
		public bool IsFormalAttendanceTrends { get; set; }
		public bool IsFormalAttendanceHours { get; set; }
    }
}