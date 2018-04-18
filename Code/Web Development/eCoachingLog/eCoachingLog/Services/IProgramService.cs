using eCoachingLog.Models.Common;
using System.Collections.Generic;

namespace eCoachingLog.Services
{
	public interface IProgramService
    {
        List<Program> GetAllPrograms();
        List<Program> GetPrograms(int moduleId);
    }
}
