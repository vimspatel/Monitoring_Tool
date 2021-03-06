﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="db_growth.aspx.cs" Inherits="Monitoring_Tool.db_growth" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Bootstrap -->
    <script type="text/javascript" src='https://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.3.min.js'></script>
    <%--<script type="text/javascript" src='https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.0.3/js/bootstrap.min.js'></script>
    <link rel="stylesheet" href='https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.0.3/css/bootstrap.min.css' media="screen" />--%>

    <!-- Bootstrap -->
    <!-- Bootstrap DatePicker -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.4/css/bootstrap-datepicker.css" type="text/css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.4/js/bootstrap-datepicker.js" type="text/javascript"></script>
    <!-- Bootstrap DatePicker -->
    <link href="../assets/custom/glyphiconicon.css" rel="stylesheet" />
    <link href="../assets/custom/bootstrap-datetimepicker.css" rel="stylesheet" />
    <%--<link rel="stylesheet" href="https://cdn.rawgit.com/Eonasdan/bootstrap-datetimepicker/master/build/css/bootstrap-datetimepicker.css">--%>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.9.0/moment-with-locales.js"></script>
    <script type="text/javascript" src="https://cdn.rawgit.com/Eonasdan/bootstrap-datetimepicker/master/src/js/bootstrap-datetimepicker.js"></script>
    <!-- Bootstrap DatePicker -->
    <script type="text/javascript">
        $(function () {
            var tmp_st_dt = '1999-01-01';
            $('.classtxt_startdate').change(function () {
                tmp_st_dt = $('.classtxt_startdate').val();

                if (tmp_st_dt != '') {
                    $('.classtxt_enddate').datepicker('destroy');
                    $('.classtxt_enddate').val('');
                    $('.classtxt_enddate').datepicker({
                        format: "mm/dd/yyyy",
                        startDate: "'" + tmp_st_dt + "'",
                        endDate: "today"
                    });
                }
            });
            $('.classtxt_startdate,.classtxt_enddate').datepicker({
                changeMonth: true,
                changeYear: true,
                format: "mm/dd/yyyy",
                language: "tr",
                todayBtn: true,
                endDate: "+0d"
            });
            $('[id*=txt_startTime],[id*=txt_endTime]').datetimepicker({
                format: 'LT'

            });
        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="col-lg-12">
        <div class="card">
            <div class="card-header">
                <strong>Database Growth</strong> Chart
            </div>
            <div class="card-body card-block">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <div class="row form-group">
                            <div class="col col-md-2">
                                <asp:Label ID="lbl_server" runat="server" CssClass="form-control-label">Server</asp:Label>
                            </div>
                            <div class="col-6 col-md-3">
                                <asp:DropDownList ID="ddl_servername" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddl_serverName_SelectedIndexChanged"></asp:DropDownList>
                                <%--<input type="email" id="hf-email" name="hf-email" placeholder="Enter Email..." class="form-control"><span class="help-block">Please enter your email</span>--%>
                            </div>
                            <div class="col-6 col-md-5">
                                <div class="input-group">
                                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                                    <asp:TextBox ID="txt_startdate" CssClass="form-control classtxt_startdate" runat="server"></asp:TextBox>
                                    <div class="input-group-addon">to</div>
                                    <asp:TextBox ID="txt_enddate" CssClass="form-control classtxt_enddate" runat="server"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col col-md-2">
                                <asp:Label ID="lbl_database" runat="server" CssClass="form-control-label">Database</asp:Label>
                            </div>
                            <div class="col-6 col-md-3">
                                <asp:DropDownList ID="ddl_dbname" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddl_dbname_SelectedIndexChanged"></asp:DropDownList>
                            </div>
                            <div class="col-6 col-md-5">
                                <div class="input-group">
                                    <span class="input-group-addon"><span class="glyphicon glyphicon-time"></span></span>
                                    <asp:TextBox ID="txt_startTime" CssClass="form-control classtxt_startTime" runat="server"></asp:TextBox>
                                    <div class="input-group-addon">to</div>
                                    <asp:TextBox ID="txt_endTime" CssClass="form-control classtxt_endTime" runat="server"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col col-md-2">
                                <asp:Label ID="lbl_filetype" runat="server" class="form-control-label">FileType</asp:Label>
                            </div>
                            <div class="col-6 col-md-3">
                                <asp:DropDownList ID="ddl_filetype" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddl_filetype_SelectedIndexChanged"></asp:DropDownList>
                            </div>
                        </div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
                <div class="card-footer">
                    <asp:Button ID="btn_dbgrowthchart" runat="server" Text="Get Report" class="btn btn-primary btn-sm" OnClick="btn_dbgrowthchart_Click" />
                    <asp:Button ID="btn_dbgrowthchart_reset" runat="server" Text="Cancel" class="btn btn-danger btn-sm" OnClick="btn_dbgrowthchart_reset_Click" />
                </div>
            </div>
        </div>
        <!-- Content -->
        <div class="content">
            <div class="animated fadeIn">
                <div class="row">
                    <asp:Literal ID="lt_DBGrowthChart" runat="server"></asp:Literal>
                </div>
            </div>
            <!-- .animated -->
        </div>
        <!-- /.content -->
        <div class="clearfix"></div>
        <!-- Scripts -->

        <asp:Literal ID="lt_script_DbGrowthChart" runat="server"></asp:Literal>
</asp:Content>
