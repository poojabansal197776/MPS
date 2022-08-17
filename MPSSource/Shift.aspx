<%--
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'File Name          : Shift.aspx
'Function           : To show visualization of ACS inspection process throgh graph
'Created By         : 
'Created on         : 
'Revision History   : Modified by Gagan Kalyana on 2015-Mar-23 for the FC63 Anken
'                     On entry of each screen a log entry will be store in Screen_Usage table
'                   : Modified by Gagan Kalyana on 2015-Mar-27, 2015-Apr-14 for the FC63 Anken
'                     Working screen design chnage.
'                   : Modified by Govind on 2015-Mar-19 for Factory Code
'                   : Modified by Gagan Kalyana on 2015-Apr-02, 2015-Apr-06 and 2015-Apr-07 for Screen Usage design
'                   : Modified by Gagan Kalyana on 2015-Apr-02 for unused code removal
'                   : Modified by Gagan Kalyana on 2015-Apr-17 for Mouse Pointer Change to hand over Mouse Hover   
'                   : Modified by Gagan Kalyana on 2015-Apr-22 for Full date display on Pop-up while clicking on Detail(2) 
'                   : Modified by Gagan Kalyana on 2015-Apr-27 for FC63 Anken
' 		              Changes has been done for Defect plotting on Graph.
'                   : Modified by Gagan Kalyana on 2015-May-06 for FC63 Anken (IS3 Req. No.ER/150506002)
' 		              Bug Fix: Changes has been done to show Defect Quantity in figure.
'                   : Modified by Gagan Kalyana on 2015-May-08 for FC63 Anken
' 		              Modifications done for proper japanese caption display
'                   : Modified by Gagan Kalyana on 2015-May-13 for FC63 Anken (IS3 Req. No. ER/150513002)
'                     When the screen refresh has been executed, Graph is displayed.When a number is being displayed,Please be in the numerical display.
'                   : Modified by Gagan Kalyana on 2015-May-13 for FC63 Anken (IS3 Req. No. ER/150513001)
'                     CR: Do not display SECTION,SUPERVISOR NOTE, SUB LEADER,UPDATETIME
'                   : Modified by Gagan Kalyana on 2015-May-13 for FC63 Anken (IS3 Req. No. ER/150513004)
'                     CR:Increase the Fonrt Size of Quantity Fields display
'                   : Modified by Gagan Kalyana on 2015-May-15 for Support and Maintenance (IS3 Req. No. ER/150515002)
'                     Quantity displayed as Number should be according to Orange Line till current Time. Earlier this was according to Red Line till current Time.
'                   : Modified by Gagan Kalyana on 2015-May-18 for Support and Maintenance (IS3 Req. No. ER/150518001)
'                     Modifications done for Japanese and Chinese caption display
'                   : Modified by Gagan Kalyana on 2015-Dec-17 for Support and Maintenance (IS3 Req. No. ER/151217001)
' 		              Changes done to add Color Switch on the Work Progress screen (Shift.aspx).
'                   : Modified by Gagan Kalyana on 2016-Feb-18 for FC66-GLOBAL VISUALIZING IN-ASSEMBLY SYSTEM_PHASE2
'                     [1]. The caption of Zoom Out button is changed to Zoom.
'                     [2]. On click of each Detail button, screen will be opened in new browser window.
'                     [3]. Detail(2) button is removed and caption of all other Detail buttons is changed as followings:
'                          Detail(1) --> Detail
'                          Detail(3) --> Detail
'                          Detail(4) --> Detail                        
'                     [4]. Add Design Change and Work Order No. and remove Abd and Cbd from the Product information area.
'                     [5]. For drawing of yellow line (Production Progress (Downtime %)) of graph use progress judgement rate defined in DicData_MST.
'                     [6]. Display format of field showing time value of Working Time area will be changed to "HH.MM"
'                     [7]. A new image will be added on the work progress screen to display the Production Progress using Progress judgment rate defined in DicData_Mst.
'                     [8]. Stopage Ratio will be calculted till the current time only. Not till the operation time of target shift.
'                     [9]. Defect reference of work progress screen will be changed from Defect_Res to ACS_Defect_Res.
'                     [10]. Display real time efficiency on top of Work Progress screen's graph.
'                     [11]. Allow the user to change Work Date and Shift and a search button is added to view Prpoduction History data on this screen.
'                   : Modified by Gagan Kalyana on 2016-Apr-04 for FC66-GLOBAL VISUALIZING IN-ASSEMBLY SYSTEM_PHASE2 
'                     Bug Fix: Change the separator of Working Time Area from Dot (.) to Colon (:).     (IS3 Req. No. ER/160331016)
'                     Bug Fix: Stoppage ratio is to be calculated for the current Working Hours.        (IS3 Req. No. ER/160405001)
'                     Bug Fix: Real Time Efficiency is not displaying correctly .                       (IS3 Req. No. ER/160405002)
'                   : Modified by SIS on 2016-Apr-06 for FC66-GLOBAL VISUALIZING IN-ASSEMBLY SYSTEM_PHASE2 
'                     Bug Fix:                        (IS3 Req. No. ER/160405002)
'                   : Modified by Gagan Kalyana on 2016-Apr-07 for FC66-GLOBAL VISUALIZING IN-ASSEMBLY SYSTEM_PHASE2 
'                     Bug Fix: Real Time Efficiency is not displaying correctly .                       (IS3 Req. No. ER/160405002)
'                   : Modified by SIS on 2016-Nov-23 for FC68-GLOBAL VISUALIZING IN-ASSEMBLY SYSTEM_PHASE3 
'                   : Modified by SIS on 2017-Jun-13 for FC68-GLOBAL VISUALIZING IN-ASSEMBLY SYSTEM_PHASE3 
'                     Bug Fix: Processing correction with 4M process less than 6
'                   : Modified by SIS on 2017-Jun-19 for FC68-GLOBAL VISUALIZING IN-ASSEMBLY SYSTEM_PHASE3 
'                     Bug Fix: Correction of the efficiency indication when there is not overtime work
'                   : Modified by Gagan Kalyana on 2017-Mar-16 for FC69_GVIA-Phase-III-I
'                     Changes have been done to improve the Formula calculation of Working Time which will improve the calculation of Real Time Efficiency. 
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--%>
<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" %>

<%@ Import Namespace="System.Web.Script.Serialization" %>



<%--'Commented by Gagan Kalyana on 2015-Apr-02 [Start]--%>
<%--<%@ Import Namespace="System.Net" %>
<% @Import Namespace= "System" %>
<% @Import Namespace= "System.Data" %>
<% @Import Namespace= "System.Configuration"%>
<% @Import Namespace= "System.Web"%>
<% @Import Namespace= "System.Web.Security"%>--%>
<%--<% @Import Namespace= "System.Web.UI.WebControls"%>--%>
<%--<% @Import Namespace= "System.Web.UI.WebControls.WebParts"%>--%>
<%--'Commented by Gagan Kalyana on 2015-Apr-02 [End]--%>

<%@ Import Namespace="System.Web.UI" %>
<%@ Import Namespace="System.Web.UI.HtmlControls" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%--Added by Gagan Kalyana on 2016-Feb-18--%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.Services" %>
<%@ Import Namespace="System.Globalization" %>

