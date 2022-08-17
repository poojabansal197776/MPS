<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="Shift_Simple.aspx.vb" Inherits="Shift_Simple" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <link type="text/css" href="Styles/css/ui-lightness/jquery-ui-1.8.19.custom.css" rel="stylesheet" />
    <script type="text/javascript" src="Scripts/js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="Scripts/js/jquery-ui-1.8.19.custom.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="divshift">
        <table style="width: 100%">
            <tr>
                <td style="width: 20%">
                    <span class="fontshift_head"><%=ReadWriteXml.getAppResource("1028")%></span>
                    <span style="margin-left: 5px">
                        <label id="lblLine_C" runat="server"><% Response.Write(Line_C + "-" + Line_Nm)%></label></span>
                </td>
                <td style="width: 20%">
                    <span class="fontshift_head"><%=ReadWriteXml.getAppResource("1029")%></span>
                    <span style="margin-left: 5px">
                        <label id="lblLeader" runat="server"><% Response.Write(Leader)%></label></span>
                </td>
                <td style="width: 20%">
                    <span class="fontshift_head"><%=ReadWriteXml.getAppResource("1026")%></span>
                    <span style="margin-left: 5px; font-size: 8pt !important">
                        <asp:TextBox ID="txtWork_Date" Style="width: 120px" class="PickedDate" onchange="updateShift()" runat="server" />
                    </span>
                </td>
                <td style="width: 20%">
                    <span class="fontshift_head"><%=ReadWriteXml.getAppResource("1030")%></span>
                    <span style="margin-left: 5px">
                        <select id="shift" visible="true" onchange="setShift(this,this.value)" class="shift" style="width: 120px" runat="server"></select>
                    </span>
                    <asp:HiddenField ID="hdshift_C" runat="server" />
                </td>
                <td style="width: 20%">
                    <span style="margin-left: 5px">
                        <asp:Button ID="bt_Search" class="bt_Search" runat="server" Style="font-weight: bold; width: 80px; color: blue" />
                    </span>
                </td>
            </tr>
        </table>
    </div>
    <div class="clear" />
    <div class="main_1">
        <%--Chart Start----%>
        <div class="boxBorder" style="background-color: #313131; margin: 10px">
            <div class="fontshift_1" style="margin: 05px">
                <span style="vertical-align: top"><%=ReadWriteXml.getAppResource("1071")%></span>

                <span style="margin-left: 5px;">
                    <a onclick="javascript:WriteCookie('G')" class="selection Link_Hover" style="padding-right: 3px; color: white"><%=ReadWriteXml.getAppResource("1192").ToString() %></a>
                    /
                    <a onclick="javascript:WriteCookie('Q')" class="selection Link_Hover" style="padding-left: 3px; color: white"><%=ReadWriteXml.getAppResource("1070").ToString() %></a>

                    <button style="margin: 0; margin-left: 5px" type="button" id="btnColSwt" class="colorSwitch" onclick="colorToggle('click'); return false"><%=ReadWriteXml.getAppResource("1253")%></button>
                </span>

                <table style="float: right">
                    <tr>
                        <td style="width: 50%;">
                            <label runat="server" id="lblPlan_Qty" style="color: white; z-index: 1;">Plan Qty. <span><%Response.Write(PlanQty.ToString)%></span> </label>
                        </td>
                        <td style="width: 50%; float: right">
                            <% If (CInt(_actualCount) < CInt(getSimpleProductionPLanQty(Factory_C, Section_C, Line_C, Shift_C, Work_Date))) Then%>
                            <img style="float: right; position: absolute; z-index: 1; margin-top: 30px" src="image/NG.png" width="40px" height="40px" />
                            <% Else%>
                            <img style="float: right; position: absolute; z-index: 1; margin-top: 30px" src="image/OK.png" width="40px" height="40px" />
                            <%End If%>       
                        </td>
                    </tr>
                </table>

            </div>

            <div id="dvChart" style="display: block; width: 100%;">
                <span>
                    <asp:Chart ID="Chart1" runat="server" Height="400px" Width="1200px" BackColor="#313131">
                        <Series></Series>
                        <ChartAreas>
                            <asp:ChartArea Name="ChartArea1" BackColor="#313131"></asp:ChartArea>
                        </ChartAreas>
                        <Legends>
                            <asp:Legend Name="Standard" BackColor="#313131" ForeColor="white"></asp:Legend>
                        </Legends>
                    </asp:Chart>
                </span>
            </div>

            <div id="dvQty" style="display: none;">
                <%--height: 283px; width: 700px;"--%>
                <table cellpadding="6" cellspacing="0" border="0" class="qtytable" style="margin-top: 30px">
                    <tr>
                        <td style="width: 50%; font-size: 50px; color: white"><%=ReadWriteXml.getAppResource("1189").ToString()%></td>
                        <td style="text-align: right; font-size: 50px; color: white"><% Response.Write(Math.Round(_BaseonTargetofline).ToString)%></td>
                    </tr>
                    <tr>
                        <td style="width: 50%; font-size: 50px; color: white"><%=ReadWriteXml.getAppResource("1190").ToString()%></td>
                        <td style="text-align: right; font-size: 50px; color: white"><% Response.Write(_actualCount.ToString)%></td>
                    </tr>
                    <tr>
                        <td style="width: 50%; font-size: 50px; color: white"><%=ReadWriteXml.getAppResource("1191").ToString() %></td>
                        <td style="text-align: right; font-size: 50px; color: white"><% Response.Write(_defectCount.ToString)%></td>
                    </tr>
                </table>
            </div>
        </div>
        <%--Chart End----%>

        <div style="margin: 10px; display: flex;">
            <div style="float: left; width: 35%">
                <div style="float: left; width: 49%">
                    <table class="shifttable">
                        <tr>
                            <th style="width: 60%; text-align: left"><%=ReadWriteXml.getAppResource("1043")%></th>
                            <th><%=ReadWriteXml.getAppResource("1044")%></th>
                        </tr>
                        <tr>
                            <td>
                                <%=ReadWriteXml.getAppResource("1043")%>
                            </td>
                            <td align="center"><% Response.Write(Int(TotalWokringHours).ToString + ":" + Right("0" + Math.Round(60 * (TotalWokringHours - Int(TotalWokringHours)), 0).ToString(), 2))%></td>
                        </tr>
                        <tr>
                            <td>
                                <%=ReadWriteXml.getAppResource("1045")%>
                            </td>
                            <td align="center"><%Response.Write(DowntimeLimit + "%")%>
                            </td>
                        </tr>
                    </table>
                    <table class="shifttable" style="margin-top: 20px;">
                        <tr>
                            <th style="width: 60%; text-align: left"><%=ReadWriteXml.getAppResource("1056")%></th>
                            <th><%=ReadWriteXml.getAppResource("1036")%></th>
                        </tr>
                        <% If dsInspData.Tables.Contains("ACS_Defect_Res") Then
                                If dsInspData.Tables("ACS_Defect_Res").Rows.Count > 0 Then
                                    For i = 0 To dsInspData.Tables("ACS_Defect_Res").Rows.Count - 1%>
                        <tr>
                            <td><% Response.Write(dsInspData.Tables("ACS_Defect_Res").Rows(i)(0).ToString())%></td>
                            <td align="center"><% Response.Write(dsInspData.Tables("ACS_Defect_Res").Rows(i)(1).ToString())%></td>
                        </tr>
                        <% Next
                        End If
                    End If%>

                        <tr>
                            <td colspan="2">
                                <div align="right">
                                    <a target="_blank" href="DefectDetails.aspx?factory_c=<%Response.Write(Request("factory").ToString)%>&section_c=<%Response.Write(Request("section").ToString)%>&line_c=<%Response.Write(Request("line_C").ToString)%>&shift=<%Response.Write(hdshift_C.Value.ToString)%>&wk=<%Response.Write(Work_Date)%>" class="Link_Hover linkLabel">&nbsp;<%=ReadWriteXml.getAppResource("1055")%>&nbsp;</a>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <div style="float: right; width: 49%;">
                    <table width="100%" class="shifttable">
                        <tr bgcolor="gray" align="center">
                            <th style="width: 60%" align="left"><span><%=ReadWriteXml.getAppResource("1049")%></span></th>
                            <th style="width: 38%"><span><%=ReadWriteXml.getAppResource("1036")%></span></th>
                        </tr>
                        <tr>
                            <td>
                                <div><%=ReadWriteXml.getAppResource("1205")%></div>
                            </td>
                            <td>
                                <div align="center">
                                    <span><%Response.Write(DirectWorker)%></span>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div><%=ReadWriteXml.getAppResource("1287")%></div>
                            </td>
                            <td>
                                <div align="center">
                                    <span><%Response.Write(InDirectWorker)%></span>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div><%=ReadWriteXml.getAppResource("1053")%></div>
                            </td>
                            <td>
                                <div align="center">
                                    <span><%Response.Write(TotalWorker)%></span>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div align="right">
                                    <a target="_blank" href="WorkingTime.aspx?factory_c=<%Response.Write(Request("factory").ToString)%>&section_c=<%Response.Write(Request("section").ToString)%>&line_c=<%Response.Write(Request("line_C").ToString)%>&shift=<%Response.Write(hdshift_C.Value.ToString)%>&wk=<%Response.Write(Work_Date)%>" class="Link_Hover linkLabel">&nbsp;<%=ReadWriteXml.getAppResource("1055")%>&nbsp;</a>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div style="float: right; width: 65%;">
                <div style="float: left; width: 59%; margin-left: 10px;">
                    <table width="100%" class="shifttable">
                        <tr>
                            <th width="50%"><%=ReadWriteXml.getAppResource("1062")%></th>
                            <th width="30%" align="center">
                                <div><%=ReadWriteXml.getAppResource("1133")%></div>
                            </th>
                            <th width="20%" align="center">
                                <div><%=ReadWriteXml.getAppResource("1140")%></div>
                            </th>
                        </tr>
                        <% If dsInspData.Tables.Contains("ACS_insp_res") Then
                                Dim color As String=""
                                If dsInspData.Tables("ACS_insp_res").Rows.Count > 0 Then
                                    For i = 0 To dsInspData.Tables("ACS_insp_res").Rows.Count - 1
                                        If IsDBNull(dsInspData.Tables("ACS_insp_res").Rows(i)(0).ToString())= False and (dsInspData.Tables("ACS_insp_res").Rows(i)(0).ToString()) = "" Then
                                            color = "RED"
                                        End If%>
                        <tr>
                            <td  style="color:<%Response.Write(color)%>"><% Response.Write(dsInspData.Tables("ACS_insp_res").Rows(i)(0).ToString())%></td>
                            <td  style="color:<%Response.Write(color)%>"><% Response.Write(dsInspData.Tables("ACS_insp_res").Rows(i)(1).ToString())%></td>
                            <td align="center" style="color:<%Response.Write(color)%>"><% Response.Write(dsInspData.Tables("ACS_insp_res").Rows(i)(2).ToString())%></td>
                        </tr>
                        <% Next
                        End If
                    End If%>
                    </table>
                </div>
                <div style="float: right; width: 39%; background-color: #313131;" class="boxBorder">
                    <div>
                        <div>
                            <div style="font-weight: bold; width: 30%; float: left" class="orangeLabel"><%=ReadWriteXml.getAppResource("1086")%></div>
                            <div style="width: 20%; float: left; margin-left: 20px">
                                <a target="_black" href="DowntimeDetails.aspx?factory_c=<%Response.Write(Request("factory").ToString)%>&section_c=<%Response.Write(Request("section").ToString)%>&line_c=<%Response.Write(Request("line_C").ToString)%>&shift=<%Response.Write(hdshift_C.Value.ToString)%>&wk=<%Response.Write(Work_Date)%>" class="Link_Hover linkLabel">&nbsp;<%=ReadWriteXml.getAppResource("1088")%>&nbsp;</a>
                            </div>
                        </div>

                        <div>
                            <table width="99%" border="0">
                                <tr height="50%">
                                    <td rowspan="2" align="left" valign="top" width="30%">
                                        <div style="color: <% Response.Write(DowntimeColor)%>;"><span class="fontshift" style="font-size: large;"><%=ReadWriteXml.getAppResource("1087")%></span></div>
                                    </td>

                                    <td align="left" valign="top" width="40%">
                                        <div style="font-size: x-large; color: <% Response.Write(DowntimeColor)%>;"><% Response.Write(DowntimeRatio_Act.ToString)%>&nbsp;%</div>
                                    </td>

                                    <td rowspan="2" align="center" valign="top" width="30%">
                                        <% If (DowntimeRatio <= DowntimeRatio_Pl) Then%><img src="image/ok.png" width="70px" height="70px" /><% Else%><img src="image/ng.png" width="70px" height="70px" />
                                        <%End If%>
                                    </td>
                                </tr>

                                <tr height="50%">
                                    <td align="left" valign="top" width="40%">
                                        <div style="font-size: x-large; color: <% Response.Write(DowntimeColor)%>;"><% Response.Write(System.Math.Round(DowntimeRatio * 60, 2).ToString & "&nbsp;Min")%></div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <script type="text/javascript">
        $(document).ready(function () {
            updateShift();
            $("#d1").show();
            $("#d2").hide();
            colorToggle("refresh");
        });
        function a() {
            $('#d1, #d2').toggle();
        }

        function WriteCookie(id) {
            cookievalue = id + ";";
            document.cookie = "name=" + cookievalue;
        }

        function getCookie(cname) {
            var name = cname + "=";
            var ca = document.cookie.split(';');
            for (var i = 0; i < ca.length; i++) {
                var c = ca[i];
                while (c.charAt(0) == ' ') c = c.substring(1);
                if (c.indexOf(name) == 0) {
                    return c.substring(name.length, c.length);
                }
            }
            return "";
        }
        $(document).ready(function () {
            var user = getCookie("name");
            if (user != "" && user == "Q") {
                $("#dvQty").show();
                $("#dvChart").hide();
            } else {
                document.cookie = "name=" + "G";
                $("#dvQty").hide();
                $("#dvChart").show();
            }

            var graph = '<%=ReadWriteXml.getAppResource("1192").ToString()%>'
            var qty = '<%=ReadWriteXml.getAppResource("1070").ToString()%>'
            $(".selection").click(function () {
                if ($(this).text() == graph) {
                    $("#dvQty").hide();
                    $("#dvChart").show();
                } else if ($(this).text() == qty) {
                    $("#dvQty").show();
                    $("#dvChart").hide();
                }
            })
        })

        $(function () {
            $(function () {
                $(".PickedDate").datepicker({
                });
            });
        })
        function setShift(obj, val) {
            var hidden = document.getElementById('<%= hdshift_C.ClientID %>');
            hidden.value = val;
            obj.value = val;
        }

        function updateShift() {
            var factory = '<% Response.Write(Request("factory"))%>';
            var section = '<% Response.Write(Request("section"))%>';
            var line = '<% Response.Write(Request("line_C"))%>'
            var wk = ($(".PickedDate").val());
            if (wk.length > 0) {
                $.ajax({
                    type: "POST",
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    url: "Shift_Simple.aspx/updateShift",
                    data: "{'strDate':'" + wk + "','Factory':'" + factory + "','Section':'" + section + "','Line':'" + line + "'}",
                    success: function (response) {
                        var option = '';
                        var arr = []
                        arr = JSON.parse(response.d);
                        console.log();
                        if (arr.length > 0) {
                            for (var i = 0; i < arr.length; i++) {
                                option = option + '<option value="' + arr[i].Shift_C + '">' + arr[i].Shift_Nm + '</option>';
                            }
                            $(".shift").html(option);
                            var hidden = document.getElementById('<%= hdshift_C.ClientID %>');
                            if (arr.length == 1 || hidden.value == "") {
                                var hidden = document.getElementById('<%= hdshift_C.ClientID %>');
                                $(".shift").val(arr[0][0]);
                                hidden.value = (arr[0].Shift_C);
                            }

                            var hidden = document.getElementById('<%= hdshift_C.ClientID %>');
                            $(".shift").val(hidden.value);
                        }
                        else {
                            alert('<%Response.Write(ReadWriteXml.getAppResource("5001"))%>');
                            varoption = option + '<option value=""></option>';
                            $(".shift").html(option);
                            var hidden = document.getElementById('<%= hdshift_C.ClientID %>');
                            hidden.value = "";
                            $(".PickedDate").focus();
                        }
                    },
                    error: function (xhr, textStatus, error) {
                        alert("Error: " + error);
                    }
                })
            }
        }
        function whiteTheme() {
            $(".shifttable").toggleClass('shifttable shifttable_inverse');
            $(".divshift").toggleClass('divshift divshift_inverse');
            $(".body").toggleClass('body body_inverse');
            $(".header").toggleClass('header header_inverse');
            $(".header_title_1").toggleClass('header_title_1 header_title_1_inverse');
            $(".main_1").toggleClass('main_1 main_1_inverse');
            $(".main_left").toggleClass('main_left main_left_inverse');
            $(".loginDisplay").toggleClass('loginDisplay loginDisplay_inverse');
            $(".boxBorder").toggleClass('boxBorder boxBorder_inverse');
            $(".fontshift_head").toggleClass('fontshift_head fontshift_head_inverse');
            $(".fontshift_1").toggleClass('fontshift_1 fontshift_1_inverse');
            $(".main_left_menu_1").toggleClass('main_left_menu_1 main_left_menu_1_inverse');
            $(".main_left_menu_2").toggleClass('main_left_menu_2 main_left_menu_2_inverse');
            $(".orangeLabel").toggleClass('orangeLabel orangeLabel_inverse');
            $(".linkLabel").toggleClass('linkLabel linkLabel_inverse');
        }
        function balckTheme() {
            $(".shifttable_inverse").toggleClass('shifttable_inverse shifttable');
            $(".divshift_inverse").toggleClass('divshift_inverse divshift');
            $(".body_inverse").toggleClass('body_inverse body');
            $(".header_inverse").toggleClass('header_inverse header');
            $(".header_title_1_inverse").toggleClass('header_title_1_inverse header_title_1');
            $(".main_1_inverse").toggleClass('main_1_inverse main_1');
            $(".main_left_inverse").toggleClass('main_left_inverse main_left');
            $(".loginDisplay_inverse").toggleClass('loginDisplay_inverse loginDisplay');
            $(".boxBorder_inverse").toggleClass('boxBorder_inverse boxBorder');
            $(".fontshift_head_inverse").toggleClass('fontshift_head_inverse fontshift_head');
            $(".fontshift_1_inverse").toggleClass('fontshift_1_inverse fontshift_1');
            $(".main_left_menu_1_inverse").toggleClass('main_left_menu_1_inverse main_left_menu_1');
            $(".main_left_menu_2_inverse").toggleClass('main_left_menu_2_inverse main_left_menu_2');
            $(".orangeLabel_inverse").toggleClass('orangeLabel_inverse orangeLabel');
            $(".linkLabel_inverse").toggleClass('linkLabel_inverse linkLabel');
        }
        function setColor(val) {
            cookievalue = val + ";";
            document.cookie = "color=" + cookievalue;
        }
        function getColor(cColor) {
            var color = cColor + "=";
            var ca = document.cookie.split(';');
            for (var i = 0; i < ca.length; i++) {
                var c = ca[i];
                while (c.charAt(0) == ' ') c = c.substring(1);
                if (c.indexOf(color) == 0) {
                    return c.substring(color.length, c.length);
                }
            }
            return "";
        }
        function colorToggle(action) {
            if (action == "click") {
                if (getColor("color") == "Color(1)" || getColor("color") == "") {
                    whiteTheme();
                    setColor("Color(2)");
                }
                else {
                    balckTheme();
                    setColor("Color(1)");
                }
            }
            if (action == "refresh") {
                if (getColor("color") == "Color(2)") { whiteTheme(); }
                else { balckTheme(); }
            }
        }
    </script>
</asp:Content>



