<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="monitor_sp.aspx.cs" Inherits="Monitoring_Tool.monitor_sp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
            <div class="alerts">
                <div class="row">
                    <div class="col-md-6">
                        <div class="card-body">
                            <div class="alert alert-success" role="alert">
                                Last Run -
                                <asp:Label ID="lbl_lastrun" runat="server" Text="Label"></asp:Label>
                                <a href="stopped_sp.aspx" class="alert-link">Click to check Stopped Proces/Services</a>.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- .alerts -->
                <div class="col-lg-12">
                    <asp:Panel ID="pnlResult" runat="server"></asp:Panel>
                    <asp:Literal ID="ltService_Table" runat="server" />
                    <asp:Literal ID="ltProcess_Table" runat="server" />
                    <!-- .table from back end -->
                </div>
       
</asp:Content>
