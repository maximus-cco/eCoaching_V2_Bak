<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site2.Master" CodeBehind="error4.aspx.vb" Inherits="eCoachingFixed.error4" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <p>
        <img alt="warning" class="style75" src="images/Symbols-Warning-icon.png" 
            longdesc="error.html" /></p>
    <p>
    <asp:Label ID="Label1" runat="server" 
            Text="A system error has occured. Please contact the system admin for <br /> assistance." 
            CssClass="warning"></asp:Label>
</p>
</asp:Content>
