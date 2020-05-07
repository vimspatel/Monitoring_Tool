<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="admin_monitor_sp.aspx.cs" Inherits="Monitoring_Tool.admin_monitor_sp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script type="text/javascript" src="assets/js/custom/jquery.blockUI.js"></script>
<script type="text/javascript">
    $(function () {
        BlockUI("dvGrid");
        $.blockUI.defaults.css = {};
    });
    function BlockUI(elementID) {
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_beginRequest(function () {
            $("#" + elementID).block({ message: '<div align = "center">' + '<img src="images/loadingAnim.gif"/></div>',
                css: {},
                overlayCSS: { backgroundColor: '#000000', opacity: 0.6, border: '3px solid #63B2EB' }
            });
        });
        prm.add_endRequest(function () {
            $("#" + elementID).unblock();
        });
    };
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
</asp:ScriptManager>
<div id="dvGrid">
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <asp:GridView ID="gv_env_detail" runat="server" AutoGenerateColumns="false" OnRowDataBound="gv_env_detail_RowDataBound"
            DataKeyNames="Env_ID" OnRowEditing="gv_env_detail_RowEditing" OnRowCancelingEdit="gv_env_detail_RowCancelingEdit" PageSize = "5" AllowPaging ="true" OnPageIndexChanging = "gv_env_detail_PageIndexChanging"
            OnRowUpdating="gv_env_detail_RowUpdating" OnRowDeleting="gv_env_detail_RowDeleting" EmptyDataText="No records has been added.">
            <Columns>
                <asp:TemplateField HeaderText="Env ID">
                    <ItemTemplate>
                        <asp:Label ID="lblEnv_ID" runat="server" Text='<%# Eval("Env_ID") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtEnv_ID" runat="server" Text='<%# Eval("Env_ID") %>' ></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfv_Env_Id" runat="server" ControlToValidate="txtEnv_ID" ErrorMessage="Required*" ValidationGroup="vg_Env_Detail"></asp:RequiredFieldValidator>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Environment" >
                    <ItemTemplate>
                        <asp:Label ID="lblEnv_Title" runat="server" Text='<%# Eval("Env_Title") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtEnv_Title" runat="server" Text='<%# Eval("Env_Title") %>' ></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfv_Env_Title" runat="server" ControlToValidate="txtEnv_Title" ErrorMessage="Required*" ValidationGroup="vg_Env_Detail"></asp:RequiredFieldValidator>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Env Output" >
                    <ItemTemplate>
                        <asp:Label ID="lblEnv_Output" runat="server" Text='<%# Eval("Env_Output") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtEnv_Output" runat="server" Text='<%# Eval("Env_Output") %>' ></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfv_Env_Output" runat="server" ControlToValidate="txtEnv_Output" ErrorMessage="Required*" ValidationGroup="vg_Env_Detail"></asp:RequiredFieldValidator>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="For" >
                    <ItemTemplate>
                        <asp:Label ID="lblEnv_For" runat="server" Text='<%# Eval("Env_For") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddl_Env_For" runat="server" >
                            <asp:ListItem Value="" Text="- Select -"></asp:ListItem>
                            <asp:ListItem Value="Service" Text="Service"></asp:ListItem>
                            <asp:ListItem Value="Process" Text="Process"></asp:ListItem>
                    </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfv_Env_For" runat="server" ControlToValidate="txtEnv_For" ErrorMessage="Required*" ValidationGroup="vg_Env_Detail"></asp:RequiredFieldValidator>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Email Recipient" >
                    <ItemTemplate>
                        <asp:Label ID="lblEmail_Recipient" runat="server" Text='<%# Eval("Email_Recipient") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtEmail_Recipient" runat="server" Text='<%# Eval("Email_Recipient") %>'></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfv_Env_Recipient" runat="server" ControlToValidate="txtEmail_Recipient" ErrorMessage="Required*" ValidationGroup="vg_Env_Detail"></asp:RequiredFieldValidator>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:CommandField ButtonType="Link" EditText="<i class='fa fa-pencil-square-o'></i>" DeleteText="<i class='fa fa-trash-o'></i>" ShowEditButton="true" ShowDeleteButton="true" ValidationGroup="vg_Env_Detail"/>
            </Columns>
        </asp:GridView>
        <table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse">
            <tr>
                <td style="width: 150px">
                    Name:<br />
                    <asp:TextBox ID="txtAdd_Env_Title" runat="server"/>
                        <asp:RequiredFieldValidator ID="rfv_Add_Env_Title" runat="server" ControlToValidate="txtAdd_Env_Title" ErrorMessage="Required*" ValidationGroup="vg_Env_Detail_int"></asp:RequiredFieldValidator>
                </td>
                <td style="width: 150px">
                    Environment Output:<br />
                    <asp:TextBox ID="txtAdd_Env_Output" runat="server" />
                        <asp:RequiredFieldValidator ID="rfv_Add_Env_OUtput" runat="server" ControlToValidate="txtAdd_Env_Output" ErrorMessage="Required*" ValidationGroup="vg_Env_Detail_int"></asp:RequiredFieldValidator>
                </td>
                <td style="width: 150px">
                    Service/Process:<br />
                    <asp:DropDownList ID="ddlAdd_Env_For" runat="server">
                        <asp:ListItem Value="" Text="- Select -"></asp:ListItem>
                        <asp:ListItem Value="Service" Text="Service"></asp:ListItem>
                        <asp:ListItem Value="Process" Text="Process"></asp:ListItem>
                    </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfv_Add_Env_For" runat="server" ControlToValidate="ddlAdd_Env_For" InitialValue="" ErrorMessage="Required*" ValidationGroup="vg_Env_Detail_int"></asp:RequiredFieldValidator>
                </td>
                <td style="width: 150px">
                    Email Recipient:<br />
                    <asp:TextBox ID="txtAdd_email_recepient" runat="server" />
                        <asp:RequiredFieldValidator ID="rfv_Add_email_recepient" runat="server" ControlToValidate="txtAdd_email_recepient" ErrorMessage="Required*" ValidationGroup="vg_Env_Detail_int"></asp:RequiredFieldValidator>
                </td>
                <td style="width: 150px">
                    <asp:Button ID="btnInsert_Env" runat="server" Text="Add" OnClick="btnInsert_Env_Click" ValidationGroup="vg_Env_Detail_int"/>
                    <asp:Button ID="btnCancel_Env" runat="server" Text="Clear" OnClick="btnCancel_Env_Click"/>
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>


