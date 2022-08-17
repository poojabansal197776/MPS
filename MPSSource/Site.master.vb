'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'File Name          : Site.Master.vb
'Function           : Master Page
'Created By         : 
'Created on         : 
'Revision History   : Modified by Gagan Kalyana on 2015-Apr-27 for FC63 Anken
'        		      Changes has been done related to Page Browsing History.
'                   : Modified by Gagan Kalyana on 2015-Dec-17 for Support and Maintenance (IS3 Req. No. ER/151217001)
'   	              CR: Changes done to Display Color Switch Button only on the Work Progress screen (Shift.aspx).
'                   : Modified by Gagan Kalyana on 2016-Feb-01 for FC66-GLOBAL VISUALIZING IN-ASSEMBLY SYSTEM_PHASE2
'        		      1. Changes has been done for removal of Page Browsing History for Mieruka Web application.
'                     2. Changes has been done to modify "Side Menu" of Mieruka Web Application
'                   : Modified by Gagan Kalyana on 2016-Apr-14 for G-ACS SUPPORT MAINTENANCE H1_16_17  (IS3 Req. No. ER/160412001)
'                     Changes has been done to change User control Efficiency.ascx to an Independent Page as Efficiency.aspx.
'                   : Modified by Gagan Kalyana on 2017-Mar-07 for FC69_GVIA-Phase-III-I
'                     Changes has been done to Hide the side Menu in case of GVIA simple version.
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Imports System.Web              'Added by Gagan Kalyana on 2015-Apr-27
Imports System.Data.SqlClient   'Added by Gagan Kalyana on 2017-Mar-07

Partial Class Site
    Inherits System.Web.UI.MasterPage
    'Added by Gagan Kalyana on 2017-Mar-07 [Start] 
    Dim obj As New FunctionControl()
    Public strValue As Boolean
    Public dblJudgementRate As Double = 0
    'Added by Gagan Kalyana on 2017-Mar-07 [End]

    'Added by Gagan Kalyana on 2015-Apr-27 [Start]
    Protected Sub lbtnHome_Click(sender As Object, e As EventArgs) Handles lbtnHome.Click
        'Commented by Gagan Kalyana on 2016-Feb-01 [1]
        'Call ScreenUsageLog.logEntry("Home")
        Response.Redirect("Default.aspx")
    End Sub

    'Commented and Added by Gagan Kalyana on 2016-Feb-01 [2]
    'Protected Sub lbtnSummery_Click(sender As Object, e As EventArgs) Handles lbtnSummery.Click, lbtnDaily.Click, lbtnMonthly.Click, lbtnCompare.Click, lbtnSummery2.Click, lbtnSearch.Click
    Protected Sub lbtnSummery_Click(sender As Object, e As EventArgs) Handles lbtnSummery.Click, lbtnDaily.Click, lbtnMonthly.Click, lbtnCompare.Click, lbtnSummery2.Click, lbtnEfficiency.Click, lbtnParetto.Click
        Dim strBtnSender As String = sender.ID.ToString()
        Select Case True
            Case strBtnSender Is "lbtnSummery"
                'Commented by Gagan Kalyana on 2016-Feb-01 [1]
                'Call ScreenUsageLog.logEntry("Summary")
                Response.Redirect("tool.aspx?id=1")

            Case strBtnSender Is "lbtnDaily"
                'Commented by Gagan Kalyana on 2016-Feb-01 [1]
                'Call ScreenUsageLog.logEntry("Daily Chart")
                Response.Redirect("tool.aspx?id=3")

            Case strBtnSender Is "lbtnMonthly"
                'Commented by Gagan Kalyana on 2016-Feb-01 [1]
                'Call ScreenUsageLog.logEntry("Monthly Chart")
                Response.Redirect("tool.aspx?id=5")

            Case strBtnSender Is "lbtnCompare"
                'Commented by Gagan Kalyana on 2016-Feb-01 [1]
                'Call ScreenUsageLog.logEntry("Comparision")
                Response.Redirect("tool.aspx?id=6")

            Case strBtnSender Is "lbtnSummery2"
                'Commented by Gagan Kalyana on 2016-Feb-01 [1]
                'Call ScreenUsageLog.logEntry("Production Summary")
                Response.Redirect("tool.aspx?id=8")

            Case strBtnSender Is "lbtnEfficiency"               'Added by Gagan Kalyana on 2016-Feb-01 [2] [Start]
                'Response.Redirect("tool.aspx?id=9")            'Commented by Gagan Kalyana on 2016-Apr-14
                Response.Redirect("Efficiency.aspx")             'Added by Gagan Kalyana on 2016-Apr-14

            Case strBtnSender Is "lbtnParetto"
                Response.Redirect("tool.aspx?id=10")            'Added by Gagan Kalyana on 2016-Feb-01 [2] [End]

                'Commented by Gagan Kalyana on 2016-Feb-01 [1] [Start]
                'Case strBtnSender Is "lbtnSearch"
                '    Call ScreenUsageLog.logEntry("Search")
                '    Response.Redirect("Search.aspx?id=001")
                'Commented by Gagan Kalyana on 2016-Feb-01 [1] [End]
        End Select
    End Sub
    'Added by Gagan Kalyana on 2015-Apr-27 [End]

    'Added by Gagan Kalyana on 2015-Dec-17 [Start]
    Protected Sub Form1_Load(sender As Object, e As EventArgs) Handles Form1.Load
        'Dim strPagename As String
        hdnPageName.Value = Me.MainContent.Page.GetType().FullName
        If hdnPageName.Value = "ASP.shift_aspx" Then
            btnColSwt.Visible = True
        End If

        'Added by Gagan Kalyana on 2017-Mar-07 [Start] 
        Dim db As New Database
        Dim rd As SqlDataReader
        Dim strSql As String

        strSql = "SELECT ISNULL(Param_Val, 0) AS Param_Val FROM DicData_mst WHERE Data_C = 'P0101';"
        db.conecDB()
        db.initCMD()

        rd = db.execReader(strSql)
        If rd.Read() Then
            If IsDBNull(rd("Param_Val")) = False Then
                dblJudgementRate = CDbl(rd("Param_Val")).ToString
            End If
        End If
        db.closeDB()
        rd.Close()

        strValue = obj.getValue("G-VIA Simple Mode", "1", False).Flag
        If strValue = True Then
            ScriptManager.RegisterStartupScript(Me, Page.GetType, "Script", "menuToggle();", True)
            sideMenu.Style.Add("visibility", "hidden")
        End If
        'Added by Gagan Kalyana on 2017-Mar-07 [End]
    End Sub
    'Added by Gagan Kalyana on 2015-Dec-17  [End]
End Class

