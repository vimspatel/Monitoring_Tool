using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace Monitoring_Tool
{
    public partial class stopped_sp : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                BindGrid_stopped_service();
                BindGrid_stopped_process();
            }
        }

        private void BindGrid_stopped_service()
        {
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                SqlCommand cmd = new SqlCommand();
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "SP_NONRUNNING_SERVICES";
                cmd.Parameters.Add("@service_lastrun", SqlDbType.DateTime);
                cmd.Parameters["@service_lastrun"].Direction = ParameterDirection.Output;

                {
                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {
                        cmd.Connection = con;
                        sda.SelectCommand = cmd;
                        using (DataTable dt = new DataTable())
                        {
                            sda.Fill(dt);
                            gv_stopped_services.EmptyDataText = "All Services Are Running!!";
                            gv_stopped_services.DataSource = dt;
                            gv_stopped_services.DataBind();
                            lbl_slastrun.Text = cmd.Parameters["@service_lastrun"].Value.ToString();
                        }
                    }
                }
            }
        }


        protected void gv_stopped_services_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string s_status = e.Row.Cells[4].Text;

                if (s_status == "Stopped")
                {
                    e.Row.Cells[4].Text = "<span class='badge badge-pending'>Stopped</span>";
                }
                else
                {
                    e.Row.Cells[4].Text = "<span class='badge badge-complete'>Running</span>";
                }
            }
        }


        private void BindGrid_stopped_process()
        {
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                SqlCommand cmd = new SqlCommand();
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "SP_NONRUNNING_PROCESSES";
                cmd.Parameters.Add("@process_lastrun", SqlDbType.DateTime);
                cmd.Parameters["@process_lastrun"].Direction = ParameterDirection.Output;

                {
                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {
                        cmd.Connection = con;
                        sda.SelectCommand = cmd;
                        using (DataTable dt = new DataTable())
                        {
                            sda.Fill(dt);
                            gv_stopped_process.EmptyDataText = "All Process are running!!";
                            gv_stopped_process.DataSource = dt;
                            gv_stopped_process.DataBind();
                            lbl_plastrun.Text = cmd.Parameters["@process_lastrun"].Value.ToString();
                        }
                    }
                }
            }
        }


        protected void gv_stopped_process_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string s_status = e.Row.Cells[4].Text;

                if (s_status == "Not Running")
                {
                    e.Row.Cells[4].Text = "<span class='badge badge-pending'>Stopped</span>";
                }
                else
                {
                    e.Row.Cells[4].Text = "<span class='badge badge-complete'>Running</span>";
                }
            }
        }
    }
}