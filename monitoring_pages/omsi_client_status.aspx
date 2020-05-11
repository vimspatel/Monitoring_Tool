<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="omsi_client_status.aspx.cs" Inherits="Monitoring_Tool.monitoring_pages.omsi_client_status" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="alerts">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="card">
                                   <%-- <div class="card-header">
                                        <strong class="card-title">Contents</strong>
                                    </div>--%>
                                    <div class="card-body">
                                        <asp:PlaceHolder ID="PlaceHolder_htmlstring" runat="server"></asp:PlaceHolder>
                                        <%--<div class="alert alert-success" role="alert">
                                            <h3 class="alert-heading">OMSI Client Parameters: "TOTPSAPPDEV01"</h3>
                                            <div class="mt-4">
                                                <p>POST_URL=https://test2-atl.carrierpoint.com/CPHttpsInterface</p>
                                                <p>JDBC_URL=jdbc:sqlserver://TOTPSDBTST01:1433;DatabaseName=FNQC;SelectMethod=Cursor</p>
                                                <hr>
                                                <p class="mb-0">CP Client is running.</p>
                                            </div>
                                        </div>

                                        <div class="alert alert-danger" role="alert">
                                           <h3 class="alert-heading">OMSI Client Parameters: "TOTPSAPPDEV01"</h3>
                                            <div class="mt-4">
                                            <p>POST_URL=https://test2-atl.carrierpoint.com/CPHttpsInterface</p>
                                            <p>JDBC_URL=jdbc:sqlserver://TOTPSDBTST01:1433;DatabaseName=FNQC;SelectMethod=Cursor</p>
                                            <hr>
                                            <p class="mb-0">CP Client is Down.</p>
                                            <p class="mb-0">Last modified date of log file: 10/25/2018 8:11:34 PM.</p>
                                                </div>
                                        </div>

                                        <div class="alert alert-danger" role="alert">
                                            <div class="mt-4">
                                            <h3 class="alert-heading">OMSI Client Parameters: "TOTPSAPPDEV01"</h3>
                                            <p>POST_URL=https://test2-atl.carrierpoint.com/CPHttpsInterface</p>
                                            <p>JDBC_URL=jdbc:sqlserver://TOTPSDBTST01:1433;DatabaseName=FNQC;SelectMethod=Cursor</p>
                                            <hr>
                                            <p class="mb-0">CP Client is Down.</p>
                                            <p class="mb-0">Last modified date of log file: 10/25/2018 8:11:34 PM.</p>
                                                </div>
                                        </div>--%>
                                    </div>
                                </div>



                            </div>
                        </div>
                    </div>
                    <!-- .alerts -->
</asp:Content>
