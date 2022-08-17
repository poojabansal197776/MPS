<%--'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'File Name          : linesummary.ascx
'Function           : To Output Production report in the Excel format
'Created By         : 
'Created on         : 
'Revision History   : Modified by Gagan Kalyana on 2016-Mar-15 for FC66-GLOBAL VISUALIZING IN-ASSEMBLY SYSTEM_PHASE2
'                     Changes has been done to:
'                     [1] To abolish crystal report from the screen.
'                     [2] To add output criteria for the new excel report generation.
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%>
<%@ Control Language="VB" AutoEventWireup="false" CodeFile="linesummary.ascx.vb" Inherits="Control_linesummary" %>
<%--[1] Commented by Gagan Kalyana on 2016-Mar-15 [Start]
<%@ Register Assembly="CrystalDecisions.Web, Version=13.0.2000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304"
    Namespace="CrystalDecisions.Web" TagPrefix="CR" %>[1] Commented by Gagan Kalyana on 2016-Mar-15 [End]--%>
<div style="border-bottom:1px solid gray; margin-bottom:5px; padding-bottom:5px;height:610px;width:1200px;">
<%--<div style="margin-bottom:5px;font-weight:bold;"><%=ReadWriteXml.getAppResource("1184").ToString()%></div>      Modified by Gagan Kalyana on 2016-Mar-15--%>
<div style="margin-bottom:5px;font-weight:bold"><%=ReadWriteXml.getAppResource("1260").ToString()%></div>
<hr />
<%--[2] Modified by Gagan Kalyana on 2016-Mar-15 [Start]
<asp:Panel ID="Panel1" runat="server">
    <asp:DropDownList ID="dr_company" runat="server" Width="70px" AutoPostBack="true"></asp:DropDownList>
    &nbsp;<asp:DropDownList ID="dr_section" runat="server" Width="70px" AutoPostBack="true"></asp:DropDownList>
    <span style="color:red"><%=ReadWriteXml.getAppResource("1175").ToString()%></span>
    &nbsp;<asp:DropDownList ID="dr_line" runat="server" Width="100px" ></asp:DropDownList>
    <span style="color:red"><%=ReadWriteXml.getAppResource("1175").ToString()%></span>
    &nbsp;<label><%=ReadWriteXml.getAppResource("1187").ToString()%></label>
    &nbsp;<asp:TextBox ID="txtdate" runat="server" Width="100px"></asp:TextBox>
    <span style="color:red"><%=ReadWriteXml.getAppResource("1175").ToString()%></span>
    &nbsp;<label><%=ReadWriteXml.getAppResource("1188").ToString()%></label>&nbsp;
    <asp:TextBox ID="txtdate1" runat="server" Width="100px"></asp:TextBox>
    <span style="color:red"><%=ReadWriteXml.getAppResource("1175").ToString()%></span>&nbsp;    
    <script type="text/javascript">
        new datepickr('ctl00_MainContent_uc211_txtdate', {
            'dateFormat': 'm/d/Y'
        });
        new datepickr('ctl00_MainContent_uc211_txtdate1', {
            'dateFormat': 'm/d/Y'
        });
    </script>
   <%--Commented and added by Gagan Kalyana on 2015-Apr-24--%>
   <%--<asp:Button ID="btnSearch" runat="server" Text="Search" Width="150px" Font-Bold="true" ForeColor="Red" />--%>    
   <%--<asp:Button ID="btnSearch" runat="server" Text="" Width="150px" Font-Bold="true" ForeColor="Red" />--%>
    <table>
    <tr>
        <td><%=ReadWriteXml.getAppResource("1171").ToString()%><span style="color:red;margin-right:5px"><%=ReadWriteXml.getAppResource("1175").ToString()%></span></td>
        <td><%=ReadWriteXml.getAppResource("1153").ToString()%><span style="color:red;margin-right:5px"><%=ReadWriteXml.getAppResource("1175").ToString()%></span></td>
        <td><%=ReadWriteXml.getAppResource("1154").ToString()%><span style="color:red;margin-right:5px"><%=ReadWriteXml.getAppResource("1175").ToString()%></span></td>
        <td><%=ReadWriteXml.getAppResource("1135").ToString()%><span style="color:red;margin-right:5px"><%=ReadWriteXml.getAppResource("1175").ToString()%></span></td>
        <td style="margin-right:5px"><%=ReadWriteXml.getAppResource("1051").ToString()%></td>
        <td><%=ReadWriteXml.getAppResource("1261").ToString()%><span style="color:red;margin-right:5px"><%=ReadWriteXml.getAppResource("1175").ToString()%></span></td>
        <td><%=ReadWriteXml.getAppResource("1262").ToString()%><span style="color:red;margin-right:5px"><%=ReadWriteXml.getAppResource("1175").ToString()%></span></td>
        
    </tr>
    <tr>
        <td><asp:DropDownList ID="dr_company" runat="server" Width="70px" AutoPostBack="true"></asp:DropDownList></td>
        <td><asp:DropDownList ID="dr_section" CssClass="section" runat="server" Width="100px" AutoPostBack="true"></asp:DropDownList></td>
        <td><asp:DropDownList ID="dr_line" CssClass="line" runat="server" Width="70px"  AutoPostBack="true"></asp:DropDownList></td>
        <td><asp:DropDownList ID="dr_shift" CssClass="shift" runat="server" Width="170px"></asp:DropDownList></td>        
        <td><asp:DropDownList ID="dr_leader" runat="server" Width="170px"></asp:DropDownList></td>        
        <td><asp:TextBox ID="txt_stDate" runat="server" Width="100px"></asp:TextBox></td>
        <td><asp:TextBox ID="txt_endDate" runat="server" Width="100px"></asp:TextBox></td>
        <td><asp:Button ID="btnSearch" runat="server" OnClientClick="return validate()" OnClick="btnSearch_Click" Text="" Width="120px" Font-Bold="true" ForeColor="Red"/></td>
    </tr>
         <script type="text/javascript">
             function validate()
             {
                 var validData = true;
                 if ($(".section").val() == "*") 
                 {
                     alert('<%Response.Write(ReadWriteXml.getAppResource("5005"))%>');
                     validData = false;
                     return validData;
                 }
                 if ($(".line").val() == "*") {
                     alert('<%Response.Write(ReadWriteXml.getAppResource("5006"))%>');
                     validData = false;
                     return validData;
                 }
                 if ($(".shift").val() == "*") {
                     alert('<%Response.Write(ReadWriteXml.getAppResource("5007"))%>');
                     validData = false;
                     return validData;
                 }
                 return validData;
             }
             new datepickr('ctl00_MainContent_uc211_txt_stDate', {
                 'dateFormat': 'Y/m/d'
             });
             new datepickr('ctl00_MainContent_uc211_txt_endDate', {
                 'dateFormat': 'Y/m/d'
             });
    </script>
    </table>
<%--</asp:Panel>
    [2] Modified by Gagan Kalyana on 2016-Mar-15 [End]--%>
<br />
</div>
<%--[1] Commented by Gagan Kalyana on 2016-Mar-15 [Start]
<CR:CrystalReportViewer ID="CrystalReportViewer1" runat="server" 
    AutoDataBind="true" HasCrystalLogo="False" HasToggleGroupTreeButton="False" 
    HasZoomFactorList="False"  EnableToolTips="False" ToolPanelView="None" 
    HasDrilldownTabs="False"  HasDrillUpButton="False" BorderStyle="None" 
    GroupTreeStyle-BorderStyle="None" BorderColor="White" BorderWidth="0px" 
    Height="50px" ToolbarStyle-BackColor="White" ToolbarStyle-BorderColor="White" 
    ToolbarStyle-BorderWidth="0px" Width="350px"/>
[1] Commented by Gagan Kalyana on 2016-Mar-15 [End]--%>