<script runat="server">
    Public _dman As Double = 28.0    
    Public _direct As Double = 0.0
    Public _indirect As Double = 0.0
    Public _target As Double = 0.0
    'Added by Gagan Kalyana on 2015-Apr-06[Start]
    Protected _defectCount As Double = 0.0
    Protected _actualCount As Double = 0.0
    Protected _BaseonTargetofline As Double = 0.0
    'Added by Gagan Kalyana on 2015-Apr-06[End]
    'Public _tact_time_target As Double = 0.0
    'Added by Gagan Kalyana on 2016-Feb-18 [Start]
    Protected dataAdapter As SqlDataAdapter
    Dim strSql As String
    Protected dataSet As New DataSet
    Protected _dblWorking_hours_act As Double = 0.0
    Protected dblJudgementRate As Integer = 0
    Protected dblOpr_time As Double = 0.0
    Dim smh As Double = 1.0
    Dim strWorkDate As String
    Dim strShiftNm As String
    Dim strShift As String
    'Added by Gagan Kalyana on 2016-Feb-18 [End]
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)       
        If Not IsPostBack() Then
            '[11] Commented and Added by Gagan Kalyana on 2016-Feb-18[Start]
            bt_Search.Text = ReadWriteXml.getAppResource("1197")
            Dim intTemp As Integer
            If (hdshift_C.Value = "") Then
                strSql = strSql & "SELECT DISTINCT A.Shift_c, A.Shift_Nm FROM Shift_Mst AS A "
                strSql = strSql & "WHERE  A.factory_c = '" + Request("factory") + "' AND A.Section_c='" & Request("section") & "'"
                dataSet.Tables.Clear()
                dataAdapter = New SqlDataAdapter(strSql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
                dataAdapter.Fill(dataSet)
                If dataSet.Tables(0).Rows.Count > 0 Then
                    For intTemp = 0 To dataSet.Tables(0).Rows.Count - 1
                        shift.Items.Add(New ListItem(dataSet.Tables(0).Rows(intTemp)("Shift_Nm"), dataSet.Tables(0).Rows(intTemp)("Shift_c")))
                    Next
                End If
                hdshift_C.Value = Request("s").ToString
            End If
            '[11] Commented and Added by Gagan Kalyana on 2016-Feb-18[End]
            
            _get_line_information(Request("factory"), Request("section"), Request("line"), Request("wk"), Request("s"))
            _get_over_time(Request("factory"), Request("section"), Request("line"), Request("wk"), Request("s"))
            _get_drawing_chart()
        End If
    End Sub
   
    '[11] Commented and Added by Gagan Kalyana on 2016-Feb-18[Start]
    <WebMethod> _
    Public Shared Function updateShift(strDate As String, Factory As String, Section As String, Line As String) As String
        Dim strSql As String = ""
        Dim table As New DataTable
        Dim adapter As SqlDataAdapter
        Dim dtWorkDate As DateTime = DateTime.ParseExact(strDate, "dd/MM/yyyy", CultureInfo.InvariantCulture)
        strDate = dtWorkDate.ToString("yyyy/MM/dd", CultureInfo.InvariantCulture)
        strSql = "SELECT A.Shift_C, B.Shift_Nm FROM Line_Data AS A JOIN Shift_Mst AS B "
        strSql = strSql & "ON A.Section_C = B.Section_C AND A.Factory_C = B.Factory_C AND A.Shift_C = B.Shift_C "
        strSql = strSql & "WHERE  A.factory_c = '" + Factory + "' AND A.Section_c='" & Section & "'  AND A.Line_C='" & Line & "' AND A.Work_date = '" & strDate & "'"
        adapter = New SqlDataAdapter(strSql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
        adapter.Fill(table)
        Dim serializer As New JavaScriptSerializer()
        Dim rows As New List(Of Dictionary(Of String, Object))()
        Dim row As Dictionary(Of String, Object)
        For Each dr As DataRow In table.Rows
            row = New Dictionary(Of String, Object)()
            For Each col As DataColumn In table.Columns
                row.Add(col.ColumnName, dr(col))
            Next
            rows.Add(row)
        Next
        Return serializer.Serialize(rows)
    End Function
    
    Protected Sub bt_search_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles bt_Search.Click
        If (hdshift_C.Value <> "") Then
            Dim dtWorkDate As DateTime = DateTime.ParseExact(lb_working_day_1.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture)
            strWorkDate = dtWorkDate.ToString("yyyy/MM/dd", CultureInfo.InvariantCulture)
            lb_working_day.Text = strWorkDate
            _get_line_information(Request("factory"), Request("section"), Request("line"), strWorkDate, hdshift_C.Value)
            _get_over_time(Request("factory"), Request("section"), Request("line"), strWorkDate, hdshift_C.Value)
            lblRealEff.InnerText = "0 %"        'Added by Gagan Kalyana on 2016-Apr-04
            _get_drawing_chart()
        Else
            Dim strError As String = ReadWriteXml.getAppResource("5001").ToString
            ScriptManager.RegisterStartupScript(Me, [GetType](), strError, "Showalert();", True)
            lb_working_day_1.Focus()
        End If
    End Sub
    '[11] Commented and Added by Gagan Kalyana on 2015-Feb-19[End]
    
    Private Sub _get_over_time(ByVal factory As String, ByVal section As String, ByVal line As String, ByVal work_dt As String, ByVal shift As String)
        Dim db As New Database
        Dim rd As SqlDataReader
        Dim temp As Double = 0.0
        db.conecDB()
        db.initCMD()
        Dim sql As String
        sql = "select a.start_time ,a.end_time,a.duration_time "
        sql = sql & "from Shift_time_data as a "
        sql = sql & "where a.factory_c='" & factory & "' and a.section_c='" & section & "' and a.work_date='" & work_dt & "' and a.line_c='" & line & "' and a.shift_c='" & shift & "' and a.time_c='ST08' "
        rd = db.execReader(sql)
        If rd.Read() Then
            If rd("duration_time") > 0 Then
                temp = CDbl(rd("duration_time")) / 60
            End If
        End If
        db.closeDB()
        rd.Close()
        '[6] Commented and Added By Gagan Kalyana on 2016-Feb-18
        'lb_over_time.Text = temp.ToString("##,###0.00")
        'lb_over_time.Text = Int(temp).ToString + "." + Right("0" + Math.Round(60 * (temp - Int(temp)), 0).ToString(), 2)        Modified by Gagan Kalyana on 2016-Apr-04 
        lb_over_time.Text = Int(temp).ToString + ":" + Right("0" + Math.Round(60 * (temp - Int(temp)), 0).ToString(), 2)
    End Sub
    
    
    Private Sub _get_line_information(ByVal factory As String, ByVal section As String, ByVal line As String, ByVal work_dt As String, ByVal shift As String)
        Dim db As New Database
        Dim rd As SqlDataReader
        Dim tact_time_tg As Double
        db.conecDB()
        db.initCMD()
        Dim sql As String
 
        ''Commented and Modified by SIS on 2016-Apr-07 START

        'sql = "select top 1 a.section_c,a.line_c,c.line_nm,b.proty_tg as proty_taget,a.shift_c,a.work_date, "
        'sql = sql & "worker_name_1 =(select top 1 user_nm from user_mst where user_c=b.worker_c1), "
        'sql = sql & "worker_name_2 =(select top 1 user_nm from user_mst where user_c=b.worker_c2), "
        'sql = sql & "worker_name_3 =(select top 1 user_nm from user_mst where user_c=b.worker_c3), "
        'sql = sql & "convert(nvarchar(19),a.upd_dt,108) as upd_dt,b.qty_pl,b.tact_time,b.cycle_time,b.memo_dt, "
        'sql = sql & "b.smh_sh,b.amh_sh,b.effic_st_di as effic_st,b.effic_st_in as effic_act,b.ahour_pl,b.shour_pl,c.downtime_pl as downtime_ratio_pl, "
        ''[FC] Commented and Modified by Govind on 2015-Mar-19
        ''sql = sql & "downtime_pl=(select sum(duration_pl) from lineshift_downtime_pl where section_c=a.section_c and line_c=a.line_c and shift_c=a.shift_c and work_date=a.work_date group by section_c,line_c,work_date), "
        'sql = sql & "downtime_pl=(select sum(duration_pl) from lineshift_downtime_pl where section_c=a.section_c and line_c=a.line_c and shift_c=a.shift_c and work_date=a.work_date and Factory_c = a.Factory_c group by section_c,line_c,work_date), "
        'sql = sql & "b.diman_act,spare=(f.man_act),leader=(e.man_act),b.inman_act,(b.diman_act+0+b.inman_act) as total_act,(b.diman_pl+0+b.inman_pl) as total_pl "
        'sql = sql & "from Shift_time_data as a "
        'sql = sql & "join line_data as b on a.section_c=b.section_c and a.line_c=b.line_c and a.shift_c=b.shift_c and a.work_date=b.work_date "
        'sql = sql & "and a.Factory_c = b.Factory_c " '[FC] Added by Govind on 2015-Mar-19
        'sql = sql & "join line_mst as c on a.section_c=c.section_c and a.line_c=c.line_c "
        'sql = sql & "and a.Factory_c = c.Factory_c " '[FC] Added by Govind on 2015-Mar-19"
        'sql = sql & "join lineman_data as d on a.section_c=d.section_c and  a.line_c=d.line_c and a.shift_c=d.shift_c and a.work_date=d.work_date and d.data_c='MAS09' "
        'sql = sql & "and a.Factory_c = d.Factory_c " '[FC] Added by Govind on 2015-Mar-19
        'sql = sql & "join lineman_data as e on a.section_c=e.section_c and  a.line_c=e.line_c and a.shift_c=e.shift_c and a.work_date=e.work_date and e.data_c='MAS11' "
        'sql = sql & "and a.Factory_c = e.Factory_c " '[FC] Added by Govind on 2015-Mar-19
        'sql = sql & "join lineman_data as f on a.section_c=f.section_c and  a.line_c=f.line_c and a.shift_c=f.shift_c and a.work_date=f.work_date and f.data_c='MAS12' "
        'sql = sql & "and a.Factory_c = f.Factory_c " '[FC] Added by Govind on 2015-Mar-19
        'sql = sql & "where a.factory_c='" & factory & "' and a.section_c='" & section & "' and a.line_c='" & line & "' and a.work_date='" & work_dt & "' and a.shift_c='" & shift & "' "
        'sql = sql & "order by a.work_date desc,a.ent_dt desc "

        sql = "select top 1 a.section_c,a.line_c,c.line_nm,b.proty_tg as proty_taget,a.shift_c,a.work_date, "
        sql = sql & "worker_name_1 =(select top 1 user_nm from user_mst where user_c=b.worker_c1), "
        sql = sql & "worker_name_2 =(select top 1 user_nm from user_mst where user_c=b.worker_c2), "
        sql = sql & "worker_name_3 =(select top 1 user_nm from user_mst where user_c=b.worker_c3), "
        sql = sql & "convert(nvarchar(19),a.upd_dt,108) as upd_dt,b.qty_pl,b.tact_time,b.cycle_time,b.memo_dt, "
        sql = sql & "b.smh_sh,b.amh_sh,b.effic_st_di as effic_st,b.effic_st_in as effic_act,b.ahour_pl,b.shour_pl,c.downtime_pl as downtime_ratio_pl, "
        sql = sql & "downtime_pl=(select sum(duration_pl) from lineshift_downtime_pl where section_c=a.section_c and line_c=a.line_c and shift_c=a.shift_c and work_date=a.work_date and Factory_c = a.Factory_c group by section_c,line_c,work_date), "
        sql = sql & "b.diman_act,b.inman_act,(b.diman_act+0+b.inman_act) as total_act,(b.diman_pl+0+b.inman_pl) as total_pl "
        sql = sql & "from Shift_time_data as a "
        sql = sql & "join line_data as b on a.section_c=b.section_c and a.line_c=b.line_c and a.shift_c=b.shift_c and a.work_date=b.work_date "
        sql = sql & "and a.Factory_c = b.Factory_c "
        sql = sql & "join line_mst as c on a.section_c=c.section_c and a.line_c=c.line_c "
        sql = sql & "and a.Factory_c = c.Factory_c "
         sql = sql & "where a.factory_c='" & factory & "' and a.section_c='" & section & "' and a.line_c='" & line & "' and a.work_date='" & work_dt & "' and a.shift_c='" & shift & "' "
        sql = sql & "order by a.work_date desc,a.ent_dt desc "
 
        ''Commented and Modified by SIS on 2016-Apr-07 END

        rd = db.execReader(sql)
        While rd.Read()
            lb_section.Text = rd("section_c").ToString
            lb_line_no.Text = rd("line_c").ToString
            'lb_shift.Text = rd("shift_c").ToString                                     '[11] Commented and Added by Gagan Kalyana on 2016-Feb-18
            lb_line_name.Text = rd("line_nm").ToString
            lb_working_day.Text = rd("work_date").ToString
            lb_note.Text = rd("memo_dt").ToString
            Dim myDate As Date = rd("work_date")
            lb_working_day_1.Text = Left(myDate.ToString("dd/MM/yyyy"), 10)
            lb_leader.Text = rd("worker_name_2").ToString
            lb_sub_leader.Text = rd("worker_name_3").ToString
            lb_sv.Text = rd("worker_name_1").ToString
            lb_upd_dt.Text = rd("upd_dt").ToString
            lb_qty_pl.Text = rd("qty_pl").ToString
            If IsDBNull(rd("tact_time")) = False Then
                lb_tact_time.Text = CDbl(rd("tact_time")).ToString("##,###0.0")
                tact_time_tg = CDbl(rd("tact_time"))
            End If
            If IsDBNull(rd("smh_sh")) = False Then
                lb_smh.Text = CDbl(rd("smh_sh")).ToString("##,###0.0")
            End If
            If IsDBNull(rd("amh_sh")) = False Then
                lb_amh.Text = CDbl(rd("amh_sh")).ToString("##,###0.0")
            End If
            If IsDBNull(rd("proty_taget")) = False Then
                lb_proty_taget.Text = CDbl(rd("proty_taget")).ToString("##,###0.0") & "%"
            End If
            If IsDBNull(rd("ahour_pl")) = False Then
                '[6] Commented and Added By Gagan Kalyana on 2016-Feb-18 [Start]
                'lb_hour_act.Text = CDbl(rd("ahour_pl")).ToString("##,###0.00")
                _dblWorking_hours_act = CDbl(rd("ahour_pl")).ToString("##,###0.00")
                'lb_hour_act.Text = Int(_dblWorking_hours_act).ToString + "." + RIGHT("0" + Math.Round(60 * (_dblWorking_hours_act - Int(_dblWorking_hours_act)), 0).ToString(), 2)          Modified by Gagan Kalyana on 2016-Apr-04
                lb_hour_act.Text = Int(_dblWorking_hours_act).ToString + ":" + RIGHT("0" + Math.Round(60 * (_dblWorking_hours_act - Int(_dblWorking_hours_act)), 0).ToString(), 2)
                '[6] Commented and Added By Gagan Kalyana on 2016-Feb-18 [End]
            End If
            If IsDBNull(rd("downtime_ratio_pl")) = False Then
                lb_downtime_ratio.Text = CDbl(rd("downtime_ratio_pl")).ToString("##,###0.0")
            End If
            If IsDBNull(rd("shour_pl")) = False Then
                '[6] Commented and Added By Gagan Kalyana on 2016-Feb-18
                'lb_break.Text = CDbl(rd("shour_pl")).ToString("##,###0.00")
                'lb_break.Text = Int(rd("shour_pl")).ToString + "." + Right("0" + Math.Round(60 * (rd("shour_pl") - Int(rd("shour_pl"))), 0).ToString(), 2)     Modified by Gagan Kalyana on 2016-Apr-04
                lb_break.Text = Int(rd("shour_pl")).ToString + ":" + RIGHT("0" + Math.Round(60 * (rd("shour_pl") - Int(rd("shour_pl"))), 0).ToString(), 2)
            End If
            If IsDBNull(rd("downtime_pl")) = False Then
                '[6] Commented and Added By Gagan Kalyana on 2016-Feb-18 [Start]
                Dim dtpl As Double = System.Math.Round(rd("downtime_pl") / 60, 3)
                'lb_downtime_pl.Text = dtpl.ToString("##,###0.00")
                'lb_downtime_pl.Text = Int(dtpl).ToString + "." + Right("0" + Math.Round(60 * (dtpl - Int(dtpl)), 0).ToString(), 2)          Modified by Gagan Kalyana on 2016-Apr-04 
                lb_downtime_pl.Text = Int(dtpl).ToString + ":" + Right("0" + Math.Round(60 * (dtpl - Int(dtpl)), 0).ToString(), 2)          
                '[6] Commented and Added By Gagan Kalyana on 2016-Feb-18 [End]
            Else
                'lb_downtime_pl.Text = "0.00"            Modified by Gagan Kalyana on 2016-Apr-04 
                lb_downtime_pl.Text = "0:00"
            End If
           
            ''Commented and Modified by SIS on 2016-Apr-07 START
            
            'If IsDBNull(rd("diman_act")) = False And IsDBNull(rd("leader")) = False Then
            '    lb_worker.Text = (CDbl(rd("diman_act")) - CDbl(rd("leader"))).ToString("##,###0.0")
            'End If

            'If IsDBNull(rd("leader")) = False Then
            '    lb_leader_1.Text = CDbl(rd("leader")).ToString("##,###0.0")
            'End If
            'If IsDBNull(rd("spare")) = False Then
            '    lb_inman.Text = CDbl(rd("spare")).ToString("##,###0.0")
            'End If

            'If IsDBNull(rd("total_act")) = False Then
            '    lb_total_men.Text = CDbl(rd("total_act")).ToString("##,###0.0")
            'End If
            
            'If IsDBNull(rd("total_pl")) = False Then
            '    If rd("total_pl") <> 0 Then
            '        lb_per_men.Text = CDbl(System.Math.Round((rd("total_act") / rd("total_pl")) * 100, 1)).ToString("##,###0.0")
            '    End If
            'End If
            
            If IsDBNull(rd("diman_act")) = False Then
                lb_worker.Text = CDbl(rd("diman_act")).ToString("##,###0.0")
            End If

            If IsDBNull(rd("inman_act")) = False Then
                lb_leader_1.Text = CDbl(rd("inman_act")).ToString("##,###0.0")
            End If
            
            If IsDBNull(rd("total_act")) = False Then
                lb_total_men.Text = CDbl(rd("total_act")).ToString("##,###0.0")
            End If

            ''Commented and Modified by SIS on 2016-Apr-07 END

            If IsDBNull(rd("diman_act")) = False Then
                _direct = rd("diman_act")
            End If
            If IsDBNull(rd("total_act")) = False Then
                _indirect = rd("total_act")
            End If

            ''Commented and Modified by SIS on 2016-Apr-07 START
            
            '_dman = _indirect
            _dman = _direct
            
            If IsDBNull(rd("effic_st")) = False Then
                lb_effic_st.Text = CDbl(rd("effic_st")).ToString("##,###0.0")
                tact_time_tg = tact_time_tg * CDbl(rd("effic_st"))
            End If
            If IsDBNull(rd("effic_act")) = False Then
                lb_effic_at.Text = CDbl(rd("effic_act")).ToString("##,###0.0")
            End If
            If IsDBNull(rd("proty_taget")) = False Then
                _target = CDbl(rd("proty_taget")).ToString("##,###0.0")
                tact_time_tg = tact_time_tg / CDbl(rd("proty_taget"))
            End If
            If tact_time_tg > 0 Then
                lb_cycle_time.Text = tact_time_tg.ToString("##,###0.0")
            Else
                lb_cycle_time.Text = "0.0"
            End If
            
        End While
        db.closeDB()
        rd.Close()
    End Sub
    
    Private Sub _get_drawing_chart()
        Dim sql As String = ""
        Dim db As New Database
        Dim rd As SqlDataReader
        Dim _factory_c As String = "00000"
        Dim _section_c As String = "ASY1  "
        Dim _line_c As String = "TVF1"
        Dim _work_date As String = "5/14/2013 12:00:00 AM"
        Dim _shift_c As String = "2"

        Dim _ahour_pl As Double = 6.42
        Dim _cycle_act As Double = 153.68
        Dim _tact_act As Double = 100.01
        Dim _dm As Double = 27.0
        Dim _step As Double = 0.0

        _factory_c = Request("factory")
        _section_c = lb_section.Text
        _work_date = Format$(CDate(lb_working_day.Text), "yyyy-MM-dd")
        _line_c = lb_line_no.Text
        '_shift_c = lb_shift.Text        [11] Commented and Added by Gagan Kalyana on 2016-Feb-18
        _shift_c = hdshift_C.Value

        '[6] Commented and Added By Gagan Kalyana on 2016-Feb-18 [Start]
        'If lb_hour_act.Text <> Nothing And lb_hour_act.Text <> "" Then
        '    _ahour_pl = CDbl(lb_hour_act.Text)
        'End If
        If _dblWorking_hours_act <> Nothing And _dblWorking_hours_act <> 0.0 Then
            _ahour_pl = _dblWorking_hours_act
        End If
        '[6] Commented and Added By Gagan Kalyana on 2016-Feb-18 [End]
          
        If lb_cycle_time.Text <> Nothing And lb_cycle_time.Text <> "" Then
            _cycle_act = CDbl(lb_cycle_time.Text)
        End If
        If lb_tact_time.Text <> Nothing And lb_tact_time.Text <> "" Then
            _tact_act = CDbl(lb_tact_time.Text)
        End If
        If _dman > 0 Then
            _dm = _dman
        End If
        
        Dim _shift_begin As DateTime
        Dim _shift_st As DateTime
        Dim _shift_end As DateTime  'Added by Gagan Kalyana on 2015-Apr-27

        Dim _shift_date(100, 2) As DateTime
        Dim i1 As Integer = 0

        Dim _xA(500, 2) As String
        Dim _aC As Double = 0.0
        Dim _xTemq(500, 2) As String
        Dim _tC As Double = 0.0

        Dim _xZ(500, 2) As String
        Dim _zC As Double = 0.0

        Dim _xU(500, 2) As String
        Dim _uC As Double = 0.0

        Dim _xY(500, 2) As String
        Dim _yC As Double = 0.0
        Dim _y As Integer = 0

        Dim _date_temp(1, 2) As DateTime
        Dim i As Integer = 0
        Dim j As Integer = 0
        Dim k As Integer = 0


        sql = "select a.start_time,a.end_time,a.time_c from Shift_time_data as a where "
        sql = sql & "a.factory_c='" & _factory_c & "' and a.section_c='" & _section_c & "' and  a.line_c='" & _line_c & "' and a.work_date='" & _work_date & "'  and a.shift_c='" & _shift_c & "' "
       
        db.conecDB()
        db.initCMD()
        rd = db.execReader(sql)
        While rd.Read()
            Dim temp1 As DateTime = rd("start_time")
            Dim temp2 As DateTime = rd("end_time")
            Dim temp3 As String = rd("time_c")
            If (temp1 <> "1900-01-01 00:00:00.000") And (temp2 <> "1900-01-01 00:00:00.000") And (temp3 = "ST01") Then
                _shift_st = temp1
                _shift_date(i1, 0) = rd("end_time")
                _shift_date(i1, 1) = rd("end_time")
                i1 = i1 + 1
            End If
            If (temp1 <> "1900-01-01 00:00:00.000") And (temp2 <> "1900-01-01 00:00:00.000") And (temp3 <> "ST01") And (temp3 <> "ST08") Then
                If DateDiff(DateInterval.Minute, rd("start_time"), rd("end_time")) > 0 Then
                    _shift_date(i1, 0) = rd("start_time")
                    _shift_date(i1, 1) = rd("end_time")
                    i1 = i1 + 1
                End If
            End If
            If (temp1 <> "1900-01-01 00:00:00.000") And (temp2 <> "1900-01-01 00:00:00.000") And (temp3 = "ST08") Then
                If DateDiff(DateInterval.Minute, rd("start_time"), rd("end_time")) > 0 Then
                    _shift_date(i1, 0) = rd("end_time")
                    _shift_date(i1, 1) = rd("end_time")
                    i1 = i1 + 1
                End If
            End If
        End While
        db.closeDB()
        rd.Close()

        sql = "select a.stop_pl_st,a.stop_pl_en from LineShift_downtime_pl as a where "
        sql = sql & "a.factory_c='" & _factory_c & "'  and a.section_c='" & _section_c & "' and  a.work_date='" & _work_date & "' and a.line_c='" & _line_c & "' and a.shift_c='" & _shift_c & "'  "
        db.conecDB()
        db.initCMD()
        rd = db.execReader(sql)
        While rd.Read()
            _shift_date(i1, 0) = rd("stop_pl_st")
            _shift_date(i1, 1) = rd("stop_pl_en")
            i1 = i1 + 1
        End While
        db.closeDB()
        rd.Close()

        'Array.Sort _shift_date       
        For i = 0 To 10
            For j = 0 To 10
                If _shift_date(i, 0) > _shift_date(j, 0) Then
                    _date_temp(0, 0) = _shift_date(i, 0)
                    _date_temp(0, 1) = _shift_date(i, 1)
                    _shift_date(i, 0) = _shift_date(j, 0)
                    _shift_date(i, 1) = _shift_date(j, 1)
                    _shift_date(j, 0) = _date_temp(0, 0)
                    _shift_date(j, 1) = _date_temp(0, 1)
                End If
            Next
        Next
        'For i = i1 - 1 To 0 Step -1
        '    Response.Write(_shift_date(i, 0) & ":" & _shift_date(i, 1) & "__")
        'Next

        If i1 - 1 > 0 Then
            If _shift_st > _shift_date(i1 - 1, 0) Then
                _shift_st = _shift_date(i1 - 1, 0)
            End If
        Else
            Exit Sub
        End If

        'Chart for Tact Time Target                       
        If _cycle_act > 0 Then
            _step = System.Math.Round((_cycle_act / 60), 2)
        End If
        If _step = 0 Then
            Exit Sub
        End If
        j = 0
        _shift_begin = _shift_st
        
        ''[10] Added by Gagan Kalyana on 2016-Feb-18[Start]
        'Dim duration As TimeSpan = DateTime.Now - _shift_begin
        'dblOpr_time = (DateTime.Now - _shift_begin).Hours.ToString("00") + CDbl((duration.Minutes / 6000) * 100).ToString(".00")
        ''lblRealEff.InnerText = CDbl(CDbl(_actualCount) * (smh / (dblOpr_time * 3600)) * CDbl(lb_worker.Text).ToString("##.00")).ToString("###.000000")
        'lblRealEff.InnerText = (DateTime.Now - _shift_begin).Hours.ToString("00") + CDbl((duration.Minutes / 6000) * 100).ToString(".00")
        ''[10] Added by Gagan Kalyana on 2016-Feb-18[End]
        
        For i = i1 - 1 To 0 Step -1
            If j = 0 Then
                While _shift_begin < _shift_date(i, 0)
                    _xU(j, 0) = _shift_begin
                    _uC = _uC + System.Math.Round(5 / _step, 3)
                    _shift_begin = _shift_begin.AddMinutes(5)
                    _xU(j, 1) = _uC
                    j = j + 1
                End While
                While (_shift_begin >= _shift_date(i, 0)) And (_shift_begin <= _shift_date(i, 1))
                    _xU(j, 0) = _shift_begin
                    _xU(j, 1) = _uC
                    _shift_begin = _shift_begin.AddMinutes(5)
                    j = j + 1
                End While
            Else
                While _shift_begin <= _shift_date(i, 0)
                    _xU(j, 0) = _shift_begin
                    _uC = _uC + System.Math.Round(5 / _step, 3)
                    _shift_begin = _shift_begin.AddMinutes(5)
                    _xU(j, 1) = _uC
                    j = j + 1
                End While
                While (_shift_begin > _shift_date(i, 0)) And (_shift_begin <= _shift_date(i, 1))
                    _xU(j, 0) = _shift_begin
                    _xU(j, 1) = _uC
                    _shift_begin = _shift_begin.AddMinutes(5)
                    j = j + 1
                End While
            End If
        Next
        
        ''''''''''''''''''''''''''CHART'''''''''''''''''''''''''''''''
        Dim axis As Integer = 5
        If j - 1 > 50 Then
            axis = 10
        End If
        Dim yaxis = 30
        If _uC >= 300 And _uC <= 500 Then
            yaxis = 50
        End If
        If _uC > 500 And _uC < 1000 Then
            yaxis = 70
        End If
        If _uC >= 1000 And _uC < 1300 Then
            yaxis = 90
        End If
        If _uC >= 1300 Then
            yaxis = 200
        End If
        Chart1.ChartAreas(0).AxisY.Interval = yaxis
        Chart1.ChartAreas(0).AxisX.Interval = axis
        Chart1.ChartAreas(0).AxisX.LineColor = Drawing.Color.Orange
        Chart1.ChartAreas(0).AxisY.LineColor = Drawing.Color.Orange
        Chart1.Legends(0).IsDockedInsideChartArea = False
        Chart1.Legends(0).Docking = Docking.Top
        Chart1.ChartAreas(0).AxisX.MajorGrid.LineDashStyle = ChartDashStyle.Dot
        Chart1.ChartAreas(0).AxisX.MajorGrid.LineColor = Drawing.Color.White
        Chart1.ChartAreas(0).AxisY.MajorGrid.LineDashStyle = ChartDashStyle.Dot
        Chart1.ChartAreas(0).AxisY.MajorGrid.LineColor = Drawing.Color.White
        Dim FontName As String = "Tahoma"
        Dim FontSize As Integer = 9
        Dim FS As New Drawing.Font(FontName, FontSize, Drawing.FontStyle.Regular)
        Chart1.ChartAreas(0).AxisX.LabelStyle.Font = FS
        Chart1.ChartAreas(0).AxisX.LabelStyle.ForeColor = Drawing.Color.White
        Chart1.ChartAreas(0).AxisY.LabelStyle.Font = FS
        Chart1.ChartAreas(0).AxisY.LabelStyle.ForeColor = Drawing.Color.White
        
        'Commented by Gagan Kalyana on 2015-May-15[Start]
        ''Added by Gagan Kalyana on 2015-Apr-06[Start]
        'Dim _CurrentDateTime As DateTime = _shift_st.ToShortDateString + " " + DateTime.Now.ToShortTimeString
        'For i = 0 To j - 1
        '    Dim _value As DateTime = _xU(i, 0)
        '    Dim result As Integer = DateTime.Compare(_value, _CurrentDateTime)
        '    If result < 0 Then
        '        _BaseonTargetofline = _xU(i, 1).ToString
        '    End If
        'Next
        ''Added by Gagan Kalyana on 2015-Apr-06[End]
        'Commented by Gagan Kalyana on 2015-May-15[End]
        
        ''[5] Commented by Govind on 2015-Mar-19 [Start]
        'Dim u As New Series
        'u.Name = "Base on Target of line"
        'u.XValueType = ChartValueType.String
        'u.ChartType = SeriesChartType.Line
        'u.BorderWidth = 2
        'u.Color = Drawing.Color.Red
        'For i = 0 To j - 1
        '    Dim _value As DateTime = _xU(i, 0)
        '    u.Points.AddXY(_value.ToShortTimeString, _xU(i, 1).ToString)
        '    If (i = j - 1) Then
        '        Dim _fontname As String = "Arial"
        '        Dim _fontsize As Integer = 10
        '        Dim _font As New Drawing.Font(_fontname, _fontsize, Drawing.FontStyle.Regular)
        '        u.Points(i).Font = _font
        '        u.Points(i).LabelForeColor = Drawing.Color.Red
        '        Dim __value As Double = _xU(i, 1)
        '        u.Points(i).Label = __value.ToString("##,###0.0")
        '    End If
        'Next
        'Chart1.Series.Add(u)
        
        ''Chart for Tact Time            
        'If _tact_act > 0 Then
        '    _step = System.Math.Round((_tact_act / 60), 2)
        'End If
        'If _step = 0 Then
        '    Exit Sub
        'End If

        'j = 0
        '_shift_begin = _shift_st

        'For i = i1 - 1 To 0 Step -1
        '    If j = 0 Then
        '        While _shift_begin < _shift_date(i, 0)
        '            _xZ(j, 0) = _shift_begin
        '            _zC = _zC + System.Math.Round(5 / _step, 3)
        '            _shift_begin = _shift_begin.AddMinutes(5)
        '            _xZ(j, 1) = _zC
        '            j = j + 1
        '        End While
        '        While (_shift_begin >= _shift_date(i, 0)) And (_shift_begin <= _shift_date(i, 1))
        '            _xZ(j, 0) = _shift_begin
        '            _xZ(j, 1) = _zC
        '            _shift_begin = _shift_begin.AddMinutes(5)
        '            j = j + 1
        '        End While
        '    Else
        '        While _shift_begin <= _shift_date(i, 0)
        '            _xZ(j, 0) = _shift_begin
        '            _zC = _zC + System.Math.Round(5 / _step, 3)
        '            _shift_begin = _shift_begin.AddMinutes(5)
        '            _xZ(j, 1) = _zC
        '            j = j + 1
        '        End While
        '        While (_shift_begin > _shift_date(i, 0)) And (_shift_begin <= _shift_date(i, 1))
        '            _xZ(j, 0) = _shift_begin
        '            _xZ(j, 1) = _zC
        '            _shift_begin = _shift_begin.AddMinutes(5)
        '            j = j + 1
        '        End While
        '    End If
        'Next

        'Dim z As New Series
        'z.Name = "Production Plan & Tact Time"
        'z.XValueType = ChartValueType.String
        'z.ChartType = SeriesChartType.Line
        'z.BorderWidth = 2
        'z.Color = Drawing.Color.PaleGreen
        'For i = 0 To j - 1
        '    Dim _value As DateTime = _xZ(i, 0)
        '    z.Points.AddXY(_value.ToShortTimeString, _xZ(i, 1).ToString)
        '    If (i = j - 1) Then
        '        Dim _fontname As String = "Arial"
        '        Dim _fontsize As Integer = 10
        '        Dim _font As New Drawing.Font(_fontname, _fontsize, Drawing.FontStyle.Regular)
        '        z.Points(i).Font = _font
        '        z.Points(i).LabelForeColor = Drawing.Color.PaleGreen
        '        Dim __value As Double = _xZ(i, 1)
        '        z.Points(i).Label = __value.ToString("##,###0.0")
        '    End If
        'Next
        'Chart1.Series.Add(z)
        ''[5] Commented by Govind on 2015-Mar-19 [End]

        'Chart for Production plan
        sql = "select  a.product_no,b.short_c,round((b.smh_sub+smh_asy)/3600,6) as smh,a.proty_pl,a.plan_qty "
        sql = sql & "from production_plan as a "
        sql = sql & "join  product_mst as b on a.product_no=b.product_no and a.cusdesch_c1=b.cusdesch_c1 and a.cusdesch_c2=b.cusdesch_c2 and a.intdesch_c=b.intdesch_c  "
        sql = sql & "and a.Factory_c = b.Factory_c " '[FC] Added by Govind on 2015-Mar-19
        sql = sql & "where a.factory_c='" & _factory_c & "'  and a.section_c='" & _section_c & "' and a.line_c='" & _line_c & "' and a.shift_c='" & _shift_c & "' and a.work_date='" & _work_date & "' and a.plan_qty>0  "
        sql = sql & "order by a.priority asc "

        db.conecDB()
        db.initCMD()
        Dim __step(100, 2) As Double
       
        Dim n As Integer = 0
        Dim temp As Double = 0.0
        Dim temp_q As Double = 0.0
        j = 0
        _shift_begin = _shift_st

        For i = 0 To 100
            __step(i, 0) = 0
            __step(i, 1) = 0
        Next

        rd = db.execReader(sql)
        While rd.Read()
            If IsDBNull(rd("plan_qty")) = False Then
                temp_q = temp_q + rd("plan_qty")
            End If
            __step(n, 0) = temp_q
            If IsDBNull(rd("smh")) = False Then
                temp = (rd("smh") / _dm)
                temp = temp / (rd("proty_pl") / 100)
                temp = System.Math.Round((temp * 60), 6)
            End If
            __step(n, 1) = temp
            n = n + 1
        End While
        db.closeDB()
        rd.Close()

        If __step(0, 1) = 0 Then
            Exit Sub
        Else
            _step = __step(0, 1)
        End If


        For i = i1 - 1 To 0 Step -1
            If j = 0 Then
                While _shift_begin < _shift_date(i, 0)
                    _yC = _yC + System.Math.Round(5 / _step, 3)
                    If _yC > temp_q Then
                        Exit While
                    End If
                    For k = 0 To n
                        If _yC <= __step(k, 0) Then
                            _step = __step(k, 1)
                            Exit For
                        End If
                    Next
                    _xY(j, 0) = _shift_begin
                    _shift_begin = _shift_begin.AddMinutes(5)
                    _xY(j, 1) = _yC
                    j = j + 1
                End While
                While (_shift_begin >= _shift_date(i, 0)) And (_shift_begin <= _shift_date(i, 1))
                    _xY(j, 0) = _shift_begin
                    _xY(j, 1) = _yC
                    _shift_begin = _shift_begin.AddMinutes(5)
                    j = j + 1
                End While
            Else
                While _shift_begin <= _shift_date(i, 0)
                    _yC = _yC + System.Math.Round(5 / _step, 3)
                    For k = 0 To n
                        If _yC <= __step(k, 0) Then
                            _step = __step(k, 1)
                            Exit For
                        End If
                    Next
                    _xY(j, 0) = _shift_begin
                    _shift_begin = _shift_begin.AddMinutes(5)
                    _xY(j, 1) = _yC
                    j = j + 1
                End While
                While (_shift_begin > _shift_date(i, 0)) And (_shift_begin <= _shift_date(i, 1))
                    _xY(j, 0) = _shift_begin
                    _xY(j, 1) = _yC
                    _shift_begin = _shift_begin.AddMinutes(5)
                    j = j + 1
                End While
            End If
        Next
        'Added by Gagan Kalyana on 2015-May-15[Start]
        _BaseonTargetofline = temp_q
        
        Dim _CurrentDateTime As DateTime = _shift_st.ToShortDateString + " " + DateTime.Now.ToShortTimeString
        For i = 0 To j - 1
            Dim _value As DateTime = _xY(i, 0)
            Dim result As Integer = DateTime.Compare(_value, _CurrentDateTime)
            If result < 0 Then
                _BaseonTargetofline = _xY(i, 1).ToString
                
                If _xY(i, 1) >= temp_q Then
                    Exit For
                End If
            End If
        Next
        'Added by Gagan Kalyana on 2015-May-15[End]
        Dim x As New Series
        x.Name = ReadWriteXml.getAppResource("1195").ToString()
        x.XValueType = ChartValueType.String
        x.ChartType = SeriesChartType.Line
        x.BorderWidth = 2
        x.Color = Drawing.Color.Orange

        For i = 0 To j - 1
            Dim _value As DateTime = _xY(i, 0)
            _shift_end = _value ' Added By Gagan Kalyana on 2015-Apr-27
            x.Points.AddXY(_value.ToShortTimeString, _xY(i, 1).ToString)
            If _xY(i, 1) >= temp_q Then
                Dim _fontname As String = "Arial"
                Dim _fontsize As Integer = 10
                Dim _font As New Drawing.Font(_fontname, _fontsize, Drawing.FontStyle.Regular)
                x.Points(i).Font = _font
                x.Points(i).LabelForeColor = Drawing.Color.Orange
                Dim __value As Double = _xY(i, 1)
                'x.Points(i).Label = __value.ToString("##,###0")
                x.Points(i).Label = temp_q

                Exit For
            Else
                If (i = j - 1) Then
                    Dim _fontname As String = "Arial"
                    Dim _fontsize As Integer = 10
                    Dim _font As New Drawing.Font(_fontname, _fontsize, Drawing.FontStyle.Regular)
                    x.Points(i).Font = _font
                    x.Points(i).LabelForeColor = Drawing.Color.Orange
                    Dim __value As Double = _xY(i, 1)
                    x.Points(i).Label = __value.ToString("##,###0")
                End If
            End If
        Next
        Chart1.Series.Add(x)

        ' Added By Gagan Kalyana on 2015-Apr-14 [Start] 
        
        '[5] Commented and added by Gagan Kalyana on 2016-Feb-18 [Start]
        'Dim obj As New FunctionControl
        'Dim strDownTime As String = ""
        'If obj.getValue("Down_Time", "1").Flag = True Then
        '    strDownTime = obj.getValue("Down_Time", "1").Value
        'End If
        'If strDownTime.Trim = "" Or IsNumeric(strDownTime) = False Then strDownTime = "0"
        'Dim iDownTimePer As Int16 = Convert.ToInt16(strDownTime)
        
        strSql = "SELECT ISNULL(Param_Val, 0) FROM DicData_mst WHERE Data_C = 'P0101';"
        dataSet.Tables.Clear()
        dataAdapter = New SqlDataAdapter(strSql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
        dataAdapter.Fill(dataSet)
    
        If dataSet.Tables(0).Rows.Count > 0 Then
            dblJudgementRate = Convert.ToInt16(dataSet.Tables(0).Rows(0)(0))
        End If
        Dim iDownTimePer As Int16 = dblJudgementRate
        '[5] Commented and added by Gagan Kalyana on 2016-Feb-18  [End] 
        
        If iDownTimePer > 0 Then
            Dim ProdQty As New Series
            ProdQty.Name = ReadWriteXml.getAppResource("1195").ToString() + "(" + iDownTimePer.ToString + " %)"
            ProdQty.XValueType = ChartValueType.String
            ProdQty.ChartType = SeriesChartType.Line
            ProdQty.BorderWidth = 2
            ProdQty.Color = Drawing.Color.Yellow
            
            For i = 0 To j - 1
                Dim _value As DateTime = _xY(i, 0)
                Dim dblCurrentProdQty As Double = Convert.ToDouble(_xY(i, 1)) * (1 - iDownTimePer / 100)
                ProdQty.Points.AddXY(_value.ToShortTimeString, dblCurrentProdQty.ToString)
                If _xY(i, 1) >= temp_q Then
                    Dim _fontname As String = "Arial"
                    Dim _fontsize As Integer = 10
                    Dim _font As New Drawing.Font(_fontname, _fontsize, Drawing.FontStyle.Regular)
                    ProdQty.Points(i).Font = _font
                    ProdQty.Points(i).LabelForeColor = Drawing.Color.Yellow
                    dblCurrentProdQty = Convert.ToDouble(temp_q) * (1 - iDownTimePer / 100)
                    ProdQty.Points(i).Label = dblCurrentProdQty.ToString("##,###0")
                    Exit For
                Else
                    If (i = j - 1) Then
                        Dim _fontname As String = "Arial"
                        Dim _fontsize As Integer = 10
                        Dim _font As New Drawing.Font(_fontname, _fontsize, Drawing.FontStyle.Regular)
                        ProdQty.Points(i).Font = _font
                        ProdQty.Points(i).LabelForeColor = Drawing.Color.Yellow
                        ProdQty.Points(i).Label = dblCurrentProdQty.ToString("##,###0")
                    End If
                End If
            Next
            Chart1.Series.Add(ProdQty)
        End If
        ' Added By Gagan Kalyana on 2015-Apr-07 [End]
        
        'Get data actual from acs system
        sql = "select count(*) as total "
        sql = sql & "from ACS_insp_res as a "
        sql = sql & "where a.factory_c='" & _factory_c & "' and a.line_c='" & _line_c & "' and a.shift='" & _shift_c & "' and a.shift_st_dt='" & _work_date & "' "
        sql = sql & "and a.section_c='" & _section_c & "'"  '[FC] Added by Govind on 2015-Mar-19

        Dim _count As Integer = 0
        db.conecDB()
        db.initCMD()
        rd = db.execReader(sql)
        If rd.Read() Then
            If IsDBNull(rd("total")) = False Then
                _count = Convert.ToInt32(rd("total"))
                _actualCount = _count
            End If
        End If
        db.closeDB()
        rd.Close()

        If _count = 0 Then
            Exit Sub
        End If

        ReDim _xA(_count, 2)

        sql = "select DATEADD(dd,0,a.ent_dt) as ent_dt "
        sql = sql & "from ACS_insp_res as a "
        sql = sql & "where a.factory_c='" & _factory_c & "' and a.line_c='" & _line_c & "' and a.shift='" & _shift_c & "' and a.shift_st_dt='" & _work_date & "' "
        sql = sql & "and a.section_c='" & _section_c & "' "  '[FC] Added by Govind on 2015-Mar-19
        sql = sql & "order by a.ent_dt asc "

        db.conecDB()
        db.initCMD()
        rd = db.execReader(sql)
        While rd.Read()
            _xA(_y, 0) = rd("ent_dt")
            _aC = _aC + 1
            _xA(_y, 1) = _aC
            _y = _y + 1
        End While
        db.closeDB()
        rd.Close()

        j = 0
        _shift_begin = _shift_st

        _xTemq(0, 0) = _shift_begin
        _xTemq(0, 1) = 0

        For i = 0 To _y - 1
            Dim _value As DateTime = _xA(i, 0)
            If _shift_begin <= _value Then
                While _shift_begin < _value
                    j = j + 1
                    _shift_begin = _shift_begin.AddMinutes(5)
                    _xTemq(j, 0) = _shift_begin
                    _xTemq(j, 1) = _tC
                End While
            End If
            _tC = _tC + 1
            _xTemq(j, 0) = _shift_begin
            _xTemq(j, 1) = _tC
        Next
        j = j + 1
        If _shift_end <= _shift_begin Then _shift_end = _shift_begin ' Added By Gagan Kalyana on 2015-Apr-27

        'Actual chart
        Dim y As New Series
        y.Name = ReadWriteXml.getAppResource("1102").ToString()
        y.XValueType = ChartValueType.String
        y.ChartType = SeriesChartType.Line
        y.BorderWidth = 2
        y.Color = Drawing.Color.White
        For i = 0 To j - 1
            Dim _value As DateTime = _xTemq(i, 0)
            y.Points.AddXY(_value.ToShortTimeString, _xTemq(i, 1).ToString)
            y.LabelToolTip = _xTemq(i, 1).ToString
            If (i = j - 1) Then
                Dim _fontname As String = "Arial"
                Dim _fontsize As Integer = 10
                Dim _font As New Drawing.Font(_fontname, _fontsize, Drawing.FontStyle.Regular)
                y.Points(i).Font = _font
                y.Points(i).LabelForeColor = Drawing.Color.White
                y.Points(i).Label = CDbl(_xTemq(i, 1)).ToString("##,###0")
            End If
        Next
        Chart1.Series.Add(y)
        
        ' Added By Gagan Kalyana on 2015-Apr-27 [Start]
        Dim lstDef As New List(Of DateTime)
        '[9] Commented and added by Gagan Kalyana on 2016-Feb-18
        'sql = "select Ent_Dt from defect_res "
        'sql = sql & "where factory_c='" & _factory_c & "' and section_c='" & _section_c & "' and line_c='" & _line_c & "' and shift_c='" & _shift_c & "' and work_date='" & _work_date & "'  order by ent_dt asc"
        sql = "SELECT Insp_Dt FROM ACS_Defect_Res WHERE Factory_C = '" & _factory_c & "' AND Section_C = '" & _section_c & "' AND Line_C = '" & _line_c & "' AND "
        sql = sql & "Shift = '" & _shift_c & "' AND CAST(Insp_Dt AS DATE) = CAST('" & _work_date & "' AS DATE) ORDER BY Insp_Dt ASC"
        
        db.conecDB()
        db.initCMD()
        rd = db.execReader(sql)

        While rd.Read()
            '[9] Commented and added by Gagan Kalyana on 2016-Feb-18
            'lstDef.Add(rd("Ent_Dt"))
            lstDef.Add(rd("Insp_Dt"))
        End While
        db.closeDB()
        rd.Close()

        Dim lstDefPeriod As New List(Of DateTime)
        _shift_begin = _shift_st

        _defectCount = CInt(lstDef.Count)    'Added by Gagan Kalyana on 2015-May-06

        While _shift_begin <= _shift_end
            lstDefPeriod.Add(_shift_begin)
            _shift_begin = _shift_begin.AddMinutes(5)
        End While

        Dim _Cnt As Integer
        Dim AA As New Series
        With AA
            .Name = "Def"
            .XValueType = ChartValueType.String
            .ChartType = SeriesChartType.Line
            .IsVisibleInLegend = False
            .Color = Drawing.Color.Transparent
            .MarkerSize = 10
            .MarkerStyle = MarkerStyle.Star4
            .MarkerColor = Drawing.Color.Red

            For i = 0 To lstDefPeriod.Count - 1
                Dim _value As DateTime = lstDefPeriod.Item(i)
                _Cnt = Aggregate QQ In lstDef
                            Where QQ >= _value And QQ < _value.AddMinutes(5)
                            Into Count()

                .Points.AddXY(_value.ToShortTimeString, 20)
                If _Cnt = 0 Then
                    .Points(i).IsEmpty = True
                Else
                    .Points(i).ToolTip = _Cnt.ToString
                End If
            Next
        End With
        Chart1.Series.Add(AA)
        ' Added By Gagan Kalyana on 2015-Apr-27 [End]
        
        'Commented and Added by SIS on 2016-Oct-20 [Start]

        'Dim dblTime As Double = getWorkingTime(_factory_c, _section_c, _line_c, _shift_c, _work_date)        
        ''Modified by Gagan Kalyana on 2016-Apr-04
        ''strSql = "SELECT AVG(((ISNULL(I.Qty, 0) * ROUND((ISNULL(M.smh_sub + M.smh_asy, 0))/3600, 6)) / " & dblTime.ToString & " * 3600 * " & lb_worker.Text & ") / P.proty_pl) AS Pp "
        ''strSql = "SELECT AVG(((I.Qty * ROUND((ISNULL(M.smh_sub + M.smh_asy, 0)), 6)) / (" & dblTime.ToString & " * 3600 * " & lb_worker.Text & ")) * P.proty_pl) AS Pp "           'Commnected by Gagan Kalyana on 2016-Apr-07
        'strSql = "SELECT ISNULL((SUM(I.Qty * ROUND((ISNULL(M.smh_sub + M.smh_asy, 0)), 6)/(P.proty_pl/100)))/ (" & dblTime.ToString & " * 3600 * " & lb_worker.Text & "),0) AS Pp "  'Added by Gagan Kalyana on 2016-Apr-07
        'strSql = strSql + "FROM Production_plan P(NOLOCK) "
        'strSql = strSql + "LEFT JOIN Product_mst M(NOLOCK) ON P.Factory_c = M.Factory_c AND P.product_no = M.product_no and P.cusdesch_c1=M.cusdesch_c1 and P.cusdesch_c2=M.cusdesch_c2 and P.intdesch_c=M.intdesch_c "
        ''Modified by Gagan Kalyana on 2016-Apr-04
        ''strSql = strSql + "LEFT JOIN (SELECT Product_No, CusDesch_C1, CusDesch_C2, IntDesch_C, COUNT(1) AS Qty FROM ACS_insp_res(NOLOCK) "
        'strSql = strSql + "LEFT JOIN (SELECT Product_No, CusDesch_C1, CusDesch_C2, IntDesch_C, ISNULL(COUNT(1),0) AS Qty FROM ACS_insp_res(NOLOCK) "
        'strSql = strSql + "WHERE factory_c = '" & _factory_c & "' AND section_c = '" & _section_c & "' AND line_c = '" & _line_c & "' AND shift_st_dt = CAST('" & _work_date & "' AS DATE) AND shift = '" & _shift_c & "' "
        'strSql = strSql + "GROUP BY Product_No, CusDesch_C1, CusDesch_C2, IntDesch_C "
        'strSql = strSql + ") I ON P.product_no = I.product_no and P.cusdesch_c1=I.cusdesch_c1 and P.cusdesch_c2=I.cusdesch_c2 and P.intdesch_c=I.intdesch_c "
        'strSql = strSql + "WHERE P.factory_c = '" & _factory_c & "' AND P.section_c = '" & _section_c & "' AND P.line_c = '" & _line_c & "' AND P.work_date = CAST('" & _work_date & "' AS DATE) AND P.shift_C = '" & _shift_c & "' "
        
        Dim dblTime As Double = 0
        
        'Commented and Added by SIS on 2016-nov-08 [Start]

        'If Format$(CDate(Request("WK")), "yyyy-MM-dd") = _work_date Then
        '    dblTime = getWorkingTime(_factory_c, _section_c, _line_c, _shift_c, _work_date)
        'Else
        '    dblTime = getPastWorkingTime(_factory_c, _section_c, _line_c, _shift_c, _work_date)
        'End If
        
        strSql = "SELECT start_time,end_time,duration_time "
        strSql = strSql + "FROM Shift_time_data "
        strSql = strSql + "WHERE factory_c = '" & _factory_c & "' AND section_c = '" & _section_c & "' AND line_c = '" & _line_c & "' AND work_date = CAST('" & _work_date & "' AS DATE) AND shift_C = '" & _shift_c & "'AND (time_c ='ST01'OR time_c ='ST08')  "
        strSql = strSql + "ORDER BY time_c"
       
        dataSet.Tables.Clear()
        dataAdapter = New SqlDataAdapter(strSql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
        dataAdapter.Fill(dataSet)
        
        'Commented and Added by SIS on 2016-Jun-19 [Start]
        'If (dataSet.Tables(0).Rows(0)(0) <= Now) And ((dataSet.Tables(0).Rows(1)(1) >= Now) And (dataSet.Tables(0).Rows(1)(2) > 0)) Then
        If (dataSet.Tables(0).Rows(1)(2) > 0) Then
            If (dataSet.Tables(0).Rows(0)(0) <= Now) And ((dataSet.Tables(0).Rows(1)(1) >= Now)) Then
            dblTime = getWorkingTime(_factory_c, _section_c, _line_c, _shift_c, _work_date)
            Else
                dblTime = getPastWorkingTime(_factory_c, _section_c, _line_c, _shift_c, _work_date)
            End If
        Else
            If (dataSet.Tables(0).Rows(0)(0) <= Now) And ((dataSet.Tables(0).Rows(0)(1) >= Now)) Then
                dblTime = getWorkingTime(_factory_c, _section_c, _line_c, _shift_c, _work_date)
            Else
            dblTime = getPastWorkingTime(_factory_c, _section_c, _line_c, _shift_c, _work_date)
        End If
        
        End If
        'Commented and Added by SIS on 2016-nov-08 [End]
        'Commented and Added by SIS on 2016-Jun-19 [End]
        
        'Commented and Added by Gagan Kalyana on 2017-Mar-16
        'strSql = "SELECT ISNULL((SUM(I.Qty * ROUND((ISNULL(M.smh_sub + M.smh_asy, 0)), 6)))/ (" & dblTime.ToString & " * 3600 * " & lb_worker.Text & "),0) AS Pp "
        strSql = "SELECT ISNULL((SUM(I.Qty * ROUND((ISNULL(M.SMH, 0)), 6)))/ (" & dblTime.ToString & " * 3600 * " & lb_worker.Text & "),0) AS Pp "  'Added by Gagan Kalyana on 2016-Apr-07
        strSql = strSql + "FROM Production_plan P(NOLOCK) "
        strSql = strSql + "LEFT JOIN Product_mst M(NOLOCK) ON P.Factory_c = M.Factory_c AND P.product_no = M.product_no and P.cusdesch_c1=M.cusdesch_c1 and P.cusdesch_c2=M.cusdesch_c2 and P.intdesch_c=M.intdesch_c "
        strSql = strSql + "LEFT JOIN (SELECT Product_No, CusDesch_C1, CusDesch_C2, IntDesch_C, ISNULL(COUNT(1),0) AS Qty FROM ACS_insp_res(NOLOCK) "
        strSql = strSql + "WHERE factory_c = '" & _factory_c & "' AND section_c = '" & _section_c & "' AND line_c = '" & _line_c & "' AND shift_st_dt = CAST('" & _work_date & "' AS DATE) AND shift = '" & _shift_c & "' "
        strSql = strSql + "GROUP BY Product_No, CusDesch_C1, CusDesch_C2, IntDesch_C "
        strSql = strSql + ") I ON P.product_no = I.product_no and P.cusdesch_c1=I.cusdesch_c1 and P.cusdesch_c2=I.cusdesch_c2 and P.intdesch_c=I.intdesch_c "
        strSql = strSql + "WHERE P.factory_c = '" & _factory_c & "' AND P.section_c = '" & _section_c & "' AND P.line_c = '" & _line_c & "' AND P.work_date = CAST('" & _work_date & "' AS DATE) AND P.shift_C = '" & _shift_c & "' "

        'Commented and Added by SIS on 2016-Oct-20 [END]

        dataSet.Tables.Clear()
        dataAdapter = New SqlDataAdapter(strSql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
        dataAdapter.Fill(dataSet)
    
        If dataSet.Tables(0).Rows.Count > 0 Then
            'Commented and Added by Gagan Kalyana on 2016-Apr-04 [Start]
            'lblRealEff.InnerText = dataSet.Tables(0).Rows(0)(0).ToString("00.00") & "%"
            'lblRealEff.InnerText = Int(dataSet.Tables(0).Rows(0)(0) * 100) & "%"                         'Commented by Gagan Kalyana on 2017-Mar-16
            lblRealEff.InnerText = CDbl(dataSet.Tables(0).Rows(0)(0) * 100).ToString("0.00") & "%"        'Added by Gagan Kalyana on 2017-Mar-16
       
        Else
            lblRealEff.InnerText = "0 %"
            'Commented and Added by Gagan Kalyana on 2016-Apr-04 [End]
        End If
        
        ''[10] Added by Gagan Kalyana on 2016-Feb-18[Start]
        'Dim duration As TimeSpan = DateTime.Now - _shift_begin
        'dblOpr_time = (DateTime.Now - _shift_begin).Hours.ToString("00") + CDbl((duration.Minutes / 6000) * 100).ToString(".00")
        ''lblRealEff.InnerText = CDbl(CDbl(_actualCount) * (smh / (dblOpr_time * 3600)) * CDbl(lb_worker.Text).ToString("##.00")).ToString("###.000000")
        'lblRealEff.InnerText = (DateTime.Now - _shift_begin).Hours.ToString("00") + CDbl((duration.Minutes / 6000) * 100).ToString(".00")
        ''[10] Added by Gagan Kalyana on 2016-Feb-18[End]
    End Sub
    
   Private Function getWorkingTime(ByVal Factory_C As String, ByVal Section_C As String, ByVal Line_C As String, ByVal Shift_C As String, ByVal Work_Date As String) As Double
        Dim dblTotalWorkingTime As Double = 0
        Dim strSql As String = ""
        Dim dataAdapter As SqlDataAdapter
        Dim intCount As Integer = 0
        Dim strTemp As String = ""
        Dim dataSet As New DataSet
        
        strSql = "SELECT Time_C, Duration_Time, Flg_Time FROM Shift_Time_Data WHERE  Factory_C = '" + Factory_C + "' AND Section_C='" + Section_C + "' "
        strSql = strSql + "AND Line_C='" + Line_C + "' AND Shift_C= '" + Shift_C + "' AND Work_Date = CAST('" + Work_Date + "' AS DATE) "
        strSql = strSql + "AND CAST(End_Time AS TIME) <= CAST(GETDATE() AS TIME);"
        
        strSql = strSql + "SELECT Time_C, DATEDIFF(MINUTE, CAST(Start_Time AS TIME), CAST(GETDATE() AS TIME)) AS Duration_Time, Flg_Time FROM Shift_Time_Data WHERE  Factory_C = '" + Factory_C + "' AND Section_C='" + Section_C + "' "
        strSql = strSql + "AND Line_C='" + Line_C + "' AND Shift_C= '" + Shift_C + "' AND Work_Date = CAST('" + Work_Date + "' AS DATE) "
        strSql = strSql + "AND CAST(GETDATE() AS TIME) between CAST(Start_Time AS TIME) and CAST(End_Time AS TIME);"

        dataAdapter = New SqlDataAdapter(strSql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
        dataAdapter.Fill(dataSet)

        For intCount = 0 To dataSet.Tables(0).Rows.Count - 1
            strTemp = dataSet.Tables(0).Rows(intCount)(0).ToString
            Select Case strTemp
                Case "ST01"
                    dblTotalWorkingTime = dblTotalWorkingTime + dataSet.Tables(0).Rows(intCount)(1)
                Case "ST08"
                    dblTotalWorkingTime = dblTotalWorkingTime + dataSet.Tables(0).Rows(intCount)(1)
                    
                    'Modified by Gagan Kalyana on 2017-Mar-16 [Start] 
                    'Case "ST05"
                    '    dblTotalWorkingTime = dblTotalWorkingTime - dataSet.Tables(0).Rows(intCount)(1)
                    'Case Is <> "ST12"
                    '    If dataSet.Tables(0).Rows(intCount)(2) = 0 Then
                    '        dblTotalWorkingTime = dblTotalWorkingTime - dataSet.Tables(0).Rows(intCount)(1)
                    '    End If
                    'Case "ST12"
                    '    dblTotalWorkingTime = dblTotalWorkingTime + dataSet.Tables(0).Rows(intCount)(1)
                Case Else
                    If dataSet.Tables(0).Rows(intCount)(2) <> 1 Then
                        dblTotalWorkingTime = dblTotalWorkingTime - dataSet.Tables(0).Rows(intCount)(1)
                    End If
                    'Modified by Gagan Kalyana on 2017-Mar-16 [End]
            End Select
        Next

        For intCount = 0 To dataSet.Tables(1).Rows.Count - 1
            strTemp = dataSet.Tables(1).Rows(intCount)(0).ToString
            Select Case strTemp
                Case "ST01"
                    dblTotalWorkingTime = dblTotalWorkingTime + dataSet.Tables(1).Rows(intCount)(1)
                Case "ST08"
                    dblTotalWorkingTime = dblTotalWorkingTime + dataSet.Tables(1).Rows(intCount)(1)
                
                    'Modified by Gagan Kalyana on 2017-Mar-16 [Start] 
                    'Case "ST05"
                    '    dblTotalWorkingTime = dblTotalWorkingTime - dataSet.Tables(1).Rows(intCount)(1)
                    'Case Is <> "ST12"
                    '    If dataSet.Tables(1).Rows(intCount)(2) = 0 Then
                    '        dblTotalWorkingTime = dblTotalWorkingTime - dataSet.Tables(1).Rows(intCount)(1)
                    '    End If
                    'Case "ST12"
                    '    dblTotalWorkingTime = dblTotalWorkingTime + dataSet.Tables(1).Rows(intCount)(1)
                Case Else
                    If dataSet.Tables(1).Rows(intCount)(2) <> 1 Then
                        dblTotalWorkingTime = dblTotalWorkingTime - dataSet.Tables(1).Rows(intCount)(1)
                    End If
                    'Modified by Gagan Kalyana on 2017-Mar-16 [End]
                    
            End Select
        Next
        
        dblTotalWorkingTime = dblTotalWorkingTime / 60
        
        'Commented and Added by SIS on 2016-Nov-14 [START]
        'dblTotalWorkingTime = CDbl(Int(dblTotalWorkingTime).ToString + "." + (TimeSpan.FromMinutes(dblTotalWorkingTime).Seconds).ToString("00"))
        'Commented and Added by SIS on 2016-Nov-14 [END]
        
        Return dblTotalWorkingTime
    End Function
 
    Private Function getPastWorkingTime(ByVal Factory_C As String, ByVal Section_C As String, ByVal Line_C As String, ByVal Shift_C As String, ByVal Work_Date As String) As Double
  
        Dim dblTotalWorkingTime As Double = 0
        Dim strSql As String = ""
        Dim dataAdapter As SqlDataAdapter
        Dim intCount As Integer = 0
        Dim strTemp As String = ""
        Dim dataSet As New DataSet
        
        strSql = "SELECT Time_C, Duration_Time, Flg_Time FROM Shift_Time_Data WHERE  Factory_C = '" + Factory_C + "' AND Section_C='" + Section_C + "' "
        strSql = strSql + "AND Line_C='" + Line_C + "' AND Shift_C= '" + Shift_C + "' AND Work_Date = CAST('" + Work_Date + "' AS DATE) "
 
        dataAdapter = New SqlDataAdapter(strSql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
        dataAdapter.Fill(dataSet)
        
        For intCount = 0 To dataSet.Tables(0).Rows.Count - 1
            strTemp = dataSet.Tables(0).Rows(intCount)(0).ToString
            Select Case strTemp
                Case "ST01"
                    dblTotalWorkingTime = dblTotalWorkingTime + dataSet.Tables(0).Rows(intCount)(1)
                Case "ST08"
                    dblTotalWorkingTime = dblTotalWorkingTime + dataSet.Tables(0).Rows(intCount)(1)
                
                    'Modified by Gagan Kalyana on 2017-Mar-16 [Start] 
                    'Case "ST05"
                    '    dblTotalWorkingTime = dblTotalWorkingTime - dataSet.Tables(0).Rows(intCount)(1)
                    'Case Is <> "ST12"
                    '    If dataSet.Tables(0).Rows(intCount)(2) = 0 Then
                    '        dblTotalWorkingTime = dblTotalWorkingTime - dataSet.Tables(0).Rows(intCount)(1)
                    '    End If
                    'Case "ST12"
                    '    dblTotalWorkingTime = dblTotalWorkingTime + dataSet.Tables(0).Rows(intCount)(1)
                Case Else
                    If dataSet.Tables(0).Rows(intCount)(2) <> 1 Then
                        dblTotalWorkingTime = dblTotalWorkingTime - dataSet.Tables(0).Rows(intCount)(1)
                    End If
                    'Modified by Gagan Kalyana on 2017-Mar-16 [End]
            End Select
        Next
        
        'Commented and Added by SIS on 2016-Nov-14 [START]
        dblTotalWorkingTime = dblTotalWorkingTime / 60
        'dblTotalWorkingTime = CDbl(Int(dblTotalWorkingTime).ToString + "." + (TimeSpan.FromMinutes(dblTotalWorkingTime).Seconds).ToString("00"))
        'Commented and Added by SIS on 2016-Nov-14 [END]

        Return dblTotalWorkingTime
    End Function
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <%--[11] Commented and Added by Gagan Kalyana on 2016-Feb-18 [Start]--%>
    <link type="text/css" href="Styles/css/ui-lightness/jquery-ui-1.8.19.custom.css" rel="stylesheet" />
    <script type="text/javascript" src="Scripts/js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="Scripts/js/jquery-ui-1.8.19.custom.min.js"></script>
    <%--[11] Commented and Added by Gagan Kalyana on 2016-Feb-18 [End]--%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="divshift">      
        <asp:Table ID="Table1" runat="server"  Width="100%" CellPadding="2">
            <asp:TableRow runat="server">
                <%--Commented and added by Gagan Kalyana on 2015-May-13--%>
                <%--<asp:TableCell runat="server">&nbsp;&nbsp;<span class="fontshift_head"><%=ReadWriteXml.getAppResource("1024")%></span><span style="margin-left:5px"></span><asp:Label ID="lb_section" runat="server" Text=""></asp:Label></asp:TableCell>
                    <asp:TableCell ID="TableCell24" runat="server">&nbsp;&nbsp;<span class="fontshift_head"><%=ReadWriteXml.getAppResource("1025")%></span><span style="margin-left:8px"></span><asp:Label ID="lb_sv" runat="server" Text=""></asp:Label></asp:TableCell>--%>  
                <asp:TableCell runat="server" Visible="false">&nbsp;&nbsp;<span class="fontshift_head"><%=ReadWriteXml.getAppResource("1024")%></span><span style="margin-left:5px"></span><asp:Label ID="lb_section" runat="server" Text=""></asp:Label></asp:TableCell>  
                <asp:TableCell ID="TableCell24" runat="server"  Visible="false">&nbsp;&nbsp;<span class="fontshift_head"><%=ReadWriteXml.getAppResource("1025")%></span><span style="margin-left:8px"></span><asp:Label ID="lb_sv" runat="server" Text=""></asp:Label></asp:TableCell>
                <%--Commented by Gagan Kalyana on 2015-Mar-27--%>
                <%--<asp:TableCell runat="server">&nbsp;&nbsp;<span class="fontshift_head"><%=ReadWriteXml.getAppResource("1026")%></span><span style="margin-left:10px">&nbsp;</span><asp:Label ID="lb_working_day_1" runat="server" Text=""></asp:Label><asp:Label ID="lb_working_day" runat="server" Text="" Visible="False"></asp:Label>
                </asp:TableCell> --%>               
            </asp:TableRow>

            <%--Commented and added by Gagan Kalyana on 2015-May-13[Start]--%>
            <%--<asp:TableRow runat="server" HorizontalAlign="Left">--%>
                <%--<asp:TableCell runat="server">&nbsp;&nbsp;<span class="fontshift_head"><%=ReadWriteXml.getAppResource("1028")%></span><span style="margin-left:5px">&nbsp;</span><asp:Label ID="lb_line_no" runat="server" Text=""></asp:Label>-<asp:Label ID="lb_line_name" runat="server" Text=""></asp:Label></asp:TableCell>--%>
                <%--<asp:TableCell ID="TableCell25" runat="server">&nbsp;&nbsp;<span class="fontshift_head"><%=ReadWriteXml.getAppResource("1029")%></span><span style="margin-left:40px">&nbsp;</span><asp:Label ID="lb_leader" runat="server" Text=""></asp:Label></asp:TableCell>--%>                            
                <%--Added by Gagan Kalyana on 2015-Mar-27 [Start]--%>
                <%--<asp:TableCell ID="TableCell1" runat="server">&nbsp;&nbsp;<span class="fontshift_head"><%=ReadWriteXml.getAppResource("1026")%></span><span style="margin-left:10px">&nbsp;</span><asp:Label ID="lb_working_day_1" runat="server" Text=""></asp:Label><asp:Label ID="lb_working_day" runat="server" Text="" Visible="False"></asp:Label></asp:TableCell>--%> 
                <%--Added by Gagan Kalyana on 2015-Mar-27 [End]--%>
               <%--<asp:TableCell runat="server">&nbsp;&nbsp;<span class="fontshift_head"><%=ReadWriteXml.getAppResource("1030")%></span><span style="margin-left:52px">&nbsp;</span><asp:Label ID="lb_shift" runat="server" Text=""></asp:Label></asp:TableCell>--%>
            <%--</asp:TableRow>--%>

            <asp:TableRow ID="TableRow4" runat="server" HorizontalAlign="Left">
                <asp:TableCell ID="TableCell1" runat="server">&nbsp;&nbsp;<span class="fontshift_head"><%=ReadWriteXml.getAppResource("1028")%></span><span style="margin-left:5px">&nbsp;</span><asp:Label ID="lb_line_no" runat="server" Text=""></asp:Label>-<asp:Label ID="lb_line_name" runat="server" Text=""></asp:Label></asp:TableCell>
                <asp:TableCell ID="TableCell25" runat="server">&nbsp;&nbsp;<span class="fontshift_head"><%=ReadWriteXml.getAppResource("1029")%></span><span style="margin-left:5px">&nbsp;</span><asp:Label ID="lb_leader" runat="server" Text=""></asp:Label></asp:TableCell>                            
                <%--[11] Commented and Added by Gagan Kalyana on 2016-Feb-18 [Start]--%>
                <%--Added by Gagan Kalyana on 2015-Mar-27 [Start]--%>
                <%--<asp:TableCell ID="TableCell2" runat="server">&nbsp;&nbsp;<span class="fontshift_head"><%=ReadWriteXml.getAppResource("1026")%></span><span style="margin-left:5px">&nbsp;</span><asp:Label ID="lb_working_day_1" runat="server" Text=""></asp:Label><asp:Label ID="lb_working_day" runat="server" Text="" Visible="False"></asp:Label></asp:TableCell> --%>
                <%--Added by Gagan Kalyana on 2015-Mar-27 [End]--%>
                <%--<asp:TableCell ID="TableCell3" runat="server">&nbsp;&nbsp;<span class="fontshift_head"><%=ReadWriteXml.getAppResource("1030")%></span><span style="margin-left:5px">&nbsp;</span><asp:Label ID="Label1" runat="server" Text=""></asp:Label></asp:TableCell>--%>

                <asp:TableCell ID="TableCell2" runat="server">&nbsp;&nbsp;<span class="fontshift_head"><%=ReadWriteXml.getAppResource("1026")%></span><span style="margin-left:5px">&nbsp;</span>
                    <span style="font-size:8pt !important">
                        <asp:TextBox ID="lb_working_day_1" class="PickedDate" onchange="updateShift()" Width="120px" runat="server"/>
                    </span>
                    <asp:Label ID="lb_working_day" runat="server" Text="" Visible="False"></asp:Label></asp:TableCell><asp:TableCell ID="TableCell3" runat="server">&nbsp;&nbsp;<span class="fontshift_head"><%=ReadWriteXml.getAppResource("1030")%></span><span style="margin-left: 5px">&nbsp;</span>
                        <asp:DropDownList ID="ddl_shift" runat="server" Width="120px" Visible="false"></asp:DropDownList>
                        <select id="shift" visible="true" onchange="setShift(this,this.value)" class="shift" style="width:120px" runat="server"></select>
                        <asp:HiddenField ID="hdshift_C" runat="server"/>
                </asp:TableCell><asp:TableCell ID="TableCell10" runat="server">
                    &nbsp;&nbsp;<span class="fontshift_head" /><span style="margin-left: 5px">&nbsp;</span>
                    <asp:Button ID="bt_Search" CssClass="bt_Search" runat="server" Style="font-weight: bold; width: 80px; color: blue"></asp:Button>
                </asp:TableCell><%--[11] Commented and Added by Gagan Kalyana on 2016-Feb-18 [End]--%></asp:TableRow><%--Commented and added by Gagan Kalyana on 2015-May-13
            <asp:TableRow runat="server" HorizontalAlign="Left">--%><asp:TableRow ID="TableRow1" runat="server" HorizontalAlign="Left" Visible="false">
                <asp:TableCell runat="server" Style="color: Red">
                    &nbsp;&nbsp;
                   <span class="fontshift_head"><%=ReadWriteXml.getAppResource("1032")%></span>
                    <span style="margin-left: 5px">&nbsp;</span><asp:Label ID="lb_note" runat="server" Text=""></asp:Label>
                </asp:TableCell><asp:TableCell ID="TableCell26" runat="server">
                    &nbsp;&nbsp;<span class="fontshift_head"><%=ReadWriteXml.getAppResource("1033")%></span><span style="margin-left: 5px">&nbsp;</span><asp:Label ID="lb_sub_leader" runat="server" Text=""></asp:Label>
                </asp:TableCell><asp:TableCell runat="server">
                    &nbsp;&nbsp;<span class="fontshift_head"><%=ReadWriteXml.getAppResource("1034")%></span><span style="margin-left: 0px">&nbsp;</span><asp:Label ID="lb_upd_dt" runat="server" Text=""></asp:Label>
                </asp:TableCell></asp:TableRow></asp:Table><%--[11] Commented and Added by Gagan Kalyana on 2016-Feb-18 [Start]--%><script type="text/javascript">
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
                var line = '<% Response.Write(Request("line"))%>'
                var wk = ($(".PickedDate").val());
                if (wk.length > 0) {
                    $.ajax({
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json; charset=utf-8",
                        url: "Shift.aspx/updateShift",
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
        </script><%--[11] Commented and Added by Gagan Kalyana on 2016-Feb-18 [End]--%></div><div class="clear"></div>
    <div class="main_1">
    <div style="width:100%">
        <asp:table ID="Table_center" runat="server" Width="100%" CellPadding="2" CellSpacing="2">
            <asp:TableRow ID="tablerow_left" runat="server" VerticalAlign="top">                
                <asp:TableCell ID="TableCell_right" runat="server">                    
                      <asp:Table ID="table_info" runat="server" Width="100%" CellPadding="2" CellSpacing="0">
                        <asp:TableRow ID="tablerow_info1" runat="server" VerticalAlign="top">
                            <asp:TableCell ID="tablecell_info1" runat="server" Width="60%">
                                <!--tact time,working time-->
                                <table width="100%" cellspacing="0" cellpadding="2" class="shifttable">
                                      <tr bgcolor="gray" align="center"> 
                                          <%--Modified by Gagan Kalyana on 2015-Dec-17                       
                                        <td width="60%" align="left"><span class="fontshift_1"><%=ReadWriteXml.getAppResource("1035")%></span></td>
                                        <td colspan="2" ><span class="fontshift_head_1"><%=ReadWriteXml.getAppResource("1036")%></span></td>--%>
                                        <th width="60%" align="left"><span><%=ReadWriteXml.getAppResource("1035")%></span></th>
                                        <th colspan="2" ><span><%=ReadWriteXml.getAppResource("1036")%></span></th>
                                      </tr>
                                      <tr>                        
                                        <%--  Modified by Gagan Kalyana on 2015-Dec-17    
                                        <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1037")%></div></td>--%>
                                          <td><div><%=ReadWriteXml.getAppResource("1037")%></div></td>
                                        <td colspan="2"><div align="center"><asp:Label ID="lb_qty_pl" runat="server" Text=""></asp:Label></div></td>
                                      </tr>
                                      <tr>                        
                                        <%--Modified by Gagan Kalyana on 2015-Dec-17    
                                        <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1038")%></div></td>--%>
                                        <td><div ><%=ReadWriteXml.getAppResource("1038")%></div></td>
                                        <td colspan="2"><div align="center"><asp:Label ID="lb_tact_time" runat="server" Text=""></asp:Label></div></td>
                                      </tr>
                                      <tr>  
                                        <%--Modified by Gagan Kalyana on 2015-Dec-17                      
                                        <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1038")%></div></td>--%>
                                        <td><div><%=ReadWriteXml.getAppResource("1291")%></div></td>
                                        <td colspan="2"><div align="center"><asp:Label ID="lb_cycle_time" runat="server" Text=""></asp:Label><%=ReadWriteXml.getAppResource("1039")%></div></td>
                                      </tr>
                                      <tr>                        
                                        <%--Modified by Gagan Kalyana on 2015-Dec-17                      
                                        <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1040")%></div></td>--%>
                                        <td><div><%=ReadWriteXml.getAppResource("1040")%></div></td>
                                        <td><div align="center"><asp:Label ID="lb_smh" runat="server" Text=""></asp:Label></div></td>
                                        <td><div align="center"><asp:Label ID="lb_amh" runat="server" Text=""></asp:Label></div></td>
                                      </tr>
                                       <%--[3] Commented and Modified by Govind on 2015-Mar-19 [Start]
                                      <tr>                        
                                        <td><div class="fontshift">Eff(Di/In)(%)</div></td>
                                        <td><div align="center"><asp:Label ID="lb_effic_st" runat="server" Text=""></asp:Label></div></td>
                                        <td><div align="center"><asp:Label ID="lb_effic_at" runat="server" Text=""></asp:Label></div></td>
                                      </tr>
                                      --%>
                                      <tr>      
                                        <%--Modified by Gagan Kalyana on 2015-Dec-17                         
                                        <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1193")%></div></td>--%>
                                        <td><div><%=ReadWriteXml.getAppResource("1193")%></div></td>
                                        <td colspan="2"><div align="center"><asp:Label ID="lb_effic_st" runat="server" Text=""></asp:Label></div></td>
                                      </tr>  
                                      <tr>         
                                        <%--Modified by Gagan Kalyana on 2015-Dec-17               
                                        <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1194")%></div></td>--%>
                                        <td><div><%=ReadWriteXml.getAppResource("1194")%></div></td>
                                        <td colspan="2"><div align="center"><asp:Label ID="lb_effic_at" runat="server" Text=""></asp:Label></div></td>
                                      </tr>
                                      <%--[3] Commented and Modified by Govind on 2015-Mar-19 [End]--%>
                                      <tr>                 
                                        <%--Modified by Gagan Kalyana on 2015-Dec-17       
                                        <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1042")%></div></td>--%>
                                        <td><div ><%=ReadWriteXml.getAppResource("1042")%></div></td>
                                        <td colspan="2"><div align="center"><asp:Label ID="lb_proty_taget" runat="server" Text=""></asp:Label></div></td>
                                      </tr>
                                    </table>
                                <div class="fontshift_1" style="margin:5px 5px 5px 5px;"></div>
                                <table width="100%"  cellspacing="0" cellpadding="2" class="shifttable">
                                      <tr bgcolor="gray" align="center">                        
                                        <%--Modified by Gagan Kalyana on 2015-Dec-17       
                                        <td align="left" width="60%"><span class="fontshift_1"><%=ReadWriteXml.getAppResource("1043")%></span></td>
                                        <td colspan="2" ><span class="fontshift_head_1"><%=ReadWriteXml.getAppResource("1044")%></span></td>--%>
                                        <th align="left" width="60%"><span><%=ReadWriteXml.getAppResource("1043")%></span></th>
                                        <th colspan="2" ><span ><%=ReadWriteXml.getAppResource("1044")%></span></th>
                                      </tr>
                                      <tr>                        
                                        <%--Modified by Gagan Kalyana on 2015-Dec-17    
                                        <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1043")%></div></td>--%>
                                        <td><div ><%=ReadWriteXml.getAppResource("1043")%></div></td>
                                        <td colspan="2"><div align="center"><asp:Label ID="lb_hour_act" runat="server" Text=""></asp:Label></div></td>
                                      </tr>
                                      <tr>  
                                        <%--Modified by Gagan Kalyana on 2015-Dec-17                          
                                        <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1045")%></div></td>--%>
                                        <td><div><%=ReadWriteXml.getAppResource("1045")%></div></td>
                                        <td colspan="2"><div align="center"><asp:Label ID="lb_downtime_ratio" runat="server" Text=""></asp:Label>%</div></td>
                                      </tr>
                                      <tr>                        
                                        <%--Modified by Gagan Kalyana on 2015-Dec-17                          
                                        <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1046")%></div></td>--%>
                                        <td><div><%=ReadWriteXml.getAppResource("1046")%></div></td>
                                        <td colspan="2"><div align="center"><asp:Label ID="lb_break" runat="server" Text=""></asp:Label></div></td>
                                      </tr>
                                      <tr>        
                                        <%--Modified by Gagan Kalyana on 2015-Dec-17                 
                                        <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1047")%></div></td>--%>
                                        <td><div><%=ReadWriteXml.getAppResource("1047")%></div></td>
                                        <td colspan="2"><div align="center"><asp:Label ID="lb_downtime_pl" runat="server" Text=""></asp:Label></div></td>
                                      </tr>
                                      <tr>   
                                        <%--Modified by Gagan Kalyana on 2015-Dec-17                      
                                        <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1048")%></div></td>--%>
                                          <td><div><%=ReadWriteXml.getAppResource("1048")%></div></td>
                                        <td colspan="2"><div align="center"><asp:Label ID="lb_over_time" runat="server" Text=""></asp:Label></div></td>
                                      </tr>                      
                                    </table>  
                                <!--end tact time,working time-->
                            </asp:TableCell>
                            <asp:TableCell ID="tablecell_info2" runat="server">
                                <!--man power,defect-->
                                <table width="100%" cellspacing="0" cellpadding="2" class="shifttable">
                                  <tr bgcolor="gray" align="center">                     
                                      <%--Modified by Gagan Kalyana on 2015-Dec-17         
                                     <td width="60%" align="left"><span class="fontshift_1"><%=ReadWriteXml.getAppResource("1049")%></span></td>
                                     <td width="38%"><span class="fontshift_head_1"><%=ReadWriteXml.getAppResource("1036")%></span></td>--%>
                                      <th width="60%" align="left"><span><%=ReadWriteXml.getAppResource("1049")%></span></th>
                                     <th width="38%"><span><%=ReadWriteXml.getAppResource("1036")%></span></th>
                                  </tr>
                                  <tr>                        
                                    <%--Modified by Gagan Kalyana on 2015-Dec-17
                                    <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1050")%></div></td>--%>
                                    <td><div><%=ReadWriteXml.getAppResource("1050")%></div></td>
                                    <td><div align="center"><asp:Label ID="lb_worker" runat="server" Text=""></asp:Label></div></td>
                                  </tr>
                                  <tr>                   
                                    <%--Modified by Gagan Kalyana on 2015-Dec-17     
                                    <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1051")%></div></td>--%>
                                    <td><div ><%=ReadWriteXml.getAppResource("1287")%></div></td>
                                    <td><div align="center"><asp:Label ID="lb_leader_1" runat="server" Text=""></asp:Label></div></td>
                                  </tr>
                                  
                                  <%--Modified by SIS on 2016-Apr-07　
                                  <tr>                        
                                    <%--Modified by Gagan Kalyana on 2015-Dec-17     
                                    <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1052")%></div></td>
                                    <td><div><%=ReadWriteXml.getAppResource("1052")%></div></td>
                                    <td><div align="center"><asp:Label ID="lb_inman" runat="server" Text=""></asp:Label></div></td>
                                  </tr>
                                  -- Modified by SIS on 2016-Apr-07 END %>

                                  <tr>    
                                    <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1053")%></div></td>--%>
                                    <td><div ><%=ReadWriteXml.getAppResource("1053")%></div></td>
                                    <td><div align="center"><asp:Label ID="lb_total_men" runat="server" Text=""></asp:Label> </div></td>
                                  </tr>

                                  <%--Modified by SIS on 2016-Apr-07　
                                  <tr>       
                                    <%--Modified by Gagan Kalyana on 2015-Dec-17                   
                                    <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1054")%></div></td>
                                    <td><div><%=ReadWriteXml.getAppResource("1054")%></div></td>
                                    <td><div align="center"><asp:Label ID="lb_per_men" runat="server" Text=""></asp:Label></div></td>
                                  </tr>
                                  -- Modified by SIS on 2016-Apr-07 END %>
 
                                  <tr>
                                      <%--Modified by Gagan Kalyana on 2015-Apr-17 for Mouse Pointer Change to hand over Mouse Hover--%> 
                                    <%--<td colspan="2"><div align="right">&nbsp;<a onclick="_show_1_1();"  style="background:#0000FF;color:white; font-size:14px;font-family:Tahoma">&nbsp;<%=ReadWriteXml.getAppResource("1055")%>&nbsp;</a></div></td>--%>
                                    <%--Modified by Gagan Kalyana on 2015-Dec-17
                                    <td colspan="2"><div align="right">&nbsp;<a onclick="_show_1_1();" class="Link_Hover" style="background:#0000FF;color:white; font-size:14px;font-family:Tahoma">&nbsp;<%=ReadWriteXml.getAppResource("1055")%>&nbsp;</a></div></td>--%>
                                    <%--[2] Modified by Gagan Kalyana on 2016-Feb-18 
                                    <td colspan="2"><div align="right">&nbsp;<a onclick="_show_1_1();" class="Link_Hover linkLabel">&nbsp;<%=ReadWriteXml.getAppResource("1055")%>&nbsp;</a></div></td>--%>
                                    <td colspan="2"><div align="right">&nbsp;<a target="_blank" href="WorkingTime.aspx?factory_c=<%Response.Write(Request("factory").ToString)%>&section_c=<%Response.Write(Request("section").ToString)%>&line_c=<%Response.Write(Request("line").ToString)%>&shift=<%Response.Write(hdshift_C.Value.ToString)%>&wk=<%Response.Write(lb_working_day.Text)%>" class="Link_Hover linkLabel">&nbsp;<%=ReadWriteXml.getAppResource("1055")%>&nbsp;</a></div></td>
                                  </tr>                     
                                </table>  
                                <%--[4] Commented and Modified by Govind on 2015-Mar-19
                                <div class="fontshift_1" style="margin:5px 5px 5px 5px;"></div>--%>                  
                                <div class="fontshift_1" style="margin:3px 3px 10px;"></div>
                                <br/>           
                                <%--Modified by Gagan Kalyana on 2015-Dec-17--%>        
                                <%--<table width="100%" cellspacing="0" cellpadding="2" class="shifttable_2">--%>
                                    <table width="100%" cellspacing="0" cellpadding="2" class="shifttable">
                                                  <tr bgcolor="gray" align="center">                                        
                                                     <%--Modified by Gagan Kalyana on 2015-Dec-17         
                                                      <td width="60%" align="left"><span class="fontshift_1"><%=ReadWriteXml.getAppResource("1056")%></span></td>
                                                     <td width="38%"><span class="fontshift_head_1"><%=ReadWriteXml.getAppResource("1036")%></span></td>--%>
                                                      <th width="60%" align="left"><span><%=ReadWriteXml.getAppResource("1056")%></span></th>
                                                     <th width="38%"><span><%=ReadWriteXml.getAppResource("1036")%></span></th>
                                                  </tr>
                                                    <%
                                                        '[9] Commented and added by Gagan Kalyana on 2016-Feb-18 [Start]
                                                        'Dim db As New Database
                                                        'Dim rd As SqlDataReader
                                                        'Dim sql As String
                                                        'Dim v(3) As Integer
                                                        'Dim i As Integer
                                                        'For i = 0 To 3
                                                        '    v(i) = 0
                                                        'Next
                                                        'db.conecDB()
                                                        'db.initCMD()
                                                        'sql = "select a.data_c from defect_res as a  "
                                                        'sql = sql & "where a.factory_c='" & Request("factory") & "' and a.section_c='" & Request("section") & "' and a.line_c='" & lb_line_no.Text & "' and a.shift_c='" & lb_shift.Text & "' and a.section_c='" & lb_section.Text & "' and a.work_date='" & lb_working_day.Text & "' order by a.upd_dt"
                                                        'rd = db.execReader(sql)
                                                        'While rd.Read()
                                                        '    If (rd("data_c") = "QQA01") Then
                                                        '        v(0) = v(0) + 1
                                                        '    End If
                                                        '    If (rd("data_c") = "QAS02") Then
                                                        '        v(1) = v(1) + 1
                                                        '    End If
                                                        '    If (rd("data_c") = "QAS03") Then
                                                        '        v(2) = v(2) + 1
                                                        '    End If
                                                        '    If (rd("data_c") = "QQA04") Then
                                                        '        v(3) = v(3) + 1
                                                        '    End If
                                                        'End While
                                                        'db.closeDB()
                                                        'rd.Close()
                                                        
                                                        
                                                   %>
                                                  <%--<tr>--%>        
                                                    <%--Modified by Gagan Kalyana on 2015-Dec-17                                
                                                    <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1057")%></div></td>--%>
                                                   <%-- <td><div ><%=ReadWriteXml.getAppResource("1057")%></div></td>
                                                    <td><div align="center"><% Response.Write(v(0).ToString)%></div></td>
                                                  </tr>
                                                  <tr>       --%>                                 
                                                    <%--Modified by Gagan Kalyana on 2015-Dec-17                                
                                                    <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1058")%></div></td>--%>
                                                    <%--<td><div ><%=ReadWriteXml.getAppResource("1058")%></div></td>
                                                    <td><div align="center"><% Response.Write(v(1).ToString)%></div></td>
                                                  </tr>
                                                  <tr>    --%>                                    
                                                    <%--Modified by Gagan Kalyana on 2015-Dec-17                                
                                                    <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1059")%></div></td>--%>
                                                    <%--<td><div><%=ReadWriteXml.getAppResource("1059")%></div></td>
                                                    <td><div align="center"><% Response.Write(v(2).ToString)%></div></td>
                                                  </tr>
                                                  <tr> --%>     
                                                    <%--Modified by Gagan Kalyana on 2015-Dec-17                                  
                                                    <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1060")%></div></td>--%>
                                                    <%--<td><div><%=ReadWriteXml.getAppResource("1060")%></div></td>
                                                    <td><div align="center"><% Response.Write(v(3).ToString)%></div></td>
                                                  </tr>--%>
                                                   <% 
                                                       Dim sql As String
                                                       Dim localDt As New DataTable
                                                       sql = "SELECT TOP 4 Defect_Nm, COUNT(1) AS Count FROM ACS_Defect_Res WHERE Factory_C = '" + Request("factory") + "' AND Section_C = '" + Request("section") + "' AND Line_C = '" + lb_line_no.Text + "' AND "
                                                       sql = sql + "Shift = '" + hdshift_C.Value.ToString + "' AND CAST(Insp_Dt AS DATE) = CAST('" + lb_working_day.Text + "' AS DATE) GROUP BY Defect_Nm ORDER By 2 DESC"
                                                       dataAdapter = New SqlDataAdapter(sql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
                                                       dataAdapter.Fill(localDt)
                                                       If localDt.Rows.Count > 0 Then
                                                           For intCounter = 0 To localDt.Rows.Count - 1
                                                               %>
                                        <tr>
                                            <td><div><%Response.Write(localDt.Rows(intCounter)("Defect_Nm").ToString)%></div></td>
                                            <td><div align="center"><% Response.Write(localDt.Rows(intCounter)("Count").ToString)%></div></td>
                                        </tr> 

                                        <%
                                                           Next
                                                       End If
                                                    %>
                                                  <%--'[9] Commented and added by Gagan Kalyana on 2016-Feb-18 [End]--%>
                                                  <tr> 
                                                    <%-- Modified by Gagan Kalyana on 2015-Apr-17 for Mouse Pointer Change to hand over Mouse Hover                                        
                                                    <td colspan="2" align="right"><div><a onClick="_show_1_2();" style="background:#0000FF;color:white;font-size:14px;font-family:Tahoma;">&nbsp;<%=ReadWriteXml.getAppResource("1061")%>&nbsp;</a></div></td>--%>                                       
                                                    <%--Modified by Gagan Kalyana on 2015-Dec-17
                                                    <td colspan="2" align="right"><div><a onClick="_show_1_2();" class="Link_Hover" style="background:#0000FF;color:white;font-size:14px;font-family:Tahoma;">&nbsp;<%=ReadWriteXml.getAppResource("1061")%>&nbsp;</a></div></td>--%>
                                                    <%--[2] Modified by Gagan Kalyana on 2016-Feb-18 
                                                    <td colspan="2" align="right"><div><a onClick="_show_1_2();" class="Link_Hover linkLabel">&nbsp;<%=ReadWriteXml.getAppResource("1061")%>&nbsp;</a></div></td>--%>
                                                    <td colspan="2" align="right"><div><a <a target="_blank" href="DefectDetails.aspx?factory_c=<%Response.Write(Request("factory").ToString)%>&section_c=<%Response.Write(Request("section").ToString)%>&line_c=<%Response.Write(Request("line").ToString)%>&shift=<%Response.Write(hdshift_C.Value.ToString)%>&wk=<%Response.Write(lb_working_day.Text)%>" class="Link_Hover linkLabel">&nbsp;<%=ReadWriteXml.getAppResource("1061")%>&nbsp;</a></div></td>
                                                  </tr>
                                </table>
                                <!--end man power,defect-->                                 
                            </asp:TableCell>
                        </asp:TableRow>
                    </asp:Table>
                    <!--product plan-->
                    <script type="text/javascript">
                        $(document).ready(function () {
                            updateShift();      <%--[11] Commented and Added by Gagan Kalyana on 2016-Feb-18--%>
                            $("#d1").show();
                            $("#d2").hide();
                        });
                        function a() {
                            $('#d1, #d2').toggle();
                        }
                    </script>
                      <asp:Table ID="table_pro_plan" runat="server" Width="100%" CellPadding="2" CellSpacing="0">
                        <asp:TableRow ID="tablrow_plan" runat="server">
                            <asp:TableCell ID="tablecell_plan" runat="server">
                                <div class="fontshift_1" style="margin:5px 5px 5px 5px;"></div>
                                <table width="100%" cellspacing="0" cellpadding="2" class="shifttable" >
                                      <tr>
                                        <%--Modified by Gagan Kalyana on 2015-Dec-17   [Start]
                                        <td width="26%" style="color:#F90;font-weight:bold;"><%=ReadWriteXml.getAppResource("5px 5px 5px 5px")%></td>                        --%>
                                        <%--[4] Commented and Modified by Govind on 2015-Mar-19 [Start]
                                        <td width="10%"  align="center"><div style="color:#0C0;"><%=ReadWriteXml.getAppResource("1063")%></div></td>
                                        <td width="8%"  align="center"><div style="color:#0C0;"><%=ReadWriteXml.getAppResource("1064")%></div></td>--%>
                                        <%--[4] Commented and Modified by Govind on 2015-Mar-19 [End]--%>
                                        <%--<td width="10%"  align="center"><div style="color:#0C0;"><%=ReadWriteXml.getAppResource("1065")%></div></td>
                                        <td width="8%"  align="center"><div style="color:#0C0;"><%=ReadWriteXml.getAppResource("1066")%></div></td>
                                        <td width="8%"  align="center"><div style="color:#0C0;"><%=ReadWriteXml.getAppResource("1067")%></div></td>
                                        <td width="8%"  align="center"><div style="color:#0C0;"><%=ReadWriteXml.getAppResource("1068")%></div></td>
                                        <td width="8%"  align="center"><div style="color:#0C0;"><%=ReadWriteXml.getAppResource("1069")%></div></td>--%>
                                         <%--[4] Commented and Modified by Govind on 2015-Mar-19
                                        <td colspan="2"  width="16%"  align="center"><div style="color:#0C0;"><%=ReadWriteXml.getAppResource("1070")%></div></td>--%>
                                        <%--<td colspan="2"  width="32%"  align="center"><div style="color:#0C0;"><%=ReadWriteXml.getAppResource("1070")%></div></td>--%>
                                        <th width="26%"><%=ReadWriteXml.getAppResource("1062")%></th> 
                                        <th width="14%" align="center"><div><%=ReadWriteXml.getAppResource("1133")%></div></th>   <%--[4] Added by Gagan Kalyana on 2016-Feb-18 --%>
                                        <th width="10%" align="center"><div><%=ReadWriteXml.getAppResource("1065")%></div></th>
                                        <th width="8%" align="center"><div><%=ReadWriteXml.getAppResource("1066")%></div></th>
                                        <th width="8%" align="center"><div><%=ReadWriteXml.getAppResource("1067")%></div></th>
                                        <%--[4] Commented and Added by Gagan Kalyana on 2016-Feb-18 [Start]
                                        <th width="8%" align="center"><div><%=ReadWriteXml.getAppResource("1068")%></div></th>
                                        <th width="8%" align="center"><div><%=ReadWriteXml.getAppResource("1069")%></div></th>
                                        <th colspan="2" width="32%"  align="center"><div><%=ReadWriteXml.getAppResource("1070")%></div></th>--%>
                                        <th width="16%" align="center"><div><%=ReadWriteXml.getAppResource("1214")%></div></th>
                                        <th colspan="2" width="18%"  align="center"><div><%=ReadWriteXml.getAppResource("1070")%></div></th>
                                        <%--[4] Commented and Added by Gagan Kalyana on 2016-Feb-18 [End]--%>
                                        <%--Modified by Gagan Kalyana on 2015-Dec-17   [End]--%>
                                      </tr>                     
                                      <%
                                         Dim db As New Database
                                         Dim rd As SqlDataReader
                                         Dim sql As String                         
                                         db.conecDB()
                                         db.initCMD()
                                          '[4] Commented and Modified by Govind on 2015-Mar-19
                                          'sql = "select  a.product_no,b.short_c,b.circuit_no,round((b.smh_sub+smh_asy)/3600,6) as smh,a.proty_pl,c.asy_board,c.circuit_board,a.shift_c,a.Cusdesch_c1,a.Cusdesch_c2,a.Intdesch_c "
                                          sql = "select  a.product_no,b.short_c,round((b.smh_sub+smh_asy)/3600,6) as smh,a.proty_pl,c.asy_board,c.circuit_board,a.shift_c,a.Cusdesch_c1,a.Cusdesch_c2,a.Intdesch_c "
                                          sql = sql & "from production_plan as a "
                                          sql = sql & "join  product_mst as b on a.factory_c =b.factory_c and a.product_no=b.product_no and a.cusdesch_c1=b.cusdesch_c1 and a.cusdesch_c2=b.cusdesch_c2 and a.intdesch_c=b.intdesch_c "
                                          '[FC] Commented and Modified by Govind on 2015-Mar-19
                                          'sql = sql & "join lineproduct_mst as c on a.factory_c =c.factory_c and a.line_c=c.line_c and a.product_no=c.product_no "
                                          '[11] Commented and Added by Gagan Kalyana on 2016-Feb-18
                                          'sql = sql & "join lineproduct_mst as c on a.factory_c = c.factory_c and a.section_c = c.section_c and a.line_c=c.line_c and a.product_no=c.product_no "
                                          sql = sql & "join lineproduct_mst as c on a.factory_c = c.factory_c and a.section_c = c.section_c and a.line_c=c.line_c and a.product_no=c.product_no and a.cusdesch_c1=c.cusdesch_c1 and a.cusdesch_c2=c.cusdesch_c2 and a.intdesch_c=c.intdesch_c "
                                          '[11] Commented and Added by Gagan Kalyana on 2016-Feb-18
                                          'sql = sql & "where a.factory_c='" & Request("factory") & "' and a.section_c='" & Request("section") & "' and a.line_c='" & lb_line_no.Text & "' and a.plan_qty>0 and a.section_c='" & lb_section.Text & "' and a.work_date='" & lb_working_day.Text & "' and a.shift_c='" & Trim(lb_shift.Text) & "' "
                                          sql = sql & "where a.factory_c='" & Request("factory") & "' and a.section_c='" & Request("section") & "' and a.line_c='" & lb_line_no.Text & "' and a.plan_qty>0 and a.section_c='" & lb_section.Text & "' and a.work_date='" & lb_working_day.Text & "' and a.shift_c='" & Trim(hdshift_C.Value.ToString) & "' "
                                          sql = sql & "order by a.shift_c asc,a.priority asc"
                         
                                          Dim ahour As Double = 0.0
                                          'Dim smh As Double = 1.0                           '[10] Commented By Gagan Kalyana on 2016-Feb-18 
                                          Dim _tast_time As Double = 0.0
                                          Dim color_1 As String = ""
                                          Dim color_2 As String = ""
                                          Dim color_3 As String = ""
                                          Dim color_4 As String = ""
                          
                                          '[6] Commented and Added By Gagan Kalyana on 2016-Feb-18 [Start]
                                          'If lb_hour_act.Text <> "" Then
                                          '    ahour = CDbl(lb_hour_act.Text)
                                          'End If
                                          If _dblWorking_hours_act <> 0.0 Then
                                              ahour = _dblWorking_hours_act
                                          End If
                                          '[6] Commented and Added By Gagan Kalyana on 2016-Feb-18 [End]
                                                                    
                                          'If Trim(lb_shift.Text) = "1" Then [11] Commented and Added by Gagan Kalyana on 2016-Feb-18
                                          If Trim(hdshift_C.Value.ToString) = "1" Then
                                              color_1 = "yellow"
                                          End If
                                          'If Trim(lb_shift.Text) = "2" Then     [11] Commented and Added by Gagan Kalyana on 2016-Feb-18
                                          If Trim(hdshift_C.Value.ToString) = "2" Then
                                              color_2 = "yellow"
                                          End If
                                          'If Trim(lb_shift.Text) = "3" Then     [11] Commented and Added by Gagan Kalyana on 2016-Feb-18
                                          If Trim(hdshift_C.Value.ToString) = "3" Then
                                              color_3 = "yellow"
                                          End If
                                          'If Trim(lb_shift.Text) = "4" Then     [11] Commented and Added by Gagan Kalyana on 2016-Feb-18
                                          If Trim(hdshift_C.Value.ToString) = "4" Then
                                              color_4 = "yellow"
                                          End If
                          
                                          rd = db.execReader(sql)
                                          While rd.Read()
                                              Dim _db As New Database
                                              Dim _rd As SqlDataReader
                                              Dim _sql As String
                                              Dim qty_1 As Integer = 0
                                              '[4] Commented by Govind on 2015-Mar-19 [Start]
                                              'Dim qty_2 As Integer = 0
                                              'Dim qty_3 As Integer = 0
                                              'Dim qty_4 As Integer = 0
                             
                                              
                                              'Dim _proty_1 As Double = 0.0
                                              'Dim _proty_2 As Double = 0.0
                                              'Dim _proty_3 As Double = 0.0
                                              'Dim _proty_4 As Double = 0.0
                                              '[4] Commented by Govind on 2015-Mar-19 [End]
                              
                                              Dim CD As String = ""
                                              If IsDBNull(rd("cusdesch_c1")) = False Then
                                                  '[4] Commented and added by Gagan Kalyana on 2016-Feb-18 
                                                  'CD = rd("cusdesch_c1") & "-" & rd("cusdesch_c2") & "-" & rd("Intdesch_c")
                                                  CD = Trim(rd("cusdesch_c1")) & "-" & Trim(rd("cusdesch_c2")) & "-" & Trim(rd("Intdesch_c"))
                                              End If
                                              If IsDBNull(rd("smh")) = False Then
                                                  smh = rd("smh")
                                              End If
                              
                                              _db.conecDB()
                                              _db.initCMD()
                              
                                              'Commented and Modified by Govind on 2015-Mar-19
                                              '_sql = "select a.plan_qty,a.shift_c,a.priority from production_plan as a "
                                              _sql = "select a.plan_qty from production_plan as a "
                                              _sql = _sql & "join  product_mst as b on a.factory_c=b.factory_c and a.product_no=b.product_no and a.cusdesch_c1=b.cusdesch_c1 and a.cusdesch_c2=b.cusdesch_c2 and a.intdesch_c=b.intdesch_c "
                                              _sql = _sql & "where a.factory_c='" & Request("factory") & "' and a.section_c='" & lb_section.Text & "' and a.line_c='" & lb_line_no.Text & "' and a.plan_qty>0 and a.work_date='" & lb_working_day.Text & "' and a.shift_c='" & rd("shift_c") & "' "
                                              _sql = _sql & "and a.product_no='" & rd("product_no") & "' and b.short_c='" & rd("short_c") & "' and a.cusdesch_c1='" & rd("cusdesch_c1") & "' and a.cusdesch_c2='" & rd("cusdesch_c2") & "' and  a.intdesch_c='" & rd("intdesch_c") & "' "
                                              _rd = _db.execReader(_sql)
                              
                                              While _rd.Read()
                                                  qty_1 = 0
                                                  qty_1 = _rd("plan_qty")   '[4] Added by Govind on 2015-Mar-19
                                                                                                    
                                                  ''[4] Commented by Govind on 2015-Mar-19 [Start]
                                                  'qty_2 = 0
                                                  'qty_3 = 0
                                                  'qty_4 = 0
                                                  
                                                  'Dim priority As Integer = 0
                                                  'If _rd("shift_c") = Trim(lb_shift.Text) Then
                                                  '    priority = _rd("priority")
                                                  'End If
                                                  'If _rd("shift_c") = "1" Then
                                                  '    qty_1 = _rd("plan_qty")
                                                  'End If
                                                  'If _rd("shift_c") = "2" Then
                                                  '    qty_2 = _rd("plan_qty")
                                                  'End If
                                                  'If _rd("shift_c") = "3" Then
                                                  '    qty_3 = _rd("plan_qty")
                                                  'End If
                                                  'If _rd("shift_c") = "4" Then
                                                  '    qty_4 = _rd("plan_qty")
                                                  'End If
                                                  ''[4] Commented by Govind on 2015-Mar-19 [End]
                                  
                                                  _tast_time = smh / _dman
                                                  _tast_time = _tast_time / (rd("proty_pl") / 100)
                                                  _tast_time = _tast_time * 3600
                                                  
                                                  '[4] Added by Gagan Kalyana on 2016-Feb-18 [Start]
                                                  Dim strWorkOrder As String =""
                                                  Dim _WorkOrderDB As New Database
                                                  Dim _WorkOrderRD As SqlDataReader
                                                  _WorkOrderDB.conecDB()
                                                  _WorkOrderDB.initCMD()
                                                          
                                                  _sql = "SELECT TOP 1 Order_No AS Order_No FROM ACS_Insp_Res "
                                                  _sql = _sql & "WHERE factory_c = '" & Request("factory") & "' AND line_c = '" & lb_line_no.Text & "' AND shift_st_dt = '" & lb_working_day.Text & "' AND shift = '" & rd("shift_c") & "' "
                                                  _sql = _sql & "AND product_no = '" & rd("product_no") & "' AND cusdesch_c1 = '" & rd("cusdesch_c1") & "' AND cusdesch_c2 = '" & rd("cusdesch_c2") & "' AND intdesch_c = '" & rd("intdesch_c") & "' "
                                                  _sql = _sql & "AND section_c = '" & lb_section.Text & "' ORDER BY Insp_Dt DESC"
                                                  _WorkOrderRD = _WorkOrderDB.execReader(_sql)
                              
                                                  While _WorkOrderRD.Read()
                                                      strWorkOrder = _WorkOrderRD("Order_No")
                                                  End While
                                                  _WorkOrderDB.closeDB()
                                                  _WorkOrderRD.Close()
                                                  '[4] Added by Gagan Kalyana on 2016-Feb-18 [End]                                                                    
                                        %>
                                      <tr>
                                        <td ><% Response.Write(rd("product_no").ToString)%></td>
                                        <%--[4] Added by Gagan Kalyana on 2016-Feb-18 --%>
                                        <td ><% Response.Write(CD)%></td>        
                                         <%--[4] Commented and Modified by Govind on 2015-Mar-19 [Start]
                                                      <td align="center"><% Response.Write(rd("short_c").ToString)%></td>
                                                    <td align="center"><% Response.Write(rd("circuit_no").ToString)%></td>--%>
                                                    <%--[4] Commented and Modified by Govind on 2015-Mar-19 [End]--%>
                                        <td align="center"><% Response.Write(Left(rd("smh"), 6).ToString)%></td>
                                        <td align="center"><% Response.Write(Fix(rd("proty_pl")).ToString)%></td>
                                        <td align="center"><% Response.Write(_tast_time.ToString("##,###0.0"))%></td>
                                        <%--[4] Commented and added by Gagan Kalyana on 2016-Feb-18 
                                        <td align="center"><% Response.Write(rd("asy_board").ToString)%></td>
                                        <td align="center"><% Response.Write(rd("circuit_board").ToString)%></td>--%>
                                        <td ><% Response.Write(strWorkOrder.ToString)%></td>
                                       <%--[4] Commented by Govind on 2015-Mar-19 [Start]
                                                    <td style="background:blue" align="center" >                     
                                                        <%
                                                        ''[4] Commented by Govind on 2015-Mar-19 [Start]
                                                        'If Trim(lb_shift.Text) = 1 Then
                                                        '    Response.Write(qty_1.ToString)
                                                        'End If
                                                        'If Trim(lb_shift.Text) = 2 Then
                                                        '    Response.Write(qty_2.ToString)
                                                        'End If
                                                        'If Trim(lb_shift.Text) = 3 Then
                                                        '    Response.Write(qty_3.ToString)
                                                        'End If
                                                        'If Trim(lb_shift.Text) = 4 Then
                                                        '    Response.Write(qty_4.ToString)
                                                        'End If
                                                       %>                             
                                                    </td>    
                                                    <td rowspan="1" align="center"><% Response.Write(priority.ToString)%></td>
                                                      [4] Commented by Govind on 2015-Mar-19 [End]--%>                   
                                      <%--[4] Added by Govind on 2015-Mar-19 [Start]--%>
                                                      <%
                                                          Dim ActQty As Integer = 0
                                                          Dim _Actdb As New Database
                                                          Dim _Actrd As SqlDataReader
                                                          _Actdb.conecDB()
                                                          _Actdb.initCMD()
                                                          
                                                          _sql = "select count(*) as total from ACS_insp_res "
                                                          _sql = _sql & "where factory_c='" & Request("factory") & "' and line_c='" & lb_line_no.Text & "' and shift_st_dt ='" & lb_working_day.Text & "' and shift='" & rd("shift_c") & "' "
                                                          '_sql = _sql & "and product_no='" & rd("product_no") & "' and cusdesch_c1='" & rd("cusdesch_c1") & "' and cusdesch_c2='" & rd("cusdesch_c2") & "' and intdesch_c='" & rd("intdesch_c") & "' "
                                                          _sql = _sql & "and product_no='" & rd("product_no") & "' and cusdesch_c1='" & rd("cusdesch_c1") & "' and cusdesch_c2='" & rd("cusdesch_c2") & "'"
                                                          _sql = _sql & "and section_c='" & lb_section.Text & "'"  '[FC] Added by Govind on 2015-Mar-19
                                                          _Actrd = _Actdb.execReader(_sql)
                              
                                                          While _Actrd.Read()
                                                              ActQty = _Actrd("total")
                                                          End While
                                                          _Actdb.closeDB()
                                                          _Actrd.Close()
                                                      %>
                                                      <%--Modified by Gagan Kalyana on 2015-Dec-17
                                                      <td style="background:blue" align="center" width="16%"><% Response.Write(qty_1.ToString)%></td>--%>
                                                      <td style="background:blue;color:white" align="center" width="9%"><% Response.Write(qty_1.ToString)%></td>
                                                      <td align="center" width="9%"><% Response.Write(ActQty.ToString)%></td>
                                                      <%--[4] Added by Govind on 2015-Mar-19 [End]--%>
                                                  </tr>                           
                                                  <%
                                                End While
                                                _db.closeDB()
                                                _rd.Close()
                                            End While
                                            db.closeDB()
                                            rd.Close()

                                            'Commented and Modified by SIS on 2016-May-26                                              
                                              Dim _sql1 As String
                                            Dim _AcsInspDB As New Database
                                            Dim _AcsInspRD As SqlDataReader

                                            _AcsInspDB.conecDB()
                                            _AcsInspDB.initCMD()
                                                  
                                              _sql1 = "SELECT 	AIR.line_c,AIR.product_no,AIR.cusdesch_c1, AIR.cusdesch_c2, AIR.intdesch_c, count(AIR.prodlbl_no)AS Result_Qty "
                                              _sql1 = _sql1 & "FROM ACS_insp_res AIR "
                                              _sql1 = _sql1 & "WHERE not exists (SELECT * "
                                              _sql1 = _sql1 & "		 			FROM  Production_plan PP "
                                              _sql1 = _sql1 & "		 			WHERE 	AIR.product_no = PP.product_no and "
                                              _sql1 = _sql1 & "		 			AIR.cusdesch_c1 = PP.cusdesch_c1 and "
                                              _sql1 = _sql1 & "		 			AIR.cusdesch_c2 = PP.cusdesch_c2 and "
                                              _sql1 = _sql1 & "		 			AIR.intdesch_c =  PP.intdesch_c  and "
                                              _sql1 = _sql1 & "		 			AIR.line_c = PP.line_c and "
                                              _sql1 = _sql1 & "		 			AIR.shift_st_dt = PP.work_date) and "
                                              _sql1 = _sql1 & "AIR.shift_st_dt = '" & lb_working_day.Text & "' and "
                                              _sql1 = _sql1 & "AIR.line_c = '" & lb_line_no.Text & "' "
                                              _sql1 = _sql1 & "GROUP BY	AIR.line_c, AIR.product_no, AIR.cusdesch_c1, AIR.cusdesch_c2, AIR.intdesch_c "
                                            
                                              _AcsInspRD = _AcsInspDB.execReader(_sql1)

                                            While _AcsInspRD.Read()%>
                                            <tr>
			                                    <td style="color:Red"><% Response.Write(_AcsInspRD("product_no").ToString)%></td>
			                                    <td style="color:Red"><% Response.Write(Trim(_AcsInspRD("cusdesch_c1")) & "-" & Trim(_AcsInspRD("cusdesch_c2")) & "-" & Trim(_AcsInspRD("intdesch_c")))%></td>        
			                                    <td></td>
			                                    <td></td>
			                                    <td></td>
			                                    <td></td>
			                                    <td></td>
			                                    <td align="center" style="color:Red" width="9%"> <% Response.Write(_AcsInspRD("Result_Qty").ToString)%> </td>
 		                                    </tr>
	                                    <%		                                            End While
	                                        _AcsInspDB.closeDB()
	                                        _AcsInspRD.Close()%>

                                </table> 
                            </asp:TableCell>
                        </asp:TableRow>
                      </asp:Table>
                    <!--end product plan-->                
                </asp:TableCell>
                <asp:TableCell ID="tablecel_left" runat="server" Width="730px">                    
                    <!--chart-->                    
                    <%--Modified by Gagan Kalyana on 2015-Dec-17       
                    <asp:Table ID="table_production" runat="server" Width="100%"  CellPadding="2" CellSpacing="2" CssClass="shifttable">--%>
                    <asp:Table ID="table_production" runat="server" Width="100%"  CellPadding="2" CellSpacing="2" CssClass="boxBorder">
                        <asp:TableRow ID="tablerow_production" runat="server" VerticalAlign="top">
                            <%--Modified by Gagan Kalyana on 2015-Dec-17
                            <asp:TableCell ID="tablecell_production" runat="server">--%>                             
                            <asp:TableCell ID="tablecell_production" runat="server" BackColor="#313131">                             
                                    <%--Modified by Gagan Kalyana on 2015-Apr-17 for Mouse Pointer Change to hand over Mouse Hover   
                                    <div class="fontshift_1">&nbsp;<%=ReadWriteXml.getAppResource("1071")%>&nbsp;<a href="Chart.aspx?factory=<% Response.Write(request("factory")) %>&se=<% Response.Write(lb_section.Text)%>&w=<% Response.Write(lb_working_day.Text)%>&l=<% Response.Write(lb_line_no.Text)%>&s=<% Response.Write(lb_shift.Text)%>&ah=<% Response.Write(lb_hour_act.Text)%>&cy=<% Response.Write(lb_cycle_time.Text)%>&ta=<% Response.Write(lb_tact_time.Text)%>&dm=<% Response.Write(_dman.Tostring)%>" style="color:white; font-size:14px;font-family:Tahoma"><%=ReadWriteXml.getAppResource("1072")%></a>&nbsp;&nbsp;&nbsp;<a onclick="_show_1_4();" style="background:#0000FF;color:white;font-weight:normal;font-size:14px;font-family:Tahoma;">&nbsp;<%=ReadWriteXml.getAppResource("1073")%>&nbsp;</a>&nbsp;&nbsp;&nbsp;<a href="#" style="color:white; font-size:14px;font-family:Tahoma"></a><a href="javascript:void(0)" class="selection" style="padding-right:3px;color:white"><%=ReadWriteXml.getAppResource("1192").ToString() %></a>/<a href="javascript:void(0)" class="selection" style="padding-left:3px;color:white"><%=ReadWriteXml.getAppResource("1070").ToString() %></a></div>      --%>
                                    <%--Commented and Added by Gagan Kalyana on 2015-May-13
                                    <div class="fontshift_1">&nbsp;<%=ReadWriteXml.getAppResource("1071")%>&nbsp;<a href="Chart.aspx?factory=<% Response.Write(request("factory")) %>&se=<% Response.Write(lb_section.Text)%>&w=<% Response.Write(lb_working_day.Text)%>&l=<% Response.Write(lb_line_no.Text)%>&s=<% Response.Write(lb_shift.Text)%>&ah=<% Response.Write(lb_hour_act.Text)%>&cy=<% Response.Write(lb_cycle_time.Text)%>&ta=<% Response.Write(lb_tact_time.Text)%>&dm=<% Response.Write(_dman.Tostring)%>" style="color:white; font-size:14px;font-family:Tahoma"><%=ReadWriteXml.getAppResource("1072")%></a>&nbsp;&nbsp;&nbsp;<a onclick="_show_1_4();" class="Link_Hover" style="background:#0000FF;color:white;font-weight:normal;font-size:14px;font-family:Tahoma;">&nbsp;<%=ReadWriteXml.getAppResource("1073")%>&nbsp;</a>&nbsp;&nbsp;&nbsp;<a href="#" style="color:white; font-size:14px;font-family:Tahoma"></a><a href="javascript:void(0)" class="selection" style="padding-right:3px;color:white"><%=ReadWriteXml.getAppResource("1192").ToString() %></a>/<a href="javascript:void(0)" class="selection" style="padding-left:3px;color:white"><%=ReadWriteXml.getAppResource("1070").ToString() %></a></div>--%>
                                <%--Modified by Gagan Kalyana on 2015-Dec-17
                                <div class="fontshift_1">&nbsp;<%=ReadWriteXml.getAppResource("1071")%>&nbsp;<a href="Chart.aspx?factory=<% Response.Write(request("factory")) %>&se=<% Response.Write(lb_section.Text)%>&w=<% Response.Write(lb_working_day.Text)%>&l=<% Response.Write(lb_line_no.Text)%>&s=<% Response.Write(lb_shift.Text)%>&ah=<% Response.Write(lb_hour_act.Text)%>&cy=<% Response.Write(lb_cycle_time.Text)%>&ta=<% Response.Write(lb_tact_time.Text)%>&dm=<% Response.Write(_dman.Tostring)%>" style="color:white; font-size:14px;font-family:Tahoma"><%=ReadWriteXml.getAppResource("1072")%></a>&nbsp;&nbsp;&nbsp;<a onclick="_show_1_4();" class="Link_Hover" style="background:#0000FF;color:white;font-weight:normal;font-size:14px;font-family:Tahoma;">&nbsp;<%=ReadWriteXml.getAppResource("1073")%>&nbsp;</a>&nbsp;&nbsp;&nbsp;<a href="#" style="color:white; font-size:14px;font-family:Tahoma"></a><a onclick="javascript:WriteCookie('G')" class="selection Link_Hover" style="padding-right:3px;color:white"><%=ReadWriteXml.getAppResource("1192").ToString() %></a>/<a onclick="javascript:WriteCookie('Q')" class="selection Link_Hover" style="padding-left: 3px; color: white"><%=ReadWriteXml.getAppResource("1070").ToString() %></a></div>    --%>
                                <%--[2] Modified by Gagan Kalyana on 2016-Feb-18 
                                <div class="fontshift_1">&nbsp;<%=ReadWriteXml.getAppResource("1071")%>&nbsp;<a href="Chart.aspx?factory=<% Response.Write(request("factory")) %>&se=<% Response.Write(lb_section.Text)%>&w=<% Response.Write(lb_working_day.Text)%>&l=<% Response.Write(lb_line_no.Text)%>&s=<% Response.Write(lb_shift.Text)%>&ah=<% Response.Write(lb_hour_act.Text)%>&cy=<% Response.Write(lb_cycle_time.Text)%>&ta=<% Response.Write(lb_tact_time.Text)%>&dm=<% Response.Write(_dman.Tostring)%>" style="color:white; font-size:14px;font-family:Tahoma"><%=ReadWriteXml.getAppResource("1072")%></a>&nbsp;&nbsp;&nbsp;<a onclick="_show_1_4();" class="Link_Hover linkLabel" style="font-weight:normal;">&nbsp;<%=ReadWriteXml.getAppResource("1073")%>&nbsp;</a>&nbsp;&nbsp;&nbsp;<a href="#" style="color:white; font-size:14px;font-family:Tahoma"></a><a onclick="javascript:WriteCookie('G')" class="selection Link_Hover" style="padding-right:3px;color:white"><%=ReadWriteXml.getAppResource("1192").ToString() %></a>/<a onclick="javascript:WriteCookie('Q')" class="selection Link_Hover" style="padding-left: 3px; color: white"><%=ReadWriteXml.getAppResource("1070").ToString() %></a></div>    --%>
                                <%--[6] & [7] Commented and Added By Gagan Kalyana on 2016-Feb-18
                                <div class="fontshift_1">&nbsp;<%=ReadWriteXml.getAppResource("1071")%>&nbsp;<a href="Chart.aspx?factory=<% Response.Write(request("factory")) %>&se=<% Response.Write(lb_section.Text)%>&w=<% Response.Write(lb_working_day.Text)%>&l=<% Response.Write(lb_line_no.Text)%>&s=<% Response.Write(lb_shift.Text)%>&ah=<% Response.Write(lb_hour_act.Text)%>&cy=<% Response.Write(lb_cycle_time.Text)%>&ta=<% Response.Write(lb_tact_time.Text)%>&dm=<% Response.Write(_dman.Tostring)%>" style="color:white; font-size:14px;font-family:Tahoma"><%=ReadWriteXml.getAppResource("1072")%></a>&nbsp;&nbsp;<a href="#" style="color:white; font-size:14px;font-family:Tahoma"></a><a onclick="javascript:WriteCookie('G')" class="selection Link_Hover" style="padding-right:3px;color:white"><%=ReadWriteXml.getAppResource("1192").ToString() %></a>/<a onclick="javascript:WriteCookie('Q')" class="selection Link_Hover" style="padding-left: 3px; color: white"><%=ReadWriteXml.getAppResource("1070").ToString() %></a></div>--%>
                                <%--[11] Commented and Added by Gagan Kalyana on 2016-Feb-18
                                <div class="fontshift_1" style="position:relative">&nbsp;<%=ReadWriteXml.getAppResource("1071")%>&nbsp;<a href="Chart.aspx?factory=<% Response.Write(request("factory")) %>&se=<% Response.Write(lb_section.Text)%>&w=<% Response.Write(lb_working_day.Text)%>&l=<% Response.Write(lb_line_no.Text)%>&s=<% Response.Write(lb_shift.Text)%>&ah=<% Response.Write(_dblWorking_hours_act.ToString)%>&cy=<% Response.Write(lb_cycle_time.Text)%>&ta=<% Response.Write(lb_tact_time.Text)%>&dm=<% Response.Write(_dman.Tostring)%>" style="color:white; font-size:14px;font-family:Tahoma"><%=ReadWriteXml.getAppResource("1072")%></a>&nbsp;&nbsp;<a href="#" style="color:white; font-size:14px;font-family:Tahoma"></a><a onclick="javascript:WriteCookie('G')" class="selection Link_Hover" style="padding-right:3px;color:white"><%=ReadWriteXml.getAppResource("1192").ToString() %></a>/<a onclick="javascript:WriteCookie('Q')" class="selection Link_Hover" style="padding-left: 3px; color: white"><%=ReadWriteXml.getAppResource("1070").ToString() %></a></div>--%>
                                <div class="fontshift_1" style="position:relative">&nbsp;<%=ReadWriteXml.getAppResource("1071")%>&nbsp;<a href="Chart.aspx?factory=<% Response.Write(request("factory")) %>&se=<% Response.Write(lb_section.Text)%>&w=<% Response.Write(lb_working_day.Text)%>&l=<% Response.Write(lb_line_no.Text)%>&s=<% Response.Write(hdshift_C.Value.ToString)%>&ah=<% Response.Write(_dblWorking_hours_act.ToString)%>&cy=<% Response.Write(lb_cycle_time.Text)%>&ta=<% Response.Write(lb_tact_time.Text)%>&dm=<% Response.Write(_dman.Tostring)%>" style="color:white; font-size:14px;font-family:Tahoma"><%=ReadWriteXml.getAppResource("1072")%></a>&nbsp;&nbsp;<a href="#" style="color:white; font-size:14px;font-family:Tahoma"></a><a onclick="javascript:WriteCookie('G')" class="selection Link_Hover" style="padding-right:3px;color:white"><%=ReadWriteXml.getAppResource("1192").ToString() %></a>/<a onclick="javascript:WriteCookie('Q')" class="selection Link_Hover" style="padding-left: 3px; color: white"><%=ReadWriteXml.getAppResource("1070").ToString() %></a><label runat="server" id="lblRealEff" style="color:white;float:right;position:absolute;top:25px;right:100px;z-index:1;">0 %</label><% If (CInt(_BaseonTargetofline - _actualCount) > CInt(_BaseonTargetofline * (dblJudgementRate / 100))) Then%><img style="float:right;position:absolute;top:20px;right:15px;z-index:1;" src="image/NG.png" width="35px" height="35px" /><% Else %><img style="float:right;position:absolute;top:20px;right:15px;z-index:1;" src="image/OK.png" width="35px" height="35px" /><%End If%></div>    
                                   <%--'Added by Gagan Kalyana on 2015-Apr-06[Start] --%>
                                <div id="dvChart" style="display: block; position:relative">
                                    <asp:panel runat="server"  id="paaa" style="color:red ;position: absolute; width: 620px; z-index: 500; top: 175px; left: 57px;" ></asp:panel> 
                                    <%--'Added by Gagan Kalyana on 2015-Apr-06[End]--%>
                                    <asp:Chart ID="Chart1" runat="server" Height="280px" Width="700px" BackColor="#313131">
                                            <Series></Series>
                                            <ChartAreas>
                                                <asp:ChartArea Name="ChartArea1" BackColor="#313131"></asp:ChartArea>
                                            </ChartAreas>
                                             <Legends>
                                                <asp:Legend Name="Standard" BackColor="#313131" ForeColor="white"></asp:Legend>
                                            </Legends>
                                    </asp:Chart>
                                <%--'Added by Gagan Kalyana on 2015-Apr-06[Start]--%>
                                </div>
                                <div id="dvQty" style="display: none; height: 283px; width: 700px;">
                                    <%--[11] Commented and Added by Gagan Kalyana on 2015-Feb-19
                                    <table cellpadding="6" cellspacing="0" border="0" class="qtytable" style=>--%>
                                    <table cellpadding="6" cellspacing="0" border="0" class="qtytable" style="margin-top:30px">
                                        <tr>
                                             <%--'Commented and added by Gagan Kalyana on 2015-May-13 [Start]--%>
                                            <%--<td style="width:50%"><%=ReadWriteXml.getAppResource("1189").ToString()%></td>
                                            <td style="text-align:right;" ><% Response.Write(Math.Ceiling(_BaseonTargetofline).ToString)%></td>
                                        </tr>
                                        <tr>
                                            <td style="width:50%"><%=ReadWriteXml.getAppResource("1190").ToString()%></td>
                                            <td style="text-align:right;"><% Response.Write(_actualCount.ToString)%></td>
                                        </tr>
                                        <tr>
                                            <td style="width:50%"><%=ReadWriteXml.getAppResource("1191").ToString() %></td>
                                            <td style="text-align:right;"><% Response.Write(_defectCount.ToString)%></td>--%>
                                            
                                            <td style="width:50%;font-size:50px;color:white"><%=ReadWriteXml.getAppResource("1189").ToString()%></td>
                                             <%--'Commented and added by Gagan Kalyana on 2015-May-15--%>
                                            <%--<td style="text-align:right;font-size:50px;" ><% Response.Write(Math.Ceiling(_BaseonTargetofline).ToString)%></td>--%>
                                            <td style="text-align:right;font-size:50px;color:white" ><% Response.Write(Math.Round(_BaseonTargetofline).ToString)%></td>
                                        </tr>
                                        <tr>
                                            <td style="width:50%;font-size:50px;color:white"><%=ReadWriteXml.getAppResource("1190").ToString()%></td>
                                            <td style="text-align:right;font-size:50px;color:white"><% Response.Write(_actualCount.ToString)%></td>
                                        </tr>
                                        <tr>
                                            <td style="width:50%;font-size:50px;color:white"><%=ReadWriteXml.getAppResource("1191").ToString() %></td>
                                            <td style="text-align:right;font-size:50px;color:white"><% Response.Write(_defectCount.ToString)%></td>
                                     <%--'Commented and added by Gagan Kalyana on 2015-May-13 [End]--%>
                                        </tr>
                                    </table>
                                </div>
                                 <%--'Added by Gagan Kalyana on 2015-Apr-06[End]--%>
                            </asp:TableCell>
                        </asp:TableRow>
                    </asp:Table>                    
                    <!--end chart--> 
                    <%--'Added by Gagan Kalyana on 2015-Apr-06[Start]--%>
                    <script type="text/javascript">
                        <%--'Added by Gagan Kalyana on 2015-May-13 [Start]--%>
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
                        <%--'Added by Gagan Kalyana on 2015-May-13 [End]--%>
                        $(document).ready(function () {
                             <%--'Added by Gagan Kalyana on 2015-May-13 [Start]--%>
                            var user = getCookie("name");
                            if (user != "" && user == "Q") {
                                $("#dvQty").show();
                                $("#dvChart").hide();
                            } else {
                                document.cookie = "name=" + "G";
                                $("#dvQty").hide();
                                $("#dvChart").show();
                            }
                            <%--'Added by Gagan Kalyana on 2015-May-13 [End]--%>

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
                    </script>
                    <%--'Added by Gagan Kalyana on 2015-Apr-06[End]--%>
                    <div class="fontshift_1" style="margin:5px 5px 5px 5px;"></div>
                    <!-- change point-->
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td  width="430px">
                            <%--Modified by Gagan Kalyana on 2015-Dec-17
                            <table width="100%" cellspacing="0" cellpadding="2" class="shifttable_2">--%>
                            <table width="100%" cellspacing="0" cellpadding="2" class="shifttable">
				              <tr bgcolor="gray">
                                <%--Commneted and added by Gagan Kalyana on 2015-May-08 [Start]
					            <td width="30%"> <div class="fontshift_1"><%=ReadWriteXml.getAppResource("1074")%></div> </td>
					            <td width="10%"><div align="center" style="font-size:smaller;font-size:9px;">&nbsp;<%=ReadWriteXml.getAppResource("1075")%>&nbsp;</div></td>
					            <td width="10%"><div align="center" style="font-size:smaller;font-size:9px;"><%=ReadWriteXml.getAppResource("1076")%></div></td>
					            <td width="10%"><div align="center" style="font-size:smaller;font-size:9px;"><%=ReadWriteXml.getAppResource("1077")%></div></td>
					            <td width="10%"><div align="center" style="font-size:smaller;font-size:9px;"><%=ReadWriteXml.getAppResource("1078")%></div></td>
					            <td width="10%"><div align="center" style="font-size:smaller;font-size:9px;"><%=ReadWriteXml.getAppResource("1079")%></div></td>
					            <td width="10%"><div align="center" style="font-size:smaller;font-size:9px;"><%=ReadWriteXml.getAppResource("1080")%></div></td>
					            <td width="10%"><div align="center" style="font-size:smaller;font-size:9px;"><%=ReadWriteXml.getAppResource("1081")%></div></td>--%>
				              <%--Commneted and added by Gagan Kalyana on 2015-May-18
                                <td width="25%"> <div class="fontshift_1"><%=ReadWriteXml.getAppResource("1074")%></div> </td>
					            <td width="5%"><div align="center" style="font-size:smaller;font-size:9px;">&nbsp;<%=ReadWriteXml.getAppResource("1075")%>&nbsp;</div></td>--%>
                                <%--Modified by Gagan Kalyana on 2015-Dec-17 [Start]
					            <td width="22%"> <div class="fontshift_1"><%=ReadWriteXml.getAppResource("1074")%></div> </td>
					            <td width="8%"><div align="center" style="font-size:smaller;font-size:9px;">&nbsp;<%=ReadWriteXml.getAppResource("1075")%>&nbsp;</div></td>
                                <td width="8%"><div align="center" style="font-size:smaller;font-size:9px;"><%=ReadWriteXml.getAppResource("1076")%></div></td>
					            <td width="13%"><div align="center" style="font-size:smaller;font-size:9px;"><%=ReadWriteXml.getAppResource("1077")%></div></td>
					            <td width="13%"><div align="center" style="font-size:smaller;font-size:9px;"><%=ReadWriteXml.getAppResource("1078")%></div></td>
					            <td width="13%"><div align="center" style="font-size:smaller;font-size:9px;"><%=ReadWriteXml.getAppResource("1079")%></div></td>
					            <td width="10%"><div align="center" style="font-size:smaller;font-size:9px;"><%=ReadWriteXml.getAppResource("1080")%></div></td>
					            <td width="13%"><div align="center" style="font-size:smaller;font-size:9px;"><%=ReadWriteXml.getAppResource("1081")%></div></td>--%>
                                <%--Commneted and added by Gagan Kalyana on 2015-May-08 [End]--%>


                                <%--
                                <th width="22%"> <div align="left"><%=ReadWriteXml.getAppResource("1074")%></div> </th>
					            <th width="8%"><div align="center" style="color:white;font-size:smaller;font-size:9px;">&nbsp;<%=ReadWriteXml.getAppResource("1075")%>&nbsp;</div></th>
                                <th width="8%"><div align="center" style="color:white;font-size:smaller;font-size:9px;"><%=ReadWriteXml.getAppResource("1076")%></div></th>
					            <th width="13%"><div align="center" style="color:white;font-size:smaller;font-size:9px;"><%=ReadWriteXml.getAppResource("1077")%></div></th>
					            <th width="13%"><div align="center" style="color:white;font-size:smaller;font-size:9px;"><%=ReadWriteXml.getAppResource("1078")%></div></th>
					            <th width="13%"><div align="center" style="color:white;font-size:smaller;font-size:9px;"><%=ReadWriteXml.getAppResource("1079")%></div></th>
					            <th width="10%"><div align="center" style="color:white;font-size:smaller;font-size:9px;"><%=ReadWriteXml.getAppResource("1080")%></div></th>
					            <th width="13%"><div align="center" style="color:white;font-size:smaller;font-size:9px;"><%=ReadWriteXml.getAppResource("1081")%></div></th>
                                --%>  
                                <%--Commneted and added by SIS on 2017-Jun-13 [START]--%>
                                <%                                   
                                    Dim db As New Database
                                    Dim rd As SqlDataReader
                                    Dim sql As String
                                    Dim ProcName As String() = {"-", "-", "-", "-", "-", "-", "-"}

                                    Dim i As Integer
                                    
                                    db.conecDB()
                                    db.initCMD()
                                    
                                    sql = "SELECT Data_nm FROM DicData_mst WHERE (Class = '4M1')"
                                    rd = db.execReader(sql)
                                    i = 0
                                    While rd.Read()
                                        ProcName(i) = rd("Data_nm").ToString
                                        i = i + 1
                                    End While
                                    db.closeDB()
                                    rd.Close()
                                %>
                                    
                                <th width="16%"> <div align="left"><%=ReadWriteXml.getAppResource("1074")%></div> </th>
					            <th width="12%"><div align="center" style="color:white;font-size:smaller;font-size:9px;">&nbsp;<% Response.Write(ProcName(0).ToString)%>&nbsp;</div></th>
                                <th width="12%"><div align="center" style="color:white;font-size:smaller;font-size:9px;"><% Response.Write(ProcName(1).ToString)%></div></th>
					            <th width="12%"><div align="center" style="color:white;font-size:smaller;font-size:9px;"><% Response.Write(ProcName(2).ToString)%></div></th>
					            <th width="12%"><div align="center" style="color:white;font-size:smaller;font-size:9px;"><% Response.Write(ProcName(3).ToString)%></div></th>
					            <th width="12%"><div align="center" style="color:white;font-size:smaller;font-size:9px;"><% Response.Write(ProcName(4).ToString)%></div></th>
					            <th width="12%"><div align="center" style="color:white;font-size:smaller;font-size:9px;"><% Response.Write(ProcName(5).ToString)%></div></th>
					            <th width="12%"><div align="center" style="color:white;font-size:smaller;font-size:9px;"><% Response.Write(ProcName(6).ToString)%></div></th>

                                <%--Commneted and added by SIS on 2016-Nov-23 [End]--%>
                                <%--Commneted and added by SIS on 2017-Jun-13 [End]--%>

                                <%--Modified by Gagan Kalyana on 2015-Dec-17 [End]--%>
                              </tr>
                              <%
                                  'Dim db As New Database
                                  'Dim rd As SqlDataReader
                                  'Dim sql As String
                             Dim m(4, 7) As String
                             Dim color(4, 7) As String
                                  'Dim i As Integer
                             For i = 0 To 6
                                 m(0, i) = "0"
                                 color(0, i) = ""
                                 m(1, i) = "0"
                                 color(1, i) = ""
                                 m(2, i) = "0"
                                 color(2, i) = ""
                                 m(3, i) = "0"
                                 color(3, i) = ""
                             Next
                             db.conecDB()
                             db.initCMD()
                                  sql = "select a.data_c from ChangePoint_data as a  "
                                  '     [11] Commented and Added by Gagan Kalyana on 2016-Feb-18
                                  'sql = sql & "where a.factory_c='" & Request("factory") & "' and a.line_c='" & lb_line_no.Text & "' and a.shift_c='" & lb_shift.Text & "' and a.section_c='" & lb_section.Text & "' and a.work_date='" & lb_working_day.Text & "' "
                                  sql = sql & "where a.factory_c='" & Request("factory") & "' and a.line_c='" & lb_line_no.Text & "' and a.shift_c='" & hdshift_C.Value.ToString & "' and a.section_c='" & lb_section.Text & "' and a.work_date='" & lb_working_day.Text & "' "
                             sql = sql & "and a.data_des<>'' order by a.upd_dt"
                             rd = db.execReader(sql)
                             While rd.Read()
                                 If Left(rd("data_c").ToString, 3) = "4M1" Then
                                     If Right(rd("data_c").ToString, 2) = "01" Then
                                         m(0, 0) = "c"
                                         color(0, 0) = "Red"
                                     End If
                                     If Right(rd("data_c").ToString, 2) = "02" Then
                                         m(0, 1) = "c"
                                         color(0, 1) = "Red"
                                     End If
                                     If Right(rd("data_c").ToString, 2) = "03" Then
                                         m(0, 2) = "c"
                                         color(0, 2) = "Red"
                                     End If
                                     If Right(rd("data_c").ToString, 2) = "04" Then
                                         m(0, 3) = "c"
                                         color(0, 3) = "Red"
                                     End If
                                     If Right(rd("data_c").ToString, 2) = "05" Then
                                         m(0, 4) = "c"
                                         color(0, 4) = "Red"
                                     End If
                                     If Right(rd("data_c").ToString, 2) = "06" Then
                                         m(0, 5) = "c"
                                         color(0, 5) = "Red"
                                     End If
                                     If Right(rd("data_c").ToString, 2) = "07" Then
                                         m(0, 6) = "c"
                                         color(0, 6) = "Red"
                                     End If
                                 End If
                                 If Left(rd("data_c").ToString, 3) = "4M2" Then
                                     If Right(rd("data_c").ToString, 2) = "01" Then
                                         m(1, 0) = "c"
                                         color(1, 0) = "Red"
                                     End If
                                     If Right(rd("data_c").ToString, 2) = "02" Then
                                         m(1, 1) = "c"
                                         color(1, 1) = "Red"
                                     End If
                                     If Right(rd("data_c").ToString, 2) = "03" Then
                                         m(1, 2) = "c"
                                         color(1, 2) = "Red"
                                     End If
                                     If Right(rd("data_c").ToString, 2) = "04" Then
                                         m(1, 3) = "c"
                                         color(1, 3) = "Red"
                                     End If
                                     If Right(rd("data_c").ToString, 2) = "05" Then
                                         m(1, 4) = "c"
                                         color(1, 4) = "Red"
                                     End If
                                     If Right(rd("data_c").ToString, 2) = "06" Then
                                         m(1, 5) = "c"
                                         color(1, 5) = "Red"
                                     End If
                                     If Right(rd("data_c").ToString, 2) = "07" Then
                                         m(1, 6) = "c"
                                         color(1, 6) = "Red"
                                     End If
                                 End If
                                 If Left(rd("data_c").ToString, 3) = "4M3" Then
                                     If Right(rd("data_c").ToString, 2) = "01" Then
                                         m(2, 0) = "c"
                                         color(2, 0) = "Red"
                                     End If
                                     If Right(rd("data_c").ToString, 2) = "02" Then
                                         m(2, 1) = "c"
                                         color(2, 1) = "Red"
                                     End If
                                     If Right(rd("data_c").ToString, 2) = "03" Then
                                         m(2, 2) = "c"
                                         color(2, 2) = "Red"
                                     End If
                                     If Right(rd("data_c").ToString, 2) = "04" Then
                                         m(2, 3) = "c"
                                         color(2, 3) = "Red"
                                     End If
                                     If Right(rd("data_c").ToString, 2) = "05" Then
                                         m(2, 4) = "c"
                                         color(2, 4) = "Red"
                                     End If
                                     If Right(rd("data_c").ToString, 2) = "06" Then
                                         m(2, 5) = "c"
                                         color(2, 5) = "Red"
                                     End If
                                     If Right(rd("data_c").ToString, 2) = "07" Then
                                         m(2, 6) = "c"
                                         color(2, 6) = "Red"
                                     End If
                                 End If
                                 If Left(rd("data_c").ToString, 3) = "4M4" Then
                                     If Right(rd("data_c").ToString, 2) = "01" Then
                                         m(3, 0) = "c"
                                         color(3, 0) = "Red"
                                     End If
                                     If Right(rd("data_c").ToString, 2) = "02" Then
                                         m(3, 1) = "c"
                                         color(3, 1) = "Red"
                                     End If
                                     If Right(rd("data_c").ToString, 2) = "03" Then
                                         m(3, 2) = "c"
                                         color(3, 2) = "Red"
                                     End If
                                     If Right(rd("data_c").ToString, 2) = "04" Then
                                         m(3, 3) = "c"
                                         color(3, 3) = "Red"
                                     End If
                                     If Right(rd("data_c").ToString, 2) = "05" Then
                                         m(3, 4) = "c"
                                         color(3, 4) = "Red"
                                     End If
                                     If Right(rd("data_c").ToString, 2) = "06" Then
                                         m(3, 5) = "c"
                                         color(3, 5) = "Red"
                                     End If
                                     If Right(rd("data_c").ToString, 2) = "07" Then
                                         m(3, 6) = "c"
                                         color(3, 6) = "Red"
                                     End If
                                 End If
                             End While
                             db.closeDB()
                             rd.Close()
                              %>
				              <tr>
                                <%--Modified by Gagan Kalyana on 2015-Dec-17
					            <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1082")%></div></td>--%>
                                <td><div><%=ReadWriteXml.getAppResource("1082")%></div></td>
					            <td style="background-color:<% Response.Write(color(0, 0).ToString) %>"><div align="center"><% Response.Write(m(0, 0).ToString)%></div></td>
					            <td style="background-color:<% Response.Write(color(0, 1).ToString) %>"><div align="center"><% Response.Write(m(0, 1).ToString)%></div></td>
					            <td style="background-color:<% Response.Write(color(0, 2).ToString) %>"><div align="center"><% Response.Write(m(0, 2).ToString)%></div></td>
					            <td style="background-color:<% Response.Write(color(0, 3).ToString) %>"><div align="center"><% Response.Write(m(0, 3).ToString)%></div></td>
					            <td style="background-color:<% Response.Write(color(0, 4).ToString) %>"><div align="center"><% Response.Write(m(0, 4).ToString)%></div></td>
					            <td style="background-color:<% Response.Write(color(0, 5).ToString) %>"><div align="center"><% Response.Write(m(0, 5).ToString)%></div></td>
					            <td style="background-color:<% Response.Write(color(0, 6).ToString) %>"><div align="center"><% Response.Write(m(0, 6).ToString)%></div></td>
				              </tr>
				              <tr>
                                <%--Modified by Gagan Kalyana on 2015-Dec-17
					            <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1083")%></div></td>--%>
                                <td><div ><%=ReadWriteXml.getAppResource("1083")%></div></td>
					            <td style="background-color:<% Response.Write(color(1, 0).ToString) %>"><div align="center"><% Response.Write(m(1, 0).ToString)%></div></td>
					            <td style="background-color:<% Response.Write(color(1, 1).ToString) %>"><div align="center"><% Response.Write(m(1, 1).ToString)%></div></td>
					            <td style="background-color:<% Response.Write(color(1, 2).ToString) %>"><div align="center"><% Response.Write(m(1, 2).ToString)%></div></td>
					            <td style="background-color:<% Response.Write(color(1, 3).ToString) %>"><div align="center"><% Response.Write(m(1, 3).ToString)%></div></td>
					            <td style="background-color:<% Response.Write(color(1, 4).ToString) %>"><div align="center"><% Response.Write(m(1, 4).ToString)%></div></td>
					            <td style="background-color:<% Response.Write(color(1, 5).ToString) %>"><div align="center"><% Response.Write(m(1, 5).ToString)%></div></td>
					            <td style="background-color:<% Response.Write(color(1, 6).ToString) %>"><div align="center"><% Response.Write(m(1, 6).ToString)%></div></td>
				              </tr>
				              <tr>
                                <%--Modified by Gagan Kalyana on 2015-Dec-17
					            <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1084")%></div></td>--%>
                                <td><div><%=ReadWriteXml.getAppResource("1084")%></div></td>
					            <td style="background-color:<% Response.Write(color(2, 0).ToString) %>"><div align="center"><% Response.Write(m(2, 0).ToString)%></div></td>
					            <td style="background-color:<% Response.Write(color(2, 1).ToString) %>"><div align="center"><% Response.Write(m(2, 1).ToString)%></div></td>
					            <td style="background-color:<% Response.Write(color(2, 2).ToString) %>"><div align="center"><% Response.Write(m(2, 2).ToString)%></div></td>
					            <td style="background-color:<% Response.Write(color(2, 3).ToString) %>"><div align="center"><% Response.Write(m(2, 3).ToString)%></div></td>
					            <td style="background-color:<% Response.Write(color(2, 4).ToString) %>"><div align="center"><% Response.Write(m(2, 4).ToString)%></div></td>
					            <td style="background-color:<% Response.Write(color(2, 5).ToString) %>"><div align="center"><% Response.Write(m(2, 5).ToString)%></div></td>
					            <td style="background-color:<% Response.Write(color(2, 6).ToString) %>"><div align="center"><% Response.Write(m(2, 6).ToString)%></div></td>
				              </tr>
				              <tr>
                                <%--Modified by Gagan Kalyana on 2015-Dec-17
					            <td><div class="fontshift"><%=ReadWriteXml.getAppResource("1085")%></div></td>--%>
                                <td><div><%=ReadWriteXml.getAppResource("1085")%></div></td>
					            <td style="background-color:<% Response.Write(color(3, 0).ToString) %>"><div align="center"><% Response.Write(m(3, 0).ToString)%></div></td>
					            <td style="background-color:<% Response.Write(color(3, 1).ToString) %>"><div align="center"><% Response.Write(m(3, 1).ToString)%></div></td>
					            <td style="background-color:<% Response.Write(color(3, 2).ToString) %>"><div align="center"><% Response.Write(m(3, 2).ToString)%></div></td>
					            <td style="background-color:<% Response.Write(color(3, 3).ToString) %>"><div align="center"><% Response.Write(m(3, 3).ToString)%></div></td>
					            <td style="background-color:<% Response.Write(color(3, 4).ToString) %>"><div align="center"><% Response.Write(m(3, 4).ToString)%></div></td>
					            <td style="background-color:<% Response.Write(color(3, 5).ToString) %>"><div align="center"><% Response.Write(m(3, 5).ToString)%></div></td>
					            <td style="background-color:<% Response.Write(color(3, 6).ToString) %>"><div align="center"><% Response.Write(m(3, 6).ToString)%></div></td>
				              </tr>
				            </table> 
                        </td>
                        <td>
                            <%--Modified by Gagan Kalyana on 2015-Dec-17
                            <div style="border:1px solid #FFCC99;width:98%; margin-left:3px;height:116px;">--%>
                                <div style="border:1px solid #FFCC99;width:98%; margin-left:3px;height:114px;background: #313131;">
                              <%--[6] Commented and Modified by Govind on 2015-Mar-19 [Start]--%>
                              <%--<div class="fontshift_1" style="margin:5px 5px 5px 5px;"><%=ReadWriteXml.getAppResource("1086")%></div>--%>
                                <%--Modified by Gagan Kalyana on 2015-Dec-17
                                <div class="fontshift_1" style="margin:5px 5px 5px 5px;">--%>
                                <div style="margin:5px 5px 5px 5px;">
                                  <table width="100%" height="100%"  border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <%--Modified by Gagan Kalyana on 2015-Dec-17
                                        <td width="50%" align="left"><%=ReadWriteXml.getAppResource("1086")%></td>--%>
                                        <td width="55%" align="left"><div style="font-weight:bold;width:inherit" class="orangeLabel"><%=ReadWriteXml.getAppResource("1086")%></div></td>
                                        <%--Modified by Gagan Kalyana on 2015-Apr-17 for Mouse Pointer Change to hand over Mouse Hover
                                        <td width="50%" align="left"><a onclick="_show_1_3();" style="background:#0000FF;color:white;font-size:14px;font-family:Tahoma;">&nbsp;<%=ReadWriteXml.getAppResource("1088")%>&nbsp;</a></td>--%>
                                        <%--Modified by Gagan Kalyana on 2015-Dec-17
                                        <td width="50%" align="left"><a onclick="_show_1_3();" class="Link_Hover" style="background:#0000FF;color:white;font-size:14px;font-family:Tahoma;font-weight:normal">&nbsp;<%=ReadWriteXml.getAppResource("1088")%>&nbsp;</a></td>--%>
                                        <%--[2] Modified by Gagan Kalyana on 2016-Feb-18 
                                        <td width="50%" align="left"><a onclick="_show_1_3();" class="Link_Hover linkLabel">&nbsp;<%=ReadWriteXml.getAppResource("1088")%>&nbsp;</a></td>--%>
                                        <td width="50%" align="left"><a target="_black" href="DowntimeDetails.aspx?factory_c=<%Response.Write(Request("factory").ToString)%>&section_c=<%Response.Write(Request("section").ToString)%>&line_c=<%Response.Write(Request("line").ToString)%>&shift=<%Response.Write(hdshift_C.Value.ToString)%>&wk=<%Response.Write(lb_working_day.Text)%>" class="Link_Hover linkLabel">&nbsp;<%=ReadWriteXml.getAppResource("1088")%>&nbsp;</a></td>
                                      </tr>
                                    </table>
                                </div>
                                <%--[6] Commented and Modified by Govind on 2015-Mar-19 [End]--%>                                   
                                    <%
                                    Dim _color As String = "White"
                                        'Dim db As New Database
                                        'Dim rd As SqlDataReader
                                        'Dim sql As String
                                    Dim _ratio As Double = 0.0
                                    Dim _work_time_act As String = "0.0"
                                    Dim _work_ratio As String = "0.0"
                                        
                                        '[6] Commented and Added By Gagan Kalyana on 2016-Feb-18 [Start]
                                        'If (IsNumeric(lb_hour_act.Text) = True) Then
                                        '    _work_time_act = lb_hour_act.Text
                                        'End If
                                        If (IsNumeric(_dblWorking_hours_act) = True) Then
                                            _work_time_act = _dblWorking_hours_act.ToString
                                        End If
                                        '[6] Commented and Added By Gagan Kalyana on 2016-Feb-18 [End]
                                        
                                        If (IsNumeric(lb_downtime_ratio.Text) = True) Then
                                            _work_ratio = lb_downtime_ratio.Text
                                        End If
                                        db.conecDB()
                                        db.initCMD()
                                    
                                        ''Commented and Added by SIS on 2016-Oct-20 [START]
                                        If Format$(CDate(Request("WK")), "yyyy-MM-dd") = Format$(CDate(lb_working_day.Text), "yyyy-MM-dd") Then
                                        
                                            sql = "select sum(convert(int,a.duration)) as duration from LineShift_downtime_act as a "
                                            '[11] Commented and Added by Gagan Kalyana on 2016-Feb-18
                                            'sql = sql & "where a.factory_c='" & Request("factory") & "' and a.line_c='" & lb_line_no.Text & "' and a.shift_c='" & lb_shift.Text & "' and a.section_c='" & lb_section.Text & "' and a.work_date='" & lb_working_day.Text & "' and a.status_flg<>'0' "
                                            sql = sql & "where a.factory_c='" & Request("factory") & "' and a.line_c='" & lb_line_no.Text & "' and a.shift_c='" & hdshift_C.Value.ToString & "' and a.section_c='" & lb_section.Text & "' and a.work_date='" & lb_working_day.Text & "' and a.status_flg<>'0' "
                                            sql = sql & "and a.stop_En <= GETDATE()"                          '[9] Added By Gagan Kalyana on 2016-Feb-18
                                            rd = db.execReader(sql)
                                            While rd.Read()
                                                If IsDBNull(rd("duration")) = False Then
                                                    _ratio = System.Math.Round(rd("duration") / 3600, 5)
                                                End If
                                            End While
                                            db.conecDB()
                                            rd.Close()
                                        
                                            '[11] Added by Gagan Kalyana on 2016-Feb-18 [Start]
                                            db.conecDB()
                                            db.initCMD()
                                    
                                            sql = "select DATEDIFF(second, CAST(a.stop_st AS TIME), CAST(GETDATE() AS TIME)) as duration from LineShift_downtime_act as a "
                                            sql = sql & "where a.factory_c='" & Request("factory") & "' and a.line_c='" & lb_line_no.Text & "' and a.shift_c='" & hdshift_C.Value.ToString & "' and a.section_c='" & lb_section.Text & "' and a.work_date='" & lb_working_day.Text & "' and a.status_flg<>'0' "
                                            sql = sql & "and CAST(GETDATE() AS TIME) between CAST(a.stop_st AS TIME) and CAST(a.stop_En AS TIME)"
                                            rd = db.execReader(sql)
                                            While rd.Read()
                                                If IsDBNull(rd("duration")) = False Then
                                                    _ratio = _ratio + System.Math.Round(rd("duration") / 3600, 5)
                                                End If
                                            End While
                                            db.conecDB()
                                            rd.Close()
                                        
                                            ''Commented and Added by SIS on 2016-Oct-20 [START]
                                            Dim dblWorkingTime As Double = 0
                                            dblWorkingTime = getWorkingTime(Request("factory"), Request("section"), Request("line"), hdshift_C.Value.ToString, lb_working_day.Text)
                                            _work_time_act = dblWorkingTime.ToString
                                        
                                        Else
                                        
                                            sql = "select sum(convert(int,a.duration)) as duration from LineShift_downtime_act as a "
                                            sql = sql & "where a.factory_c='" & Request("factory") & "' and a.line_c='" & lb_line_no.Text & "' and a.shift_c='" & hdshift_C.Value.ToString & "' and a.section_c='" & lb_section.Text & "' and a.work_date='" & lb_working_day.Text & "' and a.status_flg<>'0' "
                                            rd = db.execReader(sql)
                                            While rd.Read()
                                                If IsDBNull(rd("duration")) = False Then
                                                    _ratio = System.Math.Round(rd("duration") / 3600, 5)
                                                End If
                                            End While

                                            db.conecDB()
                                            rd.Close()
                                        
                                            db.conecDB()
                                            db.initCMD()
                                    
                                            sql = "select DATEDIFF(second, CAST(a.stop_st AS TIME), CAST(GETDATE() AS TIME)) as duration from LineShift_downtime_act as a "
                                            sql = sql & "where a.factory_c='" & Request("factory") & "' and a.line_c='" & lb_line_no.Text & "' and a.shift_c='" & hdshift_C.Value.ToString & "' and a.section_c='" & lb_section.Text & "' and a.work_date='" & lb_working_day.Text & "' and a.status_flg<>'0' "
                                            sql = sql & "and CAST(GETDATE() AS TIME) between CAST(a.stop_st AS TIME) and CAST(a.stop_En AS TIME)"
                                            rd = db.execReader(sql)
                                            While rd.Read()
                                                If IsDBNull(rd("duration")) = False Then
                                                    _ratio = _ratio + System.Math.Round(rd("duration") / 3600, 5)
                                                End If
                                            End While
                                            db.conecDB()
                                            rd.Close()
                                            Dim dblWorkingTime As Double = 0
                                            dblWorkingTime = getPastWorkingTime(Request("factory"), Request("section"), Request("line"), hdshift_C.Value.ToString, lb_working_day.Text)

                                            _work_time_act = dblWorkingTime.ToString
                                    
                                        End If
                                        
                                        '[11] Added by Gagan Kalyana on 2016-Feb-18 [End]
                                        ''Added by Gagan Kalyana on 2016-Apr-04 [Start]
                                        'Dim dblWorkingTime As Double = getWorkingTime(Request("factory"), Request("section"), Request("line"), hdshift_C.Value.ToString, lb_working_day.Text)
                                        ''Added by Gagan Kalyana on 2016-Apr-04 [End]
                                        ''Commented and Added by SIS on 2016-Oct-20 [END]
                                        
                                        Dim _ratio_pl As Double = System.Math.Round((CDbl(_work_ratio) * CDbl(_work_time_act)) / 100, 2)
                                        Dim _ratio_act As Double = System.Math.Round((_ratio * 100) / CDbl(_work_time_act), 2)
                                        
                                        If (_ratio <= _ratio_pl) Then
                                        Else
                                            _color = "Red"
                                        End If
                                    %>
                                    <%--[6] Commented and Modified by Govind on 2015-Mar-19 [Start]
                                    <table width="99%" border="0" cellspacing="0" cellpadding="1">
                                      <tr>
                                        <td height="42px;"><div align="center" style="font-size:large;color:<% Response.Write(_color) %>;"><span class="fontshift">Act Ratio:&nbsp;</span><% Response.Write(_ratio_act.ToString)%>% ~ <% Response.Write(System.Math.Round(_ratio * 60, 2).ToString & "min")%></div></td>
                                        <td rowspan="2" align="center"><% If (_ratio <= _ratio_pl) Then%><img src="/image/ok.png" width="70px" height="70px" /><% Else %><img src="/image/ng.png" width="70px" height="70px" /> <%End If%></td>
                                      </tr>
                                      <tr>
                                        <td width="65%" height="40px;"><div align="center"><a onClick="_show_1_3();" style="background:#0000FF;color:white;font-size:14px;font-family:Tahoma;">&nbsp;Detail(4)&nbsp;</a></div></td>
                                      </tr>

                                        height="42px;" 
                                        height="40px;" 
                                      --%>
                                    <table width="99%" border="0" >        
                                      <tr height="50%" >
                                        <td rowspan="2" align="left" valign="top" width="30%" >
                                            <div style="color:<% Response.Write(_color) %>;"><span class="fontshift" style="font-size:large;"><%=ReadWriteXml.getAppResource("1087")%></span></div>
                                        </td>
                                          
                                        <td align="left" valign="top" width="40%">
                                            <div style="font-size:x-large;color:<% Response.Write(_color) %>;"><% Response.Write(_ratio_act.ToString)%>&nbsp;%</div>
                                        </td>
                                        
                                        <td rowspan="2" align="center" valign="top" width="30%">
                                             <% If (_ratio <= _ratio_pl) Then%><img src="image/ok.png" width="70px" height="70px" /><% Else %><img src="image/ng.png" width="70px" height="70px" /> <%End If%>
                                        </td>
                                      </tr>

                                      <tr height="50%" >
                                        <td align="left" valign="top" width="40%">
                                            <div style="font-size:x-large;color:<% Response.Write(_color) %>;"><% Response.Write(System.Math.Round(_ratio * 60, 2).ToString & "&nbsp;Min")%></div>
                                        </td>
                                      </tr>
                                    <%--[6] Commented and Modified by Govind on 2015-Mar-19 [End]--%>
                                    </table>
                                </div>
                        </td>
                      </tr>
                    </table> 
                    <!--end change point-->                   
                </asp:TableCell></asp:TableRow></asp:table></div></div><%--[2] Commented by Gagan Kalyana on 2016-Feb-18  [Start]
    <div id="1_1" class="popup"></div>
    <div id="_1_1" class="_popup">
         <div class="_popup_title"><span>&nbsp;<%=ReadWriteXml.getAppResource("1089")%></span><span onclick="_close_1_1();" style="float:right;cursor:pointer;"><img src="image/i_close.gif"></span></div>
         <div style="padding:5px;">
               <asp:Table ID="Table3" runat="server" Width="100%" CellSpacing="2" CellPadding="2">
                <asp:TableRow ID="TableRow2" runat="server"  ForeColor="#9B1321" Font-Size="Large">
                    <asp:TableCell ID="TableCell4" runat="server" Width="35%"><span class="fontshift_popup"><%=ReadWriteXml.getAppResource("1090")%></span></asp:TableCell>
                    <asp:TableCell ID="TableCell5" runat="server" Width="30%"><span class="fontshift_popup"><%=ReadWriteXml.getAppResource("1091")%></span></asp:TableCell>
                    <asp:TableCell ID="TableCell6" runat="server" Width="35%"><span class="fontshift_popup"><%=ReadWriteXml.getAppResource("1092")%></span></asp:TableCell>
                </asp:TableRow>
                <asp:TableRow ID="TableRow3" runat="server" VerticalAlign="Top">
                    <asp:TableCell ID="TableCell7" runat="server" Width="40%">
                        <table width="100%" border="0" cellspacing="0" cellpadding="2" class="shifttable_1">
                          <tr bgcolor="#FF9900">
                            <td width="60%"><%=ReadWriteXml.getAppResource("1093")%></td>
                            <td width="15%"><div align="center"><%=ReadWriteXml.getAppResource("1094")%></div></td>
                            <td width="15%"><div align="center"><%=ReadWriteXml.getAppResource("1095")%></div></td>
                            <td width="10%"><div align="center"><%=ReadWriteXml.getAppResource("1096")%></div></td>
                          </tr>
                          <tr>
                            <td colspan="4" bgcolor="#CCCCCC"><b><%=ReadWriteXml.getAppResource("1097")%></b></td>
                          </tr>       --%><% 
                              'Dim db As New Database
                              'Dim rd As SqlDataReader
                              'Dim sql As String
                              'sql = "select a.time_nm,a.start_time,a.end_time,a.duration_time,a.time_c,a.priority_time from Shift_time_data as a "
                              'sql = sql & "where a.factory_c='" & Request("factory") & "' and  a.line_c='" & lb_line_no.Text & "' and a.shift_c='" & lb_shift.Text & "' and a.section_c='" & lb_section.Text & "' and a.work_date='" & lb_working_day.Text & "' order by convert(int,a.priority_time) asc "
                              'db.conecDB()
                              'db.initCMD()
                              'rd = db.execReader(sql)
                              'While rd.Read()
                              '    Dim _sh_1 As DateTime = rd("start_time")
                              '    Dim _sh_2 As DateTime = rd("end_time")
                              '    Dim temp1 As String = ""
                              '    Dim temp2 As String = ""
                              '    Dim temp3 As String = ""
                              '    If rd("start_time") = "1900-01-01 00:00:00.000" Then
                              '        temp1 = ""
                              '    Else
                              '        temp1 = _sh_1.ToShortTimeString
                              '    End If
                              '    If rd("end_time") = "1900-01-01 00:00:00.000" Then
                              '        temp2 = ""
                              '    Else
                              '        temp2 = _sh_2.ToShortTimeString
                              '    End If
                              '    If rd("priority_time") = 0 Then
                              '        temp3 = "(a)"
                              '    End If
                              '    If rd("priority_time") = 1 Then
                              '        temp3 = "(b)"
                              '    End If
                              '    If rd("priority_time") = 2 Then
                              '        temp3 = "(c)"
                              '    End If
                              '    If rd("priority_time") = 3 Then
                              '        temp3 = "(d)"
                              '    End If
                              '    If rd("priority_time") = 4 Then
                              '        temp3 = "(e)"
                              '    End If
                              '    If rd("priority_time") = 5 Then
                              '        temp3 = "(f)"
                              '    End If
                              '    If rd("priority_time") = 6 Then
                              '        temp3 = "(g)"
                              '    End If
                              '    If rd("priority_time") = 7 Then
                              '        temp3 = "(h)"
                              '    End If
                              '    If rd("priority_time") = 8 Then
                              '        temp3 = "(i)"
                              '    End If
                              '    If rd("priority_time") = 9 Then
                              '        temp3 = "(k)"
                              '    End If
                              '    If rd("priority_time") = 10 Then
                              '        temp3 = "(o)"
                              '    End If
                          %><%--  <tr align="left">
                            <td><span style="color:Blue"><% Response.Write(temp3.ToString())%> </span><% Response.Write(rd("time_nm").ToString)%></td>
                            <td align="right"><% Response.Write(temp1.ToString)%></td>
                            <td align="right"><% Response.Write(temp2.ToString)%></td>
                            <td><div align="right"><% Response.Write(CDbl(System.Math.Round(rd("duration_time") / 60, 2)).ToString("##,###0.00"))%></div></td>
                          </tr>--%><% 
                              'End While
                              'db.closeDB()
                              'rd.Close()
                          %><%--  <tr>
                            <td colspan="4" bgcolor="#CCCCCC"><span style="color:Blue">(l) </span><b><%=ReadWriteXml.getAppResource("1098")%></b></td>
                          </tr> --%><%                                                            
                              'db.conecDB()
                              'db.initCMD()
                              'sql = "select b.data_nm,a.stop_pl_st,a.stop_pl_en,a.duration_pl "
                              'sql = sql & "from LineShift_downtime_pl as a join DicData_mst as b on a.data_c=b.data_c "                              
                              'sql = sql & "where a.factory_c='" & Request("factory") & "' and a.line_c='" & lb_line_no.Text & "' and a.shift_c='" & lb_shift.Text & "' and a.section_c='" & lb_section.Text & "' and a.work_date='" & lb_working_day.Text & "' order by a.upd_dt"
                              'rd = db.execReader(sql)                             
                              'While rd.Read()                                  
                              '    Dim _sh_1 As DateTime = rd("stop_pl_st")
                              '    Dim _sh_2 As DateTime = rd("stop_pl_en")
                              '    Dim temp1 As String = ""
                              '    Dim temp2 As String = ""
                              '    If rd("stop_pl_st") = "1900-01-01 00:00:00.000" Then
                              '        temp1 = ""
                              '    Else
                              '        temp1 = _sh_1.ToShortTimeString
                              '    End If
                              '    If rd("stop_pl_en") = "1900-01-01 00:00:00.000" Then
                              '        temp2 = ""
                              '    Else
                              '        temp2 = _sh_2.ToShortTimeString
                              '    End If
                          %><%-- <tr>
                            <td><% Response.Write(rd("data_nm").ToString)%></td>
                            <td><% Response.Write(temp1.ToString)%></td>
                            <td><% Response.Write(temp2.ToString)%></td>
                            <td><div align="center"><% Response.Write(CDbl(System.Math.Round(rd("duration_pl") / 60, 2)).ToString("##,###0.00"))%></div></td>
                          </tr>--%><%
                              '  End While
                              'db.closeDB()
                              'rd.Close()
                          %><%--</table>                        
                    </asp:TableCell>
                    <asp:TableCell ID="TableCell8" runat="server" Width="30%">
                        <table width="100%" border="0" cellspacing="0" cellpadding="2" class="shifttable_1">
                          <tr bgcolor="#FF9900">
                            <td width="2%"><%=ReadWriteXml.getAppResource("1099")%></td>
                            <td width="68%"><%=ReadWriteXml.getAppResource("1100")%></td>
                            <td width="15%"><div align="center"><%=ReadWriteXml.getAppResource("1101")%></div></td>
						    <td width="15%"><div align="center"><%=ReadWriteXml.getAppResource("1102")%></div></td>
                          </tr>--%><%
                              'Dim db As New Database
                              'Dim rd As SqlDataReader
                              'Dim sql As String
                              'Dim t_pl As Double = 0.0
                              'Dim t_act As Double = 0.0
                              'Dim s As Integer = 0
                              'Dim _d_pl As Double = 0.0
                              'Dim _id_pl As Double = 0.0
                              'Dim _od_pl As Double = 0.0
                              'Dim _d_act As Double = 0.0
                              'Dim _id_act As Double = 0.0
                              'Dim _od_act As Double = 0.0
                              'Dim rate As Double = 0.0
                              'db.conecDB()
                              'db.initCMD()
                              'sql = "select b.data_nm,a.data_c,a.man_pl,a.man_act "
                              'sql = sql & "from lineman_data as a join dicdata_mst as b on a.data_c=b.data_c "
                              'sql = sql & "where a.factory_c='" & Request("factory") & "' and a.line_c='" & lb_line_no.Text & "' and a.shift_c='" & lb_shift.Text & "' and a.section_c='" & lb_section.Text & "' and a.work_date='" & lb_working_day.Text & "' order by a.data_c asc"
                              'rd = db.execReader(sql)
                              'While rd.Read()
                              '    t_pl = t_pl + rd("man_pl")
                              '    t_act = t_act + rd("man_act")
                              '    s = s + 1
                              '    Dim d_c As Integer = 0
                              '    If IsDBNull(rd("data_c")) = False Then
                              '        d_c = CDbl(Right(rd("data_c"), 2))
                              '    End If
                              '    If d_c >= 1 And d_c <= 8 Then
                              '        _d_pl = _d_pl + rd("man_pl")
                              '        _d_act = _d_act + rd("man_act")
                              '    End If
                              '    If d_c >= 10 And d_c <= 11 Then
                              '        _d_pl = _d_pl + rd("man_pl")
                              '        _d_act = _d_act + rd("man_act")
                              '    End If
                              '    If d_c = 13 Then
                              '        _d_pl = _d_pl + rd("man_pl")
                              '        _d_act = _d_act + rd("man_act")
                              '    End If
                              '    If d_c > 11 And d_c <= 12 Then
                              '        _id_pl = _id_pl + rd("man_pl")
                              '        _id_act = _id_act + rd("man_act")
                              '    End If
                              '    If d_c >= 9 And d_c <= 10 Then
                              '        _od_pl = _od_pl + rd("man_pl")
                              '        _od_act = _od_act + rd("man_act")
                              '    End If
                                  
                          %><%--  <tr>
                            <td><% Response.Write(s.ToString)%></td>
                            <td><% Response.Write(rd("data_nm").ToString)%></td>
                            <td><div align="right"><% Response.Write(rd("man_pl").ToString)%></div></td>
						    <td><div align="right"><% Response.Write(rd("man_act").ToString)%></div></td>
                          </tr>  --%><%
                              'End While
                              'db.closeDB()
                              'rd.Close()
                              'If (t_pl - _od_pl) > 0 Then
                              '    rate = (t_act - _od_act) / (t_pl - _od_pl)
                              'End If
                              
                          %><%--<tr>
                            <td></td>
                            <td><div align="right"><strong><%=ReadWriteXml.getAppResource("1103")%>&nbsp;&nbsp;&nbsp;</strong></div></td>
                            <td><div align="right"><% Response.Write(_d_pl.ToString("##,###0.00"))%></div></td>
						    <td><div align="right"><% Response.Write(_d_act.ToString("##,###0.00"))%></div></td>
                          </tr> 
                          <tr>
                            <td></td>
                            <td><div align="right"><strong><%=ReadWriteXml.getAppResource("1104")%></strong></div></td>
                            <td><div align="right"><% Response.Write(_id_pl.ToString("##,###0.00"))%></div></td>
						    <td><div align="right"><% Response.Write(_id_act.ToString("##,###0.00"))%></div></td>
                          </tr>  
                          <tr>
                            <td></td>
                            <td><div align="right"><strong><%=ReadWriteXml.getAppResource("1105")%>&nbsp;</strong></div></td>
                            <td><div align="right"><% Response.Write(_od_pl.ToString("##,###0.00"))%></div></td>
						    <td><div align="right"><% Response.Write(_od_act.ToString("##,###0.00"))%></div></td>
                          </tr>                            
                          <tr>
                            <td></td>
                            <td><div align="right"><strong><%=ReadWriteXml.getAppResource("1053")%></strong></div></td>
                            <td><div align="right"><% Response.Write(t_pl.ToString("##,###0.00"))%></div></td>
						    <td><div align="right"><% Response.Write(t_act.ToString("##,###0.00"))%></div></td>
                          </tr>  
                          <tr>
                            <td>&nbsp;</td>
                            <td><div align="right"><strong><%=ReadWriteXml.getAppResource("1106")%></strong></div></td>
                            <td colspan="2"><div align="center"><% Response.Write(System.Math.Round(rate * 100, 2))%>%</div></td>
					      </tr>                                                                  
                        </table>
                    </asp:TableCell>
                    <asp:TableCell ID="TableCell9" runat="server" Width="30%">
                        <table width="100%" border="0" cellspacing="0" cellpadding="2" class="shifttable_1">
                          <tr bgcolor="#FF9900">
                            <td width="2%"><%=ReadWriteXml.getAppResource("1099")%></td>
                            <td width="83%"><%=ReadWriteXml.getAppResource("1107")%></td>
                            <td width="15%"><div align="center"><%=ReadWriteXml.getAppResource("1070")%></div></td>						
                          </tr>--%><%
                              'Dim db As New Database
                              'Dim rd As SqlDataReader
                              'Dim sql As String                          
                              'Dim s As Integer = 0
                              'db.conecDB()
                              'db.initCMD()
                              '  sql = "select b.data_nm,a.data_c,a.eq_pl,a.eq_act "
                              '  sql = sql & "from lineequipment_data as a join dicdata_mst as b on a.data_c=b.data_c "
                              '  sql = sql & "where a.factory_c='" & Request("factory") & "' and a.line_c='" & lb_line_no.Text & "' and a.shift_c='" & lb_shift.Text & "' and a.section_c='" & lb_section.Text & "' and a.work_date='" & lb_working_day.Text & "' order by a.upd_dt desc "
                              'rd = db.execReader(sql)
                              'While rd.Read()
                              '    s = s + 1
                          %><%-- <tr>
                            <td><% Response.Write(s.ToString)%></td>
                            <td><% Response.Write(rd("data_nm").ToString)%></td>
                            <td><div align="right"><% Response.Write(rd("eq_act").ToString)%></div></td>						
                          </tr>   --%><%
                              'End While
                              'db.closeDB()
                              'rd.Close()
                          %><%--</table>
                    </asp:TableCell>
                </asp:TableRow>
            </asp:Table>           
            <div style="color:Yellow"><b><u><%=ReadWriteXml.getAppResource("1014")%></u></b></div>
            <div style="width:100%; text-align:center; border:1px solid white;">
            <table width="100%" border="0" cellspacing="0" cellpadding="15" style="font-size:15px;">
               <tr valign="top">
                <td width="50%" align="left" style="color:gray">                    
                    <div style="margin-bottom:3px;"><%=ReadWriteXml.getAppResource("1108")%> <% Response.Write("(a-b-c-d-e-f-g+h-i-k-o-l)")%> : <% Response.Write(lb_hour_act.Text)%></div>
                    <div style="margin-bottom:3px;"><%=ReadWriteXml.getAppResource("1109")%>  <% Response.Write(lb_tact_time.Text)%> </div>
                    <div style="margin-bottom:3px;"><%=ReadWriteXml.getAppResource("1110")%> <% Response.Write(lb_cycle_time.Text)%> </div>
                    <div style="margin-bottom:3px;"><%=ReadWriteXml.getAppResource("1111")%> <% Response.Write(lb_smh.Text)%> </div>
                    <div style="margin-bottom:3px;"><%=ReadWriteXml.getAppResource("1112")%> <% Response.Write("(a-e+h-k-l)")%> <%=ReadWriteXml.getAppResource("1141")%> <% Response.Write(lb_amh.Text)%> </div>
                </td>
                <td width="50%" align="left" style="color:gray">
                    <div style="margin-bottom:3px;"><%=ReadWriteXml.getAppResource("1113")%><% Response.Write(lb_effic_st.Text)%></div>
                    <div style="margin-bottom:3px;"><%=ReadWriteXml.getAppResource("1114")%><% Response.Write("(a-e+h-k-l)")%> <%=ReadWriteXml.getAppResource("1115")%><% Response.Write(lb_effic_at.Text)%></div>
                    <div style="margin-bottom:3px;"><%=ReadWriteXml.getAppResource("1116")%> <% Response.Write(_direct.ToString)%></div>
                    <div style="margin-bottom:3px;"><%=ReadWriteXml.getAppResource("1117")%> <% Response.Write(_indirect.ToString)%></div>                    
                </td>               
               </tr>
            </table>
            </div>
        </div>
    </div>    
    <div id="1_2" class="popup"></div>
    <div id="_1_2" class="_popup">
         <div class="_popup_title"><span>&nbsp;<%=ReadWriteXml.getAppResource("1118")%></span><span onclick="_close_1_2();" style="float:right;cursor:pointer;"><img src="image/i_close.gif"></span></div>
         <div style="padding:5px;">  
           <asp:Table ID="Table6" runat="server" Width="100%" CellSpacing="2" CellPadding="2">
                <asp:TableRow ID="TableRow8" runat="server"  ForeColor="#9B1321" Font-Size="Large">
                   <asp:TableCell ID="TableCell28" runat="server" Width="50%"><span class="fontshift_popup"><%=ReadWriteXml.getAppResource("1119")%></span></asp:TableCell>
                   <asp:TableCell ID="TableCell29" runat="server" Width="50%"><span class="fontshift_popup"><%=ReadWriteXml.getAppResource("1120")%></span></asp:TableCell>                   
                </asp:TableRow>
                <asp:TableRow ID="TableRow9" runat="server"  ForeColor="#9B1321" >
                    <asp:TableCell ID="TableCell22" runat="server" valign="top">
                       <table width="100%" border="0" cellspacing="0" cellpadding="2" class="shifttable_1">
                          <tr bgcolor="#FF9900">
                            <td width="2%"><%=ReadWriteXml.getAppResource("1099")%></td>
                            <td width="38%"><%=ReadWriteXml.getAppResource("1121")%></td>
                            <td width="20%"><div align="center"><%=ReadWriteXml.getAppResource("1122")%></div></td>
                            <td width="20%"><div align="center"><%=ReadWriteXml.getAppResource("1070")%></div></td>	
                            <td width="20%"><div align="center"><%=ReadWriteXml.getAppResource("1123")%></div></td>                            
                          </tr>--%><%
                              'Dim db As New Database
                              'Dim rd As SqlDataReader
                              'Dim sql As String                          
                              'Dim s As Integer = 0
                              'db.conecDB()
                              'db.initCMD()
                              'sql = "select a.defect_c,a.no_of_defect,a.defect_pos,data_nm=(select data_nm from dicData_mst where data_c=a.data_c) "
                              'sql = sql & "from defect_res as a "
                              'sql = sql & "where a.factory_c='" & Request("factory") & "' and a.line_c='" & lb_line_no.Text & "' and a.shift_c='" & lb_shift.Text & "' and a.section_c='" & lb_section.Text & "' and a.work_date='" & lb_working_day.Text & "' order by a.ent_dt "
                              'rd = db.execReader(sql)
                              'While rd.Read()
                              '      s = s + 1                                 
                          %><%-- <tr>
                            <td><% Response.Write(s.ToString)%></td>
                            <td><% Response.Write(rd("data_nm").ToString)%></td>
                            <td><div align="center"><% Response.Write(rd("defect_c").ToString)%></div></td>
                            <td><div align="center"><% Response.Write(rd("no_of_defect").ToString)%></div></td>	
                            <td><div align="center"><% Response.Write(rd("defect_pos").ToString)%></div></td>							                            
                          </tr>--%><%
                              'End While
                              'db.closeDB()
                              'rd.Close()
                          %><%-- </table>                 
                    </asp:TableCell>
                    <asp:TableCell ID="TableCell23" runat="server" valign="top">
                       <table width="100%" border="0" cellspacing="0" cellpadding="2" class="shifttable_1">
                          <tr bgcolor="#FF9900" >
                            <td width="2%"><%=ReadWriteXml.getAppResource("1099")%></td>
                            <td width="20%"><%=ReadWriteXml.getAppResource("1121")%></td>
                            <td width="20%"><div align="center"><%=ReadWriteXml.getAppResource("1123")%></div></td>
                            <td width="58%"><div align="center"><%=ReadWriteXml.getAppResource("1124")%></div></td>
                          </tr>--%><%
                              'Dim db As New Database
                              'Dim rd As SqlDataReader
                              'Dim sql As String                          
                              'Dim s As Integer = 0
                              'db.conecDB()
                              'db.initCMD()
                              'sql = "select b.data_nm as position,c.m01,c.m02,c.m03,c.m04,a.data_des "
                              'sql = sql & "from ChangePoint_data as a join DicData_mst as b on a.data_c=b.data_c "
                              '  sql = sql & "join line_data as c on a.line_c=c.line_c and a.shift_c=c.shift_c and a.work_date=c.work_date and a.section_c=c.section_c and a.factory_c=c.factory_c "
                              '  sql = sql & "where a.factory_c='" & Request("factory") & "' and a.line_c='" & lb_line_no.Text & "' and a.shift_c='" & lb_shift.Text & "' and a.section_c='" & lb_section.Text & "' and a.work_date='" & lb_working_day.Text & "' and a.data_des<>'' "
                              'rd = db.execReader(sql)
                              'While rd.Read()
                              '      s = s + 1
                              '      Dim data_name As String = ""
                              '      If IsDBNull(rd("m01")) = False Then
                              '          If rd("m01") > 0 Then
                              '              data_name = "Man "
                              '          End If
                              '      End If
                              '      If IsDBNull(rd("m02")) = False Then
                              '          If rd("m02") > 0 Then
                              '              data_name = data_name & "Machine "
                              '          End If
                              '      End If
                              '      If IsDBNull(rd("m03")) = False Then
                              '          If rd("m03") > 0 Then
                              '              data_name = data_name & "Material "
                              '          End If
                              '      End If
                              '      If IsDBNull(rd("m04")) = False Then
                              '          If rd("m04") > 0 Then
                              '              data_name = data_name & "Method "
                              '          End If
                              '      End If
                          %><%-- <tr>
                            <td><% Response.Write(s.ToString)%></td>
                            <td><% Response.Write(data_name.ToString)%></td>
                            <td><div align="center"><% Response.Write(rd("position").ToString)%></div></td>
                            <td><div align="left"><% Response.Write(rd("data_des").ToString)%></div></td>	                           				                            
                          </tr>--%><%                              
                              'End While
                              'db.closeDB()
                              'rd.Close()
                          %><%-- </table> 
                    </asp:TableCell>                    
                </asp:TableRow>
            </asp:Table>
         </div>
    </div>
    <div id="1_3" class="popup"></div>
    <div id="_1_3" class="_popup">
         <div class="_popup_title"><span>&nbsp;<%=ReadWriteXml.getAppResource("1086")%></span><span onclick="_close_1_3();" style="float:right;cursor:pointer;"><img src="image/i_close.gif"></span></div>
         <div style="padding:5px;">  
             <asp:Table ID="Table5" runat="server" Width="100%" CellSpacing="2" CellPadding="2">
                <asp:TableRow ID="TableRow6" runat="server"  ForeColor="#9B1321" Font-Size="Large">
                    <asp:TableCell ID="TableCell16" runat="server" Width="60%"><span class="fontshift_popup"><%=ReadWriteXml.getAppResource("1125")%></span></asp:TableCell>
                    <asp:TableCell ID="TableCell17" runat="server" Width="40%"><span class="fontshift_popup"><%=ReadWriteXml.getAppResource("1126")%></span></asp:TableCell>                    
                </asp:TableRow>
                <asp:TableRow ID="TableRow7" runat="server"  ForeColor="#9B1321">
                    <asp:TableCell ID="TableCell18" runat="server" valign="top">
                        <table width="100%" border="0" cellspacing="0" cellpadding="2" class="shifttable_1">
                          <tr bgcolor="#FF9900" >
                            <td width="2%"><%=ReadWriteXml.getAppResource("1099")%></td>
                            <td width="38%"><%=ReadWriteXml.getAppResource("1121")%></td>
                            <td width="15%"><div align="center"><%=ReadWriteXml.getAppResource("1127")%></div></td>
                            <td width="15%"><div align="center"><%=ReadWriteXml.getAppResource("1128")%></div></td>	
                            <td width="15%"><div align="center"><%=ReadWriteXml.getAppResource("1129")%></div></td>							
                            <td width="15%"><div align="center"><%=ReadWriteXml.getAppResource("1123")%></div></td>	
                          </tr>--%><%
                              'Dim db As New Database
                              'Dim rd As SqlDataReader
                              'Dim sql As String                          
                              'Dim s As Integer = 0
                              'db.conecDB()
                              'db.initCMD()
                              'sql = "select a.data_c,data_nm=(select data_nm from DicData_mst where data_c=a.data_c),a.stop_st,a.stop_en,a.duration,a.location "
                              'sql = sql & "from LineShift_downtime_act as a "
                              '  sql = sql & "where a.factory_c='" & Request("factory") & "' and a.line_c='" & lb_line_no.Text & "' and a.shift_c='" & lb_shift.Text & "' and a.section_c='" & lb_section.Text & "' and a.work_date='" & lb_working_day.Text & "' and a.status_flg<>'0' "
                              'sql = sql & "order by a.stop_st asc "
                              'rd = db.execReader(sql)
                              'While rd.Read()
                              '      s = s + 1
                              '      Dim _sh_1 As DateTime
                              '      Dim _sh_2 As DateTime
                              '      Dim duration As Double
                              '      Dim sa As String = ""
                              '      If IsDBNull(rd("duration")) = False Then
                              '          duration = System.Math.Round(rd("duration") / 60, 2)
                              '          _sh_1 = rd("stop_st")
                              '          _sh_2 = rd("stop_en")
                              '      End If
                              '      If IsDBNull(rd("location")) = False Then                                      
                              '          sa =  rd("location").ToString
                              '      End If
                          %><%--<tr>
                            <td><% Response.Write(s.ToString)%></td>
                            <td><% Response.Write(rd("data_nm").ToString)%></td>
                            <td><div align="right"><% Response.Write(_sh_1.ToShortTimeString)%></div></td>
                            <td><div align="right"><% Response.Write(_sh_2.ToShortTimeString)%></div></td>	
                            <td><div align="right"><% Response.Write(duration.ToString("##,###0.00"))%></div></td>							
                            <td><div align="center"><% Response.Write(sa.ToString)%></div></td>	
                          </tr>--%><%
                              'End While
                              'db.closeDB()
                              'rd.Close()
                          %><%-- </table>
                    </asp:TableCell>
                    <asp:TableCell ID="TableCell19" runat="server" valign="top">
                      <table width="100%" border="0" cellspacing="0" cellpadding="2" class="shifttable_1">
                          <tr bgcolor="#FF9900">                            
                            <td width="20%"><%=ReadWriteXml.getAppResource("1123")%></td>
                            <td width="45%"><div align="center"><%=ReadWriteXml.getAppResource("1130")%></div></td>
                            <td width="45%"><div align="center"><%=ReadWriteXml.getAppResource("1131")%></div></td>                           
                          </tr>--%><%
                              'Dim db As New Database
                              'Dim rd As SqlDataReader
                              'Dim sql As String                                                     
                              'db.conecDB()
                              'db.initCMD()
                              '  sql = "select a.location,a.factory_c,round(sum(convert(DECIMAL(9,2),a.duration)),2) as duration, "
                              '  sql = sql & "times=(select count(b.location) from LineShift_downtime_act as b where b.location=a.location and b.factory_c=a.factory_c and b.section_c=a.section_c and b.line_c=a.line_c and b.shift_c = a.shift_c and b.work_date=a.work_date) "
                              '  sql = sql & "from LineShift_downtime_act as a "
                              '  sql = sql & "where a.factory_c='" & Request("factory") & "' and a.line_c='" & lb_line_no.Text & "' and a.shift_c='" & lb_shift.Text & "' and a.section_c='" & lb_section.Text & "' and a.work_date='" & lb_working_day.Text & "' and a.status_flg<>'0' "
                              '  sql = sql & "group by a.section_c,a.line_c,a.shift_c,a.work_date,a.location,a.factory_c"
                              'rd = db.execReader(sql)
                              'While rd.Read()                                                                  

                          %><%--  <tr>                            
                            <td width="20%"><% Response.Write(rd("location").ToString)%></td>
                            <td width="45%"><div align="center"><% Response.Write(rd("times").ToString)%></div></td>
                            <td width="45%"><div align="center"><% Response.Write(CDbl(rd("duration") / 60).ToString("##,###0.00"))%></div></td>                           
                          </tr>--%><%
                              'End While
                              'db.closeDB()
                              'rd.Close()                         
                          %><%--</table>
                    </asp:TableCell>                    
                </asp:TableRow>
             </asp:Table>
         </div>
    </div>    
    <div id="1_4" class="popup"></div>
    <div id="_1_4" class="_popup">
         <div class="_popup_title"><span>&nbsp;<%=ReadWriteXml.getAppResource("1132")%></span><span onclick="_close_1_4();" style="float:right;cursor:pointer;"><img src="image/i_close.gif"></span></div>
         <div style="padding:9px;">  
          <table width="100%" cellspacing="0" cellpadding="2" class="shifttable_3" >
                      <tr bgcolor="#FF9933">
                        <td rowspan="2"  width="13%"><%=ReadWriteXml.getAppResource("1062")%></td>
                        <td rowspan="2"  width="10%"><%=ReadWriteXml.getAppResource("1133")%></td>
                        <td rowspan="2" width="8%"><div align="center"><%=ReadWriteXml.getAppResource("1063")%></div></td>
                        <td rowspan="2"  width="8%"><div align="center"><%=ReadWriteXml.getAppResource("1064")%></div></td>
                        <td rowspan="2"  width="8%"><div align="center"><%=ReadWriteXml.getAppResource("1065")%></div></td>
                        <td rowspan="2"  width="8%"><div align="center"><%=ReadWriteXml.getAppResource("1134")%></div></td>
                        <td rowspan="2"  width="8%"><div align="center"><%=ReadWriteXml.getAppResource("1067")%></div></td>
                        <td rowspan="2"  width="8%"><div align="center"><%=ReadWriteXml.getAppResource("1068")%></div></td>
                        <td rowspan="2"  width="8%"><div align="center"><%=ReadWriteXml.getAppResource("1069")%></div></td>--%><%--Modified by Gagan Kalyana on 2015-Apr-22--%><%--<td colspan="4"  width="21%"><div align="center"><%=ReadWriteXml.getAppResource("1135")%>(<% Response.Write(Left(lb_working_day_1.Text, 9))%>)</div></td>--%><%--Commneted and added by Gagan Kalyana on 2015-May-08
                        <td colspan="4"  width="21%"><div align="center"><%=ReadWriteXml.getAppResource("1135")%>(<% Response.Write(Left(lb_working_day_1.Text, 10))%>)</div></td>
                        <td rowspan="2"  width="11%"><div align="center"><%=ReadWriteXml.getAppResource("1136")%></div></td>--%><%-- <td colspan="4"  width="17%"><div align="center"><%=ReadWriteXml.getAppResource("1135")%>(<% Response.Write(Left(lb_working_day_1.Text, 10))%>)</div></td>
                        <td rowspan="2"  width="12%"><div align="center"><%=ReadWriteXml.getAppResource("1136")%></div></td>                   
                      </tr>
                      <tr  bgcolor="green">
                        <td><div align="center">01</div></td>
                        <td><div align="center">02</div></td>
                        <td><div align="center">03</div></td>
                        <td><div align="center">04</div></td>
                      </tr>--%><%
                          'Dim db As New Database
                          'Dim rd As SqlDataReader
                          'Dim sql As String                         
                          'db.conecDB()
                          'db.initCMD()
                          ' sql = "select  a.product_no,b.short_c,b.circuit_no,round((b.smh_sub+smh_asy)/3600,6) as smh,a.proty_pl,c.asy_board,c.circuit_board,a.shift_c,a.Cusdesch_c1,a.Cusdesch_c2,a.Intdesch_c "
                          ' sql = sql & "from production_plan as a "
                          ' sql = sql & "join product_mst as b on a.factory_c=b.factory_c and a.product_no=b.product_no and a.cusdesch_c1=b.cusdesch_c1 and a.cusdesch_c2=b.cusdesch_c2 and a.intdesch_c=b.intdesch_c "
                          ' '[FC] Commented and Modified by Govind on 2015-Mar-19
                          ' 'sql = sql & "join lineproduct_mst as c on a.factory_c =c.factory_c and a.line_c=c.line_c and a.product_no=c.product_no "
                          ' sql = sql & "join lineproduct_mst as c on a.factory_c = c.factory_c and a.section_c = c.section_c and a.line_c=c.line_c and a.product_no=c.product_no "
                          ' sql = sql & "where a.factory_c='" & Request("factory") & "' and a.line_c='" & lb_line_no.Text & "' and a.plan_qty>0 and a.section_c='" & lb_section.Text & "' and a.work_date='" & lb_working_day.Text & "' "
                          ' sql = sql & "order by  a.shift_c asc,a.priority asc "
                         
                          ' Dim ahour As Double = 0.0
                          ' Dim smh As Double = 1.0                          
                          ' Dim _tast_time As Double = 0.0
                          ' Dim color_1 As String = ""
                          ' Dim color_2 As String = ""
                          ' Dim color_3 As String = ""
                          ' Dim color_4 As String = ""                          
                          
                          ' If lb_hour_act.Text <> "" Then
                          '     ahour = CDbl(lb_hour_act.Text)
                          ' End If
                          
                          ' If Trim(lb_shift.Text) = "1" Then
                          '     color_1 = "yellow"
                          ' End If
                          ' If Trim(lb_shift.Text) = "2" Then
                          '     color_2 = "yellow"
                          ' End If
                          ' If Trim(lb_shift.Text) = "3" Then
                          '     color_3 = "yellow"
                          ' End If
                          ' If Trim(lb_shift.Text) = "4" Then
                          '     color_4 = "yellow"
                          ' End If                                                    
                          
                          ' rd = db.execReader(sql)
                          ' While rd.Read()
                          '     Dim _db As New Database
                          '     Dim _rd As SqlDataReader
                          '     Dim _sql As String                              
                          '     Dim qty_1 As Integer = 0
                          '     Dim qty_2 As Integer = 0
                          '     Dim qty_3 As Integer = 0
                          '     Dim qty_4 As Integer = 0                              
                          '     Dim _proty_1 As Double = 0.0
                          '     Dim _proty_2 As Double = 0.0
                          '     Dim _proty_3 As Double = 0.0
                          '     Dim _proty_4 As Double = 0.0
                              
                          '     Dim CD as string=""
                          '     If IsDBNull(rd("cusdesch_c1")) = False Then
                          '         CD= rd("cusdesch_c1")&"-"&rd("cusdesch_c2")& "-" &rd("Intdesch_c")
                          '     End If                              
                          '     If IsDBNull(rd("smh")) = False Then
                          '         smh = rd("smh")
                          '     End If                                                                                                                      
                              
                          '     _db.conecDB()
                          '     _db.initCMD()
                              
                          '     _sql = "select a.plan_qty,a.shift_c,a.priority from production_plan as a "
                          '     _sql = _sql & "join  product_mst as b on a.factory_c=b.factory_c and a.product_no=b.product_no and a.cusdesch_c1=b.cusdesch_c1 and a.cusdesch_c2=b.cusdesch_c2 and a.intdesch_c=b.intdesch_c "
                          '     _sql = _sql & "where a.factory_c='" & Request("factory") & "' and a.section_c='" & lb_section.Text & "' and a.line_c='" & lb_line_no.Text & "' and a.plan_qty>0 and a.work_date='" & lb_working_day.Text & "' and a.shift_c='" & rd("shift_c") & "' "
                          '     _sql = _sql & "and a.product_no='" & rd("product_no") & "' and b.short_c='" & rd("short_c") & "' and a.cusdesch_c1='" & rd("cusdesch_c1") & "' and a.cusdesch_c2='" & rd("cusdesch_c2") & "' and  a.intdesch_c='" & rd("intdesch_c") & "' "                              
                          '     _rd = _db.execReader(_sql)
                              
                          '     While _rd.Read()                                  
                          '         qty_1 = 0
                          '         qty_2 = 0
                          '         qty_3 = 0
                          '         qty_4 = 0
                          '         Dim priority As Integer = 0
                          '         If _rd("shift_c") = Trim(lb_shift.Text) Then
                          '             priority = _rd("priority")
                          '         End If                                  
                          '         If _rd("shift_c") = "1" Then
                          '             qty_1 = _rd("plan_qty")                                                                                                                 
                          '         End If
                          '         If _rd("shift_c") = "2" Then
                          '             qty_2 = _rd("plan_qty")                                                                            
                          '         End If
                          '         If _rd("shift_c") = "3" Then
                          '             qty_3 = _rd("plan_qty")                                                                            
                          '         End If
                          '         If _rd("shift_c") = "4" Then
                          '             qty_4 = _rd("plan_qty")                                                                                                
                          '         End If
                          '         _tast_time = smh / _dman
                          '         _tast_time = _tast_time / (rd("proty_pl") / 100)
                          '         _tast_time = _tast_time * 3600
                                                                    
                        %><%--<tr>
                        <td style="width:13%"><% Response.Write(rd("product_no").ToString)%></td>
                        <td style="width:10%"><% Response.Write(CD.ToString)%></td>
                        <td width="8%"><div align="center"><% Response.Write(rd("short_c").ToString)%></div></td>
                        <td width="8%"><div align="center"><% Response.Write(rd("circuit_no").ToString)%></div></td>
                        <td width="8%"><div align="center"><% Response.Write(Left(rd("smh"), 6).ToString)%></div></td>
                        <td width="8%"><div align="center"><% Response.Write(Fix(rd("proty_pl")).ToString)%></div></td>
                        <td width="8%"><div align="center"><% Response.Write(_tast_time.ToString("##,###0.0"))%></div></td>
                        <td width="8%"><div align="center"><% Response.Write(rd("asy_board").ToString)%></div></td>
                        <td width="8%"><div align="center"><% Response.Write(rd("circuit_board").ToString)%></div></td>
                        <td style=background-color:<% Response.Write(color_1.ToString)%>><div align="center"><% Response.Write(qty_1.ToString)%></div></td>
                        <td style=background-color:<% Response.Write(color_2.ToString)%>><div align="center"><% Response.Write(qty_2.ToString)%></div></td>
                        <td style=background-color:<% Response.Write(color_3.ToString)%>><div align="center"><% Response.Write(qty_3.ToString)%></div></td>
                        <td style=background-color:<% Response.Write(color_4.ToString)%>><div align="center"><% Response.Write(qty_4.ToString)%></div></td>
                        <td style=background-color:yellow><div align="center"><% Response.Write(priority.ToString)%></div></td>                                                
                      </tr>--%><%
                          '    End While                                                           
                          '    _db.closeDB()
                          '    _rd.Close()                       
                          'End While                  
                          'db.closeDB()
                          'rd.Close()                  
                       %><%--</table>  
         </div>
    </div>
    [2] Commented by Gagan Kalyana on 2016-Feb-18  [End]--%></asp:Content>