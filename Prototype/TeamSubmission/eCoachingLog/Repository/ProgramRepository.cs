using eCoachingLog.Models.Common;
using eCoachingLog.Utils;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace eCoachingLog.Repository
{
	public class ProgramRepository : IProgramRepository
    {
        // Create a base repository class and move this to the base class
        string conn = System.Configuration.ConfigurationManager.ConnectionStrings["dbConnectionString"].ConnectionString;

        public IList<Program> GetPrograms(int moduleId)
        {
            List<Program> programs = new List<Program>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Programs]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValue("@intModuleIDin", moduleId);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        Program program = new Program();
						program.Id = (int)dataReader["ProgramID"];
                        program.Name = dataReader["Program"].ToString();
                        programs.Add(program);
                    } // end while
                } // end using SqlDataReader
            } // end using SqlCommand

            return programs;
        }
    }
}