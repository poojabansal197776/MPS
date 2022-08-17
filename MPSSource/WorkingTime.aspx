<%--'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'File Name          : WorkingTime.aspx
'Function           : Working Time Deatils Information Page
'Created By         : Gagan Kalyana
'Created on         : 2016-Feb-09
'Revision History   : 
'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%>
<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="WorkingTime.aspx.vb" Inherits="WorkingTime" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="Server">
    <script type="text/javascript">$(document).ready(function () {
    document.getElementById('<%=(Master.FindControl("sideMenu")).ClientID%>').style.display = "none";
})
    </script>
    <div style="margin: 5px;" class="_popup_title">
        <span>&nbsp;<%=ReadWriteXml.getAppResource("1089")%></span><span onclick="window.open('', '_self', ''); window.close();" style="float: right; cursor: pointer;"><img alt="close" src="image/i_close.gif" /></span>
    </div>
    <div style="padding: 5px; width: 100%;">
        <div style="padding: 5px; vertical-align: top; display: inline; width: 40%; float: right">
            <span class="fontshift_popup"><%=ReadWriteXml.getAppResource("1091")%></span>
            <table style="margin-top: 5px" width="100%" border="0" cellspacing="0" cellpadding="2" class="DetailsTable">
                <tr>
                    <th width="4%"><%=ReadWriteXml.getAppResource("1099")%></th>
                    <th width="56%"><%=ReadWriteXml.getAppResource("1100")%></th>
                    <th width="20%" align="center"><%=ReadWriteXml.getAppResource("1242")%></th>
                    <th width="20%" align="center"><%=ReadWriteXml.getAppResource("1243")%></th>
                </tr>
                <%
                    dblTotalEfficiency = 0.0
                    dblTotalProductivity = 0.0
                    If dataSet.Tables(1).Rows.Count > 0 Then
                        For intCount = 0 To dataSet.Tables(1).Rows.Count - 1
                            strTemp = "0.00"
                            If dataSet.Tables(1).Rows(intCount)(1) = 0 Then
                                strTemp = dataSet.Tables(1).Rows(intCount)(2).ToString
                                dblTotalEfficiency = dblTotalEfficiency + CDbl(dataSet.Tables(1).Rows(intCount)(2))
                            End If
                            dblTotalProductivity = dblTotalProductivity + CDbl(dataSet.Tables(1).Rows(intCount)(2))
                %>
                <tr>
                    <td style="text-align: right"><% Response.Write((intCount + 1).ToString)%></td>
                    <td style="padding-left: 5px"><% Response.Write(dataSet.Tables(1).Rows(intCount)(0))%></td>
                    <td align="right"><% Response.Write(strTemp)%></td>
                    <td align="right"><% Response.Write(dataSet.Tables(1).Rows(intCount)(2).ToString)%></td>

                </tr>
                <%
                Next
                
                ''Commented and Modified by SIS on 2016-Apr-11 SIS START
                dblEffAMH = dblEffworkingTime * dblTotalEfficiency / 60
                dblProdAMH = dblEffworkingTime * dblTotalProductivity / 60
                ''Commented and Modified by SIS on 2016-Apr-11 SIS END
            
            End If
                %>
                <tr>
                    <td></td>
                    <td align="right"><%=ReadWriteXml.getAppResource("1053")%></td>
                    <td align="right"><% Response.Write(dblTotalEfficiency.ToString("##,##0.00"))%></td>
                    <td align="right"><% Response.Write(dblTotalProductivity.ToString("##,##0.00"))%></td>

                </tr>
            </table>
        </div>

        <div style="padding: 5px; vertical-align: top; display: inline; width: 55%; float: left">
            <span class="fontshift_popup"><%=ReadWriteXml.getAppResource("1090")%></span>
            <table style="margin-top: 5px" width="100%" border="0" cellspacing="0" cellpadding="2" class="DetailsTable">
                <tr><th style="width: 100%; text-align: center;" colspan="3"><%=ReadWriteXml.getAppResource("1223")%></th></tr>
                <tr align="left">
                    <td style="width: 30%; padding-left: 5px"><%=ReadWriteXml.getAppResource("1224")%></td>
                    <td style="width: 60%"></td>
                    <%--Commented and Modified by SIS on 2016-Apr-11 SIS START--%>
                    <%--<td style="width: 10%; text-align: right"><% Response.Write(Int(dblRegularTime).ToString  + "." + (TimeSpan.FromMinutes(dblRegularTime).Seconds).ToString("00"))%></td>--%>
                    <td style="width: 10%; text-align: right"><% Response.Write(Int(dblRegularHourTime).ToString + ":" + dblRegularMinTime.ToString("00"))%></td>
                    <%--Commented and Modified by SIS on 2016-Apr-11 SIS START--%>
                </tr>
                <tr align="left">
                    <td style="width: 30%; padding-left: 5px"><%=ReadWriteXml.getAppResource("1225")%></td>
                    <td style="width: 60%; padding-left: 5px"></td>
                    <%--Commented and Modified by SIS on 2016-Apr-11 SIS START--%>
                    <%--<td style="width: 10%; text-align: right"><% Response.Write(Int(dblOverTime).ToString + "." + (TimeSpan.FromMinutes(dblOverTime).Seconds).ToString("00"))%></td> --%>
                    <td style="width: 10%; text-align: right"><% Response.Write(Int(dblOverHourTime).ToString + ":" + dblOverMinTime.ToString("00"))%></td>
                    <%--Commented and Modified by SIS on 2016-Apr-11 SIS END--%>
                </tr>
                <tr align="left">
                    <td style="width: 30%; padding-left: 5px"><%=ReadWriteXml.getAppResource("1226")%></td>
                    <td style="width: 60%; padding-left: 5px"></td>
                    <%--Commented and Modified by SIS on 2016-Apr-11 SIS START--%>
                    <%--<td style="width: 10%; text-align: right"><% Response.Write(Int(dblLunchTime).ToString + "." + (TimeSpan.FromMinutes(dblLunchTime).Seconds).ToString("00"))%></td> --%>
                    <td style="width: 10%; text-align: right"><% Response.Write(Int(dblLunchHourTime).ToString + ":" + dblLunchMinTime.ToString("00"))%></td>
                    <%--Commented and Modified by SIS on 2016-Apr-11 SIS END--%>
                </tr>
                <tr align="left">
                    <td style="width: 30%; padding-left: 5px"><%=ReadWriteXml.getAppResource("1252")%></td>
                    <td style="width: 60%; padding-left: 5px"></td>
                    <%--Commented and Modified by SIS on 2016-Apr-11 SIS START--%>
                    <%--<td style="width: 10%; text-align: right"><% Response.Write(Int(dblDeductTime).ToString + "." + (TimeSpan.FromMinutes(dblDeductTime).Seconds).ToString)%></td> --%>
                    <td style="width: 10%; text-align: right"><% Response.Write(Int(dblDeductHourTime).ToString + ":" + dblDeductMinTime.ToString("00"))%></td>
                    <%--Commented and Modified by SIS on 2016-Apr-11 SIS END--%>
                 </tr>
                <tr align="left">
                    <td style="width: 30%; padding-left: 5px"><%=ReadWriteXml.getAppResource("1251")%></td>
                    <td style="width: 60%; padding-left: 5px"><%=ReadWriteXml.getAppResource("1228")%></td>
                    <%--Commented and Modified by SIS on 2016-Apr-11 SIS START--%>
                    <%--<td style="width: 10%; text-align: right"><% Response.Write(Int(dblTotalWorkingTime).ToString + "." + (TimeSpan.FromMinutes(dblTotalWorkingTime).Seconds).ToString("00"))%></td> --%>
                    <td style="width: 10%; text-align: right"><% Response.Write(Int(dblTotalWorkingHourTime).ToString + ":" + dblTotalWorkingMinTime.ToString("00"))%></td> 
                    <%--Commented and Modified by SIS on 2016-Apr-11 SIS END--%>
                </tr>
            </table>
            
            <table style="margin-top: 20px" width="100%" border="0" cellspacing="0" cellpadding="2" class="DetailsTable">
                <tr>
                    <td style="width: 30%; padding-left: 5px"><%=ReadWriteXml.getAppResource("1229")%></td>
                    <td style="width: 60%; padding-left: 5px"><%=ReadWriteXml.getAppResource("1235")%></td>
                    <td style="width: 10%">
                        <%--Commented and Modified by SIS on 2016-Apr-11 SIS START--%>
                        <%--<div align="right"><% Response.Write((CDbl(dblRegularTime.ToString("###,##.00")) + CDbl(dblOverTime.ToString("###,##.00")) - CDbl(dblLunchTime.ToString("###,##.00"))) * CDbl(dblTotalEfficiency.ToString("###,##.00")))%></div> --%>
                        <div align="right"><% Response.Write(CDbl(dblEffAMH).ToString("##0.00"))%></div>
                        <%--Commented and Modified by SIS on 2016-Apr-11 SIS END--%>
                    </td>
                </tr>
                <tr>
                    <td style="width: 30%; padding-left: 5px"><%=ReadWriteXml.getAppResource("1230")%></td>
                    <td style="width: 60%; padding-left: 5px"><%=ReadWriteXml.getAppResource("1236")%></td>
                    <td style="width: 10%">
                        <%--Commented and Modified by SIS on 2016-Apr-11 SIS START--%>
                        <%-- %><div align="right"><% Response.Write((CDbl(dblRegularTime.ToString("###,##.00")) + CDbl(dblOverTime.ToString("###,##.00")) - CDbl(dblLunchTime.ToString("###,##.00"))) * CDbl(dblTotalProductivity.ToString("###,##.00")))%></div> --%>
                        <div align="right"><% Response.Write((CDbl(dblProdAMH).ToString("##0.00")))%></div>
                        <%--Commented and Modified by SIS on 2016-Apr-11 SIS END--%>
                    </td>
                </tr>
                <tr>
                    <td style="width: 30%; padding-left: 5px"><%=ReadWriteXml.getAppResource("1231")%></td>
                    <td style="width: 60%; padding-left: 5px"><%=ReadWriteXml.getAppResource("1237")%></td>
                    <td style="width: 10%">
                        <div align="right"><%Response.Write(dblSMH)%></div>
                    </td>
                </tr>
                <tr>
                    <td style="width: 30%; padding-left: 5px"><%=ReadWriteXml.getAppResource("1035")%></td>
                    <td style="width: 60%; padding-left: 5px"><%=ReadWriteXml.getAppResource("1238")%></td>
                    <td style="width: 10%; padding-left: 5px">
                        <div align="right"><%Response.Write(dblTactTime)%></div>
                    </td>
                </tr>
                <tr>
                    <td style="width: 30%; padding-left: 5px"><%=ReadWriteXml.getAppResource("1232")%></td>
                    <td style="width: 60%; padding-left: 5px"><%=ReadWriteXml.getAppResource("1239")%></td>
                    <td style="width: 10%">
                        <div align="right"><%Response.Write(dblAssEff.ToString("##0.0%"))%></div>
                    </td>
                </tr>
                <tr>
                    <td style="width: 30%; padding-left: 5px"><%=ReadWriteXml.getAppResource("1233")%></td>
                    <td style="width: 60%; padding-left: 5px"><%=ReadWriteXml.getAppResource("1240")%></td>
                    <td style="width: 10%">
                        <div align="right"><%Response.Write(dblAssProduct.ToString("##0.0%"))%></div>
                    </td>
                </tr>
                <tr>
                    <td style="width: 30%; padding-left: 5px"><%=ReadWriteXml.getAppResource("1234")%></td>
                    <td style="width: 60%; padding-left: 5px"><%=ReadWriteXml.getAppResource("1241")%></td>
                    <td style="width: 10%">
                        <div align="right"><%Response.Write(Cdbl(dblTrgtSpd).ToString("##,##0.00"))%></div>
                    </td>
                </tr>
            </table>
        </div>
    </div>

</asp:Content>

