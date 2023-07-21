<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Rankings.aspx.cs" Inherits="Rankings.Rankings" EnableEventValidation="true" Debug="true" %>



<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Rankings</title>
    <!--Stylesheet and Script for bootstrap-->
    <link rel="stylesheet" href="css/tabulator.min.css" />
    <link rel="stylesheet" href="css/bootstrap.min.css" /> 
    <link rel="stylesheet" href="css/Ranking.css" />
    <style>
        .modal-open .modal{
            overflow-x: auto;
            
        }
        .weightInfo{
            width: fit-content;
        }
        .wTHeader{
            font-size: small;
        }
        .WRowHeader{
            font-weight: bold;
            white-space: nowrap;
            width: fit-content;
            font-size: small;
        }
        .table td, .table th{
            padding: 5px;
        }
        .uTableDataPoint{
            text-align: center;
        }
        .lookBackTableHeaderFirst{
            width: 150px;
            font-size: 14px;
            font-weight:600;
        }
        .lookBackTableHeader{
            font-size: 14px;
            font-weight: 600;
            padding-left: 6px;
            padding-right: 25px;
        }
        .lookBackTable{
            font-size: 12px;
        }
       
        
        .lookBackTable tr:nth-child(even){
            background-color: lightgrey;
        }
        .lookBackTable tr:nth-child(odd){
            background-color: darkgrey;
        }
    </style>

</head>
    
<!-- Opening of the of Ranking Body -->
<body id="rankingBodyTag" runat="server" >
    <form id="rankingMainBody" runat="server">


<!--==================================================================================================== 
            NAVBAR PLACEHOLDER
=========================================================================================================-->
    <asp:PlaceHolder ID ="navBar" runat="server" /> 
        


    <div id="MainPage" style="width: 100vw; height: calc(100vh - 132px);">
        <br />
        <!-- Opening of the Table Body -->
        <div id="TableBody">
        <!--==================================================================================================== 
                    RANKING TOP MENU
        =========================================================================================================-->
        <div id="subMenuBar" style="display: inline-block; min-width: 1134px; padding: 4px; background-color: #E8E8E8; width: 100%; border-bottom:1px solid #AAAAAA; border-top-left-radius: 10px; border-top-right-radius: 10px; padding-left: 10px; float:left;">
            
            <div class="grid-child" style="text-align: left; display:inline-block;">
                <p id="RankTitle">Site Ranks by Month    <sub id="guideText" runat="server">*right click month to expand/collapse</sub></p>
                <!-- Leaving this Toggle Object Just incase becomes handy to hook too 
                    Is Not Visable on Page-->
                <div id="newHireToggleMain" class="custom-control custom-switch newHireToggle">
                    <input type="checkbox" class="custom-control-input" id="newHireToggle" checked="checked"/>
                    <label class="custom-control-label" for="newHireToggle">Include New Hires</label>
                </div> 

            </div>

            <div class="grid-child" style="display:inline-block; float: right;">
                <button type="button" class="btn btn-secondary btn-sm" id="metricByMonth" runat="server">Metrics by Month</button>
                Exports:
                <button type="button" class="btn btn-secondary btn-sm" id="dlowcsv" runat="server">Export</button>
            </div>
        </div>
        
        <!--    loading Modal is triggred by Tabulators startRender Call Back and its turned off when the renderComplete is called.
                also can be called simply by doing display.block...
            
             -->

        <div id="loading" runat="server">
            <div style="margin: 0; position: absolute; top: 50%; left: 50%; -ms-transform: translate(-50%, -50%); transform: translate(-50%, -50%);"> 

                <span id="loadingMsg" style="background-color: rgba(255,255,255,0.8); font-weight:900; color: #000000; padding: 10px; border-radius: 5px;">Loading Rank</span>

            </div>
        </div>

        <!--==================================================================================================== 
                    RANKING MAIN TABLE SECTION
        =========================================================================================================-->
        <div id="rankListTable" style="width: 100%; min-width: 1134px; height: calc(100vh - 162px); background-color: #343A40;">
            
        </div>
    </div>                        
</div>
 


<!--==================================================================================================== 
                RANKING AND METRIC DEFINITIONS PAGE
=========================================================================================================-->
<asp:PlaceHolder ID="rankDef" runat="server"></asp:PlaceHolder>
<!--<asp:PlaceHolder ID="metricModal" runat="server"></asp:PlaceHolder>-->

<!--==================================================================================================== 
                PAGE FOOTER
=========================================================================================================-->
<div style="bottom: 0; background-color: #343A40; color: white; height: 66px; width: 100%; padding: 15px;"> 
    <p id="rankingDef" style="cursor: pointer; float: left; vertical-align: middle;">Ranking Definitions&nbsp;</p>
    <!--<p id="metricDef" style="cursor: pointer; float: left; vertical-align: middle;">&nbsp;Metric Definitions</p>-->
    <img src="img/Charter_Logo_White_RGB.png" style="float: right; height: 36px;"/>

</div>




<!--==================================================================================================== 
                MODAL FOR BID RANK SELECTIONS
