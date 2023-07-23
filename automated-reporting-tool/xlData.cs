using System.Data;
using System.Data.OleDb;

namespace WorkAutomation
{
    /*
     *
     *  xlData class
     *  Containes all the nessary members and methods to prase Excel Documents
     *
     */

    internal class xlData
    {
        private string _xlHDR;
        private string _xlFilePath;
        public string sheetname { get; set; }
        public string xlConnectionString { get; set; }
        public string folderpath { get; set; }
        public string xlDateColName { get; set; }

        public string xlHDR
        {
            get { return _xlHDR; }
            set
            {
                _xlHDR = value;
                setxlConnectionString();
            }
        }

        public string xlFilePath
        {
            get { return _xlFilePath; }
            set
            {
                _xlFilePath = value;
                setxlConnectionString();
            }
        }

        public void setxlConnectionString()
        {
            xlConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + xlFilePath + "; Extended Properties = \"Excel 12.0 Xml;HDR=YES\";";
        }

        public bool testxlConnection()
        {
            OleDbConnection conn = new OleDbConnection(xlConnectionString);
            try { conn.Open(); return true; } catch { return false; }
        }

        /*
         *  getxlData will pull the data from an excel file and load it into a datatable
         */

        public DataTable getxlData()
        {
            //Initilize Objects
            OleDbConnection conn = new OleDbConnection(xlConnectionString);
            OleDbCommand oconn = new OleDbCommand("Select * from [" + sheetname + "$]", conn);
            OleDbDataAdapter adp = new OleDbDataAdapter(oconn);
            DataTable dt = new DataTable();

            // Fill xlData into datatable and return it
            conn.Open();
            adp.Fill(dt);
            conn.Close();
            return dt;
        }

        /*
         *  getMindDate method will return the minimum date from the datatable
         */

        public string getMinDate(DataTable dt)
        {
            foreach (DataColumn y in dt.Columns)
            {
                int col = 0;
                if (y.ColumnName.ToString() == xlDateColName)
                {
                    DataRow[] dr = dt.Select("[" + xlDateColName + "] = MIN([" + xlDateColName + "])");
                    return dr[0][dt.Columns.IndexOf(xlDateColName)].ToString();
                };
                col = col + 1;
            }
            return "error";
        }

        /*
         *  getMaxDate will return the maximum date from the datatable
         */

        public string getMaxDate(DataTable dt)
        {
            foreach (DataColumn y in dt.Columns)
            {
                int col = 0;
                if (y.ColumnName.ToString() == xlDateColName)
                {
                    DataRow[] dr = dt.Select("[" + xlDateColName + "] = MAX([" + xlDateColName + "])");
                    return dr[0][dt.Columns.IndexOf(xlDateColName)].ToString();
                };
                col = col + 1;
            }
            return "error";
        }
    }
}