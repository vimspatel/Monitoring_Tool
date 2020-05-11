<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="Monitoring_Tool.monitoring_pages.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="Label1" runat="server" Text="Label" ForeColor="green"></asp:Label>
        </div>
        
            <hr />
            <div>
                <asp:Label ID="Label2" runat="server" Text="Label" ForeColor="red"><br />
                </asp:Label>
                <hr />
            </div>
        <div>
            <asp:Label ID="Label3" runat="server" Text="Label"></asp:Label>
        </div>
    </form>
</body>
</html>
