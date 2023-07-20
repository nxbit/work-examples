using System;
using System.Data;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Web;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

/// <summary>
/// Summary description for KTool
/// </summary>
public class KTool
{

    //!!!!!!!!!!!!!!!!!!!!!!!!!!!! Paths, IPs, any anything identifiable has been hidden !!!!!!!!!!!!!!!!!!!!!!!!!!!! //

    
    /// <summary>
    /// String converstion of users SAM account
    /// </summary>
    public static string cUser;

    public string getUser()
    {
        return cUser;
    }


    public KTool()
    {
        cUser = HttpContext.Current.User.Identity.Name.Split('\\')[HttpContext.Current.User.Identity.Name.Split('\\').Length - 1];
    }

    
    /// <summary>
    /// sql Connection String used where KTool is used as a Connection
    /// </summary>
    public string sqlConnString = "<<CONNECTIONSTRING>>";

    
    
    public string sqlConnStringNew = "<<NEWDBCONNECTIONSTRING>>";

    public bool isGVPOps(string Q_Access)
    {
        if (Q_Access != "E000000" && Q_Access != "P0000000" &&
                    Q_Access != "E000000" && Q_Access != "P0000000" &&
                    Q_Access != "E000000" && Q_Access != "P0000000" &&
                    Q_Access != "P0000000" && Q_Access != "P0000000" &&
                    Q_Access != "E000000" && Q_Access != "P0000000" &&
                    Q_Access != "P0000000" && Q_Access != "P0000000" &&
                    Q_Access != "E000000" && Q_Access != "P0000000" &&
                    Q_Access != "E000000" && Q_Access != "P0000000" &&
                    Q_Access != "P0000000" && Q_Access != "P0000000" &&
                    Q_Access != "P0000000" && Q_Access != "P0000000")
            return true;
        else
            return false;
    }



