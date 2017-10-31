<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="error2.aspx.cs" Inherits="eCLUsers.error2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
 <p>
        <img alt="Unknown User" class="style75" src="images/1348199466_metacontact_unknown.png" 
            longdesc="error.html" /></p>
    <p>
    <asp:Label ID="Label1" runat="server" 
            Text="You are not authorized to submit an eCoaching Log.  If you feel this is <br /> in error, contact your supervisor or report it through the Report an<br /> Issue link at the top of the page. <br /><br />" 
            CssClass="warning"></asp:Label>
</p>
</asp:Content>
