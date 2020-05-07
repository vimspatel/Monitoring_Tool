using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;

namespace Monitoring_Tool
{
    public partial class admin_monitor_sp : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                this.BindGrid_Env_Detail();
                this.BindGrid_Service_List();
            }
        }

        private void BindGrid_Env_Detail()
        {
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                SqlCommand cmd = new SqlCommand();
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "SP_MASTER_INSERT_UPDATE_DELETE_Env";
                cmd.Parameters.AddWithValue("@StatementType", "Select");

                {
                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {
                        cmd.Connection = con;
                        sda.SelectCommand = cmd;
                        using (DataTable dt = new DataTable())
                        {
                            sda.Fill(dt);
                            gv_env_detail.EmptyDataText = "All Services Are Running!!";
                            gv_env_detail.DataSource = dt;
                            gv_env_detail.DataBind();
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Insert Env Detail
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnInsert_Env_Click(object sender, EventArgs e)
        {
            string Env_title = txtAdd_Env_Title.Text;
            string Env_Output = txtAdd_Env_Output.Text;
            string Env_For = ddlAdd_Env_For.SelectedValue;
            string Email_rec = txtAdd_email_recepient.Text;
            clearEnv_detail();

            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "SP_MASTER_INSERT_UPDATE_DELETE_Env";
                    cmd.Parameters.AddWithValue("@Env_Title", Env_title);
                    cmd.Parameters.AddWithValue("@Env_Output", Env_Output);
                    cmd.Parameters.AddWithValue("@Env_For", Env_For);
                    cmd.Parameters.AddWithValue("@Email_Recipient", Email_rec);
                    cmd.Parameters.AddWithValue("@StatementType", "Insert");

                    try
                    {
                        cmd.Connection = con;
                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();

                    }
                    catch
                    {
                        //do something else if there is an exception
                    }
                }
            }
            BindGrid_Env_Detail();
        }

        /// <summary>
        /// When the Edit Button is clicked, the GridView’s OnRowEditing event handler is triggered.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void gv_env_detail_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gv_env_detail.EditIndex = e.NewEditIndex;
            this.BindGrid_Env_Detail();
        }

        /// <summary>
        /// When the Update Button is clicked, the GridView’s OnRowUpdating event handler is triggered.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void gv_env_detail_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            GridViewRow row = gv_env_detail.Rows[e.RowIndex];
            int Env_ID = Convert.ToInt32(gv_env_detail.DataKeys[e.RowIndex].Values[0]);
            string Env_title = (row.FindControl("txtEnv_Title") as TextBox).Text;
            string Env_Output = (row.FindControl("txtEnv_Output") as TextBox).Text;
            string Env_For = (row.FindControl("txtEnv_For") as TextBox).Text;
            string Email_rec = (row.FindControl("txtEmail_Recipient") as TextBox).Text;

            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "SP_MASTER_INSERT_UPDATE_DELETE_Env";
                    cmd.Parameters.AddWithValue("@Env_ID", Env_ID);
                    cmd.Parameters.AddWithValue("@Env_Title", Env_title);
                    cmd.Parameters.AddWithValue("@Env_Output", Env_Output);
                    cmd.Parameters.AddWithValue("@Env_For", Env_For);
                    cmd.Parameters.AddWithValue("@Email_Recipient", Email_rec);
                    cmd.Parameters.AddWithValue("@StatementType", "Update");

                    try
                    {
                        cmd.Connection = con;
                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();

                    }
                    catch
                    {
                        //do something else if there is an exception
                    }
                }
            }
            gv_env_detail.EditIndex = -1;
            BindGrid_Env_Detail();
        }

        /// <summary>
        /// Edit Cancel 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void gv_env_detail_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gv_env_detail.EditIndex = -1;
            this.BindGrid_Env_Detail();
        }

        /// <summary>
        /// Delete Row in Gridview
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void gv_env_detail_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int Env_ID = Convert.ToInt32(gv_env_detail.DataKeys[e.RowIndex].Values[0]);
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "SP_MASTER_INSERT_UPDATE_DELETE_Env";
                    cmd.Parameters.AddWithValue("@Env_ID", Env_ID);
                    cmd.Parameters.AddWithValue("@StatementType", "Delete");

                    try
                    {
                        cmd.Connection = con;
                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();

                    }
                    catch
                    {
                        //do something else if there is an exception
                    }
                }
            }
            BindGrid_Env_Detail();
        }
        protected void gv_env_detail_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && e.Row.RowIndex != gv_env_detail.EditIndex)
            {
               //Delete confirmation
                (e.Row.Cells[5].Controls[2] as LinkButton).Attributes["onclick"] = "return confirm('Do you want to delete this row?');";
            }

            if (e.Row.RowType == DataControlRowType.DataRow && gv_env_detail.EditIndex == e.Row.RowIndex)
            {
                //selected value from the dropdown in gridview edit template.
                DropDownList ddl_Env_For = (DropDownList)e.Row.FindControl("ddl_Env_For");

                string selected = DataBinder.Eval(e.Row.DataItem, "Env_For").ToString();
                ddl_Env_For.SelectedValue = selected;
            }

        }



        protected void gv_env_detail_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gv_env_detail.PageIndex = e.NewPageIndex;
            this.BindGrid_Env_Detail();
        }

        protected void btnCancel_Env_Click(object sender, EventArgs e)
        {
            clearEnv_detail();
        }

        protected void clearEnv_detail()
        {
            txtAdd_Env_Title.Text = "";
            txtAdd_Env_Output.Text = "";
            ddlAdd_Env_For.SelectedValue = "";
            txtAdd_email_recepient.Text = "";
        }






        private void BindGrid_Service_List()
        {
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                SqlCommand cmd = new SqlCommand();
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "SP_MASTER_INSERT_UPDATE_DELETE_SERVICE";
                cmd.Parameters.AddWithValue("@StatementType", "Select");

                {
                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {
                        cmd.Connection = con;
                        sda.SelectCommand = cmd;
                        using (DataTable dt = new DataTable())
                        {
                            sda.Fill(dt);
                            gv_service.EmptyDataText = "All Services Are Running!!";
                            gv_service.DataSource = dt;
                            gv_service.DataBind();
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Insert Service Detail
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnInsert_Service_List_Click(object sender, EventArgs e)
        {
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "SP_MASTER_INSERT_UPDATE_DELETE_SERVICE";
                    cmd.Parameters.Add("@Description",SqlDbType.VarChar,100).Value = txtAdd_S_Description.Text.Trim();
                    cmd.Parameters.Add("@Server_Name", SqlDbType.VarChar,100).Value = txtAdd_Server_Name.Text.Trim();
                    cmd.Parameters.Add("@Service_Name", SqlDbType.VarChar,100).Value = txtAdd_Service_Name.Text.Trim();
                    cmd.Parameters.Add("@Env_Search_String", SqlDbType.VarChar, 100).Value = txtAdd_Env_Search_String.Text.Trim();
                    cmd.Parameters.Add("@Notify_Flag", SqlDbType.Bit).Value = Convert.ToInt32(chkAdd_S_Notify_FLag.SelectedValue);
                    cmd.Parameters.Add("@Env_ID", SqlDbType.Int).Value = txtAdd_S_Env_ID.Text.Trim();
                    cmd.Parameters.Add("@Active_Flag", SqlDbType.Bit).Value = Convert.ToInt32(chkAdd_S_Active_Flag.SelectedValue);
                    cmd.Parameters.Add("@StatementType", SqlDbType.NVarChar, 20).Value = "Insert";

                    try
                    {
                        cmd.Connection = con;
                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                        catch
                    {
                        //do something else if there is an exception
                    }
                }
            }

            clearservicelist();
            BindGrid_Service_List();
        }

        /// <summary>
        /// When the Edit Button is clicked, the GridView’s OnRowEditing event handler is triggered.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void gv_service_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gv_service.EditIndex = e.NewEditIndex;
            this.BindGrid_Service_List();
        }

        /// <summary>
        /// When the Update Button is clicked, the GridView’s OnRowUpdating event handler is triggered.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void gv_service_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            GridViewRow row = gv_service.Rows[e.RowIndex];
            int Service_ID = Convert.ToInt32(gv_service.DataKeys[e.RowIndex].Values[0]);
            string Description = (row.FindControl("etxtS_Description") as TextBox).Text;
            string Server_Name = (row.FindControl("etxtServer_Name") as TextBox).Text;
            string Service_Name = (row.FindControl("etxtService_Name") as TextBox).Text;
            string Env_Search_String = (row.FindControl("etxtEnv_Search_String") as TextBox).Text;
            string Notify_Flag = (row.FindControl("echk_S_Notify_FLag") as CheckBoxList).SelectedValue;
            string Env_ID = (row.FindControl("etxtS_Env_ID") as TextBox).Text;
            string Active_Flag = (row.FindControl("echk_S_Active_Flag") as CheckBoxList).SelectedValue;

            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "SP_MASTER_INSERT_UPDATE_DELETE_Env";
                    cmd.Parameters.AddWithValue("@Service_ID", Service_ID);
                    cmd.Parameters.AddWithValue("@Description", Description);
                    cmd.Parameters.AddWithValue("@Server_Name", Server_Name);
                    cmd.Parameters.AddWithValue("@Service_Name", Service_Name);
                    cmd.Parameters.AddWithValue("@Env_Search_String", Env_Search_String);
                    cmd.Parameters.AddWithValue("@Notify_Flag", Notify_Flag);
                    cmd.Parameters.AddWithValue("@Env_ID", Env_ID);
                    cmd.Parameters.AddWithValue("@Active_Flag", Active_Flag);
                    cmd.Parameters.AddWithValue("@StatementType", "Update");

                    try
                    {
                        cmd.Connection = con;
                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();

                    }
                    catch
                    {
                        //do something else if there is an exception
                    }
                }
            }
            gv_service.EditIndex = -1;
            BindGrid_Service_List();
        }

        /// <summary>
        /// Edit Cancel 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void gv_service_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gv_service.EditIndex = -1;
            this.BindGrid_Service_List();
        }

        /// <summary>
        /// Delete Row in Gridview
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void gv_service_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int Service_ID = Convert.ToInt32(gv_service.DataKeys[e.RowIndex].Values[0]);
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "SP_MASTER_INSERT_UPDATE_DELETE_Env";
                    cmd.Parameters.AddWithValue("@Service_ID", Service_ID);
                    cmd.Parameters.AddWithValue("@StatementType", "Delete");

                    try
                    {
                        cmd.Connection = con;
                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();

                    }
                    catch
                    {
                        //do something else if there is an exception
                    }
                }
            }
            BindGrid_Service_List();
        }
        protected void gv_service_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && e.Row.RowIndex != gv_service.EditIndex)
            {
                (e.Row.Cells[8].Controls[2] as LinkButton).Attributes["onclick"] = "return confirm('Do you want to delete this row?');";
            }
        }

        protected void gv_service_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gv_service.PageIndex = e.NewPageIndex;
            this.BindGrid_Service_List();
        }

        protected void btnClear_Service_list_Click(object sender, EventArgs e)
        {
            clearservicelist();
        }

        protected void clearservicelist()
        {
            txtAdd_S_Description.Text = "";
            txtAdd_Server_Name.Text = "";
            txtAdd_Service_Name.Text = "";
            txtAdd_Env_Search_String.Text = "";
            chkAdd_S_Notify_FLag.SelectedValue = null;
            txtAdd_S_Env_ID.Text = "";
            chkAdd_S_Active_Flag.SelectedValue = null;
        }
        
    }
}