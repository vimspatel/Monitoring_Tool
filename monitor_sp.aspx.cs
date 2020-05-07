using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;

namespace Monitoring_Tool
{
    public partial class monitor_sp : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)  // If page loads for first time
            {
            BindGrid_all_service();
            BindGrid_all_Process();
            }
        }

        private void BindGrid_all_service()
        {
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                SqlCommand cmd = new SqlCommand();
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "SP_SERVICES_STATUS";
                cmd.Parameters.Add("@lastrun", SqlDbType.DateTime);
                cmd.Parameters["@lastrun"].Direction = ParameterDirection.Output;


                {
                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {
                        cmd.Connection = con;
                        sda.SelectCommand = cmd;
                        DataSet ds = new DataSet();
                        sda.Fill(ds);


                        lbl_lastrun.Text = cmd.Parameters["@lastrun"].Value.ToString();
                        StringBuilder sb = new StringBuilder();

                        foreach(DataTable t in ds.Tables)
                        {
                            string i = t.Rows[0]["Env_Title"].ToString();
                            string j = i.Replace(" ","_s");

                            sb.Append("<div class='accordion' id='accordionService'>");
                            sb.Append("<div class='card'>");
                            sb.Append("<div class='card-header'>");
                            sb.Append("<button class='btn btn-link' type='button' data-toggle='collapse' data-target='#");
                            sb.Append(j);
                            sb.Append("'aria-expanded='true' aria-controls='");
                            sb.Append(j+"'>");
                            sb.Append("<strong class='card-title'>");
                            sb.Append(i + " - Services");
                            sb.Append("</strong>");
                            sb.Append("</button></div>");
                            sb.Append("<div id = '");
                            sb.Append(j);
                            sb.Append("' class='collapse show' aria-labelledby='headingOne' data-parent='#accordionService'>");

                            //accordian body
                            //Table start.
                            sb.Append("<div class='table-stats order-table ov-h'>");
                            sb.Append("<table class='table'>");

                            //Adding HeaderRow.
                            sb.Append("<thead><tr>");
                            foreach (DataColumn column in t.Columns)
                            {
                                sb.Append("<th>" + column.ColumnName + "</th>");
                            }
                            sb.Append("</tr></thead>");

                            //Adding DataRow.
                            foreach (DataRow row in t.Rows)
                            {
                                sb.Append("<tr>");
                                foreach (DataColumn column in t.Columns)
                                {
                                    if(row[column.ColumnName].ToString() == "Stopped" || row[column.ColumnName].ToString() == "Not Running")
                                    {
                                        sb.Append("<td><span class='badge badge-pending'>" + row[column.ColumnName].ToString() + "</span></td>");
                                    }
                                    else if(row[column.ColumnName].ToString() == "Running" )
                                    {
                                        sb.Append("<td><span class='badge badge-complete'>" + row[column.ColumnName].ToString() + "</span></td>");
                                    }
                                    else
                                    {
                                        sb.Append("<td>" + row[column.ColumnName].ToString() + "</td>");
                                    }
                                }
                                sb.Append("</tr>");
                            }

                            //Table end.
                            sb.Append("</table>");

                            //accordian body end
                            sb.Append("</div>");
                            sb.Append("</div>");
                            sb.Append("</div>");

                        }

                        ltService_Table.Text = sb.ToString();

                        //foreach (DataTable t in ds.Tables)
                        //{
                        //    string i = t.Rows[0]["Env_Title"].ToString();
                        //    string j = "gv" + i;
                        //    GridView objGV = new GridView();
                        //    objGV.ID = j; // ID of each grid view must be unique

                        //    sda.Fill(t);
                        //    objGV.DataSource = t;
                        //    objGV.DataBind();
                        //    pnlResult.Controls.Add(child: objGV);

                        //}

                        //foreach (DataTable t in ds.Tables)
                        //{
                        //    foreach (DataRow row in t.Rows)
                        //    {
                        //        foreach (DataColumn col in t.Columns)
                        //        {
                        //            //Do with row[col]……
                        //        }
                        //    }
                        //}
                    }
                }
            }
        }
        private void BindGrid_all_Process()
        {
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                SqlCommand cmd = new SqlCommand();
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "SP_PROCESS_STATUS";
                cmd.Parameters.Add("@lastrun", SqlDbType.DateTime);
                cmd.Parameters["@lastrun"].Direction = ParameterDirection.Output;


                {
                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {
                        cmd.Connection = con;
                        sda.SelectCommand = cmd;
                        DataSet ds = new DataSet();
                        sda.Fill(ds);


                        lbl_lastrun.Text = cmd.Parameters["@lastrun"].Value.ToString();
                        StringBuilder sb = new StringBuilder();

                        foreach (DataTable t in ds.Tables)
                        {
                            string i = t.Rows[0]["Env_Title"].ToString();
                            string j = i.Replace(" ", "_p");

                            sb.Append("<div class='accordion' id='accordionProcess'>");
                            sb.Append("<div class='card'>");
                            sb.Append("<div class='card-header'>");
                            sb.Append("<button class='btn btn-link' type='button' data-toggle='collapse' data-target='#");
                            sb.Append(j);
                            sb.Append("'aria-expanded='true' aria-controls='");
                            sb.Append(j + "'>");
                            sb.Append("<strong class='card-title'>");
                            sb.Append(i + " - Process");
                            sb.Append("</strong>");
                            sb.Append("</button></div>");
                            sb.Append("<div id = '");
                            sb.Append(j);
                            sb.Append("' class='collapse show' aria-labelledby='headingOne' data-parent='#accordionProcess'>");

                            //accordian body
                            //Table start.
                            sb.Append("<div class='table-stats order-table ov-h'>");
                            sb.Append("<table class='table'>");

                            //Adding HeaderRow.
                            sb.Append("<thead><tr>");
                            foreach (DataColumn column in t.Columns)
                            {
                                sb.Append("<th>" + column.ColumnName + "</th>");
                            }
                            sb.Append("</tr></thead>");

                            //Adding DataRow.
                            foreach (DataRow row in t.Rows)
                            {
                                sb.Append("<tr>");
                                foreach (DataColumn column in t.Columns)
                                {
                                    if (row[column.ColumnName].ToString() == "Stopped" || row[column.ColumnName].ToString() == "Not Running")
                                    {
                                        sb.Append("<td><span class='badge badge-pending'>" + row[column.ColumnName].ToString() + "</span></td>");
                                    }
                                    else if (row[column.ColumnName].ToString() == "Running")
                                    {
                                        sb.Append("<td><span class='badge badge-complete'>" + row[column.ColumnName].ToString() + "</span></td>");
                                    }
                                    else
                                    {
                                        sb.Append("<td>" + row[column.ColumnName].ToString() + "</td>");
                                    }
                                }
                                sb.Append("</tr>");
                            }

                            //Table end.
                            sb.Append("</table>");

                            //accordian body end
                            sb.Append("</div>");
                            sb.Append("</div>");
                            sb.Append("</div>");

                        }

                        ltProcess_Table.Text = sb.ToString();
                                                
                    }
                }
            }
        }
    }
}