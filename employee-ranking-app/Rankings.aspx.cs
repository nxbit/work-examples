using System;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.SessionState;
using System.Data;
using System.Web;




namespace Rankings
{
    public partial class Rankings : System.Web.UI.Page, System.Web.UI.ICallbackEventHandler, IRequiresSessionState
    {
        /* cbVal used to store the CallBack Value, Q_Access stores the current User, updateTime stores the last
            Ranking Update Time in String Format rowClickFiscal, rowClickID, and lvlCb are used in the CallBack */
        string cbVal, Q_Access, updateTime = "", rowClickFiscal = "", rowClickID = "", lvlCb = "", lvl = "";
        
        // Common Page and Parsing Tools Loaded
        KTool k = new KTool();
        MatTools rankingPage = new MatTools();
        Ranking_disp rdisp = new Ranking_disp();
        

        // RaiseCallbackEvent happens when the Page 
        // calls the JS function UseCallBack
        // the eventArgument is the value passed to UseCallBack
        public void RaiseCallbackEvent(string eventArgument)
        {
            DataSet rowCbDs = new DataSet();

            /* Starting off by Setting the Call Back Value to the passed EventArg */
            cbVal = eventArgument;

            /* Parsing out the Fiscal and ID returned from the rowClick Event on the Client Side */
            rowClickFiscal = cbVal.Split(new string[] { "<fiscal>" }, 3, StringSplitOptions.None)[1];
            rowClickID = cbVal.Split(new string[] { "<id>" }, 3, StringSplitOptions.None)[1];
            lvlCb = cbVal.Split(new string[] { "<lvl>" }, 3, StringSplitOptions.None)[1];

            //string q = "declare @psid numeric(10,0); declare @fiscalNom nvarchar(6); declare @sDate date; declare @eDate date; declare @yDate date; declare @uRole int;   set @fiscalNom = '"+rowClickFiscal+"'; set @fiscalNom = ((2000 + cast(right(@fiscalNom,2) as int)) * 100) + case when left(@fiscalNom,3) = 'Jan' then 01 when left(@fiscalNom,3) = 'Feb' then 02 when left(@fiscalNom,3) = 'Mar' then 03 when left(@fiscalNom,3) = 'Apr' then 04 when left(@fiscalNom,3) = 'May' then 05 when left(@fiscalNom,3) = 'Jun' then 06 when left(@fiscalNom,3) = 'Jul' then 07 when left(@fiscalNom,3) = 'Aug' then 08 when left(@fiscalNom,3) = 'Sep' then 09 when left(@fiscalNom,3) = 'Oct' then 10 when left(@fiscalNom,3) = 'Nov' then 11 when left(@fiscalNom,3) = 'Dec' then 12 else 0 end;   set @psid = "+rowClickID+"; set @eDate = datefromparts(left(@fiscalNom,4),right(@fiscalNom,2),28); set @sDate = dateadd(day,1,dateadd(month,-1,@eDate)); set @yDate = dateadd(day,-1,dateadd(hour,-5,getutcdate()));   set @uRole = "+lvlCb+";  ;;with empDates as ( select hdi.SUPPEOPLESOFTID ,case when sw.PREFFNAME is null then sw.FIRSTNAME else sw.PREFFNAME end + ' ' + sw.LASTNAME SupName ,hdi.PEOPLESOFTID ,case when w.PREFFNAME is null then w.FIRSTNAME else w.PREFFNAME end + ' ' + w.LASTNAME EmpName ,format(w.HIREDATE,'MM/dd/yyyy') hiredate ,format(w.TERMINATEDDATE,'MM/dd/yyyy') termDate ,format(case /* when the employee is beyond the  */ when datediff(day,w.HIREDATE,@sDate) > 132 then @sDate when datediff(day,w.HIREDATE,@sDate) <= 132 then case when dateadd(day,132,w.HIREDATE) >= @eDate then null else dateadd(day,132,w.HIREDATE) end else null end,'MM/dd/yyyy') dataSDate   , min(hdi.STARTDATE)sDate   , max(hdi.STARTDATE) eDate ,format(case when w.TERMINATEDDATE is null then @eDate when w.TERMINATEDDATE is not null then case when w.TERMINATEDDATE <= @eDate then w.TERMINATEDDATE else @eDate end else null end,'MM/dd/yyyy') dataEDate from UXID.EMP.Enterprise_Historical_Daily_Indexed hdi with(nolock) inner join UXID.EMP.Workers w with(nolock) on hdi.PEOPLESOFTID = w.NETIQWORKERID inner join UXID.EMP.Workers sw with(nolock) on hdi.SUPPEOPLESOFTID = sw.NETIQWORKERID where case when @uRole = 2 then hdi.SUPPEOPLESOFTID when @uRole = 3 then hdi.MGRPEOPLESOFTID else hdi.SUPPEOPLESOFTID end  = @psid and hdi.STARTDATE between @sDate and @eDate and w.HIREDATE <= @yDate and case when w.TERMINATEDDATE is not null then (case when w.TERMINATEDDATE <= @sDate then 0 else 1 end) else 1 end = 1 and dateDiff(day, w.HIREDATE, hdi.STARTDATE) >= 132 group by hdi.SUPPEOPLESOFTID ,case when sw.PREFFNAME is null then sw.FIRSTNAME else sw.PREFFNAME end + ' ' + sw.LASTNAME ,case when w.PREFFNAME is null then w.FIRSTNAME else w.PREFFNAME end ,w.LASTNAME ,hdi.PEOPLESOFTID ,w.HIREDATE ,w.TERMINATEDDATE ) select d.SupName ,d.EmpName [Employee Name] ,d.PEOPLESOFTID [psid] ,format(d.sDate,'MM/dd/yyyy') [Data from] ,format(d.eDate,'MM/dd/yyyy') [Data to] from empDates d with(nolock) where d.dataSDate is not null;";
            string q = "declare @psid numeric(10,0); declare @fiscalNom nvarchar(6); declare @sDate date; declare @eDate date; declare @yDate date; declare @uRole int;   set @fiscalNom = '" + rowClickFiscal + "'; set @fiscalNom = ((2000 + cast(right(@fiscalNom,2) as int)) * 100) + case when left(@fiscalNom,3) = 'Jan' then 01 when left(@fiscalNom,3) = 'Feb' then 02 when left(@fiscalNom,3) = 'Mar' then 03 when left(@fiscalNom,3) = 'Apr' then 04 when left(@fiscalNom,3) = 'May' then 05 when left(@fiscalNom,3) = 'Jun' then 06 when left(@fiscalNom,3) = 'Jul' then 07 when left(@fiscalNom,3) = 'Aug' then 08 when left(@fiscalNom,3) = 'Sep' then 09 when left(@fiscalNom,3) = 'Oct' then 10 when left(@fiscalNom,3) = 'Nov' then 11 when left(@fiscalNom,3) = 'Dec' then 12 else 0 end;   set @psid = " + rowClickID + "; set @eDate = datefromparts(left(@fiscalNom,4),right(@fiscalNom,2),28); set @sDate = dateadd(day,1,dateadd(month,-1,@eDate)); set @yDate = dateadd(day,-1,dateadd(hour,-5,getutcdate()));   set @uRole = " + lvlCb + ";  ;;with vid_jobRoles as ( 			select 				jr.JOBROLEID 				,jr.JOBROLE 				,jc.JOBCODE 				,jc.TITLE 			from UXID.REF.Job_Roles jr witH(nolock) 			inner join UXID.REF.Job_Code_Job_Roles jcjr with(nolock) 				on jr.JOBROLEID = jcjr.JOBROLEID 			inner join UXID.REF.Job_Codes jc with(nolock) 				on jcjr.JOBCODEID = jc.JOBCODEID 			where 				JOBROLE in 				(case 					when @uRole = 3 then 'Frontline' 					when @uRole = 2 then 'Frontline' 					when @uRole = 5 then 'Lead' 					else 'Lead' 				end) 			group by 				jr.JOBROLEID 				,jr.JOBROLE 				,jc.JOBCODE 				,jc.TITLE 		), empDates as ( 	select 		hdi.SUPPEOPLESOFTID 		,case when sw.PREFFNAME is null then sw.FIRSTNAME else sw.PREFFNAME end + ' ' + sw.LASTNAME SupName 		,hdi.PEOPLESOFTID 		,case when w.PREFFNAME is null then w.FIRSTNAME else w.PREFFNAME end + ' ' + w.LASTNAME EmpName 		,format(w.HIREDATE,'MM/dd/yyyy') hiredate ,format(w.TERMINATEDDATE,'MM/dd/yyyy') termDate 		,format(case /* when the employee is beyond the  */ when datediff(day,w.HIREDATE,@sDate) > 132 then @sDate when datediff(day,w.HIREDATE,@sDate) <= 132 then case when dateadd(day,132,w.HIREDATE) >= @eDate then null else dateadd(day,132,w.HIREDATE) end else null end,'MM/dd/yyyy') dataSDate   		, min(hdi.STARTDATE)sDate   		, max(hdi.STARTDATE) eDate 		,format(case when w.TERMINATEDDATE is null then @eDate when w.TERMINATEDDATE is not null then case when w.TERMINATEDDATE <= @eDate then w.TERMINATEDDATE else @eDate end else null end,'MM/dd/yyyy') dataEDate 	from UXID.EMP.Enterprise_Historical_Daily_Indexed hdi with(nolock) 	inner join UXID.EMP.Workers w with(nolock) 		on hdi.PEOPLESOFTID = w.NETIQWORKERID 	inner join UXID.EMP.Workers sw with(nolock) 		on hdi.SUPPEOPLESOFTID = sw.NETIQWORKERID 	inner join vid_jobRoles v with(nolock) 		on hdi.TITLE = v.TITLE 	where 	case 		when @uRole = 2 then hdi.SUPPEOPLESOFTID 		when @uRole = 3 then hdi.MGRPEOPLESOFTID 		else hdi.SUPPEOPLESOFTID 	end  = @psid 	and hdi.STARTDATE between @sDate and @eDate 	and w.HIREDATE <= @yDate and 		case 			when w.TERMINATEDDATE is not null then (case when w.TERMINATEDDATE <= @sDate then 0 else 1 end) 			else 1 		end = 1 		and dateDiff(day, w.HIREDATE, hdi.STARTDATE) >= 132 	group by 		hdi.SUPPEOPLESOFTID 		,case when sw.PREFFNAME is null then sw.FIRSTNAME else sw.PREFFNAME end + ' ' + sw.LASTNAME 		,case when w.PREFFNAME is null then w.FIRSTNAME else w.PREFFNAME end 		,w.LASTNAME 		,hdi.PEOPLESOFTID 		,w.HIREDATE 		,w.TERMINATEDDATE 		,hdi.TITLE ) 		 		 	select 		d.SupName 		,d.EmpName [Employee Name] 		,d.PEOPLESOFTID [psid] 		,format(d.sDate,'MM/dd/yyyy') [Data from] 		,format(d.eDate,'MM/dd/yyyy') [Data to] 	from empDates d with(nolock) 		where d.dataSDate is not null 	order by 1, 2, 4 desc";

            /* Grabbing the DataSet retuned from the parsed rowClick Values */
            rowCbDs = k.returnDataSetNew(q);
            /* Setting the cbValue as a JSON var wrapped in a id tableOne, tableTwo tag */
            cbVal = "<tableOne>" + k.rnkDTToJSON(rowCbDs.Tables[0]) + "<tableOne>";
            rowCbDs.Dispose();
        }
        // GetCallbackResult happens when the value is returned back to the 
        // page. This will hardly ever be modified as the callBack Value is 
        // ususally the value needing for a call Back
        public string GetCallbackResult()
        {
            return cbVal;
        }

        
        /*################## SQL Connections and Queries ##################*/

