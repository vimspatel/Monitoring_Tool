using System;
using System.Collections.Generic;
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
    }
}