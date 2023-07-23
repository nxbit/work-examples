using System.Data;
using System.Data.SqlClient;

namespace WorkAutomation
{
    /*
     *
     *  sqlData class
     *  Contains all nessary parameters and methods for communicating
     *  with SQL Database
     *
     */

    internal class SqlData
    {
        // sqlData Members
        private string _sqlServerAddress;

        private string _sqlUserName;
        private string _sqlPassword;
        private string _sqlDatabase;
        public string sqlTableName;

        public string SqlConnectionString { get; set; }

        public string SqlServerAddress
        {
            get { return _sqlServerAddress; }
            set
            {
                _sqlServerAddress = value;
                SetSqlConnection();
            }
        }

        public string SqlUserName
        {
            get { return _sqlUserName; }
            set
            {
                _sqlUserName = value;
                SetSqlConnection();
            }
        }

        public string SqlPassword
        {
            get { return _sqlPassword; }
            set
            {
                _sqlPassword = value;
                SetSqlConnection();
            }
        }

        public string SqlDatabase
        {
            get { return _sqlDatabase; }
            set
            {
                _sqlDatabase = value;
                SetSqlConnection();
            }
        }

        /*
         *  Set SQL Connection method will update the sqlConnection string as approprate
         */

        public void SetSqlConnection()
        {
            SqlConnectionString = "Data Source=" + SqlServerAddress + ",1806" +
                ";Initial Catalog=" + SqlDatabase +
                ";User ID=" + SqlUserName +
                ";Password=" + SqlPassword + ";";
        }

        /*
         *  testsqlConnection method will test the sqlConnection by opening and closing a connection
         */

        public bool TestsqlConnection()
        {
            SqlConnection conn = new SqlConnection(SqlConnectionString);
            try { conn.Open(); conn.Close(); conn.Dispose(); return true; } catch { conn.Dispose(); return false; };
        }

        /*
         *  clearDateRange function will accept the nessary parameters to establish a delete string.
         */

        public bool ClearDateRange(string tableName, string xlDateCol, string startDate, string endDate)
        {
            string query = "DELETE FROM [" + tableName +
                "] WHERE [" + xlDateCol +
                "] >= '" + startDate +
                "' AND [" + xlDateCol +
                "] <= '" + endDate + "'";
            if (TestsqlConnection())
            {
                SqlConnection conn = new SqlConnection(SqlConnectionString);
                conn.Open();
                SqlCommand comm = new SqlCommand(query, conn);
                comm.ExecuteNonQuery();
                conn.Close();
                comm.Dispose();
                conn.Dispose();
                return true;
            }
            else { return false; }
        }

        /*
         *  upload Data will take a datatable and upload it to the nessary sqlTable.
         */

        public bool UploadData(string TableName, DataTable dt)
        {
            if (TestsqlConnection())
            {
                SqlConnection conn = new SqlConnection(SqlConnectionString);
                conn.Open();

                using (SqlBulkCopy BC = new SqlBulkCopy(conn))
                {
                    BC.DestinationTableName = "[dbo]" + ".[" + TableName+"]";
                    foreach (var column in dt.Columns)
                    {
                        BC.ColumnMappings.Add(column.ToString(), column.ToString());
                    }
                    BC.WriteToServer(dt);
                }
                conn.Close();
                return true;
            }
            else { return false; }
        }

        /*
         *  getupdateDate will query the sql server and return the max date as a string
         */

        public string GetupdateDate(string TableName, string DateColName)
        {
            SetSqlConnection();
            SqlConnection conn = new SqlConnection(SqlConnectionString);
            conn.Open();
            string query = "SELECT convert(varchar, MAX([" + DateColName + "]), 101) FROM [" + TableName + "]";
            using (SqlCommand comm = new SqlCommand(query, conn))
            {
                SqlDataReader reader = comm.ExecuteReader();
                while (reader.Read())
                {
                    return reader[0].ToString();
                }
                comm.Dispose();
                conn.Dispose();
                return reader[0].ToString();
            }
        }

        /*
         *  deteTable method will take a table name and execute a Delete command on that table
         */

        public void DeleteTable(string TableName)
        {
           // SetSqlConnection();
            string query = "DELETE FROM [" + TableName + "]";
            SqlConnection conn = new SqlConnection(SqlConnectionString);
            conn.Open();
            SqlCommand comm = new SqlCommand(query, conn);
            comm.ExecuteNonQuery();
            comm.Dispose();
            conn.Dispose();
        }

        /*
         *  getLatUpdateDate method will gather the last update date of a table
         */

        public string GetLastUpdateDate(string TableName)
        {
            SetSqlConnection();
            SqlConnection conn = new SqlConnection(SqlConnectionString);
            conn.Open();
            string query = @"SELECT max(last_user_update) FROM sys.dm_db_index_usage_stats WHERE object_id = OBJECT_ID('" + TableName + "')";
            using (SqlCommand comm = new SqlCommand(query, conn))
            {
                SqlDataReader reader = comm.ExecuteReader();
                while (reader.Read())
                {
                    return reader[0].ToString();
                }
                comm.Dispose();
                return reader[0].ToString();
            }
        }
    }
}