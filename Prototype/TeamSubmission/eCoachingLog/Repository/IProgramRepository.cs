using eCoachingLog.Models.Common;
using System.Collections.Generic;

namespace eCoachingLog.Repository
{
	interface IProgramRepository
    {
        IList<Program> GetPrograms(int moduleId);
    }
}
