using eCoachingLog.Models.Common;
using eCoachingLog.Repository;
using log4net;
using System.Collections.Generic;

namespace eCoachingLog.Services
{
	public class ProgramService : IProgramService
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        private IProgramRepository programRepository = new ProgramRepository();

        public IList<Program> GetPrograms(int moduleId)
        {
            return programRepository.GetPrograms(moduleId);
        }
    }
}