<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site2.Master" CodeBehind="error2.aspx.vb" Inherits="eCoachingFixed.error2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <p>
        <img alt="warning" class="style75" src="images/Symbols-Warning-icon.png" 
            longdesc="error.html" /></p>
    <p>
    <asp:Label ID="Label1" runat="server" 
            Text="You are not authorized to submit an eCoaching Log.  If you feel this is <br /> in error, contact your supervisor or report it through the Report an<br /> Issue link at the top of the page. <br /><br />" 
            CssClass="warning"></asp:Label>
</p>
</asp:Content>