<asp:UpdatePanel ID="UpdatePanel2" runat="server">
    <ContentTemplate>
        <asp:GridView ID="gv_service" runat="server" AutoGenerateColumns="false" OnRowDataBound="gv_service_RowDataBound"
            DataKeyNames="Service_ID" OnRowEditing="gv_service_RowEditing" OnRowCancelingEdit="gv_service_RowCancelingEdit" PageSize = "5" AllowPaging ="true" OnPageIndexChanging = "gv_service_PageIndexChanging"
            OnRowUpdating="gv_service_RowUpdating" OnRowDeleting="gv_service_RowDeleting" EmptyDataText="No records has been added.">
            <Columns>
                <asp:TemplateField HeaderText="Service ID">
                    <ItemTemplate>
                        <asp:Label ID="lblService_ID" runat="server" Text='<%# Eval("Service_ID") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="etxtService_ID" runat="server" Text='<%# Eval("Service_ID") %>' ></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfv_Service_ID" runat="server" ControlToValidate="etxtService_ID" ErrorMessage="Required*" ValidationGroup="vg_Service_List"></asp:RequiredFieldValidator>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Description" >
                    <ItemTemplate>
                        <asp:Label ID="lblS_Description" runat="server" Text='<%# Eval("Description") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="etxtS_Description" runat="server" Text='<%# Eval("Description") %>' ></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfv_S_Description" runat="server" ControlToValidate="etxtS_Description" ErrorMessage="Required*" ValidationGroup="vg_Service_List"></asp:RequiredFieldValidator>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Server Name" >
                    <ItemTemplate>
                        <asp:Label ID="lblServer_Name" runat="server" Text='<%# Eval("Server_Name") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="etxtServer_Name" runat="server" Text='<%# Eval("Server_Name") %>' ></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfv_Server_Name" runat="server" ControlToValidate="etxtServer_Name" ErrorMessage="Required*" ValidationGroup="vg_Service_List"></asp:RequiredFieldValidator>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Service Name" >
                    <ItemTemplate>
                        <asp:Label ID="lblService_Name" runat="server" Text='<%# Eval("Service_Name") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="etxtService_Name" runat="server" Text='<%# Eval("Service_Name") %>' ></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfv_Service_Name" runat="server" ControlToValidate="etxtService_Name" ErrorMessage="Required*" ValidationGroup="vg_Service_List"></asp:RequiredFieldValidator>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Search String" >
                    <ItemTemplate>
                        <asp:Label ID="lblEnv_Search_String" runat="server" Text='<%# Eval("Env_Search_String") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="etxtEnv_Search_String" runat="server" Text='<%# Eval("Env_Search_String") %>'></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfv_Env_Recipient" runat="server" ControlToValidate="etxtEnv_Search_String" ErrorMessage="Required*" ValidationGroup="vg_Service_List"></asp:RequiredFieldValidator>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Notify" >
                    <ItemTemplate>
                        <asp:CheckBox ID="lbl_chk_S_Notify_Flag" runat="server" Checked='<%#bool.Parse(Eval("Notify_Flag").ToString())%>'></asp:CheckBox>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:CheckBox ID="echk_S_Notify_Flag" runat="server" Checked='<%#bool.Parse(Eval("Notify_Flag").ToString())%>'></asp:CheckBox>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Environment" >
                    <ItemTemplate>
                        <asp:Label ID="lblS_Env_ID" runat="server" Text='<%# Eval("Env_ID") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="etxtS_Env_ID" runat="server" Text='<%# Eval("Env_ID") %>'></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Active" >
                    <ItemTemplate>
                        <asp:CheckBox ID="lbl_chk_S_Active_Flag" runat="server" Checked='<%#bool.Parse(Eval("Active_Flag").ToString())%>'></asp:CheckBox>
                    </ItemTemplate>
                    <EditItemTemplate>
                              <asp:CheckBox ID="echk_S_Active_Flag" runat="server" Checked='<%#bool.Parse(Eval("Active_Flag").ToString())%>'></asp:CheckBox>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:CommandField ButtonType="Link" EditText="<i class='fa fa-pencil-square-o'></i>" DeleteText="<i class='fa fa-trash-o'></i>" ShowEditButton="true" ShowDeleteButton="true" ValidationGroup="vg_Service_List"/>
            </Columns>
        </asp:GridView>
        <table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse">
            <tr>
                <td style="width: 150px">
                    Desc:<br />
                    <asp:TextBox ID="txtAdd_S_Description" runat="server"/>
                        <asp:RequiredFieldValidator ID="rfv_S_Description" runat="server" ControlToValidate="txtAdd_S_Description" ErrorMessage="Required*" ValidationGroup="vg_Service_List_int"></asp:RequiredFieldValidator>
                </td>
                <td style="width: 150px">
                    Server Name:<br />
                    <asp:TextBox ID="txtAdd_Server_Name" runat="server" />
                        <asp:RequiredFieldValidator ID="rfv_Add_Server_name" runat="server" ControlToValidate="txtAdd_Server_Name" ErrorMessage="Required*" ValidationGroup="vg_Service_List_int"></asp:RequiredFieldValidator>
                </td>
                <td style="width: 150px">
                    Service Name:<br />
                    <asp:TextBox ID="txtAdd_Service_Name" runat="server" />
                        <asp:RequiredFieldValidator ID="rfv_Add_Service_Name" runat="server" ControlToValidate="txtAdd_Service_Name" ErrorMessage="Required*" ValidationGroup="vg_Service_List_int"></asp:RequiredFieldValidator>
                </td>
                <td style="width: 150px">
                    Search String:<br />
                    <asp:TextBox ID="txtAdd_Env_Search_String" runat="server" />
                        <asp:RequiredFieldValidator ID="rfv_Add_Env_Search_String" runat="server" ControlToValidate="txtAdd_Env_Search_String" ErrorMessage="Required*" ValidationGroup="vg_Service_List_int"></asp:RequiredFieldValidator>
                </td>
                <td style="width: 150px">
                    Notify:<br />
                    <asp:CheckBoxList ID="chkAdd_S_Notify_FLag" runat="server">
                        <asp:ListItem Value="1" Text ="Yes"></asp:ListItem>
                        <asp:ListItem Value="0" Text ="No"></asp:ListItem>
                    </asp:CheckBoxList>
                        </td>
                <td style="width: 150px">
                    Env ID:<br />
                    <asp:TextBox ID="txtAdd_S_Env_ID" runat="server" />
                        <asp:RequiredFieldValidator ID="rfv_Add_S_Env_ID" runat="server" ControlToValidate="txtAdd_S_Env_ID" ErrorMessage="Required*" ValidationGroup="vg_Service_List_int"></asp:RequiredFieldValidator>
                </td>
                <td style="width: 150px">
                    Active :<br />
                    <asp:CheckBoxList ID="chkAdd_S_Active_Flag" runat="server"> 
                        <asp:ListItem Value="1" Text="Active"></asp:ListItem>
                        <asp:ListItem Value="0" Text="Inactive"></asp:ListItem>
                    </asp:CheckBoxList>
                   </td>
                <td style="width: 150px">
                    <asp:Button ID="btnInsert_Service_List" runat="server" Text="Add" OnClick="btnInsert_Service_List_Click" ValidationGroup="vg_Service_List_int"/>
                    <asp:Button ID="btnClear_Service_list" runat="server" Text="Clear" OnClick="btnClear_Service_list_Click"/>
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>
</div>
</asp:Content>
