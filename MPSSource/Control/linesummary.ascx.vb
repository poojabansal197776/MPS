'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'File Name          : linesummary.ascx.vb
'Function           : To Output Production report in the Excel format
'Created By         : 
'Created on         : 
'Revision History   : Modified by Gagan Kalayana on 30-Mar-2015 for the FC63 Anken
'                     To read all text fields of crystal report from resource file
'                   : Modified by Gagan Kalyana on 2015-Apr-02 for unused code removal
'                   : Added by Gagan Kalyana on 2015-Apr-24 for reasource reading
'                   : Modified by Gagan Kalyana on 2015-May-08 for FC63 Anken
' 		              Modifications done for proper japanese caption display
'                   : Modified by Gagan Kalyana on 2016-Mar-15 for FC66-GLOBAL VISUALIZING IN-ASSEMBLY SYSTEM_PHASE2
'                     Changes has been done to:
'                     [1] To abolish crystal report from the screen.
'                     [2] To add output criteria for the new excel report generation.
'                     [3] To output excel report against the selected data in the Output criteria.
'                   : Modified by Gagan Kalyana on 2016-Apr-05 for FC66-GLOBAL VISUALIZING IN-ASSEMBLY SYSTEM_PHASE2
'                     Changes has been done to generate excel report without installing MS-Excel on server. (IS3 Req. No ER/160407001)
'                   : Modified by Gagan Kalyana on 2017-Mar-20 for FC69_GVIA-Phase-III-I
'                     Changes has been done to generate the excel report for GVIA Simple version with PLan Qty from Production_Simple_Plan table
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'Commented by Gagan Kalyana on 2015-Apr-02 [Start]
'Imports System.IO
'Imports System.Data
'Imports System.Web.HttpApplication
'Imports CrystalDecisions.Shared
'Imports CrystalDecisions.Web
'Imports CrystalDecisions.ReportSource
'Commented by Gagan Kalyana on 2015-Apr-02 [End]
'Imports CrystalDecisions.CrystalReports.Engine          [1] Commented by Gagan Kalyana on 2016-Mar-15
Imports System.Data.SqlClient
Imports Excel = Microsoft.Office.Interop.Excel           '[3] Added by Gagan Kalyana on 2016-Mar-15 [Start]
Imports System.Data
Imports System.Globalization
Imports System.IO                                        '[3] Added by Gagan Kalyana on 2016-Mar-15 [End]

