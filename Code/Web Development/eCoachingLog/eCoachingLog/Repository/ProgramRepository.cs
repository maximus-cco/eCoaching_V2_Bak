using eCoachingLog.Models.Common;
using eCoachingLog.Utils;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace eCoachingLog.Repository
{
	public class ProgramRepository : IProgramRepository
    {
        // Create a base repository class and move this to the base class
        string conn = System.Configuration.ConfigurationManager.ConnectionStrings["dbConnectionString"].ConnectionString;

        public List<Program> GetAllPrograms()
        {
            var programs = new List<Program>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("select distinct ProgramID, Program from ec.DIM_Program where isActive = 1 order by ProgramID", connection))
            {
                connection.Open();
                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        Program program = new Program();
                        program.Id = Convert.ToInt32(dataReader["ProgramID"]);
                        program.Name = dataReader["Program"].ToString();

                        programs.Add(program);
                    }
                }
            }

            return programs;
        }

        public List<Program> GetPrograms(int moduleId)
        {
            List<Program> programs = new List<Program>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Programs]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@intModuleIDin", moduleId);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    int i = 1;
                    while (dataReader.Read())
                    {
                        Program program = new Program();
                        program.Name = dataReader["Program"].ToString();
                        program.Id = eCoachingLogUtil.GetProgramIdByName(program.Name);

                        programs.Add(program);
                    } // end while
                } // end using SqlDataReader
            } // end using SqlCommand

            return programs;
        }
    }
}