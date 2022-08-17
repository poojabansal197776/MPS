<%--
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'File Name          : Default.aspx
'Function           : To Use custom control for search Lines for the sections
'Created By         : 
'Created on         : 
'Revision History   : Modified by Gagan Kalyana on 2015-Apr-02 for unused code removal.
'                   : Modified by Gagan Kalyana on 2016-Feb-11 for FC66-GLOBAL VISUALIZING IN-ASSEMBLY SYSTEM_PHASE2
'                     Changes has been done to add Display Changeover function of the Home screen.
'                   : Changes has been done by SIS on 2016-Mar-31 and merged by mohit maheshwari on 2016-Dec-28
'                   : Modified by Gagan Kalyana on 2017-Mar-08 for FC69_GVIA-Phase-III-I
'                     Changes has been done to:
'                       1. Add the display of Real Time Efficiency, Downtime, Defect Count and Production Qty. on the basis of Parameter master setting.
'                       2. In case of GVIA simple mode, "Print" button has been added on top of the screen.
'                       3. Formula for Working Time calculation has been improved.   
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%>

<%@ Page Title="Home Page" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="_Default" %>
<%@ MasterType  virtualPath="~/Site.Master"%>   <%--Added by Gagan Kalyana on 2017-Mar-08 --%>
<%@ Import Namespace="System.Data" %>
<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>
<%--Commented by Gagan Kalyana on 2015-Apr-02 [Start]--%>
<%--<% @Import Namespace= "System" %>
<% @Import Namespace= "System.Data" %>
<% @Import Namespace= "System.Configuration"%>
<% @Import Namespace= "System.Web"%>
<% @Import Namespace= "System.Web.Security"%>--%>
<%--<% @Import Namespace= "System.Web.UI" %>--%>
<%--<% @Import Namespace= "System.Web.UI.WebControls"%>
<% @Import Namespace= "System.Web.UI.WebControls.WebParts"%>--%>
<%--<% @Import Namespace= "System.Web.UI.HtmlControls"%>--%>
<%--'Commented by Gagan Kalyana on 2015-Apr-02 [End]--%>
<%@ Import Namespace="System.Data.SqlClient" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <div class="clear"></div>
    <%--Added by Gagan Kalyana on 2016-Feb-11 [Start]--%>
    <div>
        <ul class="tabrow Link_Hover" align="right">
            <li id="pp" class="selected" onclick="changeover(1);return false"><%=ReadWriteXml.getAppResource("1212")%></li>
            <li id="dt" onclick="changeover(2);return false"><%=ReadWriteXml.getAppResource("1213")%></li>
        </ul>
    </div>
    <script type="text/javascript">
        function changeover(id) {
            if (id == "1") {
                $(".dvProgress").show();
                $(".dvDowntime").hide();
                $("#dt").removeClass("selected");
                $("#pp").addClass("selected");
            }
            else {
                $("#pp").removeClass("selected");
                $("#dt").addClass("selected");
                $(".dvProgress").hide();
                $(".dvDowntime").show();
            }
        }
        //Modified by SIS on 2016-Mar-31
        //function validateLeader(leader,message) {
        function validateLeader(leader, message, message1, wkdata) {
            //Added by SIS on 2016-Mar-31[Start]
            if (wkdata == '') {
                alert(message1)
                return false;
            }
            //Added by SIS on 2016-Mar-31[End]
            if (leader == '') {
                alert(message);
                //return true;   Commented by SIS  on 2016-Mar-31
            }
            return true; //Added by SIS on 2016-Mar-31
        }
    </script>
    <%--Added by Gagan Kalyana on 2016-Feb-11 [End]--%>
    <%
        Dim sql As String
        Dim db As New Database
        Dim reader_factory As SqlDataReader
        Dim reader_section As SqlDataReader
        Dim AF(100) As String
        Dim AY(100) As String
        Dim _step_f As Integer = 0
        Dim _step_s As Integer = 0
        Dim k As Integer = 0
        For k = 0 To 100
            AF(k) = "00000"
            AY(k) = "00000"
        Next
            
        sql = "Select distinct factory_c from Line_mst order by factory_c "
        db.conecDB()
        db.initCMD()
        reader_factory = db.execReader(sql)
        While reader_factory.Read()
            AF(_step_f) = reader_factory("factory_c").ToString
            _step_f = _step_f + 1
        End While
        db.closeDB()
        reader_factory.Close()
            
        sql = "Select distinct section_c from Line_mst  where status_flg='1' order by section_c "
        db.conecDB()
        db.initCMD()
        reader_section = db.execReader(sql)
        While reader_section.Read()
            AY(_step_s) = reader_section("section_c").ToString
            _step_s = _step_s + 1
        End While
        db.closeDB()
        reader_section.Close()
            
        If _step_f = 0 Then
            _step_f = 1
        End If
            
        If _step_s = 0 Then
            _step_s = 1
        End If
            
        Dim j As Integer = 0
        Dim i As Integer = 0
        For i = 0 To _step_f - 1
    %>
    <div><span style="color: Orange; font-size: large; font-weight: bold;"><%=ReadWriteXml.getAppResource("1019")%> <% Response.Write(AF(i))%></span></div>
    <%--Modified by Gagan Kalyana on 2016-Feb-11
  <table width="99%" border="0" cellspacing="0" cellpadding="0">--%>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr valign="top">
            <td width="100%" style="border: 1px white solid; border-bottom: 0px;">
                <%                       
                    For j = 0 To _step_s - 1
                        Dim check As Integer = 0
                        sql = "Select distinct section_c from Line_mst where factory_c='" + AF(i) + "' and section_c='" & AY(j) & "' "
                        db.conecDB()
                        db.initCMD()
                        reader_section = db.execReader(sql)
                        If reader_section.Read() Then
                            check = 1
                        End If
                        db.closeDB()
                        reader_section.Close()
                        If check > 0 Then
                %>
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tr>
                        <td style="border-bottom: 1px white solid;"><div class="assy"><% Response.Write(AY(j))%></div></td>
                        <%--Added by Gagan Kalyana on 2016-Feb-11--%>
                        <%--<td style="border-bottom:1px white solid; "> --%>
                        <td class="dvProgress">
                            <%                          
                                'Dim reader As SqlDataReader
                                'db.conecDB()
                                'db.initCMD()                                    
                                'sql = "SELECT * FROM Line_mst where factory_c='" & AF(i) & "' and section_c='" & AY(j) & "' "
                                'reader = db.execReader(sql)
                                'While reader.Read()
                                '    Dim _color As String = "assytab"
                                '    If _check_line_status(reader("factory_c").ToString, reader("section_c").ToString, reader("line_c").ToString) > 0 Then
                                '        _color = "assytab_1"

                                '        If _check_downtime_pl_shift(reader("factory_c").ToString, reader("section_c").ToString, reader("line_c").ToString) = 1 Then
                                '            _color = "assytab_2"
                                '        End If
                                '    End If
                                Dim dt As New DataTable
                                Dim _color As String = "assytab"
                                'Added by SIS on 2016-Mar-31 [Start]
                                Dim plan_qty As Integer
                                Dim act_qty As Integer
                                Dim work_date As String
                                Dim shift As String
                                Dim work_date_yyyyMMdd As String
                                'Added by SIS on 2016-Mar-31 [END]
                                'Added by Gagan Kalyana on 2017-Mar-08 [Start] 
                                Dim Efficiency As String = "XX"
                                Dim Downtime As String = "XX"
                                Dim Defects As String = "XX"
                                'Added by Gagan Kalyana on 2017-Mar-08 [End]
                                sql = "SELECT A.*, B.Tw_Leader_1 FROM Line_Mst AS A LEFT JOIN Shift_Leader_Mst AS B ON A.Factory_C = B.Factory_C"
                                sql = sql + " AND A.Section_C = B.Section_C AND A.Line_C = B.Line_C where A.factory_c='" & AF(i) & "' and A.section_c='" & AY(j) & "' AND status_flg = 1"
                                dataAdapter = New SqlDataAdapter(sql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
                                dataAdapter.Fill(dt)
                                If dt.Rows.Count > 0 Then
                                    For intCounter = 0 To dt.Rows.Count - 1
                                        _color = "assytab"
                                        If _check_line_status(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString) > 0 Then
                                            _color = "assytab_1"

                                            If production_prgress_check(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString) = 1 Then
                                                _color = "assytab_2"
                                            End If
                                        End If
                                        'Added by SIS on 2016-Mar-31 [Start]
                                        work_date = _get_work_date(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString)
                                        shift = _get_shift(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString)
                                        
                                        'Added by Gagan Kalyana on 2017-Mar-08 [Start] 
                                        Defects = "0"
                                        getDefectCountLineWise(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString, shift, work_date)
                                        
                                        If dataSet.Tables.Count > 0 Then
                                            If dataSet.Tables.Contains("ACS_Defect_Res") = True And dataSet.Tables("ACS_Defect_Res").Rows.Count > 0 Then
                                                Defects = dataSet.Tables("ACS_Defect_Res").Rows(0)(0)
                                            End If
                                        End If
                                        
                                        
                                        Downtime = getDowntime(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString, shift, work_date)
                                        Efficiency = getRealTimeEfficiency(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString, shift, work_date)
                                        'Added by Gagan Kalyana on 2017-Mar-08 [End]
                                        
                                        work_date_yyyyMMdd = _get_work_date_yyyyMMdd(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString)
                                        If String.Compare(DateTime.Now.ToString("yyyyMMdd"), work_date_yyyyMMdd) = 0 Then
                                            plan_qty = _get_plan_Qty(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString, work_date, shift)
                                            act_qty = _get_Act_Qty(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString, work_date, shift)
                                            Efficiency = Efficiency + " %"  'Added by Gagan Kalyana on 2017-Mar-08
                                            Downtime = Downtime + " %"      'Added by Gagan Kalyana on 2017-Mar-08
                                        Else
                                            plan_qty = 0
                                            act_qty = 0
                                            'Added by Gagan Kalyana on 2017-Mar-08 [Start]
                                            Efficiency = "XX%"
                                            Downtime = "XX%"
                                            Defects = "XX"
                                            'Added by Gagan Kalyana on 2017-Mar-08 [End]
                                        End If
                                        'Added by SIS on 2016-Mar-31 [END]
                                       
                            %>
                            <%--Modified by SIS on 2016-Mar-31--%>
                            <%--<div class="<% Response.Write(_color)%>">--%>
                            <div class="<% Response.Write(_color)%>" align="center">
                                <%--Modified by Gagan Kalyana on 2016-Feb-11
                                    <a href="Shift.aspx?factory=<%Response.Write(reader("factory_c").ToString())%>&section=<%Response.Write(reader("section_c").ToString())%>&line=<%Response.Write(reader("line_c").ToString())%>&wk=<% Response.Write(_get_work_date(reader("factory_c").ToString, reader("section_c").ToString, reader("line_c").ToString))%>&s=<% Response.Write(_get_shift(reader("factory_c").ToString, reader("section_c").ToString, reader("line_c").ToString))%>" title="<% Response.Write(reader("line_c").ToString)%>"><span class="assytabline"><%Response.Write(Mid(reader("line_nm").ToString, 1, 20))%></span>  </a>--%>
                                <%--Modified by SIS on 2016-Mar-31[Start] --%>
                                <%--<a onclick="validateLeader('<% Response.Write(dt.Rows(intCounter)("Tw_Leader_1").ToString)%>','<%Response.Write(ReadWriteXml.getAppResource("5000"))%>')" href="Shift.aspx?factory=<%Response.Write(dt.Rows(intCounter)("factory_c").ToString())%>&section=<%Response.Write(dt.Rows(intCounter)("section_c").ToString())%>&line=<%Response.Write(dt.Rows(intCounter)("line_c").ToString())%>&wk=<% Response.Write(_get_work_date(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString))%>&s=<% Response.Write(_get_shift(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString))%>" title="<% Response.Write(dt.Rows(intCounter)("line_c").ToString)%>"><span class="assytabline"><%Response.Write(Mid(dt.Rows(intCounter)("line_nm").ToString, 1, 20))%></span>  </a>--%>
                                <%--'Modified by Gagan Kalyana on 2017-Mar-08 [Start] 
                                    <a onclick="return validateLeader('<% Response.Write(dt.Rows(intCounter)("Tw_Leader_1").ToString)%>','<%Response.Write(ReadWriteXml.getAppResource("5000"))%>','<%Response.Write(ReadWriteXml.getAppResource("5008"))%>','<% Response.Write(_get_work_date(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString))%>')" href="Shift.aspx?factory=<%Response.Write(dt.Rows(intCounter)("factory_c").ToString())%>&section=<%Response.Write(dt.Rows(intCounter)("section_c").ToString())%>&line=<%Response.Write(dt.Rows(intCounter)("line_c").ToString())%>&wk=<% Response.Write(_get_work_date(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString))%>&s=<% Response.Write(_get_shift(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString))%>" title="<% Response.Write(dt.Rows(intCounter)("line_c").ToString)%>"><span class="assytabline"><%Response.Write(Mid(dt.Rows(intCounter)("line_nm").ToString, 1, 20))%>
                                        <br />
                                    <% Response.Write(act_qty)%> / <% Response.Write(plan_qty)%></span></a>--%>
                                        <%If Master.strValue = True Then%>
                                            <a onclick="return validateLeader('<% Response.Write(dt.Rows(intCounter)("Tw_Leader_1").ToString)%>','<%Response.Write(ReadWriteXml.getAppResource("5000"))%>','<%Response.Write(ReadWriteXml.getAppResource("5008"))%>','<% Response.Write(_get_work_date(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString))%>')" href="Shift_Simple.aspx?factory=<%Response.Write(dt.Rows(intCounter)("factory_c").ToString())%>&section=<%Response.Write(dt.Rows(intCounter)("section_c").ToString())%>&line_C=<%Response.Write(dt.Rows(intCounter)("line_c").ToString())%>&wk=<% Response.Write(work_date)%>&s=<% Response.Write(shift)%>&line_Nm=<% Response.Write(dt.Rows(intCounter)("line_nm").ToString())%>" title="<% Response.Write(dt.Rows(intCounter)("line_c").ToString)%>"><span class="assytabline"><%Response.Write(Mid(dt.Rows(intCounter)("line_nm").ToString, 1, 20))%>
                                        <%Else%>
                                            <a onclick="return validateLeader('<% Response.Write(dt.Rows(intCounter)("Tw_Leader_1").ToString)%>','<%Response.Write(ReadWriteXml.getAppResource("5000"))%>','<%Response.Write(ReadWriteXml.getAppResource("5008"))%>','<% Response.Write(_get_work_date(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString))%>')" href="Shift.aspx?factory=<%Response.Write(dt.Rows(intCounter)("factory_c").ToString())%>&section=<%Response.Write(dt.Rows(intCounter)("section_c").ToString())%>&line=<%Response.Write(dt.Rows(intCounter)("line_c").ToString())%>&wk=<% Response.Write(_get_work_date(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString))%>&s=<% Response.Write(_get_shift(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString))%>" title="<% Response.Write(dt.Rows(intCounter)("line_c").ToString)%>"><span class="assytabline"><%Response.Write(Mid(dt.Rows(intCounter)("line_nm").ToString, 1, 20))%>
                                        <%End If%>
                                        <% If btnDisplayProduction_Qty = True Then%><br/><%  Response.Write(act_qty)%> / <% Response.Write(plan_qty)
                                           End If%>
                                    <span style="color:white;font-size:x-small;">
                                        <% If btnDisplayEfficiecy = True Then%> 
                                            <br /><label>Efficiency (%):<% Response.Write(Efficiency)%></label><%End If%><% If btnDisplayDownTime = True Then%><br/><label>Downtime (%):<%Response.Write(Downtime)%></label><%End If%><% If btnDisplayDefect = True Then%><br/><label>Defects:<% Response.Write(Defects)%></label><%End If%></span></span></a><%--'Modified by Gagan Kalyana on 2017-Mar-08 [End]--%><%--Modified by SIS on 2016-Mar-31[End] --%></div>
                            <%                      
                                'Commented and added by Gagan Kalyana on 2016-Feb-11
                                'End While
                                'db.closeDB()
                                'reader.Close()
                            Next
                        End If
                            %>
                            <div style="font-size: 2px; width: 100%;"></div>
                        </td>
                        <%--Added by Gagan Kalyana on 2016-Feb-11 [Start]--%>
                        <td class="dvDowntime">
                            <%                          
                                If dt.Rows.Count > 0 Then
                                    For intCounter = 0 To dt.Rows.Count - 1
                                        'Added by Gagan Kalyana on 2017-Mar-08 [Start] 
                                        Efficiency = "XX"
                                        Downtime = "XX"
                                        Defects = "XX"
                                        'Added by Gagan Kalyana on 2017-Mar-08 [End]
                                        _color = "assytab"
                                        If _check_line_status(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString) > 0 Then
                                            _color = "assytab_1"
                                            If _check_downtime_pl_shift(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString) = 1 Then
                                                _color = "assytab_2"
                                            End If
                                        End If
                                        'Added by SIS on 2016-Mar-31 [Start]
                                        work_date = _get_work_date(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString)
                                        shift = _get_shift(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString)
                                        'Added by Gagan Kalyana on 2017-Mar-08 [Start] 
                                        Defects = "0"
                                        getDefectCountLineWise(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString, shift, work_date)
                                        If dataSet.Tables.Count > 0 Then
                                            If dataSet.Tables.Contains("ACS_Defect_Res") = True And dataSet.Tables("ACS_Defect_Res").Rows.Count > 0 Then
                                                Defects = dataSet.Tables("ACS_Defect_Res").Rows(0)(0)
                                            End If
                                        End If
                                        
                                        Downtime = getDowntime(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString, shift, work_date)
                                        Efficiency = getRealTimeEfficiency(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString, shift, work_date)
                                        'Added by Gagan Kalyana on 2017-Mar-08 [End]  
                                        
                                        work_date_yyyyMMdd = _get_work_date_yyyyMMdd(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString)
                                        If String.Compare(DateTime.Now.ToString("yyyyMMdd"), work_date_yyyyMMdd) = 0 Then
                                            plan_qty = _get_plan_Qty(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString, work_date, shift)
                                            act_qty = _get_Act_Qty(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString, work_date, shift)
                                            Efficiency = Efficiency + " %"  'Added by Gagan Kalyana on 2017-Mar-08
                                            Downtime = Downtime + " %"      'Added by Gagan Kalyana on 2017-Mar-08
                                        Else
                                            plan_qty = 0
                                            act_qty = 0
                                            'Added by Gagan Kalyana on 2017-Mar-08 [Start]
                                            Efficiency = "XX%"
                                            Downtime = "XX%"
                                            Defects = "XX"
                                            'Added by Gagan Kalyana on 2017-Mar-08 [End]
                                        End If
                                        'Added by SIS on 2016-Mar-31 [END]
                                            
                            %>
                            <%--Modified by SIS on 2016-Mar-31 [Start]--%>
                            <%--<div class="<% Response.Write(_color)%>">--%>
                            <%--<a onclick="validateLeader('<% Response.Write(dt.Rows(intCounter)("Tw_Leader_1").ToString)%>','<%Response.Write(ReadWriteXml.getAppResource("5000"))%>')" href="Shift.aspx?factory=<%Response.Write(dt.Rows(intCounter)("factory_c").ToString())%>&section=<%Response.Write(dt.Rows(intCounter)("section_c").ToString())%>&line=<%Response.Write(dt.Rows(intCounter)("line_c").ToString())%>&wk=<% Response.Write(_get_work_date(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString))%>&s=<% Response.Write(_get_shift(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString))%>" title="<% Response.Write(dt.Rows(intCounter)("line_c").ToString)%>"><span class="assytabline"><%Response.Write(Mid(dt.Rows(intCounter)("line_nm").ToString, 1, 20))%></span>  </a>--%>
                            <div class="<% Response.Write(_color)%>" align="center">
                                    <%--Modified by Gagan Kalyana on 2017-Mar-08 [Start] 
                                    <a onclick="return validateLeader('<% Response.Write(dt.Rows(intCounter)("Tw_Leader_1").ToString)%>','<%Response.Write(ReadWriteXml.getAppResource("5000"))%>','<%Response.Write(ReadWriteXml.getAppResource("5008"))%>','<% Response.Write(_get_work_date(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString))%>')" href="Shift.aspx?factory=<%Response.Write(dt.Rows(intCounter)("factory_c").ToString())%>&section=<%Response.Write(dt.Rows(intCounter)("section_c").ToString())%>&line=<%Response.Write(dt.Rows(intCounter)("line_c").ToString())%>&wk=<% Response.Write(_get_work_date(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString))%>&s=<% Response.Write(_get_shift(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString))%>" title="<% Response.Write(dt.Rows(intCounter)("line_c").ToString)%>"><span class="assytabline"><%Response.Write(Mid(dt.Rows(intCounter)("line_nm").ToString, 1, 20))%>
                                    <br>
                                    <% Response.Write(act_qty)%> / <% Response.Write(plan_qty)%></span>  </a>--%>
                                 <%If Master.strValue = True Then%>
                                            <a onclick="return validateLeader('<% Response.Write(dt.Rows(intCounter)("Tw_Leader_1").ToString)%>','<%Response.Write(ReadWriteXml.getAppResource("5000"))%>','<%Response.Write(ReadWriteXml.getAppResource("5008"))%>','<% Response.Write(work_date)%>')" href="Shift_Simple.aspx?factory=<%Response.Write(dt.Rows(intCounter)("factory_c").ToString())%>&section=<%Response.Write(dt.Rows(intCounter)("section_c").ToString())%>&line=<%Response.Write(dt.Rows(intCounter)("line_c").ToString())%>&wk=<% Response.Write(work_date)%>&s=<% Response.Write(shift)%>&line_Nm=<% Response.Write(dt.Rows(intCounter)("line_nm").ToString())%>" title="<% Response.Write(dt.Rows(intCounter)("line_c").ToString)%>"><span class="assytabline"><%Response.Write(Mid(dt.Rows(intCounter)("line_nm").ToString, 1, 20))%>
                                        <%Else%>
                                            <a onclick="return validateLeader('<% Response.Write(dt.Rows(intCounter)("Tw_Leader_1").ToString)%>','<%Response.Write(ReadWriteXml.getAppResource("5000"))%>','<%Response.Write(ReadWriteXml.getAppResource("5008"))%>','<% Response.Write(_get_work_date(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString))%>')" href="Shift.aspx?factory=<%Response.Write(dt.Rows(intCounter)("factory_c").ToString())%>&section=<%Response.Write(dt.Rows(intCounter)("section_c").ToString())%>&line=<%Response.Write(dt.Rows(intCounter)("line_c").ToString())%>&wk=<% Response.Write(_get_work_date(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString))%>&s=<% Response.Write(_get_shift(dt.Rows(intCounter)("factory_c").ToString, dt.Rows(intCounter)("section_c").ToString, dt.Rows(intCounter)("line_c").ToString))%>" title="<% Response.Write(dt.Rows(intCounter)("line_c").ToString)%>"><span class="assytabline"><%Response.Write(Mid(dt.Rows(intCounter)("line_nm").ToString, 1, 20))%>
                                        <%End If%>
                                        
                                <% If btnDisplayProduction_Qty = True Then%><br /><%
                                            Response.Write(act_qty)%> / <% Response.Write(plan_qty)
                                                                                              End If%>
                                    <span style="color:white;font-size:x-small;"> 
                                        <% If btnDisplayEfficiecy = True Then%> 
                                            <br /><label>Efficiency (%):<% Response.Write(Efficiency)%></label><%End If%><% If btnDisplayDownTime = True Then%><br/><label>Downtime (%):<%Response.Write(Downtime)%></label><%End If%><% If btnDisplayDefect = True Then%><br/><label>Defects:<% Response.Write(Defects)%></label><%End If%></span></span></a><%--Modified by Gagan Kalyana on 2017-Mar-08 [End]--%><%--Modified by SIS on 2016-Mar-31 [End]--%></div>
                            <%                      
                            Next
                        End If
                        dt.Clear()
                            %>           
                        </td>
                        <%--Added by Gagan Kalyana on 2016-Feb-11 [End]--%>
                    </tr>
                </table>
                <%  
                End If
            Next j
                %>              
            </td>
        </tr>
    </table>
    <%   Next i%>
</asp:Content>
