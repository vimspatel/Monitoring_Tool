using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Monitoring_Tool
{
    public partial class db_growth : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                bind_servername();
            }
        }
        private void BindDropDownList(DropDownList ddl, string query, string text, string value, string defaultText)
        {
            string conString = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            SqlCommand cmd = new SqlCommand(query);
            using (SqlConnection con = new SqlConnection(conString))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter())
                {
                    cmd.Connection = con;
                    con.Open();
                    ddl.DataSource = cmd.ExecuteReader();
                    ddl.DataTextField = text;
                    ddl.DataValueField = value;
                    ddl.DataBind();
                    con.Close();
                }
            }
            ddl.Items.Insert(0, new ListItem(defaultText, "0"));
        }
        private void bind_filetype()
        {
            ddl_filetype.Items.Insert(0, "Select File type");
            ddl_filetype.Items.Add("ROWS");
            ddl_filetype.Items.Add("LOG");
        }

        private void bind_servername()
        {
            string query = "Select Distinct DB_Server_Name,ServerID From [VP_DB_SERVER_LIST]";
            BindDropDownList(ddl_servername, query, "DB_SERVER_NAME", "ServerID", "Select Server");
            //ddlStates.Enabled = false;
            //ddlCities.Enabled = false;
            //ddlStates.Items.Insert(0, new ListItem("Select State", "0"));
            //ddlCities.Items.Insert(0, new ListItem("Select City", "0"));
        }

        protected void ddl_serverName_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddl_dbname.Enabled = false;
            //ddlCities.Enabled = false;
            ddl_dbname.Items.Clear();
            //ddlCities.Items.Clear();
            ddl_dbname.Items.Insert(0, new ListItem("Select Database", "0"));
            //ddlCities.Items.Insert(0, new ListItem("Select City", "0"));
            int serverId = int.Parse(ddl_servername.SelectedItem.Value);
            if (serverId > 0)
            {
                string query = string.Format("select DISTINCT DBName from [VP_DB_FILE_LIST] where ServerID = {0}", serverId);
                BindDropDownList(ddl_dbname, query, "DBName", "DBName", "Select Database");
                ddl_dbname.Enabled = true;
            }
        }


        protected void ddl_dbname_SelectedIndexChanged(object sender, EventArgs e)
        {
            bind_filetype();
        }


        protected void ddl_filetype_SelectedIndexChanged(object sender, EventArgs e)
        {

        }


        protected void btn_dbgrowthchart_Click(object sender, EventArgs e)
        {
            int serverid = Convert.ToInt32(ddl_servername.SelectedValue);
            var dbname = ddl_dbname.SelectedValue;
            var filetype = ddl_filetype.SelectedValue;
            if (txt_startdate.Text != "" && txt_enddate.Text != "")
            {
                // filter with Date only
                var startdate = Convert.ToDateTime(txt_startdate.Text).ToString("MM/dd/yyyy");
                var enddate = Convert.ToDateTime(txt_enddate.Text).ToString("MM/dd/yyyy");
                ShowDBGrowths(serverid, dbname, startdate, enddate, null, null);
            }
            else if(txtstartTime.Text != "" && txtendTime.Text != "")
            {
                // filter with Time only
                var starttime = Convert.ToDateTime(txtstartTime.Text).ToString("HH:mm");
                var endtime = Convert.ToDateTime(txtendTime.Text).ToString("HH:mm");
                ShowDBGrowths(serverid, dbname, null, null, starttime, endtime);
            }
            else if(txt_startdate.Text != "" && txt_enddate.Text != "" && txtstartTime.Text != "" && txtendTime.Text != "")
            {
                // filter with Date and time 
                var startdate = Convert.ToDateTime(txt_startdate.Text).ToString("MM/dd/yyyy");
                var enddate = Convert.ToDateTime(txt_enddate.Text).ToString("MM/dd/yyyy");
                var starttime = Convert.ToDateTime(txtstartTime.Text).ToString("HH:mm");
                var endtime = Convert.ToDateTime(txtendTime.Text).ToString("HH:mm");
                ShowDBGrowths(serverid, dbname, startdate, enddate, starttime, endtime);
            }
            else
            {
                // no filter
                ShowDBGrowths(serverid, dbname, null, null, null, null);
            }
        }

        private void ShowDBGrowths(int ServerID, string DBName,string startDate, string endDate, string startTime, string endTime)
        {
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand("SP_DBGROWTH_CHART"))
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ServerID", ServerID);
                    cmd.Parameters.AddWithValue("@DBName", DBName);
                    cmd.Parameters.AddWithValue("@startDate", startDate);
                    cmd.Parameters.AddWithValue("@endDate", endDate);
                    cmd.Parameters.AddWithValue("@startTime", startTime);
                    cmd.Parameters.AddWithValue("@endTime", endTime);
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataSet dt = new DataSet();
                        sda.Fill(dt);
                        if (dt != null)
                        {

                            DataTable t_log = dt.Tables[0];
                            DataTable t_row = dt.Tables[1];

                            //build string for div
                            String div_dbgrowthchart = "";
                            //build string for script
                            String dbgrowthchart = "";

                            if (t_log.Rows.Count > 0 && t_row.Rows.Count > 0)
                            {
                                var l_filetype = (t_log.Rows[0].ItemArray[0].ToString());
                                var r_filetype = (t_row.Rows[0].ItemArray[0].ToString());
                                var l_data = (t_log.Rows[0].ItemArray[1].ToString());
                                var r_data = (t_row.Rows[0].ItemArray[1].ToString());
                                var l_dates = (t_log.Rows[0].ItemArray[2].ToString());
                                var r_dates = (t_row.Rows[0].ItemArray[2].ToString());
                                
                                
                                // You can change your chart height by modify height value
                                div_dbgrowthchart += "<div class='col -lg-6'>";
                                    div_dbgrowthchart += "<div class='card'>";
                                        div_dbgrowthchart += "<div class='card-body'>";
                                                div_dbgrowthchart += "<h4 class='mb-3'>Disk Growth</h4>";
                                                div_dbgrowthchart += "<canvas id=\"db_growth-chart\"></canvas>";
                                            div_dbgrowthchart += "</div>";
                                    div_dbgrowthchart += "</div>";
                                div_dbgrowthchart += "</div>";
                                //Team chart
                                dbgrowthchart += "<script>";
                                dbgrowthchart += "jQuery(document).ready(function($){";
                                dbgrowthchart += "\"use strict\"; ";
                                dbgrowthchart += "var ctx = document.getElementById(\"db_growth-chart\");";
                                dbgrowthchart += "ctx.height = 150;";
                                dbgrowthchart += "var myChart = new Chart(ctx, {";
                                dbgrowthchart += "type: 'line',";
                                dbgrowthchart += "data:";
                                dbgrowthchart += "{";
                                dbgrowthchart += "labels: [\"";
                                dbgrowthchart += l_dates;
                                dbgrowthchart += "\"],";
                                dbgrowthchart += "type: 'line',";
                                dbgrowthchart += "defaultFontFamily: 'Montserrat',";
                                dbgrowthchart += "datasets: [ {";
                                dbgrowthchart += "data: [";
                                dbgrowthchart += r_data;
                                dbgrowthchart += "],";
                                dbgrowthchart += "label: 'Data',";
                                dbgrowthchart += "backgroundColor: 'rgba(0,200,155,.35)',";
                                dbgrowthchart += "borderColor: 'rgba(0,200,155,0.60)',";
                                dbgrowthchart += "borderWidth: 3.5,";
                                dbgrowthchart += "pointStyle: 'circle',";
                                dbgrowthchart += "pointRadius: 5,";
                                dbgrowthchart += "pointBorderColor: 'transparent',";
                                dbgrowthchart += "pointBackgroundColor: 'rgba(0,200,155,0.60)',";
                                dbgrowthchart += "},";
                                dbgrowthchart += "{";
                                dbgrowthchart += "data: [";
                                dbgrowthchart += l_data;
                                dbgrowthchart += "],";
                                dbgrowthchart += "label: 'Log',";
                                dbgrowthchart += "backgroundColor: 'rgba(0,194,146,.25)',";
                                dbgrowthchart += "borderColor: 'rgba(0,194,146,0.5)',";
                                dbgrowthchart += "borderWidth: 3.5,";
                                dbgrowthchart += "pointStyle: 'circle',";
                                dbgrowthchart += "pointRadius: 5,";
                                dbgrowthchart += "pointBorderColor: 'transparent',";
                                dbgrowthchart += "pointBackgroundColor: 'rgba(0,194,146,0.5)',";
                                dbgrowthchart += "}, ]";
                                dbgrowthchart += "},";
                                dbgrowthchart += "options:";
                                dbgrowthchart += "{";
                                dbgrowthchart += "responsive: true,";
                                dbgrowthchart += "tooltips:";
                                dbgrowthchart += "{";
                                dbgrowthchart += "mode: 'index',";
                                dbgrowthchart += "titleFontSize: 12,";
                                dbgrowthchart += "titleFontColor: '#000',";
                                dbgrowthchart += "bodyFontColor: '#000',";
                                dbgrowthchart += "backgroundColor: '#fff',";
                                dbgrowthchart += "titleFontFamily: 'Montserrat',";
                                dbgrowthchart += "bodyFontFamily: 'Montserrat',";
                                dbgrowthchart += "cornerRadius: 3,";
                                dbgrowthchart += "intersect: false,";
                                dbgrowthchart += "},";
                                dbgrowthchart += "legend:";
                                dbgrowthchart += "{";
                                dbgrowthchart += "display: true,";
                                dbgrowthchart += "position: 'top',";
                                dbgrowthchart += "labels:";
                                dbgrowthchart += "{";
                                dbgrowthchart += "usePointStyle: true,";
                                dbgrowthchart += "fontFamily: 'Montserrat',";
                                dbgrowthchart += "},";

                                dbgrowthchart += "},";
                                dbgrowthchart += "scales:";
                                dbgrowthchart += "{";
                                dbgrowthchart += "xAxes: [ {";
                                dbgrowthchart += "display: true,";
                                dbgrowthchart += "gridLines:";
                                dbgrowthchart += "{";
                                dbgrowthchart += "display: false,";
                                dbgrowthchart += "drawBorder: false";
                                dbgrowthchart += "},";
                                dbgrowthchart += "scaleLabel:";
                                dbgrowthchart += "{";
                                dbgrowthchart += "display: false,";
                                dbgrowthchart += "labelString: 'Month'";
                                dbgrowthchart += "}";
                                dbgrowthchart += "} ],";
                                dbgrowthchart += "yAxes: [ {";
                                dbgrowthchart += "display: true,";
                                dbgrowthchart += "gridLines:";
                                dbgrowthchart += "{";
                                dbgrowthchart += "display: false,";
                                dbgrowthchart += "drawBorder: false";
                                dbgrowthchart += "},";
                                dbgrowthchart += "scaleLabel:";
                                dbgrowthchart += "{";
                                dbgrowthchart += "display: true,";
                                dbgrowthchart += "labelString: 'Value'";
                                dbgrowthchart += "}";
                                dbgrowthchart += "} ]";
                                dbgrowthchart += "},";
                                dbgrowthchart += "title:";
                                dbgrowthchart += "{";
                                dbgrowthchart += "display: false,";
                                dbgrowthchart += "}";
                                dbgrowthchart += "}";

                                dbgrowthchart += "} );";
                                dbgrowthchart += "} )( jQuery );";
                                dbgrowthchart += "</script>";

                            }
                        
                            else
                            {
                                div_dbgrowthchart += "<div class='col -lg-6'>";
                                    div_dbgrowthchart += "<div class='card'>";
                                        div_dbgrowthchart += "<div class='card-body'>";
                                           div_dbgrowthchart += "No Data to Display";
                                        div_dbgrowthchart += "</div>";
                                    div_dbgrowthchart += "</div>";
                                div_dbgrowthchart += "</div>";
                            }

                            lt_DBGrowthChart.Text = div_dbgrowthchart;
                            lt_script_DbGrowthChart.Text = dbgrowthchart;
                            Literal1.Text = "Vimal";
                        }
                        //// For each table in the DataSet, print the row values.
                        //foreach (DataTable table in dt.Tables)
                        //{                            
                        //    foreach (DataRow row in table.Rows)
                        //    {

                        //        //// skip first row of table
                        //        //if (table.Rows.IndexOf(row) != 0)
                        //        //{
                        //            foreach (DataColumn column in table.Columns)
                        //            {
                        //                //var x = row[column].ToString();
                        //                //var ft = table.Columns.IndexOf(column).ToString();
                        //                var filetype = row["FileType"].ToString();
                        //                var data = row["Size"].ToString();
                        //                var dates = row["MDate"].ToString();

                        //            //Users user = new Users(filetype, data, dates);
                        //            //user.GetUserDetails();
                        //            }
                        //        //}
                        //    }
                        //}
                    }
                }
            }
        }
    }
}