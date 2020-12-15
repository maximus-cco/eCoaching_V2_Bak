using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace SharePointToolBox
{
    public static class Helpers
    {
        // from EASE / ATT
        public static DataTable GetTableType(string connString, string table)
        {
            // need more error handling and logging here, at the row level and command level.
            using (SqlConnection conn = new SqlConnection(connString))
            {
                if (conn.State != ConnectionState.Open)
                    conn.Open();

                string queryString = String.Format(@"
--Create table variable from type.
DECLARE @Table AS {0}

--Create new permanent/physical table by selecting into from the temp table.
SELECT *
INTO #x
FROM @Table
WHERE 1 = 2

--Verify table exists and review structure.
SELECT *
FROM #x
", table);

                SqlDataAdapter adapter = new SqlDataAdapter(queryString, conn);
                adapter.MissingSchemaAction = MissingSchemaAction.AddWithKey; // Added to pull column lengths across

                DataSet results = new DataSet();
                adapter.Fill(results, table);

                var rt = results.Tables[0];

                return rt;
            }
        }
    }
}
