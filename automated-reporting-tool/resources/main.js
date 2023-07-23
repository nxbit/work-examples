function reportInfoBox(reportTitle, reportDes, reportCurrent, reportPast) {
    Metro.infobox.create("<H3><center>" + reportTitle + "</h3><br>" + reportDes + "</center><br><br>Current Report: <a href=\"" + reportCurrent + "\" target=\"_blank\">Here</a>" +" <br>Archived Report: <a href=\""+reportPast+"\" target=\"_blank\">Here</a>", "default");
}

function reportInfoBoxAlignment(reportTitle, reportDes, reportCurrent, reportPast) {
    Metro.infobox.create("<H3><center>" + reportTitle + "</h3><br>" + reportDes + "</center><br><br>Current Alignment: <a href=\"" + reportCurrent + "\" target=\"_blank\">Here</a>" +" <br>Alignment Process Document: <a href=\""+reportPast+"\" target=\"_blank\">Here</a>", "default");
}

function auxReport(){
	window.open("auxReportURLPlaceholder");
}

function shrinkageReport(){
	window.open("shrinkageReportURLPlaceholder");
}

function DailyStackReport(){
	window.open("dailystackrankReportURLPlaceholder");
}

function CorPortalCoachingReport(){
	window.open("corportalcoachingReportURLPlaceholder");
}

function ETDReport(){
	window.open("etdReportURLPlaceholder");
}

function IRISUsageReport(){
	window.open("irisusageReportURLPlaceholder");
}

function LeadStackReport(){
	window.open("leadstackrankReportURLPlaceholder");
}

function AttendanceReport(){
	window.open("attendanceReportURLPlaceholder");
}

function AlignmentReport(){
	window.open("alignmentReportURLPlaceholder");
}

function RubyReport(){
	window.open("rubyReportURLPlaceholder");
}

function TransferLocationReport(){
	window.open("transferlocationsReportURLPlaceholder");
}

function WorkOrderDetailsReport(){
	window.open("workorderdetailsReportURLPlaceholder");
}

function VOCDetailsReport(){
	window.open("vocdetailsReportURLPlaceholder");
}

function MonthoverMonthReport(){
	window.open("monthovermonthURLPlaceholder");
}

function SapphireReport(){
	window.open("sapphireReportURLPlaceholder");
}
function EmeraldReport(){
	window.open("emeraldReportURLPlaceholder");
}

function ehhReport(){
	window.open("ehhReportURLPlaceholder");
}
document.getElementById('AUXReportUpdateDate').innerText = 'auxReportDatePlaceholder';
document.getElementById('ehhUpdateDate').innerText = 'ehhReportDatePlaceholder';
document.getElementById('ShrinkageReportUpdateDate').innerText = 'shrinkageReportDatePlaceholder';
document.getElementById('DailyStackRankUpdateDate').innerText = 'dailystackrankReportDatePlaceholder';
document.getElementById('CorPortalCoachingTrackerUpdateDate').innerText = 'corportalcoachingReportDatePlaceholder';
document.getElementById('ETDOutofComplianceUpdateDate').innerText = 'etdReportDatePlaceholder';
document.getElementById('IRISUsagebyTeamUpdateDate').innerText = 'irisusageDatePlaceholder';
document.getElementById('LeadStackRankUpdateDate').innerText = 'leadstackrankReportDatePlaceholder';
document.getElementById('AttendacePatternToolUpdateDate').innerText = 'attendanceReportDatePlaceholder';
document.getElementById('AlignmentUpdateDate').innerText = 'alignmentReportDatePlaceholder';
document.getElementById('RubyUpdateDate').innerText = 'rubyReportDatePlaceholder';
document.getElementById('TransferLocationDate').innerText = 'transferlocationsReportDatePlaceholder';
document.getElementById('WorkOrderDetailsDate').innerText = 'workorderdetailsReportDatePlaceholder';
document.getElementById('VOCDetailsDate').innerText = 'vocdetailsReportDatePlaceholder';
document.getElementById('AgentMonthoverMonthUpdateDate').innerText = 'monthovermonthReportDatePlaceholder';
document.getElementById('SapphireUpdateDate').innerText = 'sapphireReportDatePlaceholder';
document.getElementById('EmeraldUpdateDate').innerText = 'emeraldReportDatePlaceholder'


