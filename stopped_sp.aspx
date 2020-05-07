﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="stopped_sp.aspx.cs" Inherits="Monitoring_Tool.stopped_sp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
     <div class="content">
            <div class="animated fadeIn">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="card">
                            <div class="card-header">
                                <strong class="card-title">Stopped Services</strong>
                                <%--<small>Use <code>.badge</code> class within <code>&lt;span&gt;</code> elements to create badges:
                                    </small>--%>
                                <small>Last run <asp:Label ID="lbl_slastrun" runat="server" Text="Label"></asp:Label>
                                <a href="monitor_sp.aspx" class="alert-link">Click to check all Services</a>.    
                                </small>
                            </div>
                            
                            <div class="table-stats order-table ov-h">
                                <asp:GridView ID="gv_stopped_services" AutoGenerateColumns="false" runat="server" class="table" OnRowDataBound="gv_stopped_services_RowDataBound" BorderStyle="None" EmptyDataRowStyle-CssClass="alert-success"  >
                                    <columns>
                                      <asp:boundfield datafield="ENV_TITLE" headertext="Environment"/>
                                      <asp:boundfield datafield="Description" headertext="Description"/>
                                      <asp:boundfield datafield="Server_Name" headertext="Server Name"/>
                                      <asp:boundfield datafield="Service_Name" headertext="Service Name"/>
                                      <asp:boundfield datafield="Status" headertext="Status"/>
                                      <asp:boundfield datafield="Status_Date" headertext="Status Date"/>
                                    </columns>
                                </asp:GridView>
                            </div> <!-- /.table-stopped Services -->
                        </div>
                    </div>
                    <div class="col-lg-12">
                        <div class="card">
                            <div class="card-header">
                                <strong class="card-title">Stopped Process</strong>
                                <small> Last run <asp:Label ID="lbl_plastrun" runat="server" Text="Label"></asp:Label>
                                    <a href="monitor_sp.aspx" class="alert-link">Click to check all Process</a>. 
                                </small>
                            </div>
                            
                            <div class="table-stats order-table ov-h">
                                <asp:GridView ID="gv_stopped_process" AutoGenerateColumns="false" runat="server" class="table" OnRowDataBound="gv_stopped_process_RowDataBound" BorderStyle="None" EmptyDataRowStyle-CssClass="alert-success" >
                                    <columns>
                                      <asp:boundfield datafield="ENV_TITLE" headertext="Environment"/>
                                      <asp:boundfield datafield="Description" headertext="Description"/>
                                      <asp:boundfield datafield="Server_Name" headertext="Server Name"/>
                                      <asp:boundfield datafield="Process_Name" headertext="Process Name"/>
                                      <asp:boundfield datafield="Status" headertext="Status"/>
                                      <asp:boundfield datafield="Status_Date" headertext="Status Date"/>
                                    </columns>
                                </asp:GridView>
                            </div> <!-- /.table-stopped Services -->
                        </div>
                    </div>
        </div>
    </div><!-- .animated -->
</div>
</asp:Content>
