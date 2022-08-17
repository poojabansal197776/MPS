
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'File Name          : Default.aspx.vb
'Function           : To display list of Lines for a particuler Factory code
'Created By         : 
'Created on         : 
'Revision History   : Modified by Gagan Kalayana on 23-Mar-2015 for the FC63 Anken
'                     On entry of each screen a log entry will be store in Screen_Usage table
'                   : Modified by Gagan Kalyana on 2015-Apr-02 for unused code removal
'                   : Modified by Gagan Kalyana on 2015-Apr-15 for the FC63 Anken (IS3 Req. No. ER/150515001)
'                     Modifications done correct the join condition.
'                   : Modified by Gagan Kalyana on 2016-Feb-11 for FC66-GLOBAL VISUALIZING IN-ASSEMBLY SYSTEM_PHASE2
'                     Changes has been done to add Display Changeover function of the Home screen.
'                   : Changes has been done by SIS on 2016-Mar-31 and merged by mohit maheshwari on 2016-Dec-28
'                   : Modified by Gagan Kalyana on 2017-Mar-08 for FC69_GVIA-Phase-III-I
'                     Changes has been done to:
'                       1. Add the display of Real Time Efficiency, Downtime, Defect Count and Production Qty. on the basis of Parameter master setting.
'                       2. In case of GVIA simple mode, "Print" button has been added on top of the screen.
'                       3. Formula for Working Time calculation has been improved.    
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'Commented by Gagan Kalyana on 2015-Apr-02 [Start]
'Imports System
'Imports System.Data
'Imports System.Configuration
'Imports System.Collections
'Imports System.Web
'Imports System.Web.Security
'Imports System.Web.UI
'Imports System.Web.UI.WebControls
'Imports System.Web.UI.WebControls.WebParts
'Imports System.Web.UI.HtmlControls
'Imports System.Web.UI.DataVisualization.Charting.Chart
'Imports System.Net
'Commented by Gagan Kalyana on 2015-Apr-02 [End]
Imports System.Data.SqlClient
Imports System.Web.UI.DataVisualization.Charting
Imports System.Data

