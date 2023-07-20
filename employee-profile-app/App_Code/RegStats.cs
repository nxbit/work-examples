using System;
using System.Web;
using System.Web.UI;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// Summary description for RegStats
/// Manages the page security hosted in the .NET version of the RegStats namespace.
/// </summary>
public class RegStats
{

    //!!!!!!!!!!!!!!!!!!!!!!!!!!!! Paths, IPs, any anything identifiable has been hidden !!!!!!!!!!!!!!!!!!!!!!!!!!!! //

    
    public string myLAN = HttpContext.Current.User.Identity.Name.Split('\\')[HttpContext.Current.User.Identity.Name.Split('\\').Length - 1];
    public bool myAuth = HttpContext.Current.User.Identity.IsAuthenticated;
    public string myName = "";
    public string myJob = "";
    public string myRegion = "";
    public bool newTrend;
    public bool result;
    public Page p = (Page)HttpContext.Current.Handler;
    public string pageName = "";
    //Page value is set at 6 hours, in minutes
    public int pTimeout = 360;
    //Security value is set at 10 min, in seconds
    public int sTimeout = 600;
    public int pageVisit = 1;

    public void Validate()
    {
        //  Initialize again as needed; Don't overwrite a value if it can be fed a value from the consturctor logic;
        myLAN = (myLAN.Length == 0 ? HttpContext.Current.User.Identity.Name.Split('\\')[HttpContext.Current.User.Identity.Name.Split('\\').Length - 1] : myLAN);
        myAuth = (!myAuth? HttpContext.Current.User.Identity.IsAuthenticated : myAuth);
        myName = "";
        myJob = "";
        myRegion = "";
        p = (p == null ? (Page)HttpContext.Current.Handler : p);
        //Page value is set at 6 hours, in minutes
        pTimeout = 360;
        //Security value is set at 10 min, in seconds
        sTimeout = 600;
        pageVisit = 1;

        result = false;

        //Since using session variable to avoid logging page refreshes, set Session timeout to high value
        p.Session.Timeout = pTimeout;
        //Parse and store page name for use in logging and security check
        if (pageName.Equals(""))
        {
            pageName = p.Server.HtmlEncode(p.Request.CurrentExecutionFilePath).ToString();
            pageName = pageName.Substring(1, pageName.Length - 1).ToLower();
        }
        //Validate session for original value if first page opens this session
        if (String.IsNullOrEmpty((string)p.Session["regstats_pageName"]) || String.IsNullOrWhiteSpace((string)p.Session["regstats_pageName"]))
            p.Session["regstats_pageName"] = "";
        if (String.IsNullOrEmpty((string)p.Session["regstats_pageFound"]) || String.IsNullOrWhiteSpace((string)p.Session["regstats_pageFound"]))
            p.Session["regstats_pageFound"] = "";
        if (String.IsNullOrEmpty((string)p.Session["regstats_VResult"]) || String.IsNullOrWhiteSpace((string)p.Session["regstats_VResult"]))
            p.Session["regstats_VResult"] = "";
        if (String.IsNullOrEmpty((string)p.Session["regstats_LastCheck"]) || String.IsNullOrWhiteSpace((string)p.Session["regstats_LastCheck"]))
            p.Session["regstats_LastCheck"] = "";

        //Once initialized or confirmed to already have value, check for whether this is the first open of this page and store result.
        Boolean doLogging = !p.IsPostBack && !p.IsCallback && (!String.Equals(p.Session["regstats_pageName"].ToString(), pageName));
        //
        //  An extra fact check to make sure the logging is refreshed when expected, the the original logging is false
        //  and a timestamp is available, check the interval since the last logged check.
        //
        DateTime LastCheck;
        if (!doLogging && (DateTime.TryParse(p.Session["regstats_LastCheck"].ToString(), out LastCheck)))
            if (DateTime.Compare(LastCheck.AddSeconds(sTimeout), DateTime.UtcNow.AddHours(-5)) > 0)
                doLogging = true;
        //
        //  Check to make sure the logging is refreshed if the session variables timeout or wipe out for some reason.
        //  If a time is not available, and the logging is not already set to run, run the security.
        //
        if (!doLogging && (p.Session["regstats_LastCheck"].ToString() == ""))
            doLogging = true;
        
        //Update the session to the current page
        p.Session["regstats_pageName"] = pageName;

        //Initialize the profile lookups
        //
        //  Lookup logic is formatted to return a standard datatable whether security is in place for the page or not.
        //  The format allows for standard tracking even if there is no security
        //
        //  The logic itself is staged to only revalidate a user against Sentry if the timeout threshold (int sTimeout) is less than the last time the user was validated.
        //  In that instance the last logged validation is used.
        //
        //  The idea being, between the validation above to ignore postbacks and the validation here to avoid SQL overhead, the security should be as clean as possible.
        //
        string qryExLog = "SET NOCOUNT ON;DECLARE @pageLogic1 varchar(6000);DECLARE @myLAN varchar(20);DECLARE @pageName varchar(50);DECLARE @sLimit int;DECLARE @pageVisit bit;SET @myLAN = '" + myLAN + "';SET @pageName ='" + pageName + "';/*Confirm Timeout in seconds*/SET @sLimit = " + sTimeout.ToString() + ";/*Set the flag for page visit*/;SET @pageVisit = " + pageVisit.ToString() + ";IF ((SELECT ISNULL(DATEDIFF(s,(SELECT TOP 1 VStamp FROM Database.schema.RegStats_Tracking v with(nolock) WHERE PageUser=@myLAN and pageName=@pageName and pageVisit=@pageVisit ORDER BY VStamp DESC),DATEADD(hh,-5,GETUTCDATE())),@sLimit)) >= @sLimit) BEGIN SET @pageLogic1='';SET @pageLogic1 = @pageLogic1 + 'IF OBJECT_ID(''tempdb..#r_Val'') IS NOT NULL BEGIN DROP table #r_Val END;';SET @pageLogic1 = @pageLogic1 + 'DECLARE @myLAN varchar(20);';SET @pageLogic1 = @pageLogic1 + 'DECLARE @pageName varchar(50);';SET @pageLogic1 = @pageLogic1 + 'DECLARE @pageFound bit;';SET @pageLogic1 = @pageLogic1 + 'DECLARE @pageVisit bit;';SET @pageLogic1 = @pageLogic1 + 'SET @myLAN = '''+@myLAN+''';';SET @pageLogic1 = @pageLogic1 + 'SET @pageName = '''+@pageName+''';';SET @pageLogic1 = @pageLogic1 + 'SET @pageFound = (SELECT COUNT(*) FROM Database.schema.RegStats_Validation v with(nolock) WHERE pageName=@pageName);';SET @pageLogic1 = @pageLogic1 + 'SET @pageVisit = '+CAST(@pageVisit as varchar(1))+';';SET @pageLogic1 = @pageLogic1 + '';SET @pageLogic1 = @pageLogic1 + CASE WHEN (SELECT COUNT(*) FROM Database.schema.RegStats_Validation v with(nolock) WHERE pageName=@pageName) = 0 THEN 'INSERT INTO Database.schema.RegStats_Tracking '+ 'SELECT @myLAN PageUser,@pageName PageName,@pageFound PageFound,DATEADD(hh,-5,GETUTCDATE()) VStamp, COUNT(*) VResult, @pageVisit pageVisit ' ELSE ISNULL((SELECT logic FROM Database.schema.RegStats_Validation v with(nolock) WHERE pageName=@pageName),'') END;/*PRINT @pageLogic1*/EXEC(@pageLogic1);END;SELECT TOP 1 * FROM Database.schema.RegStats_Tracking t with(nolock) where PageUser=@myLAN and PageName=@pageName order by VStamp desc;";
        string ignoreList = "ChannelYou_RestrictedLinks.aspx;ChannelYou_PublicLinks.aspx;avayavalidation.aspx;careopsmaintest2.aspx;careopsmain.aspx;wf_profiler_validationtest.aspx;EZCRescues.aspx;vdntrace.aspx;";

        
        //  All logic is placed inside this validation to reduce overhead in using the page during refreshes and postbacks
        //  Validate the logging via the qualifiers bookmarked in IE
        if (doLogging)
        {
            //Access management will route through RTXCare and will also house the logging tables
            CONNECTIONCLASS secSql = new CONNECTIONCLASS();

            DataTable profile = new DataTable();
            secSql.CreateConn();
            SqlDataAdapter secAdapter = new SqlDataAdapter(qryExLog, secSql.Connection);
            //Confirm the sql statement is populated, and if so make sure the command timeout value is set at 10 min as needed.
            if (secAdapter.SelectCommand != null)
                secAdapter.SelectCommand.CommandTimeout = 600;
            secAdapter.Fill(profile);
            secSql.CloseConn();
            secAdapter.Dispose();


            p.Session["regstats_pageFound"] = profile.Rows[0][2].ToString();
            p.Session["regstats_VResult"] = profile.Rows[0][4].ToString();
            p.Session["regstats_LastCheck"] = profile.Rows[0][3].ToString();

            //----------------------------------------------------------------
            //          Items in this section will handle the message 
            //          and denial behaviors for each page.

            //----------------------------------------------------------------

            //Clean up
            profile.Dispose();
        }
        if(p.Session["regstats_VResult"].ToString() != "")
            bool.TryParse(p.Session["regstats_VResult"].ToString().Replace("1","true").Replace("0","false"), out result);

        if ("E038723;".Contains(myLAN))
        {
            if (!ignoreList.ToLower().Contains(pageName.ToLower()+";"))
            {
                //When admin looking at the page show a summary of security notes so far.
                //p.Response.Write("-----------------<br>Page Found: " + p.Session["regstats_pageFound"].ToString() + "<BR>Result: " + p.Session["regstats_VResult"].ToString() + "<BR>");
                //p.Response.Write("-----------------<BR>Stored Result: " + result.ToString() + "<BR>");
                //p.Response.Write("-----------------<BR>Last Checked: " + p.Session["regstats_LastCheck"].ToString() + "<BR>");
            }
        }
        //---------------------------------------------------
    }
    
    public RegStats()
	{
		//
		// TODO: Add constructor logic here
		//
        Validate();
	}
}