        public DataSet getRankData(string lvl, string byMonth)
        {
            string query = "";
            if (byMonth == "1")
                query = k.ReadFromFile("\\\\ausccoweb01\\RegStatsDotNet\\query\\RankingDisplayQueryV2MetricByMonth_New.sql");
            else
                query = k.ReadFromFile("\\\\ausccoweb01\\RegStatsDotNet\\query\\RankingDisplayQueryV2_New.sql");
            query = query.Replace("POSITIONLEVEL", lvl);
            return k.returnDataSetNew(query);

        }



        protected void Page_Load(object sender, EventArgs e)
        {

            if (false)
            {
                Response.Write("" +

                  "<html><head>" +
                  "<link rel=\"stylesheet\" href=\"css/bootstrap.min.css\">" +
                  "<style>" +
                  "body {" +
                  "background-color: #FFFFFF;" +
                  "color: #000000;" +
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
                  "Rankings will be postponed until 7/10/23.<br/>" +
                  "</div>" +
                  "</body></html>" +
                    "");
                Response.End();
            }

            //CallBack Functions
            string cbref = Page.ClientScript.GetCallbackEventReference(this, "arg", "JSCallback", "context");
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "UseCallBack", "function UseCallBack(arg, context){" + cbref + ";}", true);

           

                /* Setting Gate for Page Premissions */
               // RegStats_MIG gate;
               // gate = new RegStats_MIG();
                Q_Access = rankingPage.Q_Access;

