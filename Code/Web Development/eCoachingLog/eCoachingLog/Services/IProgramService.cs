using eCoachingLog.Models.Common;
using System.Collections.Generic;

namespace eCoachingLog.Services
{
	public interface IProgramService
    {
        IList<Program> GetPrograms(int moduleId);
    }
}
