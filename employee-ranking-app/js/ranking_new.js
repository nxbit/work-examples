//URL Parameters Passed 
const urlParms = new URLSearchParams(window.location.search);

function JSCallback(returnMsg, context) {
	//==========================================================
	//					JSCallback
	//		Handles the call Back request for Roster Data
	//==========================================================
    
	//Roster data will be fed back as a JSON Array, arr will store that JSON Return
	var arr = JSON.parse(returnMsg.match("<tableOne>(.*)<tableOne>")[1]);


    //Creating Column Values from Array
    var col = [];
    for(var i = 0; i < arr.length; i++){
        for(var key in arr[i]){
            if(col.indexOf(key) === -1){
                col.push(key);
            }
        }
    }


    //Creating a Table Ele to Load First Array to
    var table = document.createElement('table');
    table.setAttribute('class','lookBackTable');
    table.setAttribute('id','lookBackTableMetrics');


    //Generic TableRow Objects for Table One and Two
    var tr = table.insertRow(-1);


    //Adding Column Headings to Table One from Array One
    for(var i = 0; i < col.length; i++) {
        var th = document.createElement('th');
        if(i==0)
            th.setAttribute('class','lookBackTableHeaderFirst');
        else 
            th.setAttribute('class','lookBackTableHeader');
        th.innerHTML = col[i];
        tr.appendChild(th);
    }


    //Adding Data to Table From Array One
    for(var i = 0; i < arr.length; i++) {
        tr= table.insertRow(-1);
        for(var j = 0; j < col.length; j++) {
            var tabCell = tr.insertCell(-1);
            tabCell.innerHTML = arr[i][col[j]];
        }
    }

    //Adding the Table Element to the TableOnePage Container
    var divContainer = document.getElementById('tblOne');
    divContainer.innerHTML = "";
    divContainer.append(table);


    $('#loadingMsg').text('Grabbing Roster');
    //Turning off the Loading Modal
    setVisible('#loading', false);
    //Show the new Created RowModal
    $('#rowInfoTwo').modal('show');

}


function setVisible(selector, visible) {
    document.querySelector(selector).style.display = visible ? 'block' : 'none';
}




//Disable EnterButton as a postback option
$(document).ready(function () {
    $("form").bind("keypress", function (e) {
        if (e.keyCode == 13) {
            return false;
        }
    });
});




$('#rankingDef').click(function () {
    $('#rankDef').modal('show');
});

$('#bidRanksBtn').click(function(){
    $('#bidMonthSelection').modal('show');
});

var sParams = [{locale: true, alignEmptyValues:"bottom"}];
var rDataTable = new Tabulator("#rankListTable",{
    data: rData,
    
    height: "calc(100vh - 235px)",
    renderStarted:function(){setVisible('#loading', true);},
    renderComplete:function(){setVisible('#loading', false);},
    columns: colLayout,
   /* autoColumns:true,*/
    /*virtualDomHoz: true,*/
    virtualDomBuffer: 500,
   /* rowClick:function(e, row){
        setVisible('#loading', true);
        UseCallBack(row.getCell('id').getValue());
    },*/
    cellClick:function(e, cell){

        var row = cell.getRow();
        var rowID = row.getCell('id').getValue();
        var rowName = row.getCell('empName').getValue();
        
        var col = cell.getColumn();
        var colGTitle = col.getParentColumn().getDefinition().title

		var lvlCB = "";

		const urlParams = new URLSearchParams(window.location.search);
		

		if(urlParams.has('lvl')){
			lvlCB = urlParams.get('lvl');
		}else{
			lvlCB = "2";
		}


		

        if(!colGTitle.includes('Info') && lvlCB != "4")
        {
            //Show the new Created RowModal
            $('#rowInfoTwo').modal('show');

            if(false){
                $('#loadingMsg').text('Grabbing '+colGTitle+' Roster Data');
                setVisible('#loading', true);
                $('#mrChangeTitle').text(colGTitle+' Roster for '+rowName);
                UseCallBack('<id>'+rowID+'<id>'+'<fiscal>'+colGTitle+'<fiscal>'+'<lvl>'+lvlCB+'<lvl>');
            }
        }

        


    }
        
    
        
});

$('#metricByMonth').click(function(){
    
    var slvl = urlParms.get('lvl');
    var bM = urlParms.get('bMonth');
    if(slvl!=null)
        if(bM!=null)
        location.replace("https://repairreporting.corp.chartercom.com/Rankings.aspx?lvl="+slvl);
        else
        location.replace("https://repairreporting.corp.chartercom.com/Rankings.aspx?bMonth=1&lvl="+slvl);
    else
        if(bM!=null)
            location.replace("https://repairreporting.corp.chartercom.com/Rankings.aspx");
        else
            location.replace("https://repairreporting.corp.chartercom.com/Rankings.aspx?bMonth=1");
});


try{
$('#monSelAll').click(function(){
    var rInputs = $('input:checkbox');
    var i = 0;
    rInputs.each(function(){
        if($(this).attr('id') != "newHireToggle" && $(this).attr('id') != "SiteRankToggle")
        {
            $(this).prop('checked',true);
        };
    });
});
}catch(err){};

try{
$('#monClearAll').click(function(){
    var rInputs = $('input:checkbox');
    var i = 0;
    rInputs.each(function(){
        if($(this).attr('id') != "newHireToggle" && $(this).attr('id') != "SiteRankToggle")
        {
            $(this).prop('checked',false);
        };
    });
});}catch(err){};






