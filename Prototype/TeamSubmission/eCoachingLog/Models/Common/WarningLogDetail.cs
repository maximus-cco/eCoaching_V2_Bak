namespace eCoachingLog.Models.Common
{
	public class WarningLogDetail : BaseLogDetail
    {
		public int ModuleId { get; set; }
		public string ModuleName { get; set; }
		public bool IsFormalAttendanceTrends { get; set; }
		public bool IsFormalAttendanceHours { get; set; }
    }
}