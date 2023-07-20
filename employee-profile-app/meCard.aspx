<%@ Page Language="C#" AutoEventWireup="true" CodeFile="meCard.aspx.cs" Inherits="meCard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

<link rel="stylesheet" href="./css/bootstrap.css" />
<link rel="stylesheet" href="./css/bootstrap-select.css" />
<link rel="stylesheet" href="./css/meCardStyle.css" />   
<script type="text/javascript" src="sortable.js"></script>
<script type="text/javascript" src="./js/jquery-3.5.1.min.js"></script>
<script type="text/javascript" src="./js/jquery-ui.min.js"></script>
    <script src="./js/popper.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css"/>
    
    <title>meCard</title>
    
    <!--!!!!!!!!!!!!!!!!!!!!!!!!!!!! Paths, IPs, any anything identifiable has been hidden !!!!!!!!!!!!!!!!!!!!!!!!!!!!-->
        
<script src="./js/Chart.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        
        <!-- Main Container Spans Full Page-->
        <table>
            <tr>
                <td style="width: 237px; min-width: 237px;">
                     <div class="navconatiner container" style="position: absolute; top:0; left: 0; margin-right: 15px;">
            <div class="container" style="width: 222px; margin: 0;">
                 <!-- Main Container for Leftside Nav-->
                <div class="col-sm-2" style="min-width: 222px; max-width: 222px;">
                    <div class="row">
                        <a href="#" id="meCardLogoLinkBack" runat="server">
                        <asp:Image ID="meCardLogo" runat="server" />
                            </a>
                    </div>
                    <div class="row">
                        <input id="pidInput" name="pidInput" class="form-control" runat="server" type="text" placeholder="Enter Name, PID, or PSID" />
                        <button id="search" name="search" class="form-control" type="button">Search</button>
                    </div>
                    <div class="row" style="padding-top:15px;">
                        <br /><br /><br />
                        <div id="teamListContainer" runat="server" class="cardcontainer">
                            <asp:PlaceHolder ID="TeamListTitleLabel" runat="server"></asp:PlaceHolder><br />
                            <asp:PlaceHolder ID="homeLinkBack" runat="server"></asp:PlaceHolder>
                            <asp:GridView ID="TeamListItems" runat="server" ></asp:GridView>
                        </div>
                </div>
                    <div class="row" style="padding-top:15px;">
                        <br /><br /><br />
                        <div id="selectedListContainer" runat="server" class="cardcontainer">
                            <asp:PlaceHolder ID="selectedListTitleLabel" runat="server"></asp:PlaceHolder>
                            <asp:GridView ID="selectedListItems" runat="server" ></asp:GridView>
                        </div>
                </div>
               
                <!-- END of Leftside Nav-->
                </div>
            </div>
            </div>
                </td>
                <td style="width:900px; min-width: 900px">
                     <asp:PlaceHolder ID="alertPanel" runat="server"></asp:PlaceHolder>  





                    <div class="row">
                   
                    <div class="col"> 
                    <div class="cardcontainer" id="empnameinfocontainer" runat="server">
                        <asp:GridView ID="empNameInfo" runat="server"></asp:GridView>
                        <div class="empImgcontainer" id="empImgcontainer" runat="server">
                            
                            
                            <asp:Image ID="empImage" runat="server"  CssClass="empImage"/>
                            <asp:Image ID="empImagecontainerBackground" runat="server" CssClass="empImagecontainerBackground" /> 
                        </div>
                        
                            
                        
                        <asp:DataGrid ID="hierNameInfo" runat="server"></asp:DataGrid>
                    </div>
                    </div>
                    <div class="col">
                    <div class="cardcontainer" id="accountInfoTile" runat="server">
                        <asp:PlaceHolder ID="accountInfoTitle" runat="server"></asp:PlaceHolder>
                        <asp:GridView ID="accountInfo" runat="server" OnRowDataBound="empDataItemsBind"></asp:GridView>
                    </div>
                    </div>

                    <div class="col appMaincontainer">
                        <div id="attendLinkContainer" runat="server" class="appcontainer cardcontainer">
                            <asp:Image ID="attendLink" runat="server" />
                            <asp:PlaceHolder ID="attendTitleLabel" runat="server"></asp:PlaceHolder>
                        </div>
                        <div id="uxidLinkContainer" runat="server" class="appcontainer cardcontainer">
                            <asp:Image ID="uxidLink" runat="server" />
                            <asp:PlaceHolder ID="uxidTitleLabel" runat="server"></asp:PlaceHolder>
                        </div>
                        <div id="rankLinkContainer" runat="server" class="appcontainer cardcontainer">
                            <asp:Image ID="rankLink" runat="server" />
                            <asp:PlaceHolder ID="rankTitleLabel" runat="server"></asp:PlaceHolder>
                        </div>
                    </div>
                    <div class="col appMaincontainer">
                        <div id="corPortalLinkContainer" runat="server" class="appcontainer cardcontainer">
                            <asp:Image ID="corPortalLink" runat="server" />
                            <asp:PlaceHolder ID="corPortalTitleLabel" runat="server"></asp:PlaceHolder>
                        </div>
                        <div id="qualityLinkContainer" runat="server" class="appcontainer cardcontainer">
                            <asp:Image ID="qualityLink" runat="server" />
                            <asp:PlaceHolder ID="qualityTitleLabel" runat="server"></asp:PlaceHolder>
                        </div>
                        <div id="feedbackLinkContainer" runat="server" class="appcontainer cardcontainer">
                            <asp:Image ID="feedbackLink" runat="server" />
                            <asp:PlaceHolder ID="feedbackLinkTitleLabel" runat="server"></asp:PlaceHolder>
                        </div>
                    </div>
                    <div class="col appMaincontainer">
                        <div id="corPortalCoachLinkContainer" runat="server" class="appcontainer cardcontainer">
                            <asp:Image ID="corPortalCoachLink" runat="server" />
                            <asp:PlaceHolder ID="corPortalCoachTitleLabel" runat="server"></asp:PlaceHolder>
                        </div>
                        <div id="reportingTilesContainer" runat="server" class="appcontainer cardcontainer">
                            <asp:Image ID="reportingTilesLink" runat="server" />
                            <asp:PlaceHolder ID="reportingTilesLabel" runat="server"></asp:PlaceHolder>
                        </div>
                        <%--<div id="rankingDataExportContainer" runat="server" class="appcontainer cardcontainer">
                            <asp:Image ID="rankingDataExportLink" runat="server" />
                            <asp:PlaceHolder ID="rankingDataExportTitleLabel" runat="server"></asp:PlaceHolder>
                        </div>--%>
                        <div id="apdLinkContainer" runat="server" class="appcontainer cardcontainer">
                            <asp:Image ID="apdPageLink" runat="server" />
                            <asp:PlaceHolder ID="apdLinkTitleLabel" runat="server"></asp:PlaceHolder>
                        </div>
                    </div>
                    </div>




                    <div class="row">
                        <div class="col">
                                <div id="empDataContainer" runat="server" class="cardcontainer">
                                    <asp:PlaceHolder ID="empDataTitleLabel" runat="server"></asp:PlaceHolder>
                                    <asp:GridView ID="empDataItems" runat="server" OnRowDataBound="empDataSpacing"></asp:GridView>
                                </div>
                        </div>
                        <div class="col">
                            <div class="row">


                                <div id="carouselMetricControls" class="carousel slide cardcontainer" data-ride="carousel" runat="server">
                                    <ol class="carousel-indicators">
                                        <li data-target="#carouselMetricControls" data-slide-to="0" class="active"></li>
                                        <li data-target="#carouselMetricControls" data-slide-to="1"></li>
                                        <li data-target="#carouselMetricControls" data-slide-to="2"></li>
                                        <li data-target="#carouselMetricControls" data-slide-to="3"></li>
                                        <li data-target="#carouselMetricControls" data-slide-to="4"></li>
                                        <li data-target="#carouselMetricControls" data-slide-to="5"></li>
                                        <li data-target="#carouselMetricControls" data-slide-to="6"></li>
                                        <li data-target="#carouselMetricControls" data-slide-to="7"></li>
                                    </ol>
                                  <div class="carousel-inner">
                                    <div class="carousel-item active" id="corRankingChart" runat="server" style="width: 430px; height: 250px; padding: 5px;" data-interval="20000">
                                        <asp:PlaceHolder ID="empRankingTitleLabel" runat="server"></asp:PlaceHolder>
                                        <asp:PlaceHolder ID="updatedDateLabel" runat="server"></asp:PlaceHolder>
                                      <canvas id="empRankingChart" width="430" height="200"></canvas>
                                    </div>
                                    <div class="carousel-item" id="ahtChart" runat="server" style="width: 430px; height: 250px; padding: 5px;" data-interval="20000">
                                        <asp:PlaceHolder ID="empAHTTitleLabel" runat="server"></asp:PlaceHolder>
                                        <asp:PlaceHolder ID="rankingahtupdatedDateLabel" runat="server"></asp:PlaceHolder>
                                      <canvas id="empAHTChart" width="430" height="200"></canvas>
                                    </div>
                                    <div class="carousel-item" style="width: 430px; height: 250px; padding: 5px;" data-interval="20000">
                                        <asp:PlaceHolder ID="empFCRTitleLabel" runat="server"></asp:PlaceHolder>
                                        <asp:PlaceHolder ID="rankingfcrupdatedDateLabel" runat="server"></asp:PlaceHolder>
                                      <canvas id="empFCRChart" width="430" height="200"></canvas>
                                    </div>
                                    <div class="carousel-item" style="width: 430px; height: 250px; padding: 5px;" data-interval="20000">
                                        <asp:PlaceHolder ID="empVOCTitleLabel" runat="server"></asp:PlaceHolder>
                                        <asp:PlaceHolder ID="rankingvocupdatedDateLabel" runat="server"></asp:PlaceHolder>
                                      <canvas id="empVOCChart" width="430" height="200"></canvas>
                                    </div>
                                    <div class="carousel-item" style="width: 430px; height: 250px; padding: 5px;" data-interval="20000">
                                        <asp:PlaceHolder ID="empCOMPTitleLabel" runat="server"></asp:PlaceHolder>
                                        <asp:PlaceHolder ID="rankingcompupdatedDateLabel" runat="server"></asp:PlaceHolder>
                                      <canvas id="empCOMPChart" width="430" height="200"></canvas>
                                    </div>
                                    <div class="carousel-item" style="width: 430px; height: 250px; padding: 5px;" data-interval="20000">
                                        <asp:PlaceHolder ID="empTRANSTitleLabel" runat="server"></asp:PlaceHolder>
                                        <asp:PlaceHolder ID="rankingtransupdatedDateLabel" runat="server"></asp:PlaceHolder>
                                      <canvas id="empTRANSChart" width="430" height="200"></canvas>
                                    </div>
                                    <div class="carousel-item" style="width: 430px; height: 250px; padding: 5px;" data-interval="20000">
                                        <asp:PlaceHolder ID="empOOOTitleLabel" runat="server"></asp:PlaceHolder>
                                        <asp:PlaceHolder ID="rankingoooupdatedDateLabel" runat="server"></asp:PlaceHolder>
                                      <canvas id="empOOOChart" width="430" height="200"></canvas>
                                    </div>
                                  </div>
                                  <a class="carousel-control-prev" href="#carouselMetricControls" role="button" data-slide="prev">
                                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                    <span class="sr-only">Previous</span>
                                  </a>
                                  <a class="carousel-control-next" href="#carouselMetricControls" role="button" data-slide="next">
                                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                    <span class="sr-only">Next</span>
                                  </a>
                                </div>





                            </div>
                            <div class="row">
                            <div id="teamMovesContainer" runat="server" class="cardcontainer">
                                <asp:PlaceHolder ID="teamMovesTitleLabel" runat="server"></asp:PlaceHolder>
                                <asp:GridView ID="teamMovesItems" runat="server"></asp:GridView>
                            </div>
                            </div>
                        </div>
                        
                    </div>
                    <div class="row">

                            <div id="empNotesContainer" runat="server" class="cardcontainer">
                                <div style="display:table-cell; width: 100%;" id="leadershipNotesContainer" runat="server">
                                            <div style="display:table">
                                                <span class="Titles">Leadership Notes <span style="font-size:smaller;">(plain text only)</span></span> 
                                                <div style="display:table-row">&nbsp;</div>
                                                <div style="display:table-row">
                                                    <asp:TextBox ID="leadershipNotesForm" Name="leadershipNotesForm"  CssClass="leadershipNotes" runat="server" TextMode="MultiLine" Rows="10"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div style="display:table-cell; padding-left: 15px; width: 100%;">
                                            <div style="display:table; width: 100%;">
                                                <span class="Titles">Agent Notes <span style="font-size:smaller;">(plain text only)</span></span> <img src="img/save.png" id="saveNotes" class="saveNotes" style="float: right;"/>
                                                <div style="display:table-row; width: 100%;">&nbsp;</div>
                                                <div style="display:table-row; width: 100%;">
                                                    <asp:TextBox ID="agentNotesForm" Name="agentNotesForm" CssClass="leadershipNotes" runat="server" TextMode="MultiLine" Rows="10"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                            </div>
                  
                    </div>
                    <div class="row">
                   
                            <div id="teamDataContainer" runat="server" class="cardcontainer">
                                <asp:PlaceHolder ID="TeamDataTitleLabel" runat="server"></asp:PlaceHolder>
                                <asp:GridView ID="TeamDataItems" runat="server"></asp:GridView>
                            </div>
                            <div id="empInteractionsContainer" runat="server" class="cardcontainer">
                                <asp:PlaceHolder ID="empInteractionsTitleLabel" runat="server"></asp:PlaceHolder>
                                <asp:GridView ID="empInteractionsItems" runat="server"></asp:GridView>
                            </div>
                
                        
                    </div>


                <!-- END of Main Section-->




                    


               
                </td>
            </tr>
        </table>
           
       


           
               


    

            
            
        <!-- END of Main Container-->    
      
          
            


        <div class="modal fade" id="savingNotesModal" tabindex="-1" role="dialog" aria-labelledby="savingNotesModalLabel" aria-hidden="true">
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="savingNotesModalLabel">Note Saving...</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div id="savingModalBody" class="modal-body">
                Note is Saving.....
              </div>
            </div>
          </div>
        </div>


        <div class="modal fade" id="feedbackSentModal" tabindex="-1" role="dialog" aria-labelledby="feedbackSentModalLabel" aria-hidden="true">
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="feedbackSentModalLabel">Feedback Sent...</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div id="feedbackSentModalBody" class="modal-body">
                Feedback Sent!
              </div>
            </div>
          </div>
        </div>


        <div class="modal fade" id="rankingExportModal" tabindex="-1" role="dialog" aria-labelledby="rankingExportModalLabel" aria-hidden="true">
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="rankingExportModalLabel">Rank Export Options</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body">
                <h4>Ranking Export Options</h4><br />
                <h6><a href="./aRankMonthlyDH.ashx">Rankings and Metrics by Month</a></h6>
                  <small>&emsp;- Includes YTD and Quarterly Summary and Fiscal Months on Seperate Tabs. <br /><br /><br /></small>
                <h6><a href="./aRankMetricsDH.ashx">Ranking and Metrics by Metric</a></h6>
                  <small>&emsp;- Includes YTD and Quarterly Summary and Metrics on Seperate Tabs.<br /><br /><br /></small>
                <h6>Selected Fiscal Mth(s)</h6>
                  <small>Select Fiscal Mth from dropdown.<br /><br /><br /></small>
                  <asp:PlaceHolder ID="fMonthsholder" runat="server"></asp:PlaceHolder>
                  <button id="exportR" type="button" class="btn-sm">Export</button>
              </div>
            </div>
          </div>
        </div>


        <div class="modal fade" id="feedbackFormContainer" tabindex="-1" role="dialog" aria-labelledby="feedbackFormLabel" aria-hidden="true">
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="feedbackFormLabel">Feedback</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body">
                <small>     Send feedback to the Video Reporting Team. <br /> DL-Video-Repair-Reporting@charter.com</small><br /><br />
                <h6>Subject</h6>
                  <asp:TextBox runat="server" ID="feedbackSubject" Name="feedbackSubject" TextMode="SingleLine" Rows="1" Width="100%"/><br /><br /><br />
                <h6>Body</h6>
                  <asp:TextBox runat="server" ID="feedbackBody" Name="feedbackBody" TextMode="MultiLine" Rows="10" Width="100%"/><br /><br /><br />

              </div>
               <div class="modal-footer">
                   <button type="button" id="feedbacksend" name="feedbacksend" class="btn btn-primary">Send</button>
                   <button type="button" id="feedbackClear" class="btn btn-secondary">Clear</button>
               </div>
            </div>
          </div>
        </div>
                    
            
                
      <!--  <span ID="kToolsPH" runat="server"></span> -->
    
    </form>
   <script src="js/bootstrap.js"></script>
    <script src="js/bootstrap-select.js"></script>
    <script>

        

        
       

        function JSCallback(returnMsg, context) {
            
          //  alert(returnMsg);

            if(returnMsg == "Saved" || returnMsg == "Failed")
            {
            if(returnMsg == "Saved")
            {
                $('#savingModalBody').text('Note Saved. Thank you!');
                $('#savingNotesModalLabel').text('Successful');
            };
            if(returnMsg == "Failed")
            {
                $('#savingModalBody').text('Note Not Saved');
                $('#savingNotesModalLabel').text('Note Not Saved');
            };
            
                
            }else{ alert('Something Else Happend.'); };
           $('#savingNotesModal').modal('hide');
            $('#feedbackFormContainer').modal('hide');
            $('#feedbackSentModal').modal('show');
        setTimeout(function() {
            $('#feedbackSentModal').modal('hide');
        }, 2000);
            
        };
        //
        //  UrlSearchParams not compatable with IE, Added .urlParam function
        //
        $.urlParam = function(name){
            var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
            if (results == null){
               return null;
            }
            else {
               return decodeURI(results[1]) || 0;
            }
        }

        
       
       
        

        document.getElementById("search").addEventListener("click",function(){
            window.location.href = './meCard.aspx?PID='+document.getElementById("pidInput").value;
        }); 


        
        document.getElementById("feedbackLinkContainer").addEventListener("click",function(){
             $('#feedbackFormContainer').modal('show');
        });

        document.getElementById("feedbackClear").addEventListener("click",function()
        {
            document.getElementById("feedbackSubject").value = "";
            document.getElementById("feedbackSubject").Text = "";
            document.getElementById("feedbackBody").value = "";
            document.getElementById("feedbackBody").Text = "";
        });
        document.getElementById("feedbacksend").addEventListener("click",function()
        {
            var subject = document.getElementById("feedbackSubject").value;
            var body = document.getElementById("feedbackBody").value;
           
            subject = subject.replace('\n', ' ').replace(';', ' ').replace('<', ' ').replace('>', ' ').replace('\\', ' ').replace('{', ' ').replace('}', ' ').replace('[', ' ').replace(']', ' ');
            body = body.replace('\n', ' ').replace(';', ' ').replace('<', ' ').replace('>', ' ').replace('\\', ' ').replace('{', ' ').replace('}', ' ').replace('[', ' ').replace(']', ' ');

            document.getElementById("feedbackSubject").value = subject;
            document.getElementById("feedbackBody").value = body;
    
            $('#savingNotesModal').modal('show');
            UseCallBack('[feedbackSubject]'+subject+'[feedbackSubject][feedbackBody]'+body+'[feedbackBody]');
        });


        
        
  </script>
    
</body>
    
</html>