                /* Locations for URL Parameters */
                lvl = "";
                string bidRank = "";
                string fMonth = "";
                string mbyMonth = "\\";

                


                /*################## Check for Site Premissions ##################*/
                if (true)
                {
                    //Adding Ranking Definitions Modal to the page
                    rankDef.Controls.Add(rdisp.rnkDef());

                    //Grab the Requested Level from URL    
                    if ((!String.IsNullOrEmpty(Request.QueryString["lvl"])) || (!String.IsNullOrEmpty(Request.QueryString["lvl"])))
                        lvl = k.parseString(Request.QueryString["lvl"].ToString());
                    else
                        lvl = "\\";
                    //If the User is a Lead, their only Lvl Value to pass is Lead = 4
                    if (lvl == "\\")
                        lvl = "2";
                    if (k.getUserTitle(Q_Access).Contains("Lead"))
                        lvl = "4";

                    //If the BidRank Value was set grab the Requested month From URL
                    if (((!String.IsNullOrEmpty(Request.QueryString["fMonth"])) || (!String.IsNullOrEmpty(Request.QueryString["fMonth"]))) && bidRank != "\\")
                        fMonth = Request.QueryString["fMonth"].ToString();
                    else
                        fMonth = "\\";

                    //If the byMonth Flag is set, the by Month view will be returned
                    if ((!String.IsNullOrEmpty(Request.QueryString["bMonth"])) || (!String.IsNullOrEmpty(Request.QueryString["bMonth"])))
                        mbyMonth = Request.QueryString["bMonth"].ToString();
                    else
                        mbyMonth = "\\";

                    rType.Value = lvl;

                    /*==================================================
                     * rnk - Stores the DataSet Returned from ranking Display Query
                     * colMaps - Stores the Column Mapping and used to create the context "collapse and expand" menus
                     * rData - Stores the Ranking Data
                     * wTable - Stores the Weighted Ranks
                     * uTable - Stores Data Update Dates for Display
                     ==================================================*/
                    DataSet rnk = getRankData(lvl, mbyMonth);
                    DataTable colMaps = new DataTable();
                    DataTable rData = new DataTable();
                    DataTable wTable = new DataTable();
                    DataTable uTable = new DataTable();

                   

                    colMaps = rnk.Tables[0].Copy();
                    rData = rnk.Tables[1].Copy();
                    wTable = rnk.Tables[2].Copy();
                    uTable = rnk.Tables[3].Copy();
                    //Setting Global Update Time
                    DateTime dt = new DateTime();
                    DateTime.TryParse(uTable.Rows[0][1].ToString(), out dt);
                    //Updated Date to Convert From UTC Time. 
                    updateTime = dt.AddHours(-5).ToShortDateString();
                    string url = Request.Url.AbsoluteUri;
                    if(url.IndexOf("?") != -1)
                        url = url.Substring(0,url.IndexOf("?"));
                    navBar.Controls.Add(rdisp.createNavBar(k.getUserTitle(Q_Access),url,updateTime));
                    updateDatesTbl.DataSource = uTable;
                    updateDatesTbl.DataBind();
                    rnk.Dispose();

                    /*=======================================================
                     * Looping though the rData Columns and adding in the metricShortName to the Column Name
                     =======================================================*/
                    foreach (DataColumn c in rData.Columns)
                    {
                        foreach (DataRow r in colMaps.Rows)
                        {
                            if (c.ColumnName == r["colNumber"].ToString())
                            {
                                c.ColumnName = r["metricShortName"].ToString();
                            }
                        }
                    }

                    /*========================================================
                     * fMonthView used to grab a DT with unique Fiscal Months
                     * Will be used to crate the context menus
                     ========================================================*/
                    DataView fMonthView = new DataView(colMaps);
                    DataTable fMonthsVals = fMonthView.ToTable(true, "fiscalMth");
                    DataTable mDisplayVals = fMonthView.ToTable(true, "metricDisplayName");


                    DataTable fMonthsDates = new DataTable();
                    fMonthsDates.Columns.Add("fMonths", DateTime.UtcNow.AddHours(-5).GetType());
                    DateTime pMonth = new DateTime();
                    foreach (DataRow r in fMonthsVals.Rows)
                    {
                        DataRow nr = fMonthsDates.NewRow();
                        DateTime.TryParse(r[0].ToString().Substring(4, 2) + "/1/" + r[0].ToString().Substring(0, 4), out pMonth);


                        nr[0] = pMonth;
                        fMonthsDates.Rows.Add(nr);

                    }

                    string tabCol = null;
                    string jsonString = null;
                

                    /*====================================================================
                        *  Building up Tabulator Columns JSON object
                        * 
                        =====================================================================*/
                    tabCol = "var colLayout = [";
                    tabCol += " {title: \"" + k.posLvlNumToName(lvl) + " Info\", frozen:true, ";
                    tabCol += " columns:[{ title: \"Site\", field: \"stateCity\", sorter: \"string\", sorterParams: { alignEmptyValues: \"bottom\"}, headerFilter:\"input\" }, ";
                    if (lvl == "3")
                    {
                        tabCol += " { title: \"Director\", field: \"supName\", headerFilter:\"input\" }, ";
                        tabCol += " { title: \"Manager\", field: \"empName\", headerFilter:\"input\" }, ";
                    }
                    else if (";2;5;".Contains(";"+lvl+";"))
                    {
                        tabCol += " { title: \"Director\", field: \"mgrName\", headerFilter:\"input\" }, ";
                        tabCol += " { title: \"Manager\", field: \"supName\", headerFilter:\"input\" }, ";
                        tabCol += " { title: \"Supervisor\", field: \"empName\", headerFilter:\"input\" }, ";
                    }
                    else
                    {
                        tabCol += " { title: \"Manger\", field: \"mgrName\", headerFilter:\"input\" }, ";
                        tabCol += " { title: \"Supervisor\", field: \"supName\", headerFilter:\"input\" }, ";
                        tabCol += " { title: \"Employee\", field: \"empName\", headerFilter:\"input\" }, ";
                    }
                    tabCol += " { title: \"HR Number\", field: \"id\", headerFilter:\"input\", visible:\"false\"}], ";
                    tabCol += " }, ";

                    /*=====================================================================
                        * Building up the Tabulator context Menu JSON objects
                        * 
                        ======================================================================*/
                    string tabConMnu = "";
                    string tabConExp = "";
                    string tabConColl = "";

                    if (mbyMonth == "1")
                    {
                        metricByMonth.InnerText = "Month by Metric";
                        guideText.Visible = false;
                        //foreach(DataRow r in fMonthsVals.Rows)
                        for (int a = 0; a < mDisplayVals.Rows.Count; a++)
                        {
                            //Starting the Fiscal Mth Data Groups
                            tabCol += "{title: \"" + mDisplayVals.Rows[a][0].ToString() + "\",  headerTooltip:\"Right Click to Expand/Collapse\", columns:[";
                            //Starting the Fiscal Mth Context Menus

                            for (int i = 0; i < colMaps.Rows.Count; i++)
                            {
                                if (colMaps.Rows[i][2].ToString() == mDisplayVals.Rows[a][0].ToString())
                                {
                                    if (!colMaps.Rows[i]["metricShortName"].ToString().Contains("Rank"))
                                        //Adding the Data Points to Fiscal Group
                                        tabCol += " { title: \"" + colMaps.Rows[i]["metricShortName"].ToString().Replace(mDisplayVals.Rows[a][0].ToString(), "") + "\", field: \"" + colMaps.Rows[i]["metricShortName"].ToString() + "\", sorter: \"number\", sorterParams: { alignEmptyValues: \"bottom\"}}, ";
                                }
                            }

                            tabCol += "],},";
                        }
                        tabCol += "];";
                    }
                    else
                    {
                        guideText.Visible = true;
                        for (int a = 0; a < fMonthsVals.Rows.Count; a++)
                        {


                            string fMonthName = k.monthNumToName(fMonthsVals.Rows[a][0].ToString().Substring(4, 2)) + " " + fMonthsVals.Rows[a][0].ToString().Substring(2, 2);



                            //Starting the Fiscal Mth Data Groups
                            tabCol += "{title: \"" + fMonthName + "\", headerTooltip:\"Right Click to Expand/Collapse\", headerContextMenu:contextMenu" + fMonthsVals.Rows[a][0].ToString() + "  , columns:[";
                            //Starting the Fiscal Mth Context Menus
                            tabConColl = " var contextMenu" + fMonthsVals.Rows[a][0].ToString() + " = [{ label:\"Collapse\", action:function(e, column){ rDataTable.blockRedraw(); ";
                            tabConExp = "}},{ label:\"Expand\", action:function(e, column){ rDataTable.blockRedraw();";
                            for (int i = 0; i < colMaps.Rows.Count; i++)
                            {
                                if (colMaps.Rows[i][0].ToString() == fMonthsVals.Rows[a][0].ToString())
                                {
                                    if (colMaps.Rows[i]["metricDisplayName"].ToString() != "Rank" && colMaps.Rows[i]["metricDisplayName"].ToString() != "Rank Pct")
                                    {
                                        //Adding the Data Points to Fiscal Group
                                        tabCol += " { title: \"" + colMaps.Rows[i]["metricDisplayName"].ToString() + "\", field: \"" + colMaps.Rows[i]["metricShortName"].ToString() + "\", sorter: \"number\", sorterParams: { alignEmptyValues: \"bottom\"}, visible: false }, ";
                                        //Building both Collapse and Expand JSON  Objects
                                        tabConColl += "rDataTable.hideColumn(\"" + colMaps.Rows[i]["metricShortName"].ToString() + "\");";
                                        tabConExp += "rDataTable.showColumn(\"" + colMaps.Rows[i]["metricShortName"].ToString() + "\");";
                                    }
                                    else
                                    {
                                        //Adding the Data Points to Fiscal Group
                                        tabCol += " { title: \"" + colMaps.Rows[i]["metricDisplayName"].ToString() + "\", field: \"" + colMaps.Rows[i]["metricShortName"].ToString() + "\",headerTooltip:\"Right Click to Expand/Collapse\", sorter: \"number\", sorterParams: { alignEmptyValues: \"bottom\"} }, ";
                                    }
                                }
                            }
                            //Appending the Tabulator Context Menu Object to the main Context Menu
                            tabConMnu += tabConColl + "rDataTable.restoreRedraw(); " + tabConExp + " rDataTable.restoreRedraw();}},]; ";
                            //Clear the Sub Context Parts before next loop
                            tabConColl = "";
                            tabConExp = "";
                            tabCol += "],},";
                        }
                        tabCol += "];";

                    }







                    string expBtnJS = "";
                    expBtnJS += " $('#dlowcsv').click(function(){  ";
                    expBtnJS += " $('#exportModal').modal('show'); ";
                    expBtnJS += " }); ";
                    expBtnJS += " $('#exportMonthBtn').click(function(){  ";
                    expBtnJS += "    var radioInputs = $('input:checkbox:checked'); ";
                    expBtnJS += "    var i = 0; ";
                    expBtnJS += "    var mString = \"\"; ";
                    expBtnJS += "    radioInputs.each(function(){ ";
                    expBtnJS += "        if($(this).attr('id') != 'newHireToggle' && $(this).attr('id') != 'SiteRankToggle' && $(this).attr('id') != 'nhCheckBox') ";
                    expBtnJS += "        { ";
                    expBtnJS += "            if(i == (radioInputs.length -1)) ";
                    expBtnJS += "                mString += \"m\"+i+\"=\"+$(this).attr('id'); ";
                    expBtnJS += "            else ";
                    expBtnJS += "                mString += \"m\"+i+\"=\"+$(this).attr('id')+\"&\"; ";
                    expBtnJS += "            i += 1; ";
                    expBtnJS += "        } ";
                    expBtnJS += "    }); ";
                    expBtnJS += "    var rt = $('#rType').val(); ";
                    expBtnJS += "    var nhChkBox = $('#nhCheckBox').is(':checked'); ";
                    expBtnJS += "    if(!nhChkBox) ";
                    expBtnJS += "        window.open(\"https://repairreporting.corp.chartercom.com/RankingDataExport_New.ashx?rType=\"+rt+\"&\"+mString); ";
                    expBtnJS += "    else ";
                    expBtnJS += "        if(rt = 'Sup') ";
                    expBtnJS += "            window.open(\"https://repairreporting.corp.chartercom.com/RankingDataExport_New.ashx?rType=\"+rt+\"&nhBox=True&\"+mString); ";
                    expBtnJS += "        else ";
                    expBtnJS += "            window.open(\"https://repairreporting.corp.chartercom.com/RankingDataExport_New.ashx?rType=\"+rt+\"&nhBox=True&\"+mString); ";
                    expBtnJS += " }); ";

                    if (k.isGVPOps(Q_Access))
                        expBtnJS += " rDataTable.setHeaderFilterValue(\"stateCity\",\"" + k.getUserStateCity(Q_Access) + "\"); ";

                    jsonString = k.rnkDTToJSON(rData);
                    rData.Dispose();

                    Page.ClientScript.RegisterStartupScript(this.GetType(), "exportBtn", expBtnJS, true);

                    if (mbyMonth == "\\")
                        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "contextMenu", tabConMnu, true);
                    /* Registering the Column Layout JSON objects */
                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "colLayout", tabCol, true);
                    /* Registering the Rank Data as JSON objects */
                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "rnkData", " var rData = " + jsonString + ";", true);

                    
                   

                    colMaps.Dispose();


                    wTableAsp.DataSource = wTable;
                    wTableAsp.HeaderStyle.CssClass = "wTHeader";
                    wTableAsp.DataBind();


                    string monthSel = "";
                    monthSel += " <button type=\"button\" id=\"monSelAll\" class=\"btn btn-light\">Select All</button> ";
                    monthSel += " <button type=\"button\" id=\"monClearAll\" class=\"btn btn-light\">Clear All</button> ";
                    //Populating Inputs for Ranking Selections
                    foreach (DataRow r in fMonthsDates.Rows)
                    {

                        monthSel += " <div class=\"input-group\"> ";
                        monthSel += " <div class=\"input-group-prepend\"> ";
                        monthSel += " <div class=\"input-group-text monthSelBox\"> ";
                        monthSel += " <input type=\"checkbox\" id=\"" + DateTime.Parse(r[0].ToString()).ToString("yyyyMM") + "\" name=\"" + DateTime.Parse(r[0].ToString()).ToString("yyyyMM") + "\" aria-label=\"" + DateTime.Parse(r[0].ToString()).ToString("yyyyMM") + "\" checked /> ";
                        monthSel += " </div> ";
                        monthSel += " &nbsp;&nbsp;&nbsp;&nbsp;" + DateTime.Parse(r[0].ToString()).ToString("MMMM yy") + " ";
                        monthSel += " </div> ";
                        monthSel += " </div> ";
                    }
                    monthSelectionDD.InnerHtml = monthSel;




                }
                else
                {
                    //  When not granted access to the page, show an alert advising to email for access;
                   // Response.Write("Network ID: " + gate.myLAN + " does not have rights to view the Rankings.  If you believe this is in error, please email DL-Video-Repair-Reporting");
                   // Response.End();
                }

        } // End of Page Load

        private void Page_Error(object sender, EventArgs args)
        {

            //  Pull the error details to variables
            Exception pException = Server.GetLastError();
            string pUser = User.Identity.Name.Split('\\')[User.Identity.Name.Split('\\').Length - 1];
            string pName = Server.HtmlEncode(Request.CurrentExecutionFilePath).ToString().Trim();

           // Response.Write(Server.GetLastError());
           // Response.End();

            Page_Error_logging log = new Page_Error_logging(pUser, pName, pException, lvl);
        }


        protected void wTableAsp_RowCreated(object sender, GridViewRowEventArgs e)
        {
            TableCell c = new TableCell();
            for (int i = 0; i < e.Row.Cells.Count; i++)
            {
                c = e.Row.Cells[i];
                if (i == 0)
                    c.CssClass = "WRowHeader";
            }
        }

        protected void updateDatesTbl_RowCreated(object sender, GridViewRowEventArgs e)
        {
            GridViewRow r = e.Row;

            if (r.RowType == DataControlRowType.Header)
                r.CssClass = "uTableHeader";

            TableCellCollection c = r.Cells;
            for (int i = 0; i < c.Count; i++)
            {
                if (i != 0)
                    c[i].CssClass = "uTableDataPoint";
            }


        }

    }
}