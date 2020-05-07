<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="db_growth.aspx.cs" Inherits="Monitoring_Tool.db_growth" %>

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
    <link href="assets/custom/glyphiconicon.css" rel="stylesheet" />
    <link href="assets/custom/bootstrap-datetimepicker.css" rel="stylesheet" />
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
            $('[id*=txtstartTime],[id*=txtendTime]').datetimepicker({
                format: 'LT'

            });
        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div class="card">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="card-header">
                    <strong>Horizontal</strong> Form
                </div>
                <div class="card-body card-block">
                    <div class="row form-group">
                        <div class="col col-md-2">
                            <asp:label id="lbl_server" runat="server" CssClass="form-control-label">Server</asp:label></div>
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
                            <asp:label ID="lbl_database" runat="server" CssClass="form-control-label">Database</asp:label></div>
                        <div class="col-6 col-md-3">
                            <asp:DropDownList ID="ddl_dbname" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddl_dbname_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                        <div class="col-6 col-md-5">
                            <div class="input-group">
                                <span class="input-group-addon"><span class="glyphicon glyphicon-time"></span></span>
                                <asp:TextBox ID="txtstartTime" CssClass="form-control classtxt_startTime" runat="server"></asp:TextBox>
                                <div class="input-group-addon">to</div>
                                <asp:TextBox ID="txtendTime" CssClass="form-control classtxtendTime" runat="server"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="row form-group">
                        <div class="col col-md-2">
                            <asp:label ID="lbl_filetype" runat="server" class="form-control-label">FileType</asp:label></div>
                        <div class="col-6 col-md-3">
                            <asp:DropDownList ID="ddl_filetype" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddl_filetype_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="card-footer">
                    <asp:Button ID="btn_dbgrowthchart" runat="server" Text="Get Report" class="btn btn-primary btn-sm" OnClick="btn_dbgrowthchart_Click" />
                    <asp:Button ID="btn_dbgrowthchart_reset" runat="server" Text="Cancel" class="btn btn-danger btn-sm" />
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>











    <!-- Content -->
    <div class="content">
        <div class="animated fadeIn">
            <div class="row">


                <asp:Literal ID="lt_DBGrowthChart" runat="server"></asp:Literal>


                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-body">
                            <h4 class="mb-3">Yearly Sales </h4>
                            <canvas id="sales-chart"></canvas>
                        </div>
                    </div>
                </div>
                <!-- /# column -->

                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-body">
                            <h4 class="mb-3">Team Commits </h4>
                            <canvas id="team-chart"></canvas>
                        </div>
                    </div>
                </div>
                <!-- /# column -->

                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-body">
                            <h4 class="mb-3">Bar chart </h4>
                            <canvas id="barChart"></canvas>
                        </div>
                    </div>
                </div>
                <!-- /# column -->

                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-body">
                            <h4 class="mb-3">Rader chart </h4>
                            <canvas id="radarChart"></canvas>
                        </div>
                    </div>
                </div>
                <!-- /# column -->

                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-body">
                            <h4 class="mb-3">Line Chart </h4>
                            <canvas id="lineChart"></canvas>
                        </div>
                    </div>

                    <div class="col-lg-12">
                        <div class="card">
                            <div class="card-body">
                                <h4 class="mb-3">Doughut Chart </h4>
                                <canvas id="doughutChart"></canvas>
                            </div>
                        </div>
                    </div>
                    <!-- /# column -->

                </div>
                <!-- /# column -->

                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-body">
                            <h4 class="mb-3">Pie Chart </h4>
                            <canvas id="pieChart"></canvas>
                        </div>
                    </div>
                </div>
                <!-- /# column -->


                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-body">
                            <h4 class="mb-3">Polar Chart </h4>
                            <canvas id="polarChart"></canvas>
                        </div>
                    </div>
                </div>
                <!-- /# column -->

                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-body">
                            <h4 class="mb-3">Single Bar Chart </h4>
                            <canvas id="singelBarChart"></canvas>
                        </div>
                    </div>
                </div>
                <!-- /# column -->



            </div>

        </div>
        <!-- .animated -->
    </div>
    <!-- /.content -->
    <div class="clearfix"></div>
    <!-- Scripts -->

    <asp:Literal ID="lt_script_DbGrowthChart" runat="server"></asp:Literal>

    <script src="https://cdn.jsdelivr.net/npm/jquery@2.2.4/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.4/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jquery-match-height@0.7.2/dist/jquery.matchHeight.min.js"></script>
    <script src="assets/js/main.js"></script>
    <!--  Chart js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@2.7.3/dist/Chart.bundle.min.js"></script>
    <script src="assets/js/init/chartjs-init.js"></script>
    <!--Flot Chart-->
    <script src="https://cdn.jsdelivr.net/npm/jquery.flot@0.8.3/jquery.flot.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flot-spline@0.0.1/js/jquery.flot.spline.min.js"></script>
</asp:Content>
