<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="UnAuthorizedUser.aspx.cs" Inherits="eCLUsers.UnAuthorizedUser" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<h2 style="font-size: x-large; font-weight: bold; ">
<br />
Restricted Use
</h2>
<br />
<br />
<asp:Label ID="Label1" runat="server" 
            Text="The use of this Web Site is restricted to authorized users. <br /><br />" 
            CssClass="warning"></asp:Label>


    <br />
    <br />
</asp:Content>