=========================================================================================================-->
<div class="modal fade" id="bidMonthSelection" tabindex="-1" role="dialog" aria-labelledby="sucessfullModal" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="bidMonthSelectionTitle">Bid Month Selection</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">x</span>
                </button>
            </div>
            <div class="modal-body">    
                Choose Level and Month
                <div class="input-group mb-3">         
                        <div class="input-group-prepend">
                           <label class="input-group-text" for="bidFiscalRankType">Level</label>
                        </div>
                        <select class="custom-select" id="bidFiscalRankType">
                            <option selected="selected" style="background-color: yellow;">Choose...</option>
                            <!-- Values must match the posLevel on the Query -->
                            <option value="1">Agent</option>
                            <option value="4">Lead</option>
                        </select>
                </div>
                <div class="input-group mb-3">                             
                        <div class="input-group-prepend">
                            <label class="input-group-text" for="bidFiscalMonthSelectionLabel">Month</label>
                        </div>
                        <select class="custom-select" id="bidFiscalMonthSelection">
                            <option selected="selected" style="background-color: yellow;">Choose...</option>
                            <option value="1/28/2021">January 2021</option>
                            <option value="2/28/2021">Febuary 2021</option>
                            <option value="3/28/2021">March 2021</option>
                            <option value="4/28/2021">April 2021</option>
                            <option value="5/28/2021">May 2021</option>
                            <option value="6/28/2021">June 2021</option>
                            <option value="7/28/2021">July 2021</option>
                            <option value="8/28/2021">August 2021</option>
                            <option value="9/28/2021">September 2021</option>
                            <option value="10/28/2021">October 2021</option>
                            <option value="11/28/2021">November 2021</option>
                        </select>
                </div>

                <button type="button" class="btn btn-primary bidRanksBtn" style="width: 100%;" id="viewBidRanksBtn">View Bid Ranks</button>             
            </div>
        </div>    
    </div>         
 </div>





<!--==================================================================================================== 
                MODAL FOR EXPORT OPTIONS
=========================================================================================================-->
<div class="modal" id="exportModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Export Options</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                Utilize the Month Selection drop down to select Individual Months and press Export once done. YTD Ranks will be included with all exports. Deselecting all Fiscal Months will just export YTD Ranks.
           
                <br />
                <div class="dropdown">

                        
                    <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        Month Selection
                    </button>
                    <div class="dropdown-menu" aria-labelledby="dropdownMenuButton" id="monthSelectionDD" runat="server"></div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" id="exportMonthBtn" class="btn btn-primary">Export</button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>





<!--==================================================================================================== 
                MODAL FOR Weight Table INFO
=========================================================================================================-->
<div class="modal" id="weightInfo" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content weightInfo">
            <div class="modal-header">
                <h5 class="modal-title">Weights Used</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="table">
                    <div class="row">
                        <div class="col">
                            <div id="weightTable" >
                                <asp:GridView ID="wTableAsp" runat="server" AutoGenerateColumns="true" OnRowCreated="wTableAsp_RowCreated">

                                </asp:GridView>
                            </div>
                        </div>
                        


                    </div>
                </div>
               
            </div>
        </div>
    </div>
</div>



<!--==================================================================================================== 
                MODAL FOR Update Dates Table INFO
=========================================================================================================-->
<div class="modal" id="updateDates" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content weightInfo">
            <div class="modal-header">
                <h5 class="modal-title">Update Info</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                
                <asp:GridView id="updateDatesTbl" runat="server" OnRowCreated="updateDatesTbl_RowCreated"></asp:GridView>

            </div>
        </div>
    </div>
</div>


        <!--==================================================================================================== 
                MODAL FOR Row INfo Table INFO
=========================================================================================================-->
<div class="modal" id="rowInfoTwo" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content weightInfo">
            <div class="modal-header">
                <h5 class="modal-title" id="mrChangeTitle">Roster</h5><br />
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <!--<span>Table below shows Employee's and range of dates where data will roll up to Supervisor/Manager.</span>-->
                <span>Data Source for Roster Modal is being evaluated. This feature will be available again soon.</span>
                
                <!--<span id="tblOne" runat="server"></span>-->
                <!--<span id="tblTwo" runat="server"></span>-->
            </div>
        </div>
    </div>
</div>





        <span id="kToolsPH" runat="server"></span> 


        <div id="dlAll" style="display: none;"></div>
        <asp:PlaceHolder ID="BidContainerHolder" runat="server"></asp:PlaceHolder>
        <asp:HiddenField ID ="RankTypeVal" runat="server" value="Agent"/>

        <asp:HiddenField ID="rType" runat="server" />

        
        
        <script src="js/jquery-3.5.1.min.js"></script>
        <script src="js/popper.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script src="js/bootstrap-toggle.min.js"></script>
        
        <script src="js/tabulator.min.js"></script>
        <script src="js/ranking_new.js"> </script>
        
        

        <script>

$('#udpatedOnBtn').click(function(){
    $('#updateDates').modal('show');
});
$('#metrics').click(function(){
    $('#lookBackTableMetrics').css('display','block');
    $('#lookBackTableRanks').css('display','none');
});
$('#ranks').click(function(){
    $('#lookBackTableMetrics').css('display','none');
    $('#lookBackTableRanks').css('display','block');
});
            
            
        </script>

<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-154690921-1"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-154690921-1');
</script>


    </form>

</body>
</html>
