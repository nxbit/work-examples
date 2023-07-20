using System;
using System.Data.SqlClient;
using System.Data;
using System.Web;

/// <summary>
/// cardUser Class contains: 
///     currentUser - String Type - holds Current User SAM Account
///     returnDataSet() - Contains Components to connect to SQL Table with provided sqlConnString and return a DataSet
///     returnDataTable() - Same as returnDataSet scoped to one DataTable
///     currentUserPosLevel() - Returns "String" with 1,2,3,4 values based on User Position Level 
///     Title() - Returns the cardUser Title as a string
/// </summary>
public class cardUser
{
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!! Paths, IPs, any anything identifiable has been hidden !!!!!!!!!!!!!!!!!!!!!!!!!!!! //

    public string selectedUser;

    public string currentUser = HttpContext.Current.User.Identity.Name.Split('\\')[HttpContext.Current.User.Identity.Name.Split('\\').Length - 1];
    //public string currentUser = "P0000000";

    private string sqlConnString = "<<CONNECTIONSTRING>>";

    public cardUser(string user)
    {

        if (user == null)
        {

            selectedUser = HttpContext.Current.User.Identity.Name.Split('\\')[HttpContext.Current.User.Identity.Name.Split('\\').Length - 1];
        }
        else
        {
            selectedUser = user;
        }
        // TODO: Add constructor logic here
        //
    }

    private DataSet returnDataSet(string query)
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

    private void runquery(string query)
    {
        string connstring = sqlConnString;
        using (SqlConnection connection = new SqlConnection(connstring))
        {
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                connection.Open();
                command.ExecuteNonQuery();
                connection.Close();
            }
        }
    }

    private DataTable returnDataTable(string query)
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

    public string cardUserMainQuery = "<<QUERYSAVEDIN: QUERIES>meCard.sql>>";

    public DataSet getDataSet()
    {

        cardUserMainQuery = cardUserMainQuery.Replace("<#SELECTEDUSER#>", selectedUser).Replace("<#CURRENTUSER#>", currentUser);
        return returnDataSet(cardUserMainQuery);

    }




    public void UpdateNotes(string id, string agentNotes, string leaderNotes)
    {
        string sqlquery = "" +
            " DECLARE @agentNotes nvarchar(max); " +
            " DECLARE @leaderNotes nvarchar(max); " +
            " DECLARE @samAccount nvarchar(10); " +
            " DECLARE @itemExists int; " +

            " SET @samAccount = '" + id + "' " +
            " SET @agentNotes = '" + agentNotes + "'; " +
            " SET @leaderNotes = '" + leaderNotes + "'; " +
            " SET @itemExists = ( " +

            " SELECT " +
            " 1 " +
            " FROM Database.schema.meCard_LEADERSHIP_DATA ld with(nolock) " +
            " WHERE ld.psid = @samAccount) " +

            " IF @itemExists IS NULL " +
            " BEGIN " +

            "  INSERT INTO Database.schema.meCard_LEADERSHIP_DATA(psid, agentNotes, leaderNotes)  " +
            "  SELECT  " +
            "  @samAccount psid, " +
            "  @agentNotes agentNotes,  " +
            "  @leaderNotes leaderNotes;  " +


            "  END  " +
            "  if @itemExists IS NOT NULL  " +
            "  BEGIN  " +
            //If the Leadernotes Passed is the HIDDEN token then update only the Agent Notes Section
            " 	if @leaderNotes = 'HIDDEN' " +
            " 	BEGIN " +
            "    UPDATE Database.schema.meCard_LEADERSHIP_DATA  " +
            " 	 SET agentNotes = @agentNotes " +
            " 	 WHERE psid = @samAccount  " +
            " 	END " +
            " 	ELSE " +
            " 	BEGIN " +
            " 	 UPDATE Database.schema.meCard_LEADERSHIP_DATA  " +
            " 	 SET agentNotes = @agentNotes, leaderNotes = @leaderNotes  " +
            " 	 WHERE psid = @samAccount  " +
            " 	END " +
            "  END  ";

        runquery(sqlquery);




    }

    public string UpdateNotesquery(string id, string agentNotes, string leaderNotes)
    {
        string sqlquery = "" +
            " DECLARE @agentNotes nvarchar(max); " +
            " DECLARE @leaderNotes nvarchar(max); " +
            " DECLARE @samAccount nvarchar(10); " +
            " DECLARE @itemExists int; " +

            " SET @samAccount = '" + id + "' " +
            " SET @agentNotes = '" + agentNotes + "'; " +
            " SET @leaderNotes = '" + leaderNotes + "'; " +
            " SET @itemExists = ( " +

            " SELECT " +
            " 1 " +
            " FROM Database.schema.meCard_LEADERSHIP_DATA ld with(nolock) " +
            " WHERE ld.psid = @samAccount) " +

            " IF @itemExists IS NULL " +
            " BEGIN " +

            "  INSERT INTO Database.schema.meCard_LEADERSHIP_DATA(psid, agentNotes, leaderNotes)  " +
            "  SELECT  " +
            "  @samAccount psid, " +
            "  @agentNotes agentNotes,  " +
            "  @leaderNotes leaderNotes;  " +


            "  END  " +
            "  if @itemExists IS NOT NULL  " +
            "  BEGIN  " +
            " 	if @leaderNotes = ' ' " +
            " 	BEGIN " +
            "    UPDATE Database.schema.meCard_LEADERSHIP_DATA  " +
            " 	 SET agentNotes = @agentNotes, leaderNotes = @leaderNotes  " +
            " 	 WHERE psid = @samAccount  " +
            " 	END " +
            " 	ELSE " +
            " 	BEGIN " +
            " 	 UPDATE Database.schema.meCard_LEADERSHIP_DATA  " +
            " 	 SET agentNotes = @agentNotes " +
            " 	 WHERE psid = @samAccount  " +
            " 	END " +
            "  END  ";

        return sqlquery;




    }


    public string CUserEmail()
    {
        string sql = "" +
            " SELECT " +
            " max([EMAIL]) [cUserEmail] " +
            "    FROM Database.schema.PROD_WORKERS pw with(nolock) " +
            " WHERE pw.ENTITYACCOUNT = '" + currentUser + "' OR pw.SAMACCOUNTNAME = '" + currentUser + "' ";

        return returnDataTable(sql).Rows[0][0].ToString();
    }













}