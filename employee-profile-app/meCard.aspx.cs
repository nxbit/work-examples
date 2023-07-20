using System;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Text;
using System.Drawing;
using System.Net.Mail;
using System.Net.Mime;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.SessionState;

public partial class meCard : System.Web.UI.Page, System.Web.UI.ICallbackEventHandler, IRequiresSessionState
{

    //!!!!!!!!!!!!!!!!!!!!!!!!!!!! Paths, IPs, any anything identifiable has been hidden !!!!!!!!!!!!!!!!!!!!!!!!!!!! //

    //
    //  Function to Grab Update Status
    //
    
    private string sqlConnString = "<<CONNECTIONSTRING>>";

    private bool grabUpdateStatus()
    {

        DataSet queryresults = new DataSet();
        using (SqlConnection connection = new SqlConnection(sqlConnString))
        {
            using (SqlCommand command = new SqlCommand(" SELECT " +
                        " Status_Flag " +
                    " FROM <<DataBase.Schema>>JOB_StatusTracking jt with(nolock) " +
                    " WHERE JobToken = 'Ranking.Updating' ", connection))
            {
                connection.Open();
                using (SqlDataAdapter da = new SqlDataAdapter(command))
                {
                    da.Fill(queryresults);
                }
                connection.Close();
            }
            if (queryresults.Tables[0].Rows[0][0].ToString() == "1") { queryresults.Dispose(); return true; } else { queryresults.Dispose(); return false; }

        }
    }

    //
    // CallBack Event Handler Section
    //
    public string callBackVal;
    public string GetCallbackResult()
    {
        string str_agentNotes = "";
        if (callBackVal.Contains("[agentNotes]"))
        { str_agentNotes = callBackVal.Substring((callBackVal.IndexOf("[agentNotes]") + 12), ((callBackVal.LastIndexOf("[agentNotes]")) - (callBackVal.IndexOf("[agentNotes]") + 12))).ToString().Replace("\n", "").Replace(";", "").Replace("<", "").Replace(">", "").Replace("'", "").Replace("\"", "").Replace("{", "").Replace("}", ""); }

        string leadershipNotes = "";
        if (callBackVal.Contains("[leadershipNotes]"))
        { leadershipNotes = callBackVal.Substring((callBackVal.IndexOf("[leadershipNotes]") + 17), ((callBackVal.LastIndexOf("[leadershipNotes]")) - (callBackVal.IndexOf("[leadershipNotes]") + 17))).ToString().Replace("\n", "").Replace(";", "").Replace("<", "").Replace(">", "").Replace("'", "").Replace("\"", "").Replace("{", "").Replace("}", ""); }

        string agentID = "";
        if (callBackVal.Contains("[agentID]"))
        { agentID = callBackVal.Substring((callBackVal.IndexOf("[agentID]") + 9), ((callBackVal.LastIndexOf("[agentID]")) - (callBackVal.IndexOf("[agentID]") + 9))).ToString().Replace("\n", "").Replace(";", "").Replace("<", "").Replace(">", "").Replace("'", "").Replace("\"", "").Replace("{", "").Replace("}", ""); }


        string feedbackBodyVal = "";
        if (callBackVal.Contains("[feedbackBody]"))
        { feedbackBodyVal = callBackVal.Substring((callBackVal.IndexOf("[feedbackBody]") + 14), ((callBackVal.LastIndexOf("[feedbackBody]")) - (callBackVal.IndexOf("[feedbackBody]") + 14))).ToString().Replace("\n", "").Replace(";", "").Replace("<", "").Replace(">", "").Replace("'", "").Replace("\"", "").Replace("{", "").Replace("}", ""); };

        string feedbackSubjectVal = "";
        if (callBackVal.Contains("[feedbackSubject]"))
        { feedbackSubjectVal = callBackVal.Substring((callBackVal.IndexOf("[feedbackSubject]") + 17), ((callBackVal.LastIndexOf("[feedbackSubject]")) - (callBackVal.IndexOf("[feedbackSubject]") + 17))).ToString().Replace("\n", "").Replace(";", "").Replace("<", "").Replace(">", "").Replace("'", "").Replace("\"", "").Replace("{", "").Replace("}", ""); }

        cardUser cu = new cardUser(agentID);

        //
        //  Try to UpdateNotes for the parsed User
        //  If sucessfull passs Save Sucessfull msg, 
        //  If not show Save Failed.
        //
        try
        {
            if (feedbackBodyVal != "" && feedbackSubjectVal != "")
            {
                eMail email = new eMail();

                string[] em = { "<<Email@Address.com>>" };

                string eBody = "";
                eBody = eBody + "Hello Reporting Team,<br />";
                eBody = eBody + "<br />";
                eBody = eBody + "You've recived " + Page.Title.ToString() + " page feedback from " + cu.currentUser + " on " + DateTime.UtcNow.AddHours(-5).ToString("MM/dd/yyyy");
                eBody = eBody + "<br />";
                eBody = eBody + "<br />";
                eBody = eBody + "Submission Subject: " + feedbackSubjectVal;
                eBody = eBody + "<br />";
                eBody = eBody + "Submission Body: ";
                eBody = eBody + "<div style=' text-align:left; width: 100%;'>";
                eBody = eBody + feedbackBodyVal;
                eBody = eBody + "<br />";
                eBody = eBody + "<br />";
                eBody = eBody + "Page Data:";
                eBody = eBody + "<br />";
                eBody = eBody + "Url: " + Request.Url.ToString() + "<br />";
                eBody = eBody + "User: " + cu.currentUser + "<br />";
                eBody = eBody + "SessionID: " + Session.SessionID.ToString() + "<br />";
                eBody = eBody + "Timeout: " + Session.Timeout.ToString() + "<br />";
                eBody = eBody + "<br />";
                eBody = eBody + "<br />";
                eBody = eBody + "Please research and followup.<br />";
                eBody = eBody + "Thank you<br />";
                eBody = eBody + "<br />";
                eBody = eBody + "<br />";
                eBody = eBody + "<br />";


                if (email.sendEmail(cu.CUserEmail(), "#DDEBF7", "meCard", feedbackSubjectVal, em, "<<Email@Address.com>>", eBody, "VRA_EmailHeader_meCard.png"))
                    return "Saved";
                else
                    return "Failed"; ;

                // sendEmail(feedbackSubjectVal, feedbackBodyVal, cu.CUserEmail());
                // return "Saved";
            }
            else
            {
                cu.UpdateNotes(agentID, str_agentNotes, leadershipNotes);

            }
            return "Saved";
        }
        catch (Exception e)
        {
            return e.ToString();
        };
    }

