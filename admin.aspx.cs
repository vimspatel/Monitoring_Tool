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
    public partial class admin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                this.BindGrid_Role_List();
                this.BindGrid_logins();
                txtAdd_User_ID.ReadOnly = true;
            }
        }




        private void BindGrid_logins()
        {
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                SqlCommand cmd = new SqlCommand();
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "SP_MASTER_INSERT_UPDATE_DELETE_LOGINS";
                cmd.Parameters.AddWithValue("@StatementType", "Select");

                {
                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {
                        cmd.Connection = con;
                        sda.SelectCommand = cmd;
                        using (DataTable dt = new DataTable())
                        {
                            sda.Fill(dt);
                            gv_logins.EmptyDataText = "No User found!!";
                            gv_logins.DataSource = dt;
                            gv_logins.DataBind();
                        }
                    }
                }
            }
        }

        private void BindGrid_Role_List()
        {
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand("Select Role_ID, Role_Name FROM VP_Role"))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Connection = con;
                    con.Open();
                    ddlAdd_Role_List.DataSource = cmd.ExecuteReader();
                    ddlAdd_Role_List.DataTextField = "Role_Name";
                    ddlAdd_Role_List.DataValueField = "Role_ID";
                    ddlAdd_Role_List.DataBind();
                    con.Close();
                }
            }
            ddlAdd_Role_List.Items.Insert(0, new ListItem("--Select--", "0"));
        }
        /// <summary>
        /// Insert User
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnInsert_User_Click(object sender, EventArgs e)
        {
            string UserName = txtAdd_Username.Text;
            string Password = txtAdd_Password.Text;
            string Role_ID = ddlAdd_Role_List.SelectedValue;
            

            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "SP_MASTER_INSERT_UPDATE_DELETE_LOGINS";
                    cmd.Parameters.AddWithValue("@UserName", UserName);
                    cmd.Parameters.AddWithValue("@Password", Password);
                    cmd.Parameters.AddWithValue("@Role_id", Role_ID);
                    cmd.Parameters.AddWithValue("@StatementType", "Insert");

                    try
                    {
                        cmd.Connection = con;
                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                        clearUser();
                    }
                    catch
                    {
                        //do something else if there is an exception
                    }
                }
            }
            
            BindGrid_logins();
        }

        /// <summary>
        /// When the Edit Button is clicked, the GridView’s OnRowEditing event handler is triggered.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void gv_logins_RowEditing(object sender, GridViewEditEventArgs e)
        {            
            gv_logins.EditIndex = e.NewEditIndex;
            this.BindGrid_logins();
        }

        /// <summary>
        /// When the Update Button is clicked, the GridView’s OnRowUpdating event handler is triggered.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void gv_logins_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            GridViewRow row = gv_logins.Rows[e.RowIndex];
            int User_ID = Convert.ToInt32(gv_logins.DataKeys[e.RowIndex].Values[0]);
            string UserName = (row.FindControl("txtUserName") as TextBox).Text;
            string Password = (row.FindControl("txtPassword") as TextBox).Text;
            string Role_ID = (row.FindControl("ddl_Role_List") as DropDownList).SelectedValue;
            
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "SP_MASTER_INSERT_UPDATE_DELETE_LOGINS";
                    cmd.Parameters.AddWithValue("@User_ID", User_ID);
                    cmd.Parameters.AddWithValue("@UserName", UserName);
                    cmd.Parameters.AddWithValue("@Password", Password);
                    cmd.Parameters.AddWithValue("@Role_id", Role_ID);
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
            gv_logins.EditIndex = -1;
            BindGrid_logins();
        }

        /// <summary>
        /// Edit Cancel 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void gv_logins_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gv_logins.EditIndex = -1;
            this.BindGrid_logins();
        }

        /// <summary>
        /// Delete Row in Gridview
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void gv_logins_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int User_ID = Convert.ToInt32(gv_logins.DataKeys[e.RowIndex].Values[0]);
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "SP_MASTER_INSERT_UPDATE_DELETE_LOGINS";
                    cmd.Parameters.AddWithValue("@User_ID", User_ID);
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
            BindGrid_logins();
        }
        protected void gv_logins_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // gridview to render <thead> <tbody>
            if (e.Row.RowType == DataControlRowType.Header)
            {
                e.Row.TableSection = TableRowSection.TableHeader;
            }
            if (e.Row.RowType == DataControlRowType.DataRow && e.Row.RowIndex != gv_logins.EditIndex)
            {
                //Delete confirmation
                (e.Row.Cells[4].Controls[2] as LinkButton).Attributes["onclick"] = "return confirm('Do you want to delete this row?');";
            }

            if (e.Row.RowType == DataControlRowType.DataRow && gv_logins.EditIndex == e.Row.RowIndex)
            {
                //selected value from the dropdown in gridview edit template.
                DropDownList ddl_Role_List = (DropDownList)e.Row.FindControl("ddl_Role_List");

                string selected = DataBinder.Eval(e.Row.DataItem, "Role_ID").ToString();
                ddl_Role_List.SelectedValue = selected;
            }

            // read only txtbox
            if (e.Row.RowState == DataControlRowState.Edit || e.Row.RowState == DataControlRowState.Alternate)
            {
                //on you condition
                TextBox txt = (TextBox)e.Row.FindControl("txtUser_ID");
                if (txt != null)
                {
                    txt.Attributes.Add("readonly", "readonly");

                }
            }

        }

        protected void gv_logins_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gv_logins.PageIndex = e.NewPageIndex;
            this.BindGrid_logins();
        }

        protected void btnCancel_User_Click(object sender, EventArgs e)
        {
            clearUser();
        }

        protected void clearUser()
        {
            txtAdd_User_ID.Text = "";
            txtAdd_Username.Text = "";
            ddlAdd_Role_List.SelectedValue = "";
        }

    }
}