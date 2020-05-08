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
                $("#" + elementID).block({
                    message: '<div align = "center">' + '<img src="images/loadingAnim.gif"/></div>',
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

<div class="col-lg-12">
    <ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">
        <li class="nav-item">
            <a class="nav-link active" id="pills-home-tab" data-toggle="pill" href="#pills-env" role="tab">Environments</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="pills-service-tab" data-toggle="pill" href="#pills-service" role="tab">Services</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="pills-process-tab" data-toggle="pill" href="#pills-process" role="tab">Process</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="pills-server-tab" data-toggle="pill" href="#pills-server" role="tab">Servers</a>
        </li>
    </ul>
</div>
    <div class="col-lg-12">
    <div class="tab-content" id="pills-tabContent">
        <div class="tab-pane fade show active" id="pills-env" role="tabpanel">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <div class="row">
                        <div class="col-lg-8">
                            <div class="card">
                                <div class="card-header">
                                    <strong class="card-title">Environment</strong>
                                </div>
                                <div class="card-body">
                                    <asp:GridView ID="gv_env_detail" runat="server" AutoGenerateColumns="false" OnRowDataBound="gv_env_detail_RowDataBound" CssClass="mytable table table-striped table-bordered"
                                        DataKeyNames="Env_ID" OnRowEditing="gv_env_detail_RowEditing" OnRowCancelingEdit="gv_env_detail_RowCancelingEdit" PageSize="5" AllowPaging="true" OnPageIndexChanging="gv_env_detail_PageIndexChanging"
                                        OnRowUpdating="gv_env_detail_RowUpdating" OnRowDeleting="gv_env_detail_RowDeleting" EmptyDataText="No records has been added.">
                                        <Columns>
                                            <asp:TemplateField HeaderText="Env ID">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblEnv_ID" runat="server" Text='<%# Eval("Env_ID") %>'></asp:Label>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="txtEnv_ID" runat="server" Text='<%# Eval("Env_ID") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfv_Env_Id" runat="server" ControlToValidate="txtEnv_ID" ErrorMessage="Required*" ValidationGroup="vg_Env_Detail"></asp:RequiredFieldValidator>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Environment">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblEnv_Title" runat="server" Text='<%# Eval("Env_Title") %>'></asp:Label>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="txtEnv_Title" runat="server" Text='<%# Eval("Env_Title") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfv_Env_Title" runat="server" ControlToValidate="txtEnv_Title" ErrorMessage="Required*" ValidationGroup="vg_Env_Detail"></asp:RequiredFieldValidator>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Env Output">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblEnv_Output" runat="server" Text='<%# Eval("Env_Output") %>'></asp:Label>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="txtEnv_Output" runat="server" Text='<%# Eval("Env_Output") %>'></asp:TextBox>
                                                    <%--<asp:RequiredFieldValidator ID="rfv_Env_Output" runat="server" ControlToValidate="txtEnv_Output" ErrorMessage="Required*" ValidationGroup="vg_Env_Detail"></asp:RequiredFieldValidator>--%>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="For">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblEnv_For" runat="server" Text='<%# Eval("Env_For") %>'></asp:Label>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:DropDownList ID="ddl_Env_For" runat="server">
                                                        <asp:ListItem Value="" Text="- Select -"></asp:ListItem>
                                                        <asp:ListItem Value="Service" Text="Service"></asp:ListItem>
                                                        <asp:ListItem Value="Process" Text="Process"></asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="rfv_Env_For" runat="server" ControlToValidate="ddl_Env_For" InitialValue="" ErrorMessage="Required*" ValidationGroup="vg_Env_Detail"></asp:RequiredFieldValidator>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Email Recipient">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblEmail_Recipient" runat="server" Text='<%# Eval("Email_Recipient") %>'></asp:Label>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="txtEmail_Recipient" runat="server" Text='<%# Eval("Email_Recipient") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfv_Env_Recipient" runat="server" ControlToValidate="txtEmail_Recipient" ErrorMessage="Required*" ValidationGroup="vg_Env_Detail"></asp:RequiredFieldValidator>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:CommandField ButtonType="Link" EditText="<i class='fa fa-pencil-square-o'></i>" DeleteText="<i class='fa fa-trash-o'></i>" ShowEditButton="true" ShowDeleteButton="true" ValidationGroup="vg_Env_Detail" />
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="card">
                                <div class="card-header">
                                    <strong class="card-title">Add Environment</strong>
                                </div>
                                <div class="card-body">
                                    <!-- Credit Card -->
                                    <div>
                                        <div class="card-body">
                                            <div class="card-title">
                                                <h3 class="text-center">Pay Invoice</h3>
                                            </div>
                                            <hr>

                                            <div class="form-group text-center">
                                                <ul class="list-inline">
                                                    <li class="list-inline-item"><i class="text-muted fa fa-cc-visa fa-2x"></i></li>
                                                    <li class="list-inline-item"><i class="fa fa-cc-mastercard fa-2x"></i></li>
                                                    <li class="list-inline-item"><i class="fa fa-cc-amex fa-2x"></i></li>
                                                    <li class="list-inline-item"><i class="fa fa-cc-discover fa-2x"></i></li>
                                                </ul>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label mb-1">Environment Name</label>
                                                <asp:TextBox ID="txtAdd_Env_Title" runat="server" CssClass="form-control" />
                                                <asp:RequiredFieldValidator ID="rfv_Add_Env_Title" runat="server" ControlToValidate="txtAdd_Env_Title" ErrorMessage="Required*" ValidationGroup="vg_Env_Detail_int"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="form-group has-success">
                                                <label class="control-label mb-1">Environment Output</label>
                                                <asp:TextBox ID="txtAdd_Env_Output" runat="server" CssClass="form-control" />
                                                <%--<asp:RequiredFieldValidator ID="rfv_Add_Env_OUtput" runat="server" ControlToValidate="txtAdd_Env_Output" ErrorMessage="Required*" ValidationGroup="vg_Env_Detail_int"></asp:RequiredFieldValidator>--%>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label mb-1">Select Service/Process</label>
                                                <asp:DropDownList ID="ddlAdd_Env_For" runat="server" CssClass="form-control">
                                                    <asp:ListItem Value="" Text="- Select -"></asp:ListItem>
                                                    <asp:ListItem Value="Service" Text="Service"></asp:ListItem>
                                                    <asp:ListItem Value="Process" Text="Process"></asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="rfv_Add_Env_For" runat="server" ControlToValidate="ddlAdd_Env_For" InitialValue="" ErrorMessage="Required*" ValidationGroup="vg_Env_Detail_int"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="form-group has-success">
                                                <label class="control-label mb-1">Email Recipient</label>
                                                <asp:TextBox ID="txtAdd_email_recepient" runat="server" CssClass="form-control" />
                                                <asp:RequiredFieldValidator ID="rfv_Add_email_recepient" runat="server" ControlToValidate="txtAdd_email_recepient" ErrorMessage="Required*" ValidationGroup="vg_Env_Detail_int"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="form-actions form-group">
                                                <asp:Button ID="btnInsert_Env" runat="server" Text="Add" CssClass="btn btn-primary" OnClick="btnInsert_Env_Click" ValidationGroup="vg_Env_Detail_int" />
                                                <asp:Button ID="btnCancel_Env" runat="server" Text="Clear" CssClass="btn btn-secondary" OnClick="btnCancel_Env_Click" />
                                            </div>

                                        </div>
                                    </div>

                                </div>
                            </div>
                            <!-- .card -->
                        </div>
                        <!--/.col-->
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        <div class="tab-pane fade" id="pills-service" role="tabpanel">
            <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                <ContentTemplate>
                    <div class="row">
                        <div class="col-lg-8">
                            <div class="card">
                                <div class="card-header">
                                    <strong class="card-title">Sevices</strong>
                                </div>
                                <div class="card-body">
                                    <asp:GridView ID="gv_service" runat="server" AutoGenerateColumns="false" OnRowDataBound="gv_service_RowDataBound" CssClass="myservicetable table table-striped table-bordered"
                                        DataKeyNames="Service_ID" OnRowEditing="gv_service_RowEditing" OnRowCancelingEdit="gv_service_RowCancelingEdit" PageSize="5" AllowPaging="true" OnPageIndexChanging="gv_service_PageIndexChanging"
                                        OnRowUpdating="gv_service_RowUpdating" OnRowDeleting="gv_service_RowDeleting" EmptyDataText="No records has been added.">
                                        <Columns>
                                            <asp:TemplateField HeaderText="Service ID">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblService_ID" runat="server" Text='<%# Eval("Service_ID") %>'></asp:Label>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="etxtService_ID" runat="server" Text='<%# Eval("Service_ID") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfv_Service_ID" runat="server" ControlToValidate="etxtService_ID" ErrorMessage="Required*" ValidationGroup="vg_Service_List"></asp:RequiredFieldValidator>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Description">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblS_Description" runat="server" Text='<%# Eval("Description") %>'></asp:Label>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="etxtS_Description" runat="server" Text='<%# Eval("Description") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfv_S_Description" runat="server" ControlToValidate="etxtS_Description" ErrorMessage="Required*" ValidationGroup="vg_Service_List"></asp:RequiredFieldValidator>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Server Name">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblServer_Name" runat="server" Text='<%# Eval("Server_Name") %>'></asp:Label>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="etxtServer_Name" runat="server" Text='<%# Eval("Server_Name") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfv_Server_Name" runat="server" ControlToValidate="etxtServer_Name" ErrorMessage="Required*" ValidationGroup="vg_Service_List"></asp:RequiredFieldValidator>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Service Name">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblService_Name" runat="server" Text='<%# Eval("Service_Name") %>'></asp:Label>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="etxtService_Name" runat="server" Text='<%# Eval("Service_Name") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfv_Service_Name" runat="server" ControlToValidate="etxtService_Name" ErrorMessage="Required*" ValidationGroup="vg_Service_List"></asp:RequiredFieldValidator>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Search String">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblEnv_Search_String" runat="server" Text='<%# Eval("Env_Search_String") %>'></asp:Label>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="etxtEnv_Search_String" runat="server" Text='<%# Eval("Env_Search_String") %>'></asp:TextBox>
                                                    <%--<asp:RequiredFieldValidator ID="rfv_Env_Recipient" runat="server" ControlToValidate="etxtEnv_Search_String" ErrorMessage="Required*" ValidationGroup="vg_Service_List"></asp:RequiredFieldValidator>--%>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Notify">
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="lbl_chk_S_Notify_Flag" runat="server" Checked='<%#bool.Parse(Eval("Notify_Flag").ToString())%>'></asp:CheckBox>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:CheckBox ID="echk_S_Notify_Flag" runat="server" Checked='<%#bool.Parse(Eval("Notify_Flag").ToString())%>'></asp:CheckBox>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Environment">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblS_Env_ID" runat="server" Text='<%# Eval("Env_ID") %>'></asp:Label>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="etxtS_Env_ID" runat="server" Text='<%# Eval("Env_ID") %>'></asp:TextBox>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Active">
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="lbl_chk_S_Active_Flag" runat="server" Checked='<%#bool.Parse(Eval("Active_Flag").ToString())%>'></asp:CheckBox>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:CheckBox ID="echk_S_Active_Flag" runat="server" Checked='<%#bool.Parse(Eval("Active_Flag").ToString())%>'></asp:CheckBox>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:CommandField ButtonType="Link" EditText="<i class='fa fa-pencil-square-o'></i>" DeleteText="<i class='fa fa-trash-o'></i>" ShowEditButton="true" ShowDeleteButton="true" ValidationGroup="vg_Service_List" />
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="card">
                                <div class="card-header">
                                    <strong class="card-title">Add Services</strong>
                                </div>
                                <div class="card-body">
                                    <!-- Credit Card -->
                                    <div>
                                        <div class="card-body">
                                            <div class="card-title">
                                                <h3 class="text-center">Pay Invoice</h3>
                                            </div>
                                            <hr>

                                            <div class="form-group text-center">
                                                <ul class="list-inline">
                                                    <li class="list-inline-item"><i class="text-muted fa fa-cc-visa fa-2x"></i></li>
                                                    <li class="list-inline-item"><i class="fa fa-cc-mastercard fa-2x"></i></li>
                                                    <li class="list-inline-item"><i class="fa fa-cc-amex fa-2x"></i></li>
                                                    <li class="list-inline-item"><i class="fa fa-cc-discover fa-2x"></i></li>
                                                </ul>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label mb-1">Desc</label>
                                                <asp:TextBox ID="txtAdd_S_Description" runat="server" CssClass="form-control" />
                                                <asp:RequiredFieldValidator ID="rfv_S_Description" runat="server" ControlToValidate="txtAdd_S_Description" ErrorMessage="Required*" ValidationGroup="vg_Service_List_int"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="form-group has-success">
                                                <label class="control-label mb-1">Server Name</label>
                                                <asp:TextBox ID="txtAdd_Server_Name" runat="server" CssClass="form-control" />
                                                <asp:RequiredFieldValidator ID="rfv_Add_Server_name" runat="server" ControlToValidate="txtAdd_Server_Name" ErrorMessage="Required*" ValidationGroup="vg_Service_List_int"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="form-group has-success">
                                                <label class="control-label mb-1">Service Name</label>
                                                <asp:TextBox ID="txtAdd_Service_Name" runat="server" CssClass="form-control" />
                                                <asp:RequiredFieldValidator ID="rfv_Add_Service_Name" runat="server" ControlToValidate="txtAdd_Service_Name" ErrorMessage="Required*" ValidationGroup="vg_Service_List_int"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="form-group has-success">
                                                <label class="control-label mb-1">Search String</label>
                                                <asp:TextBox ID="txtAdd_Env_Search_String" runat="server" CssClass="form-control" />
                                                <%--<asp:RequiredFieldValidator ID="rfv_Add_Env_Search_String" runat="server" ControlToValidate="txtAdd_Env_Search_String" ErrorMessage="Required*" ValidationGroup="vg_Service_List_int"></asp:RequiredFieldValidator>--%>
                                            </div>
                                            <div class="row form-group">
                                                <div class="col col-md-4">
                                                    <label class=" form-control-label">Get Notify:</label>
                                                </div>
                                                <div class="col col-md-4">
                                                    <asp:CheckBoxList ID="chkAdd_S_Notify_FLag" runat="server" CssClass="form-check-inline form-check">
                                                        <asp:ListItem Value="1" Text="Yes"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="No"></asp:ListItem>
                                                    </asp:CheckBoxList>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label mb-1">Environment</label>
                                                <asp:DropDownList ID="ddl_Env_List_S" runat="server" CssClass="form-control"></asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="rfv_Add_S_Env_ID" runat="server" ControlToValidate="ddl_Env_List_S" InitialValue="0" ErrorMessage="Required*" ValidationGroup="vg_Service_List_int"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="row form-group">
                                                <div class="col col-md-4">
                                                    <label class=" form-control-label">Monitoring :</label>
                                                </div>
                                                <div class="col col-md-4">
                                                    <asp:CheckBoxList ID="chkAdd_S_Active_Flag" runat="server" CssClass="form-check-inline form-check">
                                                        <asp:ListItem Value="1" Text="Active"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Inactive"></asp:ListItem>
                                                    </asp:CheckBoxList>
                                                </div>
                                            </div>
                                            <div class="form-actions form-group">
                                                <asp:Button ID="btnInsert_Service_List" runat="server" Text="Add" CssClass="btn btn-primary" OnClick="btnInsert_Service_List_Click" ValidationGroup="vg_Service_List_int" />
                                                <asp:Button ID="btnClear_Service_list" runat="server" Text="Clear" CssClass="btn btn-secondary" OnClick="btnClear_Service_list_Click" />
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>
                            <!-- .card -->
                        </div>
                        <!--/.col-->
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        <div class="tab-pane fade" id="pills-process" role="tabpanel">
            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                <ContentTemplate>
                    <div class="row">
                        <div class="col-lg-8">
                            <div class="card">
                                <div class="card-header">
                                    <strong class="card-title">Process</strong>
                                </div>
                                <div class="card-body">
                                    <asp:GridView ID="gv_process" runat="server" AutoGenerateColumns="false" OnRowDataBound="gv_process_RowDataBound" CssClass="myprocesstable table table-striped table-bordered"
                                        DataKeyNames="Process_ID" OnRowEditing="gv_process_RowEditing" OnRowCancelingEdit="gv_process_RowCancelingEdit" PageSize="5" AllowPaging="true" OnPageIndexChanging="gv_process_PageIndexChanging"
                                        OnRowUpdating="gv_process_RowUpdating" OnRowDeleting="gv_process_RowDeleting" EmptyDataText="No records has been added.">
                                        <Columns>
                                            <asp:TemplateField HeaderText="Process ID">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblProcess_ID" runat="server" Text='<%# Eval("Process_ID") %>'></asp:Label>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="etxtProcess_ID" runat="server" Text='<%# Eval("Process_ID") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfv_Process_ID" runat="server" ControlToValidate="etxtProcess_ID" ErrorMessage="Required*" ValidationGroup="vg_Process_List"></asp:RequiredFieldValidator>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Description">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblP_Description" runat="server" Text='<%# Eval("Description") %>'></asp:Label>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="etxtP_Description" runat="server" Text='<%# Eval("Description") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfv_P_Description" runat="server" ControlToValidate="etxtP_Description" ErrorMessage="Required*" ValidationGroup="vg_Process_List"></asp:RequiredFieldValidator>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Server Name">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblPServer_Name" runat="server" Text='<%# Eval("Server_Name") %>'></asp:Label>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="etxtPServer_Name" runat="server" Text='<%# Eval("Server_Name") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfv_Server_Name" runat="server" ControlToValidate="etxtPServer_Name" ErrorMessage="Required*" ValidationGroup="vg_Process_List"></asp:RequiredFieldValidator>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Process Name">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblProcess_Name" runat="server" Text='<%# Eval("Process_Name") %>'></asp:Label>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="etxtProcess_Name" runat="server" Text='<%# Eval("Process_Name") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfv_Process_Name" runat="server" ControlToValidate="etxtProcess_Name" ErrorMessage="Required*" ValidationGroup="vg_Process_List"></asp:RequiredFieldValidator>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Search String">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblPEnv_Search_String" runat="server" Text='<%# Eval("Env_Search_String") %>'></asp:Label>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="etxtPEnv_Search_String" runat="server" Text='<%# Eval("Env_Search_String") %>'></asp:TextBox>
                                                    <%--<asp:RequiredFieldValidator ID="rfv_Env_Recipient" runat="server" ControlToValidate="etxtPEnv_Search_String" ErrorMessage="Required*" ValidationGroup="vg_Process_List"></asp:RequiredFieldValidator>--%>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Notify">
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="lbl_chk_P_Notify_Flag" runat="server" Checked='<%#bool.Parse(Eval("Notify_Flag").ToString())%>'></asp:CheckBox>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:CheckBox ID="echk_P_Notify_Flag" runat="server" Checked='<%#bool.Parse(Eval("Notify_Flag").ToString())%>'></asp:CheckBox>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Environment">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblP_Env_ID" runat="server" Text='<%# Eval("Env_ID") %>'></asp:Label>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="etxtP_Env_ID" runat="server" Text='<%# Eval("Env_ID") %>'></asp:TextBox>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Active">
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="lbl_chk_P_Active_Flag" runat="server" Checked='<%#bool.Parse(Eval("Active_Flag").ToString())%>'></asp:CheckBox>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:CheckBox ID="echk_P_Active_Flag" runat="server" Checked='<%#bool.Parse(Eval("Active_Flag").ToString())%>'></asp:CheckBox>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:CommandField ButtonType="Link" EditText="<i class='fa fa-pencil-square-o'></i>" DeleteText="<i class='fa fa-trash-o'></i>" ShowEditButton="true" ShowDeleteButton="true" ValidationGroup="vg_Process_List" />
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="card">
                                <div class="card-header">
                                    <strong class="card-title">Add Process</strong>
                                </div>
                                <div class="card-body">
                                    <!-- Credit Card -->
                                    <div>
                                        <div class="card-body">
                                            <div class="card-title">
                                                <h3 class="text-center">Pay Invoice</h3>
                                            </div>
                                            <hr>

                                            <div class="form-group text-center">
                                                <ul class="list-inline">
                                                    <li class="list-inline-item"><i class="text-muted fa fa-cc-visa fa-2x"></i></li>
                                                    <li class="list-inline-item"><i class="fa fa-cc-mastercard fa-2x"></i></li>
                                                    <li class="list-inline-item"><i class="fa fa-cc-amex fa-2x"></i></li>
                                                    <li class="list-inline-item"><i class="fa fa-cc-discover fa-2x"></i></li>
                                                </ul>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label mb-1">Desc</label>
                                                <asp:TextBox ID="txtAdd_P_Description" runat="server" CssClass="form-control" />
                                                <asp:RequiredFieldValidator ID="rfv_P_Description" runat="server" ControlToValidate="txtAdd_P_Description" ErrorMessage="Required*" ValidationGroup="vg_Process_List_int"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="form-group has-success">
                                                <label class="control-label mb-1">Server Name</label>
                                                <asp:TextBox ID="txtAdd_PServer_Name" runat="server" CssClass="form-control" />
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtAdd_PServer_Name" ErrorMessage="Required*" ValidationGroup="vg_Process_List_int"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="form-group has-success">
                                                <label class="control-label mb-1">Process Name</label>
                                                <asp:TextBox ID="txtAdd_Process_Name" runat="server" CssClass="form-control" />
                                                <asp:RequiredFieldValidator ID="rfv_Add_Process_Name" runat="server" ControlToValidate="txtAdd_Process_Name" ErrorMessage="Required*" ValidationGroup="vg_Process_List_int"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="form-group has-success">
                                                <label class="control-label mb-1">Search String</label>
                                                <asp:TextBox ID="txtAdd_PEnv_Search_String" runat="server" CssClass="form-control" />
                                                <%--<asp:RequiredFieldValidator ID="rfv_Add_PEnv_Search_String" runat="server" ControlToValidate="txtAdd_PEnv_Search_String" ErrorMessage="Required*" ValidationGroup="vg_Process_List_int"></asp:RequiredFieldValidator>--%>
                                            </div>
                                            <div class="row form-group">
                                                <div class="col col-md-4">
                                                    <label class=" form-control-label">Get Notify:</label>
                                                </div>
                                                <div class="col col-md-4">
                                                    <asp:CheckBoxList ID="chkAdd_P_Notify_FLag" runat="server" CssClass="form-check-inline form-check">
                                                        <asp:ListItem Value="1" Text="Yes"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="No"></asp:ListItem>
                                                    </asp:CheckBoxList>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label mb-1">Select Service/Process</label>
                                                <asp:DropDownList ID="ddl_Env_List_P" runat="server" CssClass="form-control"></asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="rfv_Add_P_Env_ID" runat="server" ControlToValidate="ddl_Env_List_P" InitialValue="0" ErrorMessage="Required*" ValidationGroup="vg_Process_List_int"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="row form-group">
                                                <div class="col col-md-4">
                                                    <label class=" form-control-label">Monitoring :</label>
                                                </div>
                                                <div class="col col-md-4">
                                                    <asp:CheckBoxList ID="chkAdd_P_Active_Flag" runat="server" CssClass="form-check-inline form-check">
                                                        <asp:ListItem Value="1" Text="Active"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Inactive"></asp:ListItem>
                                                    </asp:CheckBoxList>
                                                </div>
                                            </div>
                                            <div class="form-actions form-group">
                                                <asp:Button ID="btnInsert_Process_List" runat="server" Text="Add" CssClass="btn btn-primary" OnClick="btnInsert_Process_List_Click" ValidationGroup="vg_Process_List_int" />
                                                <asp:Button ID="btnClear_Process_list" runat="server" Text="Clear" CssClass="btn btn-secondary" OnClick="btnClear_Process_list_Click" />
                                            </div>

                                        </div>
                                    </div>

                                </div>
                            </div>
                            <!-- .card -->
                        </div>
                        <!--/.col-->
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        <div class="tab-pane fade" id="pills-server" role="tabpanel">
            <asp:UpdatePanel ID="UpdatePanel4" runat="server">
                <ContentTemplate>
                    <div class="row">
                        <div class="col-lg-8">
                            <div class="card">
                                <div class="card-header">
                                    <strong class="card-title">Process</strong>
                                </div>
                                <div class="card-body">
                                    <asp:GridView ID="gv_server_detail" runat="server" AutoGenerateColumns="false" OnRowDataBound="gv_server_detail_RowDataBound" CssClass="myservertable table table-striped table-bordered"
                                        DataKeyNames="ServerID" OnRowEditing="gv_server_detail_RowEditing" OnRowCancelingEdit="gv_server_detail_RowCancelingEdit" PageSize="5" AllowPaging="true" OnPageIndexChanging="gv_server_detail_PageIndexChanging"
                                        OnRowUpdating="gv_server_detail_RowUpdating" OnRowDeleting="gv_server_detail_RowDeleting" EmptyDataText="No Server has been added.">
                                        <Columns>
                                            <asp:TemplateField HeaderText="Server ID">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblServer_ID" runat="server" Text='<%# Eval("ServerID") %>'></asp:Label>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="etxtServer_ID" runat="server" Text='<%# Eval("ServerID") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfv_Server_ID" runat="server" ControlToValidate="etxtServer_ID" ErrorMessage="Required*" ValidationGroup="vg_server_List"></asp:RequiredFieldValidator>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Server Name">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblServer_Name" runat="server" Text='<%# Eval("DB_Server_Name") %>'></asp:Label>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="etxtServer_Name" runat="server" Text='<%# Eval("DB_Server_Name") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfv_Server_Name" runat="server" ControlToValidate="etxtServer_Name" ErrorMessage="Required*" ValidationGroup="vg_server_List"></asp:RequiredFieldValidator>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Description">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblSer_Description" runat="server" Text='<%# Eval("Descr") %>'></asp:Label>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="etxtSer_Description" runat="server" Text='<%# Eval("Descr") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfvSer_Description" runat="server" ControlToValidate="etxtSer_Description" ErrorMessage="Required*" ValidationGroup="vg_server_List"></asp:RequiredFieldValidator>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Active">
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="lbl_chk_Ser_Active_Flag" runat="server" Checked='<%#bool.Parse(Eval("Active_Flag").ToString())%>'></asp:CheckBox>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:CheckBox ID="echk_Ser_Active_Flag" runat="server" Checked='<%#bool.Parse(Eval("Active_Flag").ToString())%>'></asp:CheckBox>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:CommandField ButtonType="Link" EditText="<i class='fa fa-pencil-square-o'></i>" DeleteText="<i class='fa fa-trash-o'></i>" ShowEditButton="true" ShowDeleteButton="true" ValidationGroup="vg_server_List" />
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="card">
                                <div class="card-header">
                                    <strong class="card-title">Add Server</strong>
                                </div>
                                <div class="card-body">
                                    <!-- Credit Card -->
                                    <div>
                                        <div class="card-body">
                                            <div class="card-title">
                                                <h3 class="text-center">Pay Invoice</h3>
                                            </div>
                                            <hr>

                                            <div class="form-group text-center">
                                                <ul class="list-inline">
                                                    <li class="list-inline-item"><i class="text-muted fa fa-cc-visa fa-2x"></i></li>
                                                    <li class="list-inline-item"><i class="fa fa-cc-mastercard fa-2x"></i></li>
                                                    <li class="list-inline-item"><i class="fa fa-cc-amex fa-2x"></i></li>
                                                    <li class="list-inline-item"><i class="fa fa-cc-discover fa-2x"></i></li>
                                                </ul>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label mb-1">Server Name</label>
                                                <asp:TextBox ID="txtAdd_ServerName" runat="server" CssClass="form-control" />
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtAdd_ServerName" ErrorMessage="Required*" ValidationGroup="vg_Server_List_int"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="form-group has-success">
                                                <label class="control-label mb-1">Description</label>
                                                <asp:TextBox ID="txtAdd_Server_Descr" runat="server" CssClass="form-control" />
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtAdd_Server_Descr" ErrorMessage="Required*" ValidationGroup="vg_Server_List_int"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="row form-group">
                                                <div class="col col-md-4">
                                                    <label class=" form-control-label">Monitoring :</label>
                                                </div>
                                                <div class="col col-md-4">
                                                    <asp:CheckBoxList ID="chkAdd_Server_Active_Flag" runat="server" CssClass="form-check-inline form-check">
                                                        <asp:ListItem Value="1" Text="Active"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Inactive"></asp:ListItem>
                                                    </asp:CheckBoxList>
                                                    <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="chkAdd_Server_Active_Flag" ErrorMessage="Required*" ValidationGroup="vg_Server_List_int"></asp:RequiredFieldValidator>--%>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-actions form-group">
                                            <asp:Button ID="btnInsert_Server" runat="server" Text="Add" CssClass="btn btn-primary" OnClick="btnInsert_Server_Click" ValidationGroup="vg_Server_List_int" />
                                            <asp:Button ID="btnCancel_Server" runat="server" Text="Clear" CssClass="btn btn-secondary" OnClick="btnCancel_Server_Click" />
                                        </div>

                                    </div>
                                </div>

                            </div>
                        </div>
                        <!-- .card -->
                    </div>
                    <!--/.col-->
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
</div>
    <link rel="stylesheet" href="assets/css/lib/datatable/dataTables.bootstrap.min.css">
    <script src="assets/js/lib/data-table/datatables.min.js"></script>
    <script src="assets/js/lib/data-table/dataTables.bootstrap.min.js"></script>
    <script src="assets/js/lib/data-table/dataTables.buttons.min.js"></script>
    <script src="assets/js/lib/data-table/buttons.bootstrap.min.js"></script>
    <script src="assets/js/lib/data-table/jszip.min.js"></script>
    <script src="assets/js/lib/data-table/vfs_fonts.js"></script>
    <script src="assets/js/lib/data-table/buttons.html5.min.js"></script>
    <script src="assets/js/lib/data-table/buttons.print.min.js"></script>
    <script src="assets/js/lib/data-table/buttons.colVis.min.js"></script>
    <script src="assets/js/init/datatables-init.js"></script>

    <!-- mytable class to enable sorting and filtering -->
    <script type="text/javascript">
        $(document).ready(function () {
            $('.myservicetable').DataTable();
            $('.myprocesstable').DataTable();
            $('.mytable').DataTable();
        });
    </script>

    <%-- ---------------------------------------------------------------------------------------------------------------- --%>
    <div id="dvGrid">
    </div>
</asp:Content>
