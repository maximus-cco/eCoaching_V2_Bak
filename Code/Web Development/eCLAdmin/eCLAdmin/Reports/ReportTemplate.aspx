<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportTemplate.aspx.cs" Inherits="eCLAdmin.Reports.ReportTemplate" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<!DOCTYPE html>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <title></title>
        <script src="../Scripts/jquery-2.2.0.js"></script>
    </head>
    <body style="margin: 0px; padding: 0px;">
        <form id="form1" runat="server">
            <div>
                <asp:ScriptManager ID="scriptManagerReport" AsyncPostBackTimeOut="0" runat="server">
                </asp:ScriptManager>
                <rsweb:ReportViewer  id="rvSiteMapping" runat ="server" AsyncRendering="false" KeepSessionAlive="true" ShowPrintButton="false"  ZoomMode="Percent" Width="100%" Height="100%" SizeToReportContent="false" > 
                </rsweb:ReportViewer> 
            </div>
        </form>
    </body>
</html>
