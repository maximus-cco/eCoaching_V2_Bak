<%@ page title="" language="vb" autoeventwireup="true" masterpagefile="~/Site4.Master" codebehind="MySurveyError.aspx.vb" inherits="eCoachingFixed.MySurveyError" %>
<asp:content id="Content1" contentplaceholderid="head" runat="server">
</asp:content>
<asp:content id="Content2" contentplaceholderid="ContentPlaceHolder1" runat="server">
    <div class="errorMsg">
        <asp:Label ID="ErrorLabel" runat="server" Text="<%$ Resources:LocalizedText, ErrorMessage %>" CssClass="errorTitle"></asp:Label>
        <br />
        <br />
        <asp:Label ID="ErrorDetailLabel" runat="server" CssClass="errorDetail"></asp:Label> 
    </div> 
</asp:content>

<asp:content id="Content3" contentplaceholderid="ContentPlaceHolder2" runat="server">
</asp:content>

