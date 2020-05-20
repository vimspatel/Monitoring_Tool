using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Monitoring_Tool
{
    public partial class Master : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblErrorMessage.Visible = false;

            if (!IsPostBack)
            {
                if(Request.Cookies["username"] !=null && Request.Cookies["password"] != null)
                {
                    txtUserName.Text = Request.Cookies["username"].Value;
                    txtPassword.Attributes["value"] = Request.Cookies["password"].Value;
                }
            }
        }

        protected void SiteMapPath_breadcrumb_ItemCreated(object sender, SiteMapNodeItemEventArgs e)
        {
            //hidding dummy root and pathseperator dynamically
            if (e.Item.ItemType == SiteMapNodeItemType.Root ||
                e.Item.ItemType == SiteMapNodeItemType.PathSeparator && e.Item.ItemIndex == 1)
            {
                e.Item.Visible = false;
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection sqlCon = new SqlConnection(constr))
            {
                sqlCon.Open();
                string query = "SELECT COUNT(1) FROM VP_User WHERE username=@username AND password=@password";
                SqlCommand sqlCmd = new SqlCommand(query, sqlCon);
                sqlCmd.Parameters.AddWithValue("@username", txtUserName.Text.Trim());
                sqlCmd.Parameters.AddWithValue("@password", txtPassword.Text.Trim());
                int count = Convert.ToInt32(sqlCmd.ExecuteScalar());
                if (count == 1)
                {
                    if (Chk_rememberme.Checked)
                    {
                        Response.Cookies["username"].Value = txtUserName.Text;
                        Response.Cookies["password"].Value = txtPassword.Text;
                        Response.Cookies["username"].Expires = DateTime.Now.AddMinutes(1);
                        Response.Cookies["password"].Expires = DateTime.Now.AddMinutes(1);
                    }
                    else
                    {
                        Response.Cookies["username"].Expires = DateTime.Now.AddMinutes(-1);
                        Response.Cookies["password"].Expires = DateTime.Now.AddMinutes(-1);
                    }

                    Session["username"] = txtUserName.Text.Trim();
                    Response.Redirect("admin_monitor_sp.aspx");
                }
                else { lblErrorMessage.Visible = true; }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("Splash_page.aspx");
        }
    }
}