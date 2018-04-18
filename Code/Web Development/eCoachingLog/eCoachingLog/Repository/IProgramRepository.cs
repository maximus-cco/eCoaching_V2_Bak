using eCoachingLog.Models.Common;
using System.Collections.Generic;

namespace eCoachingLog.Repository
{
	interface IProgramRepository
    {
        List<Program> GetAllPrograms();
        List<Program> GetPrograms(int moduleId);
    }
}
