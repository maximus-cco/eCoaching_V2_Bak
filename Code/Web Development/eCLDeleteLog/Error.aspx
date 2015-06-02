<%@ Page Title="" Language="C#" MasterPageFile="~/masterpages/Site1.Master" AutoEventWireup="true" CodeBehind="Error.aspx.cs" Inherits="eCLDeleteLog.Error" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <h3>An Error Has Occurred</h3>
        <p>
            An unexpected error occurred, please click <asp:HyperLink ID="HomeHyperLink" runat="server" NavigateUrl="~/Search.aspx">here</asp:HyperLink>
            to return to the homepage.
        </p>
        <br />
        <br />
        <asp:Label ID="StackTrace" runat="server" CssClass="warning" />
</asp:Content>
