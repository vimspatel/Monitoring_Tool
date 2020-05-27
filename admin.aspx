<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="admin.aspx.cs" Inherits="Monitoring_Tool.admin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <script type="text/javascript" src="assets/js/custom/jquery.blockUI.js"></script>
   <%-- <script type="text/javascript">
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
    </script>--%>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <%-- ---------------------------------------------------------------------------------------------------------------- --%>
        <div id="dvGrid">
        </div>
    <div class="col-lg-12">
        <ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">
            <li class="nav-item">
                <a class="nav-link active" id="pills-home-tab" data-toggle="pill" href="#pills-logins" role="tab">Logins</a>
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
            <div class="tab-pane fade show active" id="pills-logins" role="tabpanel">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <div class="row">
                            <div class="col-lg-8">
                                <div class="card">
                                    <div class="card-header">
                                        <strong class="card-title">Logins</strong>
                                    </div>
                                    <div class="card-body">
                                        <asp:GridView ID="gv_logins" runat="server" AutoGenerateColumns="false" OnRowDataBound="gv_logins_RowDataBound" CssClass="mytable table table-striped table-bordered"
                                            DataKeyNames="User_ID" OnRowEditing="gv_logins_RowEditing" OnRowCancelingEdit="gv_logins_RowCancelingEdit" PageSize="5" AllowPaging="true" OnPageIndexChanging="gv_logins_PageIndexChanging"
                                            OnRowUpdating="gv_logins_RowUpdating" OnRowDeleting="gv_logins_RowDeleting" EmptyDataText="No records has been added.">
                                            <Columns>
                                                <asp:TemplateField HeaderText="User ID">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblUser_ID" runat="server" Text='<%# Eval("User_ID") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <EditItemTemplate>
                                                        <asp:TextBox ID="txtUser_ID" runat="server" Text='<%# Eval("User_ID") %>'></asp:TextBox>
                                                        <asp:RequiredFieldValidator ID="rfv_User_Id" runat="server" ControlToValidate="txtUser_ID" ErrorMessage="Required*" ValidationGroup="vg_logins"></asp:RequiredFieldValidator>
                                                    </EditItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="UserName">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblUserName" runat="server" Text='<%# Eval("UserName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <EditItemTemplate>
                                                        <asp:TextBox ID="txtUserName" runat="server" Text='<%# Eval("UserName") %>'></asp:TextBox>
                                                        <asp:RequiredFieldValidator ID="rfv_UserName" runat="server" ControlToValidate="txtUserName" ErrorMessage="Required*" ValidationGroup="vg_logins"></asp:RequiredFieldValidator>
                                                    </EditItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Password">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblPassword" runat="server" Text='<%# Eval("Password") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <EditItemTemplate>
                                                        <asp:TextBox ID="txtPassword" runat="server" Text='<%# Eval("Password") %>'></asp:TextBox>
                                                        <%--<asp:RequiredFieldValidator ID="rfv_Password" runat="server" ControlToValidate="txtPassword" ErrorMessage="Required*" ValidationGroup="vg_logins"></asp:RequiredFieldValidator>--%>
                                                    </EditItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Role">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblRole" runat="server" Text='<%# Eval("Role_ID") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <EditItemTemplate>
                                                        <asp:DropDownList ID="ddl_Role_List" runat="server"></asp:DropDownList>
                                                        <asp:RequiredFieldValidator ID="rfv_Role_List" runat="server" ControlToValidate="ddl_Role_List" InitialValue="0" ErrorMessage="Required*" ValidationGroup="vg_logins"></asp:RequiredFieldValidator>
                                                    </EditItemTemplate>
                                                </asp:TemplateField>
                                                <asp:CommandField ButtonType="Link" EditText="<i class='fa fa-pencil-square-o'></i>" DeleteText="<i class='fa fa-trash-o'></i>" ShowEditButton="true" ShowDeleteButton="true" ValidationGroup="vg_logins" />
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4">
                                <div class="card">
                                    <div class="card-header">
                                        <strong class="card-title">Add User/Update</strong>
                                    </div>
                                    <div class="card-body">
                                        <!-- Credit Card -->
                                        <div>
                                            <div class="card-body">
                                                <div class="card-title">
                                                    <h3 class="text-center">Logins</h3>
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
                                                    <label class="control-label mb-1">User ID</label>
                                                    <asp:TextBox ID="txtAdd_User_ID" runat="server" CssClass="form-control" />
                                                    <%--<asp:RequiredFieldValidator ID="rfv_Add_User_ID" runat="server" ControlToValidate="txtAdd_User_ID" ErrorMessage="Required*" ValidationGroup="vg_login_int"></asp:RequiredFieldValidator>--%>
                                                </div>
                                                <div class="form-group has-success">
                                                    <label class="control-label mb-1">User Name</label>
                                                    <asp:TextBox ID="txtAdd_Username" runat="server" CssClass="form-control" />
                                                    <%--<asp:RequiredFieldValidator ID="rfv_Add_Username" runat="server" ControlToValidate="txtAdd_Username" ErrorMessage="Required*" ValidationGroup="vg_login_int"></asp:RequiredFieldValidator>--%>
                                                </div>
                                                <div class="form-group has-success">
                                                    <label class="control-label mb-1">Password</label>
                                                    <asp:TextBox ID="txtAdd_Password" runat="server" CssClass="form-control" />
                                                    <%--<asp:RequiredFieldValidator ID="rfv_Add_Password" runat="server" ControlToValidate="txtAdd_Password" ErrorMessage="Required*" ValidationGroup="vg_login_int"></asp:RequiredFieldValidator>--%>
                                                </div>
                                                <div class="form-group">
                                                    <label class="control-label mb-1">Select Role</label>
                                                    <asp:DropDownList ID="ddlAdd_Role_List" runat="server" CssClass="form-control"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="rfv_Add_Env_For" runat="server" ControlToValidate="ddlAdd_Role_List" InitialValue="" ErrorMessage="Required*" ValidationGroup="vg_Env_Detail_int"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-actions form-group">
                                                    <asp:Button ID="btnInsert_User" runat="server" Text="Add" CssClass="btn btn-primary" OnClick="btnInsert_User_Click" ValidationGroup="vg_login_int" />
                                                    <asp:Button ID="btnCancel_User" runat="server" Text="Clear" CssClass="btn btn-secondary" OnClick="btnCancel_User_Click" />
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

       
</asp:Content>