    public void RaiseCallbackEvent(string eventArgument)
    {
        callBackVal = eventArgument;
    }



    protected void Page_Load(object sender, EventArgs e)
    {
        KTool k = new KTool();
        //
        // RegStats driving page logging.
        //
        RegStats gate = new RegStats();



        //
        //  Check if Page is updating
        //
        if (!grabUpdateStatus() && gate.result)
        {
            string sPID = null;
            string selectedUser = null;
            if (Request.QueryString["PID"] != null)
            {
                sPID = Request.QueryString["PID"].ToString();
            }
            string url = Request.Url.ToString().Replace("?PID=" + sPID, "").Replace(" ", "").ToString();
            //
            //  Check if PID was passed if not
            //  CardUser class will assign the current user
            //
            if (Request.QueryString["PID"] != null)
                selectedUser = Request.QueryString["PID"].ToString().Replace("\n", "").Replace(";", "").Replace("<", "").Replace(">", "").Replace("'", "").Replace("\"", "").Replace("{", "").Replace("}", "");
            cardUser user = new cardUser(selectedUser);
            string cuser = user.currentUser;



            meCardLogoLinkBack.HRef = url + "?PID=" + cuser;
            HttpBrowserCapabilities browser = ((Page)HttpContext.Current.Handler).Request.Browser;

            if (browser.Browser.Contains("IE") || browser.Browser.Contains("Internet"))
            {
                //  Older version misbehaving with tile format; Oddly, IE 9 seems to mostly behave without issue;
                //  List needs to start and end with a pipe | on each value to avoid partial matching;
                if ("|4|5|6|7|8|10|".Contains("|" + browser.MajorVersion + "|"))
                {

                    Label compatLabel = new Label();
                    string alertMsg = "";
                    alertMsg = alertMsg + "Your browser appears to be in compatibility mode, or using an older version, which breaks functionality on this page.";
                    alertMsg = alertMsg + "<br><br>";
                    alertMsg = alertMsg + "To disable Compatibility mode:<br>";
                    //081020:   Added mention of the Alt key since the menu bar is hidden by default in IE;
                    alertMsg = alertMsg + "- Press the Alt key to see the menu bar, then select Tools > Compatibility View Settings from the menu bar.<br>";
                    alertMsg = alertMsg + "- Remove chartercom.com if it appears in the sites<br>";
                    alertMsg = alertMsg + "- Uncheck any of the options at the bottom<br>";
                    alertMsg = alertMsg + "- Close the prompt.<br>";
                    alertMsg = alertMsg + "<br>";
                    compatLabel.Text = alertMsg;
                    alertPanel.Controls.Add(compatLabel);


                }
            }




            //
            // Set Call Back Register Items
            //
            string cbref = Page.ClientScript.GetCallbackEventReference(this, "arg", "JSCallback", "context");
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "UseCallBack", "function UseCallBack(arg, context){" + cbref + ";}", true);

            //
            //  Initilize DataSet,
            //  Distribute DataTable Objects;
            //  Clean up DataSet
            //
            DataSet cardData = new DataSet();
            cardData = user.getDataSet();
            DataTable getEmpAllList = new DataTable();
            getEmpAllList = cardData.Tables[0];
            DataTable empHierarchyInfo = new DataTable();
            empHierarchyInfo = cardData.Tables[1];
            DataTable empInfo = new DataTable();
            empInfo = cardData.Tables[2];
            DataTable getEmpList = new DataTable();
            getEmpList = cardData.Tables[3];
            DataTable getTeamRank = new DataTable();
            getTeamRank = cardData.Tables[4];
            DataTable getLastandCurrentMetrics = new DataTable();
            getLastandCurrentMetrics = cardData.Tables[5];
            DataTable getCorPortalRank = new DataTable();
            getCorPortalRank = cardData.Tables[6];
            DataTable getEmpRank = new DataTable();
            getEmpRank = cardData.Tables[6];
            DataTable getSupMoves = new DataTable();
            getSupMoves = cardData.Tables[7];
            DataTable recentInteractions = new DataTable();
            recentInteractions = cardData.Tables[8];
            DataTable AgentLeadershipNotes = new DataTable();
            AgentLeadershipNotes = cardData.Tables[9];
            DataTable fullEmpList = new DataTable();
            fullEmpList = cardData.Tables[10];
            DataTable apdLink = new DataTable();
            apdLink = cardData.Tables[11];
            DataTable updateDates = new DataTable();
            updateDates = cardData.Tables[12];
            DataTable ahtData = new DataTable();
            ahtData = cardData.Tables[13];
            DataTable compData = new DataTable();
            compData = cardData.Tables[14];
            DataTable fcrData = new DataTable();
            fcrData = cardData.Tables[15];
            DataTable vocData = new DataTable();
            vocData = cardData.Tables[16];
            DataTable transData = new DataTable();
            transData = cardData.Tables[17];
            DataTable oooData = new DataTable();
            oooData = cardData.Tables[18];
            DataTable RankingUpdateData = new DataTable();
            RankingUpdateData = cardData.Tables[19];
            DataTable RankingFCRDateData = new DataTable();
            RankingFCRDateData = cardData.Tables[20];

            DataTable TitleCurrentUser = new DataTable();
            TitleCurrentUser = cardData.Tables[21];
            int currentUserPosLevel = 1;


            switch (TitleCurrentUser.Rows[0][0].ToString())
            {
                case "Rep":
                    currentUserPosLevel = 1;
                    break;
                case "Sup":
                    currentUserPosLevel = 2;
                    break;
                case "Mgr":
                    currentUserPosLevel = 3;
                    break;
                case "Dir":
                    currentUserPosLevel = 4;
                    break;
                case "GVP":
                    currentUserPosLevel = 5;
                    break;
                case "VP,":
                    currentUserPosLevel = 5;
                    break;
                default:
                    currentUserPosLevel = 1;
                    break;

            }


            DataTable selectedUserPos = new DataTable();
            selectedUserPos = cardData.Tables[22];
            int selectedUserPosLevel = 1;
            switch (selectedUserPos.Rows[0][0].ToString())
            {
                case "Rep":
                    selectedUserPosLevel = 1;
                    break;
                case "Sup":
                    selectedUserPosLevel = 2;
                    break;
                case "Mgr":
                    selectedUserPosLevel = 3;
                    break;
                case "Dir":
                    selectedUserPosLevel = 4;
                    break;
                case "GVP":
                    selectedUserPosLevel = 5;
                    break;
                case "VP,":
                    selectedUserPosLevel = 5;
                    break;
                default:
                    selectedUserPosLevel = 1;
                    break;

            }
            DataTable cUserEmailAddress = new DataTable();
            cUserEmailAddress = cardData.Tables[23];

            DataTable getCurrentUserTeamList = new DataTable();
            if (cardData.Tables[24] != null)
                getCurrentUserTeamList = cardData.Tables[24];



            cardData.Dispose();


            //
            // Create the List of Lookup Items based on users Position Level and PID
            //
            string varlList = "";
            if (cuser == "P0000000" || cuser == "P0000000" || cuser == "P0000000" ||
                cuser == "P0000000" || cuser == "P0000000" || cuser == "P0000000" ||
                cuser == "P0000000" || cuser == "P0000000" || cuser == "P0000000" || currentUserPosLevel == 5)
                varlList = k.DTToJSON(fullEmpList).Replace("'", "");
            else
                varlList = k.DTToJSON(fullEmpList).Replace("'", "");


            string empFullList = "" +
            "$( function() {" +
            "var availLookups = " +
            varlList + ";" +
            "$(\"#pidInput\").autocomplete({" +
            "source: availLookups," +
            "select: function(event, ui){ " +
            "event.preventDefault();" +
            "document.getElementById(\"pidInput\").value = ui.item.label;" +
            " window.location = \"" + url + "?PID=\"+ui.item.label.substring(ui.item.label.length - 20, ui.item.label.length-11).replace(\"(\",\"\").replace(\")\",\"\");}," +
            "minLength: 3" +
            "});" +
            "} );";



            //
            //  Set meCardLogo and Class
            //
            meCardLogo.ImageUrl = "./img/meCardLogo.png";
            meCardLogo.CssClass = "meCardLogo";



            //
            //  Create Card User Square
            //  Square with Image
            //
            //  121720 - Seperated Employee Name and HierInfo
            string selUserName = "";
            if (empHierarchyInfo.Rows.Count != 0)
            {


                DataTable empUserInfo = new DataTable();
                DataTable hierUserInfo = new DataTable();
                empUserInfo.Columns.Add("Col1", typeof(string));
                empUserInfo.Columns.Add("Col2", typeof(string));
                hierUserInfo.Columns.Add("Col1", typeof(string));
                hierUserInfo.Columns.Add("Col2", typeof(string));

                //Looping in Boss's Boss and Boss Information skipping index 2 as the Employee info is expected there
                for (int i = 0; i < empHierarchyInfo.Columns.Count && i != 2; i++)
                    hierUserInfo.Rows.Add(empHierarchyInfo.Columns[i].ColumnName,
                        empHierarchyInfo.Rows[0][i].ToString());

                //Grabbing just Employee Info from index Column 2
                empUserInfo.Rows.Add(empHierarchyInfo.Columns[2].ColumnName, empHierarchyInfo.Rows[0][2].ToString());
                selUserName = empHierarchyInfo.Rows[0][2].ToString();
                //Setup Employee GridView
                empNameInfo.DataSource = empUserInfo;
                empNameInfo.ShowHeader = false;
                empNameInfo.GridLines = GridLines.None;
                empNameInfo.DataBind();
                //empUser Info Cleanup
                empUserInfo.Dispose();



                empNameInfo.Rows[0].Cells[0].CssClass = "Titles";
                empImage.ImageUrl = "./ADImage.aspx?sAM=" + user.selectedUser;
                empImagecontainerBackground.ImageUrl = "./ADImage.aspx?sAM=" + user.selectedUser;

                //Setup Employee Heirarchy GridView
                hierNameInfo.DataSource = hierUserInfo;
                hierNameInfo.ShowHeader = false;
                hierNameInfo.GridLines = GridLines.None;
                hierNameInfo.DataBind();
                //hierUser Info Cleanup
                hierUserInfo.Dispose();

                for (int i = 0; i < hierNameInfo.Items.Count; i++)
                {
                    hierNameInfo.Items[i].Cells[0].CssClass = "Titles";
                }

            }
            //Clean Up Main Pull
            empHierarchyInfo.Dispose();



            //
            //  Initilzie Profile Info Section
            // 
            accountInfo.DataSource = empInfo;
            accountInfo.ShowHeader = false;
            accountInfo.GridLines = GridLines.None;
            accountInfo.DataBind();
            empInfo.Dispose();



            //
            // Title the Profile Section with the Selected Users Job Title
            //
            HtmlGenericControl acctInfoTitle = new HtmlGenericControl("span");
            acctInfoTitle.Attributes.Add("class", "ContainerTitle Titles");
            acctInfoTitle.InnerText = selectedUserPos.Rows[0][0].ToString() + " Profile Info";
            accountInfoTitle.Controls.AddAt(0, acctInfoTitle);
            acctInfoTitle.Dispose();


            //
            //  Initilize Attendance App
            //
            attendLink.ImageUrl = "img/Clock.png";
            attendLink.Height = 50;
            attendLink.Width = 50;
            HtmlGenericControl attendTitle = new HtmlGenericControl("span");
            attendTitle.Attributes.Add("class", "Titles attendTitle Links");
            attendTitle.InnerText = "Attend";
            attendTitleLabel.Controls.AddAt(0, attendTitle);
            attendTitle.Dispose();
            attendLinkContainer.Attributes.Add("class", attendLinkContainer.Attributes["class"].ToString() + " Links");


            //
            //  Initilize UXID App
            //
            uxidLink.ImageUrl = "img/Person.jpg";
            uxidLink.Height = 50;
            uxidLink.Width = 50;
            HtmlGenericControl uxidTitle = new HtmlGenericControl("span");
            uxidTitle.Attributes.Add("class", "Titles attendTitle Links");
            uxidTitle.InnerText = "UXID";
            uxidTitleLabel.Controls.AddAt(0, uxidTitle);
            uxidTitle.Dispose();
            uxidLinkContainer.Attributes.Add("class", uxidLinkContainer.Attributes["class"].ToString() + " Links");

            //
            //  Initilize the CorPortal App
            //
            corPortalLink.ImageUrl = "img/CorPortalIcon.png";
            corPortalLink.Height = 50;
            corPortalLink.Width = 50;
            HtmlGenericControl corPortalTitle = new HtmlGenericControl("span");
            corPortalTitle.Attributes.Add("class", "Titles attendTitle Links");
            corPortalTitle.InnerText = "CorPortal";
            corPortalTitleLabel.Controls.AddAt(0, corPortalTitle);
            corPortalTitle.Dispose();
            corPortalLinkContainer.Attributes.Add("class", corPortalLinkContainer.Attributes["class"].ToString() + " Links");

            //
            //  Initilize the CorPortalCoaching App
            //
            corPortalCoachLink.ImageUrl = "img/CorPortalIcon.png";
            corPortalCoachLink.Height = 50;
            corPortalCoachLink.Width = 50;
            HtmlGenericControl corPortalCoachTitle = new HtmlGenericControl("span");
            corPortalCoachTitle.Attributes.Add("class", "Titles attendTitle Links");
            corPortalCoachTitle.InnerText = "CPCoaching";
            corPortalCoachTitleLabel.Controls.AddAt(0, corPortalCoachTitle);
            corPortalCoachTitle.Dispose();
            corPortalCoachLinkContainer.Attributes.Add("class", corPortalCoachLinkContainer.Attributes["class"].ToString() + " Links");


            //
            //  Initilize the Qualitiy App
            //
            qualityLink.ImageUrl = "img/qualityIcon.png";
            qualityLink.Height = 50;
            qualityLink.Width = 50;
            HtmlGenericControl qualityTitle = new HtmlGenericControl("span");
            qualityTitle.Attributes.Add("class", "Titles attendTitle Links");
            qualityTitle.InnerText = "BQOA";
            qualityTitleLabel.Controls.AddAt(0, qualityTitle);
            qualityTitle.Dispose();
            qualityLinkContainer.Attributes.Add("class", qualityLinkContainer.Attributes["class"].ToString() + " Links");


            //
            //  Initilize the Reporting Tiles App
            //
            reportingTilesLink.ImageUrl = "img/apps.png";
            reportingTilesLink.Height = 50;
            reportingTilesLink.Width = 50;
            reportingTilesLink.Style.Add("style", "padding: 15px;");
            HtmlGenericControl reportingTile = new HtmlGenericControl("span");
            reportingTile.Attributes.Add("class", "Titles attendTitle Links");
            reportingTile.InnerText = "Reporting";
            reportingTilesLabel.Controls.AddAt(0, reportingTile);
            reportingTile.Dispose();
            reportingTilesContainer.Attributes.Add("class", reportingTilesContainer.Attributes["class"].ToString() + " Links");

            //
            // Initilize the APD Link app
            //
            apdPageLink.ImageUrl = "img/MicroStrategy.png";
            apdPageLink.Height = 50;
            apdPageLink.Width = 50;
            apdPageLink.Style.Add("style", "padding: 15px;");
            HtmlGenericControl adpTile = new HtmlGenericControl("span");
            adpTile.Attributes.Add("class", "Titles attendTitle Links");
            adpTile.InnerText = "APD";
            apdLinkTitleLabel.Controls.AddAt(0, adpTile);
            adpTile.Dispose();
            apdLinkContainer.Attributes.Add("class", apdLinkContainer.Attributes["class"].ToString() + " Links");


            //
            // Initilize the FeedbackLink app
            //
            feedbackLink.ImageUrl = "img/feedbackLink.png";
            feedbackLink.Height = 50;
            feedbackLink.Width = 50;
            feedbackLink.Style.Add("style", "padding: 15px;");
            HtmlGenericControl feedbackTile = new HtmlGenericControl("span");
            feedbackTile.Attributes.Add("class", "Titles attendTitle Links");
            feedbackTile.InnerText = "Feedback";
            feedbackLinkTitleLabel.Controls.AddAt(0, feedbackTile);
            feedbackTile.Dispose();
            feedbackLinkContainer.Attributes.Add("class", feedbackLinkContainer.Attributes["class"].ToString() + " Links");

            //
            // Initilize the Rank App
            //
            rankLink.ImageUrl = "img/rank-icon.png";
            rankLink.Height = 50;
            rankLink.Width = 50;
            rankLink.Style.Add("style", "padding: 15px;");
            HtmlGenericControl rankTitle = new HtmlGenericControl("span");
            rankTitle.Attributes.Add("class", "Titles attendTitle Links");
            rankTitle.InnerText = "Rank";
            rankTitleLabel.Controls.AddAt(0, rankTitle);
            rankTitle.Dispose();
            rankLinkContainer.Attributes.Add("class", rankLinkContainer.Attributes["class"].ToString() + " Links");


            //
            //Initilize the Current Users Quick Cards Section
            //
            DataTable teamList = new DataTable();
            DataTable teamDisplay = new DataTable();
            teamList = getCurrentUserTeamList;
            teamDisplay = teamList.Copy();
            teamDisplay.Columns.RemoveAt(1);
            if (teamList.Rows.Count != 0)
            {
                TeamListItems.DataSource = teamDisplay;
                TeamListItems.GridLines = GridLines.None;
                TeamListItems.HeaderStyle.CssClass = "Titles";
                TeamListItems.CssClass = "Links";
                TeamListItems.ShowHeader = false;
                TeamListItems.DataBind();
            }
            else { teamListContainer.Visible = false; }

            for (int i = 0; i < TeamListItems.Rows.Count; i++)
            {
                HyperLink teamLink = new HyperLink();

                teamLink.Text = teamList.Rows[i][0].ToString();
                teamLink.NavigateUrl = url + "?PID=" + teamList.Rows[i][1].ToString();
                TeamListItems.Rows[i].Cells[0].Controls.Add(teamLink);
                TeamListItems.Rows[i].Cells[0].ID = teamList.Rows[i][1].ToString();

            }
            //Cleanup
            teamList.Dispose();
            teamDisplay.Dispose();
            getCurrentUserTeamList.Dispose();
            TeamListItems.ShowHeader = false;

            //Title QuickCardsSection
            HtmlGenericControl teamListTitle = new HtmlGenericControl("span");
            teamListTitle.Attributes.Add("class", "ContainerTitle Titles");
            teamListTitle.InnerText = "Quick Cards";
            TeamListTitleLabel.Controls.AddAt(0, teamListTitle);
            teamListTitle.Dispose();

            //Add home Link to Navigation
            HyperLink homelink = new HyperLink();
            homelink.NavigateUrl = url + "?PID=" + cuser;
            homelink.Text = selUserName;
            homeLinkBack.Controls.AddAt(0, homelink);
            homelink.Dispose();


            //
            // Initilize the Team Cards Section
            //
            DataTable selList = new DataTable();
            DataTable selDisplay = new DataTable();
            selList = getEmpList;
            selDisplay = selList.Copy();
            selDisplay.Columns.RemoveAt(1);
            //Check if the 
            if (selList.Rows.Count != 0)
            {
                selectedListItems.DataSource = selDisplay;
                selectedListItems.GridLines = GridLines.None;
                selectedListItems.ShowHeader = false;
                selectedListItems.CssClass = "Links";
                selectedListItems.DataBind();

            }
            else { selectedListContainer.Visible = false; }

            for (int i = 0; i < selectedListItems.Rows.Count; i++)
            {
                HyperLink selLink = new HyperLink();

                selLink.Text = selList.Rows[i][0].ToString();
                selLink.NavigateUrl = url + "?PID=" + selList.Rows[i][1].ToString();
                selectedListItems.Rows[i].Cells[0].Controls.Add(selLink);
                selectedListItems.Rows[i].Cells[0].ID = selList.Rows[i][1].ToString();

            }
            //  Cleanup
            selList.Dispose(); selList = null;
            selDisplay.Dispose(); selDisplay = null;
            selectedListItems.ShowHeader = false;
            HtmlGenericControl selListTitle = new HtmlGenericControl("span");
            selListTitle.Attributes.Add("class", "ContainerTitle Titles");
            selListTitle.InnerText = "Team Cards";
            selectedListTitleLabel.Controls.AddAt(0, selListTitle);
            selListTitle.Dispose();

            //
            // Caculate The Current Fiscal
            //
            DateTime currentFiscal = new DateTime();
            if (DateTime.UtcNow.AddHours(-5).Day < 29) { currentFiscal = DateTime.UtcNow.AddHours(-5).Date.AddDays(28 - DateTime.UtcNow.AddHours(-5).Day); }
            else { currentFiscal = DateTime.UtcNow.AddHours(-5).Date.AddDays(-1 * (DateTime.UtcNow.AddHours(-5).Day - 28)).AddMonths(1); };


            //
            //  Initilize The Team Data Table
            //  Only when Position Level is greater than 1 (a sup and up)
            //
            if (selectedUserPosLevel != 1 && getTeamRank.Rows.Count > 0)
            {


                TeamDataItems.DataSource = getTeamRank;
                TeamDataItems.GridLines = GridLines.None;
                TeamDataItems.HeaderStyle.CssClass = "Titles";
                TeamDataItems.Attributes.Add("style", "text-align: center;");
                TeamDataItems.CellPadding = 3;
                TeamDataItems.DataBind();

                //Add Team Hyperlinks to indiviudal meCard Pages
                for (int i = 0; i < TeamDataItems.Rows.Count; i++)
                {
                    HyperLink lnk = new HyperLink();
                    lnk.Text = TeamDataItems.Rows[i].Cells[0].Text;
                    lnk.NavigateUrl = url + "?PID=" + getTeamRank.Rows[i][1].ToString();
                    TeamDataItems.Rows[i].Cells[0].Controls.Add(lnk);
                }

                //Title the Section
                HtmlGenericControl teamDataTitle = new HtmlGenericControl("p");
                teamDataTitle.Attributes.Add("class", "Titles ContainerTitle");
                teamDataTitle.InnerText = "Team Rankings - " + currentFiscal.AddMonths(-1).AddDays(1).ToString("MM/dd/yy") + " - " + DateTime.UtcNow.AddHours(-5).ToString("MM/dd/yy");
                teamDataTitle.Style.Add("text-align", "center");
                TeamDataTitleLabel.Controls.AddAt(0, teamDataTitle);
                teamDataTitle.Dispose();

            }
            else { teamDataContainer.Visible = false; }




            //
            //  Initilize the Month over Month section
            //
            // 120920 - Added check if empData Rows != 0
            if (!(currentUserPosLevel == 5 && selectedUserPosLevel == 5))
            {
                DataTable empData = new DataTable();
                empData = getLastandCurrentMetrics;
                empData.Columns[0].ColumnName = "Metrics";



                DateTime lastFiscal = currentFiscal.AddMonths(-1);

                empData.Columns[1].ColumnName = lastFiscal.ToString("MM/dd");
                empData.Columns[2].ColumnName = currentFiscal.ToString("MM/dd");


                for (int i = 0; i < empData.Rows.Count; i++)
                    if (empData.Rows[i][0].ToString() == "Staffed Time")
                        empData.Rows[i].Delete();

                if (empData.Rows.Count != 0)
                {

                    empDataItems.DataSource = empData;
                    empDataItems.DataBind();

                    empDataItems.GridLines = GridLines.None;
                    empDataItems.HeaderStyle.CssClass = "Titles";

                    try
                    {
                        foreach (GridViewRow r in empDataItems.Rows)
                        {
                            if (r.Cells[0].Text == "Staffed Time")
                            {
                                r.Cells[1].Text = String.Format("{0:#,###0}", Convert.ToDecimal(r.Cells[1].Text) / 60);
                                r.Cells[2].Text = String.Format("{0:#,###0}", Convert.ToDecimal(r.Cells[2].Text) / 60);
                                r.Cells[3].Text = String.Format("{0:#,###0}", Convert.ToDecimal(r.Cells[3].Text) / 60);
                            }
                            if (r.Cells[0].Text == "Calls Handled")
                            {
                                r.Cells[1].Text = String.Format("{0:#,###0}", Convert.ToDecimal(r.Cells[1].Text));
                                r.Cells[2].Text = String.Format("{0:#,###0}", Convert.ToDecimal(r.Cells[2].Text));
                                r.Cells[3].Text = String.Format("{0:#,###0}", Convert.ToDecimal(r.Cells[3].Text));
                            }
                            if (r.Cells[0].Text == "Coaching AUX Min")
                            {
                                r.Cells[1].Text = String.Format("{0:#,###0}", Convert.ToDecimal(r.Cells[1].Text));
                                r.Cells[2].Text = String.Format("{0:#,###0}", Convert.ToDecimal(r.Cells[2].Text));
                                r.Cells[3].Text = String.Format("{0:#,###0}", Convert.ToDecimal(r.Cells[3].Text));
                            }
                        }
                    }
                    catch { };
                    empDataItems.ShowHeader = false;

                    HtmlGenericControl empDataTile = new HtmlGenericControl("span");
                    empDataTile.Attributes.Add("class", "Titles ContainerTitle metricTitles");
                    empDataTile.InnerText = "Prev and Current Month Metrics";
                    empDataTitleLabel.Controls.AddAt(0, empDataTile);
                    empDataTile.Dispose();

                    empDataItems.AlternatingRowStyle.BackColor = System.Drawing.ColorTranslator.FromHtml("#3A3B3C");
                    empDataItems.HeaderStyle.BackColor = System.Drawing.ColorTranslator.FromHtml("#3A3B3C");

                }
                else { empDataContainer.Visible = false; };
            }
            else { empDataContainer.Visible = false; }
            //
            //  Create Employee Rank Table
            //
            //  120920 - Added Check if Ranks return a non 0 count
            //  121120 - Added Check if User is Agent return Agents CorPortal Data
            DataTable empRankCopy = new DataTable();
            DataTable empVRRankCopy = new DataTable();

            empRankCopy = getCorPortalRank;
            //empRankCopy = oooData;
            empVRRankCopy = getEmpRank;



            /* 011921 - Can Remove Code File Audit */
            // DataTable empCorandVr = new DataTable();
            // empCorandVr = getCorPortalandVRRanks;


            int pl = selectedUserPosLevel;


            if ((pl == 1 || pl == 2 || pl == 3 || pl == 4) && ahtData.Rows.Count > 0)
            {
                ChartJs empRank = new ChartJs("empRankingChart", empRankCopy);
                ChartJs ahtRank = new ChartJs("empAHTChart", ahtData);
                ChartJs fcrRank = new ChartJs("empFCRChart", fcrData);
                ChartJs vocRank = new ChartJs("empVOCChart", vocData);
                ChartJs compRank = new ChartJs("empCOMPChart", compData);
                ChartJs transRank = new ChartJs("empTRANSChart", transData);
                ChartJs oooRank = new ChartJs("empOOOChart", oooData);
                Page.ClientScript.RegisterStartupScript(this.GetType(), "chartScripts", empRank.LineChart2D("empRankingChart", empRankCopy), true);
                Page.ClientScript.RegisterStartupScript(this.GetType(), "chartScripts3", ahtRank.LineChart2D("empAHTChart", ahtData), true);
                Page.ClientScript.RegisterStartupScript(this.GetType(), "chartScripts4", fcrRank.LineChart2D("empFCRChart", fcrData), true);
                Page.ClientScript.RegisterStartupScript(this.GetType(), "chartScripts5", vocRank.LineChart2D("empVOCChart", vocData), true);
                Page.ClientScript.RegisterStartupScript(this.GetType(), "chartScripts6", compRank.LineChart2D("empCOMPChart", compData), true);
                Page.ClientScript.RegisterStartupScript(this.GetType(), "chartScripts7", transRank.LineChart2D("empTRANSChart", transData), true);
                Page.ClientScript.RegisterStartupScript(this.GetType(), "chartScripts8", oooRank.LineChart2D("empOOOChart", oooData), true);

                DateTime rUD = new DateTime();
                rUD = (DateTime)RankingUpdateData.Rows[0][0];
                DateTime fUD = new DateTime();
                fUD = (DateTime)RankingFCRDateData.Rows[0][0];

                HtmlGenericControl empRankTitle = new HtmlGenericControl("span");
                empRankTitle.Attributes.Add("class", "ContainerTitle Titles");
                empRankTitle.InnerText = "Ranking";
                empRankingTitleLabel.Controls.AddAt(0, empRankTitle);
                empRankTitle.Dispose();
                HtmlGenericControl updatedDate = new HtmlGenericControl("span");
                updatedDate.Attributes.Add("class", "updatedOnText");
                DateTime uD = new DateTime();
                uD = (DateTime)updateDates.Rows[0][0];
                updatedDate.InnerText = "Last updated on: " + uD.ToString("MM/dd/yy");
                updatedDateLabel.Controls.AddAt(0, updatedDate);
                updatedDate.Dispose();
                HtmlGenericControl ahtRankTitle = new HtmlGenericControl("span");
                ahtRankTitle.Attributes.Add("class", "ContainerTitle Titles");
                ahtRankTitle.InnerText = "AHT";
                empAHTTitleLabel.Controls.AddAt(0, ahtRankTitle);
                ahtRankTitle.Dispose();
                HtmlGenericControl ahtUpdateDate = new HtmlGenericControl("span");
                ahtUpdateDate.Attributes.Add("class", "updatedOnText");
                ahtUpdateDate.InnerText = "Last updated on: " + rUD.ToString("MM/dd/yy");
                rankingahtupdatedDateLabel.Controls.AddAt(0, ahtUpdateDate);
                ahtUpdateDate.Dispose();
                HtmlGenericControl fcrRankTitle = new HtmlGenericControl("span");
                fcrRankTitle.Attributes.Add("class", "ContainerTitle Titles");
                fcrRankTitle.InnerText = "FCR";
                empFCRTitleLabel.Controls.AddAt(0, fcrRankTitle);
                fcrRankTitle.Dispose();
                HtmlGenericControl fcrUpdateDate = new HtmlGenericControl("span");
                fcrUpdateDate.Attributes.Add("class", "updatedOnText");
                fcrUpdateDate.InnerText = "Last updated on: " + rUD.ToString("MM/dd/yy") + " through: " + fUD.ToString("MM/dd");
                rankingfcrupdatedDateLabel.Controls.AddAt(0, fcrUpdateDate);
                HtmlGenericControl vocRankTitle = new HtmlGenericControl("span");
                vocRankTitle.Attributes.Add("class", "ContainerTitle Titles");
                vocRankTitle.InnerText = "VOC";
                empVOCTitleLabel.Controls.AddAt(0, vocRankTitle);
                vocRankTitle.Dispose();
                HtmlGenericControl vocUpdateDate = new HtmlGenericControl("span");
                vocUpdateDate.Attributes.Add("class", "updatedOnText");
                vocUpdateDate.InnerText = "Last updated on: " + rUD.ToString("MM/dd/yy");
                rankingvocupdatedDateLabel.Controls.AddAt(0, vocUpdateDate);
                HtmlGenericControl compRankTitle = new HtmlGenericControl("span");
                compRankTitle.Attributes.Add("class", "ContainerTitle Titles");
                compRankTitle.InnerText = "Compliance";
                empCOMPTitleLabel.Controls.AddAt(0, compRankTitle);
                compRankTitle.Dispose();
                HtmlGenericControl compUpdateDate = new HtmlGenericControl("span");
                compUpdateDate.Attributes.Add("class", "updatedOnText");
                compUpdateDate.InnerText = "Last updated on: " + rUD.ToString("MM/dd/yy");
                rankingcompupdatedDateLabel.Controls.AddAt(0, compUpdateDate);
                HtmlGenericControl transRankTitle = new HtmlGenericControl("span");
                transRankTitle.Attributes.Add("class", "ContainerTitle Titles");
                transRankTitle.InnerText = "Transfer";
                empTRANSTitleLabel.Controls.AddAt(0, transRankTitle);
                transRankTitle.Dispose();
                HtmlGenericControl transUpdateDate = new HtmlGenericControl("span");
                transUpdateDate.Attributes.Add("class", "updatedOnText");
                transUpdateDate.InnerText = "Last updated on: " + rUD.ToString("MM/dd/yy");
                rankingtransupdatedDateLabel.Controls.AddAt(0, transUpdateDate);
                HtmlGenericControl oooRankTitle = new HtmlGenericControl("span");
                oooRankTitle.Attributes.Add("class", "ContainerTitle Titles");
                oooRankTitle.InnerText = "Unplanned";
                empOOOTitleLabel.Controls.AddAt(0, oooRankTitle);
                oooRankTitle.Dispose();
                HtmlGenericControl oooUpdateDate = new HtmlGenericControl("span");
                oooUpdateDate.Attributes.Add("class", "updatedOnText");
                oooUpdateDate.InnerText = "Last updated on: " + rUD.ToString("MM/dd/yy");
                rankingoooupdatedDateLabel.Controls.AddAt(0, oooUpdateDate);

            }
            else { carouselMetricControls.Visible = false; }





            //
            //  Create Team Moves Table
            //  Hide if CardUser PosLevel is greater than 1
            //

            if (selectedUserPosLevel == 1)
            {
                teamMovesItems.DataSource = getSupMoves;
                teamMovesItems.GridLines = GridLines.None;
                teamMovesItems.HeaderStyle.CssClass = "Titles";
                teamMovesItems.CellPadding = 3;
                HtmlGenericControl teamMovesTitle = new HtmlGenericControl("span");
                teamMovesTitle.Attributes.Add("class", "ContainerTitle Titles");
                teamMovesTitle.InnerText = "Team Moves";
                teamMovesTitleLabel.Controls.AddAt(0, teamMovesTitle);
                teamMovesTitle.Dispose();
                teamMovesItems.DataBind();
            }
            else { teamMovesContainer.Visible = false; }

            //
            //  Create empInteractions Table
            //
            DataTable empInteractions = new DataTable();
            empInteractions = recentInteractions;
            if (selectedUserPosLevel == 1 && empInteractions.Rows.Count != 0 && empInteractions.Rows.Count != 5)
            {
                empInteractionsItems.DataSource = empInteractions;
                empInteractionsItems.GridLines = GridLines.None;
                empInteractionsItems.HeaderStyle.CssClass = "Titles";
                empInteractionsItems.CssClass = "sortable";
                empInteractionsItems.CellPadding = 3;

                empInteractionsItems.DataBind();
            }
            else { empInteractionsContainer.Visible = false; }

            Session.Add("dt", empInteractions);
            DataTable sheetNames = new DataTable();
            sheetNames.Columns.Add("sheetNames");
            sheetNames.Rows.Add("Employee Interactions");
            Session.Add("sheetNames", sheetNames);


            if (selectedUserPosLevel == 1 || selectedUserPosLevel == 2)
            {
                if (AgentLeadershipNotes.Rows.Count == 0)
                {
                    AgentLeadershipNotes.Rows.Add("", "");
                }
                empNotesContainer.Visible = true;


                if ((currentUserPosLevel >= 3) || cuser == "P0000000" || cuser == "P0000000" || cuser == "P0000000" ||
                cuser == "P0000000" || cuser == "P0000000" || cuser == "P0000000" ||
                cuser == "P0000000" || cuser == "P0000000" || cuser == "P0000000")
                {
                    agentNotesForm.Text = AgentLeadershipNotes.Rows[0][0].ToString();
                    leadershipNotesForm.Text = AgentLeadershipNotes.Rows[0][1].ToString();
                    leadershipNotesContainer.Visible = true;
                    string notesscript = "" +
                        " document.getElementById('saveNotes').addEventListener('click', function(){ " +
                        " var agentNotes = document.getElementById('agentNotesForm').value; " +
                        " var leadershipNotes = document.getElementById('leadershipNotesForm').value; " +
                        " const PID = $.urlParam('PID'); " +
                        " agentNotes = agentNotes.replace('\\n', ' ').replace(';', ' ').replace('<', ' ').replace('>', ' ').replace('\\\\', ' ').replace('{', ' ').replace('}', ' ').replace('[', ' ').replace(']', ' '); " +
                        " document.getElementById('agentNotesForm').value = agentNotes; " +
                        " leadershipNotes = leadershipNotes.replace('\\n', ' ').replace(';', ' ').replace('<', ' ').replace('>', ' ').replace('\\\\', ' ').replace('{', ' ').replace('}', ' ').replace('[', ' ').replace(']', ' '); " +
                        " document.getElementById('leadershipNotesForm').value = leadershipNotes; " +
                        " $('#savingNotesModal').modal('show'); " +
                        " UseCallBack('[agentID]' + PID + '[agentID][agentNotes]' + agentNotes + '[agentNotes][leadershipNotes]' + leadershipNotes + '[leadershipNotes]'); " +
                        " }); ";
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "ntoesscripts", notesscript, true);
                }
                else
                {
                    try { agentNotesForm.Text = AgentLeadershipNotes.Rows[0][0].ToString(); } catch { agentNotesForm.Text = ""; };

                    leadershipNotesContainer.Visible = false;
                    string notesscript = "" +
                    " document.getElementById('saveNotes').addEventListener('click', function(){ " +
                    " var agentNotes = document.getElementById('agentNotesForm').value; " +
                    " const PID = $.urlParam('PID'); " +
                    " agentNotes = agentNotes.replace('\\n', ' ').replace(';', ' ').replace('<', ' ').replace('>', ' ').replace('\\\\', ' ').replace('{', ' ').replace('}', ' ').replace('[', ' ').replace(']', ' '); " +
                    " document.getElementById('agentNotesForm').value = agentNotes; " +
                    //  032422: This method will wipe notes for the Leadership section any time someone below level 3 makes a change;
                    //          The UseCallBack will submit and passthrough a blank, causing the update method to store the blank and overwite
                    //          Any previously logged notes;
                    //          The notes still need to be read and maintained even if the value is not being displayed to the end user
                    //          based on their permissions;
                    // 032822: Updated Default leadershipNotes to be a SPACE, when the space is caught by the query, only the agentNotes section will be updated. 
                    //          This method is used to avoid anyone fiddling around with the CSS of a hidden field to make their leadership notes available. 
                    //          Leadership notes are only available to thoes at Level 3. 
                    " leadershipNotes = 'HIDDEN'; " +
                    " $('#savingNotesModal').modal('show'); " +
                    " UseCallBack('[agentID]' + PID + '[agentID][agentNotes]' + agentNotes + '[agentNotes][leadershipNotes]HIDDEN[leadershipNotes]'); " +
                    " }); ";
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "ntoesscripts", notesscript, true);
                    empNotesContainer.Style.Add("width", "475px");
                }




            }
            else { empNotesContainer.Visible = false; }

            //
            //  Register Page Scripts
            //
            string scripts = "" +
            "document.getElementById(\"attendLinkContainer\").addEventListener(\"click\",function(){ " +
            "window.open('./VID_Attendance.aspx?PID=" + user.selectedUser + "','_blank');});" +
            "document.getElementById(\"uxidLinkContainer\").addEventListener(\"click\",function(){ " +
            "window.open('https://webpage.com/UserProfile?id=" + user.selectedUser + "','_blank');});" +
            "document.getElementById(\"corPortalLinkContainer\").addEventListener(\"click\",function(){ " +
            "window.open('https://webpage.com/main/reports/default.aspx?reports=135','_blank');});" +
            "document.getElementById(\"qualityLinkContainer\").addEventListener(\"click\",function(){ " +
            "window.open('https://webpage.com/NxIA/Portal/Evaluations/Dashboard.aspx','_blank');});" +
            "document.getElementById(\"corPortalCoachLinkContainer\").addEventListener(\"click\",function(){ " +
            "window.open('https://webpage.com/CPO/','_blank');});" +
            "document.getElementById(\"reportingTilesContainer\").addEventListener(\"click\",function(){ " +
            "window.open('https://webpage.com/','_blank');});" +
            "document.getElementById(\"rankLinkContainer\").addEventListener(\"click\",function(){ " +
            "window.open('https://webpage.com/Rankings.aspx/','_blank');});" +
            "document.getElementById(\"apdLinkContainer\").addEventListener(\"click\",function(){ " +
            "window.open('" + apdLink.Rows[0][1].ToString() + "','_blank');});";



            if (currentUserPosLevel != 5)
                Page.ClientScript.RegisterStartupScript(this.GetType(), "startUp", scripts + empFullList, true);
            else
                Page.ClientScript.RegisterStartupScript(this.GetType(), "startUp", scripts + empFullList, true);






            kToolsPH.InnerHtml = k.sQuery(user.cardUserMainQuery);




        }
        else
        {
            Response.Write("" +

             "<html><head>" +
         "<link rel=\"stylesheet\" href=\"./css/bootstrap.min.css\">" +
         "<style>" +
         "body {" +
         "background-color: #003057;" +
         "color: white;" +
         "font-size: 25px;" +
         "}" +
         "</style></head>" +
         "<script>" +
         "function AutoRefresh( t ) {" +
         "               setTimeout(\"location.reload(true);\", t);" +
         "            }" +
         "AutoRefresh(20000);" +
         "</script>" +
         "<body>" +
         "<div style=\"width: 100vw; height: 100vh; text-align: center; padding-top: 100px;\">" +
         "MeCard is Updating....<br/>" +
         "This may take a few minutes. This page will refresh every 20sec and Check for an update.<br/>" +
         "</body></html>" +
               "");
            Response.End();
        };



    }
    private void Page_Error(object sender, EventArgs args)
    {
        //  Pull the error details to variables
        //  Exception pException = Server.GetLastError();
        //  string pUser = User.Identity.Name.Split('\\')[User.Identity.Name.Split('\\').Length - 1];
        //  string pName = Server.HtmlEncode(Request.CurrentExecutionFilePath).ToString().Trim();

        //  Page_Error_logging log = new Page_Error_logging(pUser, pName, pException);
    }


    protected void empDataItemsBind(object sender, GridViewRowEventArgs e)
    {
        /*  Binding PID's as ID's to TR's
         */
        if (e.Row.RowType == DataControlRowType.DataRow && e.Row.RowType != DataControlRowType.EmptyDataRow)
        {

            GridViewRow r = e.Row;
            if (System.Convert.ToInt32(System.Convert.ToChar(r.Cells[1].Text.ToString().Substring(0, 1))) == 38)
                r.Visible = false;




            if (r.Cells[2].Text.Contains("1"))
            {
                if (r.Cells[0].Text.Contains("CA Level"))
                {


                    if (r.Cells[1].Text.Contains("Documented Warning"))
                    {


                        r.Cells[0].Attributes.Add("class", "caLevelDW");
                        r.Cells[1].Attributes.Add("class", "caLevelDW");
                    }
                    else if (r.Cells[1].Text.Contains("Written Warning"))
                    {
                        r.Cells[0].Attributes.Add("class", "caLevelWW");
                        r.Cells[1].Attributes.Add("class", "caLevelWW");
                    }
                    else if (r.Cells[1].Text.Contains("Final Warning"))
                    {
                        r.Cells[0].Attributes.Add("class", "caLevelFW");
                        r.Cells[1].Attributes.Add("class", "caLevelFW");
                    }
                    else { r.Cells[0].Attributes.Add("class", "Titles"); };

                }
                else
                {
                    r.Cells[0].Attributes.Add("class", "Titles");
                }
            }
            else
            {
                r.Cells[0].Attributes.Add("class", "Titles");
            }
            r.Cells[2].Visible = false;
        }
    }

    protected void empDataSpacing(object sender, GridViewRowEventArgs e)
    {
        e.Row.Cells[4].Visible = false;

        if (e.Row.RowType != DataControlRowType.Header)
        {
            if (e.Row.Cells[4].Text == "1")
                e.Row.Cells[3].CssClass = "pVar";
            if (e.Row.Cells[4].Text == "0")
                e.Row.Cells[3].CssClass = "nVar";
        }
        if (e.Row.RowType == DataControlRowType.Header)
            e.Row.Cells[0].Style.Add("text-align", "center");


        e.Row.Cells[0].CssClass = "Titles";

        e.Row.Cells[1].Width = new Unit("75px");
        e.Row.Cells[1].Style.Add("text-align", "center");
        e.Row.Cells[2].Width = new Unit("75px");
        e.Row.Cells[2].Style.Add("text-align", "center");
        e.Row.Cells[3].Width = new Unit("75px");
        e.Row.Cells[3].Style.Add("text-align", "center");

    }



}