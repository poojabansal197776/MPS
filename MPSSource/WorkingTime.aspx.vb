'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'File Name          : WorkingTime.aspx.vb
'Function           : Working Time Deatils Information Page
'Created By         : Gagan Kalyana
'Created on         : 2016-Feb-09
'Revision History   : Modified by Gagan Kalyana on 2017-Mar-16 for FC69_GVIA-Phase-III-I
'                     Changes have been done to improve the Formula calculation of Working Time. 
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Imports System.Data.SqlClient
Imports System.Data

Partial Class WorkingTime
    Inherits System.Web.UI.Page
    Protected dataSet As New DataSet
    Protected dblRegularTime As Double = 0.0
    Protected dblOverTime As Double = 0.0
    Protected dblLunchTime As Double = 0.0
    Protected dblDeductTime As Double = 0.0
    Protected dblTotalWorkingTime As Double = 0.0
    Protected dblRegularHourTime As Double = 0.0
    Protected dblOverHourTime As Double = 0.0
    Protected dblLunchHourTime As Double = 0.0
    Protected dblDeductHourTime As Double = 0.0
    Protected dblTotalWorkingHourTime As Double = 0.0
    Protected dblRegularMinTime As Double = 0.0
    Protected dblOverMinTime As Double = 0.0
    Protected dblLunchMinTime As Double = 0.0
    Protected dblDeductMinTime As Double = 0.0
    Protected dblTotalWorkingMinTime As Double = 0.0
    Protected dblEffworkingTime As Double = 0.0
    Protected dblEffAMH As Double = 0.0
    Protected dblProdAMH As Double = 0.0
    Protected strTemp As String = ""
    Protected dblTotalEfficiency As Double = 0.0
    Protected dblTotalProductivity As Double = 0.0
    Protected dblSMH As Double = 0.0
    Protected dblTactTime As Double = 0.0
    Protected dblAssEff As Double = 0.0
    Protected dblAssProduct As Double = 0.0
    Protected dblTrgtSpd As Double = 0.0

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim strSql As String = ""
            Dim dataAdapter As SqlDataAdapter
            Dim intCount As Integer = 0
            Dim strTemp As String = ""
            strSql = "SELECT Time_C, Duration_Time, Flg_Time FROM Shift_Time_Data WHERE  Factory_C = '" + Request("factory_c") + "' AND Section_C='" + Request("section_c")
            strSql = strSql + "' AND Line_C='" + Request("Line_C") + "' AND Shift_C= " + Request("shift") + " AND CONVERT(VARCHAR(10), Work_Date, 121)  = CONVERT(VARCHAR(10), '"
            strSql = strSql + CDate(Request("wk")).ToString("yyyy-MM-dd") + " ', 121) ORDER BY Time_C ASC;"
            strSql = strSql + "SELECT ISNULL(B.Data_Nm, '') ,A.Data_Tp, A.Man_Act FROM LineMan_Data  AS A  LEFT JOIN DicData_Mst AS B ON  A.Data_C = B.Data_C WHERE  A.Factory_C = '" + Request("factory_c")
            strSql = strSql + "' AND A.Section_C='" + Request("section_c") + "' AND A.Line_C='" + Request("Line_C") + "' AND A.Shift_C= " + Request("shift") + " AND CONVERT(VARCHAR(10), A.Work_Date, 121)  = CONVERT(VARCHAR(10), '"
            strSql = strSql + CDate(Request("wk")).ToString("yyyy-MM-dd") + " ', 121) ORDER BY A.Data_C; "
            strSql = strSql + "SELECT SMH_Sh, Tact_Time, Effic_St_Di, Effic_St_In, Proty_Tg FROM Line_Data WHERE  Factory_C = '" + Request("factory_c") + "' AND Section_C='" + Request("section_c")
            strSql = strSql + "' AND Line_C='" + Request("Line_C") + "' AND Shift_C= " + Request("shift") + " AND CONVERT(VARCHAR(10), Work_Date, 121)  = CONVERT(VARCHAR(10), '"
            strSql = strSql + CDate(Request("wk")).ToString("yyyy-MM-dd") + " ', 121)"

            dataAdapter = New SqlDataAdapter(strSql, ConfigurationManager.ConnectionStrings("ConnectionDB").ConnectionString)
            dataAdapter.Fill(dataSet)

            For intCount = 0 To dataSet.Tables(0).Rows.Count - 1
                strTemp = dataSet.Tables(0).Rows(intCount)(0).ToString
                Select Case strTemp
                    Case "ST01"
                        dblRegularTime = CDbl(dataSet.Tables(0).Rows(intCount)(1))
                        dblTotalWorkingTime = dblTotalWorkingTime + dataSet.Tables(0).Rows(intCount)(1)
                    Case "ST08"
                        dblOverTime = CDbl(dataSet.Tables(0).Rows(intCount)(1))
                        dblTotalWorkingTime = dblTotalWorkingTime + dataSet.Tables(0).Rows(intCount)(1)
                    Case "ST05"
                        dblLunchTime = CDbl(dataSet.Tables(0).Rows(intCount)(1))
                        dblTotalWorkingTime = dblTotalWorkingTime - dataSet.Tables(0).Rows(intCount)(1)

                        'Modified by Gagan Kalyana on 2017-Mar-16 [Start] 
                        'Case Is <> "ST12"
                        '    If dataSet.Tables(0).Rows(intCount)(2) = 0 Then
                        '        dblDeductTime = dblDeductTime + CDbl(dataSet.Tables(0).Rows(intCount)(1))
                        '        dblTotalWorkingTime = dblTotalWorkingTime - dataSet.Tables(0).Rows(intCount)(1)
                        '    End If
                        'Case "ST12"
                        'dblTotalWorkingTime = dblTotalWorkingTime + dataSet.Tables(0).Rows(intCount)(1)
                    Case Else
                        If dataSet.Tables(0).Rows(intCount)(2) <> 1 Then
                            dblDeductTime = dblDeductTime + CDbl(dataSet.Tables(0).Rows(intCount)(1))
                            dblTotalWorkingTime = dblTotalWorkingTime - dataSet.Tables(0).Rows(intCount)(1)
                        End If
                        'Modified by Gagan Kalyana on 2017-Mar-16 [End]
                End Select
            Next

            dblRegularHourTime = dblRegularTime / 60
            dblRegularMinTime = dblRegularTime Mod 60
            dblOverHourTime = dblOverTime / 60
            dblOverMinTime = dblOverTime Mod 60
            dblLunchHourTime = dblLunchTime / 60
            dblLunchMinTime = dblLunchTime Mod 60
            dblDeductHourTime = dblDeductTime / 60
            dblDeductMinTime = dblDeductTime Mod 60
            dblTotalWorkingHourTime = dblTotalWorkingTime / 60
            dblTotalWorkingMinTime = dblTotalWorkingTime Mod 60
            'Modified by Gagan Kalyana on 2017-Mar-16
            'dblEffworkingTime = (dblRegularTime + dblOverTime - dblLunchTime)
            dblEffworkingTime = dblTotalWorkingTime

            dblAssProduct = 0.0
            dblAssEff = 0.0
            If dataSet.Tables(2).Rows.Count > 0 Then
                For intCount = 0 To dataSet.Tables(2).Rows.Count - 1
                    dblSMH = CDbl(dataSet.Tables(2).Rows(0)(0)).ToString()
                    dblTactTime = dataSet.Tables(2).Rows(0)(1)
                    dblAssEff = CDbl(dataSet.Tables(2).Rows(0)(2) / 100)
                    dblAssProduct = CDbl(dataSet.Tables(2).Rows(0)(3) / 100)
                    dblTrgtSpd = CDbl((dataSet.Tables(2).Rows(0)(1) * dataSet.Tables(2).Rows(0)(2)) / dataSet.Tables(2).Rows(0)(4))
                Next
            End If
        End If
    End Sub
End Class
