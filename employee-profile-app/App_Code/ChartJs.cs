using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for ChartJs
/// </summary>
public class ChartJs
{

    //!!!!!!!!!!!!!!!!!!!!!!!!!!!! Paths, IPs, any anything identifiable has been hidden !!!!!!!!!!!!!!!!!!!!!!!!!!!! //
    public DataTable dt;
    public string elementID;
    public ChartJs(string id, DataTable data)
    {
        elementID = id;
        dt = data;
        //
        // TODO: Add constructor logic here
        //
    }
    //
    //  Strings Data Lables from the first column of the DataTable
    //
    public string stringDataLabels()
    {
        string main = "[";
        foreach(DataRow r in dt.Rows)
        {
            if (dt.Rows.IndexOf(r) == dt.Rows.Count) { main = main + "'" + r[0].ToString() + "'"; }
            else { main = main + "'" + r[0].ToString() + "',"; };
        }
        return main + "]";
    }
    public string stringDataAxisLabel()
    {
        return dt.Columns[0].ColumnName;
    }
    public string stringDataAxisLabelPassed(DataTable dt2)
    {
        return dt2.Columns[0].ColumnName;
    }
    public string stringDataAxisLabelsPassed(DataTable dt2)
    {
        string main = "[";
        foreach (DataRow r in dt2.Rows)
        {
            if (dt2.Rows.IndexOf(r) == dt2.Rows.Count) { main = main + "'" + r[0].ToString() + "'"; }
            else { main = main + "'" + r[0].ToString() + "',"; };
        }
        return main + "]";
    }
    //
    //  String Data Values from the second column of the DataTable
    //      Values are assumed to be numeric
    //
    public string stringDataValues()
    {
        string main = "[";
        foreach (DataRow r in dt.Rows)
        {
            if (dt.Rows.IndexOf(r) == dt.Rows.Count) { main = main + "" + r[1].ToString() + ""; }
            else { main = main + "" + r[1].ToString() + ","; };
        }
        return main + "]";
    }
    public string stringDataValuesPassed(DataTable dt2, int index = 1)
    {
        string main = "[";
        foreach (DataRow r in dt2.Rows)
        {
            if (dt2.Rows.IndexOf(r) == (dt2.Rows.Count-1)) { main = main + "" + r[index].ToString() + ""; }
            else { main = main + "" + r[index].ToString() + ","; };
        }
        return main + "]";
    }
    //
    //  Create 2-Dimensional BarChart
    //
    public string LineChart2D(string id, DataTable dataSet)
    {
        string LineChart = "" +

        "var ctx = document.getElementById('"+id+"').getContext('2d');" +
        "var "+id+" = new Chart(ctx, {" +
        "type: 'bar'," +
        "data:" +
            "{" +
            "labels: "+
            stringDataLabels()+
            "," +
            "datasets: [" +
            "{" +
                "label: '"+ stringDataAxisLabelPassed(dataSet) + "'," +
                "data: "+
                stringDataValuesPassed(dataSet,1)+
                "," +
                "backgroundColor: [" +
                    "'rgba(255, 99, 132, 0.2)'," +
                    "'rgba(54, 162, 235, 0.2)'," +
                    "'rgba(255, 206, 86, 0.2)'," +
                    "'rgba(75, 192, 192, 0.2)'," +
                    "'rgba(153, 102, 255, 0.2)'," +
                    "'rgba(255, 99, 132, 0.2)'," +
                    "'rgba(54, 162, 235, 0.2)'," +
                    "'rgba(255, 206, 86, 0.2)'," +
                    "'rgba(75, 192, 192, 0.2)'," +
                    "'rgba(153, 102, 255, 0.2)'," +
                    "'rgba(255, 99, 132, 0.2)'," +
                    "'rgba(54, 162, 235, 0.2)'," +
                    "'rgba(255, 206, 86, 0.2)'," +
                    "'rgba(75, 192, 192, 0.2)'," +
                    "'rgba(153, 102, 255, 0.2)'," +
                    "'rgba(255, 159, 64, 0.2)'" +
                "]," +
                "borderColor: [" +
                    "'rgba(255, 99, 132, 1)'," +
                    "'rgba(54, 162, 235, 1)'," +
                    "'rgba(255, 206, 86, 1)'," +
                    "'rgba(75, 192, 192, 1)'," +
                    "'rgba(153, 102, 255, 1)'," +
                    "'rgba(255, 99, 132, 1)'," +
                    "'rgba(54, 162, 235, 1)'," +
                    "'rgba(255, 206, 86, 1)'," +
                    "'rgba(75, 192, 192, 1)'," +
                    "'rgba(153, 102, 255, 1)'," +
                    "'rgba(255, 99, 132, 1)'," +
                    "'rgba(54, 162, 235, 1)'," +
                    "'rgba(255, 206, 86, 1)'," +
                    "'rgba(75, 192, 192, 1)'," +
                    "'rgba(153, 102, 255, 1)'," +
                    "'rgba(255, 159, 64, 1)'" +
                "]," +               
                "borderWidth: 1" +
            "}" +
            "]" +
        "}," +
        "options:" +
            "{" +
            "scales:" +
                "{" +
                "yAxes: [{" +
                    "ticks:" +
                        "{" +
                        "fontColor: \"white\","+
                        "reverse: false,"+
                        "suggestedMin: 100," +
                        "suggestedMax: 0,"+
                        "callback: function(value, index, values){ return (value);}" +                       
                    "}" +
                    "}]," +
                "xAxes: [{" +
                    "ticks:" +
                        "{" +
                        "fontColor: \"white\"" +
                    "}" +
                    "}]" +
            "}" +
            "}" +
        "});   ";


        return LineChart;
    }
    //
    //  Pass id, and formatted strings
    //
    public string LineChart2D_2Lines(string id, DataTable dataSet)
    {
        


        string LineChart = "" +

               "var options = {"+
        "type: 'bar',"+
  "data:"+
            "{"+
            "labels: "+ stringDataAxisLabelsPassed(dataSet) + "," +
    "datasets: [" +
        "{" +
                "label: 'VR Rankings'," +
          "data: "+stringDataValuesPassed(dataSet,1) +"," +
          "backgroundColor: [" +
                    "'rgba(255, 99, 132, 0.2)'," +
                    "'rgba(255, 99, 132, 0.2)'," +
                    "'rgba(255, 99, 132, 0.2)'," +
                    "'rgba(255, 99, 132, 0.2)'," +
                    "'rgba(255, 99, 132, 0.2)'," +
                    "'rgba(255, 99, 132, 0.2)'," +
                    "'rgba(255, 99, 132, 0.2)'," +
                    "'rgba(255, 99, 132, 0.2)'," +
                    "'rgba(255, 99, 132, 0.2)'," +
                    "'rgba(255, 99, 132, 0.2)'," +
                    "'rgba(255, 99, 132, 0.2)'," +
                    "'rgba(255, 99, 132, 0.2)'" +
                "]," +
                "borderColor: [" +
                    "'rgba(255, 99, 132, 1)'," +
                    "'rgba(255, 99, 132, 1)'," +
                    "'rgba(255, 99, 132, 1)'," +
                    "'rgba(255, 99, 132, 1)'," +
                    "'rgba(255, 99, 132, 1)'," +
                    "'rgba(255, 99, 132, 1)'," +
                    "'rgba(255, 99, 132, 1)'," +
                    "'rgba(255, 99, 132, 1)'," +
                    "'rgba(255, 99, 132, 1)'," +
                    "'rgba(255, 99, 132, 1)'," +
                    "'rgba(255, 99, 132, 1)'," +
                    "'rgba(255, 99, 132, 1)'" +
                "]," +
                
          "borderWidth: 1," +
          "fill: 'start'" +
        "},	" +
            "{" +
"                label: 'CorPortal Rankings'," +
                "data: "+stringDataValuesPassed(dataSet,2) +"," +
                "backgroundColor: [" +
                    "'rgba(255, 206, 86, 0.2)'," +
                    "'rgba(255, 206, 86, 0.2)'," +
                    "'rgba(255, 206, 86, 0.2)'," +
                    "'rgba(255, 206, 86, 0.2)'," +
                    "'rgba(255, 206, 86, 0.2)'," +
                    "'rgba(255, 206, 86, 0.2)'," +
                    "'rgba(255, 206, 86, 0.2)'," +
                    "'rgba(255, 206, 86, 0.2)'," +
                    "'rgba(255, 206, 86, 0.2)'," +
                    "'rgba(255, 206, 86, 0.2)'," +
                    "'rgba(255, 206, 86, 0.2)'," +
                    "'rgba(255, 206, 86, 0.2)'" +
                "]," +
                "borderColor: [" +
                    "'rgba(255, 206, 86, 1)'," +
                    "'rgba(255, 206, 86, 1)'," +
                    "'rgba(255, 206, 86, 1)'," +
                    "'rgba(255, 206, 86, 1)'," +
                    "'rgba(255, 206, 86, 1)'," +
                    "'rgba(255, 206, 86, 1)'," +
                    "'rgba(255, 206, 86, 1)'," +
                    "'rgba(255, 206, 86, 1)'," +
                    "'rgba(255, 206, 86, 1)'," +
                    "'rgba(255, 206, 86, 1)'," +
                    "'rgba(255, 206, 86, 1)'," +
                    "'rgba(255, 206, 86, 1)'" +
                "]," +
                
                "borderWidth: 1," +
                "fill: 'start'" +
            "}" +
        "]" +
  "}," +
  "options:" +
            "{" +
            "scales:" +
                "{" +
                "yAxes: [{" +
                    "ticks:" +
                        "{" +
                        "reverse: false" +
                    "}" +
                    "}]" +
    "}" +
            "}" +
        "}; " +

        "var ctx = document.getElementById('"+id+"').getContext('2d');" +
        "new Chart(ctx, options);";


        return LineChart;
    }


}