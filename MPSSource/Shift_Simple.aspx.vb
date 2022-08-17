'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'File Name          : Shift_Simple.aspx
'Function           : To show visualization of ACS inspection process through graph for GVIA Simple Mode
'Created By         : Gagan Kalyana
'Created on         : 2017-Mar-20
'Revision History   : 
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Imports System.Web.UI
Imports System.Web.UI.HtmlControls
Imports System.Data.SqlClient
Imports System.Data
Imports System.Web.Services
Imports System.Globalization
Imports System.Web.Script.Serialization
Imports System.Web.UI.DataVisualization.Charting

Partial Class Shift_Simple
    Inherits System.Web.UI.Page

    Protected dataAdapter As SqlDataAdapter
    Protected dataSet As New DataSet
    Public Factory_C As String = ""
    Public Section_C As String = ""
    Public Line_C As String = ""
    Public Work_Date As String = ""
    Public Shift_C As String = ""
    Public Line_Nm As String = ""
    Public TotalWokringHours As Double = "0.0"
    Public DowntimeLimit As String = ""
    Public DirectWorker As String = ""
    Public InDirectWorker As String = ""
    Public TotalWorker As String = ""
    Public Proty_Pl As String = ""
    Public Cycle_Time As String = ""
    Public Leader As String = ""
    Protected dsInspData As New DataSet
    Protected DowntimeRatio As Double = 0.0
    Protected DowntimeRatio_Pl As Double = 0.0
    Protected DowntimeRatio_Act As Double = 0.0
    Protected PlanQty As Double = 0.0
    Protected DowntimeColor As String = "White"
    Protected _defectCount As Double = 0.0
    Protected _actualCount As Double = 0.0
    Protected _BaseonTargetofline As Double = 0.0
    Dim strSql As String = ""
    Protected dblJudgementRate As Double = 0.0

    Protected Sub Shift_Simple_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim intTemp As Integer
        If Not IsPostBack() Then
            Factory_C = Request("factory")
            Section_C = Request("section")
            Line_C = Request("line_C")
            Work_Date = Request("wk")
            Shift_C = Request("s")
            Line_Nm = Request("line_Nm")
            bt_Search.Text = ReadWriteXml.getAppResource("1197")
            txtWork_Date.Text = Format$(CDate(Work_Date), "dd/MM/yyyy") 'Left(Work_Date.ToString("dd/MM/yyyy"), 10)

            If (hdshift_C.Value = "") Then
                strSql = strSql & "SELECT DISTINCT A.Shift_c, A.Shift_Nm FROM Shift_Mst AS A "
                strSql = strSql & "WHERE  A.factory_c = '" + Request("factory") + "' AND A.Section_c='" & Request("section") & "'"
                dataSet.Tables.Clear()
                dataAdapter = New SqlDataAdapter(strSql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
                dataAdapter.Fill(dataSet, "Shift_Mst")
                If dataSet.Tables(0).Rows.Count > 0 Then
                    For intTemp = 0 To dataSet.Tables(0).Rows.Count - 1
                        shift.Items.Add(New ListItem(dataSet.Tables(0).Rows(intTemp)("Shift_Nm"), dataSet.Tables(0).Rows(intTemp)("Shift_c")))
                    Next
                End If
                hdshift_C.Value = Shift_C
            End If

            getLine_Data(Factory_C, Section_C, Line_C, Work_Date, Shift_C)
            getInspection_Data()
            getDowntime_Data()
            DrawChart()
        End If
    End Sub

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
            Dim dtWorkDate As DateTime = DateTime.ParseExact(txtWork_Date.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture)
            Work_Date = dtWorkDate.ToString("yyyy/MM/dd", CultureInfo.InvariantCulture)
            Factory_C = Request("factory")
            Section_C = Request("section")
            Line_C = Request("line_C")
            Shift_C = hdshift_C.Value
            Line_Nm = Request("line_Nm")
            getLine_Data(Factory_C, Section_C, Line_C, Work_Date, hdshift_C.Value)
            getInspection_Data()
            getDowntime_Data()
            DrawChart()
        Else
            Dim strError As String = ReadWriteXml.getAppResource("5001").ToString
            ScriptManager.RegisterStartupScript(Me, [GetType](), strError, "Showalert();", True)
            txtWork_Date.Focus()
        End If
    End Sub

    Private Sub getLine_Data(ByVal factory As String, ByVal section As String, ByVal line As String, ByVal work_dt As String, ByVal shift As String)
        Dim db As New Database
        Dim rd As SqlDataReader
        db.conecDB()
        db.initCMD()
        Dim strSql As String

        strSql = "SELECT TOP 1 A.SectiON_C, A.Line_C,A.Shift_c,A.Work_Date, B.Ahour_pl, C.Downtime_pl as Downtime_Ratio_Pl, B.Diman_Act,B.Inman_Act, (B.Diman_Act + B.InMan_Act) AS Total_Act,"
        strSql = strSql & "Worker_Name_2 = (SELECT TOP 1 User_Nm FROM User_Mst WHERE User_C=B.Worker_C2), B.Proty_Pl, (ISNULL(B.Tact_Time,0) * ISNULL(B.Effic_St_Di ,0)/ISNULL(B.Proty_Tg,0)) AS Cycle_Time FROM Shift_time_data AS A "
        strSql = strSql & "JOIN Line_Data AS B ON A.sectiON_c = B.sectiON_c AND A.Line_c=B.Line_c AND A.shift_c=B.shift_c AND A.work_date=B.work_date "
        strSql = strSql & "AND A.Factory_c = B.Factory_c JOIN Line_Mst AS C ON A.sectiON_c=C.sectiON_c AND A.Line_c=C.Line_c "
        strSql = strSql & "AND A.Factory_c = C.Factory_c "
        strSql = strSql & "WHERE A.factory_c='" & factory & "' AND A.sectiON_c='" & section & "' AND A.Line_c='" & line & "' AND A.work_date='" & work_dt & "' AND A.shift_c='" & shift & "' "
        strSql = strSql & "ORDER BY A.work_date DESC, A.ent_dt DESC "

        rd = db.execReader(strSql)
        While rd.Read()
            TotalWokringHours = CDbl(rd("Ahour_pl")).ToString
            DowntimeLimit = CDbl(rd("Downtime_Ratio_Pl")).ToString("###0.0")
            DirectWorker = rd("Diman_Act").ToString
            InDirectWorker = rd("Inman_Act").ToString
            TotalWorker = rd("Total_Act").ToString
            Leader = rd("Worker_Name_2").ToString
            Proty_Pl = rd("Proty_Pl").ToString
            If IsDBNull(rd("Cycle_Time")) = False Then
                Cycle_Time = rd("Cycle_Time").ToString
            End If
        End While
        db.closeDB()
        rd.Close()
    End Sub

    Private Sub getInspection_Data()
        Dim strSql As String
        strSql = "SELECT TOP 4 Defect_Nm, COUNT(1) AS Count FROM ACS_Defect_Res WHERE Factory_C = '" + Factory_C + "' AND Section_C = '" + Section_C + "' AND Line_C = '" + Line_C + "' AND "
        strSql = strSql + "Shift = '" + hdshift_C.Value.ToString + "' AND CAST(Insp_Dt AS DATE) = CAST('" + Work_Date + "' AS DATE) GROUP BY Defect_Nm ORDER By 2 DESC;"
        strSql = strSql + " SELECT AIR.PRODUCT_NO,(AIR.cusdesch_c1 + ' - ' +  AIR.cusdesch_c2 + ' - ' + MAX(AIR.intdesch_c)) DC, COUNT(AIR.Prodlbl_No) AS Result_Qty, MAX(PM.SMH) AS SMH FROM ACS_insp_res AIR "
        strSql = strSql & " INNER JOIN Product_Mst PM ON AIR.Product_No=PM.Product_No AND AIR.Cusdesch_C1=PM.Cusdesch_C1 AND AIR.Cusdesch_C2=PM.Cusdesch_C2 AND AIR.Intdesch_c=PM.Intdesch_c"
        strSql = strSql & " WHERE line_c='" & Line_C & "' AND Shift_st_dt='" & Work_Date & "'"
        strSql = strSql & " GROUP BY AIR.Product_no, AIR.Cusdesch_C1, AIR.Cusdesch_C2"
        dataAdapter = New SqlDataAdapter(strSql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
        dataAdapter.TableMappings.Add("Table", "ACS_Defect_Res")
        dataAdapter.TableMappings.Add("Table1", "ACS_insp_res")
        dataAdapter.Fill(dsInspData)
    End Sub

    Private Sub getDowntime_Data()
        Dim strSql As String
        Dim _color As String = "White"

        Dim _work_time_act As String = "0.0"
        Dim _work_ratio As String = "0.0"
        Dim ds As New DataSet

        If (IsNumeric(TotalWokringHours) = True) Then
            _work_time_act = TotalWokringHours
        End If

        If (IsNumeric(DowntimeLimit) = True) Then
            _work_ratio = DowntimeLimit
        End If

        strSql = "SELECT ISNULL(SUM(CONVERT(INT,A.DURATION)),0) AS DURATION FROM LINESHIFT_DOWNTIME_ACT AS A "
        strSql = strSql & "WHERE A.FACTORY_C = '" & Factory_C & "' AND A.SECTION_C = '" & Section_C & "'"
        strSql = strSql & " AND A.LINE_C = '" & Line_C & "' AND A.SHIFT_C = '" & hdshift_C.Value.ToString & "' "
        strSql = strSql & " AND A.WORK_DATE='" & Work_Date & "' AND A.STATUS_FLG<>'0' "
        If Format$(CDate(Request("WK")), "yyyy-MM-dd") = Format$(CDate(Work_Date), "yyyy-MM-dd") Then
            strSql = strSql & "AND A.STOP_EN <= GETDATE()"
        End If

        strSql = strSql & "; "
        strSql = strSql & "SELECT ISNULL(SUM(CONVERT(INT,A.DURATION)),0) AS DURATION FROM LINESHIFT_DOWNTIME_ACT AS A "
        strSql = strSql & "WHERE A.FACTORY_C = '" & Factory_C & "' AND A.SECTION_C = '" & Section_C & "'"
        strSql = strSql & " AND A.LINE_C = '" & Line_C & "' AND A.SHIFT_C = '" & hdshift_C.Value.ToString & "' "
        strSql = strSql & " AND A.WORK_DATE='" & Work_Date & "' AND A.STATUS_FLG<>'0' "
        strSql = strSql & "AND CAST(GETDATE() AS TIME) BETWEEN CAST(A.STOP_ST AS TIME) AND CAST(A.STOP_EN AS TIME)"
        dataAdapter = New SqlDataAdapter(strSql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
        dataAdapter.Fill(ds)

        If ds.Tables(0).Rows.Count > 0 Then
                DowntimeRatio = System.Math.Round(ds.Tables(0).Rows(0)(0) / 3600, 5)
        End If

        If ds.Tables(1).Rows.Count > 0 Then
                DowntimeRatio = DowntimeRatio + System.Math.Round(ds.Tables(1).Rows(0)(0) / 3600, 5)
        End If


        Dim dblWorkingTime As Double = 0
        'dblWorkingTime = getWorkingTime(Request("factory"), Request("section"), Request("line"), hdshift_C.Value.ToString, lb_working_day.Text)
        If Format$(CDate(Request("WK")), "yyyy-MM-dd") = Format$(CDate(Work_Date), "yyyy-MM-dd") Then
            dblWorkingTime = getWorkingTime(Factory_C, Section_C, Line_C, hdshift_C.Value.ToString, Work_Date)
        Else
            dblWorkingTime = getPastWorkingTime(Factory_C, Section_C, Line_C, hdshift_C.Value.ToString, Work_Date)
        End If

        _work_time_act = dblWorkingTime.ToString

        DowntimeRatio_Pl = System.Math.Round((CDbl(_work_ratio) * CDbl(_work_time_act)) / 100, 2)
        DowntimeRatio_Act = System.Math.Round((DowntimeRatio * 100) / CDbl(_work_time_act), 2)

        If (DowntimeRatio <= DowntimeRatio_Pl) Then
        Else
            DowntimeColor = "Red"
        End If
    End Sub

    Private Sub DrawChart()
        Dim sql As String = ""
        Dim db As New Database
        Dim rd As SqlDataReader
        Dim _cycle_act As Double = 153.68
        Dim _tact_act As Double = 100.01
        Dim _step As Double = 0.0
        Dim _shift_begin As DateTime
        Dim _shift_st As DateTime
        Dim _shift_end As DateTime
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
        Dim Shift_St_Tm As String = ""
        Dim Shift_En_Tm As String = ""

        sql = "SELECT A.START_TIME,A.END_TIME,A.TIME_C FROM SHIFT_TIME_DATA AS A WHERE "
        sql = sql & "A.FACTORY_C='" & Factory_C & "' AND A.SECTION_C='" & Section_C & "' AND  A.LINE_C='" & Line_C & "' AND A.WORK_DATE='" & Work_Date & "'  AND A.SHIFT_C='" & Shift_C & "' "
        sql = sql & " ORDER BY TIME_C DESC"

        db.conecDB()
        db.initCMD()
        rd = db.execReader(sql)
        While rd.Read()
            Dim temp1 As DateTime = rd("START_TIME")
            Dim temp2 As DateTime = rd("END_TIME")
            Dim temp3 As String = rd("time_c")
            If (temp1 <> "1900-01-01 00:00:00.000") And (temp2 <> "1900-01-01 00:00:00.000") And (temp3 = "ST01") Then
                _shift_st = temp1
                _shift_date(i1, 0) = rd("END_TIME")
                _shift_date(i1, 1) = rd("END_TIME")
                i1 = i1 + 1
                Shift_St_Tm = rd("START_TIME")
                Shift_En_Tm = rd("END_TIME")
            End If
            If (temp1 <> "1900-01-01 00:00:00.000") And (temp2 <> "1900-01-01 00:00:00.000") And (temp3 <> "ST01") And (temp3 <> "ST08") Then
                If DateDiff(DateInterval.Minute, rd("START_TIME"), rd("END_TIME")) > 0 Then
                    _shift_date(i1, 0) = rd("START_TIME")
                    _shift_date(i1, 1) = rd("END_TIME")
                    i1 = i1 + 1
                End If
            End If
            If (temp1 <> "1900-01-01 00:00:00.000") And (temp2 <> "1900-01-01 00:00:00.000") And (temp3 = "ST08") Then
                If DateDiff(DateInterval.Minute, rd("START_TIME"), rd("END_TIME")) > 0 Then
                    _shift_date(i1, 0) = rd("END_TIME")
                    _shift_date(i1, 1) = rd("END_TIME")
                    i1 = i1 + 1
                    If rd("END_TIME") <> rd("START_TIME") Then
                        Shift_En_Tm = rd("END_TIME")
                    End If
                End If
            End If
        End While
        db.closeDB()
        rd.Close()

        sql = "SELECT A.STOP_PL_ST,A.STOP_PL_EN FROM LINESHIFT_DOWNTIME_PL AS A WHERE "
        sql = sql & "A.FACTORY_C='" & Factory_C & "'  AND A.SECTION_C='" & Section_C & "' AND  A.WORK_DATE='" & Work_Date & "' AND A.LINE_C='" & Line_C & "' AND A.SHIFT_C='" & Shift_C & "'  "
        db.conecDB()
        db.initCMD()
        rd = db.execReader(sql)
        While rd.Read()
            _shift_date(i1, 0) = rd("STOP_PL_ST")
            _shift_date(i1, 1) = rd("STOP_PL_EN")
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


        If i1 - 1 > 0 Then
            If _shift_st > _shift_date(i1 - 1, 0) Then
                _shift_st = _shift_date(i1 - 1, 0)
            End If
        Else
            Exit Sub
        End If

        'Chart for Tact Time Target                       
        If Cycle_Time > 0 Then
            _step = System.Math.Round((Cycle_Time / 60), 2)
        End If
        If _step = 0 Then
            _step = 5
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

        ''''''''''''''''''''''''''CHART'''''''''''''''''''''''''''''''
        Dim axis As Integer = 5
        Dim yaxis = 30

        If j - 1 > 50 Then axis = 4
        If _uC >= 300 And _uC <= 500 Then yaxis = 50
        If _uC > 500 And _uC < 1000 Then yaxis = 70
        If _uC >= 1000 And _uC < 1300 Then yaxis = 90
        If _uC >= 1300 Then yaxis = 200

        Dim FontName As String = "Tahoma"
        Dim FontSize As Integer = 9
        Dim FS As New Drawing.Font(FontName, FontSize, Drawing.FontStyle.Regular)
        Chart1.ChartAreas(0).AxisY.Interval = yaxis
        Chart1.ChartAreas(0).AxisX.Interval = axis
        Chart1.ChartAreas(0).AxisX.LineColor = Drawing.Color.Orange
        Chart1.ChartAreas(0).AxisY.LineColor = Drawing.Color.Orange
        Chart1.Legends(0).IsDockedInsideChartArea = False
        Chart1.Legends(0).Docking = Docking.Top
        Chart1.ChartAreas(0).AxisX.MajorGrid.LineDashStyle = ChartDashStyle.Dot
        Chart1.ChartAreas(0).AxisX.IsMarginVisible = False
        Chart1.ChartAreas(0).AxisX.MajorGrid.LineColor = Drawing.Color.White
        Chart1.ChartAreas(0).AxisY.MajorGrid.LineDashStyle = ChartDashStyle.Dot
        Chart1.ChartAreas(0).AxisY.MajorGrid.LineColor = Drawing.Color.White
        Chart1.ChartAreas(0).AxisX.LabelStyle.Font = FS
        Chart1.ChartAreas(0).AxisX.LabelStyle.ForeColor = Drawing.Color.White
        Chart1.ChartAreas(0).AxisY.LabelStyle.Font = FS
        Chart1.ChartAreas(0).AxisY.LabelStyle.ForeColor = Drawing.Color.White
        Chart1.ChartAreas(0).AxisY.IsStartedFromZero = True

        Dim intDay As Integer
        Dim sqlConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
        Dim sqlCommand As SqlCommand = New SqlCommand("Proc_GetCurrentDayNo")
        Dim dt As New DataTable
        sqlCommand.CommandType = CommandType.StoredProcedure
        sqlCommand.Parameters.AddWithValue("dtDateTime", Work_Date)
        sqlCommand.Connection = sqlConnection
        Dim adpt As New SqlDataAdapter(sqlCommand)
        adpt.Fill(dt)

        If dt.Rows.Count > 0 Then
            intDay = Convert.ToInt16(dt.Rows(0)(0))
        End If


        'Chart for Production plan
        sql = "SELECT Plan_Qty FROM Production_Simple_Plan PSM WHERE PSM.FACTORY_C = '" & Factory_C & "' AND PSM.SECTION_C='" & Section_C & "' "
        sql = sql & " AND PSM.LINE_C = '" & Line_C & "' AND PSM.SHIFT = '" & Shift_C & "' AND PSM.Day_No = " & intDay.ToString & ""

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
            If IsDBNull(rd("Plan_Qty")) = False Then
                temp_q = temp_q + rd("Plan_Qty")
                PlanQty = temp_q
            End If
        End While
        db.closeDB()
        rd.Close()

        _step = (DateAndTime.DateDiff(DateInterval.Minute, CDate(Shift_St_Tm), CDate(Shift_En_Tm)) - 5) / temp_q
        If _step = 0 Then
            Exit Sub
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

        Dim x As New Series
        x.Name = ReadWriteXml.getAppResource("1195").ToString()
        x.XValueType = ChartValueType.String
        x.ChartType = SeriesChartType.Line
        x.BorderWidth = 2
        x.Color = Drawing.Color.Orange

        For i = 0 To j - 1
            Dim _value As DateTime = _xY(i, 0)
            _shift_end = _value
            x.Points.AddXY(_value.ToShortTimeString, _xY(i, 1).ToString)
            If _xY(i, 1) >= temp_q Then
                Dim _fontname As String = "Arial"
                Dim _fontsize As Integer = 10
                Dim _font As New Drawing.Font(_fontname, _fontsize, Drawing.FontStyle.Regular)
                x.Points(i).Font = _font
                x.Points(i).LabelForeColor = Drawing.Color.Orange
                Dim __value As Double = _xY(i, 1)
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

        strSql = "SELECT ISNULL(Param_Val, 0) FROM DicData_mst WHERE Data_C = 'P0101';"
        dataSet.Tables.Clear()
        dataAdapter = New SqlDataAdapter(strSql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
        dataAdapter.Fill(dataSet)

        If dataSet.Tables(0).Rows.Count > 0 Then
            dblJudgementRate = Convert.ToInt16(dataSet.Tables(0).Rows(0)(0))
        End If
        Dim iDownTimePer As Int16 = dblJudgementRate

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

        sql = "SELECT COUNT(*) AS TOTAL FROM ACS_INSP_RES AS A WHERE A.FACTORY_C='" & Factory_C & "' AND A.SECTION_C='" & Section_C & "' "
        sql = sql & " AND A.LINE_C='" & Line_C & "' AND A.SHIFT = '" & Shift_C & "' AND A.SHIFT_ST_DT = '" & Work_Date & "' "

        Dim _count As Integer = 0
        db.conecDB()
        db.initCMD()
        rd = db.execReader(sql)
        If rd.Read() Then
            If IsDBNull(rd("TOTAL")) = False Then
                _count = Convert.ToInt32(rd("TOTAL"))
                _actualCount = _count
            End If
        End If
        db.closeDB()
        rd.Close()

        If _count = 0 Then
            Exit Sub
        End If

        ReDim _xA(_count, 2)

        sql = "SELECT DATEADD(dd,0,A.ENT_DT) AS ENT_DT FROM ACS_INSP_RES AS A "
        sql = sql & "WHERE A.FACTORY_C='" & Factory_C & "' AND A.LINE_C='" & Line_C & "' AND A.SHIFT='" & Shift_C & "' AND A.SHIFT_ST_DT='" & Work_Date & "' "
        sql = sql & "and A.section_c='" & Section_C & "' ORDER BY A.ENT_DT ASC "

        db.conecDB()
        db.initCMD()
        rd = db.execReader(sql)
        While rd.Read()
            _xA(_y, 0) = rd("ENT_DT")
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
        If _shift_end <= _shift_begin Then _shift_end = _shift_begin

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

        Dim lstDef As New List(Of DateTime)

        sql = "SELECT INSP_DT FROM ACS_DEFECT_RES WHERE FACTORY_C = '" & Factory_C & "' AND SECTION_C = '" & Section_C & "' AND LINE_C = '" & Line_C & "' AND "
        sql = sql & "SHIFT = '" & Shift_C & "' AND CAST(INSP_DT AS DATE) = CAST('" & Work_Date & "' AS DATE) ORDER BY INSP_DT ASC"

        db.conecDB()
        db.initCMD()
        rd = db.execReader(sql)

        While rd.Read()
            lstDef.Add(rd("Insp_Dt"))
        End While
        db.closeDB()
        rd.Close()

        Dim lstDefPeriod As New List(Of DateTime)
        _shift_begin = _shift_st

        _defectCount = CInt(lstDef.Count)

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
                Case Else
                    If dataSet.Tables(0).Rows(intCount)(2) <> 1 Then
                        dblTotalWorkingTime = dblTotalWorkingTime - dataSet.Tables(0).Rows(intCount)(1)
                    End If
            End Select
        Next

        For intCount = 0 To dataSet.Tables(1).Rows.Count - 1
            strTemp = dataSet.Tables(1).Rows(intCount)(0).ToString
            Select Case strTemp
                Case "ST01"
                    dblTotalWorkingTime = dblTotalWorkingTime + dataSet.Tables(1).Rows(intCount)(1)
                Case "ST08"
                    dblTotalWorkingTime = dblTotalWorkingTime + dataSet.Tables(1).Rows(intCount)(1)
                Case Else
                    If dataSet.Tables(1).Rows(intCount)(2) <> 1 Then
                        dblTotalWorkingTime = dblTotalWorkingTime - dataSet.Tables(1).Rows(intCount)(1)
                    End If
            End Select
        Next

        dblTotalWorkingTime = dblTotalWorkingTime / 60

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
                Case Else
                    If dataSet.Tables(0).Rows(intCount)(2) <> 1 Then
                        dblTotalWorkingTime = dblTotalWorkingTime - dataSet.Tables(0).Rows(intCount)(1)
                    End If
            End Select
        Next

        dblTotalWorkingTime = dblTotalWorkingTime / 60
        Return dblTotalWorkingTime
    End Function

    Public Function getSimpleProductionPLanQty(ByVal factory As String, ByVal section As String, ByVal line As String, ByVal strShift As String, ByVal strWork_Dt As String) As Integer
        Dim db As New Database
        Dim rd As SqlDataReader

        db.conecDB()
        db.initCMD()

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

        Dim sql As String
        Dim Plan_Qty As Integer = 0
        Dim CurQTy As Integer = 0
        Dim TotalWrkHr As Double = 0
        Dim CurWrkHr As Double = 0
        sql = "SELECT Plan_Qty FROM Production_Simple_plan WHERE Factory_C = '" & factory & "' AND Section_C = '" & section & "' AND Line_C = '" & line & "' "
        sql = sql & "AND Shift = '" & strShift & "' AND Day_No = " & intDay.ToString & ""

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
            If (DataTable.Rows.Count > 1) Then
                If (DataTable.Rows(0)(0) <= Now) And ((DataTable.Rows(1)(1) >= Now) And (DataTable.Rows(1)(2) > 0)) Then CurWrkHr = getWorkingTime(factory, section, line, strShift, strWork_Dt)
            Else
                If (DataTable.Rows(0)(0) <= Now) And ((DataTable.Rows(0)(1) >= Now) And (DataTable.Rows(0)(2) > 0)) Then CurWrkHr = getWorkingTime(factory, section, line, strShift, strWork_Dt)
            End If

        End If

        If CurQTy <> 0 And Plan_Qty <> 0 And TotalWrkHr <> 0 Then
            CurQTy = (Plan_Qty / TotalWrkHr) * (CurWrkHr) * ((100 - dblJudgementRate) / 100)
        End If

        Return CurQTy
    End Function
End Class