Partial Class Control_linesummary
    Inherits System.Web.UI.UserControl
    'Private sql As String                           [1] Commented by Gagan Kalyana on 2016-Mar-15
    'Dim crystalReport As New ReportDocument()       [1] Commented by Gagan Kalyana on 2016-Mar-15
    Dim obj As New FunctionControl()                'Added Gagan Kalyana on 2017-Mar-20

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        '[2] Commented and added by Gagan Kalyana on 2016-Mar-15 [Start]
        'btnSearch.Text = ReadWriteXml.getAppResource("1197").ToString() 'Added by Gagan Kalyana on 2015-Apr-24
        If Not IsPostBack() Then
            btnSearch.Text = ReadWriteXml.getAppResource("1263").ToString()
            '[2] Commented and added by Gagan Kalyana on 2016-Mar-15 [Start]

            Dim db As New Database
            Dim rd As SqlDataReader
            Dim sql As String = ""

            sql = "Select distinct factory_c from factory_mst order by factory_c "
            db.conecDB()
            db.initCMD()
            rd = db.execReader(sql)
            While rd.Read()
                dr_company.Items.Add(New ListItem(rd("factory_c"), rd("factory_c")))
            End While
            db.closeDB()
            rd.Close()

            db.conecDB()
            db.initCMD()
            dr_section.Items.Add(New ListItem("*", "*"))
            sql = "select distinct a.section_c "
            sql = sql & "from section_mst as a "
            '[FC] Commented and Modified by Govind on 2015-Mar-19
            'sql = sql & "where a.factory_c='" + dr_company.Text + "' and left(a.section_c,3)='ASY' "
            sql = sql & "where a.factory_c='" + dr_company.Text + "' "
            rd = db.execReader(sql)
            While rd.Read()
                dr_section.Items.Add(New ListItem(rd("section_c"), rd("section_c")))
            End While
            db.closeDB()
            rd.Close()

            db.conecDB()
            db.initCMD()
            sql = "select distinct a.line_c, a.section_c "
            sql = sql & "from line_mst as a where a.factory_c='" + dr_company.Text + "' and section_c='" & dr_section.Text & "' order by a.section_c "

            rd = db.execReader(sql)
            dr_line.Items.Add(New ListItem("*", "*"))
            While rd.Read()
                dr_line.Items.Add(New ListItem(rd("line_c"), rd("line_c")))
            End While
            db.closeDB()
            rd.Close()

            'txtdate.Text = Format(Now(), "MM/dd/yyyy")     [2] Modified by Gagan Kalyana on 2016-Mar-15
            txt_stDate.Text = Format(Now(), "yyyy/MM/dd")
            'txtdate1.Text = Format(Now(), "MM/dd/yyyy")    [2] Modified by Gagan Kalyana on 2016-Mar-15
            txt_endDate.Text = Format(Now(), "yyyy/MM/dd")

            '[2] Added by Gagan Kalyana on 2016-Mar-15 [Start]
            dr_shift.Items.Add(New ListItem("*", "*"))
            dr_leader.Items.Add(New ListItem("*", "*"))
        End If '[2] Added by Gagan Kalyana on 2016-Mar-15 [End]
    End Sub

    '[FC] Commented by Govind on 2015-Mar-19
    'Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load, btnSearch.Click
        '[1] Commented by Gagan Kalyana on 2016-Mar-15 [Start]
        'If IsDBNull(crystalReport) = True Then
        '    crystalReport = New ReportDocument
        'End If
        'If txtdate.Text <> "" And txtdate1.Text <> "" Then
        '    bindReport()
        'End If
        '[1] Commented by Gagan Kalyana on 2016-Mar-15 [End]
    End Sub

    '[1] Commented by Gagan Kalyana on 2016-Mar-15 [Start]
    'Private Function GetData(ByVal query As String) As DataSet2
    '    Dim conString As String = ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString
    '    Dim cmd As New SqlCommand(query)
    '    Using con As New SqlConnection(conString)
    '        Using sda As New SqlDataAdapter()
    '            cmd.Connection = con
    '            sda.SelectCommand = cmd
    '            Using ds As New DataSet2()
    '                sda.Fill(ds, "Datatable1")
    '                Return ds
    '            End Using
    '        End Using
    '    End Using
    'End Function
    '[1] Commented by Gagan Kalyana on 2016-Mar-15 [End]

    '[FC] Commented by Govind on 2015-Mar-19 [Start]
    'Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSearch.Click
    '
    'End Sub
    '[FC] Commented by Govind on 2015-Mar-19 [End]

    '[1] Commented by Gagan Kalyana on 2016-Mar-15 [Start]
    'Public Sub bindReport()
    '    Dim Path_Report As String = "~/Report/linesummary.rpt"
    '    Dim reportCacheKey As String = Server.MapPath(Path_Report)
    '    If IsDBNull(Cache(reportCacheKey)) = True Then
    '        crystalReport = Cache(reportCacheKey)
    '        crystalReport.Close()
    '        crystalReport.Dispose()
    '    Else
    '        Dim txt_date_1 As String
    '        txt_date_1 = txtdate.Text
    '        Dim txt_date_11 As String
    '        txt_date_11 = txtdate.Text

    '        Dim txt_date_2 As String
    '        txt_date_2 = txtdate1.Text
    '        Dim txt_date_21 As String
    '        txt_date_21 = txtdate1.Text

    '        'If dr_line.Text <> "*" Then
    '        '    sql = "select a.section_c,a.line_c,a.shift_c,convert(nvarchar(10),a.work_date,101) as work_date,a.ahour_act,a.shour_act,a.group_id,a.flg_end, "
    '        '    sql = sql & "leader=(select top 1 user_nm from user_mst where user_c=a.worker_c2), "
    '        '    sql = sql & "subleader=(select top 1 user_nm from user_mst where user_c=a.worker_c3), "
    '        '    sql = sql & "a.tact_time, a.cycle_time, a.smh_sh, a.amh_sh, a.effic_st_di as effic_st, a.effic_st_in as effic_act, "
    '        '    sql = sql & "a.m01, a.m02, a.m03, a.m04, a.diman_act, a.inman_act, "
    '        '    sql = sql & "defect_c=(select sum(no_of_defect) from Defect_res where a.factory_c=factory_c and a.section_c=section_c and a.line_c=line_c and a.shift_c=shift_c and a.work_date =work_date ),a.qty_pl,a.qty_act,a.proty_tg as proty_pl, b.SMH_ACT_Total,b.AMH_Total_di  "
    '        '    sql = sql & "from Line_Data as a  "
    '        '    sql = sql & "left join Production_hdr as b on a.factory_c=b.factory_c and a.section_c=b.section_c and a.line_c=b.line_c and a.work_date=b.work_date and a.shift_c=b.shift_c "
    '        '    sql = sql & "where a.factory_c='" + dr_company.Text + "' and  a.section_c='" & dr_section.Text & "' and a.line_c='" & dr_line.SelectedValue.ToString & "' and a.work_date between '" & txt_date_1 & "' and '" & txt_date_2 & "' "
    '        '    sql = sql & "order by a.work_date desc "
    '        'Else
    '        '    sql = "select a.section_c,a.line_c,a.shift_c,convert(nvarchar(10),a.work_date,101) as work_date,a.ahour_act,a.shour_act,a.group_id,a.flg_end, "
    '        '    sql = sql & "leader=(select top 1 user_nm from user_mst where user_c=a.worker_c2), "
    '        '    sql = sql & "subleader=(select top 1 user_nm from user_mst where user_c=a.worker_c3), "
    '        '    sql = sql & "a.tact_time, a.cycle_time, a.smh_sh, a.amh_sh, a.effic_st_di as effic_st, a.effic_st_in as effic_act, "
    '        '    sql = sql & "a.m01, a.m02, a.m03, a.m04, a.diman_act, a.inman_act, "
    '        '    sql = sql & "defect_c=(select sum(no_of_defect) from Defect_res where a.factory_c=factory_c and a.section_c=section_c and a.line_c=line_c and a.shift_c=shift_c and a.work_date =work_date ),a.qty_pl,a.qty_act,a.proty_tg as proty_pl, b.SMH_ACT_Total,b.AMH_Total_di  "
    '        '    sql = sql & "from Line_Data as a  "
    '        '    sql = sql & "left join Production_hdr as b on a.factory_c=b.factory_c and a.section_c=b.section_c and a.line_c=b.line_c and a.work_date=b.work_date and a.shift_c=b.shift_c "
    '        '    sql = sql & "where a.factory_c='" + dr_company.Text + "'  and a.work_date between '" & txt_date_1 & "' and '" & txt_date_2 & "' "
    '        '    sql = sql & "order by a.work_date desc "

    '        'End If

    '        sql = "select a.section_c,a.line_c,a.shift_c,convert(nvarchar(10),a.work_date,101) as work_date,a.ahour_act,a.shour_act,a.group_id,a.flg_end, "
    '        sql = sql & "leader=(select top 1 user_nm from user_mst where user_c=a.worker_c2), "
    '        sql = sql & "subleader=(select top 1 user_nm from user_mst where user_c=a.worker_c3), "
    '        sql = sql & "a.tact_time, a.cycle_time, a.smh_sh, a.amh_sh, a.effic_st_di as effic_st, a.effic_st_in as effic_act, "
    '        sql = sql & "a.m01, a.m02, a.m03, a.m04, a.diman_act, a.inman_act, "
    '        sql = sql & "defect_c=(select sum(no_of_defect) from Defect_res where a.factory_c=factory_c and a.section_c=section_c and a.line_c=line_c and a.shift_c=shift_c and a.work_date =work_date ),a.qty_pl,a.qty_act,a.proty_tg as proty_pl, b.SMH_ACT_Total,b.AMH_Total_di  "
    '        sql = sql & "from Line_Data as a  "
    '        sql = sql & "left join Production_hdr as b on a.factory_c=b.factory_c and a.section_c=b.section_c and a.line_c=b.line_c and a.work_date=b.work_date and a.shift_c=b.shift_c "
    '        sql = sql & "where a.factory_c='" + dr_company.Text + "' "
    '        If dr_section.Text <> "*" Then
    '            sql = sql & "and  a.section_c='" & dr_section.Text & "' "
    '        End If
    '        If dr_line.Text <> "*" Then
    '            sql = sql & "and a.line_c='" & dr_line.SelectedValue.ToString & "' "
    '        End If
    '        sql = sql & "and a.work_date between '" & txt_date_1 & "' and '" & txt_date_2 & "' "
    '        sql = sql & "order by a.work_date desc "


    '        crystalReport.Load(Server.MapPath(Path_Report))

    '            crystalReport.DataDefinition.FormulaFields("assy").Text = "'" + dr_section.Text + "'"
    '            crystalReport.DataDefinition.FormulaFields("line").Text = "'" + dr_line.Text + "'"
    '            crystalReport.DataDefinition.FormulaFields("starttime").Text = "'" + txt_date_11 + "'"
    '        crystalReport.DataDefinition.FormulaFields("endtime").Text = "'" + txt_date_21 + "'"

    '        'Added by Gagan Kalyana on 30-Mar-2015 [Start]
    '        crystalReport.DataDefinition.FormulaFields("DisplayAssy:").Text = "'" + ReadWriteXml.getAppResource("1149").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayLine:").Text = "'" + ReadWriteXml.getAppResource("1150").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayFrom:").Text = "'" + ReadWriteXml.getAppResource("1151").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayTo:").Text = "'" + ReadWriteXml.getAppResource("1152").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayProductionSummary").Text = "'" + ReadWriteXml.getAppResource("1148").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayPrintdate:").Text = "'" + ReadWriteXml.getAppResource("1169").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplaySection").Text = "'" + ReadWriteXml.getAppResource("1153").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayLine").Text = "'" + ReadWriteXml.getAppResource("1154").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayShift").Text = "'" + ReadWriteXml.getAppResource("1135").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayWorkdate").Text = "'" + ReadWriteXml.getAppResource("1155").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayActWorkingHour").Text = "'" + ReadWriteXml.getAppResource("1156").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayActStopHour").Text = "'" + ReadWriteXml.getAppResource("1157").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayLeader").Text = "'" + ReadWriteXml.getAppResource("1051").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayTacttime").Text = "'" + ReadWriteXml.getAppResource("1035").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayCycletime").Text = "'" + ReadWriteXml.getAppResource("1158").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplaySmh").Text = "'" + ReadWriteXml.getAppResource("1065").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayAmh").Text = "'" + ReadWriteXml.getAppResource("1159").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayMan").Text = "'" + ReadWriteXml.getAppResource("1082").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayMachine").Text = "'" + ReadWriteXml.getAppResource("1083").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayMeterial").Text = "'" + ReadWriteXml.getAppResource("1084").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayMethod").Text = "'" + ReadWriteXml.getAppResource("1085").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayDiman").Text = "'" + ReadWriteXml.getAppResource("1160").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayInman").Text = "'" + ReadWriteXml.getAppResource("1161").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayDefect").Text = "'" + ReadWriteXml.getAppResource("1056").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayQtyplan").Text = "'" + ReadWriteXml.getAppResource("1138").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayQtyact").Text = "'" + ReadWriteXml.getAppResource("1140").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayEFF(di)").Text = "'" + ReadWriteXml.getAppResource("1162").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayEFF(in)").Text = "'" + ReadWriteXml.getAppResource("1163").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayEFFtarget").Text = "'" + ReadWriteXml.getAppResource("1164").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayEFFact").Text = "'" + ReadWriteXml.getAppResource("1165").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayAchiev").Text = "'" + ReadWriteXml.getAppResource("1166").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayGroup").Text = "'" + ReadWriteXml.getAppResource("1167").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayShiftend").Text = "'" + ReadWriteXml.getAppResource("1168").ToString() + "'"
    '        crystalReport.DataDefinition.FormulaFields("DisplayPage").Text = "'" + ReadWriteXml.getAppResource("1207").ToString() + "'"             'Added by Gagan Kalyana on 2015-May-08
    '        'Added by Gagan Kalyana on 30-Mar-2015 [End]

    '            Dim ds As DataSet2 = GetData(sql)
    '            crystalReport.SetDataSource(ds)

    '        End If
    '        CrystalReportViewer1.ReportSource = crystalReport
    '        CrystalReportViewer1.RefreshReport()
    '        CrystalReportViewer1.DataBind()


    'End Sub

    'Protected Sub Page_Unload(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Unload       
    '    crystalReport.Close()
    '    crystalReport.Dispose()     
    'End Sub

    'Protected Sub CrystalReportViewer1_Unload(ByVal sender As Object, ByVal e As System.EventArgs) Handles CrystalReportViewer1.Unload
    '    crystalReport.Close()
    '    crystalReport.Dispose()
    '    CrystalReportViewer1.Dispose()
    'End Sub
    '[1] Commented by Gagan Kalyana on 2016-Mar-15 [End]

    Protected Sub dr_section_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles dr_section.SelectedIndexChanged
        dr_line.Items.Clear()
        Dim db As New Database
        Dim rd As SqlDataReader
        Dim sql As String = ""
        db.conecDB()
        db.initCMD()
        sql = "select distinct a.line_c, a.section_c  "
        sql = sql & "from line_mst as a where a.factory_c='" + dr_company.Text + "' and section_c='" & dr_section.Text & "' order by a.section_c "

        rd = db.execReader(sql)
        dr_line.Items.Add(New ListItem("*", "*"))
        While rd.Read()
            dr_line.Items.Add(New ListItem(rd("line_c"), rd("line_c")))
        End While
        db.closeDB()
        rd.Close()

        '[2] Added by Gagan Kalyana on 2016-Mar-15 [Start]
        dr_shift.Items.Clear()
        dr_shift.Items.Add(New ListItem("*", "*"))
        dr_leader.Items.Clear()
        dr_leader.Items.Add(New ListItem("*", "*"))
        sql = "SELECT DISTINCT Shift_C, Shift_NM FROM Shift_Mst WHERE Factory_C = '" + dr_company.Text + "' AND Section_C = '" + dr_section.SelectedItem.Text + "' ORDER BY Shift_C"
        db.conecDB()
        db.initCMD()
        rd = db.execReader(sql)
        While rd.Read()
            dr_shift.Items.Add(New ListItem(rd("Shift_NM"), rd("Shift_C")))
        End While
        db.closeDB()
        rd.Close()
        '[2] Added by Gagan Kalyana on 2016-Mar-15 [End]

    End Sub

    '[2] Added by Gagan Kalyana on 2016-Mar-15 [Start]
    Protected Sub dr_line_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles dr_line.SelectedIndexChanged
        dr_leader.Items.Clear()
        Dim db As New Database
        Dim rd As SqlDataReader
        Dim sql As String = ""
        db.conecDB()
        db.initCMD()

        If dr_section.Text <> "*" Then
            sql = "SELECT DISTINCT a.User_c,a.User_nm "
            sql = sql & "FROM User_mst AS a JOIN Production_hdr AS b ON a.factory_c=b.factory_c AND a.Section_c=b.section_c AND a.User_c=b.Worker_c2 "
            sql = sql & "WHERE b.factory_c='" & dr_company.Text & "' AND b.section_c = '" & dr_section.Text & "' " & " and b.line_c='" & dr_line.Text & "' "
        End If
        rd = db.execReader(sql)
        dr_leader.Items.Add(New ListItem("*", "*"))
        While rd.Read()
            dr_leader.Items.Add(New ListItem(rd("user_nm"), rd("User_c")))
        End While
        db.closeDB()
        rd.Close()
    End Sub

    Protected Sub dr_company_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles dr_company.SelectedIndexChanged
        Dim db As New Database
        Dim rd As SqlDataReader
        Dim sql As String = ""

        dr_section.Items.Clear()
        dr_line.Items.Clear()
        dr_shift.Items.Clear()
        dr_leader.Items.Clear()
        dr_line.Items.Add(New ListItem("*", "*"))
        dr_shift.Items.Add(New ListItem("*", "*"))
        dr_leader.Items.Add(New ListItem("*", "*"))

        db.conecDB()
        db.initCMD()
        sql = "select distinct  a.section_c  "
        sql = sql & "from section_mst as a where a.factory_c='" + dr_company.Text + "'  order by a.section_c "

        rd = db.execReader(sql)
        dr_section.Items.Clear()
        dr_section.Items.Add(New ListItem("*", "*"))
        While rd.Read()
            dr_section.Items.Add(New ListItem(rd("section_c"), rd("section_c")))
        End While
        db.closeDB()
        rd.Close()
    End Sub

    Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSearch.Click
        Dim dtStartDate As Date = DateTime.ParseExact(txt_stDate.Text, "yyyy/MM/dd", CultureInfo.InvariantCulture)
        Dim dtEndDate As Date = DateTime.ParseExact(txt_endDate.Text, "yyyy/MM/dd", CultureInfo.InvariantCulture)


        If dtStartDate > dtEndDate Then
            ScriptManager.RegisterStartupScript(Me, [GetType](), "showalert", "alert('" + ReadWriteXml.getAppResource("5003").ToString() + "');", True)
        ElseIf Math.Abs(DateDiff(DateInterval.Day, dtEndDate, dtStartDate)) > 31 Then
            ScriptManager.RegisterStartupScript(Me, [GetType](), "showalert", "alert('" + ReadWriteXml.getAppResource("5004").ToString() + "');", True)
        Else
            Dim intResult As Integer
            intResult = GenerateReport()
        End If
    End Sub

    Private Function GenerateReport() As Integer
        Dim dataSet As New DataSet
        Dim strSql As String
        Dim dataAdapter As SqlDataAdapter
        Dim intTemp As Integer = 0
        Dim iRowCnt As Integer = 0
        Dim dtStartDate As DateTime = DateTime.ParseExact(txt_stDate.Text, "yyyy/MM/dd", CultureInfo.InvariantCulture)
        Dim dtEndDate As DateTime = DateTime.ParseExact(txt_endDate.Text, "yyyy/MM/dd", CultureInfo.InvariantCulture)
        iRowCnt = Math.Abs(DateDiff(DateInterval.Day, dtEndDate, dtStartDate))

        'Table 1: Product No information with SMH
        strSql = "SELECT DISTINCT P.Product_No, P.Cusdesch_c1 +  P.Cusdesch_c2 + P.Intdesch_c AS DC, ISNULL(M.SMH, 0) AS SMH FROM Production_Hdr H INNER JOIN Production_Plan P "
        strSql = strSql + "ON H.factory_c = P.factory_c AND H.section_c = P.Section_C AND H.line_c = P.Line_C AND H.shift_c = P.Shift_C AND H.work_date = P.Work_Date "
        strSql = strSql + "INNER JOIN (SELECT Product_No, Cusdesch_c1,  Cusdesch_c2, Intdesch_c, SMH FROM Product_mst WHERE factory_c = '" + dr_company.SelectedValue.Trim + "') M "
        strSql = strSql + "ON P.Product_no = M.Product_No AND P.Cusdesch_c1 = M.Cusdesch_c1 AND P.Cusdesch_c2 = M.Cusdesch_c2 AND P.Intdesch_c = M.Intdesch_c "
        strSql = strSql + "WHERE H.Factory_C = '" + dr_company.SelectedValue.Trim + "' AND H.Section_C = '" + dr_section.SelectedValue.Trim + "' AND H.Line_C = '" + dr_line.SelectedValue.Trim + "' "
        strSql = strSql + "AND H.Shift_C = '" + dr_shift.SelectedValue.Trim + "' AND H.work_date BETWEEN '" + dtStartDate + "' AND '" + dtEndDate + "';"

        'Table 2: Plan Qty and Act Qty of each Product for Each Day
        strSql = strSql + "SELECT P.Product_No, P.Cusdesch_c1 +  P.Cusdesch_c2 + P.Intdesch_c AS DC, CONVERT(VARCHAR(10),P.Work_Date,111) AS Work_Date, P.plan_qty, ISNULL(I.Insp_Qty, 0) AS Insp_Qty, L.diman_act, L.inman_act, "
        strSql = strSql + "ISNULL(D.Duration, 0) AS Duration, ISNULL(F.Def_Qty, 0) AS Def_Qty, ISNULL(S1.Duration, 0) - ISNULL(S2.Duration, 0) AS STime "
        strSql = strSql + "FROM Production_Hdr H INNER JOIN Production_Plan P "
        strSql = strSql + "ON H.factory_c = P.factory_c AND H.section_c = P.Section_C AND H.line_c = P.Line_C AND H.shift_c = P.Shift_C AND H.work_date = P.Work_Date "
        strSql = strSql + "INNER JOIN Line_Data L "
        strSql = strSql + "ON H.factory_c = L.factory_c AND H.section_c = L.Section_C AND H.line_c = L.Line_C AND H.shift_c = L.Shift_C AND H.work_date = L.Work_Date "
        strSql = strSql + "LEFT JOIN ( "
        strSql = strSql + "SELECT Factory_C, Section_C, Line_C, Shift_C, Work_Date, SUM(Duration) AS Duration FROM LineShift_downtime_act "
        strSql = strSql + "WHERE Factory_C = '" + dr_company.SelectedValue.Trim + "' AND Section_C = '" + dr_section.SelectedValue.Trim + "' AND Line_C = '" + dr_line.SelectedValue.Trim + "' AND Shift_C = '" + dr_shift.SelectedValue.Trim + "' AND Work_Date BETWEEN '" + dtStartDate + "' AND '" + dtEndDate + "' "
        strSql = strSql + "GROUP BY Factory_C, Section_C, Line_C, Shift_C, Work_Date) D "
        strSql = strSql + "ON H.factory_c = D.factory_c AND H.section_c = D.Section_C AND H.line_c = D.Line_C AND H.shift_c = D.Shift_C AND H.work_date = D.Work_Date "
        strSql = strSql + "LEFT JOIN ( "
        strSql = strSql + "SELECT Factory_C, Section_C, Line_C, Shift AS Shift_C, Shift_St_Dt AS Work_Date, Product_No, Cusdesch_c1,  Cusdesch_c2, Intdesch_c, COUNT(1) AS Insp_Qty FROM ACS_Insp_Res "
        strSql = strSql + "WHERE Factory_C = '" + dr_company.SelectedValue.Trim + "' AND Section_C = '" + dr_section.SelectedValue.Trim + "' AND Line_C = '" + dr_line.SelectedValue.Trim + "' AND Shift = '" + dr_shift.SelectedValue.Trim + "' AND Shift_St_Dt BETWEEN '" + dtStartDate + "' AND '" + dtEndDate + "' "
        strSql = strSql + "GROUP BY Factory_C, Section_C, Line_C, Shift, Shift_St_Dt, Product_No, Cusdesch_c1,  Cusdesch_c2, Intdesch_c) I "
        strSql = strSql + "ON P.factory_c = I.factory_c AND P.section_c = I.Section_C AND P.line_c = I.Line_C AND P.shift_c = I.Shift_C AND P.work_date = I.Work_Date "
        strSql = strSql + "	AND P.Product_no = I.Product_No AND P.Cusdesch_c1 = I.Cusdesch_c1 AND P.Cusdesch_c2 = I.Cusdesch_c2 AND P.Intdesch_c = I.Intdesch_c "
        strSql = strSql + "LEFT JOIN ( "
        strSql = strSql + "SELECT Factory_C, Section_C, Line_C, Shift AS Shift_C, CAST(Insp_Dt AS DATE) AS Work_Date, Product_No, Cusdesch_c1,  Cusdesch_c2, Intdesch_c, COUNT(1) AS Def_Qty FROM ACS_Defect_Res "
        strSql = strSql + "WHERE Factory_C = '" + dr_company.SelectedValue.Trim + "' AND Section_C = '" + dr_section.SelectedValue.Trim + "' AND Line_C = '" + dr_line.SelectedValue.Trim + "' AND Shift = '" + dr_shift.SelectedValue.Trim + "' AND CAST(Insp_Dt AS DATE) BETWEEN '" + dtStartDate + "' AND '" + dtEndDate + "' "
        strSql = strSql + "GROUP BY Factory_C, Section_C, Line_C, Shift, CAST(Insp_Dt AS DATE), Product_No, Cusdesch_c1,  Cusdesch_c2, Intdesch_c) F "
        strSql = strSql + "ON P.factory_c = F.factory_c AND P.section_c = F.Section_C AND P.line_c = F.Line_C AND P.shift_c = F.Shift_C AND P.work_date = F.Work_Date "
        strSql = strSql + "AND P.Product_no = F.Product_No AND P.Cusdesch_c1 = F.Cusdesch_c1 AND P.Cusdesch_c2 = F.Cusdesch_c2 AND P.Intdesch_c = CASE WHEN RTRIM(F.Intdesch_c) = '' THEN P.Intdesch_c ELSE F.Intdesch_c END "
        strSql = strSql + "LEFT JOIN( "
        strSql = strSql + "SELECT Factory_C, Section_C, Line_C, Shift_C, Work_Date, SUM(Duration_Time) AS Duration FROM Shift_time_data "
        strSql = strSql + "WHERE Factory_C = '" + dr_company.SelectedValue.Trim + "' AND Section_C = '" + dr_section.SelectedValue.Trim + "' AND Line_C = '" + dr_line.SelectedValue.Trim + "' AND Shift_C = '" + dr_shift.SelectedValue.Trim + "' AND Work_Date BETWEEN '" + dtStartDate + "' AND '" + dtEndDate + "' "
        'Modified by Gagan Kalyana on 2017-Mar-20
        'strSql = strSql + "AND time_c IN('ST01', 'ST08', 'ST12') "
        strSql = strSql + "AND time_c IN('ST01', 'ST08') "
        strSql = strSql + "GROUP BY Factory_C, Section_C, Line_C, Shift_C, Work_Date) S1 "
        strSql = strSql + "ON P.factory_c = S1.factory_c AND P.section_c = S1.Section_C AND P.line_c = S1.Line_C AND P.shift_c = S1.Shift_C AND P.work_date = S1.Work_Date "
        strSql = strSql + "LEFT JOIN( "
        strSql = strSql + "SELECT Factory_C, Section_C, Line_C, Shift_C, Work_Date, SUM(Duration_Time) AS Duration FROM Shift_time_data "
        'Modified by Gagan Kalyana on 2017-Mar-20
        'strSql = strSql + "WHERE Factory_C = '" + dr_company.SelectedValue.Trim + "' AND Section_C = '" + dr_section.SelectedValue.Trim + "' AND Line_C = '" + dr_line.SelectedValue.Trim + "' AND Shift_C = '" + dr_shift.SelectedValue.Trim + "' AND Work_Date BETWEEN '" + dtStartDate + "' AND '" + dtEndDate + "' AND time_c = 'ST05' "
        strSql = strSql + "WHERE Factory_C = '" + dr_company.SelectedValue.Trim + "' AND Section_C = '" + dr_section.SelectedValue.Trim + "' AND Line_C = '" + dr_line.SelectedValue.Trim + "' AND Shift_C = '" + dr_shift.SelectedValue.Trim + "' AND Work_Date BETWEEN '" + dtStartDate + "' AND '" + dtEndDate + "' AND time_c not in ('ST01','ST08') AND Flg_Time<>1"
        strSql = strSql + " GROUP BY Factory_C, Section_C, Line_C, Shift_C, Work_Date) S2 "
        strSql = strSql + "ON P.factory_c = S2.factory_c AND P.section_c = S2.Section_C AND P.line_c = S2.Line_C AND P.shift_c = S2.Shift_C AND P.work_date = S2.Work_Date "
        strSql = strSql + "WHERE H.Factory_C = '" + dr_company.SelectedValue.Trim + "' AND H.Section_C = '" + dr_section.SelectedValue.Trim + "' AND H.Line_C = '" + dr_line.SelectedValue.Trim + "' AND H.Shift_C = '" + dr_shift.SelectedValue.Trim + "' AND H.work_date BETWEEN '" + dtStartDate + "' AND '" + dtEndDate + "'; "

        dataAdapter = New SqlDataAdapter(strSql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
        dataAdapter.Fill(dataSet)

        'Commented by Gagan Kalyana on 2016-Apr-05 [Start]
        'Try
        '    Dim dtDateRange As New DataTable
        '    With dtDateRange
        '        .Columns.Add("Date", Type.GetType("System.String"))
        '    End With

        '    For i = 0 To iRowCnt
        '        dtDateRange.Rows.Add((DateAdd(DateInterval.Day, i, dtStartDate).ToShortDateString).ToString)
        '    Next

        '    If dataSet.Tables(0).Rows.Count > 0 Then
        '        Dim path As String = Server.MapPath("~/TempFile/")

        '        ' CHECK IF THE FOLDER EXISTS. IF NOT, CREATE A NEW FOLDER.
        '        If Not Directory.Exists(path) Then
        '            Directory.CreateDirectory(path)
        '        End If

        '        File.Delete(path & "Production_Report.xlsx")      ' DELETE THE FILE BEFORE CREATING A NEW ONE.

        '        ' ADD A WORKBOOK USING THE EXCEL APPLICATION.
        '        Dim xlAppToExport As New Excel.Application
        '        xlAppToExport.Workbooks.Add()

        '        ' ADD A WORKSHEET.
        '        Dim xlWorkSheetToExport As Excel.Worksheet
        '        xlWorkSheetToExport = xlAppToExport.Sheets("Sheet1")

        '        ' ROW ID FROM WHERE THE DATA STARTS SHOWING.

        '        With xlWorkSheetToExport
        '            'FORMAT REPORT HEADER           
        '            Dim intHeader1Row As Integer = 1
        '            Dim intHeader1Col As Integer = 1

        '            ' REPORT HEADER CAPTION
        '            .Cells(intHeader1Row, intHeader1Col).value = UCase(ReadWriteXml.getAppResource("1280").ToString())
        '            .Cells(intHeader1Row + 1, intHeader1Col).value = UCase(ReadWriteXml.getAppResource("1285").ToString())
        '            .Cells(intHeader1Row + 2, intHeader1Col).value = UCase(ReadWriteXml.getAppResource("1286").ToString())
        '            .Cells(intHeader1Row + 3, intHeader1Col).value = UCase(ReadWriteXml.getAppResource("1264").ToString())
        '            Dim border As Excel.Borders = .Range(.Cells(intHeader1Row, intHeader1Col), .Cells(intHeader1Row + 3, intHeader1Col + 2)).Borders
        '            border.LineStyle = Excel.XlLineStyle.xlContinuous
        '            border.Weight = 2.0


        '            ' REPORT HEADER VALUES
        '            .Cells(intHeader1Row, intHeader1Col + 1).value = dr_line.SelectedValue.ToString
        '            .Cells(intHeader1Row + 1, intHeader1Col + 1).value = dr_shift.SelectedItem.Text
        '            .Cells(intHeader1Row + 2, intHeader1Col + 1).value = dr_leader.SelectedItem.Text
        '            .Cells(intHeader1Row + 3, intHeader1Col + 1).value = "'" + DateTime.Now.ToString("yyyy/MM/dd").ToString
        '            .Range(.Cells(intHeader1Row, intHeader1Col + 1), .Cells(intHeader1Row, intHeader1Col + 2)).MergeCells = True
        '            .Range(.Cells(intHeader1Row + 1, intHeader1Col + 1), .Cells(intHeader1Row + 1, intHeader1Col + 2)).MergeCells = True
        '            .Range(.Cells(intHeader1Row + 2, intHeader1Col + 1), .Cells(intHeader1Row + 2, intHeader1Col + 2)).MergeCells = True
        '            .Range(.Cells(intHeader1Row + 3, intHeader1Col + 1), .Cells(intHeader1Row + 3, intHeader1Col + 2)).MergeCells = True
        '            .Range(.Cells(intHeader1Row, 1), .Cells(intHeader1Row + 3, 3)).Font.Color = System.Drawing.ColorTranslator.ToOle(System.Drawing.Color.Blue)
        '            .Range(.Cells(intHeader1Row, 1), .Cells(intHeader1Row + 3, 3)).Font.Bold = True
        '            .Range(.Cells(intHeader1Row, 1), .Cells(intHeader1Row + 3, 3)).EntireColumn.AutoFit()

        '            Dim intHeader2Row As Integer = 5
        '            Dim intHeader2Col As Integer = 1

        '            'Date Range values and Formatting for Selected in the Output Criteria
        '            For i = 0 To iRowCnt
        '                .Cells(intHeader2Row, intHeader1Col + 3 + i + intTemp).value = DateAdd(DateInterval.Day, i, dtStartDate).ToShortDateString
        '                .Range(.Cells(intHeader2Row, intHeader1Col + 3 + i + intTemp), .Cells(intHeader2Row, intHeader1Col + 4 + i + intTemp)).MergeCells = True
        '                intTemp = intTemp + 1
        '            Next

        '            border = .Range(.Cells(intHeader2Row, 4), .Cells(intHeader2Row, 5 + (iRowCnt) * 2)).Borders
        '            border.LineStyle = Excel.XlLineStyle.xlContinuous
        '            border.Weight = 2.0
        '            .Range(.Cells(intHeader2Row, 1), .Cells(intHeader2Row, 5 + (iRowCnt) * 2)).Interior.Color = System.Drawing.ColorTranslator.ToOle(System.Drawing.Color.Gray)
        '            .Range(.Cells(intHeader2Row, 1), .Cells(intHeader2Row, 5 + (iRowCnt) * 2)).BorderAround(Excel.XlLineStyle.xlContinuous, Excel.XlBorderWeight.xlMedium, Excel.XlColorIndex.xlColorIndexAutomatic, Excel.XlColorIndex.xlColorIndexAutomatic)

        '            border = .Range(.Cells(intHeader2Row + 1, 1), .Cells(intHeader2Row + 7, 5 + (iRowCnt) * 2)).Borders
        '            border.LineStyle = Excel.XlLineStyle.xlContinuous
        '            border.Weight = 2.0

        '            .Cells(intHeader2Row + 1, intHeader2Col).value = ReadWriteXml.getAppResource("1265").ToString()
        '            .Cells(intHeader2Row + 2, intHeader2Col).value = ReadWriteXml.getAppResource("1266").ToString()
        '            .Cells(intHeader2Row + 3, intHeader2Col).value = ReadWriteXml.getAppResource("1267").ToString()
        '            .Cells(intHeader2Row + 4, intHeader2Col).value = ReadWriteXml.getAppResource("1268").ToString()
        '            .Cells(intHeader2Row + 5, intHeader2Col).value = ReadWriteXml.getAppResource("1269").ToString()
        '            .Cells(intHeader2Row + 6, intHeader2Col).value = ReadWriteXml.getAppResource("1270").ToString()
        '            .Cells(intHeader2Row + 7, intHeader2Col).value = ReadWriteXml.getAppResource("1191").ToString()

        '            .Range(.Cells(intHeader2Row + 1, intHeader2Col), .Cells(intHeader2Row + 1, intHeader2Col + 2)).MergeCells = True
        '            .Range(.Cells(intHeader2Row + 2, intHeader2Col), .Cells(intHeader2Row + 2, intHeader2Col + 2)).MergeCells = True
        '            .Range(.Cells(intHeader2Row + 3, intHeader2Col), .Cells(intHeader2Row + 3, intHeader2Col + 2)).MergeCells = True
        '            .Range(.Cells(intHeader2Row + 4, intHeader2Col), .Cells(intHeader2Row + 4, intHeader2Col + 2)).MergeCells = True
        '            .Range(.Cells(intHeader2Row + 5, intHeader2Col), .Cells(intHeader2Row + 5, intHeader2Col + 2)).MergeCells = True
        '            .Range(.Cells(intHeader2Row + 6, intHeader2Col), .Cells(intHeader2Row + 6, intHeader2Col + 2)).MergeCells = True
        '            .Range(.Cells(intHeader2Row + 7, intHeader2Col), .Cells(intHeader2Row + 7, intHeader2Col + 2)).MergeCells = True

        '            Dim intHeader3Row As Integer = 15
        '            Dim intHeader3Col As Integer = 1
        '            .Cells(intHeader3Row, intHeader3Col).value = ReadWriteXml.getAppResource("1062").ToString()
        '            .Cells(intHeader3Row, intHeader3Col + 1).value = ReadWriteXml.getAppResource("1133").ToString()
        '            .Cells(intHeader3Row, intHeader3Col + 2).value = ReadWriteXml.getAppResource("1231").ToString()


        '            For i = 0 To dataSet.Tables(0).Rows.Count - 1
        '                Dim localDt As New DataTable
        '                localDt = (dataSet.Tables(1).Clone)

        '                .Cells(intHeader3Row + 1 + i, intHeader3Col).value = dataSet.Tables(0).Rows(i).Item("Product_No")
        '                .Cells(intHeader3Row + 1 + i, intHeader3Col + 1).value = dataSet.Tables(0).Rows(i).Item("DC")
        '                .Cells(intHeader3Row + 1 + i, intHeader3Col + 2).value = dataSet.Tables(0).Rows(i).Item("SMH")

        '                localDt = dataSet.Tables(1).Select("Product_No = '" + dataSet.Tables(0).Rows(i)(0).ToString + "' AND DC = '" + dataSet.Tables(0).Rows(i)(1).ToString + "'", "Work_Date ASC").CopyToDataTable
        '                intTemp = 0
        '                For j = 0 To iRowCnt
        '                    Dim dtToday As Date = DateAdd(DateInterval.Day, j, dtStartDate)
        '                    Dim result() As DataRow = localDt.Select("Work_Date = '" + dtToday.Year.ToString + "/" + dtToday.Month.ToString("00") + "/" + dtToday.Day.ToString("00") + "'")
        '                    If (result.Count > 0) Then
        '                        'Value Exists
        '                        .Cells(intHeader3Row + 1 + i, intHeader3Col + 3 + j + intTemp).value = result(0)("plan_qty").ToString           'Plan Quantity for Each Product Day wise
        '                        .Cells(intHeader3Row + 1 + i, intHeader3Col + 4 + j + intTemp).value = result(0)("Insp_Qty").ToString           'Inspection Quantity for Each Product Day wise
        '                        .Cells(intHeader2Row + 1, intHeader1Col + 3 + j + intTemp).value = CDbl(CDbl(.Cells(intHeader2Row + 1, intHeader1Col + 3 + j + intTemp).value).ToString("#####.00") + (result(0)("Insp_Qty") * CDbl(dataSet.Tables(0).Rows(i).Item("SMH")).ToString("#####.00"))).ToString("#####.00")
        '                    Else
        '                        'Value Not Exists
        '                        .Cells(intHeader3Row + 1 + i, intHeader3Col + 3 + j + intTemp).value = 0
        '                        .Cells(intHeader3Row + 1 + i, intHeader3Col + 4 + j + intTemp).value = 0
        '                        .Cells(intHeader2Row + 1, intHeader1Col + 3 + j + intTemp).value = CDbl(.Cells(intHeader2Row + 1, intHeader1Col + 3 + j + intTemp).value).ToString("#####.00") + 0
        '                    End If

        '                    intTemp = intTemp + 1
        '                Next
        '            Next

        '            border = .Range(.Cells(intHeader3Row, 1), .Cells(intHeader3Row + dataSet.Tables(0).Rows.Count + 1, 5 + (iRowCnt) * 2)).Borders
        '            border.LineStyle = Excel.XlLineStyle.xlContinuous
        '            border.Weight = 2.0

        '            intTemp = 0
        '            For i = 0 To iRowCnt
        '                Dim dblDiman As Double = 0
        '                Dim dblInman As Double = 0
        '                Dim dblDuration As Double = 0
        '                Dim intDef_Qty As Integer = 0
        '                Dim dblSTime As Double = 0
        '                Dim dblActEfficiency As Double = 0.0
        '                Dim dblProductiviy As Double = 0.0
        '                Dim dtToday As Date = DateAdd(DateInterval.Day, i, dtStartDate)
        '                Dim result() As DataRow = dataSet.Tables(1).Select("Work_Date = '" + dtToday.Year.ToString + "/" + dtToday.Month.ToString("00") + "/" + dtToday.Day.ToString("00") + "'")

        '                For j = 0 To result.Length - 1
        '                    dblDiman = dblDiman + result(j)("Diman_Act").ToString
        '                    dblInman = dblInman + result(j)("Inman_Act").ToString
        '                    dblDuration = dblDuration + result(j)("Duration").ToString
        '                    intDef_Qty = intDef_Qty + result(j)("Def_Qty").ToString
        '                    dblSTime = dblSTime + result(j)("STime").ToString
        '                Next

        '                'Standard MH(SH)(Sec.) Day wise
        '                .Range(.Cells(intHeader2Row + 1, intHeader1Col + 3 + i + intTemp), .Cells(intHeader2Row + 1, intHeader1Col + 4 + i + intTemp)).MergeCells = True

        '                'Actual MH Day wise
        '                .Cells(intHeader2Row + 2, intHeader1Col + 3 + i + intTemp).value = CDbl(dblSTime * 60 * dblDiman).ToString("#####.00")
        '                .Range(.Cells(intHeader2Row + 2, intHeader1Col + 3 + i + intTemp), .Cells(intHeader2Row + 2, intHeader1Col + 4 + i + intTemp)).MergeCells = True

        '                'Actual Efficiency(%) - Standard MH(SH)(Sec.) Day wise /Actual MH Day wise                        
        '                If (.Cells(intHeader2Row + 1, intHeader1Col + 3 + i + intTemp).value = 0 Or .Cells(intHeader2Row + 2, intHeader1Col + 3 + i + intTemp).value = 0) Then
        '                    .Cells(intHeader2Row + 3, intHeader1Col + 3 + i + intTemp).value = 0
        '                Else
        '                    dblActEfficiency = .Cells(intHeader2Row + 1, intHeader1Col + 3 + i + intTemp).value / .Cells(intHeader2Row + 2, intHeader1Col + 3 + i + intTemp).value
        '                    .Cells(intHeader2Row + 3, intHeader1Col + 3 + i + intTemp).value = dblActEfficiency
        '                    .Range(.Cells(intHeader2Row + 3, intHeader1Col + 3 + i + intTemp), .Cells(intHeader2Row + 3, intHeader1Col + 4 + i + intTemp)).NumberFormat = "###,##.00%"
        '                End If
        '                .Range(.Cells(intHeader2Row + 3, intHeader1Col + 3 + i + intTemp), .Cells(intHeader2Row + 3, intHeader1Col + 4 + i + intTemp)).MergeCells = True

        '                'Productivity(%) - Standard MH(SH)(Sec.) Day wise /Actual MH Day wise
        '                If .Cells(intHeader2Row + 2, intHeader1Col + 3 + i + intTemp).value = 0 Then
        '                    .Cells(intHeader2Row + 4, intHeader2Col + 3 + i + intTemp).value = 0
        '                Else
        '                    dblProductiviy = .Cells(intHeader2Row + 1, intHeader1Col + 3 + i + intTemp).value / ((.Cells(intHeader2Row + 2, intHeader1Col + 3 + i + intTemp).value) + (dblSTime * 60 * dblInman))
        '                    .Cells(intHeader2Row + 4, intHeader2Col + 3 + i + intTemp).value = dblProductiviy
        '                    .Range(.Cells(intHeader2Row + 4, intHeader1Col + 3 + i + intTemp), .Cells(intHeader2Row + 4, intHeader1Col + 4 + i + intTemp)).NumberFormat = "###,##.00%"
        '                End If

        '                .Range(.Cells(intHeader2Row + 4, intHeader1Col + 3 + i + intTemp), .Cells(intHeader2Row + 4, intHeader1Col + 4 + i + intTemp)).MergeCells = True

        '                'Actual Manpower(Person) day wise
        '                .Cells(intHeader2Row + 5, intHeader2Col + 3 + i + intTemp).value = dblDiman
        '                .Range(.Cells(intHeader2Row + 5, intHeader1Col + 3 + i + intTemp), .Cells(intHeader2Row + 5, intHeader1Col + 4 + i + intTemp)).MergeCells = True

        '                'Downtime(Sec.) day wise
        '                .Cells(intHeader2Row + 6, intHeader2Col + 3 + i + intTemp).value = dblDuration
        '                .Range(.Cells(intHeader2Row + 6, intHeader1Col + 3 + i + intTemp), .Cells(intHeader2Row + 6, intHeader1Col + 4 + i + intTemp)).MergeCells = True

        '                'Defect Qty day wise
        '                .Cells(intHeader2Row + 7, intHeader2Col + 3 + i + intTemp).value = intDef_Qty
        '                .Range(.Cells(intHeader2Row + 7, intHeader1Col + 3 + i + intTemp), .Cells(intHeader2Row + 7, intHeader1Col + 4 + i + intTemp)).MergeCells = True

        '                intTemp = intTemp + 1
        '            Next

        '            'Formatting  of Product Area (AutoFit, Backcolor and Outer Border)
        '            .Range(.Cells(intHeader3Row, 1), .Cells(intHeader3Row, 5 + (iRowCnt) * 2)).Interior.Color = System.Drawing.ColorTranslator.ToOle(System.Drawing.Color.Gray)
        '            .Range(.Cells(intHeader3Row, 1), .Cells(intHeader3Row + dataSet.Tables(0).Rows.Count + 1, 5 + (iRowCnt) * 2)).BorderAround(Excel.XlLineStyle.xlContinuous, Excel.XlBorderWeight.xlMedium, Excel.XlColorIndex.xlColorIndexAutomatic, Excel.XlColorIndex.xlColorIndexAutomatic)

        '            'Date Range values and Formatting for Selected in the Output Criteria
        '            Dim sumPlan As Double = 0
        '            Dim sumInsp As Double = 0
        '            intTemp = 0
        '            For i = 0 To iRowCnt
        '                sumPlan = 0
        '                sumInsp = 0
        '                .Cells(intHeader3Row, intHeader1Col + 3 + i + intTemp).value = ReadWriteXml.getAppResource("1101").ToString()
        '                .Cells(intHeader3Row, intHeader1Col + 4 + i + intTemp).value = ReadWriteXml.getAppResource("1271").ToString()
        '                For j = 0 To dataSet.Tables(0).Rows.Count - 1
        '                    sumPlan = sumPlan + CDbl(.Cells(intHeader3Row + j + 1, intHeader1Col + 3 + i + intTemp).value)
        '                    sumInsp = sumInsp + CDbl(.Cells(intHeader3Row + j + 1, intHeader1Col + 4 + i + intTemp).value)
        '                Next

        '                .Cells(intHeader3Row + dataSet.Tables(0).Rows.Count + 1, intHeader1Col + 3 + i + intTemp).value = sumPlan
        '                .Cells(intHeader3Row + dataSet.Tables(0).Rows.Count + 1, intHeader1Col + 4 + i + intTemp).value = sumInsp
        '                intTemp = intTemp + 1
        '            Next
        '            'Total
        '            .Cells(intHeader3Row + dataSet.Tables(0).Rows.Count + 1, 3).value = ReadWriteXml.getAppResource("1053").ToString()
        '        End With

        '        ' SAVE THE FILE IN A FOLDER.
        '        xlWorkSheetToExport.SaveAs(Server.MapPath("~/TempFile/") & "Production_Report.xlsx")

        '        ' CLEAR.
        '        xlAppToExport.Workbooks.Close() : xlAppToExport.Quit()
        '        xlAppToExport = Nothing : xlWorkSheetToExport = Nothing

        '        ' Download on Client machine and delete from Server.
        '        Response.Clear()
        '        Response.ClearHeaders()
        '        Response.AddHeader("content-disposition", "attachment; filename=" + "Production_Report.xlsx")
        '        Response.AddHeader("content-length", New FileInfo(Server.MapPath("~/TempFile/") + "Production_Report.xlsx").Length.ToString())
        '        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        '        Response.WriteFile(Server.MapPath("~/TempFile/") + "Production_Report.xlsx")
        '        Response.Flush()
        '        File.Delete(Server.MapPath("~/TempFile/") + "Production_Report.xlsx")
        '        Response.End()

        '        Return 1   'Success
        '    Else
        '        ScriptManager.RegisterStartupScript(Me, [GetType](), "showalert", "alert('No Data to export!');", True)
        '        Return 2   'Success with No record
        '    End If

        'Catch ex As Exception
        '    ScriptManager.RegisterStartupScript(Me, [GetType](), "showalert", "alert('" + ex.Message + "');", True)
        '    Return 0   'Faild
        'End Try
        'Commented by Gagan Kalyana on 2016-Apr-05 [End]

        'Added by Gagan Kalyana on 2016-Apr-05 [Start]
        Try
            If dataSet.Tables(0).Rows.Count > 0 Then
                Response.Clear()
                Response.Charset = ""
                Response.ContentType = "application/vnd.ms-excel"
                Response.AddHeader("content-disposition", "attachment;filename=Production_Report.xls")
                Response.Charset = Encoding.UTF8.WebName
                Response.ContentEncoding = Encoding.UTF8
                Response.BinaryWrite(Encoding.UTF8.GetPreamble)

                Dim stringwrite As New System.IO.StringWriter()
                Dim htmlwrite As New System.Web.UI.HtmlTextWriter(stringwrite)

                Dim dg As New System.Web.UI.WebControls.DataGrid()


                htmlwrite.Write("<table ><tr><td style=""border: 0.75px solid black;""><b>" + ReadWriteXml.getAppResource("1280") + "</b></td> <td colspan=""2"" style=""border: 0.75px solid black;""><b>  " + dr_line.SelectedValue.ToString + "</b> </td></tr> <tr> <td style=""border: 0.75px solid black;""><b>" + ReadWriteXml.getAppResource("1285") + "</b></td> <td colspan=""2"" style=""border: 0.75px solid black;""> <b>" + dr_shift.SelectedItem.Text.ToString + " </b></td> </tr> <tr> <td style=""border: 0.75px solid black;""><b> " + ReadWriteXml.getAppResource("1286") + " </b></td> <td colspan=""2"" style=""border: 0.75px solid black;""> <b>" + dr_leader.SelectedItem.Text + " </b></td> </tr> <tr> <td style=""border: 0.75px solid black;""> <b>" + ReadWriteXml.getAppResource("1264") + " <b></td> <td colspan=""2"" style=""border: 0.75px solid black;"" align=""left""> <b>" + DateTime.Now.ToString("yyyy/MM/dd").ToString + " </b></td> </tr> </table>")
                Dim strTemp As String

                strTemp = "<table style=""border: 0.75px solid black;""><tr style=""background-color: gray;""><td style=""border: 0.75px solid black""><b>" + ReadWriteXml.getAppResource("1062").ToString() + "</b></td><td style=""border: 0.75px solid black;""><b>" + ReadWriteXml.getAppResource("1133").ToString() + "</b></td><td style=""border: 0.75px solid black;""><b>" + ReadWriteXml.getAppResource("1231").ToString() + "</b></td>"
                For i = 0 To iRowCnt
                    strTemp = strTemp + "<td style=""border: 0.75px solid black;""><b>" + ReadWriteXml.getAppResource("1101").ToString() + "</b></td> <td style=""border: 0.75px solid black;""><b>" + ReadWriteXml.getAppResource("1271").ToString() + "</b></td>"
                Next

                Dim array(iRowCnt + 1) As String
                Dim arrayTotalPln(iRowCnt) As Integer
                Dim arrayTotalResult(iRowCnt) As Integer
                Dim sumPlan As Double = 0
                Dim sumInsp As Double = 0

                'Added by Gagan Kalyana on 2017-Mar-20 [Start]
                Dim Sql As String
                Dim DtPSM As New DataTable
                Sql = "SELECT PSM.Day_No,PSM.Plan_Qty FROM Production_Simple_Plan PSM WHERE PSM.FACTORY_C = '" & dr_company.SelectedValue & "' AND PSM.SECTION_C='" & dr_section.SelectedValue & "' "
                Sql = Sql & " AND PSM.LINE_C = '" & dr_line.SelectedValue & "' AND PSM.SHIFT = '" & dr_shift.SelectedValue & "'"
                dataAdapter = New SqlDataAdapter(Sql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
                dataAdapter.Fill(DtPSM)
                'Added by Gagan Kalyana on 2017-Mar-20 [End]

                For i = 0 To dataSet.Tables(0).Rows.Count - 1
                    Dim localDt As New DataTable
                    localDt = (dataSet.Tables(1).Clone)

                    strTemp = strTemp + "<tr><td style=""border: 0.75px solid black;"">" + dataSet.Tables(0).Rows(i).Item("Product_No").ToString + "</td>"
                    strTemp = strTemp + "<td style=""border: 0.75px solid black;"">" + dataSet.Tables(0).Rows(i).Item("DC").ToString + "</td>"
                    strTemp = strTemp + "<td style=""border: 0.75px solid black;"">" + dataSet.Tables(0).Rows(i).Item("SMH").ToString + "</td>"

                    localDt = dataSet.Tables(1).Select("Product_No = '" + dataSet.Tables(0).Rows(i)(0).ToString + "' AND DC = '" + dataSet.Tables(0).Rows(i)(1).ToString + "'", "Work_Date ASC").CopyToDataTable
                    intTemp = 0
                    sumPlan = 0
                    sumInsp = 0
                    For j = 0 To iRowCnt
                        Dim dtToday As Date = DateAdd(DateInterval.Day, j, dtStartDate)
                        'Added by Gagan Kalyana on 2017-Mar-20 [Start]
                        Dim intDay As Integer
                        Dim sqlConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
                        Dim sqlCommand As SqlCommand = New SqlCommand("Proc_GetCurrentDayNo")
                        Dim dt As New DataTable
                        sqlCommand.CommandType = CommandType.StoredProcedure
                        sqlCommand.Parameters.AddWithValue("dtDateTime", dtToday)
                        sqlCommand.Connection = sqlConnection
                        Dim adpt As New SqlDataAdapter(sqlCommand)
                        adpt.Fill(dt)

                        If dt.Rows.Count > 0 Then
                            intDay = Convert.ToInt16(dt.Rows(0)(0))
                        End If
                        'Added by Gagan Kalyana on 2017-Mar-20 [End]

                        Dim result() As DataRow = localDt.Select("Work_Date = '" + dtToday.Year.ToString + "/" + dtToday.Month.ToString("00") + "/" + dtToday.Day.ToString("00") + "'")
                        If (result.Count > 0) Then
                            ''Added by Gagan Kalyana on 2017-Mar-20 [Start]
                            If (obj.getValue("G-VIA Simple Mode", "1", False).Flag = True) Then
                                strTemp = strTemp + "<td style=""border: 0.75px solid black;""></td>"           'Plan Quantity for Each Product Day wise
                                Dim temp() As DataRow = (DtPSM.Select("Day_No='" & intDay.ToString & "'"))
                                If temp.Length > 0 Then
                                    arrayTotalPln(j) = temp(0)("plan_qty")
                                Else
                                    arrayTotalPln(j) = 0
                                End If
                            Else
                                arrayTotalPln(j) = arrayTotalPln(j) + result(0)("plan_qty").ToString    'Added by Gagan Kalyana on 2017-Mar-20 [End]
                                strTemp = strTemp + "<td style=""border: 0.75px solid black;"">" + result(0)("plan_qty").ToString + "</td>"           'Plan Quantity for Each Product Day wise
                            End If  'Added by Gagan Kalyana on 2017-Mar-20 

                            strTemp = strTemp + "<td style=""border: 0.75px solid black;"">" + result(0)("Insp_Qty").ToString + "</td>"           'Inspection Quantity for Each Product Day wise
                            array(j) = CDbl(CDbl(array(j)).ToString("#####.00") + (result(0)("Insp_Qty") * CDbl(dataSet.Tables(0).Rows(i).Item("SMH")).ToString("#####.00"))).ToString("#####.00")
                            'arrayTotalPln(j) = arrayTotalPln(j) + result(0)("plan_qty").ToString   'Commented by Gagan Kalyana on 2017-Mar-20 
                            arrayTotalResult(j) = arrayTotalResult(j) + result(0)("Insp_Qty").ToString
                        Else
                            'Added by Gagan Kalyana on 2017-Mar-20 [Start]
                            If (obj.getValue("G-VIA Simple Mode", "1", False).Flag = True) Then
                                strTemp = strTemp + "<td style=""border: 0.75px solid black;"">  </td>"           'Plan Quantity for Each Product Day wise
                                Dim temp() As DataRow = (DtPSM.Select("Day_No='" & intDay.ToString & "'"))
                                If temp.Length > 0 Then
                                    arrayTotalPln(j) = temp(0)("plan_qty")
                                Else
                                    arrayTotalPln(j) = 0
                                End If
                            Else    'Added by Gagan Kalyana on 2017-Mar-20 [End]
                                strTemp = strTemp + "<td style=""border: 0.75px solid black;""> 0 </td>"           'Plan Quantity for Each Product Day wise
                            End If  'Added by Gagan Kalyana on 2017-Mar-20
                            strTemp = strTemp + "<td style=""border: 0.75px solid black;""> 0 </td>"           'Inspection Quantity for Each Product Day wise
                        End If
                    Next
                    strTemp = strTemp + "</tr>"
                Next
                strTemp = strTemp + "<tr><td style=""border: 0.75px solid black;"" colspan=""3"" align=""right"">" + ReadWriteXml.getAppResource("1289") + "</td>"
                For j = 0 To iRowCnt
                    strTemp = strTemp + "<td style=""border: 0.75px solid black;"">" + arrayTotalPln(j).ToString + "</td> <td style=""border: 0.75px solid black;"">" + arrayTotalResult(j).ToString + "</td>"
                Next
                strTemp = strTemp + "</tr></table> "


                Dim tempDt As New DataTable
                'tempDt.Columns.Add(New DataColumn("Caption"))
                'For i = 0 To iRowCnt
                '    tempDt.Columns.Add(New DataColumn(Convert.ToDateTime(DateAdd(DateInterval.Day, i, dtStartDate)).ToString("yyyy/MM/dd")))

                tempDt.Columns.Add(New DataColumn("SH"))
                tempDt.Columns.Add(New DataColumn("AH"))
                tempDt.Columns.Add(New DataColumn("ActEff"))
                tempDt.Columns.Add(New DataColumn("Prod"))
                tempDt.Columns.Add(New DataColumn("Diman"))
                tempDt.Columns.Add(New DataColumn("Duration"))
                tempDt.Columns.Add(New DataColumn("Def_Qty"))

                For i = 0 To iRowCnt
                    Dim dblDiman As Double = 0
                    Dim dblInman As Double = 0
                    Dim dblDuration As Double = 0
                    Dim intDef_Qty As Integer = 0
                    Dim dblSTime As Double = 0
                    Dim dblActEfficiency As Double = 0.0
                    Dim dblProductiviy As Double = 0.0
                    Dim dtToday As Date = DateAdd(DateInterval.Day, i, dtStartDate)
                    Dim result() As DataRow = dataSet.Tables(1).Select("Work_Date = '" + dtToday.Year.ToString + "/" + dtToday.Month.ToString("00") + "/" + dtToday.Day.ToString("00") + "'")

                    For j = 0 To result.Length - 1
                        dblDiman = result(j)("Diman_Act").ToString
                        dblInman = result(j)("Inman_Act").ToString
                        dblDuration = result(j)("Duration").ToString
                        intDef_Qty = intDef_Qty + result(j)("Def_Qty").ToString
                        dblSTime = result(j)("STime").ToString
                    Next

                    If (array(i) = 0 Or CDbl(dblSTime * 60 * dblDiman).ToString("#####.00") = 0) Then
                        dblActEfficiency = dblActEfficiency + 0
                    Else
                        dblActEfficiency = (array(i) / CDbl(dblSTime * 60 * dblDiman).ToString("#####.00"))
                    End If

                    If array(i) = 0 Then
                        dblProductiviy = dblProductiviy + 0
                    Else
                        If ((CDbl(dblSTime * 60 * dblDiman).ToString("#####.00")) + (dblSTime * 60 * dblInman)) <> 0 Then    'Added by Gagan Kalyana on 2017-Mar-20
                            dblProductiviy = (array(i) / ((CDbl(dblSTime * 60 * dblDiman).ToString("#####.00")) + (dblSTime * 60 * dblInman)))
                        End If  'Added by Gagan Kalyana on 2017-Mar-20
                    End If

                    Dim strActEff As String
                    Dim strProd As String

                    If IsNothing(array(i)) Then
                        array(i) = "0"
                    End If
                    If IsNothing(dblActEfficiency) Then
                        strActEff = "0"
                    Else
                        strActEff = dblActEfficiency.ToString("###,##.00%")
                    End If
                    If IsNothing(dblProductiviy) Then
                        strProd = "0"
                    Else
                        strProd = dblProductiviy.ToString("###,##.00%")
                    End If
                    If IsNothing(dblDiman) Then
                        dblDiman = "0"
                    End If
                    If IsNothing(dblDuration) Then
                        dblDuration = "0"
                    End If

                    If IsNothing(intDef_Qty) Then
                        intDef_Qty = "0"
                    End If
                    tempDt.Rows.Add(array(i), CDbl(dblSTime * 60 * dblDiman), strActEff, strProd, dblDiman, dblDuration, intDef_Qty)
                Next

                Dim excelExportGrid As New GridView()
                excelExportGrid.DataSource = GetTransposedTable(tempDt, dtStartDate)
                AddHandler excelExportGrid.RowDataBound, AddressOf excelExportGrid_RowDataBound
                excelExportGrid.DataBind()
                excelExportGrid.RenderControl(htmlwrite)
                htmlwrite.Write("<br/>" + strTemp)
                Response.Write(stringwrite.ToString())
                Response.Write("</body>")
                Response.Write("</html>")
                Response.Flush()
                Return 0
            Else
                ScriptManager.RegisterStartupScript(Me, [GetType](), "showalert", "alert('" + ReadWriteXml.getAppResource("5008").ToString() + "');", True)
                Return 1
            End If

        Catch ex As Exception
            ScriptManager.RegisterStartupScript(Me, [GetType](), "showalert", "alert('" + ex.Message + "');", True)
            Return 1
        End Try
    End Function

    Private Sub excelExportGrid_RowDataBound(sender As Object, e As GridViewRowEventArgs)

        e.Row.Cells(0).ColumnSpan = 3
        For i = 1 To e.Row.Cells.Count - 1
            e.Row.Cells(i).ColumnSpan = 2
            e.Row.Cells(i).HorizontalAlign = HorizontalAlign.Center
        Next
        For i = 0 To e.Row.Cells.Count - 1
            If e.Row.RowType = DataControlRowType.Header Then
                e.Row.Cells(i).BackColor = System.Drawing.Color.Gray
            Else
                e.Row.Cells(i).HorizontalAlign = HorizontalAlign.Right
            End If
        Next
        e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Left
    End Sub

    Function GetTransposedTable(ByVal InputTable As Data.DataTable, ByVal dtStartDate As Date) As DataTable
        Dim OutputTable As New Data.DataTable
        OutputTable.Columns.Add(New DataColumn(" "))
        For i = 0 To InputTable.Rows.Count - 1
            OutputTable.Columns.Add(New DataColumn(Convert.ToDateTime(DateAdd(DateInterval.Day, i, dtStartDate)).ToString("yyyy/MM/dd")))
        Next
        Dim arrRow1(InputTable.Rows.Count) As String
        Dim arrRow2(InputTable.Rows.Count) As String
        Dim arrRow3(InputTable.Rows.Count) As String
        Dim arrRow4(InputTable.Rows.Count) As String
        Dim arrRow5(InputTable.Rows.Count) As String
        Dim arrRow6(InputTable.Rows.Count) As String
        Dim arrRow7(InputTable.Rows.Count) As String
        arrRow1(0) = ReadWriteXml.getAppResource("1265").ToString()
        arrRow2(0) = ReadWriteXml.getAppResource("1266").ToString()
        arrRow3(0) = ReadWriteXml.getAppResource("1267").ToString()
        arrRow4(0) = ReadWriteXml.getAppResource("1268").ToString()
        arrRow5(0) = ReadWriteXml.getAppResource("1269").ToString()
        arrRow6(0) = ReadWriteXml.getAppResource("1270").ToString()
        arrRow7(0) = ReadWriteXml.getAppResource("1191").ToString()

        For i = 1 To InputTable.Rows.Count
            arrRow1(i) = InputTable.Rows(i - 1)(0)
            arrRow2(i) = InputTable.Rows(i - 1)(1)
            arrRow3(i) = InputTable.Rows(i - 1)(2)
            arrRow4(i) = InputTable.Rows(i - 1)(3)
            arrRow5(i) = InputTable.Rows(i - 1)(4)
            arrRow6(i) = InputTable.Rows(i - 1)(5)
            arrRow7(i) = InputTable.Rows(i - 1)(6)
        Next
        OutputTable.Rows.Add(arrRow1)
        OutputTable.Rows.Add(arrRow2)
        OutputTable.Rows.Add(arrRow3)
        OutputTable.Rows.Add(arrRow4)
        OutputTable.Rows.Add(arrRow5)
        OutputTable.Rows.Add(arrRow6)
        OutputTable.Rows.Add(arrRow7)
        Return OutputTable
    End Function
    'Added by Gagan Kalyana on 2016-Apr-05 [End]

    '[2] Added by Gagan Kalyana on 2016-Mar-15 [End]
End Class