    public void setConnString(string s)
    {
        sqlConnString = s;
    }
    /// <summary>
    /// Simple Function to accept a query string, fill a DataTable, and return it
    /// </summary>
    /// <returns>DataTable with Single Result Set</returns>
    public DataTable returnDataTable(string query)
    {
        string connstring = sqlConnString;


        DataTable queryresults = new DataTable();
        using (SqlConnection connection = new SqlConnection(connstring))
        {
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                connection.Open();
                using (SqlDataAdapter da = new SqlDataAdapter(command))
                {
                    da.Fill(queryresults);
                }
                connection.Close();
            }

            return queryresults;
        }
    }

    public DataTable returnDataTableNew(string query)
    {
        string connstring = sqlConnStringNew;


        DataTable queryresults = new DataTable();
        using (SqlConnection connection = new SqlConnection(connstring))
        {
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                connection.Open();
                using (SqlDataAdapter da = new SqlDataAdapter(command))
                {
                    da.Fill(queryresults);
                }
                connection.Close();
            }

            return queryresults;
        }
    }
    ///
    ///
    ///
    public string parseString(string value)
    {
        return value.Replace("\n", "").Replace(";", "").Replace("<", "").Replace(">", "").Replace("'", "").Replace("\"", "").Replace("\\\\", "\\");
    }

    /// <summary>
    /// Simple function to run a query and return true or false based on sucessfull run
    /// </summary>
    /// <returns>Bool to indicate if query was sucessfully ran</returns>
    public bool runQuery(string q)
    {


        using (SqlConnection connection = new SqlConnection(sqlConnString))
        {
            try { 
            using (SqlCommand command = new SqlCommand(q, connection))
            {
                connection.Open();
                command.ExecuteNonQuery();
                connection.Close();
                return true;
            }
            }
            catch
            {
                return false;
            }
        }
    }
    /// <summary>
    /// Simple function to run a query and return true or false based on sucessfull run
    /// </summary>
    /// <returns>Bool to indicate if query was sucessfully ran</returns>
    public string runQueryNew(string q)
    {
        
        using (SqlConnection connection = new SqlConnection(sqlConnStringNew))
        {
            try
            {
                using (SqlCommand command = new SqlCommand(q, connection))
                {
                    connection.Open();
                    command.ExecuteNonQuery();
                    connection.Close();
                    //If no flags were raised, a false should be returned.
                    return "0";
                }
            }
            catch(Exception e)
            {
                
                return e.ToString();
            }
        }
    }
    /// <summary>
    /// Simple function to run a DataSet from a query
    /// </summary>
    /// <returns>Returns a Dataset from query with Muli Returns</returns>
    public DataSet returnDataSet(string query)
    {
        string connstring = sqlConnString;


        DataSet queryresults = new DataSet();
        using (SqlConnection connection = new SqlConnection(connstring))
        {
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                connection.Open();
                using (SqlDataAdapter da = new SqlDataAdapter(command))
                {
                    da.Fill(queryresults);
                }
                connection.Close();
            }

            return queryresults;
        }
    }
    /// <summary>
    /// Simple function to run a DataSet from a query
    /// </summary>
    /// <returns>Returns a Dataset from query with Muli Returns</returns>
    public DataSet returnDataSetNew(string query)
    {
        string connstring = sqlConnStringNew;


        DataSet queryresults = new DataSet();
        using (SqlConnection connection = new SqlConnection(connstring))
        {
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                connection.Open();
                using (SqlDataAdapter da = new SqlDataAdapter(command))
                {
                    da.Fill(queryresults);
                }
                connection.Close();
            }

            return queryresults;
        }
    }
    public string monthNumToName(string fiscalMonth)
    {
        
        switch (fiscalMonth)
        {
            case "01":
                return "Jan";
                
            case "02":
                return "Feb";

            case "03":
                return "Mar";

            case "04":
                return "Apr";

            case "05":
                return "May";

            case "06":
                return "Jun";

            case "07":
                return "Jul";

            case "08":
                return "Aug";

            case "09":
                return "Sep";

            case "10":
                return "Oct";

            case "11":
                return "Nov";

            case "12":
                return "Dec";
            default:
                return "";

        }
    }


    public string posLvlNumToName(string posLevel) 
    {

        switch (posLevel)
        {
            case "1":
                return "Agent";
                
            case "2":
                return "Supervisor";

            case "12":
                return "Supervisor";

            case "5":
                return "Lead Supervisor";

            case "3":
                return "Manager";
                
            case "4":
                return "Lead";

            case "14":
                return "Lead";

            default:
                return "Agent";
                
        }

    }


    public string[] hexColors = {

        "#385273", "#0468BF","#022340","#A3B2BF","#D5E5F2"
        ,"#034AA6","#0487D9","#05AFF2","#05C7F2","#BF9004",
        "#385273", "#0468BF","#022340","#A3B2BF","#D5E5F2"
        ,"#034AA6","#0487D9","#05AFF2","#05C7F2","#BF9004",
        "#385273", "#0468BF","#022340","#A3B2BF","#D5E5F2"
        ,"#034AA6","#0487D9","#05AFF2","#05C7F2","#BF9004",
        "#385273", "#0468BF","#022340","#A3B2BF","#D5E5F2"
        ,"#034AA6","#0487D9","#05AFF2","#05C7F2","#BF9004",
        "#385273", "#0468BF","#022340","#A3B2BF","#D5E5F2"
        ,"#034AA6","#0487D9","#05AFF2","#05C7F2","#BF9004",
        "#385273", "#0468BF","#022340","#A3B2BF","#D5E5F2"
        ,"#034AA6","#0487D9","#05AFF2","#05C7F2","#BF9004"

    };

    //010422 - Scorecard Colors Array RGB Format Worst-Best
    public int[,] scorecardColors = {{ 150,52,52 },
        { 218,150,148 },
        { 242,220,219 },
        { 235,241,222 },
        { 196,215,155 },
        { 118,147,60 },
        { 228,223,236 },
        { 177,160,199 },
        { 96,73,122 }};


    /// <summary>
    /// returns a Div which will be located in the bottom Right of the view port
    /// </summary>
    /// <returns>Body HTML wrapped in a Div as a String</returns>
    private string DivWrapped(string body)
    {
        string div = "";
        div = div + "<div style=\"background-color: #F8F9FA; text-align: left; position: fixed; bottom: 0; right: 0; color: black; width: 600px; height: 400px; overflow: scroll; color: black;\">";
        div = div + body;
        div = div + "</div>";
        return div;
    }
    public string sQuery(string query)
    {
        CareTools c = new CareTools();
        string q = query;
        string[,] rItems =
            {
                {"]" ,"]<BR />" },
                {";" ,";<BR />" },
                {"/*" ,"<BR /><font color='green'><b>/*" },
                {"*/" ,"*/</b></font><BR />" },
                {"UNION" ,"<BR /><font color='blue'>UNION</font>" },
                {"INTO" ,"<BR /><font color='blue'>INTO</font>" },
                {"WHERE" ,"<BR /><font color='blue'>WHERE</font>" },
                {"FROM " ,"<BR /><font color='blue'>FROM</font> " },
                {"GROUP BY" ,"<BR /><font color='blue'>GROUP BY</font>" },
                {"ORDER BY" ,"<BR /><font color='blue'>ORDER BY</font>" },
                {"INNER JOIN" ,"<BR /><font color='blue'>INNER JOIN</font>" },
                {"RIGHT OUTER JOIN" ,"<BR /><font color='blue'>RIGHT OUTER JOIN</font>" },
                {"LEFT OUTER JOIN" ,"<BR /><font color='blue'>LEFT OUTER JOIN</font>" },
                {"  " ," " },
                {"SELECT " ,"<BR /><font color='blue'>SELECT</font> " },
                {"SET " ,"<BR /><font color='blue'>SET</font> " },
                {"BEGIN " ,"<BR /><font color='blue'>BEGIN</font> " },
                {"BEGIN;" ,"<BR /><font color='blue'>BEGIN;</font>" },
                {"UPDATE " ,"<BR /><font color='blue'>UPDATE</font> " },
                {"DROP " ,"<BR /><font color='blue'>DROP</font> " },
                {"WHEN " ,"<BR /><font color='blue'>WHEN</font> " },
                {"ELSE " ,"<BR /><font color='blue'>ELSE</font> " },
                {"<BR /><BR />" ,"<BR />" }

            };

        for (int i = 1; i < 23; i++)
        {
            q = c.Replace(q, rItems[i, 0].ToString(), rItems[i, 1].ToString(), StringComparison.OrdinalIgnoreCase);
        }
        return DivWrapped(q);


    }

    public string getUserStateCity(string samAcct)
    {
        string q = "";
        q += " SELECT ";
        q += " pl.[STATE] + ' ' + pl.[CITY] StateCity ";
        q += " FROM Database.schema.PROD_WORKERS pw with(nolock) ";
        q += " INNER JOIN Database.schema.PROD_LOCATIONS pl with(nolock) ";

        q += " on pw.LOCATIONID = pl.LOCATIONID ";
        q += " WHERE pw.SAMACCOUNTNAME = '"+samAcct+"' ";
        string r = returnDataTable(q).Rows[0][0].ToString();
        return r;
        
    }

    public string getUserTitle(string samAcct)
    {
        string q = "";
        q += " SELECT ";
        q += " pj.TITLE ";
        q += " FROM Database.schema.PROD_WORKERS p with(nolock) ";
        q += " INNER JOIN Database.schema.PROD_JOB_CODES pj with(nolock) ";
        q += " on p.JOBCODEID = pj.JOBCODEID ";
        q += " WHERE p.SAMACCOUNTNAME = '"+samAcct+"'; ";
        return returnDataTable(q).Rows[0][0].ToString();
    }


    /// <summary>
    /// Returns a string with Last updated xxxx xxxx ago based on Minutes, Hours, and Days
    /// </summary>
    /// <returns>A Simple String</returns>
    public string timediff(DateTime d1, DateTime d2)
    {
        TimeSpan t = d2 - d1;
        if(t.TotalMinutes>60)
        { 
            if(t.TotalHours>24)
                return "Last updated " + Math.Round(t.TotalDays,0).ToString() + " day(s) ago.";
            else
            return "Last updated " + Math.Round(t.TotalHours,0).ToString() + " hour(s) ago.";
        }else return "Last updated " + Math.Round(t.TotalMinutes,0).ToString() + " min(s) ago.";

    }

    public string DTToJSON(DataTable table)
    {
        var JSONString = new StringBuilder();
        if (table.Rows.Count > 0)
        {
            JSONString.Append("[");
            for (int i = 0; i < table.Rows.Count; i++)
            {
                JSONString.Append("");
                for (int j = 0; j < table.Columns.Count; j++)
                {

                    if (j == table.Columns.Count - 1)
                    {
                        JSONString.Append("\"" + table.Rows[i][j].ToString() + "\"");
                    }
                }
                if (i == table.Rows.Count - 1)
                {
                    JSONString.Append("");
                }
                else
                {
                    JSONString.Append(",");
                }
            }
            JSONString.Append("]");
        }
        return JSONString.ToString();
    }
    public string DataTableToJSONWithStringBuilder(DataTable table)
    {
        var JSONString = new StringBuilder();
        if (table.Rows.Count > 0)
        {
            JSONString.Append("[");
            for (int i = 1; i < table.Rows.Count; i++)
            {
                JSONString.Append("{");
                for (int j = 0; j < table.Columns.Count; j++)
                {
                    if (j < table.Columns.Count - 1)
                    {
                        JSONString.Append("\"" + table.Rows[0][j].ToString() + "\":" + "\"" + table.Rows[i][j].ToString() + "\",");
                    }
                    else if (j == table.Columns.Count - 1)
                    {
                        JSONString.Append("\"" + table.Rows[0][j].ToString() + "\":" + "\"" + table.Rows[i][j].ToString() + "\"");
                    }
                }
                if (i == table.Rows.Count - 1)
                {
                    JSONString.Append("}");
                }
                else
                {
                    JSONString.Append("},");
                }
            }
            JSONString.Append("]");
        }
        return JSONString.ToString();
    }
    public string ReadFromFile(string path)
    {
        return File.ReadAllText(path);
    }

    public string getParamValue(HttpContext c, string token)
    {
        if ((!String.IsNullOrEmpty(c.Request.QueryString[token])) || (!String.IsNullOrEmpty(c.Request.QueryString[token])))
            return parseString(c.Request.QueryString[token].ToString());
        else
            return "\\";
        
    }



    public static DataTable GetInversedDataTable(DataTable table, string columnX,
         string columnY, string columnZ, string nullValue, bool sumValues)
    {
        //Create a DataTable to Return
        DataTable returnTable = new DataTable();

        if (columnX == "")
            columnX = table.Columns[0].ColumnName;

        //Add a Column at the beginning of the table
        returnTable.Columns.Add(columnY);


        //Read all DISTINCT values from columnX Column in the provided DataTale
        List<string> columnXValues = new List<string>();

        foreach (DataRow dr in table.Rows)
        {
            string columnXTemp = dr[columnX].ToString();
            if (!columnXValues.Contains(columnXTemp))
            {
                //Read each row value, if it's different from others provided, add to 
                //the list of values and creates a new Column with its value.
                columnXValues.Add(columnXTemp);
                returnTable.Columns.Add(columnXTemp);
            }
        }

        //Verify if Y and Z Axis columns re provided
        if (columnY != "" && columnZ != "")
        {
            //Read DISTINCT Values for Y Axis Column
            List<string> columnYValues = new List<string>();

            foreach (DataRow dr in table.Rows)
            {
                if (!columnYValues.Contains(dr[columnY].ToString()))
                    columnYValues.Add(dr[columnY].ToString());
            }

            //Loop all Column Y Distinct Value
            foreach (string columnYValue in columnYValues)
            {
                //Creates a new Row
                DataRow drReturn = returnTable.NewRow();
                drReturn[0] = columnYValue;
                //foreach column Y value, The rows are selected distincted
                DataRow[] rows = table.Select(columnY + "='" + columnYValue + "'");

                //Read each row to fill the DataTable
                foreach (DataRow dr in rows)
                {
                    string rowColumnTitle = dr[columnX].ToString();

                    //Read each column to fill the DataTable
                    foreach (DataColumn dc in returnTable.Columns)
                    {
                        if (dc.ColumnName == rowColumnTitle)
                        {
                            //If Sum of Values is True it try to perform a Sum
                            //If sum is not possible due to value types, the value 
                            // displayed is the last one read
                            if (sumValues)
                            {
                                try
                                {
                                    drReturn[rowColumnTitle] =
                                         Convert.ToDecimal(drReturn[rowColumnTitle]) +
                                         Convert.ToDecimal(dr[columnZ]);
                                }
                                catch
                                {
                                    drReturn[rowColumnTitle] = dr[columnZ];
                                }
                            }
                            else
                            {
                                drReturn[rowColumnTitle] = dr[columnZ];
                            }
                        }
                    }
                }
                returnTable.Rows.Add(drReturn);
            }
        }
        else
        {
            throw new Exception("The columns to perform inversion are not provided");
        }

        //if a nullValue is provided, fill the datable with it
        if (nullValue != "")
        {
            foreach (DataRow dr in returnTable.Rows)
            {
                foreach (DataColumn dc in returnTable.Columns)
                {
                    if (dr[dc.ColumnName].ToString() == "")
                        dr[dc.ColumnName] = nullValue;
                }
            }
        }

        return returnTable;
    }


    public static DataTable GetInversedDataTable(DataTable table, string columnX,
                                                 params string[] columnsToIgnore)
    {
        //Create a DataTable to Return
        DataTable returnTable = new DataTable();

        if (columnX == "")
            columnX = table.Columns[0].ColumnName;

        //Add a Column at the beginning of the table

        returnTable.Columns.Add(columnX);

        //Read all DISTINCT values from columnX Column in the provided DataTale
        List<string> columnXValues = new List<string>();

        //Creates list of columns to ignore
        List<string> listColumnsToIgnore = new List<string>();
        if (columnsToIgnore.Length > 0)
            listColumnsToIgnore.AddRange(columnsToIgnore);

        if (!listColumnsToIgnore.Contains(columnX))
            listColumnsToIgnore.Add(columnX);

        foreach (DataRow dr in table.Rows)
        {
            string columnXTemp = dr[columnX].ToString();
            //Verify if the value was already listed
            if (!columnXValues.Contains(columnXTemp))
            {
                //if the value id different from others provided, add to the list of 
                //values and creates a new Column with its value.
                columnXValues.Add(columnXTemp);
                returnTable.Columns.Add(columnXTemp);
            }
            else
            {
                //Throw exception for a repeated value
                throw new Exception("The inversion used must have " +
                                    "unique values for column " + columnX);
            }
        }

        //Add a line for each column of the DataTable

        foreach (DataColumn dc in table.Columns)
        {
            if (!columnXValues.Contains(dc.ColumnName) &&
                !listColumnsToIgnore.Contains(dc.ColumnName))
            {
                DataRow dr = returnTable.NewRow();
                dr[0] = dc.ColumnName;
                returnTable.Rows.Add(dr);
            }
        }

        //Complete the datatable with the values
        for (int i = 0; i < returnTable.Rows.Count; i++)
        {
            for (int j = 1; j < returnTable.Columns.Count; j++)
            {
                returnTable.Rows[i][j] =
                  table.Rows[j - 1][returnTable.Rows[i][0].ToString()].ToString();
            }
        }

        return returnTable;
    }

    public string FindTextBetween(string text, string left, string right)
    {
        // TODO: Validate input arguments

        int beginIndex = text.IndexOf(left); // find occurence of left delimiter
        if (beginIndex == -1)
            return string.Empty; // or throw exception?

        beginIndex += left.Length;

        int endIndex = text.IndexOf(right, beginIndex); // find occurence of right delimiter
        if (endIndex == -1)
            return string.Empty; // or throw exception?

        return text.Substring(beginIndex, endIndex - beginIndex).Trim();
    }


    public string rnkDTToJSON(DataTable table)
    {
        var JSONString = new StringBuilder();
        if (table.Rows.Count > 0)
        {
            JSONString.Append("[");
            for (int i = 0; i < table.Rows.Count; i++)
            {
                JSONString.Append("{");
                for (int j = 0; j < table.Columns.Count; j++)
                {
                    if (j < table.Columns.Count - 1)
                    {
                        JSONString.Append("\"" + table.Columns[j].ColumnName.ToString() + "\":" + "\"" + table.Rows[i][j].ToString() + "\",");
                    }
                    else if (j == table.Columns.Count - 1)
                    {
                        JSONString.Append("\"" + table.Columns[j].ColumnName.ToString() + "\":" + "\"" + table.Rows[i][j].ToString() + "\"");
                    }
                }
                if (i == table.Rows.Count - 1)
                {
                    JSONString.Append("}");
                }
                else
                {
                    JSONString.Append("},");
                }
            }
            JSONString.Append("]");
        }
        return JSONString.ToString();
    }


    public string JSONReturn(DataTable table)
    {
        var JSONString = new StringBuilder();
        if (table.Rows.Count > 0)
        {
            if(table.Rows.Count>1)
                JSONString.Append("[");
            for (int i = 0; i < table.Rows.Count; i++)
            {
                JSONString.Append("{");
                for (int j = 0; j < table.Columns.Count; j++)
                {
                    if (j < table.Columns.Count - 1)
                    {
                        JSONString.Append("\"" + table.Columns[j].ColumnName.ToString() + "\":" + "\"" + table.Rows[i][j].ToString() + "\",");
                    }
                    else if (j == table.Columns.Count - 1)
                    {
                        JSONString.Append("\"" + table.Columns[j].ColumnName.ToString() + "\":" + "\"" + table.Rows[i][j].ToString() + "\"");
                    }
                }
                if (i == table.Rows.Count - 1)
                {
                    JSONString.Append("}");
                }
                else
                {
                    JSONString.Append("},");
                }
            }
            if (table.Rows.Count > 1)
                JSONString.Append("]");
        }
        return JSONString.ToString();
    }

    public HtmlGenericControl NavItem(HtmlGenericControl subControl, bool dropdown = false, bool hidden = false)
        {
            HtmlGenericControl li = new HtmlGenericControl("li");
            string liClass = "nav-item";
            if (dropdown == true) { liClass = "nav-item dropdown"; };
            li.Attributes.Add("class", liClass);
            if (hidden == true)
                li.Visible = false;
            if (subControl != null) { li.Controls.Add(subControl); };
            return li;
        }

    public HtmlGenericControl AClassLink(string innerText, string href = "#", bool dropdown = false, bool dropdownitem = false)
        {
            HtmlGenericControl a = new HtmlGenericControl("a");
            string aClass = "nav-link";
            if (dropdownitem == true) { aClass = "dropdown-item"; };
            if (dropdown == true)
            {
                aClass = "nav-link dropdown-toggle";
                a.Attributes.Add("id", "navbarDropdown");
                a.Attributes.Add("role", "button");
                a.Attributes.Add("data-toggle", "dropdown");
                a.Attributes.Add("aria-haspopup", "true");
                a.Attributes.Add("aria-expanded", "false");
            }
            a.Attributes.Add("class", aClass);
            a.Attributes.Add("href", href);
            if (innerText != null) { a.InnerText = innerText; };
            return a;
        }

    public HtmlGenericControl navbrand(bool isImage = false, string innertext = null, string imgpath = null)
        {
            string tag = "a";
            if (isImage == true) { tag = "img"; };
            HtmlGenericControl brand = new HtmlGenericControl(tag);
            brand.Attributes.Add("class", "navbar-brand");
            if (tag == "a")
            {
                brand.Attributes.Add("href", "#");
                brand.InnerText = innertext;
            }
            if (tag == "img")
            {
                brand.Attributes.Add("src", imgpath);
                brand.Attributes.Add("style", "height: 50px; width: 128px;");
            }
            return brand;

        }




    //===================================================================================
    //          RETURNS THE APD LINK FOR THE USERS'S MATCHING STATE CITY
    //              -If no Match is found or query fails, a # will be returned
    //===================================================================================
    public string getAPDLink(string Q_Access)
    {
        if(Q_Access!=null)
        { 
        string lnkQuery = "" +
            " declare @Q_Access as nvarchar(68); " +
            " declare @stateCity as nvarchar(68); " +
            " set @Q_Access = '"+ Q_Access + "' " +

            " select top 1 " +
            " @stateCity = l.STATE + ' ' + l.CITY " +
            " from Database.schema.PROD_WORKERS w with(nolock) " +
            " inner join Database.schema.PROD_LOCATIONS l with(nolock) " +
            "     on w.LOCATIONID = l.LOCATIONID " +
            " where " +
            " 	case  " +
            "         when w.SAMACCOUNTNAME = @Q_Access then 1 " +
            "         when w.LSAMACCOUNTNAME = @Q_Access then 1 " +
            "         when w.ENTITYACCOUNT = @Q_Access then 1 " +
            " 		else 0 " +
            "     end = 1; " +

            "         select " +
            "         ISNULL([Link], '#') [Link] " +
            "     from Database.schema.meCard_SITE_APD_LINKS lnk with(nolock) " +
            "          where lnk.stateCity like @stateCity ";

            try
            { return returnDataTable(lnkQuery).Rows[0][0].ToString(); }
            catch
            { return "#"; }


            }
        else
        {
            return "#";
        }

       
    }














}