Partial Class _Default
    Inherits System.Web.UI.Page
    'Added by Gagan Kalyana on 2016-Feb-11 [Start]
    Protected dataAdapter As SqlDataAdapter
    Dim strSql As String
    Protected dataSet As New DataSet
    'Added by Gagan Kalyana on 2016-Feb-11 [End]
    'Added by Gagan Kalyana on 2017-Mar-08 [Start] 
    Protected btnDisplayProduction_Qty As Boolean = False
    Protected btnDisplayEfficiecy As Boolean = False
    Protected btnDisplayDownTime As Boolean = False
    Protected btnDisplayDefect As Boolean = False
    Protected workignHours As Double
    Protected dbtDimna_Act As Double
    Protected dblRealEff As Double
    'Added by Gagan Kalyana on 2017-Mar-08 [End]

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If IsPostBack = False Then
            Call HomeScreenValuesDisplay()  'Added by Gagan Kalyana on 2017-Mar-08
        End If
    End Sub

    Public Function _check_line_status(ByVal factory As String, ByVal section As String, ByVal line As String) As Integer
        Dim db As New Database
        Dim rd As SqlDataReader
        Dim j As Integer = 0
        db.conecDB()
        db.initCMD()
        Dim sql As String
        sql = "select MIN(a.start_time) as start_time, MAX(a.end_time) as end_time,MAX(a.ent_dt) as ent_dt "
        sql = sql & "from Shift_time_data as a "
        sql = sql & "join Line_data as b on a.factory_c=b.factory_c and a.section_c=b.section_c and a.line_c=b.line_c and  a.shift_c=b.shift_c and a.work_date=b.work_date "
        sql = sql & "where a.factory_c='" + factory + "' and a.section_c='" + section + "' and a.line_c='" & line & "' and (getdate() between a.start_time and a.end_time) and a.start_time <> '1900-01-01 00:00:00.000' and a.end_time <>'1900-01-01 00:00:00.000' "
        rd = db.execReader(sql)
        If rd.Read() Then
            If IsDBNull(rd("start_time")) = False And IsDBNull(rd("end_time")) = False Then
                j = 1
            End If
        Else
            j = 0
        End If
        db.closeDB()
        rd.Close()
        Return j
    End Function

    Public Function _get_work_date(ByVal factory As String, ByVal section As String, ByVal line As String) As String
        Dim db As New Database
        Dim rd As SqlDataReader
        Dim work_dt As String = ""
        db.conecDB()
        db.initCMD()
        Dim sql As String
        sql = "select a.work_date "
        sql = sql & "from Shift_time_data  as a "
        sql = sql & "where a.factory_c='" + factory + "' and a.section_c='" + section + "' and a.line_c='" & line & "' and a.ent_dt =(select max(ent_dt) from Shift_time_data where factory_c='" + factory + "' and section_c='" + section + "' and line_c='" & line & "') "

        rd = db.execReader(sql)
        If rd.Read() Then
            If IsDBNull(rd("work_date")) = False Then
                work_dt = rd("work_date").ToString
            End If
        End If
        db.closeDB()
        rd.Close()
        Return work_dt

    End Function
    'Added by SIS on 2016-Mar-31 [Start]
    Public Function _get_work_date_yyyyMMdd(ByVal factory As String, ByVal section As String, ByVal line As String) As String
        Dim db As New Database
        Dim rd As SqlDataReader
        Dim work_dt As String = ""
        db.conecDB()
        db.initCMD()
        Dim sql As String
        sql = "select convert(nvarchar,a.work_date,112) as work_date_yyyyMMdd "
        sql = sql & "from Shift_time_data  as a "
        sql = sql & "where a.factory_c='" + factory + "' and a.section_c='" + section + "' and a.line_c='" & line & "' and a.ent_dt =(select max(ent_dt) from Shift_time_data where factory_c='" + factory + "' and section_c='" + section + "' and line_c='" & line & "') "

        rd = db.execReader(sql)
        If rd.Read() Then
            If IsDBNull(rd("work_date_yyyyMMdd")) = False Then
                work_dt = rd("work_date_yyyyMMdd").ToString
            End If
        End If
        db.closeDB()
        rd.Close()
        Return work_dt

    End Function
    'Added by SIS on 2016-Mar-31 [End]
    Public Function _get_shift(ByVal factory As String, ByVal section As String, ByVal line As String) As String
        Dim db As New Database
        Dim rd As SqlDataReader
        Dim shift As String = ""
        db.conecDB()
        db.initCMD()
        Dim sql As String
        sql = "select a.shift_c "
        sql = sql & "from Shift_time_data  as a "
        'Modified by SIS on 2016-Mar-31
        'sql = sql & "where a.factory_c='" + factory + "' and a.section_c='" + section + "' and a.line_c='" & line & "' and a.ent_dt =(select max(ent_dt) from Shift_time_data where factory_c='" + factory + "' and section_c='" + section + "' and line_c='" & line & "') "
        sql = sql & "where a.factory_c='" + factory + "' and a.section_c='" + section + "' and a.line_c='" & line & "' and (a.start_time <= GETDATE() and a.end_time >= GETDATE())"
        rd = db.execReader(sql)
        If rd.Read() Then
            If IsDBNull(rd("shift_c")) = False Then
                shift = rd("shift_c").ToString
            End If
        Else 'Added by SIS on 2016-Mar-31
            shift = 1 'Added by SIS on 2016-Mar-31
        End If
        db.closeDB()
        rd.Close()
        Return shift

    End Function

    Public Function _check_downtime_pl_shift(ByVal factory As String, ByVal section As String, ByVal line As String) As Double
        Dim db As New Database
        Dim rd As SqlDataReader
        Dim j As Double = 0
        Dim _sec As String = ""
        Dim _line As String = ""
        Dim _shift As String = ""
        Dim _work As String = ""
        Dim _ratio As Double = 0.0
        Dim _ahour As Double = 0.0
        Dim _r1 As Double = 0.0
        Dim _r2 As Double = 0.0

        Dim _work_ratio As Double = 0.0 'Added by SIS on 2016-Mar-31
        Dim sql As String
        db.conecDB()
        db.initCMD()
        sql = "select top 1 a.section_c,a.line_c,a.shift_c,a.work_date,a.ahour_pl,c.downtime_pl as downtime_ratio_pl "
        'Commented and added by Gagan Kalyana on 2015-Apr-15
        'sql = sql & "from Line_Data as a join line_mst as c on a.factory_c=a.section_c and a.section_c=c.section_c and a.line_c=c.line_c "
        sql = sql & "from Line_Data as a join line_mst as c on a.factory_c=a.factory_c and a.section_c=c.section_c and a.line_c=c.line_c "
        sql = sql & "where a.factory_c='" + factory + "' and a.section_c='" + section + "' and a.line_c='" & line & "' and a.ent_dt =(select max(ent_dt) from Line_Data where factory_c='" + factory + "' and section_c='" + section + "' and line_c='" & line & "')  "

        sql = sql & "order by a.work_date desc,a.ent_dt desc "

        rd = db.execReader(sql)
        If rd.Read() Then
            If IsDBNull(rd("ahour_pl")) = False Then
                _ahour = rd("ahour_pl")
            End If
            If IsDBNull(rd("downtime_ratio_pl")) = False Then
                _ratio = rd("downtime_ratio_pl")
            End If
            If IsDBNull(rd("section_c")) = False Then
                _sec = rd("section_c").ToString
            End If
            If IsDBNull(rd("work_date")) = False Then
                _work = rd("work_date").ToString
            End If
            If IsDBNull(rd("line_c")) = False Then
                _line = rd("line_c").ToString
            End If
            If IsDBNull(rd("shift_c")) = False Then
                _shift = rd("shift_c").ToString
            End If
        End If
        db.closeDB()
        rd.Close()
        '_r1 = (_ratio * _ahour) / 100 'Commented  by SIS on 2016-Mar-31
        db.conecDB()
        db.initCMD()
        sql = "select sum(convert(int,a.duration)) as duration from LineShift_downtime_act as a "
        'Modified by SIS on 2016-Mar-31
        'sql = sql & "where a.factory_c='" + factory + "' and a.section_c='" + section + "' and a.line_c='" & line & "' and a.shift_c='" & _shift & "' and a.section_c='" & _sec & "' and a.work_date='" & _work & "' and a.status_flg<>'0' "
        sql = sql & "where a.factory_c='" & factory & "' and a.line_c='" & line & "' and a.shift_c='" & _shift & "' and a.section_c='" & section & "' and a.work_date='" & _work & "' and a.status_flg<>'0' "
        sql = sql & "and a.stop_En <= GETDATE()"                          '[6] Added By Gagan Kalyana on 2016-Feb-11
        rd = db.execReader(sql)
        'Commented and Modified by SIS on 2016-Mar-31[Start]
        'If rd.Read() Then
        '    If IsDBNull(rd("duration")) = False Then
        '        _r2 = rd("duration") / 3600
        '    End If
        'End If
        While rd.Read()
            If IsDBNull(rd("duration")) = False Then
                _work_ratio = System.Math.Round(rd("duration") / 3600, 5)
            End If
        End While
        'Commented and Modified by SIS on 2016-Mar-31[End]
        db.closeDB()
        rd.Close()
        '[6] Added By Gagan Kalyana on 2016-Feb-11 [Start]
        db.conecDB()
        db.initCMD()
        'Commented and Modified by SIS on 2016-Mar-31[Start]
        'sql = "select DATEDIFF(second, stop_st, getdate()) as duration from LineShift_downtime_act as a "
        'sql = sql & "where a.factory_c='" + factory + "' and a.section_c='" + section + "' and a.line_c='" & line & "' and a.shift_c='" & _shift & "' and a.section_c='" & _sec & "' and a.work_date='" & _work & "' and a.status_flg<>'0' "
        'sql = sql & "and getdate() between a.stop_st and a.stop_En"
        'rd = db.execReader(sql)
        'If rd.Read() Then
        '    If IsDBNull(rd("duration")) = False Then
        '        _r2 = _r2 + (rd("duration") / 3600)
        '    End If
        'End If
        sql = "select DATEDIFF(second, CAST(a.stop_st AS TIME), CAST(GETDATE() AS TIME)) as duration from LineShift_downtime_act as a "
        sql = sql & "where a.factory_c='" & factory & "' and a.line_c='" & line & "' and a.shift_c='" & _shift & "' and a.section_c='" & section & "' and a.work_date='" & _work & "' and a.status_flg<>'0' "
        sql = sql & "and CAST(GETDATE() AS TIME) between CAST(a.stop_st AS TIME) and CAST(a.stop_En AS TIME)"
        rd = db.execReader(sql)
        While rd.Read()

            If IsDBNull(rd("duration")) = False Then
                _work_ratio = _work_ratio + System.Math.Round(rd("duration") / 3600, 5)
            End If

        End While
        'Commented and Modified by SIS on 2016-Mar-31[End]
        db.closeDB()
        rd.Close()
        '[6] Added By Gagan Kalyana on 2016-Feb-11 [End]
        'Added by SIS on 2016-Mar-31[Start]
        Dim _work_time_act As String = "0.0"
        Dim dblWorkingTime As Double = getWorkingTime(factory, section, line, _shift, _work)

        _work_time_act = dblWorkingTime.ToString

        Dim _ratio_pl As Double = System.Math.Round((CDbl(_ratio) * CDbl(_work_time_act)) / 100, 2)
        'Added by SIS on 2016-Mar-31[End]

        'Modified by SIS on 2016-Mar-31
        'If _r2 <= _r1 Then
        If (_work_ratio <= _ratio_pl) Then
            j = 0
        Else
            j = 1
        End If
        Return j

    End Function

    'Added by Gagan Kalyana on 2016-Feb-11 [Start]
    Public Function production_prgress_check(ByVal factory As String, ByVal section As String, ByVal line As String) As Integer
        Dim strShift As String
        Dim strWork_Dt As String
        Dim intCount As Integer = 0
        Dim dblJudgementRate As Double = 0.0
        Dim intActualQty As Integer = 0
        Dim intPlanQty As Integer = 0
        Dim strSMH As String = ""
        Dim dsTables As New DataSet
        Dim CurQTy As Integer = 0       'Added by Gagan Kalyana on 2017-Mar-08

        strShift = _get_shift(factory, section, line)
        strWork_Dt = _get_work_date(factory, section, line)

        'Modified by Gagan Kalyana on 2017-Mar-08 [Start] 
        'strSql = "SELECT ISNULL(Param_Val, 0) FROM DicData_mst WHERE Data_C = 'P0101';"
        'strSql = strSql + "SELECT COUNT(*) FROM ACS_Insp_Res AS A WHERE A.Factory_C = '" + factory + "' AND A.Section_C = '" + section + "' AND A.Line_C = '" + line + "' "
        'strSql = strSql + "AND A.Shift = '" + strShift + "' AND A.Shift_St_Dt = '" + strWork_Dt + "';"
        'dataAdapter = New SqlDataAdapter(strSql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
        'dataAdapter.Fill(dsTables)

        'If dsTables.Tables(0).Rows.Count > 0 Then
        '    dblJudgementRate = Val(dsTables.Tables(0).Rows(0)(0))
        'End If

        'If dsTables.Tables(1).Rows.Count > 0 Then
        '    intActualQty = Val(dsTables.Tables(1).Rows(0)(0))
        'End If

        dblJudgementRate = Master.dblJudgementRate
        intActualQty = _get_Act_Qty(factory, section, line, strWork_Dt, strShift)

        If Master.strValue = True Then
            CurQTy = getSimpleProductionPLanQty(factory, section, line, strShift, strWork_Dt)
            If (intActualQty < CurQTy) Then
                Return 1
            Else
                Return 0
            End If
        Else    'Modified by Gagan Kalyana on 2017-Mar-08 [End]

            intPlanQty = _get_drawing_chart(factory, section, line, strWork_Dt, strShift)
            If ((intPlanQty - intActualQty) > (intPlanQty * (dblJudgementRate / 100))) Then
                dsTables.Clear()
                Return 1
            Else
                dsTables.Clear()
                Return 0
            End If
        End If 'Added by Gagan Kalyana on 2017-Mar-08
    End Function

    Private Function _get_drawing_chart(ByVal factory As String, ByVal section As String, ByVal line As String, ByVal work_dt As String, ByVal shift As String) As Integer
        Dim _BaseonTargetofline As Double = 0.0
        Dim intTemp As Integer = 0
        Dim _ahour_pl As Double = 0.0
        Dim _cycle_act As Double = 0.0
        Dim _tact_act As Double = 0.0
        Dim _dm As Double = 0.0
        Dim _step As Double = 0.0
        Dim tact_time_tg As Double = 0.0
        Dim _shift_begin As DateTime
        Dim _shift_st As DateTime
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

        Dim sql As String = ""
        Dim dtTable As New DataTable
        'Commented by SIS on 2016-Mar-31[Start]
        'strSql = "SELECT TOP 1 a.section_c,a.line_c,c.line_nm,b.proty_tg AS proty_taget,a.shift_c,a.work_date, "
        'strSql = strSql & "worker_name_1 =(SELECT TOP 1 user_nm from user_mst WHERE user_c=b.worker_c1), "
        'strSql = strSql & "worker_name_2 =(SELECT TOP 1 user_nm from user_mst WHERE user_c=b.worker_c2), "
        'strSql = strSql & "worker_name_3 =(SELECT TOP 1 user_nm from user_mst WHERE user_c=b.worker_c3), "
        'strSql = strSql & "CONVERT(NVARCHAR(19),a.upd_dt,108) AS upd_dt,b.qty_pl,b.tact_time,b.cycle_time,b.memo_dt, "
        'strSql = strSql & "b.smh_sh,b.amh_sh,b.effic_st_di AS effic_st,b.effic_st_in AS effic_act,b.ahour_pl,b.shour_pl,c.downtime_pl AS downtime_ratio_pl, "
        'strSql = strSql & "downtime_pl=(SELECT SUM(duration_pl) FROM lineshift_downtime_pl WHERE section_c=a.section_c AND line_c=a.line_c AND shift_c=a.shift_c AND work_date=a.work_date AND Factory_c = a.Factory_c GROUP BY section_c,line_c,work_date), "
        'strSql = strSql & "b.diman_act,spare=(f.man_act),leader=(e.man_act),b.inman_act,(b.diman_act+0+b.inman_act) AS total_act,(b.diman_pl+0+b.inman_pl) AS total_pl "
        'strSql = strSql & "FROM Shift_time_data AS a "
        'strSql = strSql & "JOIN line_data AS b on a.section_c=b.section_c AND a.line_c=b.line_c AND a.shift_c=b.shift_c AND a.work_date=b.work_date "
        'strSql = strSql & "AND a.Factory_c = b.Factory_c "
        'strSql = strSql & "JOIN line_mst AS c on a.section_c=c.section_c AND a.line_c=c.line_c "
        'strSql = strSql & "AND a.Factory_c = c.Factory_c "
        'strSql = strSql & "JOIN lineman_data AS d on a.section_c=d.section_c AND  a.line_c=d.line_c AND a.shift_c=d.shift_c AND a.work_date=d.work_date AND d.data_c='MAS09' "
        'strSql = strSql & "AND a.Factory_c = d.Factory_c "
        'strSql = strSql & "JOIN lineman_data AS e ON a.section_c=e.section_c AND  a.line_c=e.line_c AND a.shift_c=e.shift_c AND a.work_date=e.work_date AND e.data_c='MAS11' "
        'strSql = strSql & "AND a.Factory_c = e.Factory_c "
        'strSql = strSql & "JOIN lineman_data AS f on a.section_c=f.section_c AND  a.line_c=f.line_c AND a.shift_c=f.shift_c AND a.work_date=f.work_date AND f.data_c='MAS12' "
        'strSql = strSql & "AND a.Factory_c = f.Factory_c "
        'strSql = strSql & "WHERE a.factory_c='" & factory & "' and a.section_c='" & section & "' AND a.line_c='" & line & "' AND a.work_date='" & work_dt & "' AND a.shift_c='" & shift & "' "
        'strSql = strSql & "ORDER BY a.work_date desc,a.ent_dt desc "
        'Commented by SIS on 2016-Mar-31[End]

        'Added by SIS on 2016-Mar-31[Start]
        strSql = "select top 1 a.section_c,a.line_c,c.line_nm,b.proty_tg as proty_taget,a.shift_c,a.work_date, "
        strSql = strSql & "worker_name_1 =(select top 1 user_nm from user_mst where user_c=b.worker_c1), "
        strSql = strSql & "worker_name_2 =(select top 1 user_nm from user_mst where user_c=b.worker_c2), "
        strSql = strSql & "worker_name_3 =(select top 1 user_nm from user_mst where user_c=b.worker_c3), "
        strSql = strSql & "convert(nvarchar(19),a.upd_dt,108) as upd_dt,b.qty_pl,b.tact_time,b.cycle_time,b.memo_dt, "
        strSql = strSql & "b.smh_sh,b.amh_sh,b.effic_st_di as effic_st,b.effic_st_in as effic_act,b.ahour_pl,b.shour_pl,c.downtime_pl as downtime_ratio_pl, "
        strSql = strSql & "downtime_pl=(select sum(duration_pl) from lineshift_downtime_pl where section_c=a.section_c and line_c=a.line_c and shift_c=a.shift_c and work_date=a.work_date and Factory_c = a.Factory_c group by section_c,line_c,work_date), "
        strSql = strSql & "b.diman_act,b.inman_act,(b.diman_act+0+b.inman_act) as total_act,(b.diman_pl+0+b.inman_pl) as total_pl "
        strSql = strSql & "from Shift_time_data as a "
        strSql = strSql & "join line_data as b on a.section_c=b.section_c and a.line_c=b.line_c and a.shift_c=b.shift_c and a.work_date=b.work_date "
        strSql = strSql & "and a.Factory_c = b.Factory_c "
        strSql = strSql & "join line_mst as c on a.section_c=c.section_c and a.line_c=c.line_c "
        strSql = strSql & "and a.Factory_c = c.Factory_c "
        strSql = strSql & "where a.factory_c='" & factory & "' and a.section_c='" & section & "' and a.line_c='" & line & "' and a.work_date='" & work_dt & "' and a.shift_c='" & shift & "' "
        strSql = strSql & "order by a.work_date desc,a.ent_dt desc "
        'Added by SIS on 2016-Mar-31[End]

        dataAdapter = New SqlDataAdapter(strSql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
        dataAdapter.Fill(dtTable)

        If dtTable.Rows.Count > 0 Then
            For intTemp = 0 To dtTable.Rows.Count - 1
                If IsDBNull(dtTable.Rows(intTemp)("tact_time")) = False Then
                    _tact_act = CDbl(dtTable.Rows(intTemp)("tact_time")).ToString("##,###0.0")
                End If

                If IsDBNull(dtTable.Rows(intTemp)("ahour_pl")) = False Then
                    _ahour_pl = CDbl(dtTable.Rows(intTemp)("ahour_pl")).ToString("##,###0.00")
                End If

                'Modified by SIS on 2016-Mar-31[Start]
                'If IsDBNull(dtTable.Rows(intTemp)("total_act")) = False Then
                '    _dm = dtTable.Rows(intTemp)("total_act")
                'End If
                If IsDBNull(dtTable.Rows(intTemp)("diman_act")) = False Then
                    _dm = dtTable.Rows(intTemp)("diman_act")
                End If
                'Modified by SIS on 2016-Mar-31[End]

                If IsDBNull(dtTable.Rows(intTemp)("proty_taget")) = False Then
                    tact_time_tg = tact_time_tg / CDbl(dtTable.Rows(intTemp)("proty_taget"))
                End If
                If tact_time_tg > 0 Then
                    _cycle_act = tact_time_tg.ToString("##,###0.0")
                Else
                    _cycle_act = "0.0"
                End If
            Next
        End If

        dtTable.Clear()

        strSql = "SELECT a.start_time,a.end_time,a.time_c FROM Shift_time_data AS a WHERE "
        strSql = strSql & "a.factory_c='" & factory & "' AND a.section_c='" & section & "' AND  a.line_c='" & line & "' AND a.work_date='" & work_dt & "'  AND a.shift_c='" & shift & "' "

        dataAdapter = New SqlDataAdapter(strSql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
        dataAdapter.Fill(dtTable)

        If dtTable.Rows.Count > 0 Then
            For intTemp = 0 To dtTable.Rows.Count - 1
                Dim temp1 As DateTime = dtTable.Rows(intTemp)("start_time")
                Dim temp2 As DateTime = dtTable.Rows(intTemp)("end_time")
                Dim temp3 As String = dtTable.Rows(intTemp)("time_c")
                If (temp1 <> "1900-01-01 00:00:00.000") And (temp2 <> "1900-01-01 00:00:00.000") And (temp3 = "ST01") Then
                    _shift_st = temp1
                    _shift_date(i1, 0) = dtTable.Rows(intTemp)("end_time")
                    _shift_date(i1, 1) = dtTable.Rows(intTemp)("end_time")
                    i1 = i1 + 1
                End If
                If (temp1 <> "1900-01-01 00:00:00.000") And (temp2 <> "1900-01-01 00:00:00.000") And (temp3 <> "ST01") And (temp3 <> "ST08") Then
                    If DateDiff(DateInterval.Minute, dtTable.Rows(intTemp)("start_time"), dtTable.Rows(intTemp)("end_time")) > 0 Then
                        _shift_date(i1, 0) = dtTable.Rows(intTemp)("start_time")
                        _shift_date(i1, 1) = dtTable.Rows(intTemp)("end_time")
                        i1 = i1 + 1
                    End If
                End If
                If (temp1 <> "1900-01-01 00:00:00.000") And (temp2 <> "1900-01-01 00:00:00.000") And (temp3 = "ST08") Then
                    If DateDiff(DateInterval.Minute, dtTable.Rows(intTemp)("start_time"), dtTable.Rows(intTemp)("end_time")) > 0 Then
                        _shift_date(i1, 0) = dtTable.Rows(intTemp)("end_time")
                        _shift_date(i1, 1) = dtTable.Rows(intTemp)("end_time")
                        i1 = i1 + 1
                    End If
                End If
            Next
        End If

        dtTable.Clear()

        strSql = "SELECT a.stop_pl_st,a.stop_pl_en FROM LineShift_downtime_pl AS a WHERE "
        strSql = strSql & "a.factory_c='" & factory & "'  AND a.section_c='" & section & "' AND  a.work_date='" & work_dt & "' AND a.line_c='" & line & "' AND a.shift_c='" & shift & "'  "
        dataAdapter = New SqlDataAdapter(strSql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
        dataAdapter.Fill(dtTable)

        If dtTable.Rows.Count > 0 Then
            For intTemp = 0 To dtTable.Rows.Count - 1
                _shift_date(i1, 0) = dtTable.Rows(intTemp)("stop_pl_st")
                _shift_date(i1, 1) = dtTable.Rows(intTemp)("stop_pl_en")
                i1 = i1 + 1
            Next
        End If
        dtTable.Clear()
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

        If i1 - 1 > 0 Then
            If _shift_st > _shift_date(i1 - 1, 0) Then
                _shift_st = _shift_date(i1 - 1, 0)
            End If
        End If

        If _cycle_act > 0 Then
            _step = System.Math.Round((_cycle_act / 60), 2)
        End If

        j = 0
        _shift_begin = _shift_st

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

        Dim axis As Integer = 5
        If j - 1 > 50 Then
            axis = 8
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

        strSql = "SELECT  a.product_no,b.short_c,round((b.smh_sub+smh_asy)/3600,6) AS smh,a.proty_pl,a.plan_qty "
        strSql = strSql & "FROM production_plan AS a "
        strSql = strSql & "JOIN  product_mst AS b on a.product_no=b.product_no AND a.cusdesch_c1=b.cusdesch_c1 AND a.cusdesch_c2=b.cusdesch_c2 AND a.intdesch_c=b.intdesch_c  "
        strSql = strSql & "AND a.Factory_c = b.Factory_c "
        strSql = strSql & "WHERE a.factory_c='" & factory & "'  AND a.section_c='" & section & "' AND a.line_c='" & line & "' AND a.shift_c='" & shift & "' AND a.work_date='" & work_dt & "' AND a.plan_qty>0  "
        strSql = strSql & "ORDER BY a.priority asc "
        dataAdapter = New SqlDataAdapter(strSql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
        dataAdapter.Fill(dtTable)

        If dtTable.Rows.Count > 0 Then
            For intTemp = 0 To dtTable.Rows.Count - 1
                If IsDBNull(dtTable.Rows(intTemp)("plan_qty")) = False Then
                    temp_q = temp_q + dtTable.Rows(intTemp)("plan_qty")
                End If
                __step(n, 0) = temp_q
                If IsDBNull(dtTable.Rows(intTemp)("smh")) = False Then
                    temp = (dtTable.Rows(intTemp)("smh") / _dm)
                    temp = temp / (dtTable.Rows(intTemp)("proty_pl") / 100)
                    temp = System.Math.Round((temp * 60), 6)
                End If
                __step(n, 1) = temp
                n = n + 1
            Next
        End If
        dtTable.Clear()
        If __step(0, 1) <> 0 Then
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

        Return _BaseonTargetofline
    End Function
    'Added by Gagan Kalyana on 2016-Feb-11 [End]
    'Added by SIS on 2016-Mar-31 [START]
    Public Function _get_plan_Qty(ByVal factory As String, ByVal section As String, ByVal line As String, ByVal shift_st_dt As String, ByVal shift As String) As Integer
        Dim PlanQty As Integer = 0

        If Master.strValue = True Then  'Modified by Gagan Kalyana on 2017-Mar-08 [Start]
            PlanQty = getSimpleProductionPLanQty(factory, section, line, shift, shift_st_dt)
        Else                            'Modified by Gagan Kalyana on 2017-Mar-08 [End]
            PlanQty = _get_drawing_chart(factory, section, line, shift_st_dt, shift)
        End If      'Added by Gagan Kalyana on 2017-Mar-08

        Return PlanQty
    End Function

    Public Function _get_Act_Qty(ByVal factory As String, ByVal section As String, ByVal line As String, ByVal shift_st_dt As String, ByVal shift As String) As String

        Dim db As New Database
        Dim rd As SqlDataReader
        Dim ActQty As Integer = 0

        db.conecDB()
        db.initCMD()

        Dim sql As String
        sql = "select count(*) as ActQty"
        sql = sql & " from ACS_insp_res"
        sql = sql & " where factory_c='" + factory + "' and "
        sql = sql & "       section_c='" + section + "' and"
        sql = sql & "       line_c='" & line & "' and "
        sql = sql & "       shift_st_dt='" & shift_st_dt & "' and"
        sql = sql & "       shift='" & shift & "'"

        rd = db.execReader(sql)
        If rd.Read() Then
            If IsDBNull(rd("ActQty")) = False Then
                ActQty = rd("ActQty").ToString
            End If
        End If
        db.closeDB()
        rd.Close()
        Return ActQty

    End Function

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
                    'Modified by Gagan Kalyana on 2017-Mar-08 [Start] 
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
                    'Modified by Gagan Kalyana on 2017-Mar-08 [End]
            End Select
        Next

        For intCount = 0 To dataSet.Tables(1).Rows.Count - 1
            strTemp = dataSet.Tables(1).Rows(intCount)(0).ToString
            Select Case strTemp
                Case "ST01"
                    dblTotalWorkingTime = dblTotalWorkingTime + dataSet.Tables(1).Rows(intCount)(1)
                Case "ST08"
                    dblTotalWorkingTime = dblTotalWorkingTime + dataSet.Tables(1).Rows(intCount)(1)
                    'Modified by Gagan Kalyana on 2017-Mar-08 [Start] 
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
                    'Modified by Gagan Kalyana on 2017-Mar-08 [End]
            End Select
        Next

        dblTotalWorkingTime = dblTotalWorkingTime / 60
        workignHours = dblTotalWorkingTime 'Added by Gagan Kalyana on 2017-Mar-08 
        dblTotalWorkingTime = CDbl(Int(dblTotalWorkingTime).ToString + "." + (TimeSpan.FromMinutes(dblTotalWorkingTime).Seconds).ToString("00"))
        Return dblTotalWorkingTime
    End Function
    'Added by SIS on 2016-Mar-31 [End]

    'Added by Gagan Kalyana on 2017-Mar-08 [Start] 
    Private Sub HomeScreenValuesDisplay()
        Dim stTemp As String = ""
        Dim db As New Database
        Dim rd As SqlDataReader

        Try
            db.conecDB()
            db.initCMD()
            strSql = "SELECT DATA_C,DATA_NM,PARAM_VAL FROM DICDATA_MST WHERE CLASS = 'WEB' ORDER BY DATA_C "
            rd = db.execReader(strSql)

            While rd.Read()
                If IsDBNull(rd("DATA_C")) = False And IsDBNull(rd("PARAM_VAL")) = False And rd("PARAM_VAL") = 1 Then
                    stTemp = rd("DATA_C")

                    Select Case stTemp
                        Case "WEB01"                        'Data Code = WEB01:Production Qty.
                            btnDisplayProduction_Qty = True
                        Case "WEB02"                        'Data Code = WEB02:	Real Time Efficiency
                            btnDisplayEfficiecy = True
                        Case "WEB03"                        'Data Code = WEB03: Defect Ratio
                            btnDisplayDownTime = True
                        Case "WEB04"                        'Data Code = WEB04: Downtime Efficiency
                            btnDisplayDefect = True
                    End Select
                End If
            End While
        Catch ex As Exception

        Finally
            db.closeDB()
            rd.Close()
        End Try
    End Sub

    Public Sub getDefectCountLineWise(ByVal Factory_C As String, ByVal Section_C As String, ByVal Line_C As String, ByVal Shift As String, ByVal WorkDate As String)
        Dim strSql As String

        If (Shift <> "" And WorkDate <> "") Then
            strSql = "SELECT COUNT(Defect_C) AS Count,Factory_c,Section_C,Line_c FROM ACS_Defect_Res WHERE "
            strSql = strSql + "Factory_C = '" + Factory_C + "' AND Section_C = '" + Section_C + "' AND Line_C = '" + Line_C + "' AND "
            strSql = strSql + " [Shift]='" + Shift + "' AND CONVERT(VARCHAR(10), Insp_Dt, 121)  = CONVERT(VARCHAR(10), '" + CDate(WorkDate).ToString("yyyy-MM-dd") + " ', 121) "
            strSql = strSql + " GROUP By Factory_c,Section_C,Line_c, CONVERT(VARCHAR(10), Insp_Dt, 121)"

            If dataSet.Tables.Contains("ACS_Defect_Res") = True Then
                dataSet.Tables("ACS_Defect_Res").Clear()
            End If

            dataAdapter = New SqlDataAdapter(strSql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
            dataAdapter.Fill(dataSet, "ACS_Defect_Res")
        End If
    End Sub

    Public Function getDowntime(ByVal Factory_C As String, ByVal Section_C As String, ByVal Line_C As String, ByVal Shift As String, ByVal WorkDate As String) As Double
        Dim db As New Database
        Dim rd As SqlDataReader
        Dim _ratio As Double = 0.0
        Dim _work_time_act As String = "0.0"
        Dim _work_ratio As String = "0.0"
        Dim Sql As String
        Dim dblWorkingTime As Double = 0
        If WorkDate = "" Then
            Return 0
        End If

        If CDate(Date.Now).ToString("yyyy-MM-dd") = CDate(WorkDate).ToString("yyyy-MM-dd") Then

            db.conecDB()
            db.initCMD()

            Sql = "select sum(convert(int,a.duration)) as duration from LineShift_downtime_act as a "
            Sql = Sql & "where a.factory_c='" & Factory_C & "' and a.Section_C='" & Section_C & "' and a.Line_C='" & Line_C & "' and a.Shift_C='" & Shift & "' and a.work_date='" & WorkDate & "' and a.status_flg<>'0' "
            Sql = Sql & "and a.stop_En <= GETDATE()"
            rd = db.execReader(Sql)
            While rd.Read()
                If IsDBNull(rd("duration")) = False Then
                    _ratio = System.Math.Round(rd("duration") / 3600, 5)
                End If
            End While
            db.conecDB()
            rd.Close()


            db.conecDB()
            db.initCMD()
            Sql = "select DATEDIFF(second, CAST(a.stop_st AS TIME), CAST(GETDATE() AS TIME)) as duration from LineShift_downtime_act as a "
            Sql = Sql & "where a.factory_c='" & Factory_C & "' and a.Section_C='" & Section_C & "' and a.Line_C='" & Line_C & "' and a.Shift_C='" & Shift & "' and a.work_date='" & WorkDate & "' and a.status_flg<>'0' "
            Sql = Sql & "and CAST(GETDATE() AS TIME) between CAST(a.stop_st AS TIME) and CAST(a.stop_En AS TIME)"
            rd = db.execReader(Sql)
            While rd.Read()
                If IsDBNull(rd("duration")) = False Then
                    _ratio = _ratio + System.Math.Round(rd("duration") / 3600, 5)
                End If
            End While
            db.conecDB()
            rd.Close()

            dblWorkingTime = getWorkingTime(Factory_C, Section_C, Line_C, Shift, WorkDate)
            _work_time_act = workignHours
        Else
            db.conecDB()
            db.initCMD()
            Sql = "select sum(convert(int,a.duration)) as duration from LineShift_downtime_act as a "
            Sql = Sql & "where a.factory_c='" & Factory_C & "' and a.Section_C='" & Section_C & "' and a.Line_C='" & Line_C & "' and a.Shift_C='" & Shift & "' and a.work_date='" & WorkDate & "' and a.status_flg<>'0' "
            rd = db.execReader(Sql)
            While rd.Read()
                If IsDBNull(rd("duration")) = False Then
                    _ratio = System.Math.Round(rd("duration") / 3600, 5)
                End If
            End While

            db.conecDB()
            rd.Close()

            db.conecDB()
            db.initCMD()

            Sql = "select DATEDIFF(second, CAST(a.stop_st AS TIME), CAST(GETDATE() AS TIME)) as duration from LineShift_downtime_act as a "
            Sql = Sql & "where a.factory_c='" & Factory_C & "' and a.Section_C='" & Section_C & "' and a.Line_C='" & Line_C & "' and a.Shift_C='" & Shift & "' and a.work_date='" & WorkDate & "' and a.status_flg<>'0' "
            Sql = Sql & "and CAST(GETDATE() AS TIME) between CAST(a.stop_st AS TIME) and CAST(a.stop_En AS TIME)"
            rd = db.execReader(Sql)
            While rd.Read()
                If IsDBNull(rd("duration")) = False Then
                    _ratio = _ratio + System.Math.Round(rd("duration") / 3600, 5)
                End If
            End While
            db.conecDB()
            rd.Close()
            dblWorkingTime = getPastWorkingTime(Factory_C, Section_C, Line_C, Shift, WorkDate)
            _work_time_act = dblWorkingTime.ToString
        End If

        getDowntime = System.Math.Round((_ratio * 100) / CDbl(_work_time_act), 2)

    End Function

    Public Function getPastWorkingTime(ByVal Factory_C As String, ByVal Section_C As String, ByVal Line_C As String, ByVal Shift_C As String, ByVal Work_Date As String) As Double

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
                Case Else
                    If dataSet.Tables(0).Rows(intCount)(2) <> 1 Then
                        dblTotalWorkingTime = dblTotalWorkingTime - dataSet.Tables(0).Rows(intCount)(1)
                    End If
            End Select
        Next

        dblTotalWorkingTime = dblTotalWorkingTime / 60
        Return dblTotalWorkingTime
    End Function

    Public Function getRealTimeEfficiency(ByVal Factory_C As String, ByVal Section_C As String, ByVal Line_C As String, ByVal Shift_C As String, ByVal Work_Date As String) As Double
        Dim dblTime As Double = 0
        Dim dataTable As New DataTable
        Dim dataTable1 As New DataTable
        Dim db As New Database
        Dim rd As SqlDataReader

        strSql = "SELECT start_time,end_time,duration_time FROM Shift_time_data "
        strSql = strSql + "WHERE factory_c = '" & Factory_C & "' AND section_c = '" & Section_C & "' AND line_c = '" & Line_C & "' AND work_date = CAST('" & Work_Date & "' AS DATE) AND shift_C = '" & Shift_C & "'AND (time_c ='ST01'OR time_c ='ST08')  "
        strSql = strSql + "ORDER BY time_c"

        dataAdapter = New SqlDataAdapter(strSql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
        dataAdapter.Fill(dataTable)

        If (dataTable.Rows.Count > 0) Then

            If (dataTable.Rows(0)(0) <= Now) And ((dataTable.Rows(1)(1) >= Now) And (dataTable.Rows(1)(2) > 0)) Then
                dblTime = getWorkingTime(Factory_C, Section_C, Line_C, Shift_C, Work_Date)
                dblTime = workignHours
            Else
                dblTime = getPastWorkingTime(Factory_C, Section_C, Line_C, Shift_C, Work_Date)
            End If

            db.conecDB()
            db.initCMD()
            strSql = ""
            strSql = "select diman_act from Line_Data as a "
            strSql = strSql & "where a.factory_c='" & Factory_C & "' and a.Section_C='" & Section_C & "' and a.Line_C='" & Line_C & "' and a.Shift_C='" & Shift_C & "' and a.work_date='" & Work_Date & "' "
            rd = db.execReader(strSql)
            While rd.Read()
                If IsDBNull(rd("diman_act")) = False Then
                    dbtDimna_Act = rd("diman_act")
                End If
            End While

            db.conecDB()
            rd.Close()
            If dbtDimna_Act = 0 Then
                getRealTimeEfficiency = dblRealEff
                Exit Function
            End If
        Else
            getRealTimeEfficiency = dblRealEff
            Exit Function
        End If

        dataTable.Clear()

        If Master.strValue = True Then
            strSql = "SELECT ISNULL(SUM(Val)/ (" & dblTime.ToString & " * 3600 * " & dbtDimna_Act & "),0) AS Pp FROM "
            strSql = strSql + "(SELECT ISNULL(MAX(M.SMH),0) * ISNULL(COUNT(1),0) 'Val' "
            strSql = strSql + "FROM ACS_insp_res(NOLOCK) AIR LEFT JOIN Product_mst M(NOLOCK) "
            strSql = strSql + "ON AIR.FACTORY_C = M.FACTORY_C AND AIR.PRODUCT_NO = M.PRODUCT_NO AND AIR.CUSDESCH_C1=M.CUSDESCH_C1 AND AIR.CUSDESCH_C2=M.CUSDESCH_C2 AND AIR.INTDESCH_C=M.INTDESCH_C "
            strSql = strSql + "WHERE AIR.factory_c = '" & Factory_C & "' AND AIR.section_c = '" & Section_C & "' AND AIR.line_c = '" & Line_C & "' AND AIR.shift_st_dt = CAST('" & Work_Date & "' AS DATE) AND shift = '" & Shift_C & "' "
            strSql = strSql + "GROUP BY AIR.Product_No, AIR.CusDesch_C1, AIR.CusDesch_C2, AIR.IntDesch_C ) ABC"
        Else
            strSql = "SELECT ISNULL((SUM(I.Qty * ROUND((ISNULL(M.SMH, 0)), 6)))/ (" & dblTime.ToString & " * 3600 * " & dbtDimna_Act & "),0) AS Pp "
            strSql = strSql + "FROM Production_plan P(NOLOCK) "
            strSql = strSql + "LEFT JOIN Product_mst M(NOLOCK) ON P.Factory_c = M.Factory_c AND P.product_no = M.product_no and P.cusdesch_c1=M.cusdesch_c1 and P.cusdesch_c2=M.cusdesch_c2 and P.intdesch_c=M.intdesch_c "
            strSql = strSql + "LEFT JOIN (SELECT Product_No, CusDesch_C1, CusDesch_C2, IntDesch_C, ISNULL(COUNT(1),0) AS Qty FROM ACS_insp_res(NOLOCK) "
            strSql = strSql + "WHERE factory_c = '" & Factory_C & "' AND section_c = '" & Section_C & "' AND line_c = '" & Line_C & "' AND shift_st_dt = CAST('" & Work_Date & "' AS DATE) AND shift = '" & Shift_C & "' "
            strSql = strSql + "GROUP BY Product_No, CusDesch_C1, CusDesch_C2, IntDesch_C "
            strSql = strSql + ") I ON P.product_no = I.product_no and P.cusdesch_c1=I.cusdesch_c1 and P.cusdesch_c2=I.cusdesch_c2 and P.intdesch_c=I.intdesch_c "
            strSql = strSql + "WHERE P.factory_c = '" & Factory_C & "' AND P.section_c = '" & Section_C & "' AND P.line_c = '" & Line_C & "' AND P.work_date = CAST('" & Work_Date & "' AS DATE) AND P.shift_C = '" & Shift_C & "' "
        End If

        dataAdapter = New SqlDataAdapter(strSql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
        dataAdapter.Fill(dataTable1)

        If dataTable1.Rows.Count > 0 Then
            dblRealEff = dataTable1.Rows(0)(0)
            dblRealEff = CDbl(dataTable1.Rows(0)(0) * 100).ToString("0.00")
        Else
            dblRealEff = 0
        End If

        getRealTimeEfficiency = dblRealEff
    End Function

    Private Function getSimpleProductionPLanQty(ByVal factory As String, ByVal section As String, ByVal line As String, ByVal strShift As String, ByVal strWork_Dt As String) As Integer
        Dim db As New Database
        Dim rd As SqlDataReader
        Dim intDay As Integer
        Dim sqlConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
        Dim sqlCommand As SqlCommand = New SqlCommand("Proc_GetCurrentDayNo")
        Dim dt As New DataTable
        sqlCommand.CommandType = CommandType.StoredProcedure
        sqlCommand.Parameters.AddWithValue("dtDateTime", strWork_Dt)
        sqlCommand.Connection = sqlConnection
        Dim adpt As New SqlDataAdapter(sqlCommand)
        adpt.Fill(dt)

        If dt.Rows.Count > 0 Then
            intDay = Convert.ToInt16(dt.Rows(0)(0))
        End If
        db.conecDB()
        db.initCMD()

        Dim sql As String
        Dim Plan_Qty As Integer = 0
        Dim CurQTy As Integer = 0
        Dim TotalWrkHr As Double = 0
        Dim CurWrkHr As Double = 0
        sql = "SELECT Plan_Qty FROM Production_Simple_plan WHERE Factory_C = '" & factory & "' AND Section_C = '" & section & "' AND Line_C = '" & line & "' "
        sql = sql & "AND Shift = '" & strShift & "' AND Day_No = " & intDay.ToString() & " "

        rd = db.execReader(sql)
        If rd.Read() Then
            If IsDBNull(rd("Plan_Qty")) = False Then
                Plan_Qty = rd("Plan_Qty").ToString
            End If
        End If
        db.closeDB()
        rd.Close()
        Dim DataTable As New DataTable

        TotalWrkHr = getPastWorkingTime(factory, section, line, strShift, strWork_Dt)
        CurWrkHr = TotalWrkHr


        strSql = "SELECT start_time,end_time,duration_time FROM Shift_time_data "
        strSql = strSql + "WHERE factory_c = '" & factory & "' AND section_c = '" & section & "' AND line_c = '" & line & "' AND work_date = CAST('" & strWork_Dt & "' AS DATE) AND shift_C = '" & strShift & "'AND (time_c ='ST01'OR time_c ='ST08')  "
        strSql = strSql + "ORDER BY time_c"

        dataAdapter = New SqlDataAdapter(strSql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
        dataAdapter.Fill(DataTable)

        If (DataTable.Rows.Count > 0) Then
            If (DataTable.Rows(0)(0) <= Now) And ((DataTable.Rows(1)(1) >= Now) And (DataTable.Rows(1)(2) > 0)) Then CurWrkHr = getWorkingTime(factory, section, line, strShift, strWork_Dt)
        End If

        If CurQTy <> 0 Or Plan_Qty <> 0 Or TotalWrkHr <> 0 Then
            CurQTy = (Plan_Qty / TotalWrkHr) * (CurWrkHr) * ((100 - Master.dblJudgementRate) / 100)
        End If

        Return CurQTy
    End Function
    'Added by Gagan Kalyana on 2017-Mar-08 [End]
End Class
